Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E37AD5E
	for <patches@lists.linux.dev>; Thu,  8 May 2025 23:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746747932; cv=fail; b=cZY1uDzsBkGrNqcGZ8QX5066INJTVtpRvdLm1lVfNHwgQm8zSZa/z37va20SAKDy+cNB1xg03I6oO3dMQRdsNZU5xddtsA1c1c439SnnvWOBnLDz7nsWlhUO+RaQQe4MGHxQOVOqCe1XBfCuKBFGJjCIZ5uEue45XkFCWex3Ef8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746747932; c=relaxed/simple;
	bh=NdfrNnrtiPD4ZIHOL/YfvcZEpn8FI73CYpU0n5rVmgE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RHq3eg4RwwOoCLDOYY3UF5kBH3sJWWjpAawf677YGv1yFFzkgSUovpOLi/XmTGquFwxomTw7i/AVDfVgKr7wXkvQtfyXHf06LMbRd10vjtj0hwFWV9kHxIjKw0VPbIvu+7Hw1VLvZMB4kgXwLkOs10fSMvuE2J1PJpxvu31f4Jk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nUVuvpkv; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nUVuvpkv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746747931; x=1778283931;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NdfrNnrtiPD4ZIHOL/YfvcZEpn8FI73CYpU0n5rVmgE=;
  b=nUVuvpkv9aeUG6n+Tut8hrs+nds1K9vMj2rG7+4HdUtd/uCmHs3TvtxM
   PAZcWBdSCoJ489Sj7ebLVsJaPYJ5MNjEgGjzER4k6KyJxuVloGjzglPTJ
   PuKch0YEyK9G4KchsuqSxWZHr+ulsdwG/p3c+J9+TjCigB84AJyKZGG+T
   jk45XRW6b8kcfdcmddVABH7M95MBRsN+I36itNtIvW8FS4W3dfnzXmLpm
   kr328YY1u/RxvJCuMybak7GjFJSuosYNCLvMpTBgOSg1/71Zl35tbmJOy
   fMAG94YFAIhkxV6Sk3gIHDR6qg1mC5by30f9TOgw7b3ZWWCRDCq2raLdU
   Q==;
