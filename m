Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792683836;
	b=b7P1ds8kCKMUfy7OkUoklmMyYy4qQi1kcGF70hEQ6mXXY0fg85xIi0O3on87zWtFtrYE
	 IRVM/bibelLAKohPrZfzyvQmRdgvEiCs19KgYwqxji2xi15DOTuVCviB7yTZbHNHMYu+s
	 M5PJ/Zd7GjbmCeBr6mCEvraaMxd9NV58cOv7+uRwX38JRBsi6nBtBFA6FYOgOQf1KXadR
	 y9FRAleG9chFuyf3sCgCYKHUDXoJEGLuB9a86FNlCa7c4jy5w2/Z6ao4IFnXSwr6uE7n1
	 CMm4MQmAs5CzZmogcoi9ugnGWem1Hp/4y59wdAYENkT2dr2JdJRDc762oZsqYDx+jnA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792683836;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:From:Content-Language:In-Reply-To:Content-Type:
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
	bh=hBUvdWwu/IQIWjj/7rsldsIseaAFPh1YtY41MZTzo38=;
	b=2INN5ENwzodPD7dK3fjSrlgtMUqGMwZg0QMbj1LHRj+vGG+8OmsZnL3rlVGfesg//iyX
	 B6GMnF4AtLBL26LIDp3gEjBRDxtEM6VG1KvNWVCu7H1xF7aMqmq2Dtlv3VFsMK4XyGIlg
	 lAaf+L2MveDn12RWk/LrwfwyyXc8DeOAQdDTkuexVI5ISWBiIeevjUFbugsw4XKXqcIIy
	 ot6RXNXpcj2+Udn/+oq/M4FV3i0AFVHwBN7NO+kawH9ZknAce+HgxqeGcGOIxh4g4ZYFk
	 gCS8phWcrs1ofjOy/MM8C6yjaSLlmE8z6YAo8wu+EtJLk2V8Xcc7//jBUaYv9J4cXiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BOAepe71;
	arc=fail smtp.remote-ip=192.198.163.7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278A9606A319
	for <patches@lists.linux.dev>; Thu, 22 Oct 2026 15:43:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 278A9606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BOAepe71
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792683834; x=1824219834;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fepd3nT0kM1ZqmdUWi9qllNysmoW9TaZ35WOs0cfMXA=;
  b=BOAepe71/l/jvVyMMklFRAEQ+XFZ3AJF90/leQbqqEaTvOH6mAI5Izqd
   qr07s3/Ylc9boCp4+qt3+aawMjNf6XfVuSlXGTU1Qr01aC64qkjwod8GM
   phlTffcKic3/sMx5l6jTG+5X5wnQ0RmhHU44swMx/GwMMVrSWSY6BoFZI
   a/tB/mAjK0p8DP+VwPqxJPP3G3XTB/5N57UQ3Nw/A+tTbQOdNwOhW8NS1
   y3zP04Ka6A1rgrgaM4FIGXnVmd4akSzKadPpqQlsBJK5O+hJOMSV2dmNS
   hKAtH6Ymqi3bJ0IJfO2WeT085tf9WhFX1+XGHIrSGN1AtQaVw2ghxivBZ
   g==;
