Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041723346B4
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012586; cv=fail; b=V6Ey6dnSWflfg6RBPDhuB3OgQJnxEPQzPkFThDxZ73+PanqlsWETXGgMCADWZhg/oTlYonGHgeHrh0LHsXprfvj1SQeSnqFvOV7P7Hz19cHQQuJ1DP5uaFx0qdXcGFx4EG2Hhf8V3nLUIfKEsbNqT79Syc3Fg0DDRH+m2Iv1ZEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012586; c=relaxed/simple;
	bh=CWIKSGpqAw4YuWF++sfLD0SYoPvUq0kR6QMMkfSVUYs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ma6vYJLigDPpr3nQc1TQO0h6/WUOxvtcphfeve4CBcql1x4tNE9LKXGligChe6jYSgzQgRLRwGjyg5QaDxoCZKymZ4c1M5lVV1bLKuv7NF19UlziKjmLdEQJ6Ny8wfrhxNcJDdHWaVYfMZ1IZP1oeNQT5xkkAGM8RP18OoL83Pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SVZXUx9l; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SVZXUx9l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012584; x=1820548584;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CWIKSGpqAw4YuWF++sfLD0SYoPvUq0kR6QMMkfSVUYs=;
  b=SVZXUx9lHSZ/fQfKuQeCItcJWRqAQr1qH2a1S6h+l+n6LMbh93YVQ4Ah
   xcMLEjbGPB/oX1x/A0ndF2HtjrO9XiM2wsNZnSeh+qVNeJ6aLHm/FDRHS
   hnsUEqLrMp21aSY7zeDEbMmy8rmxgnTTWJMX303SWYdIl1D1ds52kg7Lj
   shFqGXCDcZMnAxiiT6Pg7V8E0/FersYkPoQId2n5mCGevgx64W6aJWXNk
   1gW7bjP5Hk266571JjaZGgm9x5dOF5B3BpuOx70FOQChSsjxbNkHQxwl+
   Y8fb1B6IO+QK+YOncIhmpMED40f+JapkLoN0kbRTQTiRp3fNNoP4EVNBp
   Q==;
X-CSE-ConnectionGUID: 01aJBdCfQTqEiGSOEQTFAA==
X-CSE-MsgGUID: VCBjLEigT0mTqVqDXQwZvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89492958"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89492958"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:56:23 -0700
X-CSE-ConnectionGUID: u9PmJ0NPTXWQZ0dxcg9ueQ==
X-CSE-MsgGUID: j77IFwpCTBSQiihYst6guQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="265302656"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:56:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:56:22 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:56:22 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:56:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ag0oV9+BPSvKWoW/b8lxp4Eq2tUIL7b0Bl+YqXJRTleU7kDHCZRMz0qmQVlh7NWa5IwDO2LJxHTdzciBx//GuvhefslUduuqILATKO9N/lzpaILLgpzWdVEfWJ/lKG/Nii42cOf2T7owJQ0xbBltDpmqlGw90i6eZey3L1gG2mHeC9xuN/8bQmJ7wIl/4fGWGifuky5vOb6Af6XxZMPFSk/WoFtVErrkl1PIjwM+2nugKrhRSSixXnF/H/Zn4RvjJtq1JrzXnP3jAsdxMH6HjWZMdj7yLPEdyjgixD3Pz1qYSYW/xX/P6zRdeiRb124YqzyUWJRk7MGV9AtEP5F4Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uT1Bf6uBn65l17z89CxpysaG/SGx+hrKLaNzxDtOeQc=;
 b=p9G5lF/wyWi7bL9/Epyto+n2xJy5jKH0AqnuauM3YZdj+NvBxFvpsBTMsoFa7BjOQRBhGq49vPK9hKG9aKq4NezsfMCZbR3DGgXJOh/Qs1+B/vUWk5xKQCH07Z21bLKEn421okMFcrwsU0wpFUV0nc/0Qm2SMjofwPBBwJyU9H6sA4s2QLEnw8wHEFmqOYaHdrniv+Gq4BEosEkFGktQh2ueffoC8HuDVbPRneiu951XukJ3t7tUSu0X+1DQITnH2spgA8pC4RG2ovI7UnZmC+/X4EjWqNvU4AxtsDr/vxMhzcMzF6KRO5H74wNzeP+M3dNpXdOLaOwV9k8v1ubWtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 03:56:14 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:56:13 +0000
