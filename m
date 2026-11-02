Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793640054;
	b=yM1yF0cArbd7pVqh/RN6lDiY8fA3hfNrxBsffd8u37d9yFppqLNMc8aOgLf7Ckp7uCt/
	 ixlCrjMQ70I5+Bzm77mfZSJSppyv2s4O+RU0n7qtfb195X7Qg2T0C9V06Yye3gOzL+alh
	 pEbujQvQdsAOe2xjKIqmmVkwlvCYFFVaF/+cy36ygS7Kmz1zeDg+DC3bkdh7qwns1NUsA
	 ZIUdaGTZQ7GIPd/WwSv+XJQJXvMHHykSW4i1K9TqO0hE2LLYxSwydajIzjFcYG+zOhzls
	 Ga9+MxFih75QpHGPikoIcwX9Al6slQ9HsJxI8C0uCbMPrIDvMbpcbh6s/8WmCZAEhaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640054;
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
	bh=/dtNOcWWA1xUV4+gfaF8Y6jQTYl2+OJzIWQS1EKXSSw=;
	b=YfPYALTmgeY8hjhxawCkk1VQtUruQQqFN4E4/Rh/KjOq/YQUHqdnvRnmIDNFSVfevNZt
	 aIscj2A0SmO3zAr1LP1gutsTIznCxRFQrLgiPzWvNshf4CEqnOsPw3dkM2jQQbiyfiA3C
	 3MbA5qSQQaBH3s4RA7R2tsHXt2ffuGQcUmvtLDLixEDzDRI1j2CAx/LG3wd2+CixE5zoL
	 QwU4PD9jMvqSdjV6iPzTpOFmpJJJB2uObeQ1s0P3OpoRegv3KmStWvkCMb1mEO2RRzZ+f
	 ep+QuqIn1mtl9NEYHKG1hlRzLU2qxSPu3Y/5BNv4tlhbtTFcVpYEfzAPw7lSeTC9v5w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=erQhudjB;
	arc=fail smtp.remote-ip=192.198.163.12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8393860A34C5
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 17:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8393860A34C5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=erQhudjB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793640053; x=1825176053;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bFiQbJMI5h0YTn0Q6kpKz8C2yqXPCm/49WOWM45So+E=;
  b=erQhudjBbRHDVjVgOJO9iKKdnphqxWdMEqzz8PtFKLZLvvVYSJfJfWJe
   ale62qY00gzvQNbaAa6q1DTIiKmAqTVmaU9g6xHDuF74FxJKXUqZBUHia
   bL7NBfUPyEHtENeM8IHv8tCZF+2OcY2M8VUgo4NcZpKeheKDyM4CBf+Xl
   9bBXTEF/nKIQE7Qz6c/qpiVMBnbF3Rgf51UNljWr/Mq3Zfnt9DRR7oceA
   b+Yvt7Yc2nkhfAzadSkSyWG8TOYF+W0jioGDDSWjvtvQHFs03LGwc78B1
   kF2vS0bUATQgedldCW77v7h4Dr1QcV/9GbAIvOX9CE1QsjKIZLBCxlOrg
   w==;
