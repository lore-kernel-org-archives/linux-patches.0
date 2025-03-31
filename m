Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6DB21480D
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743438015; cv=fail; b=KMHcF5owba1JKDCXBnLeLx9YjyuuMzAJCneZz/qAD1YUGwSCKAPR03CeD5anc85j73/k9h2PMWLsKRwOynDQl+02RkbP43qFDzyfdaypF0G6mPa4NHjjpK4Nl5nW2hBpkYNaEbc4H17xcc+Wc6RdKL7RkoHJTor9Cc0rE9jzN1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743438015; c=relaxed/simple;
	bh=qe1oiewwiqOGQSxpU43ZheGNEvQ4BoKy+P1BU6wdARQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WiggSktaXMR3+Gi93xGtumVb+vducyaWFsTKpwoHto/gxsmAj4HeY5GdVEQkDXfZEgySuVQeLaTQG2ffTcRCtB7xGnLxTb1sRe/637Qv+xcS9RSX5rbCq764puR0g38/n5zL5Q7ZV5CZr7FDJt2ExyIreyJxTr4hIRedMZBWi8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PauYYm+e; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PauYYm+e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743438013; x=1774974013;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qe1oiewwiqOGQSxpU43ZheGNEvQ4BoKy+P1BU6wdARQ=;
  b=PauYYm+e/Prf/NiEaelL8AK83KisfpHoT6+ysNU+cG7P4gmETypcNKGQ
   LxLnHloghyX6oZgIAtZQNcAQUuq96xV2FO1SeNrGkR3lHUedz4sXCSGhv
   2g/QePlzrThE0BWzxUYK2ifM8pXC32pKNWmpxVJ6pDlHgsZ7aNsGo0xcw
   OaVEynRNv306yv0puweZlqT2eorwby3v0NrfqvJb0Gk3syv5ohQ4sYBbp
   aQVnmBpy4OyyNeAQCyoiU0x8yliKTp7ffclrQTU7FQEl/l0mT5gFOvrNV
   eP6Yv/rG6Xuiia/idS2hGwZAnelcCwUp3WP1YhQ/xnbtSJsCfdNbLZY4q
   g==;
X-CSE-ConnectionGUID: 9k0mdBBxTRirgN6mYEkuew==
X-CSE-MsgGUID: tgeQKX0tSB+nlkZfxDgQvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="48604108"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="48604108"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:20:12 -0700
X-CSE-ConnectionGUID: c3XEkMUgRBuACorse6EvwA==
X-CSE-MsgGUID: x3w7ETwiRHK8/+1HgI4Ceg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="125952452"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:20:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 09:20:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 09:20:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 09:20:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPYBBkNbfAz5KANA05AV5JY+gcSUUPALQYhu4zpczAF0SaTRos1DwhZ4CV5FdWGa0w+dyYRAYsCW8f2WZckn4WgYriEQRto/lnB65hMmSRgORMzXikCJanym1b9D5oboR3c65TazZkJzdkWfCJaUirRJkGTkcjmdf7GYkmYGFmJqn8CJlu+/SEaSt+SqLNp0yVEInQikPd3Yq3LtBtAK/vOvHq4h33ArSxaL2TDv+/0sRqRa/UiNsIkZnuyngl8/LvQvF2V7VnwNH/3/rUZKM8MFIlFuOriABYHgOH1dxAoAT/ssmxMM6R20+Zj8z2KQ+awp14F9ssmbuqPjC8ZYxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWIP7+uIsEYQSyCBiYDI4KJhd0n6HyopWz07lnGMH6w=;
 b=GxBcHpaBnB91F6H91TMpfkxNO/Pnb6k0TQdiEmTDJW5l7Ckrmel+tDO80mNT91ETlIKTE5bp3uaVXbACbZBZjqSOpEV6Sgo9ePFFxEU3WP3ug/D/NMyS7guG5nfOAnxtWrAzjeng1vAaMG82W1z3f9DgHc+6JoLTei7QAEbIQeXG6PZ2oVCJLPBjRuhktlslGDn/SCIBdJmCehlwB+C/zNJyTWvtf7xJz59Ssd8TaFDNy3CeINCLvCqVu/oU8NxXwBvzrR36Uex9fpxsPl7dohsUphWGKPatm5BlKJ/F2UBUV6YK29oac4WnAuoEct59tl7IIJ+fwPVjqatDUFAgCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4722.namprd11.prod.outlook.com (2603:10b6:5:2a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 16:20:09 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:20:09 +0000
Message-ID: <8e4b51cc-9405-4505-8bd3-07d46f246efa@intel.com>
Date: Mon, 31 Mar 2025 09:20:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/16] x86/resctrl: Add initialization hook for Intel
 PMT events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250321231609.57418-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:303:b6::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4722:EE_
