Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D1241737E;
	Tue,  7 Jul 2026 13:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783430316; cv=fail; b=unSGTp2PNsK4pHagzxyms9JYz3MzdoO+vv09kNzbOT/5l1M5Qr57y9N1vEU1UTMo4rTuHWCUqvhlAzOsgzU9vHaS0w2qmlIHvBgnBfx7leGY15RnXRrPcY54mnvyAy4RgqoMMotpuX7lO3G1/sBXIcgOBiqda+wen1nbMLmhArA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783430316; c=relaxed/simple;
	bh=lxytljmdfj8Aw+rDbTcR9IOLX6jirPal8k0y/b7DS7E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RN2dbgxqIOJj21RphpUGoHOncma7gU9Iyovm1f90Vg+zBIV/xW5BbTfMKzAdEsiOQbSRcrqiI0pPpTZ8SZPTfcxPBoo03Iz718536HwMKHu0lxG8ryCKvqdOw/PsYRXAKNxGpIKy+gv3hJ1w2Oh/d3+DGKAzLABscOfP7Yx9RZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R0qR6Eq/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zCpvXvqj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R0qR6Eq/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zCpvXvqj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667CuECp712949;
	Tue, 7 Jul 2026 13:18:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lg32R/l2qL875cFv2bmwzzQjL1NGqbB9tC2fkt8Pvrk=; b=
	R0qR6Eq/0T6/Re98NlTm4zIXQUo4rf1CPXHFbAG+boMwrgUlZPx4WuoY8tZ6iDtw
	sBSmh3JTZeQeRvsc8DyqFah9MZE044mOICgWer2xe3+mWUEA+5Cjz1HC+HE0zTGO
	Tq+CxmQHxIepKiBodVfvzFrShybqQRy+2IWTUWivmFfX1SqrGzJDEbF59Xw30tW9
	GT8pNv+9fDGRLpQ0UsUpVxaO9icJxKHom91M+FeGOTg/lIAjRMtHXkRAdIl/wR6g
	YO0GRUriCgFtKza3bw1Y5JoiXMqrmkyjd952gQkdzqx+31OHQI6itKbrxJ1PGKgR
	5pNtN2slaOb62k9rc9j7bw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rs1dppe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 13:18:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 667DIBnE008880;
	Tue, 7 Jul 2026 13:18:26 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012036.outbound.protection.outlook.com [40.93.195.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmdqabn-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jul 2026 13:18:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHvQ8kzqtdunlDwb2kJ725aMvksOsU8m2cSRbUSYOsEm8ZcjwJu+mIAaW1JsrXBbV57n7M/ebpRI09c5CgoFV+s7WBGZgGv2P0nWB6oJUvFLs0ViBX6NO4b+Qia3IoRCyvnGEbftMRoz3ZlD351T+Df7be2hlZubodcEoxjSa1BrO9DJALFBTn3idhcR+UiVijENmpY96Lz6ctL92CD0XUmtEjJRvxIKJg9lnUoSjN9u6mTYaITEU2kyiNQfqEl7d+YKfWQkp4kmM0qt1WEOoHjIDzledGhCkfwSTzr/UZGXDGWF4C0Ve4vfkEPOh7rTVWWIW3iHpAfXwL6L4cJ+vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lg32R/l2qL875cFv2bmwzzQjL1NGqbB9tC2fkt8Pvrk=;
 b=W4xwRjvNbJhJAT9MQ9DX60P84n5r4RJab/2PhL/64w0I3ceulOwQs/PntCy+eW6N6IhupfWQpUT7SZ95AQOj7RWZ7PXBZRQZx+fgv4L3ygZPwarJRQzWysjLM7z29uqzn8Fji6DCLgJm4WMP9VrkGvpamFrAQMPb8+qTBeW3Mjcvk51fz6yDOtBZtXMI7o/xoenIqXcTIoameA7TwSQEVnSOn6aOb2GtCVas8cbVMPn+jyiVQCkho+YTW3K2ZGEGiB+K/rE6s0X/psDhFeqxD1iR3nlGh9iN0kfsvGc6LG08PIup1n2X4cvoS29jRSbiKQ3+G74tm7b7O8+sKnwm2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lg32R/l2qL875cFv2bmwzzQjL1NGqbB9tC2fkt8Pvrk=;
 b=zCpvXvqjGh3gROVnZ2dOLfP/AVEe/jSoUvimzBlG6OQ5mnuIUKuIgOQ7Nh+AzQySLdHvuGFaaTYYS02AnRbKunqzPpIn/ZEBm59Ke7/l0ddF7wuAd2RrMkj12RqKTd81zI/YIvbDPrlZZjbT7+lZjVu1I5y3KuOY1OCc56pzEQ4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB7359.namprd10.prod.outlook.com (2603:10b6:208:3fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 13:18:17 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%6]) with mapi id 15.21.0181.012; Tue, 7 Jul 2026
 13:18:17 +0000