X-CSE-ConnectionGUID: QHOy4HqaSfmHfUB70BUHEA==
X-CSE-MsgGUID: PXUmWsW3TyiSBoYstltq4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2235124"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2235124"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 09:20:52 -0800
X-CSE-ConnectionGUID: eIEcnW0bSUu8DPoQyhYeKQ==
X-CSE-MsgGUID: um+hs1NbS+OmsOwbFdDIrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6720292"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 09:20:52 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 09:20:52 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 2 Nov 2026 09:20:52 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.33) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 09:20:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bXJBCCDMFmC5V3ITNyuuP4jkkK8bqsJbY/nYdQoiGaq7CWPpZhyoBgClNEY52KDJRq3D+qIAGThPFZU2FaVRf4Jb/Az6BkoinoBiA8zMuHVAEI0ZrrhTrRMks/Nw+ILSJaSpmMnNDBeBrrn15Sp+67/dGNZ6vRBbFwswMgavh9mJM/gUedswFNbhYIXf9aI0slu2k5ba+PCmJGJ+iYgH1HeTSjPLvapEx9lR1jDEgtPD4anApy+Ta8bigs2cRgzqjW1jL5IdyGtBY79Ygq4gT6kIihpbX/frlcrWjM5s6AGUtAdAo/Nsyj+bi9JlOkLc0COrkFs5Q8B6pcE0qC8B5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dtNOcWWA1xUV4+gfaF8Y6jQTYl2+OJzIWQS1EKXSSw=;
 b=QO6e3HuJlJqAl0DB4vkbf77VsmeNPYo31imiLHUrZODLGBboUKjPRpcxuHnB2v5Wg9+IV7hsijRxmzFBXcYS18EEOjQ5NsdVTEDmpmXSefy8DxJ9qbFtTitziHBKAD1XCsS50OGk5SpF3KlZoxn/QGBJyb70eQKoDw+OW+7ALlSQSKflu+gL7zXo0TEiy0r7ivAPW34o1GjEzWgLYypnS50B6o9hQH9fJRwRaMuTu3Cb0zCYgfzSoaJBjyNx8N1cZJ0xeXVmNrbseiRV6/yAofeeC2FhYCIkcxs7Yqn+1GTCx6F80W7vYHGmVpPexu+wfeGHr7IaSFJbjFvJ5fAsbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA2PR11MB5163.namprd11.prod.outlook.com (2603:10b6:806:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 17:20:44 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 17:20:44 +0000
Message-ID: <3a06c4c8-51cb-4636-b95e-d6decf33d9a5@intel.com>
Date: Mon, 2 Nov 2026 09:20:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/10] arm_mpam: resctrl: Split control and
 monitoring domain setup into helpers
To: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>, "ben.horgan@arm.com"
	<ben.horgan@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "fenghuay@nvidia.com"
	<fenghuay@nvidia.com>
CC: "tony.luck@intel.com" <tony.luck@intel.com>, "yu.c.chen@intel.com"
	<yu.c.chen@intel.com>, "babu.moger@amd.com" <babu.moger@amd.com>,
	"fustini@kernel.org" <fustini@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20621c28067916be2709fc4437473f1ccad7e334.1792443633.git.reinette.chatre@intel.com>
 <TY4PR01MB16930DAEC61D558A935F8C27E8B6A2@TY4PR01MB16930.jpnprd01.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <TY4PR01MB16930DAEC61D558A935F8C27E8B6A2@TY4PR01MB16930.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:303:8f::13) To SJ2PR11MB8370.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA2PR11MB5163:EE_
