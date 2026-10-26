Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793033735;
	b=EDzf35oirW4DNc/lJHEvHGLsbWDnH94QNCplmcG0Qni4iX2AYzrhlkH416+IrHTo+R4j
	 8v/VGr+9M9sesgsI8NaHdM9QsURnRaxrq/96YSDmlQiAh1RSRW22zZELYfjqaGJ2n982G
	 vhKr44hHT3oGaY7fLt8u3iEOVm4+S7vsSrSAcinN35sT1ZQZIDH89ASa8IdBtNo/7OPPs
	 M0v/kbMyPZtTW0UptJhsm3WaB/iPiEEjRMdiHsSYnKa3LkRxmXmVtJ79rofKuSOadk1Fw
	 t5KSrTw6a25JTlnV6hl9k4uYBnk12jouDSAlcQsKfMarBENGVg8XOm0dS8IRIPceqDw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793033735;
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
	bh=c1PvbHqAbLCjax7wCsxnME47q4eWqBPpBrNhZmYhg0w=;
	b=vJikq/cZUHabRi7y18jg9vJekhfTARIgB5RaURIWiWh9fryhjD/n9cPpoKy5V/ANWeYr
	 YFjzldEPHD0+PivTycn+S3YABUDr47l7ZfZsMjd1SDuK9TVp3eK8+NuMLjU/YFauWuqb3
	 JBZ74v8PExgLru5XsSyQwFzAY+azfHD5wnkWN1iVpKJeDiMk+0c062HsrGUMB1sF8rHmB
	 ttXuQBmO9REycsl5mSPLSBDZsiBXaQvW67ttMLgJjshmflFrtSl8p3enh5fPFY4rfs2fc
	 hWK6PIGLFOLa/jUrtpv1NpRPCDGEgT8OfLBY8SchMHIOLjU6HQS+rSSD1jUdNy79KRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A3eJS67i;
	arc=fail smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835D7606A31D
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 16:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 835D7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A3eJS67i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793033734; x=1824569734;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SXgXPemDxpZpwctkgUGhijs9IOw906k8/b47MJAcUzI=;
  b=A3eJS67iq7IZ6NaWyWihALXp75dGJ8u/uxo0lmRJNFjhX5yWGmLURN2+
   tBLju62JnEpkZWYLfNuI4yb112l4YPZdMqO3BHdCAvRbnvuBeneOcHUTs
   3dcN2xzELALvNLTfYSxeBW75sMVYtWpi+b6p/+D2tIZ9orlgyRws0tSLH
   lMXuinnkM4v5POcBVBgwBAeFbwLQ5dAx1LjzkLGmMasZPYAnB2gYYkjCv
   bR25RlUCLrWAYyuyhyTXDx3sK/8cMcaCDjVRsXiy/wN0Fp3/HJ/ru3ATW
   AytBTvc6kwS3/bKMnbhf8zmIzpSVYrcXzcnYlQJOvr2QaxiNeHtqWBcx7
   Q==;
X-CSE-ConnectionGUID: +Tste3h/RXWFpStCX0qMCg==
X-CSE-MsgGUID: 8FzonLWkSDWm2ttYbYsEbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1704049"
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="1704049"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 09:55:32 -0700
X-CSE-ConnectionGUID: rYNcTx57TQKqfVvYk6airw==
X-CSE-MsgGUID: 1xOwtrzFRVCnW/QjW7KP7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="4428574"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 09:55:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 09:55:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 26 Oct 2026 09:55:30 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.7) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 26 Oct 2026 09:55:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HM5wOsilGpQctTU7Dlb1aPYQ90S1v/J3QUmgXKcW9hBLNm6BaP5Cjydom5LxEXQCoh+2g0mcECmk2oL4zCyc6TDs++Ok4OWZjRXyL49m91Y2N8w6dih1UtLfZ1JJtnsfXOTqnC70DKzhXpkkbQsmehPlLVulhWvhIfd2uf4Ip5k7UdOTSrFPzIz+QPNiIyll1H+peBXzMt/5Z0lpFoKSQwreue5tmg8GmokGzvXEKFQAqFeFXJBKx1i12e6SSE9ibNRf/QBynb5pOVfgvL9Kb2dQBOvXTnHjikXwOI8nX9TTZYrcTEev7xfz05W1rge8qku3u9YOHGtgHykSho9wDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1PvbHqAbLCjax7wCsxnME47q4eWqBPpBrNhZmYhg0w=;
 b=TYLfufzPe/RA0N+Qf++wj94RDsvo7wMwfGVnGkLSbqtDx6tX305eEZ3cLzpcPsIFgjbvzPE2qum9I/V+rCWROqaUiZZVExjukucYCFfn3kvPI+prl83gdzhdUuliXPQLd3f1QubTiQF/UstnTTQ7LN4sPH//Jrpc7Dw1PSMdjsLFwMgU0HBbyaybSNF2XpzpZSbaUWzK3MQPMQMUmMERk1f9N05Du1+ywZQT+LSGcUq/YpuWuL9OzXW1k0NBXSf10pXMVUNyRfB554KKLGwScC0jO/0KssYs/nScJlOkxO7bLJhfc6t68PLv5NQY5zS4ch1TSz8g0ZdliDOpkqmOIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by EAYPR11MB9562.namprd11.prod.outlook.com (2603:10b6:303:2bf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 16:55:23 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0546.016; Mon, 26 Oct 2026
 16:55:21 +0000