Message-ID: <ba08a15b-e61b-453f-9331-adf17690d612@oracle.com>
Date: Tue, 7 Jul 2026 09:18:14 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 81/96] nfsd: check get_user() return when reading
 princhashlen
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        =?UTF-8?Q?Dominik_Wo=C5=BAniak?=
 <stalion@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
References: <8601edcd7c9bcc70e75f85a758f8818c57945d07.camel@decadent.org.uk>
 <20260706135124.draft-0004@kernel.org>
From: Chuck Lever <chuck.lever@oracle.com>
Content-Language: en-US
In-Reply-To: <20260706135124.draft-0004@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0039.namprd04.prod.outlook.com
 (2603:10b6:610:77::14) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|IA1PR10MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: ad4e3555-fdf7-42a5-12b6-08dedc2a344f
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 bMEEniqSd8yWr9BcRLKqu2Mo/LP6+s5qRCEdxXZN59ShNliqDf8XY+0TuRRGsI9UmljjqRbWahXVI7+uKAwceUc/ZUpk30H51ZL+CTLMT2/P3TEZOZwQ8g+6z3ENZdJwL0hGG/01NJzQE1rO24n+iyAx5L3qz1l+V84Blqt0rmAXy7nsXXwUTbHwi06IjeLs5/gskw6H40SWy+r4+fCuqF+J7mc63vno4IyZGHYH+RWD+P6vb5AXv/rF0jW429OFY53gIijsxg/oL9ti+rxaX6OertBJg8e+d9MRMxtCcm/9Xrk8Ce7CY4urCWAs/930+4VoNrw/z5ITwQruKZPgJhJudc/lMgqvfj1ZR4Y1fKo/ItWp66dKtzg6ZGCy1n+bdvlewJtmD+f3DwUSMMnoyHhAoyzPzkiIx3k7RNMNnGm2VwiX/Ht5QkvtM/yo1NeIxhRvXS1g4d1GeZWVaLmqf140J6NLCYMBPV6/T5+TFHJR2VApSjNG33MxaGnVkc+y/8SkkbHRyFs2385/v5QevEy7fJ/mxm6BnbUy98c0dTp247WWyHs6E+EmU4F7fMXLSLyE9vTyPkY0adwvCu4Tu7h8Ri6T9wFLk/msIqVWLvhF9qipG53xrdtGhPkbtbj1H1yHqNvL/R+8J0ZOoMBxdCd1ql97mZpnN9JyGiKKsAU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TnJ3eTVpVEtyUDJ0bm9BVkZRY0hkK1hONWZGcHY3aVA3ZGZVdGNxSFU5dHJx?=
 =?utf-8?B?LzNVT1drcWFkWHlhRDZ3bVVyaXQydkpLNTlYdEt1dlNDS1RNUmxiQ1NvNFI2?=
 =?utf-8?B?dmhXNXJvVWJseHMyajhsdVFLM3RlbDAwUUNVMUkxV0x1QnpCZzJvK0tNc2py?=
 =?utf-8?B?T3h2Q2FvdGFaR2dLN1daWXlzNUwwUi8rS204N1ZsZ2pMOXFoNm9YUVZoQkVG?=
 =?utf-8?B?VVh2U0tRMC9yTmlZWldYVFo0R2t2S1BvVFY5RW9zaXNqd1cxc1JXblNNYkhr?=
 =?utf-8?B?UlREMitsTVFLekd0dVMzL0I5dVl4MUpzMXpxNDF2ZjhTcHVUZDhJbWYzcWFl?=
 =?utf-8?B?ZE1IY2lFaWwxTXBFNTc1S2hjWkRhYlRhbW0rc3RyZXh2d21LdFNyRmtCSDBR?=
 =?utf-8?B?T3ZnVjYzNXZkcnVLK0FVWHJQM2NQOE1NNkxzMHo0VEFCdTVjNHZKK3JFZEdZ?=
 =?utf-8?B?aGdJUWp4Qmx4eFBCbXcvb0pZbDhxeENLSHUva3dPQ1pBU1FjblhIczNuS1pq?=
 =?utf-8?B?REs5K2RKVVZkWGdhZE1rZ2x5S0NCMGdJTnduZXY5ZXVyRkM4cEd5NU54amFC?=
 =?utf-8?B?bmNUMzlrTmg4emc4ODhETHkzYWJhOWVvekY1N1JrMEpGcVVuNDBJcU51NGxm?=
 =?utf-8?B?ZVNuTHZHZFdsSkRyOTFEWkVRaVNJdjdtT3REU1BzOGxra3h3YXZpMFZKRzdO?=
 =?utf-8?B?U2NiSlRvS0hmU1FPV1l0UHVCZy91TUVyMkdTYXNRSzBydnM1dGt3K2dnM1la?=
 =?utf-8?B?cnZMNXZ5aS9IYzVsejRQeFNJd080OFlveXFldEdnZU5sWituMlJPSE5MNzNP?=
 =?utf-8?B?UUpJWGY4RWo5aFNUSWNxeFFRZDdGb21ZUWJoNjhIaVMrdjg0WmRPU09nY3FM?=
 =?utf-8?B?QlBvN0tnbDZnQUhOb3FxS1dSMkIwVTdsaDgyUkE1Z2Z6cmJqQnZGd1JINnZX?=
 =?utf-8?B?SDRPbTRIZFM4OEtBSDQ1bGlOT2VCMzJDdEJhWkdFTnNsaXBWVlZIcEpZOFpY?=
 =?utf-8?B?SDdMMmx6R0xDOC9ZVkZTSmU5Rm5LSUNXa3IrcWtEUEZFNC85ZDBnNnVCTjRv?=
 =?utf-8?B?WkFCcDBXTEdWaytOQlRJWHMvMHJ4K1ovTFJjblRqT2UzeEthODdESmxvZHBL?=
 =?utf-8?B?eHlocStFNjh4dGJ1eEZUK00rcGVMNkJ5SEpjUWlkSmppeUdYYWM2VUFzdWhB?=
 =?utf-8?B?SDVNejRQZUZHb0JoR2FOMzVKZVB3U2pYMFdJZXJlS1lwVWNTT0RaM29xYzg5?=
 =?utf-8?B?d09YWDlUeW9mWkdrZGVQSFNJSmgzTTluSm1ucGgwNHV2Q0pETWpzckxtNlZs?=
 =?utf-8?B?ckt3TG9NZDB4N0czTHovTUZJY3pobElGSEFMOTZ2Y2tYWUlhNU9uaHFabm1O?=
 =?utf-8?B?OHlpSlJGa2hCZktkWHNWRlczelVCMEFnQURwZGJlVXMyV0FOVk1ET2wwRnIy?=
 =?utf-8?B?Z3NvL2MvaFB6YVhEVE5CeHRRMjlBRG1rdVJ6OXVxenpPRmxFRjZWWXBTaC9G?=
 =?utf-8?B?ZkE4MmNwNHlGdk9pb0hJajdSczlGQkFuRlkyUXFTOUF0SERRYWFEcU9wN04v?=
 =?utf-8?B?SnZYVjgwZU02dHhpV1k3LzVtN3cxU0FjdmF4dHRkQ3JNeXcwV2hETzNrS2k2?=
 =?utf-8?B?V0F0bmV3N2hGZmQyK3BCbmwwV2hGMm51K2NSWHptcWFBUUlORFlMbi84KzI3?=
 =?utf-8?B?d0FQanUxOTZkRy8zc0xhMTd6djdmMktxM1dQdHoveW1QeERDSjdSaXVFem5o?=
 =?utf-8?B?MlZuK3hDS2NIc1o3ZnpRc2Z6NnhLQklESTNvSmlteFd6QXl4dnRjQ3Q1ZFlY?=
 =?utf-8?B?ZG4rTmNoZUIvVjdjM09lYjJrSVlSVUIyTmw0M0FORDViYzZLZlczNVBOV1po?=
 =?utf-8?B?RFloTDViZmNDWkZ1WmR2cTUrVTJ5SG9lVWZOam5mSk5uWTFVV2JPVUNYSmhQ?=
 =?utf-8?B?aTM5UFVCSHk3a2tRRmlZNzJRbEt3QnptTVowd0lTY3BHS1lOTlVNOUp4cE1I?=
 =?utf-8?B?MVp3Q3FoSWdSQUlPQ0pYbG9sbmNPOGhiMmlieng4WUt4QTdkVWVxYTYyT2V1?=
 =?utf-8?B?RXF1cmp2V0VXQ2dSMlM4eUY4VDYra2dsaUI4V3dLUnlnQjB4WHVjK0N1KzJh?=
 =?utf-8?B?R0Z5dFluZ0l4NUN6RXpFa04zVzZyNU1JaVlhUGh5b0NDdE05RmNmVEFoV01K?=
 =?utf-8?B?UENBcTFPMHBlclkwRDNXNTJIdFBWbVNzS21EOEIrTmlxK3ptWTl6QjBtWkFn?=
 =?utf-8?B?VkJQNXYyR0kvSnM3WUhSOGs5cVk5d2dQRVpVQ3JPWElFQzRqUDM3ai9zMnZx?=
 =?utf-8?B?TEhPVzdsM1JxcWdOQTFTUlROZzduUXZramdzdkVDZnpidjJxY2tqUT09?=
