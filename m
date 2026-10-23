Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792767209;
	b=1PRnGQwbmAoZRHaThvN9bw3FxYF/I+sB2jwBXzQn1GGqIvb8Eg2+mJFQQIzJmc3RrwfK
	 lGfsmm9rT+YafiveyD1/BtY5HS9YsvsM51q/BGknfjJbvA2BUqdmXR/OHtVwGt15twxTN
	 B3N7XmRU8qp2z/Qs8q72QWqhdJ4cxrbtb3HUuwDDZV7+i1u7kA5PK8/F+n1CR8alvXpmQ
	 ZW+K7sc8A8xnUfdhNHJZVqdXJxIgpiqs5wenVKO1XnkHOwUXR0sBgpgolSNWWLcPY0Lex
	 EUupKH0v+Tes9T23U7yOJSwgZBNpB+Fc0kmvAXeqlZq01fxSiuYNDAipeJh+42w+F0Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792767209;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=zvPVlXOw57SRZZv6klOTRquycm5Orik/xFqwS1xB3As=;
	b=NP3aHLN+PhvMRAG7iF207LKDWbmyVzQo0Daxte25p031Ee2F2XscJepFFzCHKN/Drk3A
	 Av+kUV+uZW+JUMedsYyxqe0THjvC3ic+o6uY0OOaC1u5o+bBOMTC0rXo4qcbp4hz2esy9
	 XicLnRrrvB01ndge2fVgOuWiYcv5l1K2hdtHaZA545/6W+vhMJt/Ee3CnDA6WOh4c6xmN
	 YSx48hrZxzBUTDqyelDNOhYDKNBvBtFZdLeawnPRyI/tdagnI+CWlH5FpluVX6bFGAjQV
	 MTI/IJqgAD+j3uJZ982BDFj7/H6OIKtoyJXbErIpvsexVEddgsjX1cdVleK3zDdO5zg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Q2hSA93g;
	arc=fail smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10699606A31D
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 14:53:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10699606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Q2hSA93g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792767209; x=1824303209;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PD4+TamDgVQ/UN5buSmPF66wEHBCPx0FOzucv+f37+Q=;
  b=Q2hSA93gWtMILEzZzY4Zpi2vbxh6ni9LmF9pqIsiwTPw3eit8S2SC88l
   AhmlJSn89RKjKEClOWkmPvNyppQ+quUdPJgVB/fXzhCNpNCOx0kxQtEnI
   BOFS/rkBC4usW4KzMMX85HIEAzWBpIJMnzGI0FgQ15emMxIxbHf6j+ggZ
   Ohmp9qC66gf9twPtYSd3csqFClArEK/QuSQ6XBmzbH82pC1+oJSy65Vmf
   7m7anTJw7GzZ2KJHeRXuYk/hdp/mKhj1hlpHkxKnIsQ5M5Sv/WqWMfV+o
   LDxBUjzt5VeCTEnYmc2WenGburfsGgRiMSfCEptwP1E1HJg3miwNu5/+n
   Q==;
X-CSE-ConnectionGUID: NVoympJXQO2JzJh7fsqiIw==
X-CSE-MsgGUID: ycaiDJ5xT0+IvKQ8I3+SEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1543612"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1543612"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 07:53:28 -0700
X-CSE-ConnectionGUID: c+boxB66TpGULScgXME6Bw==
X-CSE-MsgGUID: DsFjMY/mTSaTeigSPun/EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3548075"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 07:53:28 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 07:53:27 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 07:53:27 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.69) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 07:53:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AmmMtHkK5g684bM5lhgOByY8Ti3B0CLLHIo+Ybrtd8/aIt2osSsb5CRP7xoxlyOvucGlLeGJsLkm3hUFNRPaY0vUSE6A3dvXOlRLhLYslJy96UyrRSpHlbnlDkyz35lHBjrNx9jYytJfEBH+R4l2K/gPIngvl7GW0zN+dPeNT05ujgyApM6h3hk5/QaePbyhwdmUXU308ffqjqPGbWrXzEZfbVIZgNpfA1p7O5TOAg7MEvbvMT3MV8tGdidFXVUAz9OJgQzvnaxTr4gtnomu7/dvpYID8EALQ10DoRw8MwSOAeHdLmYQAhGYV2c254u/ca5oZCrCmNocrDvPvdFKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvPVlXOw57SRZZv6klOTRquycm5Orik/xFqwS1xB3As=;
 b=GGAP7FPqgxQHaBIUe2BRSKQX9QhqFV9CEyaacaJ4SjJJHlO61MJec/DOTMzDVHf9BRPi4OKqJwM91hbrCEkkx/Z+xM1FUdC8NwvJbb5KKGkt1da191q5JGaZc/tF5bqtv8Cx1mGcW1y4DBGmovKIyBrbKFn/BlTbDtkcpmDPY2w4Y0NAWe9zGvuq5SbY/dRFBAA1mubTynejxNrT4ZhsmwG/+qAOtgW/1Tn1tzDW8GpDU+OhFPz2L4LDK1tIYNHOdBQadKjr/nM3TLAI1jYVKKXnS+vx1o9fRZNECsrP4NfSD9cVEvDFfunMhznDwzo5Mf88cynjyBtu9b4hM7kj/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS7PR11MB6015.namprd11.prod.outlook.com (2603:10b6:8:74::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 14:53:19 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0546.016; Fri, 23 Oct 2026
 14:53:18 +0000
Message-ID: <6f867f7f-2c02-4770-8900-2996dfc9d37f@intel.com>
Date: Fri, 23 Oct 2026 07:53:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/10] arm_mpam: resctrl: Rename ctrl_comp in
 mpam_resctrl_alloc_domain()
