Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792506082;
	b=bFdsLsUSFg9p7bS7F67Ku6aWQwnvWqxaxvxaimDvtteLWHeL4IJz6K/UW50kgscO2gmt
	 4peJNXn3urVn0151AdAA5r9DAksgidzDtZnzFnaee4N0Ab0GfgTaQ30FUQdHqbdr4kS7B
	 uQ9SB5rVKQzGcNFOaLw1rf4VIrw7tOREKhkZW8mcpQNnUm8y9+RvCqR6iCHO2NgEg++U2
	 32K+kOrEf/9j1FzmCQMujjHkkBK9wJ2BxKx1T9cSD/I91v7rr+NWOlckag82HSV/KxT3w
	 aHYsr9K326wbS786AEr3eVyElMt/K7wAaK3YMjPqf/S2/CcIWjCEspb3Q0Ge43SN7Rg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506082;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=rmoZEEs2akAuWQGBo5qJ4kZulK+/H/WQ1T3pAVFzh50=;
	b=Ig1LpoMfZskstTLBD3Mgms5+CRPuvKpVwcrucLSQ7bGh6xSi44rjtpsRcR/T7rrNPnih
	 W8H8hzGgaBSmXGHzKA0xIq0OePx4f85oIHJNY+0gGez31XjamYJHtes+PqB+QeHc1cJqE
	 jxQTFzmT6iLn2u0T1Et0YqIhwOE52KIC8kHDzyiXIwWLutdZHhwTfhv5OqMrXj+8wMScG
	 /n1wKb9Do9OHvUtnM6b/fXRTiZqr9FwkNVYVLSlRw5irVcde0h7hoBe1jf4YZOHMUONVu
	 SHf/jtbvWLwdnv+l0S4dn7PrgiggcsJBR7UMCYXLCcbP3aZRKPN+/DiRJjBUyfRelUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OarX4CZW;
	arc=fail smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142F6606AA05
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 14:21:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 142F6606AA05
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OarX4CZW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792506082; x=1824042082;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ses2zIwBiZgVDGkhsDcuXuGFqQs8n1DDULIE3mV7p/w=;
  b=OarX4CZW8O+TUl/pCY9L4e/EG6+F7bO97YO0bSX+Q/rCzII1CgWMSwy3
   /NYqKE2qxA04/r8I1qfN7K9ogJ2fPikQseEWdvGoG9xoEyG438y0uUif6
   UY84/oS022IbCSxZQThO2tNYwWkmCNACYxq12YWIDr2Mq3fz9zkdb6xpF
   ERnPt0lQiOcNNEoOKdp0xSdglzv/B06pW+Xci4OdtXF1dIiAmDB00TEWt
   PsqxRu1dtilQbRi4HOdUU8n1wfJwBZxPw2IheJ9ODx8vIsqA1e2CHLMtv
   hhCPIl5iISsRxu1IJN1oqL7Of52bKvSccHbAGB7X/Z7awTxzaxMIbuy80
   g==;
