Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7D342524;
	Sat, 19 Sep 2026 14:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789828000; cv=fail; b=gUyaVBKp9JgP5sEZ/cILlZJzlKxe5ngqR87x6ZwaxyiU5InMKz/X6dZKSc52Ffa8bycGXO2i4Deo4aZr0dixrc9Lr3qy4mlciOvb1XyN/VGoFwVY/ueJbBtdZ93TXDfPp6zTF0UJUFF9Nvd5tDdXGK+ab78tMim8Ffk7rLHxFc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789828000; c=relaxed/simple;
	bh=7wdQn16+oIIyL+6Ktq+WkvjKwXGLiesFWNS/iiNpdYU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fuJwLco1xo+2OUU6lgEwgcOXpNacpX9ub9SoMeCIi5Z4r60BeMZct2B1WLUtmyGCs5322zpgrrqpjMWAS0syPx45lC4ssy+omaFdwCupPGNN734jWuJyI/sDIEsdOxF7dbN1Hc++jzQQ+r+y0cvLBeDhuDy3Mg/yCrnXPoke510=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ct6CXVYf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NaxiQstg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ct6CXVYf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NaxiQstg"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68JDjTpk1142716;
	Sat, 19 Sep 2026 14:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=znf/wFpAEgUFdGvov9g4wCEzuEDjzcP1vH6GIKVN6MM=; b=
	ct6CXVYfStvHB1UrzzrD9xwGS0FSgvAp7uNAf0Z9qzLU06MCx0I1yHllJz+WYJFX
	GLsVp4Jl3IW8rYLPSQwfQwouTWt22p/iGvQLc1MVu1Xxx/p80ZpLJNEFJLWlyBBQ
	MNqGNJfcqJ3n3V9trM/wcpKvVmEMhr/dRXJwjzpT2JV8IMSQ/HMEWLTmJNX7+mrX
	mFL6Zj+SN4hPKZRfHt11IXecGUwWB3T6kj2T6nhOM7S1hoaGcJJdWKVsqHssqSS6
	y4Agdawcb3svl0/rpCpR0KEJbXpcXSEo9aPD/wkamky0Z1ICt5tEDHTlgZnzdKRd
	jlIxJBvcStz1ZuvAzu5wgA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk0xg78p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 14:26:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68JEPYEx005122;
	Sat, 19 Sep 2026 14:26:32 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgumx704-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 19 Sep 2026 14:26:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0Ias+kYL3vw5VVrE2lVSzDrBa7YE4eQrPM2jfgxmTrn7kVNdPmOytM0qZsI+0iO9QsKyNo1quG/cDtoqfSixYVKO3F5d/uN3lTrMGmVHsDhupx8Tr/BK25wsDAuk6FIsRM0gSUwFdDRLloO/ZZ76jTx2+Phccr21Omf270C6SnmHjwcC0Y43pk2nGFbTRQF3lbTj+cADq3ViRE8/gP6aVfsw8DpLj6WwiOc16YC0Qzfb+BHNWKoIX9tTG3nSfRvkz3JLM/UWKfqAyr9qTk/JPYUphDi2PyDD8u4RhEord3C2JIyZ0ylMb4l7L4qCtM7mbu3aIjfnWhLN0V25bch0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znf/wFpAEgUFdGvov9g4wCEzuEDjzcP1vH6GIKVN6MM=;
 b=DyE3P8gsA8HbfXtcZKicUvkwi5s3mGvJ87AV5WPt6+tXT6eHFcLnMsKkJVwqIKvfbDqraotZ2+IBm9/dLsEziTRMkXW6AlF+8Mixp2DGVIDy0QZBQNEd7LXRO4UWinzVaIBtpSK982MOEqh06Wlab2xoapUD/P1Cl5TgYbB82mhLE2hqjkRIa26TMnIrQiSY48J0X+ZMADgCZFu3foGVQGEADC+YhBLXLQmJ9s+UygndmTyizBhojSG+7T5yh9ofhENEIPJuEy7agNadNSH6TrG7AFcn9tiLlCqJwSPRlhTtiaUJSScIffFzvN/B4aYg/j4l/ZJ/bZ5HzjvDu7vFvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znf/wFpAEgUFdGvov9g4wCEzuEDjzcP1vH6GIKVN6MM=;
 b=NaxiQstgkS2Lu2yymmgIrHAP2kXBHkKroyht/i4Ue2HoynMFKY5HED/VeP4DyZdJSWqqoVywWnbdeaLFfNXsOCt0ddbQTrlVhTtgIoqueBka0ileyjL20jy5P3kErS7P0FCvNjPRkZVmhaak6HeFu30ljMna04jLX9WojPp9nJY=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SN7PR10MB6665.namprd10.prod.outlook.com (2603:10b6:806:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Sat, 19 Sep
 2026 14:26:27 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sat, 19 Sep 2026
 14:26:27 +0000
Message-ID: <88102a69-41bd-4520-8819-668b99721a67@oracle.com>
Date: Sat, 19 Sep 2026 19:56:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0464/1102] Revert "ACPI: processor: Update cpuidle
 driver check in __acpi_processor_start()"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, "Rafael J. Wysocki"
 <rafael.j.wysocki@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org>
 <20260917151551.337920984@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260917151551.337920984@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0023.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1e::17) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SN7PR10MB6665:EE_