To: Jinjie Ruan <ruanjinjie@huawei.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <adeb2b33540572b5da5edb79d2ddacc9fc098e01.1792443633.git.reinette.chatre@intel.com>
 <63de9d6d-96c9-401e-963e-0e3183ef5fd1@huawei.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <63de9d6d-96c9-401e-963e-0e3183ef5fd1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:303:b5::24) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS7PR11MB6015:EE_
X-MS-Office365-Filtering-Correlation-Id: d16ad01f-3725-4fed-88a8-08df31155ff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|261009223027099003|261021123027099003|261022105027099003|261021121427099003|10067099003|56012099006|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: ymHVYuSrLsChy6DIO2JnancfTtg+wcQdYCG8IuF4LGoGhiEhR4/y7oWasPthxCXmlC0nyAuBYgQAVokbj3Jj5iA3qfiIf/0adXzvyNvaVEYIxGJ0k1tu8vhL4Oq9Q1p0Cg6JK9NRi+AEB89v1lY2rxDVRUtbaO+oOVLPhuJDoKlU/ROfBat1CvuiUDGR2OotO9Jn6MfFVNj2N1vRhG0c2N4cnCBzpIukJuKd2j66i3QZEJLLdix69fdfDYtZpY3smrlsVjyASFWmbHZfeFfkJh80RSke4vxu1Cc/el2YAWLAN6ys/DoboGi25IHJzROTm8IQtCct9X7XO6rysAp9TtOn2eOlziLYeLvxID+1Fq42mFVZer5sigIZ7Fh5pNQPJa+JseIEFOrH+dwL7tAIzDyfK4MFLApXX1mXEdkalYnq8dYJb3m3DfCR6FGaJW5GaMTmvvDKUEinoCpo3x/PEaPmLNrPeAMgip8qGCm5/sdY4/WNWGlmq+FueUvSIkFFY+/dpLWWLAQ1HNmTpvHrUkZYyOPHwXiEgc7hesDuf/hJfRYi7IDdGi+c4KN9Dac1eI04qGFsme5ZBCWIcTppUaM4MWmcgGdGNyrL4UPd5QSfP/9/Md2509n7OfOb1zMfX5nI0I2w8fU0DJVqIMDE5eOcSmBRTOdVoxHRy6xM82o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(261009223027099003)(261021123027099003)(261022105027099003)(261021121427099003)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWk3eGQyNUhCTkNKRFRXQ3NyR3VoWjJ5cUhWOWh5ODN5dm1xWlFCSlJoKzFI?=
 =?utf-8?B?aVloRkxmaXlkdFcyUmY2TkhFZ2MvSU1zYjViRldRNFgrQm5iT0JUeVh1clhK?=
 =?utf-8?B?eFlNSUxic1lCdjd5L0hPRDNsSjBCY3JLazBEbDl0SGFpSkhHM3liWkVQN1ky?=
 =?utf-8?B?Mm9uV25DeUVTbGFOWW5kdVErTEJVdGp4RE1Ga0tDVXJ4ZXpad1gwWnNDanhN?=
 =?utf-8?B?SlRSd2o0WE8vYVpKR1prNDhtQVJ3UDBTeG93Q1RIdTErVXNVZXlTbm5lelh6?=
 =?utf-8?B?TlRrbWsxMEIrcU96ZWVMTWh3OHd5aUF2MkZjMW5NL0xuUVNQZ1VmT1lYa1R6?=
 =?utf-8?B?QmNRU1VGT09sZWpyQUdLOFhicllDbjBjWURyVjBmNG1XV0x4ZUlQaTEvSkwr?=
 =?utf-8?B?Rmh6NXd0VStWUGhVOGFYeVdqcTBDVG5SdVZtTDVpb3NuTytDbkVHdDZySkxW?=
 =?utf-8?B?YWluUG85c1htU2lWMDBCZ0VsN21MYUJwcm5rQlhQQiswejVUT05MbituZ3Q1?=
 =?utf-8?B?UkU5dENvU2wyV1gwMVNIL2J5MGd2dzFHQURPcURRU2liK3ZvQUNFaUZBRlNr?=
 =?utf-8?B?UlpNTkc4dkNtcE1BVFd0Y2hyWTFKVlNtRC9INzgySmErRWRZZlpuaEVyL0VR?=
 =?utf-8?B?UnptdzJPZFRiMlpDTXdmSnRHanpMckFvS2ZUWDZZelVWcCt4akJWaVBOaEVD?=
 =?utf-8?B?bTdXL1BaRDhDTmhTU2pRZkRHSkc0OEROaGdmK1E1d0JIUVVCSFhwSmxhSzBl?=
 =?utf-8?B?WEVKN1Y4K285OU1LeHlZclJwQWx2aEQ4cEUvcjBicnZCc01oMVhoYzNvb3Y5?=
 =?utf-8?B?L2U2bmcrVG1Ua21MNzMvMzNLQ3Irc29xbVVDQ2JBUTYrM0VncldaKzZmU2FU?=
 =?utf-8?B?WTVITHpIOUVLNDA4bjhodWVSTURmQmgvbjI1aDhmSnJMeEhsbWZnNGFBQ2dk?=
 =?utf-8?B?TDZhbmx1VjlGelVqNVhvQngrVUVxVE9xQmhsSTd2aWliK3E5cmhtWTRCNC83?=
 =?utf-8?B?QXIxQ1MzOVFDUXZuRFdkKzVmREFEVWVic2V6bGtCTGd4RDA5bktVbnVUYUFZ?=
 =?utf-8?B?RFZkNi9iZzVFa1BISnlhb0ljQmhIOG5Jcm96eDBXdmFEcTBzZFB2QnUzZ0ta?=
 =?utf-8?B?R2kzNEl2ZVBmN1pjdklNQ3hiTXdYd0VISTlhdUVTQVViNnpGeVZ6SWVEZEtn?=
 =?utf-8?B?djV5anh4OGw0ZEIzeFc3bDVKeDFvSU85ZGtZRjVlVUVERXNOUC8yTCtma3Z6?=
 =?utf-8?B?akp4bHhoSGdTOGRMaFhQMEpTNGhHS0oxRmMxcitMSXJ2aWZyRkRFODNrV0Uz?=
 =?utf-8?B?OU8zQk9mOFBSWVRMYjZ1S2Q4MmRBaW5tcjFNREQyd2l3QWFpbnhOZ0M4OUZD?=
 =?utf-8?B?S3hsOHdPL1FVTzVSS01GeUpmNUdnSEdSMTFRQ3ZCVkRIZWIyckhJTzZ0NnBq?=
 =?utf-8?B?UjBEa2l1TU1GVTNabitFSjNXOXRhOE9Mb0ZvT0Y2RjhaVy9kcUl2UXFabUtV?=
 =?utf-8?B?UjU4QWNGVVdNRU1Tdm5wOVNlUnFpZ0dOOWJpdjRvZDcyNlJWb1Jrdkg4dkVG?=
 =?utf-8?B?R2RLNGRMbmJ5OW9TbU14cFFQQXlxRGUxd0hZaTdaOXg1UnZmM3JxTVJlSGpz?=
 =?utf-8?B?R0M5L2p2SjdmYUE4ZzVlUXdJRTFxcTBzejZwRmxkUlNWUmU4dEtsVkVmM3pm?=
 =?utf-8?B?UGtXM0xCNGgwQnRMZ3d6eDFxRysveWpxemNoVWdPZmZkbU4xd3hVZGhrZExC?=
 =?utf-8?B?VFV4QklLWUR1ejJ6WFVMWUJBTi9SRzhIWml5QU1YVThPdkhWa3pKTVE2Ynpl?=
 =?utf-8?B?bDdOVUhDcmhVK3hITzNWUklNSW9xN2JTMzdRTXNGNmp3akVIank0MEpscklm?=
 =?utf-8?B?ZnZtOFZLSUhqUDJ6dWVvLzl3RkNQaHhNczRWN1FDVS9nbG94NTVkMlRtZzBv?=
 =?utf-8?B?cis3aXBlY1FrYlZjRWNVdjN4YzlIdzYrbHkzbmdFRE1hbDFoMHVIRFpiNzJw?=
 =?utf-8?B?bWhMR01DOFdCVHh3WGlkRXBmT2hNdS9Uc1J3cFZFU01nVUJnRS9ycEY4Wk0z?=
 =?utf-8?B?cnVkTEsrR0MyMTRwL1ZPRTNyRG12dkpTQkgzZ0pUU2M3elUrY2JuTW5YUThV?=
 =?utf-8?B?RUdtbzJiYU9laDAyT01sTWhONDdlUHZFR2xwYUY2VFRzS3RmZDNZWlV6UTFO?=
 =?utf-8?B?YVlrdHNyUGtHbEN0QWl0VVdlR1VQL2JQNE12aXRXTXF5RlViRlMvRG9UZnNI?=
 =?utf-8?B?TUNFZkZPRUE0K2VOSkdLcytQU3k4V1pXWEovV0NFTVplZkNaaU4xSnR3Y3Bm?=
 =?utf-8?B?b0l0NitldExtVGZrZGRNeHhYeU1ubVo4OHBHdVA5OWFyVEJENXVtaWJCNWIw?=
 =?utf-8?Q?DIH9jWcNaJ6HUPyE=3D?=