X-CSE-ConnectionGUID: od8olkm0Q1Gb06IJfDLf3w==
X-CSE-MsgGUID: VPSUhRJ9S6udOVZm7u/rOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1223690"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1223690"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 07:21:21 -0700
X-CSE-ConnectionGUID: C7NTg1z3S2mpiCDcIgb6+A==
X-CSE-MsgGUID: 06G/VaxjTvSrKfsg5bSB2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2826745"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 07:21:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 07:21:20 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 07:21:20 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.61) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 07:21:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=enpndgdxvMEcqAxUKMZj6wcLYpGSE7UUc3/VNqdngjvO7hMivcX6Wcg+tCqfJhED+5MsRpPV1RA+vu8dijomxzZUV85CBumFMxO5F2zHM+jKSSQvjJo+PzvqVF2R7aVY8KmpFwj93P7SzsPMjN/DLyDRAwLpPqBnZcGctteNvRqBzbJ8eHuD5s4M1oxz0ORARShMwt2nWcgWmLC3qClOBfn0ffVz18tnuEoJi8GzmAVeYmzP/nO40XGDZIieh4/oMMr6rDS4KphkzLEPyu0UCtw0xYL5Zo/dAbSUOy+gMkgaS10bXmRuqNvu1QTRPejbO3CZoWwOYZCrcrl04V79kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmoZEEs2akAuWQGBo5qJ4kZulK+/H/WQ1T3pAVFzh50=;
 b=b3bBnqseUND1JtyJz72aj+MI5bhcQ0igAZauFCRCS7gYDfam1rWV201JCcCmiyd0hPmgQRq3OHbhua7B95w2IMGiAUdisQPIdOYK7g5vVtHpk4oaHSYm0Kz4HJTANRQksRwmQdB1FgEiy64/QiH9Kx1Fej3a8mU6DjJlKCRqxc1IPxP4OrxuwfgsEVO4q+ebb7tpaFalYQt1tajjrb8hAJifDHBJv5RHzRAAs9f/KU7M+XAKY91eCi+aBbQ2KdkX4FXQiAekBSRu0Eb4j/HqeQjFdm1amLNvkvr5z6m9qWjYMS2+H0uW4KyV06YEPyyFVsFvrFzJvcExr2ZpPFJbpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6005.namprd11.prod.outlook.com (2603:10b6:510:1e0::19)
 by IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 14:21:16 +0000
