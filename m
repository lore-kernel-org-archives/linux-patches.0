Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C0B3D952D
	for <patches@lists.linux.dev>; Sun, 20 Sep 2026 06:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789885540; cv=fail; b=fNpkmsGmFaHMVF2En4qrD1ba76YOnnhlQf6VN+x4Nj+wYCiqm7JTbO5GzDk65fq3wkiYbKNjSOOMVW9rHz8KRPokbzOuUcrDEHrcRsFp3zKWexxyUIfBFTW0ATqj7pUxoO+AuXJIiRXcd9GW97/xuLfiw7U+BmC/+TdFNMbyIZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789885540; c=relaxed/simple;
	bh=OG2BqAFEYXJSAt7/eMw4br+1FCPdyzFawYdLOMdLB5Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lE9ACzWZ/QTNF3Zh0dM18ayGJIt8USGQiMJi/5zyYvnO7tOi3OMHU8mpAzqBLksTNAwXDFrGnwHL3mC2e8ouDHB+1ekAfdshwMTzcSObraCLoVK4s7aNv4dRbKHVW5w71oz6Z8x3101u6f+lDZ0DE3pyS0YlkCXktL0mKyiMSIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CAI4ECxq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hWV4vD4O; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CAI4ECxq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hWV4vD4O"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68K5Wg5D2589131;
	Sun, 20 Sep 2026 06:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=13qoxZG06HMIuZBAnmJi48zpmfAFYMXJQEYtqBN90xc=; b=
	CAI4ECxqgdKf7OuepdeWxHvIJUGDcZ7iplI5tSaH6cOlRUxagKsflqR6TfwpZeUl
	Eisz7gCLJzvrxcvwB0ngbX5wbqtfHJCeCP3dn+IcqNVj+WKc3gFeTV2Vr+tGwedU
	Ny5f7YV6MC4QnWAUI3GSFqKWqTeykJMmiV9sJuHCNEGjFTPGD9HRpQN1vyfvNPu4
	bjOMufOKAfB82nV8HhLDynElopkjadcBhge35nRrWOgytcCw07aKj9vkTakLPlIJ
	TQW3RT/+tVKygm+hpOBtM+hUz6ZZ+GtdbLGy6tRWN/npPkjww88VFayDxxBtzL/S
	8+Q0DtC/1c3DYov+tCJBIw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk210xvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Sep 2026 06:25:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68K6PMmH019674;
	Sun, 20 Sep 2026 06:25:26 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011004.outbound.protection.outlook.com [52.101.52.4])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgun4w85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 20 Sep 2026 06:25:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TSkPTP+UArzKRHQJq7ANrhDacMe4OxEapyDhyjIisuYj8ltE/a9OSvmsCmw6o3maYOmGy4ROFQlk12tD0hxF82jyR60+N0R9QzCuFJ1yDQaEFfojNNqiiIGtQlu751GG30lMy3ktjnpSdn2pY7kbsW5HFdjabRAfQ9rBxFvZt14B+v18EMlWwvkCv7WGC08VmAul8ZcmwCGTsoYAk0NSyZeFUmCJiSxcAu0xscDOFpwCR2C0O0sWoPqAL4oIo1Sbf/uqFdsjqYgYz9dYmIwtD3RelNYrqiDXVpvM9ACqUvPAj7vP/h+elBr6ksNNz1rH9uSYEznLMuBXcQbRnaMTTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13qoxZG06HMIuZBAnmJi48zpmfAFYMXJQEYtqBN90xc=;
 b=H5080Jnqs0wphgXfjOhqRUPq4+hfym9UPLjVKnYwnGsCBh16+VV4h3psbE4cypH4waWnnissq10NZLZPXxkwcsr1Vt1mE6fJe+9u9z8LMSiuuz4qa8ZTHtGD24alGb4m7VOak+6SiKm2caEOMtTcP8HAU0j60BKrz8pi11NLHak2YTySk1VBK0mTzuSov6QfkqqLTUGsKv7VLZTsMmjQDfimpcP0Q7YtuonNJLm1ddgfh3K1F7ziFQ6Mdi4Uq/q1IQGtb4BUj8IEb9qDUjssPrMUaJB6xSBrO21/DdrWXhUdjxr7tCrAwiiq//QXEc/8PuJWKUUWW+Z5cb6i/W3znw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13qoxZG06HMIuZBAnmJi48zpmfAFYMXJQEYtqBN90xc=;
 b=hWV4vD4OQ/DyskfA4wPUsEEuPI1EfCbb+o4Cpa7SNyu4RB4oildsJrTY+fOmrLlXtVhKiAMSlWhI0cwNDh5IgeEy/Vu1ncs7ORxy73wpejYBVdrdrP0a7QaJhIzO/zNAPJS6aM9X5Czs8Szq8F3DvRrhUxovbkBtQJ8InbpvSow=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS4PPF085C55EC8.namprd10.prod.outlook.com (2603:10b6:f:fc00::d06) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Sun, 20 Sep
 2026 06:25:21 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sun, 20 Sep 2026
 06:25:21 +0000