X-Exchange-RoutingPolicyChecked: dYBiMOF0YAQc3YjivmcIZ3oqcRrSHVociTr0hYRAnOLKg6DeQtP1a2LbEk3sPtt8XShPFUrtdB+rwhPyatvEn41BNlJcAcwawl1ahUdei/Yf8SlWtKzJqV9VL26sL66dt+UGj1pJE6vQ+rPyQIpW+de6FTZQGdUuzABmap+Mtn+RDdi3V5ZGoR+ntWitTaaSnddDJMs91EWPU38gsxu/j2MtFDg3eerq8rYaQ33oPdqSZHV4gJ9mp0/fQi1ZBSnZwS4CLRbLoqz0v+maagDGEgkJ5cIpNf07zt+QerIlC0yLctjlv4CaBhSKBn83Pgv6b2LbtjH9+dPfyVHmxJAuUQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d16ad01f-3725-4fed-88a8-08df31155ff2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 14:53:18.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kqiuFv8/uL2ilhp1/ENLK3tPGUszwXdZm6NjZ7VtcJii0plFBA5imlz41UmLYPFG2N80DvgwjWxA4rQ8EUVLrpm303GL3P4Az9vjWYqGr2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6015
X-OriginatorOrg: intel.com



On 10/23/26 1:08 AM, Jinjie Ruan wrote:
> 
> 
> 在 2026/10/20 6:07, Reinette Chatre 写道:
>> mpam_resctrl_alloc_domain() looks up the component of the resource's
>> class that contains the CPU and fails the domain allocation if there is
>> none. The component is held in a local variable named ctrl_comp and, when
>> the resource supports allocation, it also backs the control domain.
>>
>> The lookup and its check apply to every resource, including one that
>> supports only monitoring. For such a resource the component does not
>> back a control domain, so the name ctrl_comp is misleading. The name also
>> makes a comment in the same function ambiguous. The comment notes that
>> there may be no ctrl_comp for the L3, which is true of the control
>> domain's component but contradicts the local variable, which always
>> refers to a component once the lookup succeeds.
>>
>> Rename the local variable to comp. Keep the ctrl_comp name for the
>> control domain's reference to its component because it only ever refers
>> to the component that backs the control domain. Leave the comment
>> unchanged since it now unambiguously refers to that component.
>>
>> No functional change.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  drivers/resctrl/mpam_resctrl.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index 3d5f90f9f1f3..b07e5dd895dd 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -1623,14 +1623,14 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>>  	struct rdt_l3_mon_domain *mon_d;
>>  	struct rdt_ctrl_domain *ctrl_d;
>>  	struct mpam_class *class = res->class;
>> -	struct mpam_component *ctrl_comp;
>> +	struct mpam_component *comp;
>>  	struct rdt_resource *r = &res->resctrl_res;
> 
> Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
Thank you very much.

Reinette