X-MS-Office365-Filtering-Correlation-Id: 793bca20-3e04-4fb1-9708-08df1659fd69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|18002099003|22082099003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	HxJuh7wx/kub6ze6BwVwIoPYg1qtYrnHzfAFyyxFQjCg2sr8qUNJKScy1HG6jzOgT39PFwpWhSBuRuc13bk4jMrsU+8f9T8nR7MUKlQH3SjXKC/rgzGoO3VDCbup1aKuBDiCzVYXLniI7U4M5XKdIPp0kSs7C+oAXcQduEtPL23EfZr+uUDnVQJtHWAYjAsdS1RlpIAZFAE2FhZkq1+Y5qEgo9rYe9OAAGgwdg4VNTjiXuXBnCjHh/NYX8t/MggK2LZll5fFqNW0lPM3s6TiYhrtDtdHhEIugZ7wzC9P8oC/KLJQakIMf6z4/HaiyhEU3qOTQcFqnPVbbeZjWY/QBiVzma6jzEuX0LQSmkQXib+Zfk1DaRELDbSVS8m1jr6+PT8CyYJyAqorFzvDKXA1fPZofCyUznQMjYBFbEgh/xfAFXYwjZ/h9MqX9jeJhXq2RU2gUa3ZaLqeJLJ3I9cIyPDD73vKfStJmNrbhaGB3+M6IeemWXqg1F0U8Q963k1q5eQlj9QlLeLJhQpE6R+RMGp2EzwIrSWk6/GE57MT+0CRBmWOo2nLr2HIGW633AMxcX8+sb3QSNYqbcWYvXdFeJfA4RIYn4sCwmVAYKblX2l3/76XLT1B3dgpBTboLk7Vlnb3GE4A3fQIkAHn/emuBZL0TnGRxIAH7RxllB3TiGs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGFlaEErcUYvYitpK1BjcWtYamV5SkRmaDI1Z0hwSUpzc3JxSnBFblQwa016?=
 =?utf-8?B?M3YyVi82bXVsMmlSNm5WRTlrMHVGelAyVWZ2OVhkR2REekRyL2p1bWlYODhN?=
 =?utf-8?B?VStwZ1VTb2ZCU3ZYeHBvQnlYSWtvNVZvc2NGVDUwSWZTcVkrTW5WeVNCU0I0?=
 =?utf-8?B?ZytXMkZxcStEbElVaVZtVFVPZFJyamJZMmZFbDJJOFBOY1hHVkwwWnMvSzl5?=
 =?utf-8?B?b1NTNVl4SVZWbnFhNGZlRjJPWFVkTDhRaHU0cTU2cUZsNU1qRWx3bDExWmN0?=
 =?utf-8?B?NDlhOXdvSGtBdVNPOUZyYTRTZjRVNXp4REh4WnlvVG13cUx4ZVNYQ2p5OTA5?=
 =?utf-8?B?YkQ0TktoNEY0elZXdXUyME12NnNscVNoRktDNnpHUWJIYU9pYzUrR3VVc3I0?=
 =?utf-8?B?OVdQM0tPOW5YTUlhVnZ0cHV3MHlZVFhDbHAvd0tMc1NVZEtETnI2TnFMWk8z?=
 =?utf-8?B?dVFWemFJSmJPUHUwN3QvMjEvRmszSmdHOUZMODJOOWVDbTA3RVdYaUtNSVZJ?=
 =?utf-8?B?R1pvakhXVENncytqQlQ2eUtyVWV3ejlvb1BENEtoZHNDSGpCTlF2dXhUMkRH?=
 =?utf-8?B?Zi9nU2s3YjhTbnpKL3habGFNOGgxczJtbjYzZFBSSnN4byt6bnFPWG5xbjV6?=
 =?utf-8?B?WUhmekN3LzZnbWk5YmJZYk8vNE1nSkg3OTdIcTBpZFBnNFJpTnJDY2VnNS91?=
 =?utf-8?B?ZmVFb0xyS1dFTkVkVFNtWm13U3V2djFTQ1JnYTBtbVBNVVB1Q0M2ZDhNRlpp?=
 =?utf-8?B?ajhnbGRheUNmd0tlejJYZHQra0lzcE95SDJCQkZZOW9xeno0MGswR1lNajhU?=
 =?utf-8?B?eXVKQmpNampIaEJBaWRRVlF1MTNjUEpmWk9GbXY4alJteHhNUC9pcDE4VUpq?=
 =?utf-8?B?YWpXUHdFTWJ2NzlyWVNLZlRFWmNkbTVNeWw4bURnZHcyUnZtVWVoSzVZZnRm?=
 =?utf-8?B?Mkw2NHQ1eWppODhqNXc1T051RnVLZVN3UERFS05oUGNDK0ZEazB4d2JXb3dW?=
 =?utf-8?B?T3FDOHN0SXY3SG80VXRudVhCanNVN1N1N2FEM1l2NG9tbnoyeDdzVEJxczBa?=
 =?utf-8?B?ZGdSeFNJNEUzdlNIL2pYVlF5cXhldGF1cVJqZnd2U2ZCWVZEZS80alRHUG1a?=
 =?utf-8?B?QUVGLzl1MU9qbENHOStoYndsTkpMc1pYZW9BK3grdGVqS1libVFFUDdWMll5?=
 =?utf-8?B?UGErZ3FYRUdsYWdVWWVrclpYdjlIc2hHcmhRRXdESERkbVR3SldHOVd6d3My?=
 =?utf-8?B?aTNlSStPTVJucnBldk5qV2d3VVNJQ1NYeUlWYmZhS3F6cGVqTkR3UlptdlJv?=
 =?utf-8?B?TERxT2hmYUZ3S2t6dU1BMHppSHhUcEtHWW1PRmRoTjdwWFdhbGUvWTNwRzV0?=
 =?utf-8?B?VCtWTDYvMVBrSEZiYUdrcjVGdks3NE4vT2xucjF0aGYwVDJ5ZFU2MWI2dUhR?=
 =?utf-8?B?RExVS2N6QU4yYUtyeDRhaGtwb1paQVRGaG55eUtiSTBJN0hSbVl1TXFwdHFh?=
 =?utf-8?B?ay9DTjlRSE0xbTdUbmZ4NjZsMFNmVVB0U2ZMRmNRcGhGeEhyNThubURJcERP?=
 =?utf-8?B?amtLVGlLWHhvenVxZXdYNFMvNkdtZUF2R3pyWUNtL0RUVEQwY3FjUGl2Rk85?=
 =?utf-8?B?aERhTCtLaVc0dkw5QmNZLzJMbXVVSExzQ3JVdFJNQkMzck9kcTVBd1VUZnk1?=
 =?utf-8?B?Wm5lZkVTT0pwNi9BQ1lQN2ZlZE1mVC9pOVYweEs5d2VvbUwyRVVrbFZRdjQ4?=
 =?utf-8?B?dnV2Rnp4U3MxVmczbjJOdXR3TTRaMk9wd1RuQ3FzT1ZTWkpTOE9ZU1FmTmhs?=
 =?utf-8?B?ZmVoUHpHSnpRTzk0QWQ4b1ViREJrL21rTURtWEd5eVJISHF1VFh4dHJodVFp?=
 =?utf-8?B?NWhoZ3YyZW1UcXc2TlVia2wvWmZMWXhWYnFqTU5XM0FqdUlTQnpZNGl6Smth?=
 =?utf-8?B?WFc1MVIxbTdPV1NFSEFvc2RHb0JQZXg2NjFndWpTdmQxOG56VHJ4bXMvWXBM?=
 =?utf-8?B?cGlzcGFqMFBUQzR0Z2ZTS1Q1djg3V2dORGplZHFBNUNDMGV3YU9qcVQzd0Y1?=
 =?utf-8?B?dGFwc0ZEUDg3MG9mYjBuSnRUblc0eHNnT3BZR1FLZDlpYjVMNmVhRTY1amhY?=
 =?utf-8?B?RE9pS0ZmT20xcmFDSFNuTDUwTy9XMUZVSUpxSGVxS1hqcmVsSGdobm9jbVlz?=
 =?utf-8?B?OER4UkpYN1laMmlRRjI4ZityOGFYRWZDVFR2QnJQRjAzM1RmUjRYa3p1dEJz?=
 =?utf-8?B?bTRtLytZaGFtK1VJZGhwZ0RXaGYwOU9VN0FaS3Fjb2Yza1ppajNZYWF6NmFj?=
 =?utf-8?B?RVdpSEFIemZSSE55L1MweFhIOTAxcUZlRVhQUkc2S0tuTlpUcHRDcEV2cGhk?=
 =?utf-8?Q?2BPNXh1xfTHJQa6A7YHUF0aCxmTlradtBATuO?=