X-MS-Office365-Filtering-Correlation-Id: 535597d3-c07c-446d-de39-08df3905a088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|56012099006|261102123227099003|22082099003|261009223027099003|261022075727099003|261022105027099003|261021121427099003|11063799006|4143699003|10067099003|261028144727099003|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info: DcDUq+pTxMmY7gN7VTY89Y3L7QeVLdryi973bq7Q+jHJ84BqvsX5sKEe+L0ZN5V+BrjWVajROz178HRCZEXXiktLKoiIwjVgElgTgu6wEBWiBNNSXPIvNRpP5xYwcuELPrLGFZ+ccTevxD0+m2i8KZWhdDVCiV9dnUQBWCXJADzn405wkxBn+/Y5Yj38s+aaQZTtATx8cBINYieBH842xs3ui65ic0/enrD34hEFt/9kg9/0PSnFYx4SV5iLyCaRia9un3gIDcSCo072ePY1gL4Eo9jb/KeO4pTeMCZeFHCWGXqhg9SyapEef6yuO8MXuiWPTCAZQ5NocL0zFrW957J2nyf+Eeqy2oCPFM7PO5jyeoFqNINCbaxA7oL206pHDG9o4zpP4iFxRoemqFO6FC7uKWjx8IwtkxotFwc6/hjJnAyEg2ZyuIJ+bXD+LJ1F9SdvhDlH7CwDLagujP0Y8jVzkuDBAf6Gs69qcZS0sOQoBaDp17TLNsR9r/sI9tmfiCuBlj/5XFOBEU/ZAee2zmKD5oT6WfMyGjhblfBv/3TU+cgquPg8DHIY3nwVzm1nE+yiL1hhyeZWXbbZe+0Dg0ssSVkkZ/8m3LQDt51WBMngReYRUxEPQYpA3Dsgha5CNAGH0BbvSpghXDamdsE6wOfiPG+0+cC94yzqrXoh6sI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(56012099006)(261102123227099003)(22082099003)(261009223027099003)(261022075727099003)(261022105027099003)(261021121427099003)(11063799006)(4143699003)(10067099003)(261028144727099003)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3NTVlF2b1drZEZKVVVZOFBocjNsSjNUVWJzV1MxUVB4b3Zxb2hTNldGeUtF?=
 =?utf-8?B?cFN6ejJob3Rqa1ZJMFk0VXpyRE5CVGlyMFRRa3phbTgzejhNQmRrY01ndmRq?=
 =?utf-8?B?Rk96cEMrcnVlQm12ZkN1RnBCZ2swelVEck9hNG5YTmt1WXJXc2ZHRklxQ2oz?=
 =?utf-8?B?dlVRd3FBZDU4c3Azam9FdHNlaXdJaU5ES1Mya1oxM1JiMTVRTGxrWVp1WGVH?=
 =?utf-8?B?NGIxOHB2VGU2NTdkcy9DRENkNUxHTEduK2VlT0dkMk0vMitzdXdCenY1dkpI?=
 =?utf-8?B?Y1QveFQrVU1xYzJjTjJhZ2NMYVNMQ2tLUE8zaEs4eVlhWnlocm1JejJlNlVF?=
 =?utf-8?B?YWlZeTBIS2hHU0wwaDVvckdiUGVXV1lORnFtdWF6ZHp3N2ZZUFpBUU9sRmlT?=
 =?utf-8?B?dHdiVVJUQ3dYY1l2cDNkeU93aHhGNUYvbkx2SFJvQXNRZ1B0MHAxcUNsa0gx?=
 =?utf-8?B?M0JCcWRlWlVvd3lhSlRMRE1ibXFQM1FsRklNbDRWTmhNckRxYTk3UzdtZ1BZ?=
 =?utf-8?B?TnNsOXMzcGZaTFV6SDBGM3lJMHBUeC9TRXUvVlRGU2k3ZFJHNFphNnFFZXBM?=
 =?utf-8?B?S3lHdWY0dkNHQzBSTUNZbmdUbXBwU09icEQ3SVlZWnE3OGY5VG1GK3Rpak1D?=
 =?utf-8?B?clpWaDdDeWR2WTNmQ1BYS0lZditxTzBYbkZBTXZPUXNkU1MzTW9Ed0ZtcVR5?=
 =?utf-8?B?TUFDUmJwZXZqUys5dW4rVkw1dytybVRFOHNabktEQklBU1k2RXo0Ym9qeTBC?=
 =?utf-8?B?dXRpc3BIeVJidHk4RjNpY09wNHIyRXJ4WVpxWGtGek5Ga2JjbXAvQi83MEpu?=
 =?utf-8?B?VElhQzZhckVrOXJyeC9Kemc1Yi9MMG5wM0d6QU44bGxoUE9JZ28vN1l0THpE?=
 =?utf-8?B?MHMrMktJWkpCU3RpaWdvc3BqeGN3Q3BxUDdtL2J1QWMrcnFuWnhZbXFieTRU?=
 =?utf-8?B?NDV4SkZXM0ZjcWc3UXY2MUhBcGFJU1RXM2JEcmlncEU2WWNNQVNlTU9Qamho?=
 =?utf-8?B?THI0S3Iwb1FQL3FSWlRNbEtXbHc2UGUydHJJVXlxbzlxbFU0V3Z0ZVlXUEgw?=
 =?utf-8?B?ZmpWNEhBajZWbjlLS0h6Mk9VWVZmVWZtc3J0Z3Z0UTR2azhLVlZKNXdzWE1x?=
 =?utf-8?B?MWJzaVRqN1BiVEgrWDZBSXdxRk04MmhacUJhYTJsYUhwS3FOZW12U25EK1Vl?=
 =?utf-8?B?dmF0Y1NoVzdBNHhva1Z1Mml4MFZNcmRkNk1wRG51T2gyTGovbHNGTnZEK2w1?=
 =?utf-8?B?OUI4ZGluaWs5d1JMSGlTL2FFUzNnWGdQVzRnTzc1a0lyRWlBSXVEUU5xNUh3?=
 =?utf-8?B?N2hqYSt1akpzTkMyU1BXRUdwSDNlU0dyNjdONEszbmtxYklVdTNwVkh6RkpX?=
 =?utf-8?B?R1FCVVBBVHQ4ci82YmYrQlcxVU5pTTR6Y2JDWE1WdUFudjlDdjdIM2FyY2Nq?=
 =?utf-8?B?MEVCNkNxMWhnYlBvT2V2V0d5Q05FTjhmMGVWOHJGMEdZbVZFY0Zmd1l1ajBI?=
 =?utf-8?B?bkFCMmhOWHFLS0FMSGxqMFU3RXlPM3Q3SWYxYXBoQ2Jnbmxlb1ZyaGxuWHFQ?=
 =?utf-8?B?T1FTUEtDQzFueUJtZHlzRk1aK3p5UUR3b0hNL1dEeFZOeWNHS3lXNFRUcE1p?=
 =?utf-8?B?aEpFNXp6Z3F3VVVNTms2SnU2R3AyY0taaG5zUENNQnBUT21xSTFEQkxtQWM0?=
 =?utf-8?B?dTRKbzRWY2pwK3M4S1JRZ3YyL3RIcWJIWlJSR204SUNrbXpvcDNtV2hkQ1g4?=
 =?utf-8?B?RlVzSGhPZXB1UkpCRDZLTm43dm12bVFpdkFQT0drQjdmQWMxeGhwMTJoSXEz?=
 =?utf-8?B?M2xBUzZ3MmJWOCtHZzRRS3lkdjJSVW9ZUkNDNWRodEpBOVpyV29CVDBSUlZN?=
 =?utf-8?B?Qkh4U2g5WTk2ZkwrRXZSZ3Y0andlVmFiSHllZDRxTU5ib2VSU01lY05YWmJ1?=
 =?utf-8?B?WExRaVIxNjN5MUoxVStBMmpqTWp4WkllS295QUlCTkRsd0VkQ1N1dWZHRHVZ?=
 =?utf-8?B?ZHRiL0dZakd4aDJ6S29IcEthSFJSbHJQSnd1bVZjRmtDc2k5ZVpkbnpibTdt?=
 =?utf-8?B?MXppR2NmNm9nQURQNEMzbmhpdFJFOTRQNm1lR2ZxbndDWThsMHQ3ajVNWUJM?=
 =?utf-8?B?TXB0SjNOdkRIajVNOVdFaGZmT1lsL1pjWnRjci9ESWMyVHVGQVVWdnR1ZFlP?=
 =?utf-8?B?TCs1T013ZGV3eE0xbkptUW5ScmlvcnVPbitzbnU1aTVCVyswT3JlQ09mYS9Q?=
 =?utf-8?B?N0N5Zk5BeDJIYWFJLy80am53dno1OWcwSzlqTW5PYWVvT1pHNHFaT3ZrNzh1?=
 =?utf-8?B?aEthU0VQQlVwTDhQdC9jQngvQzl5SmgwMURWNGMxS0Q4UUJCQ3phN3RSSzFj?=
 =?utf-8?Q?mo8vfDI0lh1D5UjY=3D?=