Message-ID: <4eab219e-4d04-4bcb-92bb-a3dc7eb37cc5@oracle.com>
Date: Sun, 20 Sep 2026 11:55:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0303/1102] ipv6: Honor oif when choosing nexthop for
 locally generated traffic
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151547.226407448@linuxfoundation.org>
 <8ba23b23-e7f7-44fd-8238-1df3756e0c28@oracle.com>
 <20260920000825.6-1-sashal@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260920000825.6-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0116.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::31) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS4PPF085C55EC8:EE_
X-MS-Office365-Filtering-Correlation-Id: 72d34028-d6be-41af-6ac1-08df16dff245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|56012099006|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	YyakUDcxad6Ap2O4UCrBEXm0VVdmBMybBOyho+6qzHGqa/arpNKcRIx6MlwAZkL5K10UDiHt/69D6oc8TnhugRfyRGPC59BMIDP1DFhJ3XGUG9gTXSsP2LKQRL5ljdgyDmjm9ioBNL3dlJje1XgXPxYNCLYmRfyfBvNu/FGK08ixEJVDNqcc5MQ91LhfPJN6Lp1JLb9rrBEOW2CtZhkDjC+Szo0Uh6pA3/FwsndYqMEOLX1rETLEzRyjETrZ69rQ9J5SeXOWRo0zD3SCjbUroVeZEXPfo/GMWqK3Eh1trj86bJ0/IHAMn/V3jSebAhnYk31+VWDHtOngubpxSg/+Uh8mwcnXSahQsOOaJ4gGDAF1Ot5vmz+w1oAjqSyMHmcMZm/Dkei+LeA7GXm002N2Vs8mYve3IR2Uh+eakfuYL3Q8aWZFlOlbKznM1XkzrOyH8x4EAF6OcgT2ZxypfVNM1cpNxqRJgjPtTkpe1FRpuze80xoIUuNW1Hv5aCO33GXi1YumfXBPo5FOamdWQ06CI2aH1pON2Soxtq9QI5ihCvU662IbdTf6DywEkldxhuPMBNJgEbP0Zgb6FqcJ7VvhAayylhrqDVTt+VHDblkysENQ7l/RDBqY42oTvem1Z7KiFINOSkK7zHhGHVpS12yrGEZ7ifh8Z/9IzfHvRDfFAvo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(56012099006)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1NqY01POUR6WDVLYXV5RjF2SEtqNFRWNW1uNllDeGNQeVJtRlNaL0o3RUZL?=
 =?utf-8?B?V2d2YVhoaFhYTVV5N3o2MXdYK3FoZWp6L2FYSCtGRFVDVjZETElMcDlycTZG?=
 =?utf-8?B?RGd0OXhJUlV0S2NGNFo3Q3UzZ0ZiWjllSUlLREo4WkdGWXVNZUdzekxGbGJM?=
 =?utf-8?B?dHUrOW9sWmhRbTlLUUt0bngzcG8rbmw5cCtQS2NKck9pSnREOThiY3BOYXBP?=
 =?utf-8?B?alhzN1RZWm5kUW9FNEowbUpoSmlGb2FTQlZNcE1ad3pLZUh0aFVhT05TQXhZ?=
 =?utf-8?B?Z0dtK0Y1VVVwZXJMbHVpUlRyWGluTGhXWjNmQnBueUxUWk1EUEtKbzBZRzdl?=
 =?utf-8?B?QUU4U2xRclVLVFBLa25JQWVBRHQySjJyWTEwRDEvZDN4TzFoUC9wVFdpQ3NU?=
 =?utf-8?B?enIrLzZ6SjJML1ROam90TmtCaGdsbUphcmpOMisxQXhjdjFpZlFMWkJKTWdL?=
 =?utf-8?B?SUtlazhwTFBwSmp6TXFrNmxseEhwYUlCd2VFZWxOZjhnM0VDN2JFdlorS21p?=
 =?utf-8?B?Y2JXN3F6Mm10VmhaUk1XRGdGU0hrK0FoZG1mNzZVMUFnTnlHNm5Ob3piOEUr?=
 =?utf-8?B?a3ZDQXVtQk53VXJsWVRvN3ZzSmRneGNWeFk5NXlLb25qbU1ZeFR3T0gvL2dK?=
 =?utf-8?B?ZHR1YjY4RXpkck9yTlYxcjRNQWZqMUd6TUNzVitWN2VTKzFYaVhhNzVLUG5N?=
 =?utf-8?B?ckVWdEFpRmJyK1FCYzZGLzVrcXB5YUpPdVFKcXlZS3VTMzgvWmNnRFZGc0Jq?=
 =?utf-8?B?YnM3dlRWcDAvUUwyMlZDczY5ZWp6UEJwZjBZK0lKQmNtVTdidTdnS1BTZUpk?=
 =?utf-8?B?ajZGSHdsNE56NUFSZ2pDUVRMS2NIRjVuYzc3SU1tUnhscmI5YXh3OWlGZElC?=
 =?utf-8?B?eUoxSE9uWVlWQXdaMkhHbUxVZnIwbTlwZ1VlTllVWUxVbjRURWUvMlc5V2FB?=
 =?utf-8?B?TlAydFFadENIOTdKMzRLVE9KNUIvRnU0UUZrVXVaQm4wb0RkNVY2YU5JN2lp?=
 =?utf-8?B?NGl3b0ZTOXl0NVpRT01UTkF0M2Z2NFhzWm1uVWdPV0ZRK0NZbjhSc3V1TVZp?=
 =?utf-8?B?Y2hVVjQyNEh2VWw0K1YvZkc0aElzN0RjdFRVRW16QlRWNWZqZ1dMa0ZKNnNH?=
 =?utf-8?B?Mnp5ZE8vSmt1aXZSQnI2MGxLcnVqV1ByR3hYRWV6bXRQTkc5SVMyVDV1aG5X?=
 =?utf-8?B?akczdTloRzZxekdhT2piZkpMQ05KbjZyWTdvZ0VnVWJEQzlMN2wvWWpvaThW?=
 =?utf-8?B?ZUpNaitocktId05PQnVXZ3NUdzlFUXdIcTYvZnIrZXFYZURuUkRyN3UzMFpT?=
 =?utf-8?B?U0lGQVIyZHN4cDFrWERmN2RraFBzUjRXRFJmUlowOWhDYUh4VEdIZ1FQd29R?=
 =?utf-8?B?bXMzUXZOaTl4d1FkRWpIUDR5OGJZVlp1NFp0em84eGMvYTU1aE5KMVNjMkpZ?=
 =?utf-8?B?d2h5UW9mZFRMdzBHY3Q3dkdwU0JmVGM3RzNEYmh4dlNEYnV0SHBrZ2U2cWNK?=
 =?utf-8?B?MWVoNTk1cU9TenQ5TXJUbU5HTStudzExcTM0WGsybkdwaWR1SUltMUNaRExo?=
 =?utf-8?B?MDNwMUtyR3dLb0RJbEEycG9Dc1FzN0w1N09HL2xMVkErcjZJS1Fhd2JRa0J2?=
 =?utf-8?B?K3lON08wa3FDVFMvZCt5Z3BSTTVqUE41Q0xiY1p0NTJzTjlVSjYwWCtqOVor?=
 =?utf-8?B?bkpJS1dRd1Y4c3U0ODJ1VjhwTk5ZeWV6Wkh6YU9VSG16YmVhdGI2TFdiM1dm?=
 =?utf-8?B?UklDZFhHSlRKRTY3RldIK2N1VHhVRHFPYUJEWHExU0JQSG9nNnN5QmJDUU5v?=
 =?utf-8?B?SFhvbWpWTVRuTEFkYjFBZkdsb0cra1RDb0xjOGlleDJhLzBxWlBjVjAwMTdU?=
 =?utf-8?B?aysrSzhWclpDaVF0UUV3NkNlbzNDbVowb2dlRjdVMEEzVHF2UXhEZWN4Zng4?=
 =?utf-8?B?VkZ4UmNkVkVpQnFvUXpnNDg1eDIwckdKMVV4QjZTN3o0SVJ3azNxWXNEWHRw?=
 =?utf-8?B?OUY3VXZLUmdYM3pibXFZc3FQdTQraE1LTmMxQnREL3ZjWGhJUXBQTWF4VXlU?=
 =?utf-8?B?SDJoVFg2UjNyTSt2eWVGcGdEKzBpbHpoQmhiUFBXVzZuSGxVY0NsK2pvSHJn?=
 =?utf-8?B?QmRRYkNEdTZYTTEzK2VCQWxnV3ZSdU5jbngvL3A1Y2RNN3o0SE0xWHVPNkUy?=
 =?utf-8?B?aG4xanhYbEo3RUh3bFFvSmFLbFRKd0tNWE5wRmxCRHdwK2RnNXhqZjRtb3Fx?=
 =?utf-8?B?VGxXa3pvNndFU3BDRFZaY3R5UEF0VGRPd25PaUNXbVdoVldIYklaeDBMRDJm?=
 =?utf-8?B?U1c3OHVrdW5pV01jenU2WFkwS3FDR3I5RGJBUVBWSzBlckxtUlJsMnlDMlRz?=
 =?utf-8?Q?yQbtyJzecigNMpl5nOtn7jLdEJeMZQ1nXHrk7?=