X-Exchange-RoutingPolicyChecked:
	4stH5PXIDjfsm+7S2IawOXCeJBSaM4NxtATdw1sftoObaSjMreSSHQyOlkpeH7Az9rF7jIy/YxzxPvsIinaYpxCulLsAQ0vNkeP2BrbaSA2KeVzZb+Eoha3/PNIX4Y70MD1TD98EEFu62Mbc9UuOrxhNVPwNWDLYSCnN13osI0HAxPUO9KszNFtdqcTCo16mJi7x0NS405r+f/QyqwLU9yqPB9zrNmyjNrPcnFGYaRPvR114fNUpM9w4xkDcSMVjtvYBEemWoQl4LZFH0iG/hpK/PMV806QWV2LjRNKlN8ywsEnC41+GfvNNS1h+UxHhJdrpVfZlb/nbbmsl11G5GQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MU3nG0UbJhSM/8+5ba67OFNYBuZSksDE+YpyNrtW4LciEKy7LZdBy9FnXw9KXh0gFQ8BINtE9uQa16RvAfY7QO2/1YlgrqvZLp3s0LWpkUvdh/bRlVu6/3CPW6nNMIcpqFNIBwUg+W4eN6NJO3eJGG+spYmvCa7C19sZLsZmaoDIOKFJhsxSOOYsNFPwPWtcdezXkEPtqrvP0lWGc9mRwheo/gb8ndjj0/8kHj/LJ/8XCCftKuZHTzcDRUnwjyat8a/qPOoj9vQTsjrcL2hZj1vi469cnWVXEQo6XlUG7hJrsnU+jwjvrEaIWIf56unV1SWqTai5hV5PzcOfctZMFHHfiVcI2o9HnhO4RxN0s5D9+9rGZbMdM9A0TkYEwrpsVMK8RE0XoJl5tX3D/22RSdvFoNP8m3vjOtHcZu4iJLCBErnUy40IMoxO/FfrNx5PCFYYbG7BbfG4dHjRGdi0it6JvtzdGM6g49zMj9hCEOa7vh34fnjyjH6qSSgeb5KBVnkj56DlaOGoHojo3Y6X8ryV1B3OePjw6mbAypWWgKhK7YeKEsJVUXxgUWY5/9WFXBxYpvfd3ep8XDinvaiNNof4pQmD/Gtn4HGsPKjdqAs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793bca20-3e04-4fb1-9708-08df1659fd69
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2026 14:26:27.0405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frxiTx/6gGTz/gAj7bTyEbhWrJcslw4Vnc5waCvpcUc0LnVxSOjY1eOC/6fXAwlRP1N4LnVVdqB2q861Zx8B8m9yJe0ifr9v7O8WOgiwtstUVs1vDT2jdK2AtBtH19+o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6665
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609190209
X-Authority-Analysis: v=2.4 cv=F/bC5ahN c=1 sm=1 tr=0 ts=6aae9b98 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=QyXUC8HyAAAA:8
 a=VwQbUJbxAAAA:8 a=t0rcGIaaQQaehM2OMq0A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDIxMCBTYWx0ZWRfX/2ZP0ooFA3ph
 yWe3hSbOkRg4mzActW6TF3qrJRt5iWjsIwxa85RlZH6drQuu50w/wLOspGYcoQp8YYemZdPVvFm
 /PCGaf6j3nrr//gypeulEku3BoDA9Sc6UZS6YU5UDceQ6hqMvC5G