X-Exchange-RoutingPolicyChecked: twD7gWT2djvzOQ4fqvRgMIQ56T+2/7VW73A0Ll55fyQL+dV6ZXbBTBqM2B0EBKEfzC7ZPzobh1UGflXaIaeZZMS/dyCuPi4Xkz5Wh+DKqorOs2QO7oxyr5p/bapUokCUIeSZoC6fg9a/sfvp9Rw6wNse1287zw40QCIpjnsxLAhyN3mkBdHDr6nHFqg5cyjSJ2xVV0V9jVsLD2N0O8ya3Co4WsxmRnDidMCKBwsNDtRdfGhwQ1HoT8/cSSP6IrY9qGGJURWlYj1hW0ycaZOw++kuerJYVtuc+o3mm7ZZfCeRAAXtspssvPqGyduIYoEPQTyoDJegDj9h/udRlgukLw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 535597d3-c07c-446d-de39-08df3905a088
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 17:20:44.2104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPhk/RbCY8IzfYz946Gr/FMZOBrBQqZCGoYBToMm2Xx8vHen146pswPeWNdyYuqqnvakG99xihLVUyQeza08Rscyya4eEhZiz/GITVCP7vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5163
X-OriginatorOrg: intel.com

Hi Shaopeng,

Thank you very much for taking a look.

