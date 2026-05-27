Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8AA229B38;
	Wed, 27 May 2026 03:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779851171; cv=fail; b=qLzw6PFUegF4vDJjV9NxvLpTw1kSS1ZGkeDuWuk+UTUeMWfRXKepbkVzLJHfeoGfEjKWwWDMltGW0cS9IkYzEQFhoFddYChkHq4elKI/IYOMrXR5o+RVW/LBixQ4D1juVTW1gkTzS8CyHZ+YK4Q0pzCetxS4IBfiFA6kgCDnYRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779851171; c=relaxed/simple;
	bh=HAyw6OPSY4m/1Kv7G9MZFBaZcJSTrLoWCQiteW3YpjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iHmluRrc8ye+VMDDs6hYvYI40/eM+Sx6mS7D4OrtCsa8HvgyKxW+IPN5ecPSE4BandVNdralGOM/pSba+/ipIC0w9n6NbVUFEuMt7bpxZTG0Ln62OY6TZmQHPVW6FMd6QHFQzHX47tgpFcmbVRhahRaRtVP2Roa/gwN1Wv3rq7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=RebrynAf; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="RebrynAf"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64R1GvL81978092;
	Tue, 26 May 2026 20:05:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=eAnaMb3aLn2n3BvymYOA3I8fNfMV0rXViXp0cEAON9s=; b=
	RebrynAfLdthO6nFs4QvNSStnid+a5pmv+hjbWVDT+YDeKz+4hwKTO741rJ/lugj
	br7skUWwbdxEanIcJNW9Q22h+D51ThAkymXPKGSj3SnE2VMZGWTukg34dHZaHhWp
	hWuxcdM94HeZ1lVKdRsEYmD9bt4yTu5fTNuY1pdSOgpYgYZlJj+Zc6F78lOvOjaU
	GCk8I+eo0LYQwWCADeTbd5ifKJG9lLM3/qPeTbfhGqcPUIoSxlGr2KaKEGCc7nEA
	MH89OhF3dT90GZ/aBpSV3W3boNRZ8+H2WQvyFXxwpH5hQxK7x4yq1YXqrpPnHJ+Q
	K3VNQ/z9rZ7IOrflFjbdEA==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010063.outbound.protection.outlook.com [52.101.61.63])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ebbremqwn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 20:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jaXm5quSnrTAlQw9KUBFbAp0PbePP6O7LXlzQ+BtqpNV27LdgPmm+PT0ZucGRvm1haCgVMjWlT1lsiOzjEoLwcWu0M2xz16LmvKRK3d6uLoMBqXL9UCiK4pUG+00Rg8lJJNr6MKAwNnwQ8vWjrGm738SBxsxr/L1yDOnEzX2oeaUD//GH/8LtYsFI22ZGxtL5KAa6OKV9H+/ci7sg2gDjAOa1+ILePLdet6tJ8dP47UgQvti2okVviD4BFRE7BcHXLuEUmb/chhfKSSt4wVs7rQK+m03NH8TyLkYMCj7tA9JakOelOsL4NfDKIjJQ2axoJA18uVtV0RJ3S2u65yuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAnaMb3aLn2n3BvymYOA3I8fNfMV0rXViXp0cEAON9s=;
 b=qBjn0FuxJok1vBxNTEHhU5SCcwA9L0qJDQ210AtPsTIejPUx9y3W7lFEO0DGnYocDr8RvlYLGWWKO36L3xMfVIVp5gLkQcy5phsXTp/ZdZMY45Kfc4ZdadgqOOJkrttY0owM4MOlQtPrBBzHUg6FSGfxTDSP6kjbs2eNqaWCbFnSnfvEAyFpe6KkUC3Vl1l8Nz32DWcmQCO5cmv9+6aEcR7q3SITSSjZSM5xkJiLzsvwSntw56XORDlkAoOTQ4/TH9EXBbz6ZIJzpyAPOQamxvhRgrzift/sn8uH9Y27u/82n9WbqZ+2EAIOuFxPxmoq2LOYYfg2l86Uo1ra4Y664w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH7PR11MB6498.namprd11.prod.outlook.com (2603:10b6:510:1f1::21)
 by PH8PR11MB7143.namprd11.prod.outlook.com (2603:10b6:510:22d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 27 May
 2026 03:05:45 +0000
Received: from PH7PR11MB6498.namprd11.prod.outlook.com
 ([fe80::492d:f133:b4c3:f94e]) by PH7PR11MB6498.namprd11.prod.outlook.com
 ([fe80::492d:f133:b4c3:f94e%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 03:05:45 +0000
From: Jiping Ma <jiping.ma2@windriver.com>
To: lixiasong1@huawei.com
Cc: gregkh@linuxfoundation.org, kuba@kernel.org, matttbe@kernel.org,
        patches@lists.linux.dev, stable@vger.kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com,
        zhangchangzhong@huawei.com
Subject: Re: [PATCH 6.12 28/70] mptcp: fix soft lockup in mptcp_recvmsg()
Date: Wed, 27 May 2026 03:05:13 +0000
Message-ID: <20260527030537.1305489-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <52ea906c-0953-4d2c-98ee-b873ecc6a075@huawei.com>
References: <52ea906c-0953-4d2c-98ee-b873ecc6a075@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0217.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::12) To PH7PR11MB6498.namprd11.prod.outlook.com
 (2603:10b6:510:1f1::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6498:EE_|PH8PR11MB7143:EE_
X-MS-Office365-Filtering-Correlation-Id: acda0b54-c27f-4f87-6241-08debb9cd84e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014|11063799006|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	IslOjPfg0wyfkUvn76cV645Nv3IPIbkmnh2Vn8RalFq6XKNaiueNhjPN/IXTlIBCkQwGydhZnvdqcZevQB5NG+LffGFg3kpUaQy8VOpHSiAu7VV+vQtXWN0gjxEDuhFIM0dOx8nhjON2BXsMGX+LF7hSz+2XcKqH+9lAf1jBTA6DFeTZJRikZXtTc0tJH4b6APoz0zS9smxyFg/pZk6oeGT7ii/C2c/u16aFkmOIiqADP2p30DmB5EJ+v6lXf0oJykChVvAJjQIRrImfJUVuGpd7zXFNBTWON7JiJEoFy9Pe95aT0H7lxC8QoEWIYJmULBXFsScKdBMptPDM/NxGUMiuxh94WnrW0XA8YcTGSggswW31kAA5HieVTcMkf12PzLY3jCRGc2b/2sH9utkTkXU4RCE5pbUkk/xfZte+FoTFUaQTgsMfhp6NxtAX1QWt4uR8zHnXugrPy3uA66D/p9VdzNSFIbJ6voSUqSszjNXCT6OKLAbVA0dY3582HiTPtzSgkhlAc3+z4O8J8nSCulKZOwECKotbXAWdSDf7M4NF5UmXVS3n5GUB15U9vMNiHXVBcyUSoEyc35IW9ozmmGFjhzJtLY5X6SSWzgyXSUydzgG/ZnQRYZ+Po2elReV10B4Aqq9QZgnPdXMKzi35v9AvNGlvr4t76yFLAiAsSTJvf5GaM9xpzl/HF88VKNyxu652qxRs2ylcuoJOJrbBO5iZhpz9zR+iAZjnSu5z4hoxwoly9moLe4KpyXu0fqr9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6498.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014)(11063799006)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0xVL29oak1lc05QaktLRWNlYlRhSzdxNC9rZk5xMzZDcnJhQzJnMXlqb0V2?=
 =?utf-8?B?bkVrd2d3bjEvdXpZQ3ZpTCtURmd6NTNyZ2srelZJc290Z2hmaTVxNDlJTHJT?=
 =?utf-8?B?TlRXc1hiR1FUNm8xcWtMRUtPTnliYTE3WldGckNYajFwMVdiQTRBWkZoZ0xF?=
 =?utf-8?B?Y3V4MHFxZlZYbnVNVEFFdmNSdDB2ckExMzdrSXFXVWxYMmJCNDFWNVBkVE9a?=
 =?utf-8?B?WG9oMGNodDE4dzY5TVVOeWJLeW1NVmx5MG53R2UzM0xqWnAxNXlROVErdTVn?=
 =?utf-8?B?cWRHMU5VaEt5Qi9rckF0SUIrRHI3cXpBcDdOR2x5dXNJUWdKeDI4cVhnQTFt?=
 =?utf-8?B?Z29mVDMyY2dKdCtWREpXb2NQZGQ4QlZBYVUrRlR6MmdldXIxbnNLcDVsVUla?=
 =?utf-8?B?UWZmd2NkbGJBY1dOL2wwcTIxNkc1U0gvcEE1bTZYeXhYVm12YThFb2dRc2Ir?=
 =?utf-8?B?YnpicVFrTTVmbk4yS1VSclZDMjVmSmMyTjFGOVZzOWwxNWMvYndRQzhpSDBK?=
 =?utf-8?B?ekR5ZXpXOWkwR1RZVjFJR3VUbStkTHllYzFjRytORmtwYzBxUWFjbFpub0NX?=
 =?utf-8?B?dFFKekVUTG10Q21laWVwZkxUcEdLQTRaclJDTDlqTUNJZUp6OVRnT2podHJr?=
 =?utf-8?B?QzhiL0ovYm9YV2tBbzR4dVhhY1B4NGZLOW8vVHlXa01EM3IzOW1pRkJLOWhi?=
 =?utf-8?B?MnhwaXQ5cTd1UmNYeUs0WndVTXMvZDJZMkNFZFh2SnA0dWFhQnd1M3BiMVRz?=
 =?utf-8?B?TGNsV2lnWCtlV21WU3NsUzFLdFpXUzJZb25FNzdrZEYvVVhEajJvRVUzZWdu?=
 =?utf-8?B?Vy9rc0JoeHB0cWt6WGdDOUMzdVJ0RWU1dmNPRjl6RzFlTW10eGJuWjV6eFNB?=
 =?utf-8?B?RFBvWGpwTnBqRlM5Yk1WWWg0MW8zQ0l1RS9WUEFCS05IL3g0WWpNNERaNFl2?=
 =?utf-8?B?SlV1VTBCZWpyWEdZRkJ4bWJUaTBqdkVwWnV3MEw4SEt4NC8rVkRkZi9WVEIz?=
 =?utf-8?B?VWdsUURXVjc2bUFxdVZEbmpuZkltMDVvNXpmWVlVOVE5MkJQNUp4RTVpSnpp?=
 =?utf-8?B?ajZqeXJrS0VrekovWWw1a2tEQzlOK1pZWjd2NnRUZWRIUUtDQjdBUDd1bzV5?=
 =?utf-8?B?WXRUcWF3Tk5SS3ZKS0dPKzdYRHlCYUQrVmhEUVRLMGdrMjNLMnZwRGtRMndY?=
 =?utf-8?B?Nk1XTmE5S3haa1RiWHk4RFBTNDZoMzBvc3dRZjZHNExYSlpObHU4MFM1ekcx?=
 =?utf-8?B?dDlpS2hEZmgrbWlWOHdjT0NXNldTeEkxaHZIRGZYMG5KV1BzTDhrS3B3dVIz?=
 =?utf-8?B?elJsZ3dYOWx4eE52eXk3Z3Z5RXpIU2xsaW5vNVk2aGZiOGRGMm5QSWE3Sk5H?=
 =?utf-8?B?ZmpVWnJSODNXSFZOL0tieWd6cDdvQXFsYTZSZ0JCNkRkVHR1RzBXOUtQZ3hD?=
 =?utf-8?B?Wm4xL2hyOFM5YWtaTGl0WmdGeDFMeDBiY0xkai9YNWg5RmJOZlptYjlGQk40?=
 =?utf-8?B?dTFCQU9tWjZUN1pWcGh5RlR5akQ1R1VvUVVZRzhWbUNXaktYbE1PaUdjTVkr?=
 =?utf-8?B?TE9WU0lyZE44bTlGYWN5a0xuUU55WTh5V1JnTzNEdDUwM1NFbmx2ajFOUjli?=
 =?utf-8?B?MU5XWmVYS01FS1FsTm82UGpOV21ZdzhQR0tIbElzN3YwbzR6cVR6Y09VSHJo?=
 =?utf-8?B?RC9kc0lpTGFWdndiL1lvUHhiNUU2S0dzU01zU3ZWS3ZwNmExcDdRY2RZaXZm?=
 =?utf-8?B?MFJxZWJFbmlJY3FCU1NITE1QOXdSMytvSE9zL2s1TXZNSlJFN0puSjF0a3Nx?=
 =?utf-8?B?cFhKTU8ySWtTMW5IYWtzZGlnYzN3dGdTdE9UaU1RWXd5UjQ2ZHNsMGFveGRK?=
 =?utf-8?B?b2ErN28zVjFOL2UxYlZ2cXZuUVAwWDNKUmEzUE9kWkZURXkwaUlSTkNlZzdW?=
 =?utf-8?B?cGF3dnh5Y3hQOFF0aXNOQ1JiRjJ0V1pNekdQc0FwTUp0NytQNHgrVlFRL1RM?=
 =?utf-8?B?NWMySlNuakZRN2x0M2drL0F1S3lMNjlJWU5URjNWT3B3cGRlZ2tyRmMzd1N0?=
 =?utf-8?B?RFhham5GTS9QM0JjbkErM3ZrZmdUb3c5QmU0b3FZYkNMOGdBdFpONFlnQWNu?=
 =?utf-8?B?MFg4K0R1ZHFGTkw4NE04Uk9ySUY1UGUxemlYbEp0eDRCckhKT0xyL0U1a251?=
 =?utf-8?B?eVVmZkNnU0dyYjc3RWZTcVVMUUxMWGN3Y0s1REtPUWV0cG1EWU9jRmxFZ2p4?=
 =?utf-8?B?NjNGRU5vOVlMdDdieUdNV2pYK1JTVnVma1diSFhZb0l3M084Vkp2bGZxdi9w?=
 =?utf-8?B?dmpVSmpvZjQwOFIzNzhyNGtiNG9wbE1DSGNYSkhCK3ZmSkoyR2dDdz09?=
X-Exchange-RoutingPolicyChecked:
	lfp0nozZPdtVOlFNB7ZtCSVgCJN0mLXXWzo2gIYclvGGwuh3/HDwc2PPQAB6KFY8NB0WvYguK/IOpLj1GBoBSr0CRxWTg3nMR8mIiWAiucJD4OBOPCaVC6fXXUnkI1y20Qf0t1oFeAWmXOsUNQYJpwA6G41UXmvzwzVj+xHNsg5z8CqfeFWaPfniYzgeA5HtR2C11Vy2sAHNh1E7NPRwqyg5RZlCNQ0TtXulFXWcNI10pEG8d6n07zHyPff2Kt5A8MWTrdWCbZMCY5p5TQwjz8AiudzEifYGUy1FkZgQFI+ZtJcsSDjv7xqKN6KEOU4E8MiihNsgm0qTl2kvP7bazw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acda0b54-c27f-4f87-6241-08debb9cd84e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6498.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 03:05:45.3597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FWatDZd3adq7XYiLVNN3c/HLZ8SowYfZli5L1jVQ2z0LD2XN02asDQ05Wozf5+LmxKyD5Raa1/JMg/FSVWD6rpxBAHxvGLAXtiIQkB60V4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7143
X-Proofpoint-GUID: LUoTFgfWL_zo-vmErCjoeNejQqZPza6E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDAyOCBTYWx0ZWRfX0NYd811V69sq
 bWusf0Z+kOK5l1t7q87Q3PSBrQD8m2j1M2ZJlXY/bVyiJyfF4QALUw6PejFEvVzcB67t8UnCWz2
 JN0OorJb6TfyrqWxndvc3eKNOjYBVYVrDbpAlbgN/HkIzlCXF8aH8rnNYpHlLYipMiX/mgjdA8A
 O94ndn5flF6xe+dertbej7VK8pmDkoPH3LNxYP4wdTiI0zDEsUZAhO65VD6NXhnbp+O/TNGAcr/
 v/Nz3zS3nnirZ7vgdAUHA7EW/PrUgiT0V2zXko6QvruW5KKrDBtZXwXUSRL9iFDUJ37hnZ4Mg7h
 jzlh8DZP7B+PYlYHDRj7rNihXVsmbdbX84aanLkqnnPeJc5IujcNsPJwV0E7sDYjhJ6xZkY1qdj
 8+nKmz5eWsxosRsGk/b4vDDTyYDIF7je6R+JJKN/mkohAySpXxhGapl9bHCmgY3qxmav2h3HBqZ
 nS9sjjLtcci7XCHPqzw==
X-Authority-Analysis: v=2.4 cv=IMUyzAvG c=1 sm=1 tr=0 ts=6a165f8d cx=c_pps
 a=oA0oAqHEqr9/hfEU5FnDzA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=H0quJJ73Ex5w21SRuzMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: LUoTFgfWL_zo-vmErCjoeNejQqZPza6E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_05,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605270028

Hi, Xiasong

Could you share how to reproduce the issue?
I used the following code to reproduce it, and do the test in v6.18.32. but the test results are the same with and without the fix(I revert the commit 58b58b9ba89c43914eea90c18928e51852d10c24).
The client task will be waked up after 10 minutes.  There is not soft lockup.

client.c

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define IPPROTO_MPTCP 262
#define PORT 9999

int main(void) {
    int fd;
    struct sockaddr_in addr = {
        .sin_family = AF_INET,
        .sin_port = htons(PORT),
        .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
    };

    fd = socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);
    if (fd < 0) {
        perror("socket");
        return 1;
    }

    if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("connect");
        return 1;
    }

    printf("Connected. Calling recv(MSG_PEEK | MSG_WAITALL)...\n");
    printf("On vulnerable 6.6 kernel, this will soft lockup a CPU.\n");
    printf("Monitor with: dmesg -w\n\n");

    /*
     * BUG TRIGGER: MSG_PEEK | MSG_WAITALL
     *
     * - MSG_PEEK: don't remove skb from receive queue
     * - MSG_WAITALL: wait until buffer is full (1024 bytes)
     * - Server only sent 512 bytes
     *
     * Result on vulnerable kernel:
     *   sk_wait_data() sees data (512 bytes still in queue due to PEEK)
     *   → returns immediately → mptcp_recvmsg loops → never waits
     *   → infinite loop → soft lockup
     *
     * Fix: pass 'last' skb to sk_wait_data() so it knows
     *       no NEW data arrived and actually sleeps.
     */
    char buf[1024];
    int ret = recv(fd, buf, sizeof(buf), MSG_PEEK | MSG_WAITALL);

    /* On patched kernel, this eventually returns or times out */
    printf("recv returned %d (kernel is patched or not vulnerable)\n", ret);

    close(fd);
    return 0;
}

server.c

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define IPPROTO_MPTCP 262
#define PORT 9999

int main(void) {
    int sfd, cfd;
    struct sockaddr_in addr = {
        .sin_family = AF_INET,
        .sin_port = htons(PORT),
        .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
    };

    sfd = socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);
    if (sfd < 0) {
        perror("socket (try IPPROTO_TCP if MPTCP unavailable)");
        return 1;
    }

    int opt = 1;
    setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    bind(sfd, (struct sockaddr *)&addr, sizeof(addr));
    listen(sfd, 1);

    printf("Server listening on port %d...\n", PORT);
    cfd = accept(sfd, NULL, NULL);
    printf("Client connected.\n");

    /* Send data so client has something to peek */
    char buf[512];
    memset(buf, 'A', sizeof(buf));
    write(cfd, buf, sizeof(buf));
    printf("Sent %zu bytes. Keeping connection open...\n", sizeof(buf));

    /* Keep alive */
    sleep(600);
    close(cfd);
    close(sfd);
    return 0;
}

Thanks,
Jiping