Message-ID: <f288691b-6064-456e-89fc-2c4b2e6712b6@intel.com>
Date: Mon, 26 Oct 2026 09:55:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 05/10] arm_mpam: resctrl: Give the monitoring
 domain its own structure
To: Jinjie Ruan <ruanjinjie@huawei.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <2238eab97cc66852d0d0d1a5c6ff191c03ce9e0d.1792443633.git.reinette.chatre@intel.com>
 <52fdd67b-49b6-44b6-8eaa-17b29fd92947@huawei.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <52fdd67b-49b6-44b6-8eaa-17b29fd92947@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0160.namprd03.prod.outlook.com
 (2603:10b6:303:8d::15) To SJ2PR11MB8370.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|EAYPR11MB9562:EE_
X-MS-Office365-Filtering-Correlation-Id: bab204ab-ac4b-4beb-a177-08df3381ec17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|261009223027099003|261021121427099003|261022105027099003|261021123027099003|10067099003|56012099006|261026140227099003|18002099003|22082099003|261026121527099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: JS0aNMQRZIXxSyrZ3USVnPYJKRt7THF2RSONM89JYp3pY/qCy9+s4lDleofVab9otwAMzXoa3mz/gsuLjd256L5o5G+LFFCWQV/yb60C4b0WX0rIfq5kg2azsZfbyYvOJMKQfNIAZVloerZPRD/R77+Dnv+94UaUu7ZB6VvMF6l0fZOKBO4+PLY06wU+J1w7CImslYYQoyYchXfyJvJk9wKsmx1IPT7MnRPYBqLVHxRdDNGccAakFOSBmmyPPIdc360R9mzPQEFQdH/pGK/xxy22NZgiobJpa94lSZgd00PQtqVWT0577e3h9hYms+BGrg3Qx2yfXQ0u2DRgN4Xy50l3ovBNq3fpkAxA8kLw8lcmUPP2iFiPdBDH0/ups9hwjbY89YXIrXvIDDmNnXVgVcgfFkEfgJq1GC8KBYb7wrb2x6Zmd4SXp+Z3Mqrwk7HqiffeMZWFmiuVn8ga4r/FGxi/H6lCgwnqVkh6ocywgadZhLFHCJrPjQwCxpb6IW9P4ktCPjB/57jFmpkVD//tjeqQLtrqSzZoNucp4lxNUGSFMA7v49IN9FL2RBcw2mqXENKMqB2GlpA2YU4yzgh5G/q5NSg6rv6+ceD4aZE6ts+cz8YoMZZsempkzctsR2abb3rsnjitRsnKBTloF2LwxRSNN9fCKj5YxWww+3N3cEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(261009223027099003)(261021121427099003)(261022105027099003)(261021123027099003)(10067099003)(56012099006)(261026140227099003)(18002099003)(22082099003)(261026121527099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHhsNGN0VUdZMHhmK0JlYiswdTQrZHg1N2VMVXBlUjZKbnAvdnB5cm1KZ203?=
 =?utf-8?B?KzlnemxFd1JNTW5rbC9pdmRkMS81QkdlR3BmbHVGcXNHSjJlZlp0V2h2cFFB?=
 =?utf-8?B?NFJXd3Yzd1VZQ0NKZ0Z0dS8zbmxQV2tjMHljcHk2emwxUFVrMnhGRFhlRDlU?=
 =?utf-8?B?WWRZT2k3aFVrdWJIS0QwaVhoVHNXcDZxZWJlbzR4aS9qS0dkcDUySHI5WVQy?=
 =?utf-8?B?aUZ1c2JqT3grazBwbys2UkhYeDJrdU1paG5FQndNbGFVMm83VGhCY1BDUjhr?=
 =?utf-8?B?V0VEN04yMUZVdzhVOURVQW10UGx0ZytNZnF3bFEwVEtxemxCbDRuWVVic3Rw?=
 =?utf-8?B?Q0dycmFncG0wTHVod0lBa2UweGVlbDIzZ3YwZ1hXdzlKS3Z6d0oxdUc5K2da?=
 =?utf-8?B?cStKUHJTTGpMdlNiZGdsR2ptb2lXcDNaK2FjWHkvY0JSQmM5S2FpZytmT0N0?=
 =?utf-8?B?bmRSMEwvRU8wOUpnTnJidTVWcDlFWmZkdlVEZ2cxZy9GdUdCNVdkNzZsN3Bw?=
 =?utf-8?B?ZFhna3pGWFppb1FEZ1FHMTVkSlp6ZUZqT3JaMkQrQnFjYWJzS0xTTEZDVlFa?=
 =?utf-8?B?SmZUdnFiNk5yemFYdWJQOUUvQlZXKzVnRnBZMWFYYnRZZjZmZ2REdThGamp2?=
 =?utf-8?B?bUZnY1dHUENwTlBkeGc5RzhoeVV6YkoybFREeU95MC9VLzRnY0lJd2Q3dGRo?=
 =?utf-8?B?eGtTSFlzb0M2cmowb0k1MUlHTmtKY0g1Yml4N01ycmFCaWtJaEZTc2tjU2Ry?=
 =?utf-8?B?OUNsTElBZWhNbGxIbGRoQTdIbjRFUlVBbEw1ZEJjSWM5UXE3TGFlaWplZm5G?=
 =?utf-8?B?ZGg5dVo1WWRTQXkvK1pxOTlWb3NjZlA4QkdMWHBaY01XUEZuUUFUNGhvbGpR?=
 =?utf-8?B?K2JyTVBxeFYrdzBKZ1RGOEpmZUNIRlRlenFZSUZNTDJzdHRnMFJ4M1JmQVZk?=
 =?utf-8?B?MitVZ3djR3IwT2F2cGpaTWx2cS92OWI0VUdUbFNreTRaWkpuUmFDWTVnME90?=
 =?utf-8?B?MWUxUDFFOTV2ZCtGOTR4SlRDdS9SNlJlcnNvelVyYk1od21wWnJ5NytNK3pn?=
 =?utf-8?B?SlZreWZWWDJ0aThhLzI1SlR2dkIyUXMxbVNabmxCQnRMVThIQW1EYjl6QTFR?=
 =?utf-8?B?eXk1clkydzZwRlREMUl4ckFkcDdqbWRnZE5xbnJ6enFDUThRUWJxR1E3YzFR?=
 =?utf-8?B?WisyL1pGTjExM2VpM0xpeHgvWEhBZTd4NTBNSkxFdEpqeSt2dTh3aFpiZGZO?=
 =?utf-8?B?WkZzYlZuNDlGMmNLTU5rd0c2bHJHM01vVHhBcGFjRkl3YjQwZ0xoOHV6cVU0?=
 =?utf-8?B?K0RvMVRqb1Bicmt4TFZ2T3FLWjVwSnQybFZOUFlxS2sxZzcvMWo4akdYQmd5?=
 =?utf-8?B?cWNmZi9UUWY1SDgyVStja2RFb3NndGZQRkFQTEJHZkRTS1A5Nlk3YUl4Nk44?=
 =?utf-8?B?RXkweGticzNVd0NZY1YxWVJLT00wQVBCcVdNZngyS0hxdC8zSlFEMXJCZlR5?=
 =?utf-8?B?aU1XUURua1U3MU5JSVVFV3ZLNllwaEdUVFJxR0JqV0NGM21Tak5LR05vZkl6?=
 =?utf-8?B?VlRhZS9TYVYwbGlzK1I4ekZ5VzJFK2ZDSnRZandYbXh0akNmRStZNyt4Wk40?=
 =?utf-8?B?Vmx4TTJhSFd2QWtRWXF5T2VsdWRmWUcxNllNcnFWWWdzYWpSMC9FUmd1Zit1?=
 =?utf-8?B?blAzZnlXV3Vrd3dwTXJ0YU0zaGU0RGJXZWRSS2ZqZG54TzR5RXNRQ2VCcU5Q?=
 =?utf-8?B?TEloWlJFVUNPZGZoQktESENoSVlUTWRDajdhWWprZ1FHN2pTeHFUUTlzVTRo?=
 =?utf-8?B?RVhLOWpvak5HMHNkRVJwU2dXODd5dHBqSHhTay9PbnNpWTdjemdINk4zclNN?=
 =?utf-8?B?VFdOSjF3UUM4NEszV2MyelBRNE5hZmZBVXpMelZzS1FMUENJZnBXSm5kSUZM?=
 =?utf-8?B?NmVpM1AvWmxZRjdhQVJLamhaY1NvOEVTUEVUZStkdVFNTkd1MzRYUWdiL3pR?=
 =?utf-8?B?c25iQ29WMEl3K2l6K2FFSCszQkdRMjA2SlZsc2pTNU1ZQy9vUmEzUmlxNWlu?=
 =?utf-8?B?YzNPR1pTMWw2NndGYVpQbVVYNlVybmk0THlVWUxTZ1VrdTdZNmVYQUVnSEk0?=
 =?utf-8?B?RkduZ2JWdjVyNXQ5SGhZc3BCVHdLSEZqVTVwSnBzSk81Ry9HalZBUGxNUlIz?=
 =?utf-8?B?aTFYRnp4dHBSUllHZjNzN01YT2dqTFhiMHF6ZkV6SDU0eDhGM05PbTVBcENh?=
 =?utf-8?B?a2M2akt3ZW13Uk1EM2thc0g2dFBSdFZPeHowbytnV1plK0daNDZnR1Qvc25x?=
 =?utf-8?B?UnZpVjg5QzM1QWRrM2NBTHRkemRJek5iQ2M5S3VzWlppSmFlaUxCb1ZVMVFn?=
 =?utf-8?Q?xGy430s+3ddd/tjI=3D?=