Received: from PH7PR11MB6005.namprd11.prod.outlook.com
 ([fe80::4f64:b0b5:4ed2:39ae]) by PH7PR11MB6005.namprd11.prod.outlook.com
 ([fe80::4f64:b0b5:4ed2:39ae%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 14:21:16 +0000
Date: Tue, 20 Oct 2026 22:08:19 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "David E
 Box" <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v14 06/24] arm,x86,fs/resctrl: Replace architecture
 capability helpers with generic versions
Message-ID: <atd105As8IzWDouh@chenyu-dev>
References: <20261019205031.16977-1-tony.luck@intel.com>
 <20261019205031.16977-7-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261019205031.16977-7-tony.luck@intel.com>
X-ClientProxiedBy: SI3PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:295::6) To PH7PR11MB6005.namprd11.prod.outlook.com
 (2603:10b6:510:1e0::19)
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
X-MS-TrafficTypeDiagnostic: PH7PR11MB6005:EE_|IA0PR11MB8379:EE_
X-MS-Office365-Filtering-Correlation-Id: 8beed5f2-e098-43e5-3225-08df2eb5672c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|56012099006|11063799006|5023799004|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: diCob7wWh0TQpr3zt4KG6llKFYINoWVDPRBmwUkqz0Jjbx/mR+B+ZZJH0dNREssXr8kodrtLHCxcqW/1VTVkmLOSHg+toIxdkUzTno16OKmgfWJkUruyhpN0FZ1KzNMer8TXfw8zQINk0JdVFMEpQJ3c5UWiCI3DTxVv+Uw+mIqp/mTBU6nzg94noITPlc2Y343A+hkpjJv33lFID/jVys/iCg2rRbhFAmS1KD1NrOSDP5n7lQIUkCIawypILI09KVxhirZFCdd2hgw1FGXclCmEdcesa3aDJgKD8laf9F9iX/yqnu7h2Ecy2BObRQtxEOpXBON0a+36+hrio0rBZ9cCyW2WcHQJsIezhz3Ml13wJVKn6MxgExpupdC1tbzJtnPX9wbcna/Qv6Le/P2bKXxCWenv3kkf3qxu/kreD2ahsUPws+Ew/zpWoqhxR7MGic+4z5aILN9/3L+32ixQLwsCk+mnFJOj9qvGp7dQFS1dnGgAVdktMYvVhekSzZIeWhJ0Cq5qLN/IQpIY6LbiQv1V+iYrCTSWY1MqX+yEp8YH0GE9nOvJ5P4HTbHEMwmnd5Osdh4v7pTLLN0jfR8cbEyjsmclGKKLp4pO7oLxO7DPDLoJyVa5HVVBvvbZJ0TDQWF8V52VH+Mi2rw4IdWmcDN5gq9wiMs2SvTPdQUbms4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6005.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(56012099006)(11063799006)(5023799004)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4+bdzcUwyb62l2uebznG63AsoyZqQw2+R+9GMBI79jIGA8EtonZ2p6A3FCkC?=
 =?us-ascii?Q?/Kt46st84jRVxvk0TLXClCKNQNHNYwFcPD1/v0HmSM+KvNxA6xG+jE/3pyup?=
 =?us-ascii?Q?CRPc0NnfvjX6Ek7akzVZ87Z+qtvSepInUU5SeK8UIxeAE/jBRyxV6oo2XIEU?=
 =?us-ascii?Q?bKcFCfYDHzRznRHrX1Os7YQrktJWlr4Y+cbVNGgCdEKjBFbMpmFI3xE5Nz3y?=
 =?us-ascii?Q?D/hdKE6CK8ul7RYs5pDRXaqDJi+T3Ywo0U1tW0LpphMv6GpC6n94MBhgGSkF?=
 =?us-ascii?Q?NAfWYrd+u98BTOpvg3pDbiSPf8vHt5UdvztD4oM4Ap8q5Ie3t1WO27ZBNG/L?=
 =?us-ascii?Q?dz/6j7WnmjpFpBlhyHEq1ZLz3zm6cWYVK4ZL/RDeOeelDsUIAVoOsms8y8G7?=
 =?us-ascii?Q?OU91TnU48L8c/Q1jUWjgk1Vz0imlr+9fp/rXM1V8kEw6C0mTm5aYA2VGToEN?=
 =?us-ascii?Q?+3GZNl3IBPvtL7MyIohiDZWI0PIXmMKbJsQXLvQ5a9dF6Z3B8HK1pk8cUEgY?=
 =?us-ascii?Q?0D00UnFYCSPanxRgSXFNeO1iJJy9O9LM35brBCojESIPYFdAmtc0Tj4briVd?=
 =?us-ascii?Q?RcWKE8cfTOQwmpqCKD9Itbd1IcomUjHDMO1r6DqAd/3nsFtRTj6kGAZ+y0ti?=
 =?us-ascii?Q?Eg3mitHIIt5NqNHuqJic98nv/0TpmP9zQdhCT/4wqLxZVWN8tdYjb2OFM2yS?=
 =?us-ascii?Q?wZvbD3Th6eYHIZ0l1GyaQJpK/OsFJEZ2I40qw0oHh0j3TwAACgVti1huCCNC?=
 =?us-ascii?Q?ecURZ5H0OGu6E7iZzBw34ZeDXJC/9COMkQsnM9+hXdeMwtMADajNESgny6Y7?=
 =?us-ascii?Q?5e6R+NLKGtv2dwAWVfx7heMeswxh690ktrXij01rTGe9jYt3bjxN/redTrub?=
 =?us-ascii?Q?JPbBMnbAmBEZKhiQRCzLjYkfDvlFeVmB9JN9Ffbo9KT16o3GIIuc5F7AqZEA?=
 =?us-ascii?Q?XjlD4wfCHKYJYhdDcbnIiHFmQFtbDWD0qVVCns8NaBVDdaLbnjitirDEpP0o?=
 =?us-ascii?Q?nq3eFLkETl2KTu+aEtn7QdlVaWLuHy7G9ZjiR2cxvosUbbGLkT5e8fjOlMuM?=
 =?us-ascii?Q?T+j6h2y16PjscPYeAZHDsIs+SPZdqY5g/81YrSo97JlBNqDSy1USQI5tq07o?=
 =?us-ascii?Q?njGrS2FPjCQ0vku6WhrhwkcRkbqmHvtvFpB0TChJKtfCLN5qlwY/IiGNI/A4?=
 =?us-ascii?Q?xcF2t3dI+XdZXvXdHta+nRhP3tfl7ni6aJwF5iA5IW1/GMPBYZmRxhTKZvf5?=
 =?us-ascii?Q?Wh2Kn+4nZLq5317NFaj02P2Wv6qBNb/zqWBPWlSXm4QU8UWPG1F8rNyo1enT?=
 =?us-ascii?Q?MeiQ/07T08pjTGQoAaovW39xK64TpiKihHUY9bTGJT2jmuHB3QPI/+9mj543?=
 =?us-ascii?Q?9FWGWhdv8iJLtmTKT1POVSdHELZn0S/N6NIKzCU6OBeWaRYvEtYfVcXFdl7E?=
 =?us-ascii?Q?/yrwe5Gw+xdpeoAzIQ6Ol2tYF1Tbdq1V5C0zpn68B8AIppXw+bE6zTbYTXWl?=
 =?us-ascii?Q?dTHCPaKcMYX2iQnuSau3YeFgrLil7NxLztlINlp64sDPlBClkNpLCYqtsHkr?=
 =?us-ascii?Q?0EwoUCZPz/+32oO1zIkybcGr7tpAAP8ZVdlW8H8Vk40O64i78kO64eRxnjbv?=
 =?us-ascii?Q?YH3Wu1tvIw3FvliWgqO9SOVcIHU7uyucGUbRUnm/bd/1jnyY7ARCWtg8Fd/i?=
 =?us-ascii?Q?sTiGs/H2a9CRIJkD5RAdkMghHmSlQcQEuBCD0728XMgb4eStzeBgPRYTGbV/?=
 =?us-ascii?Q?HVGwh3iFIw=3D=3D?=
X-Exchange-RoutingPolicyChecked: sZhkyuNVQzXCfcmnQQv2LLmeeDYkMzDtK8jI92MkKCHOeiaS8SZ1QB8DSv1RDoh0CGGtEFq622l1aFBqYR8Ai8eJnSwUNsE8g0V4i7kuapYdCUFSvypXTAtK+O6SZVb6uaEEDApQ1Lx77X9R1BMKpfCXDvlATAWrH20pUK493tvkMTiDpjWS7MF9hBG4d5hR85gUO3PxUZ0rUzA5mp2+U6fX1o/UWo7MrpPFDXLkb2Zo3O3S0fXWgd9GAhfao6X1JBKHz6lWCJtYEaC2a5R42bfF/85QVSrfvmApn42xygmoOor1vpd1brQ0wuekqN/S+JPCI5+qfzQkkid/Y2ZXcg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8beed5f2-e098-43e5-3225-08df2eb5672c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6005.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 14:21:16.6798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNM6bt07LSN6cHdjMu8G+tOVgI5LUYVv4zaYf8bEcPLE3xsSVUW6iFDPkRhrKcl30BTPq+0gD23q5WIwy/Ks8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8379
X-OriginatorOrg: intel.com

Hi Tony,

On Mon, Oct 19, 2026 at 01:50:13PM -0700, Tony Luck wrote:
> resctrl supports allocation or monitoring if any resource is capable of
> it. Each architecture answers this via resctrl_arch_alloc_capable() and
> resctrl_arch_mon_capable(). x86 maintains global flags for this in
> addition to the per-resource flags and must keep both in sync. MPAM
> derives the answer from its per-resource flags.
> 
> The per-resource flags are part of the resource description that the file
> system already has, so the architecture helpers duplicate information
> available to the file system.
> 
> Define resctrl_alloc_capable() and resctrl_mon_capable() in the file system
> based on the per-resource flags and remove the architecture helpers, in
> preparation for removing the x86 global flags. The result is unchanged for
> MPAM, which presents all monitors on the L3 resource.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>

Since this possible regress window is very small, and I did not find any issue
in this change,

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