X-CSE-ConnectionGUID: ISWJ0CXIS+W1rAfOw9aaKQ==
X-CSE-MsgGUID: /iEWFywCTV6j3DIfKj7N0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48639672"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48639672"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 16:45:30 -0700
X-CSE-ConnectionGUID: mMSayuliSeuGxwdMtbzq5w==
X-CSE-MsgGUID: QbGGlQ19T4y6YlkaIJ9YOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136406746"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 16:45:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 16:45:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 16:45:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 16:45:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNZlX4Z0Mva7+tCD8YXk5lXNRjLR7owxry+IhL+INXl9/cKBeDyqlHxOyw7wkZJ2nfXlp0qxmnkGG4p6IIu493gDhI/6egY2rqZ2NNOaCtkLvDMu/xSm9CSvL9ODPbIgSrvWwRBp2aC2WiBFs3jL9dRxEF4qztpmIyR/1EhHexKP2lWCvIE0+qipoOehCOy3EKoa5y4yZ4j/W7HsSccggQ94sZt+PmWdKoeNNOk3RFIRej6sYc9gRET4ZvlqJIEy4xLTVED7u4qEBVWQ+rHxjZ05Atv8Vpg/e26YO19NR0NISG48NGMYpN4dTmd1AvXBml7BITRaZm6UgLmiSqBzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/qOcnVvCIhT1jrPMfoNlsjYBlUFWInDtjnEZF/NmyE=;
 b=NveC7GXBS3GzasNcuHcYUNQcmvCcDMrApcebUJdfliKt+PjEkMxsV+NPKYuWsZ1KMVqIjZ+6Oy/uvcavjEeOVAM+A5CwLXICWYCXYfsVe2h3FZFEB33c8e2EFiCzypNKtWH7fJYDbDEQNRzhvp4nX1T+Y7xeKEf8/n1Yt9dO7HtiJkX0jkqzz7DyXIyrdaf4ISVT6zXaXDY0i3Lx9N5PKY9JXFyhMT+0P8eVjkQ5VQpBXjEAs/uezkTd9k6lrEWZEMHdo/m/R7arRvgBZT8N5RiMAyYR9D5tzi5c3TXgdAisygx124FTJFJOPZUV3aEHppHC86MYNfwqvSFmBO7+vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB7836.namprd11.prod.outlook.com (2603:10b6:8:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Thu, 8 May
 2025 23:45:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 23:45:23 +0000
Message-ID: <2a19f63a-f9b4-4632-bca2-2f64f6fed57b@intel.com>
Date: Thu, 8 May 2025 16:45:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/31] fs/resctrl: Add support for additional monitor
 event display formats
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-14-tony.luck@intel.com>
 <4aa0904d-9332-4796-90d6-d858711fc611@intel.com>
 <aB0T_Ep2lJzfwjv5@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aB0T_Ep2lJzfwjv5@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::41) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: 208002c7-c117-4f3e-8146-08dd8e8a6639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WmhYR2djSzhVcVlLb0FDS1B6UjRQbnQwQ0RYTTFQdG5OaEMwa1VScjJlU0xt?=
 =?utf-8?B?WHUzODNYWDBsdnBHSzIyanQ1Z25vNG9vVWhmNDhYNldpbU05dmN6OEorOXB0?=
 =?utf-8?B?bGIrcDlIYXI2UWRWeU5sZytNUTdleVBCbjN5ZkRlbnpyVThFbW4wMDQ3Mi90?=
 =?utf-8?B?WHpseHY0bUxNY013K1JpN0tGKzFvTzFaTDRJQUtMZEc0eXhKYW9rdnpSNFNk?=
 =?utf-8?B?YVNvajM3Yi9jbVZLWUpkT25zWHpkRjUwQlN1amhPeFlxSlh2QmNYdkZmQmhZ?=
 =?utf-8?B?UCs0UmtTZGpjVlFCTWhNUkJhM1BOdWcvS21tUVBnek5rQytHWG9CM1RCVm9Z?=
 =?utf-8?B?MWdkNW9lOWVIMjNZRWdHOXNzWU5yamJaeGtCNi9yNjRoLzNLYWpxSmN5dlJD?=
 =?utf-8?B?VkErUk52YjFlNXkwSGR5VkgyWDJzZDZYNUJOWUREenR3cGxNZFNzOXpLR2Fr?=
 =?utf-8?B?bzEvNkZXVHVPZW1nNDJZcTQvU3oxQm15d2VCODZVUDc4dU5oT0Nyckd4VFBy?=
 =?utf-8?B?WlBERUtJeGZhWnBxajh0YWNsUWNlUTlmdEVpenNRTkQyRkhYTlFWc3FNcGRv?=
 =?utf-8?B?WDFhN3lhMzBISVNuQnE4K1IySHdiak0yalNEZ1JYdXI5OW91dGFPTVRNUkxj?=
 =?utf-8?B?YkxPeG5oUnNqVTgzVHo5N00rQ1V3SlZUdmhhUGNIN1JrSW5HS3ozNUtBWm9o?=
 =?utf-8?B?ektXNDZtZmh2dnVUT2FUNWZzZllIeG1vWE05OGRRVTFiaDI5N3JIdkZ4RmV6?=
 =?utf-8?B?N25CaWwwMlpXUGZxVEIyNFE4S3RKRlBsUzNVWmlVVThTa214RmV0SElYNVZ6?=
 =?utf-8?B?MFNmZ0pQcFp3Y3ZNYVE5Sys0Si9wbEpobGJtaHZDdlVSQ0hVMjUwYzgvTVVz?=
 =?utf-8?B?YWJ6ZytIeDRmVEIxbi90YjB5RTJORVdTMVFzNiszWVNKSUVGNERIV3ZrbFNa?=
 =?utf-8?B?K2JBMVJ2b2dRckF5U01ReHovN0NqSkJIRkJoeGRpNzhucXZkdmc5TFpxcVVO?=
 =?utf-8?B?VVNmMmMxaWowdTNvMnlpNUpReDJmZU1IOHpUVkc3NG92d0tCZlZ2S2Zpbisw?=
 =?utf-8?B?ekltNWoxMmxOOFdjYWhJSXVRMnNwNmVTcHBzZFNKSkFPaHBKeVBiUHdzM3Iv?=
 =?utf-8?B?aERzbWRzL0ZMYm9lMy9OT2dZS0IxaU4weHlkZUtMbm51VDRTb3VBblZNbndi?=
 =?utf-8?B?S3dkL3FIb2VtUWM0OHAvSlExcnBYU2FzQmRQL3BsaGlPNEdTL2NxMkE5WU5i?=
 =?utf-8?B?VEV0ZXB1b1BIbnFwL1M1ZXNxVUhPeGt0TlU3Q1VMTmV3bTZBL3JsNHhxU0Vi?=
 =?utf-8?B?ZThNdXh5Vnpjb1RtM3NNUStkTVJFTnJJdGVMdDFKK1RsYUpRbG9wR0RPdDgv?=
 =?utf-8?B?RFVTd1lpNXcwQlZhbWxHRi9VSmZCYWduMmd1eE5iZytBaWNlalZvSjdZZFlG?=
 =?utf-8?B?ZHJyY2h5KzlvalpKY2V2T1NETGV3L2JwS0RTNStyNEtEOXVLb1dLQXExc2hJ?=
 =?utf-8?B?TmEzb1Ryc2ZucFhUNVZMOFZZT21Yd0o4SEdsU0phOGZvd0taVUZxSGg4Ui9r?=
 =?utf-8?B?MThZY1VvS1hrdS9aN1BONGtJRlJYVnZ6NHFURnJOc0ZhZ0ZBc0JoNmt1T2c5?=
 =?utf-8?B?a3dENWNwS1htNktyTUNNeGcrOWw0YU0rYVFVcjJvcVZJL281UGZXTkJDa2lK?=
 =?utf-8?B?b20vVnZkUS9PaVhHY1lLb0tFcktBd2dpV3hrRVpPb3lIS1Y4VGJ5QTc0bjlp?=
 =?utf-8?B?Qm5NQlhxWGpQMWY5bGcycmdpYkRVQnR4elBIOU5VZFpLbzBwK2hFMUJpcE83?=
 =?utf-8?B?TTR1V1JxbVhmM1R5QzhJVGE3M3M5V0VLWDlUT0RKSmYwb250TUgxOEZCajIz?=
 =?utf-8?B?QUswTXk0SlJGaHpmMVZlZk9PWWJpQXhIRWQrN3BqaEQ2RlNuRThPNlFDdSsy?=
 =?utf-8?Q?dCxCmj6Ngxc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THRFY1BFTHhTZmJvbEFvd0RnQVp3Tm83ZGlHVGpheTJzSTdiVmJYTXVMbGdO?=
 =?utf-8?B?bXB2SFdiNE1OMkk4VXRKU2tPVThMYml1Qy85Z0MvT3NXYzAra08rUFVzWGlB?=
 =?utf-8?B?UnBKUDVGSm1sNU5xMW9PZlBPemw0ZGFvYVFlU21tS3hub3JaLzZSc3J2bDNQ?=
 =?utf-8?B?VWxZbFZxR3VkSnZBVlZNcGxYQW1aRGhaYlRabnN0MzRZdlUySVdrbkRBN0U4?=
 =?utf-8?B?QWlFTVg5QVVnU09VMzBsdXhJL3FNenF0Y1JlbHl5cUdkcHp5L0FmOEU4emd4?=
 =?utf-8?B?bjFzcWpUNTgvbnhUL2dHeEJHQTVnK0dkL0w1NGttN3BxWFRlQysrZGJRbm5Y?=
 =?utf-8?B?OGJNVUZoV0xUaFVQNmJpR1F0dTVHT082ZnpuSkJzbTBXNnpsMkxNL0dhRllD?=
 =?utf-8?B?SW1MZXVWTDRHSTVjZkthbW5rYnk5QnJucjMxRDhiUzFmQ3hQLzA3YldidFdO?=
 =?utf-8?B?ODllanRYbGVaQjdGVWRQQlM4eml2TWN6WjlrRnl3WjBwVHpibHZsV0h5a0VT?=
 =?utf-8?B?enhYSnE3RzFudEdCTllvclRlbXdTQ0hZQitMeGt5aTgwcG44OHlaWlpmVjk2?=
 =?utf-8?B?eTU2dlZrVHU1MHlLTk1SZytwQURWUDhNWGRJSkRPaWVKcTFpTkw2c3BkSWtD?=
 =?utf-8?B?dnhxajhCdWhHWStHdHRsS2ZYcE1jL3NXcDFGbmVtMFlmVW1wQjhtTkVDTlo3?=
 =?utf-8?B?K3JSTjAxVTF3WnpFa0FLMDFVMEVyK1IrYW1zVmVBbGt2MUxZbmNyRDRtT0Fn?=
 =?utf-8?B?dkJ3MGU2ZUREMzhQeGRub0kvNUxxM1YxZ242Q1VrUkY2R0FUS3BYRkEvN0Er?=
 =?utf-8?B?UWVOcEk3TzJMVkZFd0QreEtFRXZkVjgrTWtuajBIY042Z0FJTWJ4d1ZiL0Fk?=
 =?utf-8?B?YkRWdXpMc0QyNm5oRVR5Qyt6bzRjdWhnVjB4UWR4bWtDa1pYQkRlUHM2b1Rh?=
 =?utf-8?B?WElxTGJkWWx1ZWxWdVJ6dkMwYW9mNmtXcEFPTFlobXBhZE9nVlVUVEMvZDRG?=
 =?utf-8?B?aUZyWVgvZXdnL3I3SnhoMDh5R2FFa2FzNWt0TFdXOStTSzhQK216OERlS2lH?=
 =?utf-8?B?dU9rTk9BcHRyY3RhVyt3cklmN0xDd2ZKREY3Qm5hdkMyL0ZFckhRTE1MaGZ0?=
 =?utf-8?B?cXdqMGFhSXdrdGNiNGtaa2pHOWFydnBwaGkwdC9SYWx2bjJSZmlRclJwTU1n?=
 =?utf-8?B?NnNSRk5BNEVwTWpPTkFJVTgwYkI0dUhmdWhvYkpqY2RuL0tMTUVrZ3lWcWFF?=
 =?utf-8?B?MUtFZXNmVGVTeGsxOUNwZWsxMHBhWERjQVNlRlZieC9kK1lVSnlxM1oyT0NO?=
 =?utf-8?B?MDk2SDRGZDFxWHZYU3N0QmdDSGswME9xV2VpQkpZMjZLUWJxQmViNVVwN0RX?=
 =?utf-8?B?VFJZMmVqM04wSDF5aHN3RjNJM3M4ZTZiUDdmS1RxZFA0Vm1LY0EvOGErN3E4?=
 =?utf-8?B?cmhPRGR2bUFJNVYzd0Z1RkhKMnhTUzE2Vy9vblNxZWMyemtkbVJyblFUcitU?=
 =?utf-8?B?ck1zMEpaYmljVThDMkIxdkV0R2NHL1V2Y0tzb0Z0SWszZ1o5dXNDc3BFVWVF?=
 =?utf-8?B?ckVqVXdoeEcvLy8vTnlmd01rUDY4eVRWcWNvQTdxU3dxdXNnTzBwRHRXeFRr?=
 =?utf-8?B?eXdWdzlUZ2x2NmJ2Z0hkYmVRQ05xRWVkRDBsUmF2Q05LT0p1NDY0cE1EYlFB?=
 =?utf-8?B?NVlRdWtyWDdhZjJ5L2N5anZDWjJocTJZSldudXBZOUdESmhXcmxaeTJJVHhI?=
 =?utf-8?B?VlU2T2FUOW5oNlBxTHNkdXFjcjZKOGthTmRDWFpqZG1xZm5kVGNnbGtFL05N?=
 =?utf-8?B?Vkhzb1dzd21GdjNpdTk2SVRjZFpNa2t0YmhTU3VUZG11NEFVVGlnUmg3OUMx?=
 =?utf-8?B?cGw3Z0JjZkdpd3l1dWZVeFZYYjF3WTVIcWlFMjIyNWFJSlh4OXdNc25aUVd4?=
 =?utf-8?B?akRFNDBxTU5BaTQvcGFBd0lzaGtmUmtqdDU5MjJSNGZvWnV1SHVIR0o4U2lv?=
 =?utf-8?B?U0phdmR4QU5FUWwrZDdWWlBNclFRUGxIeUtqMFNtczUyUVl4UDV1dStLUlVo?=
 =?utf-8?B?S1N1UllrclJlZVlSU1N0TjNWTWlkZU9adVZnMUpLQjBGSVE1VUJYdXVUM1VC?=
 =?utf-8?B?eGhxSnMyNUFONFJvN2p0T3l2MWtxV3RNM3NLZk9ZNkVNVy8rNU5kQmV1VW1i?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 208002c7-c117-4f3e-8146-08dd8e8a6639
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 23:45:22.9465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqcNufY7oA1YnwzJGvLk9o4arWGczwNIuIO784fElaZisSdBs5+gFDMeYrDUt5SAfnEqJHUTPnFI3FLChfUT4xhjY2KDQyVTeb+GJtsJlJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7836
X-OriginatorOrg: intel.com