X-Exchange-RoutingPolicyChecked: jhCB03y1sPZw1u01+4rzvJArFuwRLjgtS+fGYkNQ7Le+g048S7cz4jgzlD9oXGdACQcR6rgt3rHZKi0CBNz8zQgdrwjkVmQYnfaI+HRPJGcUgNhinaKYwDWTdrOADx4cBlIn7qC1cgCPM7K3M7g2ADWyx/J0bXMLHzzCK/I1RgV4ByjGrbb1NPd9x8acKVSeMS1Sdkd7ObMkHy7vkWrsTbSqlbulo9WK/v4/tGs94v85BTymqMp7DcyBxmH2hjweh1NqELk3CKAozXXNXNlZ67Ys3LQ31GveI8nFzoOd7hFP3kelFhcnelzRBzrWcs+LWyBW34VVpjJZ9ClLCUZXVQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: bab204ab-ac4b-4beb-a177-08df3381ec17
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 16:55:21.6263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7W1ar93FHV6ZvaXmS4+IcWnsYQiYr7fKJvJt6phqukLWTYYbhy7C8IEqx3GiXQiiBgOoFS9KpAnO/3TjWsRgg0yv3tQ4ZoCW4A5lmCind08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR11MB9562
X-OriginatorOrg: intel.com