Message-ID: <9bf92d48-da83-4b7b-b44b-5e0a5f468a10@intel.com>
Date: Wed, 9 Sep 2026 20:56:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 06/23] arm,x86,fs/resctrl: Replace architecture
 resctrl_arch_{alloc,mon}_capable()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0321.namprd04.prod.outlook.com
 (2603:10b6:303:82::26) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: eb37b714-362e-45e1-aa93-08df0eef7512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|6133799003|10067099003|56012099006|11063799006|4143699003|5023799004|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: IJ2g2+jpL71NNd8MYonOlMRKdI/MFzfGBnsNi34pL1tCUnsk9gjDPnl52xfNq3sIAFSGNz36gMwrUum78ep4KozUv0an7ZTnweXgFcMb2vQc7cC7HHTGzCh0TCP+GDakhY7Y3wka/8dYRBB31HtoGUZAto2vCRIYU3ZdRoNQSSZlJxcRasmVzTMd/ww8nEyV0Fwe1ZnNmOqw3GPac+CkBU70Gu5Wb2bYsWMuinV27/rq0fS16BBQ3lOma9geQt1sNzsLwJtnfU0nBJ9iLcao1kg1gJOUJZ2ZXfmn2LILk5NSJ/LzQRiTGZ/j/tL2/rAsYj3q3xtoj22cQIea+6QF41RI8lqplEkz6Hmd0GzvlHPXDIJIgOPP3uOAks0Ge5OGrEE0zyEaiZSC+J9x+ctwYZEGZR3ZPt1WFPe0UDDfbIBa2qA2hX5UhS9kuwfhnmSASdvlPcIfAdc6HdwF5UyvaouV1Ij6gd/kSB51Fc4xg10kVLnPU6etajVXdfdHqXraFBMyaXm1XsZf//u+2whWbjNPgDvdZfN5eCbV+2WoiY0wLGcaWmSAb9pILmysHLwQpr9MWRQkp4/dw+Mq3PMc49tgJjY2JX8I/QFAZy1ULRzE0BKFmQgpanIWzCX2IdvGLiAiM2eBK72x9FmUVFM3nr2LXKJhxW+8TqI4SPAxvXM8CdCBvl58udYSyC4TUCeKGn/7JV71oh6kBJhVxNa/kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(5023799004)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eU12MzdETkxFOHhLUS9MYy9NTHd4c0FTUGJMenFuUis5b2dTTkx1VGNDb0tG?=
 =?utf-8?B?bXNnL2l0MTVGcVJnM25rciszbk4vbWZjRStFOU1xOEpCcE9jYWZKVE5hMDlM?=
 =?utf-8?B?cTJtSEIrYzdMWVI3Tk5DK3NmNEJHWW5oNjByQ21zVExOMHBnZFdzeUZtaTU1?=
 =?utf-8?B?RUlERUFmdVhGaStEUDFoYVJxRmRJOGhhc054MDFCdVFNWGNxcmdjRWhNVGN4?=
 =?utf-8?B?OHVaRFNDNzVtRndHT1lKM3p3cWpsYzQwaWZ2UGZGdi9CSlB0WE1xWGFlZTNQ?=
 =?utf-8?B?akdsMEIzekNRR2JMK2h6b1dqUWRweHNYSW5GL0RRNUdTakVYNWVqdFVYVk9O?=
 =?utf-8?B?UVZ1UmtoSE1lKzIwZ0tFOCtrLzJrckkydDAzSjY2RVo5aW5NS1hCVWtFWk9J?=
 =?utf-8?B?cXZCVFVKQnp5a1NDa2h3aWlXNi9JcGQ5bWtGcUtPUGxUMURxTmVjZ1JCOWtO?=
 =?utf-8?B?RWN2TzQzWXNwQ3puMng5L1dWRnRJV0hYVXhqVWROU2FiY3VyZ0VNT3FCYW1i?=
 =?utf-8?B?dHBTaUVSQlV5QUFva3lTOFRWVmtMTlhoSXZBdVpVVU16WHFweTQwUU5VRS83?=
 =?utf-8?B?TS9jR1pwWU9KaGphckdPdmFDQ3BmYmRscnhCeW1VRDkzM29WY2lPSGVQQ0FQ?=
 =?utf-8?B?L3doelFUaThRZkRrMzgyREduUjVRbGFJZVBxNlR2SkcrdG1hNDJBeHRhbWwz?=
 =?utf-8?B?ZEpaR0gxenQyTHBSdzlpNVRQU1E0eEc3eVF0Ykk3bnBmQks0OXlHclA1Q1NF?=
 =?utf-8?B?cHRpV2kvMVJYMjdOdDQrNFRWcEs2NUtaOGo3WFVDV2lhNzlGcUN0d2RzeXBD?=
 =?utf-8?B?RXJJcG9JWGsvVGZEZTZJY0ZZZ0RBSGFZaFF2NzNEU2d2S09hRU5pUXpzc0p4?=
 =?utf-8?B?VkJjRzhReHVZc1J5OXB4YW1IdTlpM2JuSkF6MVp1NXFEcGh3YzZxMS9vKzdY?=
 =?utf-8?B?ZTIxS3BBODN0dmIyM1Q2MkJLZmk3L0ZGRStEN29lMXRFSnVCUFI5VW05bzBG?=
 =?utf-8?B?U3U1NlhwaVZEUVhlbVBXQ015bmtmenVXdjFiSEhzVllZNDhNTXl0SUExWFRU?=
 =?utf-8?B?RGk1TnVkUnIzQnoxRkRXc2xaN1V4OFNvbVFoUzgxdFF4aG5CL1lBVWVzZUcx?=
 =?utf-8?B?dlN6a2xjWC9lZGJ4alY4UXgwSEx1OFRENjgyaFF6aFBmZFYyWExaODJjU0VO?=
 =?utf-8?B?NUE0WWZRMnFsRFBNbW5EbU1kckFZOWI5cXZ0V3dZcUlCQmRORWpBVCtJTHBz?=
 =?utf-8?B?dWJIeGZKck5sUEE1RmM1VXJFNnQvYWFscWVKaGtkeXYxUGlnQTh5b0Y1SkFK?=
 =?utf-8?B?ZlRDcDhsOUwzeE8yNlh6RExNaEg4Vk5TYmtza09YK3RmYWhDRnVEOEExYUlq?=
 =?utf-8?B?TkNCUzRJRjRyR2VYV1NFa3k2UlVuR2ljMDljTFlQMFhla0szeDdhc3FtUkpH?=
 =?utf-8?B?NkVIK0Nva1RlQ0ZFUzJuVWlSN3JEeVJQTEczbENvWDl4SW1URS9USm0xc1hV?=
 =?utf-8?B?NmI1NW80d2x0dkROYU16VWora1ppNm9rZW9NQmx3TEJ0ZDJLU3U0UGdac0w3?=
 =?utf-8?B?aFcrMGw0VUQ0cWYzWGhvaUxZYk9lQXlYZzZuTHpIMXBEUVYvWnZ1K2VjbG9m?=
 =?utf-8?B?N0tCUkNKalVzOU5oK083bWNVRk9aamljRWVUQ1oxQjY3R2FJekgyTTRsUGEz?=
 =?utf-8?B?SElvSnRaM0pXaVNjR0hUaGN0WDZwbXdBSWZmVzcyOVl6VW16NFZSSEI1NUdn?=
 =?utf-8?B?aEd2MlBqcnJ6Y2lHR0pibVM2cFdHY29IUkpwM2JLNU5CV1h0KzJOMm5XS2Zq?=
 =?utf-8?B?UkJJbnJmemsxRUNVUzA1M05vVjd6ZGtBRi9XZmx3Ri9XTUg2TUxzODYrcUVL?=
 =?utf-8?B?bWZXU0FGRXd4cTRPRjRlZWhOSkdTN3RlZEZvZlFFM2h4SlVRTWloSmUvVWty?=
 =?utf-8?B?NDZ4S1AvY2lIa012ZW9iRklSQXFJWmxxUHhVK0pmVmlyRkpodCtiQUs5QTQ4?=
 =?utf-8?B?OEdvYTl5TjVlUW5xTUd1b3hhY2syV2E4a0VVYnRQaVY3amR4WCtUajVGK0dy?=
 =?utf-8?B?aHBFS05Ta2QyVVhpdnloemQ0NXlOTHVVRlBSR0plU05mZXgwYkNjcnRxNERy?=
 =?utf-8?B?QktrVGRpMkhpSzJpanhTQWZnTEJoQm85RkpEaEo0Ym1KNFZnQmJqM3V3K0xo?=
 =?utf-8?B?UktNNG9udHJsYWJTcDRGdzFJNk1JdEFHRTZBL09TR0Z2U3FxVU1zTkxDV3B2?=
 =?utf-8?B?NWQyZXE0ZXJBNHhZbnplcVdya0h1alRubWxLQjlJajVRYkl4VThnWTVPNk1J?=
 =?utf-8?B?TEMzcnNQU0dOQVpVNVprSTYxY2cwQXU0UzFac2E2SUlKYVBPNEpoVGtxVVl5?=
 =?utf-8?Q?dWEDFVSMkfNj+yTU=3D?=