Hi Tony,

On 5/8/25 1:28 PM, Luck, Tony wrote:
> On Thu, May 08, 2025 at 08:49:56AM -0700, Reinette Chatre wrote:
>> On 4/28/25 5:33 PM, Tony Luck wrote:
>>> Resctrl was written with the assumption that all monitor events
>>> can be displayed as unsigned decimal integers.
>>>
>>> Some telemetry events provide greater precision where architecture code
>>> uses a fixed point format with 18 binary places.
>>>
>>> Add a "display_format" field to struct mon_evt which can specify
>>> that the value for the event be displayed as an integer for legacy
>>> events, or as a floating point value with six decimal places converted
>>> from the fixed point format received from architecture code.
>>
>> There was no discussion on this during the previous version.
>> While this version addresses the issue of architecture changing the
>> format it does not address the issue of how to handle different
>> architecture formats. With this change any architecture that may
>> want to support any of these events will be required to translate
>> whatever format it uses into the one Intel uses to be translated
>> again into format for user space. Do you think this is reasonable? 
>>
>> Alternatively, resctrl could add additional file that contains the
>> format so that if an architecture in the future needs to present data
>> differently, an interface will exist to guide userspace how to parse it.
>> Creation of such user interface cannot be delayed until the time
>> it is needed since then these formats would be ABI.
> 
> What if resctrl filesystem allows architecture to supply the number
> of binary places for fixed point values when enabling an event?