On 11/1/26 9:41 PM, Shaopeng Tan (Fujitsu) wrote:

...

>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index dc442851fd7e..246560247a28 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -1615,13 +1615,77 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
>>          return NULL;
>>  }
>>  
>> +static int mpam_resctrl_setup_ctrl_domain(unsigned int cpu,
>> +                                         struct rdt_resource *r,
>> +                                         struct mpam_component *comp,
>> +                                         struct mpam_resctrl_dom *dom)
>> +{
>> +       struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
>> +       int err;
>> +
>> +       dom->ctrl_comp = comp;
>> +
>> +       mpam_resctrl_domain_hdr_init(cpu, comp, r->rid, &ctrl_d->hdr);
>> +       ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
>> +       err = resctrl_online_ctrl_domain(r, ctrl_d);
>> +       if (err)
>> +               return err;
>> +
>> +       mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>> +
>> +       return 0;
>> +}
>> +
>> +static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
>> +                                        struct rdt_resource *r,
>> +                                        struct mpam_resctrl_dom *dom)
>> +{
>> +       struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
>> +       struct mpam_component *any_mon_comp = NULL;
>> +       enum resctrl_event_id eventid;
>> +       struct mpam_resctrl_mon *mon;
>> +       int err;
>> +
>> +       /*
>> +        * Even if the monitor domain is backed by a different
>> +        * component, the L3 component IDs need to be used... only
>> +        * there may be no ctrl_comp for the L3.
>> +        * Search each event's class list for a component with
>> +        * overlapping CPUs and set up the dom->mon_comp array.
>> +        */
>> +
>> +       for_each_mpam_resctrl_mon(mon, eventid) {
>> +               struct mpam_component *mon_comp;
>> +
>> +               if (!mon->class)
>> +                       continue;       // dummy resource
>> +
>> +               mon_comp = find_component(mon->class, cpu);
>> +               dom->mon_comp[eventid] = mon_comp;
>> +               if (mon_comp)
>> +                       any_mon_comp = mon_comp;
>> +       }
>> +       if (!any_mon_comp) {
>> +               WARN_ON_ONCE(0);
>> +               return -EFAULT;
>> +       }
>> +
>> +       mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
>> +       mon_d->hdr.type = RESCTRL_MON_DOMAIN;
>> +       err = resctrl_online_mon_domain(r, &mon_d->hdr);
>> +       if (err)
>> +               return err;
>> +
>> +       mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
>> +
>> +       return 0;
>> +}
>> +
> 
> Currently, it returns success even when the domain fails to be inserted. Is there a specific reason for this design?
> I believe it would be safer if mpam_resctrl_domain_insert() returned an int to indicate success or failure. 
> 
> For example:
> 	static int mpam_resctrl_domain_insert(struct list_head *list,
> 					       struct rdt_domain_hdr *new)

Could mpam_resctrl_domain_insert() ever fail? A domain is only created
after the lookup found none for this CPU. For a control domain the lookup is by
the component's CPU affinity while the insert checks the domain id, but the id
is the component's id and component affinities within a class do not overlap, so
absence of one implies absence of the other. For a monitoring domain both are
the L3 cache id.

For mpam_resctrl_domain_insert() to return a failure an insert would have found
an existing domain which means a domain appeared _after_ it was found to be absent.
That would be a driver bug rather than a runtime error. The WARN_ON_ONCE() reports
it. Handling it would add unwind code for a state that cannot occur.

This is how I understand the flow and believe this is why the existing code
does not report it. 

Reinette