X-MS-Office365-Filtering-Correlation-Id: e9303c30-8299-4ed6-7d83-08dd706fe7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?REloVG00RVVoWEh0WGt3UHBNUWJiYU9wTHhRb29DQU9DS1dnK1JzNnlOdU5o?=
 =?utf-8?B?WkNZaFAxb1lvdmhpaE9sclNPNzVtczdGSEFJa28wOEJpWGxEVnM2akNwV0Uv?=
 =?utf-8?B?WFhXL0FhRVZTOE5KOVlYNTZvYUJYRXFraUl2bUVCVE1VckJ3SDIzWkNzQjd1?=
 =?utf-8?B?cHBuNjdSVUUybHFTbUsvUWlEYnAyN1dwb2lHNXEraEUwdVhnQ1VRbFRsREtC?=
 =?utf-8?B?N3dERXVwTUphMDdLRUtMeWl1ZlBabFVmaGNyMHBSYWRScVpXcEk4Q2p0NVdj?=
 =?utf-8?B?OUFPUjZiemsrUUNoZVNxbDR3UkgwRk1OeE5zemZBaEN0WXBHNGVaYmJja2pl?=
 =?utf-8?B?NXBRb29MOVViL2xyNTNmMGV2d1F3QTJCNjVWdFRBOTd4dDJ1WHk0RFZmTlF3?=
 =?utf-8?B?TmhsMnNUVjQ5VFR0UCtaclluVnFVZ2syYTFIc2tTOXVrdVQzSk0wb2V6cnZP?=
 =?utf-8?B?TzE4OEZ5VW42cmZmZ0JNbUIrajNGRTFkL0xHT2U0MzJxcFd0c0c5OG53emxG?=
 =?utf-8?B?RkxrR29TMDJyZDBFc2VGMTB5Z2dJR3ByaithYVJBVVIrbEpGYkJZb1lORDly?=
 =?utf-8?B?b21sa3hKeHl5QVA5Tk9PaVNENjkzejhXOEZOaDlxRWxnYUlUU255TU1ZTTQ1?=
 =?utf-8?B?b2pGS25oYnJvZjV3bXFtcVg0ditleDhJTGJieVlrdlp1MzYyaWhPMnowYWQ5?=
 =?utf-8?B?amZsMEdHdDhjbldZdmo4NWpYTXJMcEwrUzVJUVpiOGs4REZiNWR6bjNZQTdG?=
 =?utf-8?B?SUZ4bEVJV2p1YVdmbitMOVlSbEVYL0dNd0lRb3IrTDBQbGQ1dnZLU0hXM2Vq?=
 =?utf-8?B?Z2JYUjdjRXAvOGlNTml3SXlJVWRyNDE4MEJNT2QvcWlXWTE4Uk9qenhJOXk2?=
 =?utf-8?B?dmNWci91ZU1sMmhaeXhXNnljbUhzZVhxTnpCTTcyb3o0bFZFbTBLYi9FeDNC?=
 =?utf-8?B?OHp6cU91b1RGcVpsZW16ODRGM0Jad1Y1UTNFd05RVHJtU0t5eXlnb2ZBQnN6?=
 =?utf-8?B?aUowOWFxWmRZMjl3dkFPTjE5R01PZXdHTG1na3lacXBMQUhuZERsQ0NXRUlC?=
 =?utf-8?B?b2JUZXdhVVRFOXJFUE5udGYxejk1T1ROamQwaDlGTDM5QTdEYTlMeTdXbEla?=
 =?utf-8?B?U09yRFR5VFk0SWUyU1NicDhaVVdDMFMxRDJab1lLMWlpQkRod09JUFNVa0or?=
 =?utf-8?B?dWpOTzViVS8wWnlyeWZpRVZZMGVGWTVtM0pUcEU5VTlEYytYcm5KbFFDQTQ2?=
 =?utf-8?B?OEdPa2RITWNSZDV3OEZJMmgwSW9XZlhVK2xwLytYNmpCM1ZGd1o5ZU90VjJ4?=
 =?utf-8?B?SmMrcWtaU1hmY0FweW9heDNYUDc2bFFGSlZtZEsxeXFicW1IWUxQR0tySk9p?=
 =?utf-8?B?bVo3MGtiKzYrb3hZZDZYSDVOQUx3MWtkdVYyMmhaczhiMDdzYUJEazNURzJx?=
 =?utf-8?B?bjVTNFNZUTBySFptR1dBZHkyWlN5OXJ6R0I0eFlpd3BJZjhJVDVOV21seTBi?=
 =?utf-8?B?dUV4c0ZoYmdFYUhmcXo4NVNPSXc0bEVzNkNIc09NdmR0TzVFZU1hQU9wOFRZ?=
 =?utf-8?B?NDQ5Q3R2VVRyQUVtc2lrbWZ6ejA4ZE5PN0xGZ1ZHSk1DbEJMNmY4cVdjdlNm?=
 =?utf-8?B?WncvTDk3dW9weXFTNmxXTVlaZnl5RXNVdXNOcEFUVVF2cWFJZDFIUU9OTTMx?=
 =?utf-8?B?THF5ejlsSmxEbHcvS1AyNzFwSE5sUjVVdlpYL0h2VUIrSmZaTWhvOVVQQTV0?=
 =?utf-8?B?V2huejBlSGdXd3RwK2JkQnZCYkRwUWZSWWFDNkhCSkd4SGlXZUxPdld2UDh0?=
 =?utf-8?B?U0pzRWNGSWxCUU1ZcmY5cnRxZ0daL2ZpZVM1Zm5uSXdpaFNCemxUV3pFaSta?=
 =?utf-8?Q?coArfc+w8XSRm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Unh0bElNR1JlckJtSkdMY0dGWHNXUjFnVi9IM0JpNTBiQ2c1Z2dmNmd2elVH?=
 =?utf-8?B?MTZCMTJZd2lmaHNOdXZENUtRWFFpTkNRc2FWSTEvclM2M1N6MEZjbDRaU0tp?=
 =?utf-8?B?SHNBb0JyZ2tadjMyNmU4YU5zTnl4d3l5SXNUL20wWkRYbVFiQW1hY2RXMkVu?=
 =?utf-8?B?ZHREa1J6SnhyUG1JTThKQjlGVjQwY0M3OFpzeFQyQXV3K1I5M0hvanNubGla?=
 =?utf-8?B?dDVVb2xVRkVad2x6RGJQWDk5dnVhdVNEbG1idGxsbGRrUmRPZWVvYnVZdVdG?=
 =?utf-8?B?QkFHZ09xSHBGSjZ5OTZxdDF3T2NGU2xIUWdDZVk3K2tkbGRWaUJ0bTk2Y2Vs?=
 =?utf-8?B?eHdOdGdUTXhXa2tMT1hnNGhzRFMxWkFwVmpSa2wwTTNtcVZITUs3WE93b3pU?=
 =?utf-8?B?Sm4rdHpZVWFCUEwxWFMramt0RG1kdWJsOEJYYXhSd3B6NVNXQTFhY1BUTHlP?=
 =?utf-8?B?c20waUFuLzVsSEpUYVlRS3Ard1dEbUc5NW1sSXBHa1FFTXlRNXRMSk9DdndG?=
 =?utf-8?B?Z3JSSG5mTE5nZVNSRkprTEMrOUhqNDdWSWw5NllUTjdDcnBlYk1MNngwaG0x?=
 =?utf-8?B?RVFRSWNhNDg5WHRoQTlFR0N3Qk9qRFpnL3BmSHE5SnlrRC83a255cC9aSHlC?=
 =?utf-8?B?a0JYWjRlbk5IaFpqbWgycTA5QXJQVlhHLzZ5RXlqWkpZUEV3WEY2ZUkrTXE4?=
 =?utf-8?B?c0ZiTiswcEg4ZkNzTkRKSURjQXBkTkh4OE5NYSt5b2tzb0l0V2NMR2sydGtG?=
 =?utf-8?B?VW9KL3VpZFdXZTN0TU5WZmpGNGxnME1RWjlmM0ZmVFhNRUs5dmlyRkJnQWNj?=
 =?utf-8?B?cDJ1Z2t0UktFeXFoR3hvWnlCVndBbkJaVFpuYlg3L1Y1RGo0dnNFS1M0TkUw?=
 =?utf-8?B?VzM0UWtVc0pYNGh3Y25qZVRSN0xSWU9Yci9ucXpiRWkrRWFxK3NNRk5qQUZB?=
 =?utf-8?B?NmJ3RkRsQy96cHNNR0pvWVcvYXJzOXNaOUpwR0NkczZrcEhsNFpDdlRSNHpE?=
 =?utf-8?B?NC9oS1YveW9naTRQU2I3VERiVndpcC8wVE9idjdqOGVMYWQ1RXBsQy9lT3J2?=
 =?utf-8?B?Q1BVVHR2NmhUOTZWUndqUjVvRmdLSkRsRlcwc1ZQajVQNVArMCtSZHVDWWk3?=
 =?utf-8?B?V0ZTNnIwV3dMRW02TGpBazBsOXRWV2tNYWxPMDFyTHRZYm03Y1lJTEorRzZ0?=
 =?utf-8?B?Mk1YNjJpV1BkcXRPN0dJMC9uRC9ydzMxUGowZlAxZzI5dnJrT2ZtRVJEcThJ?=
 =?utf-8?B?bHBqQ1BaNmZQdS9rQ3dsQlpOVjk1dGV3TXlxR0hQTXZwMlFvL1ZpdUhIR2VC?=
 =?utf-8?B?V05TeXNvQWRTTFFMbkZNWnh3b0FpMVI3SnpyT2RqbjZ1eXNCQk1NNE11Rkd1?=
 =?utf-8?B?YjNHdkxIMXcrQ1NIbjc1c1gvV0JSRitValBiS1lxNE1uZlNUc0VjZkg4dURJ?=
 =?utf-8?B?dXBGUFJ0T0VVQkNvRkNSZGYxa3RkSEtvVW13VnhYNWdWSk1mK1VKNEMyd0VF?=
 =?utf-8?B?QTc0cVo3UFZBaUdCUE9ydHN6OTVxdVlJcEkyQ3Y2RnYwbDhvOWNPR0plOEJv?=
 =?utf-8?B?c1lyaFArejQ4cUpObEw0TzhyMnJXT0I3bGE4T1pGVzNnSmRFOU9VcTlndHNu?=
 =?utf-8?B?dkVGV2VGekVYUW8wS0ducVovbkZHTFFjdlc3Y0hTMUc5K2d2ZWYvaGlIZ3lE?=
 =?utf-8?B?dkJoOVd5YTZXZ1NYN3cwM2JaWHkrYS9zUjZoU2xEM3pMNVc5WHM3Y2RBZGwz?=
 =?utf-8?B?ZzM4U2hMYTI2OUVrUWdiVGVpZnVKbVZ2SnFLeXFUR29Bb2d4czBETFUyTWsy?=
 =?utf-8?B?TVY1MVhlRzF0UEhUa2F3bUxrRDQ0WExLZVNMT3FtR1F2UTFNam1OZFgrRmxk?=
 =?utf-8?B?dytOWFowNjRGczg0YjZ5SW9XRjFIRXY1b1Q4dFUzWTZVZWpwdzkrUmhwQ1Vx?=
 =?utf-8?B?TkRtcWRmQ1FsVG8vdDlIb1dIUUh1SWRJTFpsckJKYlJVUjlGNHB4Y0FZak9G?=
 =?utf-8?B?cXJETWpseWFxWUM0bTE0MGRDdkZ1Qlk3MDJQV1JqUytXQTM3S0FOZzh5WGgv?=
 =?utf-8?B?cENYd2JGeVBRaUdJZEw0M1V1OUF0WFhtYjc5S2EvdDh3RzUyWTlSWFJWVW9F?=
 =?utf-8?B?UlRJWFg5K2hpVFM3TU5PT2Y0MjdFVnNMTFJ2NjJ6cGxrd1AvZFZaMFJHZlI2?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9303c30-8299-4ed6-7d83-08dd706fe7bd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:20:08.9464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dyMEQfznsvKF+JjnPEKw9yv44P5CphhmDP2o5vHuxMvTgDQSxUNR9Jfyv5JBQhmFDQrOCYgQyuiG66KPHq/gFtLFbL3E954Afbmd3284AU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4722