Hi Jinjie,

On 10/26/26 5:14 AM, Jinjie Ruan wrote:
> 在 2026/10/20 6:07, Reinette Chatre 写道:

...

>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index 246560247a28..ce5519635c51 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c

...

>> @@ -542,7 +542,7 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>>  			   enum resctrl_event_id eventid, u64 *val)
>>  {
>>  	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
>> -	struct mpam_resctrl_dom *l3_dom;
>> +	struct mpam_resctrl_mon_dom *l3_dom;
>>  	struct mpam_component *mon_comp;
>>  
>>  	if (!mpam_is_enabled())
>> @@ -551,7 +551,7 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>>  	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
>>  		return -EINVAL;
>>  
>> -	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
>> +	l3_dom = container_of(d, struct mpam_resctrl_mon_dom, resctrl_mon_dom);
>>  	mon_comp = l3_dom->mon_comp[eventid];
> 
> Maybe following code could be extracted into a helper
> 
> 553 >-------if (!mpam_is_enabled())
>  554 >------->-------return -EINVAL;
>  555
>  556 >-------if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
>  557 >------->-------return -EINVAL;
>  558
>  559 >-------l3_dom = container_of(d, struct mpam_resctrl_dom,
> resctrl_mon_dom);
>  560 >-------mon_comp = l3_dom->mon_comp[eventid];
> 

Below shows an example of such helper created (for convenience) on top of this
series. Only compile tested. Is this what you had in mind? If it looks ok I will
rebase to the beginning of this series as a new preparatory patch since it refactors
code adjacent to this series.

---8<---
 drivers/resctrl/mpam_resctrl.c | 62 ++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 61fbde9c0960..d75954f8a0ad 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -7,6 +7,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/limits.h>
 #include <linux/list.h>
@@ -536,26 +537,51 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 				 closid, rmid, val);
 }
 