This sounds good. I do not think we are in a position to come up with
an ideal solution. That would require assumptions of what another
architecture may or may not do and thus we do not have complete information.

> 
> That would allow h/w implementations to pick an appropriate precision
> for each new event. Different implementations of the same event
> (e.g. "core_energy") may pick different precision across architectures
> or between generations of the same architecture.
> 
> File system code can then do:
> 
> 	if (binary_places == 0)
> 		display as integer
> 	else
> 		convert to floating point (with one decimal place per
> 		three binary places)

I do not think this problem needs to be solved in this work but there needs
to be a plan for how other architectures can be supported. When similar
enabling needs to be done for that hypothetical architecture then it can
be implemented ... if it is still valid based on what that architecture actually
supports.
It may be sufficient for the "plan" (as above) to be in comments.

> 
> Existing events are all integers and won't change (it would be weird
> for an architecture to report "mbm_local_bytes" with a fixed point
> rather than integer value).
> 
> New events may report in either integer or floating point format
> with varying amounts of precision. But I'm not sure that would be

Partly this will depend on the unit of measurement that should form part of
the definition of the event. For example, events reporting cycles or ticks
should only be integer, no?

> a burden for writing tools that can run on different architectures.

Maybe just a comment in the docs then ... and now I see that you did
so already. My apologies, I did not get to the last four patches.

Reinette