X-OriginatorOrg: intel.com

Hi Tony,

On 3/21/25 4:15 PM, Tony Luck wrote:
> Call the OOBMSM discovery code to find out if there are any
> event groups that match unique identifiers understood by resctrl.
> 
> Note that initiialzation must happen in two phases because the

"initiialzation" -> "initialization"

> OOBMSM VSEC discovery process is not complete at resctrl
> "lateinit()" initialization time. So there is an initial hook
> that assumes that Intel PMT will exist, called early so that
> package scoped domain groups are initialized.
> 
> At first mount the remainder of initialization is done. If there
> are no Intel PMT events, the package domain lists are removed.
> 
> Move definition of struct mon_evt to <linux/resctrl_types.h>

Why not include/resctrl.h?

> 
> Events for specific systems to be added by a separate patch.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  14 ++
>  include/linux/resctrl_types.h           |  14 ++
>  arch/x86/kernel/cpu/resctrl/internal.h  |   6 +
>  fs/resctrl/internal.h                   |  14 --
>  arch/x86/kernel/cpu/resctrl/core.c      |   9 +-
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 211 ++++++++++++++++++++++++
>  fs/resctrl/rdtgroup.c                   |   3 +
>  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
>  8 files changed, 255 insertions(+), 17 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 6c895ec220fe..999e0802a26e 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -170,6 +170,14 @@ struct rdt_mon_domain {
>  	int				cqm_work_cpu;
>  };
>  
> +/**
> + * struct rdt_core_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource

Please no arch specific references in fs code. I think it will help to explain and consume this
work if patches are split into fs and arch patches.

> + * @hdr:		common header for different domain types
> + */
> +struct rdt_core_mon_domain {
> +	struct rdt_domain_hdr	hdr;
> +};
> +
>  /**
>   * struct resctrl_cache - Cache allocation related data
>   * @cbm_len:		Length of the cache bit mask
> @@ -522,4 +530,10 @@ extern unsigned int resctrl_rmid_realloc_limit;
>  int resctrl_init(void);
>  void resctrl_exit(void);
>  
> +#ifdef CONFIG_INTEL_AET_RESCTRL
> +void rdt_get_intel_aet_mount(void);

Please no arch specific helpers in fs code. This could instead be a
generic "resctrl_arch_*" helper that resctrl fs calls at beginning of
fs mount for architectures to do what is needed. 


> +#else
> +static inline void rdt_get_intel_aet_mount(void) { }
> +#endif
> +
>  #endif /* _RESCTRL_H */
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index 8f967e03af5a..d56fcd082d2c 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -57,4 +57,18 @@ enum resctrl_event_id {
>  
>  #define QOS_NUM_EVENTS		(QOS_L3_MBM_LOCAL_EVENT_ID + 1)
>  
> +/**
> + * struct mon_evt - Entry in the event list of a resource
> + * @evtid:		per resource event id
> + * @name:		name of the event
> + * @configurable:	true if the event is configurable
> + * @list:		entry in &rdt_resource->evt_list
> + */
> +struct mon_evt {
> +	unsigned int		evtid;
> +	char			*name;
> +	bool			configurable;
> +	struct list_head	list;
> +};
> +
>  #endif /* __LINUX_RESCTRL_TYPES_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 521db28efb3f..ada402c7678b 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -168,6 +168,12 @@ void rdt_ctrl_update(void *arg);
>  
>  int rdt_get_mon_l3_config(struct rdt_resource *r);
>  
> +#ifdef CONFIG_INTEL_AET_RESCTRL
> +int rdt_get_intel_aet_mon_config(void);
> +#else
> +static inline int rdt_get_intel_aet_mon_config(void) { return 0; }
> +#endif
> +
>  bool rdt_cpu_has(int flag);
>  
>  void __init intel_rdt_mbm_apply_quirk(void);
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 422f36573db7..f5a698b49e97 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -67,20 +67,6 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>  	return container_of(kfc, struct rdt_fs_context, kfc);
>  }
>  
> -/**
> - * struct mon_evt - Entry in the event list of a resource
> - * @evtid:		per resource event id
> - * @name:		name of the event
> - * @configurable:	true if the event is configurable
> - * @list:		entry in &rdt_resource->evt_list
> - */
> -struct mon_evt {
> -	unsigned int		evtid;
> -	char			*name;
> -	bool			configurable;
> -	struct list_head	list;
> -};
> -
>  /**
>   * struct mon_data - Monitoring details for each event file.
>   * @rid:             Resource id associated with the event file.
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index c8cc3104f56c..1ab0f5eec244 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -882,6 +882,7 @@ static __init bool get_rdt_alloc_resources(void)
>  static __init bool get_rdt_mon_resources(void)
>  {
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +	int ret1 = -EINVAL, ret2;
>  
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
>  		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
> @@ -890,10 +891,12 @@ static __init bool get_rdt_mon_resources(void)
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
>  		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
>  
> -	if (!rdt_mon_features)
> -		return false;
> +	if (rdt_mon_features)
> +		ret1 = rdt_get_mon_l3_config(r);
> +
> +	ret2 = rdt_get_intel_aet_mon_config();
>  
> -	return !rdt_get_mon_l3_config(r);
> +	return ret1 == 0 || ret2;
>  }
>  
>  static __init void __check_quirks_intel(void)
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..9a8ccb62b4ab
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,211 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/cpu.h>
> +#include <linux/cleanup.h>
> +#include <linux/slab.h>
> +#include "fake_intel_aet_features.h"
> +#include <linux/intel_vsec.h>
> +#include <asm/resctrl.h>
> +
> +#include "internal.h"
> +
> +static struct pmt_feature_group *feat_energy;
> +static struct pmt_feature_group *feat_perf;
> +
> +/* All telemetry events from Intel CPUs */
> +enum pmt_event_id {
> +	PMT_EVENT_ENERGY,
> +	PMT_EVENT_ACTIVITY,
> +	PMT_EVENT_STALLS_LLC_HIT,
> +	PMT_EVENT_C1_RES,
> +	PMT_EVENT_UNHALTED_CORE_CYCLES,
> +	PMT_EVENT_STALLS_LLC_MISS,
> +	PMT_EVENT_AUTO_C6_RES,
> +	PMT_EVENT_UNHALTED_REF_CYCLES,
> +	PMT_EVENT_UOPS_RETIRED,
> +
> +	PMT_NUM_EVENTS
> +};