X-CSE-ConnectionGUID: EzQKO9CVT9SinboxfYdxbg==
X-CSE-MsgGUID: 2Jk/naBOSRi//+wCeB/NSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1337628"
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="1337628"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 08:43:53 -0700
X-CSE-ConnectionGUID: cb7PtmrJRFKazsJWanA/Hw==
X-CSE-MsgGUID: NF/Mjhf6QHKLrmDum+Qs/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,172,1787036400"; 
   d="scan'208";a="3743481"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 08:43:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 08:43:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 22 Oct 2026 08:43:53 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.51) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 08:43:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=whG9ZhnMEUXmXTT8HGd8mrLvtkl3rVrPkTEvHDNSN1c+X1vzs8X39Aljrb+mAnc+fkVeczqM+wH1eku6u3bIiBhMkVgBGxgjNf4tLV0xDaXnwaDpm7nhgdbZFDgKHTg+iO5+S+tyj9M1LDthe8Z4x/QIwyIypY2R3uTKPD8V0Gg8ah6q/ggfFLsTB+NB+TjaVUnx3obKr2xQPUcVT4Ndyp25tlzWnNgFNo4072UNL8nbZv7h7qFrwTbAcfz3rrAt+Ibp07Ftt5r+VXPtPe9y1IB2BEgKQMvI01uxVJwi3VAeoDM1Go/coQucQaATzhrvGhRUJjQduVA9aZv3cN8LVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBUvdWwu/IQIWjj/7rsldsIseaAFPh1YtY41MZTzo38=;
 b=u/u3c7j4+TBvXp8w7AsqLp4bumGMswaqy04Qo5VBIFUx8nxkLtR2lrp2YHq9V6bc9qkX9RzxFk+8nP1kKNR9vdEYPUO00GmQsBzzL3CWWwoNipMlwflBEajoLcfzzzztPtLB1efOiFu8kqRXsJwEu+310mQYJEhoknkdLXnCfsfUsZJ9G+oKRo0vyfICDAy6+iIAaA7KrqgBfv73eJSqy2N62xpDXtAddIuXv1G5FLXB/2qN4FAi/yirI2PrZYx/ALfzBcamw5wfYAKbPpCtvyewEzzalhlCIn4pPzfgTRuWZ8pJvF1cF+B4KkPUaZnZnu+neQ5JwIVEYiU7u4+O1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB537784.namprd11.prod.outlook.com (2603:10b6:806:52d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 15:43:45 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0522.017; Thu, 22 Oct 2026
 15:43:45 +0000
Message-ID: <7aae7beb-d8c4-4cdf-bc10-a1aebe3c2382@intel.com>
Date: Thu, 22 Oct 2026 08:43:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/10] arm_mpam: resctrl: Separate MPAM domains
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <05e5d99a-c12f-4fb9-b632-2301f21d54c7@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <05e5d99a-c12f-4fb9-b632-2301f21d54c7@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:303:83::21) To SJ2PR11MB8370.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB537784:EE_
X-MS-Office365-Filtering-Correlation-Id: 46a5cdfe-997e-41c1-1fab-08df305341c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|6133799003|22082099003|18002099003|261021121427099003|261021135927099003|3023799007|261021123027099003|261009223027099003|4143699003|5023799004|11063799006|10067099003|260925022911599003|260925021911599003|260925021311599003|56012099006;
X-Microsoft-Antispam-Message-Info: ds0eUXFoJey6hlWG8S/r0vzMtnajXUgaEBcMrd3I4WajNbLzmMbp2VoyNpEt6ip6+JxPhVFEqfSNu3T3RkCUpEQhlWEhUZSwO+QknMvxHv5JEIDj0AlbEEdy61DDn7GKybRnZew58FThY4nT0bVBybhg2WPG8RP/jkA5Bodvru1GRSKhEISSgF46gRiXXVKMlt5laNYsSvrh023UYBJ0TmREUheFBRBOJiRDrs1XMnBMWLsNtL9X0WtphWy21HoOXaMqd/1/QrxMUqFrjA6gJ0cQooJd/VXT91ZeNLt9ZvVxd/rum4SR+rnA8vInGtBcKrSEZubHVj5xC28gaO/sB3FGS1S5fjuKOKpZpgLDPRKLiZn+ejhYh2O8yehXLk+LFNQA8Id1m5tS15d1OZ4sH1NPgR5Hzd+1g+sixmzBjVRN+hojFm+tvnmFjmhnl35B9lLPM7us/Q/UTJyPHe1bGBZgQ2aeRfN7fuQLNZRYr9BIvYDgnry00dza3j5W00YFp3JPSZ+CN2g+Kcz9IAcAE90aLM3JHvB6k2dfCccN2ditrzxufw3r75h7VGBIEHJ52aGccdfLfg7Q4RdpWAOQIcXntxXYWriPKV/zRa1OZZIQDX9PYVOnNcK+mngI+84c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(6133799003)(22082099003)(18002099003)(261021121427099003)(261021135927099003)(3023799007)(261021123027099003)(261009223027099003)(4143699003)(5023799004)(11063799006)(10067099003)(260925022911599003)(260925021911599003)(260925021311599003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aURtaDFUNTczQjZxNHo2SmYzV090bS9qNklka2s0cDNMY29JZnBSNVhnZEQ0?=
 =?utf-8?B?UnduVWo0ZDhCdHpFdUxRYVZ5dXcyenhLL2RQM2FqaE1uWlNiQU1FOGxsM3Ew?=
 =?utf-8?B?b2N1OE1iRWhzUGIwaHN5UHM5SHRJdTZybkduSm1NMTRiekl5ckZPM0w2RVZa?=
 =?utf-8?B?MVRmenlDZ2tPWXhhemJ6RjJ4S3hjb21QYkhFT2FDOVFsNzVsMjhlMG9LbnM3?=
 =?utf-8?B?bWt4UDZLdFg4eXRPRitnT3ZuRGJZYjRRelFYL2hDb2wzZTBTQ2w0WjdEbGNx?=
 =?utf-8?B?Vjg5czE5YUN5eEF3OVZCQXZ3eEQrb3cxSUkwZXNyNnVtL3hreXd4WlFUNzll?=
 =?utf-8?B?bWIwUTUrejFiNEJDQyt0SWhBcWd4VC85K21SVVk4VlVEcWlITkVJcERxa2l3?=
 =?utf-8?B?MGZsaTJ6cmUvYy9QNFFmS0FMQU4yejNrM3dNUmpObkprVmVneS9mU1lGLzNM?=
 =?utf-8?B?TXBzaEFPdmM5UmVINTJLdk1MMkZwZ3FnSE5XaTRMWWRmVGNIVi9BNlZXODVa?=
 =?utf-8?B?RlZVakNNY0JMVFd3SlFQQUJQVnF1NVlaLzFkZE1WK3FKM2wyditHUVFXRFFz?=
 =?utf-8?B?NkRKVnpkeGNiL1lsUmdva2xUZStoTmJJb2VQWklQS25EcWUwOXIrZ2Q2Z3FR?=
 =?utf-8?B?K2J4SlphNXhtcjltdnlGK05xSnhmc1VGSHorWjNLbnBVOUk3K3FoVFQ5Q0p5?=
 =?utf-8?B?SUhFMXY4V2VmaDQ3dDJ4eXZLU3dvWEZ1L3JoNXZ2MEdjQUFsT1A2SDdiUEsv?=
 =?utf-8?B?RnVDaU5oMzYzbGJONTR1VElWV1VrM21ydU5sU0svN0lGeFpKeXhGQytKMjg2?=
 =?utf-8?B?bFZwK0I0MjFYaUlVNEtSTGhIaVNtQ1g2dnBSZmdlMEg5RW5kY3VYWTZvRUZK?=
 =?utf-8?B?OEZtVENoYjJhclN6cjJWZXFsNG1oUFBub3ZNUjJZYjVOb3RvUUxEZVYyc1Ex?=
 =?utf-8?B?QmU1VEJrUDRnc3dFWWo3NDJxTGJ1WVlrUFUvRURnMUw3d0JBMlVvd0hrSDk3?=
 =?utf-8?B?eXZtbnQzcEpBSkVJc2xKSm9qbGExOTljaHZuNkZpNUk2alRqMmI0VHM2TGto?=
 =?utf-8?B?bXFDN1ByOXltZGNHUU5IK1RqUEJ2UHo2aGhiOXlJOVFsUDBkbWVBL1IvYkxD?=
 =?utf-8?B?OGttVjE0K0NzV3ZkUUVySVViTnd1YVlpcUpzWVJpQVlKVVlSOGVIbkJ5SkIv?=
 =?utf-8?B?Yk5GOGlUZ1MvdlZJZTZ2WGVrYVZxQUNGUk1mdWkyS0t2aUdmbzM3NmRsbkM2?=
 =?utf-8?B?Nmg1YTBzUUhxVXp1NVcrdEVZbzl5SER6UWNqaTFVRUxlZENEek9DREIrL2lS?=
 =?utf-8?B?cExDT0ljRU1lVzdnLzdvMWtUUllFcUVBblphSHBhN0VaVUxaYVFkNFZ0ZlVv?=
 =?utf-8?B?ZkYzYnkwQS92YzN3bGNNVzZCdnJZSVB2MS9MU3dUa1p4YlVLVkE1aDhvSEw3?=
 =?utf-8?B?TVM4N29Lay84bkhabjI4TkpJNjBxdEJKQ0h4NW1KQTV0aHM0dG02Wk1vWkhi?=
 =?utf-8?B?QXFxSEdYOTM2K2NMUlpZdWpnWUZaaXZ4TFhia1E0clRXUTFMOUdicVRwaG1r?=
 =?utf-8?B?YlAvMGl4Y1duZTdhbE5IeTB4NFU3VG00bDJiT3ZWa1BnczRGS1dmUTJQamwy?=
 =?utf-8?B?NU9ua0NGK1JzT1g1NWtzSFpoUGpsV3ZzdFlpOExCby9QNHhNOEJCNnJMUFJ4?=
 =?utf-8?B?NTg2ekF5bjFnZUh0bzdUN3RGUUV1alJFdktzWlRUaWZyU1JZVXFmNzR3TERX?=
 =?utf-8?B?UElBaDJLZ3Erb1ZMRXBoajhGVEFSbTVBaXNvdVBCYzdLUGpZZG9aSkxob3lv?=
 =?utf-8?B?V1FiTEJwdGd5enJsVEYyVEg4a2U1eHNoVGpnTjNaZk9GWFRKTlFsOEZZYnJQ?=
 =?utf-8?B?TkFLTHdTZmxyYXJDSjhrQ1BCb2p0QlVRdlphNUh4U2NVb1B6UDdESHFsTkVB?=
 =?utf-8?B?WmY1NjY3b2NTaUppaFFJNmlIODNJTFpZVGNHNHA5OFJJUmJzT1JWUmxFeHQ3?=
 =?utf-8?B?YXRaRHJhOG5Sc2F2T3hSZmYwcGY1aGVXcVdzMzBsYTVvTGlWZTAwb1hqNUZr?=
 =?utf-8?B?bW5SYm5GRVQxYUw3U21QVWZiaHBmK1FuWnp5NTdWbktUV3dOMUpXbUpLSlVV?=
 =?utf-8?B?WVpzR2VsUUpkODlPdWpIQk4vNlMva2IwT2JPZFpRVTZBckllajAvWGpIb0lv?=
 =?utf-8?B?K0VqQ0ZDRFlMU08weC9GQjZqYmcwMW5ONDZyNnRtdXpnenJiNS8ya0FEaEVW?=
 =?utf-8?B?c2RYbE1HZXNPemJybmJNckhXb2ptMHAvbzIyektyZDRtT3VLRzJHY1hONjdD?=
 =?utf-8?B?MnpDd1VydnQra3Y3d1IzYlUxZzFlYStSak1GZTU1TWZpR2xNYkphSjRjdVVh?=
 =?utf-8?Q?Ngy0hpC5fppl7JHw=3D?=
X-Exchange-RoutingPolicyChecked: Sk958GwgcZeMOn7iMqac7N6KqUhn1uRKEJTCPROsgXSq0zPcrXqN2ZXeP4CmHRulZ2IadP2VQKtVRuzHaAmiWUStPC9ZB/VKzieQKcDg8hOAu+K691F4spNC7q+k6bcc745fTTQIwA6tIKEC0M73kE0ickRQ+4OsBPuaxFkdybBAudcjr7bkoCNLnXY66xnpMuNydLmDjuFgKbfEJo9oiR5q01irlhHe2KKy/jypvl6hlzRKXtBMM0q/VK2YF3QzEwJZ/44/h0TqQ8s/4S+KzK8pjUhp6WBEHJ1MSPFEDV8MQ7+0RI5ZmxblZRFbcqcyUpe6eAe3VaT8gvQ3UE+EWg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a5cdfe-997e-41c1-1fab-08df305341c1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 15:43:45.4868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/ZLWD96YXJEpusMyRgWYyB6J8a1ALb2D8fa0UdE6aYPkeWni8rcTG2EE9+TvJ9fdPBW/PkF1oGU2FRHWd2/WqY+8Bso9mAMH7BeRAUnscU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB537784
X-OriginatorOrg: intel.com

Hi Ben,

On 10/22/26 3:45 AM, Ben Horgan wrote:
> On 19/10/2026 23:07, Reinette Chatre wrote:
>> RFC v1: https://lore.kernel.org/lkml/85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com/
>>
>> The MPAM driver represents a resctrl domain with a single structure,
>> struct mpam_resctrl_dom, that holds both a control domain and a
>> monitoring domain. On a system that supports both allocation and
>> monitoring, one instance is created for each domain and its two
>> domains are added to the resource's control and monitoring domain
>> lists.
>>
>> Holding both domains in one structure requires control and monitoring
>> to be done at the same scope, and ties each control domain to a
>> monitoring domain. This does not fit the proposed support for multiple
>> controls per resource [1]. There, each control of a resource, for
>> example a "min" and a "max" memory bandwidth control, has its own list
>> of control domains while the resource keeps a single list of
>> monitoring domains. With one structure for both, every control domain
>> would come with a monitoring domain of its own, which does not reflect
>> the resource.
>>
>> This series gives control and monitoring domains their own structures,
>> set up and torn down independently as CPUs come online and go offline,
>> in preparation for supporting multiple controls per resource. Along
>> the way it stops failing CPU online when a domain cannot be set up,
>> and adds checks when setting up a monitoring domain.
>>
>>   1-2   Preparatory cleanups of domain allocation
>>   3     Do not fail CPU online when domain setup fails
>>   4-6   Separate the control and monitoring domain structures
>>   7-9   Checks when setting up a monitoring domain
>>   10    Comment update, kept separate for review
>>
>> An earlier version of the domain split was posted on its own [2]. This
>> version incorporates the feedback from that discussion. It gives each
>> type of domain its own structure instead of duplicating the shared
>> one, sets up each domain independently instead of undoing one domain
>> when setting up the other fails, and adds the checks in patches 8 and
>> 9.
>>
>> Patch 7 turns a WARN_ON_ONCE(0) into a warning that fires. It is a
>> separate patch because it is not clear whether the silent failure was
>> intended. If it was, the patch can instead drop the dead
>> WARN_ON_ONCE().
>>
>> This is an RFC because I am only able to compile test MPAM changes,
>> which is also why the patches are small and each change is justified
>> on its own. Patches can be squashed if preferred, for example patch 10
>> into patches 5 and 9. Testing on MPAM hardware would be greatly
>> appreciated, as is any other feedback.
> 
> On an initial look through the patches everything seems sensible and in line with what we discussed
> previously. I've given it a quick sanity check on a couple of models and nothing goes wrong. Is
> there any particular shape of system needed to exercise corner cases? I'll try with monitor only
> systems and control only systems and do some more testing on real hardware as well.

Thank you very much for considering this series. This is foundational to the support for
multiple controls.

MPAM supports a variety of system shapes and this code made changes to most of
the flows dealing with this variety. Any testing is appreciated. If possible, some
scenarios that I find interesting:
- Even though you already mentioned monitor only system I would like to highlight that
  this is a shape of particular interest since this series no longer checks the res->class
  borrowed from the monitoring class and just relies on the monitoring classes themselves
  as we discussed during RFCv1.
- System where monitoring is from different class than the controls.
- System with L2 and L3 controls.

Shapes where multiple domains are possible are more interesting. If such testing is possible
it would be great if _entire_ domain can be torn down and recreated with and without resctrl
mounted (while keeping an eye on schemata file, mon_data contents, and info/ directories),
ideally with as many as possible "Kernel Hacking" configuration options enabled.
 
> Thank you very much for taking so much care over the MPAM side of things.

You are welcome. I aimed to make the changes as small as possible but I understand
this is disruptive to the MPAM design. After this lands, the remaining changes
needed to support multiple controls look to be mostly mechanical.

Thank you very much for taking a look and all the testing you are doing.

Reinette