X-Exchange-RoutingPolicyChecked:
	Zp+niIqa0aRzHWfu2Cal1/mxFGx02vCFhdN8nv3qshX/7HUJliAh3/WyLqdWGAfJWoR7pGQbeppwJEOIozgoDyZZnqd7r6ehls9jB2fySyhDcXBwFJ4/VxMaopMeOfDvQdGH+1x82p+ux6DUWn39QUToc1YXyUnkC/Xy947aVToKGDcNZIYFSsbdmEdJEEU6lOU/Ll57DBvIIun/5+4YfhjW2bR2ErhMTEpv/c5jTlh5JBKOzRetzH4BdsBRTpLpSdeeNmkHhav8fQLGw26/BKYtY2MCH5gzf25DAGZwcW2PHWUxXvZU8qO0q3ZyiN4ZXssAJf+QKbXLAJH/19LZ8g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/M1LK/8DNIy8eVmurK9p9tiwRa3hYs6Hq+lOAPxIjHx5Jwa4Ajw1SIeVBBdOfDZIq+CGbGvUBWKRkm2PFDHDwt11hGaihfncaxIaiNMPAue78AoDaDWdGQ0OZqlRdkB2CTPIni016qtXmgi692ZSeWVVCM91VO5w29NsqKtHluiHWR46gu7f0U2a7vMB0EXYMD0HFNKLehd8+DR/Pp3OL3QST5+Ahl5oGiXBka3+IcclKKnjCqYNjcpiGFQ61RJYzG7kfud+OH4KvTU9PPXhMTcEuv1OnzrTmo/E65s+wiASenbC4wahP8dWPeKjXDUmCmU13Y/xId7cL5tZ6Bs51kiK8q6PwNEKX93c+EnfRJhpPcPIc0OjM+mja42ogcs+tjutfo8XTzfPx/yuvpo/LsDlLZS0H9H1J3dou7n6YkG+CfWC6QNU+O27UHvNvPnk3kWRS8QcQ6GJhpJdjionc/JT2o6ke+NF8QC2EZGlFdWlSnl2hs6YieM4WNrKR3d9C6r7Vm22T07brMBS9EaUpytwTSJQz/pEAptf0gvxjtKAblM1RBBwY7vCRsZ1lDgjm0X34sQtZRdl+6PNgRjtFoJp4uzCPdH78a9npBSQQpI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4e3555-fdf7-42a5-12b6-08dedc2a344f
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 13:18:16.9239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRNYWKU+O7EGrzDZEe+wxyaQbbgbcwrVHLJzZdIwE7hi2jhP6LQ8J0ICbTVgpi9eBknXFJujPmYyAB//hH547g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_03,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607070130
X-Proofpoint-ORIG-GUID: v_F99zxU8sSN5mr82OjqZWKUTzE4ngVQ
X-Proofpoint-GUID: v_F99zxU8sSN5mr82OjqZWKUTzE4ngVQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDEyOSBTYWx0ZWRfX1jLPeXh5wenF
 bZQsdFZxzR9fK26JZgbnJcDZTrz69HR0/dSZhZQIpDhISfUC97eefOmkbQUVtFwCTLhFEXeb7Cx
 5W8oN9bvrbCH42AzWw9X947dgBaPtIzdN1ER8i3QyJc6C3SAptX8QDCNMYKuG2mxNHxDQ0i49dI
 2D8SViTpJ5+zP8xjAvqJlPHhOKqAhil8ZJlW1Rxlme5DzUQwOFHOq3bMs+esEBESjtWcEDmLHn5
 PTzhq2pHG6F45JQqR1aFn3NvqkoticcsQaqwYMuRQmMSJdlW7aZxfSNokEGC0WGqAJAYA5j2VYW
 zdzeemStDAVr7zvXzDWUHfXE08St9Sx9B1vrsLPNMNkTbLH8xBGUP9lLoyL/u2k3FOOI1WPg45g
 f8PKF9Mb6mEsOlHgxNnLN7g0hFpevJNAAkgKBBrxmETXlteQvYwBCipVz70DLFj5eYmig+f9qwS
 WI6eTTfnxX023W55TOw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDEyOSBTYWx0ZWRfX0fHiaYk3P76c
 DvQVrBakJ7CtokR8VnRIiVefQ50Ha6HwyqH4Ku4txByP+njIFlswnY/glDRnkru8wxNDFJYBhOg
 FTYvkWvXfPm71/Fr7VR4HVhAatiE2oYEiNYPjLNT5pPC5H+Eb4Bg
X-Authority-Analysis: v=2.4 cv=Vu0Txe2n c=1 sm=1 tr=0 ts=6a4cfca2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=kuHZnEiJILy5avvf2NUA:9
 a=QEXdDO2ut3YA:10

On 7/6/26 10:08 AM, Sasha Levin wrote:
>> I think this depends on commit 4552f4e3f2c9 "nfsd: change
>> nfs4_client_to_reclaim() to allocate data" which went into 6.19.  In
>> older stable branches this failure path appears to leak name.data.
> 
> You're right - the new early return leaks name.data on every branch
> lacking 4552f4e3f2c9, and the patch shipped in this round of releases
> on all six branches.
> 
> Could someone please send a tested backport of 4552f4e3f2c9 to all relevant
> trees?

Not wanting to duplicate effort, is that "someone" me ?


-- 
Chuck Lever