I expect the above to become part of resctrl fs. Actually, I think
all properties of the new events, the id, name and how to display it,
should be part of resctrl fs.

We do not want other architectures to create their own display names for
the same events. I expect that this will require more plumbing between
arch and fs code to communicate which events are supported, similar to
what exists for the L3 events (for example, resctrl_arch_is_mbm_total_enabled()).

This may result in struct rdt_core_mon_domain to no longer be empty but instead
for resctrl to use it to manage state of which events are enabled or not. Theoretically
all could be managed by the architecture but I think that could result in inconsistent
error codes to user space.

> +
> +/**
> + * enum evt_type - Type for values for each event.
> + * @EVT_U64:	Integer up to 64 bits
> + * @EVT_U46_18:	Fixed point binary, 46 bits for integer, 18 binary place bits
> + */
> +enum evt_type {
> +	EVT_U64,
> +	EVT_U46_18,
> +};
> +
> +#define EVT(id, evtname, offset, t)		\
> +	{					\
> +		.evt = {			\
> +			.evtid = id,		\
> +			.name = evtname		\
> +		},				\
> +		.evt_offset = offset,		\
> +		.evt_type = t			\
> +	}
> +
> +/**
> + * struct pmt_event - Telemetry event.
> + * @evt:	Resctrl event
> + * @evt_offset:	MMIO offset of counter
> + * @evt_type:	Type
> + */
> +struct pmt_event {
> +	struct mon_evt	evt;
> +	int		evt_offset;
> +	enum evt_type	evt_type;
> +};
> +
> +/**
> + * struct telem_entry - Summarized form from XML telemetry description

It is not clear to me how useful it is to document that this is
"Summarized form from XML telemetry description". Either more detail should
be added to help reader understand what XML is being talked about or
the description should be a summary of what this data structure represents.

> + * @name:			Name for this group of events
> + * @guid:			Unique ID for this group
> + * @num_rmids:			Number of RMIDS supported
> + * @stride:			Number of bytes of counters for each RMID
> + * @overflow_counter_off:	Offset od overflow count

od -> of

> + * @last_overflow_tstamp_off:	Offset of overflow timestamp
> + * @last_update_tstamp_off:	Offset of last update timestamp
> + * @active:			Marks this group as active on current CPU

Could you please elaborate what "on current CPU" implies with the events
being "per package"?

> + * @evts:			Telemetry events in this group

Since this is an array, could this comment also describe how the number of
entries are determined?


> + */
> +struct telem_entry {
> +	char	*name;
> +	int	guid;
> +	int	num_rmids;
> +	int	stride;
> +	int	overflow_counter_off;
> +	int	last_overflow_tstamp_off;
> +	int	last_update_tstamp_off;
> +	bool	active;
> +	struct pmt_event evts[];
> +};
> +
> +/* All known telemetry event groups */
> +static struct telem_entry *telem_entry[] = {
> +	NULL
> +};
> +
> +/* Per-package event groups active on this machine */
> +static struct pkg_info {
> +	int			count;
> +	struct telemetry_region	*regions;
> +} *pkg_info;
> +
> +/*
> + * Scan a feature group looking for guids recognized by this code

"this code" can be dropped

> + * and update the per-package counts of known groups.
> + */
> +static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_group *p)
> +{
> +	struct telem_entry **tentry;
> +	bool found = false;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		struct telemetry_region *tr = &p->regions[i];
> +
> +		for (tentry = telem_entry; *tentry; tentry++) {
> +			if (tr->guid == (*tentry)->guid) {
> +				if (tr->plat_info.package_id > max_pkgs) {
> +					pr_warn_once("Bad package %d\n", tr->plat_info.package_id);
> +					continue;
> +				}
> +				found = true;
> +				(*tentry)->active = true;
> +				pkg[tr->plat_info.package_id].count++;

There seems to be some duplicate information between the structures. For example,
telem_entry::num_rmids and the num_rmids from the pmt_feature_group. Are these
expected to be identical? Since the num_rmids from telem_entry are hardcoded and
the ones from pmt_feature_group discovered then this sounds like opportunity to
add some sanity checking.
Similarly, could there be a check here to ensure that the size of the memory region
provided matches the expected size based on all the hardcoded properties?


> +				break;
> +			}
> +		}
> +	}
> +
> +	return found;
> +}
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
> +	if (!IS_ERR_OR_NULL(_T))					\
> +		intel_pmt_put_feature_group(_T))
> +
> +/*
> + * Ask OOBMSM discovery driver for all the RMID based telemetry groups
> + * that it supports.
> + */
> +static bool get_events(void)
> +{
> +	struct pmt_feature_group *p1 __free(intel_pmt_put_feature_group) = NULL;
> +	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
> +	int num_pkgs = topology_max_packages();
> +	struct pkg_info *pkg __free(kfree) = NULL;
> +
> +	pkg = kmalloc_array(num_pkgs, sizeof(*pkg_info), GFP_KERNEL | __GFP_ZERO);

kcalloc() ?

> +	if (!pkg)
> +		return false;
> +
> +	p1 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_ENERGY_TELEM);
> +	p2 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_PERF_TELEM);
> +
> +	if (IS_ERR_VALUE(p1) && IS_ERR_VALUE(p1))
> +		return false;
> +
> +	if (!IS_ERR_VALUE(p1))
> +		if (!count_events(pkg, num_pkgs, p1))
> +			intel_pmt_put_feature_group(no_free_ptr(p1));