X-Proofpoint-ORIG-GUID: Gni6HK04EPndWMsUq9LOSw_xTn4XBztC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDIxMCBTYWx0ZWRfX7KXJcpC/Kzp/
 n66FKj42/HQCfyD2q5QzLVqwiIo0NI/w6k3QY2r9zLJvFQhANY4Om5icHHDOix1yPV4cP0uE8Lf
 dP1DSPrBkhHCTzmZe0/hsWoRcuh12htPnG18G/Z5oNk8uj1O5XUTgqUsDwuWDmwCfpMnJi0RI6+
 oriJhG9rGuQSXJkkidNdVhubP8YFKvAxOHQEY3tqvCrpbrpPgewciYlq/EJaC0i5J6nQh7QaJYj
 pfqYF97npTG0alV89xJN3slFSnWb1yugh1Xicq2CivFcFCOa3MVjzavjYbbHwMoSMGAlX89SHL5
 L1bemqNtn8cdjZ38a8T/clBmyD2X8fhidzW5dhv1NxqvHTnSxpp1r7MMdYubrH6St/yZYUGVJGk
 SxD39MHzg0294qo5WvFOIKn7KAPB6BGopD+/Vy7jiadPNjoMY4oCuViPG0IOTd7+1oOgbi72tA1
 xQOfpKER7Ss/GR8d2d5cyl5K3PwNZl0CuMBsp9Lc=