X-Exchange-RoutingPolicyChecked:
	MuuCYujoysSMtA8qcMo3bGKAfwM9Vnsfv+c/rCczDrQuZyljp16+y//GBF8KBAm9K59bQ45p60xwSbgE/l3WgQu4eoGyBaphNS/GX14ti9XUrNSSNXOkrLAO54npDaiqak3lk1Za07aX0U/j00T7S5LpStzisun20XitwOMawIASq8EuoaYFd1BcBqysF2kDwmRkBOclw2yz73GVfJ1DcwEGw9COpNJJbVPgKveO1rwmOsYDa9Glx+uHOPaTEAiKCIGyG6HWC2UH/TBxVhheCAqc+gEtggoEpdP3hx7VOzfYwYWXxE5BeLLzh0fOoZnt5D5SEXLcJYPJUH1nnqMCWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rbkTJ8JqDuzdXwKqFky4+1V56I1EsRri3R+2LITucsYhVL3VJfCn6XO0I4YbM++om0HhUBaWx7RNk0J54r4FHYZxDF2KdLxrpfJMWJEOBMQLIG9XRUAFtTMfnt6q0a5cSZqMWeZYF3JNDLpN+og7ncNQzOhz5zLdKwRgnC9+k198FJGltNSIwERvURqbJcWfb+ewi14RMRNccmycq38ude5CPlSGTG74LxDrjNVb/R5OLDttaVRznoucF51LoqJfyoBAmYdyVOvCHrMQTxP0cRFSDXq0ZdmAfM9rPnaiDpopdGSfVoasnRu6j6MCtHcisBaNY6wJUHE7AZKjHxL1Jrt3b4qYAWhDA/5/JWIevIZKJBTtGiMi6fVr8IuWnHHJ9YC7fq+RJRn2ReSAqA+CEnoFCygzuGE45rES3Edy1PcK5o/3kC/6h9qrLsfPQbh17BW1FlA44cJQmfJXryCh3u871HulFzGbmrzgCS4/f7vqYUI/gmY1bVX/wF09ra3FqH1cot2orhE4/nOW698PYU9Eb28ageClDV5AuLBoLqlpjoZ2Pj3GiNrVJ1+7DByK952uDPHrOYpxd32fOzzPwFMCk0/W0x1JG5ayqeX6+/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d34028-d6be-41af-6ac1-08df16dff245
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 06:25:21.1406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ao4MA7FqWnqms35LjKD5vOyyvRx7N1LZszMuJ0quVlIN03K7ARN3qFYHDa7NFmb4jf84zTzoBUlcjSYsAHgUgpekcI+G1RR5E5301AeXXdAbvBTBeUrdiC8WlnUwLlbC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF085C55EC8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609200090
X-Authority-Analysis: v=2.4 cv=APP6TA4N c=1 sm=1 tr=0 ts=6aaf7c57 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=MBnZnZMs_xvSSlSGsRAA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13532
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDA4OSBTYWx0ZWRfX38Dh9NW1AXq7
 jbkQvT6YxJUizbebGKhyyX4OPeLUYi1DJX/YNV3JYOV8lsZP6U3Oop2f+DLr6Lg+J+9eO2INzyv
 TXXXN7G00UPbg9bX6GanAGk8eP6I1fIHwD/3Th1Y1djiKPN09r8Q