-/* MBWU counters when in ABMC mode */
-int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
-			   u32 closid, u32 rmid, int mon_idx,
-			   enum resctrl_event_id eventid, u64 *val)
+/**
+ * find_mbwu_mon_comp() - Find the component counting @eventid in a domain
+ * @d:		The monitoring domain to search.
+ * @eventid:	The event to find the counting component for.
+ *
+ * The counters reached through this component are the monitors MPAM
+ * pre-allocated for bandwidth counting. Cache occupancy is not counted by
+ * those monitors, it is read on demand via resctrl_arch_rmid_read().
+ *
+ * Return: the component counting @eventid in @d, or an error pointer when
+ * MPAM is disabled, when @eventid is cache occupancy, or when no class was
+ * picked to count @eventid.
+ */
+static struct mpam_component *find_mbwu_mon_comp(struct rdt_l3_mon_domain *d,
+						 enum resctrl_event_id eventid)
 {
-	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
 	struct mpam_resctrl_mon_dom *l3_dom;
-	struct mpam_component *mon_comp;
+	struct mpam_resctrl_mon *mon;
 
 	if (!mpam_is_enabled())
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
+	mon = &mpam_resctrl_counters[eventid];
 	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	l3_dom = container_of(d, struct mpam_resctrl_mon_dom, resctrl_mon_dom);
-	mon_comp = l3_dom->mon_comp[eventid];
 
-	return read_mon_cdp_safe(mon, mon_comp, mpam_feat_msmon_mbwu,
-				 USE_PRE_ALLOCATED, closid, rmid, val);
+	return l3_dom->mon_comp[eventid];
+}
+
+/* MBWU counters when in ABMC mode */
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
+			   u32 closid, u32 rmid, int mon_idx,
+			   enum resctrl_event_id eventid, u64 *val)
+{
+	struct mpam_component *mon_comp;
+
+	mon_comp = find_mbwu_mon_comp(d, eventid);
+	if (IS_ERR(mon_comp))
+		return PTR_ERR(mon_comp);
+
+	return read_mon_cdp_safe(&mpam_resctrl_counters[eventid], mon_comp,
+				 mpam_feat_msmon_mbwu, USE_PRE_ALLOCATED,
+				 closid, rmid, val);
 }
 
 static void __reset_mon(struct mpam_resctrl_mon *mon, struct mpam_component *mon_comp,
@@ -598,20 +624,14 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d
 			     u32 closid, u32 rmid, int cntr_id,
 			     enum resctrl_event_id eventid)
 {
-	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
-	struct mpam_resctrl_mon_dom *l3_dom;
 	struct mpam_component *mon_comp;
 
-	if (!mpam_is_enabled())
-		return;
-
-	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
+	mon_comp = find_mbwu_mon_comp(d, eventid);
+	if (IS_ERR(mon_comp))
 		return;
 
-	l3_dom = container_of(d, struct mpam_resctrl_mon_dom, resctrl_mon_dom);
-	mon_comp = l3_dom->mon_comp[eventid];
-
-	reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmid);
+	reset_mon_cdp_safe(&mpam_resctrl_counters[eventid], mon_comp,
+			   USE_PRE_ALLOCATED, closid, rmid);
 }
 
 /*
---8<--- 

>> @@ -1770,11 +1723,97 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
>>  			return dom;
>>  	}
>>  
>> -	if (r->rid != RDT_RESOURCE_L3)
>> -		return NULL;
>> +	return NULL;
> 
> LGTM
> Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
Thank you very much.

Reinette