X-Proofpoint-GUID: Gni6HK04EPndWMsUq9LOSw_xTn4XBztC



On 17/09/26 8:36 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> [ Upstream commit fbf04215d9966da61feee3f4ec24dbf4544cfd0f ]
> 
> Revert commit 8a1b5d412cb4 ("ACPI: processor: Update cpuidle driver
> check in __acpi_processor_start()") which depends on commit
> 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle driver
> registration") that got reverted.
> 

^^^> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/acpi/processor_driver.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 2f5bfd00bfce8..d6d9c57dd555f 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -166,7 +166,7 @@ static int __acpi_processor_start(struct acpi_device *device)
>   	if (result && !IS_ENABLED(CONFIG_ACPI_CPU_FREQ_PSS))
>   		dev_dbg(&device->dev, "CPPC data invalid or not present\n");
>   
> -	if (cpuidle_get_driver() == &acpi_idle_driver)
> +	if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
>   		acpi_processor_power_init(pr);

Hi Greg/Sasha,

I checked the AI-assisted report for 5f5537db914c against the ACPI and
cpuidle call paths in 6.12.y.

Upstream has, after reverting the registration optimization:

if (pr->flags.power) {
         if (!acpi_processor_registered) {
                 acpi_processor_setup_cpuidle_states(pr);
                 retval = cpuidle_register_driver(&acpi_idle_driver);
                 if (retval)
                         return retval;
         }
         ...
         retval = cpuidle_register_device(dev);
}

6.12.y has:

if (pr->flags.power) {
         ...
         retval = cpuidle_register_device(dev);
}

The one-line revert matches upstream fbf04215d996, but upstream applied
it only after:

43ff36c4a5a574ee83b4b0d3f3d74f09a3a8c2d3
("Revert "ACPI: processor: idle: Optimize ACPI idle driver
registration"")

The destination lacks that prerequisite and still contains the
equivalent optimization as 7e6dc9f99870.  Consequently, the restored
no-driver branch can call acpi_processor_power_init() before a cpuidle
driver is registered.  cpuidle_register_device() then reaches code that
dereferences drv->owner without a NULL-driver check.

so maybe we should drop this ?

thanks,
Harshit

>   
>   	acpi_pss_perf_init(pr);