X-Proofpoint-ORIG-GUID: 7JQyblVwLR1jtQSGbzR8n6RO0ZbH6bon
X-Proofpoint-GUID: 7JQyblVwLR1jtQSGbzR8n6RO0ZbH6bon
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDA4OSBTYWx0ZWRfXxj0QQEXqQSqW
 LW4KgXf9Js3TVFBvremc/bg8wxenrJ4aZ8Uc4NDFqtCIGeG5v1T/hQ2KqizbqtyyHHaSvpFWb/a
 aZcFHYNyQ2+uXj2l6ZjvxxcbrVzm4zRFJPBf48qizkpHSTuuX1OxniWnyFuJ5VkQo3bernw9nP+
 HudftU0wCuD1WFeu8KYXkAyycNlMDzRn3XHWKmZ0Dva/WS9M5sqcOiPqDo02KTZg0P7q7BOrvCw
 aymZ3S8C2FBFlVSO9SGH0N55Bu0L3Z9hFA4N5qpdYpDFf834aQeLgTjRUlFG6HroYKFMRCQ9e10
 dNvDcWQ+1xSW0RG7O7dE5kypMh9eVDmnJXkHmDsdzmNWcvrZu1vgs+T7UW0hM0bDNoJ4GRq6fcL
 E094Sz3czrB5AnNKJH0B7lktKX8N7Wz+FPoGIog972sxjB42IcrI8DBUCfuvOC9yg4+KPTUt5Wr
 HhiifKsKRvb9LONCTpI5HszDeA5SZDuCEh3LTO/o=

Hi Sasha,

On 20/09/26 6:17 am, Sasha Levin wrote:
> On Fri, Sep 19, 2026 at 07:47:55PM +0530, Harshit Mogalapalli wrote:
>> That commit makes the nexthop-object walker inspect every group member
>> and retain the best match.  In 6.12.y, rt6_nh_find_match() returns the
>> first improvement, which stops the walk.
> [...]
>> I think 6.12.y should take 484bb9d164df before retaining
>> 436d8d6c4487, thoughts?
> 
> Dropped from the 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10 queues. I'll requeue
> it as the full two-patch series with 484bb9d164df in front.
> 

thanks for dealing with all the reports for 6.12.y.

Regards,
Harshit