This seems to defeat the purpose of the cleanup handler.

> +	if (!IS_ERR_VALUE(p2))
> +		if (!count_events(pkg, num_pkgs, p2))
> +			intel_pmt_put_feature_group(no_free_ptr(p2));
> +
> +	if (!IS_ERR_OR_NULL(p1))
> +		feat_energy = no_free_ptr(p1);
> +	if (!IS_ERR_OR_NULL(p2))
> +		feat_perf = no_free_ptr(p2);
> +	pkg_info = no_free_ptr(pkg);
> +
> +	return true;
> +}
> +
> +/*
> + * Early initialization. Cannot do much here because OOBMSM has not
> + * completed enumeration of telemetry event groups.
> + */
> +int rdt_get_intel_aet_mon_config(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
> +
> +	INIT_LIST_HEAD(&r->evt_list);
> +
> +	return 1;
> +}
> +
> +/*
> + * Late (first mount) initialization. Safe to ask OOBMSM which telemetry
> + * event groups are supported.
> + */
> +void rdt_get_intel_aet_mount(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
> +	struct rdt_core_mon_domain *d, *tmp;
> +	static int do_one_time;
> +
> +	if (do_one_time)
> +		return;
> +
> +	do_one_time = 1;
> +
> +	if (!get_events()) {
> +		list_for_each_entry_safe(d, tmp, &r->mon_domains, hdr.list)
> +			kfree(d);
> +		r->mon_capable = false;
> +	}
> +}
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index a90291f57330..4833dfa08ce3 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2572,6 +2572,9 @@ static int rdt_get_tree(struct fs_context *fc)
>  
>  	cpus_read_lock();
>  	mutex_lock(&rdtgroup_mutex);
> +
> +	rdt_get_intel_aet_mount();
> +
>  	/*
>  	 * resctrl file system can only be mounted once.
>  	 */
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index 2c3b09f95127..a47e1c214087 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -2,6 +2,7 @@
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
> +obj-$(CONFIG_INTEL_AET_RESCTRL)		+= intel_aet.o
>  obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
>  
>  # To allow define_trace.h's recursive include:

Reinette