X-Exchange-RoutingPolicyChecked: aipjPVXn86YNIpcz01wg2gkKtix66Gc/njcvmed47ltJMqPKIv9IBeUsITsa/dSQS2f2H1FmBzxxAZx+6q6h2ukrhINyONETSkS5v+YNtwaV7VRwyW9A3+gaemaDAkjZ0BACg11ObWArlql2yNmORTS1/s7bReeqI9VCq4snagUQIkg2JaZP9R7mu8Xx8ormZGpLKVs8f9bte8IDo/MN9VulkRJ/xmGmsYBFQV3ng7ZWyMZJaRycbU+O50iGLKafGS8t0qLuEMaT7ZyODwj10SJx4g470om8AYP9v6/V88Qo8fWheQEh/0qJVkNgAm1+WKIZxYg9gQilBA9+X/ImUg==
X-MS-Exchange-CrossTenant-Network-Message-Id: eb37b714-362e-45e1-aa93-08df0eef7512
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:56:13.5190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5a+nE/3/QmVpqw/+rxhGo1UFiflC9Xo7e7Ua1htHsE1Q6f5e2Iklc34jJGL/4RPZCOAHawGz0bZZ94EGISarrECJRWijTNHHHCIBg8FTbNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> All the information to determine whether a system is alloc, or mon,
> capable is available to the file system. Architecture helpers are not
> needed.
> 
> Define generic resctrl_alloc_capable() and resctrl_mon_capable() and
> replace all architecture versions.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
> index f92a36187a52..ba4131048260 100644
> --- a/include/linux/arm_mpam.h
> +++ b/include/linux/arm_mpam.h
> @@ -50,9 +50,6 @@ static inline int mpam_ris_create(struct mpam_msc *msc, u8 ris_idx,
>  }
>  #endif
>  
> -bool resctrl_arch_alloc_capable(void);
> -bool resctrl_arch_mon_capable(void);
> -
>  void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
>  void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
>  void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index dd09c2ce9a0f..4a6b0c1833d6 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -346,6 +346,32 @@ struct rdt_resource {
>   */
>  struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l);
>  
> +/*
> + * resctrl_alloc_capable - Are any allocation resources enabled.

The description reads like a question but ends with a period.

> + */
> +static inline bool resctrl_alloc_capable(void)
> +{
> +	struct rdt_resource *r;
> +
> +	for_each_rdt_resource(r)

Please add brackets around this loop. For reference, see "Bracket rules"
in Documentation/process/maintainer-tip.rst.

> +		if ((r)->alloc_capable)

Copied from the macro? Please drop parenthesis around r.

> +			return true;

Please add empty line here.

> +	return false;
> +}
> +
> +/*
> + * resctrl_mon_capable - Are any monitor resources enabled.
> + */
> +static inline bool resctrl_mon_capable(void)
> +{
> +	struct rdt_resource *r;
> +
> +	for_each_rdt_resource(r)
> +		if ((r)->mon_capable)
> +			return true;
> +	return false;
> +}

Same comments as for resctrl_alloc_capable().

> +
>  /**
>   * struct resctrl_schema - configuration abilities of a resource presented to
>   *			   user-space
Rest looks good to me.

Reinette

