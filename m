Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFDA19C556
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 03:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755143963; cv=fail; b=aUSpUxGMHTlqTS5usk4pB25h5AsRBiGJ2GR93A+8AwU9xHqslrRcjT3ImI+xeWLQRpwK8r3Yn/EviydJFA0V0U8z7CGolCTaWB/JErmKU3ShqZjLrlA4ElFDImIza/Z09JNOMLHGUaAK73CsAUq/mxS9mRQtqeeDiB/hNR57NXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755143963; c=relaxed/simple;
	bh=KsqIvsOH16xK32ut64TW5BR7sP6Axr3dvFLdGzvfrdc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZorXl77KywE3MJIGmT0VR/1S2A6MOe8qemoi7u4X22KYlA/gJ+5dQU28NU+i8SENfTfNQwvND1Q9LANXab9PVvRL0qClNijU5e3NJloP+qgL+P7DUqMcAgEdp1xIkedOpxy5qPAvNKnwnIxqx1LRpJ0BMqch3jVGBYjl+5Sf2mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UrEE3f8M; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UrEE3f8M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755143962; x=1786679962;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KsqIvsOH16xK32ut64TW5BR7sP6Axr3dvFLdGzvfrdc=;
  b=UrEE3f8MG1eLmy5hOssyPXuCzpVeFYyT7YdzDIyvnkCtNk6U265tYaIF
   MfmZvw6f9G00lG/o0h+rVfVTeV+jmpjSTyoajhvei0AYCcJCWBzCGwAE8
   SoE7u+U0ee0YVSHDntqGOjiypCVxJG3K7UYUg3kmL8mQX87KSYigY0kgl
   gb/3tU/6Aj8UlXWFKCFcNMUzWFBRdd5XjVLQS9OFyL+R30lv8W2/5EZGs
   s0PIDaTHdo4hiUktrf71X6HbwZBVlWbkpvwnmvgZ8WeXfHwcGv7Du7p4X
   dYpy3aXFJb/GXg+daYEq30lvPnkEwkH/OxGMDSGPZEI4Xqcj1ulrwykIy
   A==;
X-CSE-ConnectionGUID: N/UvVYW5RtOf5Yg18CLdRA==
X-CSE-MsgGUID: bbMgynMhQjmgHgJ44k7X0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68056887"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="68056887"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:59:22 -0700
X-CSE-ConnectionGUID: Z2pl7+MSS22xtrnIND56yQ==
X-CSE-MsgGUID: G1Mt58PYTxaSkexhv/bEgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="165872337"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:59:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 20:59:21 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 20:59:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.80)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 13 Aug 2025 20:59:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=awmUSev+y1Hpohq26ZH3cc75vbmofPEiufaCpj68CPQUevBG2Sz7s2hamn/1fdNI9YKtQVzdy/eEw6I43uOuDEL3LGpv2bve5oXzTCKQrz2smuD8Yijh1KVjSfES7wZWtrKHaIM1dHKs8CrPFnpWiPnC38xPcuOBTHTpKAo36E4kSx+jmXg6zQ6CLpK9bH2Rpbyo1wPcaZwV1w4/vRwLFZOp55baL2mkND+t6PjR9ugSUo+mQmAQtHMMVo72wHIo+qDZ7ltI3vO3MTeLEYy65KqwpJj6vwBXb7GUbtN30ofKZbIIAuWk3nLmGOv0yRW3bgBFULMvwbOd3bzHVbeLLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DOW6+G6Wylr0mjW3vy3yjplpIlA2FcnTo0aGmx710A=;
 b=oBd0YWt/i2JxFPwD/yXmHGyWIcBQqSKLS1G0f0/PEqwqk314OoI3hGf/LTVZgBQb0m5EiSkh7UQDqr4ZbehyHOU9gWeRWK/YSi7x9gAm2bwCz90xdtm3KLWbki2a0Jav7YqzLqP4mwbGPaFZaexiDQGSB3L6HjVPc9c0BHgxtTlSyQFe4gtLdsLO2PRXudUJQph+t+3qqJb2XFLpTwJ/TG0SyBkWvucXwpo4vOslLQhE+gjKemt4WhL4WuLXxqLeev8JUhMoOoCdFpllt0QZKC/zUzNC6p+tysj3RyJi+8D8P/IQkbNtwWVMhtY7O4vZIivBfrGSqvT1YdxitJ8hEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5198.namprd11.prod.outlook.com (2603:10b6:a03:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 03:59:19 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 03:59:19 +0000
Message-ID: <8fa6fdbe-c303-4c3b-bd49-2ae352967e9a@intel.com>
Date: Wed, 13 Aug 2025 20:59:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/32] x86,fs/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250811181709.6241-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0175.namprd03.prod.outlook.com
 (2603:10b6:303:8d::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: a4cbc337-35a0-4ae6-a61a-08dddae6f1e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OExWbGNXNHN0dEYzUFBTYUxqZVlwZ29ySTI1YXVxVWxjSmQyRXB1QTlvSTdl?=
 =?utf-8?B?dFRxQ08xbUVTQ0VlQ2lQRUhPbHFPdWE2c2NHU3dibkc2NE11Vzdsb3Vwd0FU?=
 =?utf-8?B?Qit5b01PZnF2QXhLelNCWnhPOGJiOGplSkdLU0dDbFI0Z3U2V2oyYmM4M2xX?=
 =?utf-8?B?dEJpMHp1ZVJtcm04VEZ6cUd4ekFuV1I4U1ZDeUloYmNMb1g1b3MwN3lHY1hM?=
 =?utf-8?B?UmhmN2E5UDFKOHBzUHFWVmxhVkt5MUVyWnZUNlBzdFM1TVRGajNoM3RsNkdq?=
 =?utf-8?B?cU5hNFp6NWVHVGN1SXhWbmdNRkQ3ODh3YnVESzVPNUc3WGg4UkROVG5NenN5?=
 =?utf-8?B?Q2JKYnhYT2lEYzNNa1I3VUxFYllvV2FPeFRybXo4UzA2enc4NzR2UCtQM2lo?=
 =?utf-8?B?d295NnRkWVM2bTBGTzBqZXhFZ2lCZ294bE9ibzdwWGMyS3ZSK0VRcy9FbjBr?=
 =?utf-8?B?RmduaWFuL1dDNjJGaUIrTURmS0FJMzcrOUZpQ2ZtcytnSUpEV1QwWFJ4YU5w?=
 =?utf-8?B?QThlOHkxejBFSklwdFJaY09DMWsrSUc5eFNRTlo4VUxFSzNhNzQrVXJmMnZM?=
 =?utf-8?B?ZnBKRVo5QW5aai95djk2TS9ZbGlKaWxkZnVIY1ZlNVViTmJITzgza2w5RFJE?=
 =?utf-8?B?blRGYldxckhnNVNzZG5aR25jT1hpVzhFRzk2QUxXVnJPUk0wZWt1NU12bm8r?=
 =?utf-8?B?cVFRMFFnMU1HYjZOK2IrU3k5bkN4WE85d2Uybjlyam1RZFQ5RWpWa2RrK1dI?=
 =?utf-8?B?TDZPeUFLMTY2OCszS0lRN1ZTejF4bStmZnhPandtQ1dLNmZUWkw1VVJiZlBU?=
 =?utf-8?B?bXJjUEQ1SDR3bXdnY3dHbUpkTFFHQVk2MUNBRE05c09mNTI4RkltclByVWta?=
 =?utf-8?B?UW5CUkV1RDNFUHplZDNZN0wxVFlLN3Rod0dUTjZReUg5cXcyZW5RQi84Zkwx?=
 =?utf-8?B?UmoweXJVbG9hc2cyeUNrM1pPY3RNMEorN2ZNOUE2U0tQMllQQXlKSEJHLzdK?=
 =?utf-8?B?UVRKYXl3dytlQnFaTS9RYXhRSzErSnI5bUZ6dHh4Q1RucXVWeGlhdnZwS0ZS?=
 =?utf-8?B?enNXWSsrUDg5NGwzbEVnTnAvTGZjVm4vRWwwYVQ3V1M2VkY4bG1OSjUyZ2Rt?=
 =?utf-8?B?REhiTjRaQ2tNVWRUd2wwWittUEpLaktKUkltY0NXdnlEajdmV1paTWRiV2JN?=
 =?utf-8?B?NDJKNzVhNVhqelJhZUVHQ3JKZ3BhcklMRThJKzJFZnB6NWRweGdSSlNqeE1B?=
 =?utf-8?B?aStTOUN2RDNXZ3B1V0RZNDVrVi9lS3B6TVBWY1BiOFFMUmo0M29oeVV4QVZK?=
 =?utf-8?B?UlpCbzJJMVlUYUxVaHd6TVJ1V0FPaFZXNUtHdWpyWjA0TFA0cmJvUEh4Q0ZP?=
 =?utf-8?B?V2ZJd3NGRWN5dkc0T1A5ZHRHQ0l0YUpwT0pvcTVkNFlwVHdUeGE3c3BmTjZp?=
 =?utf-8?B?ZFFzRnN1OU9jaUIvMXg5dDlmWEdLVzFKeHpVWGl2VFFWU3dwclkycTdMWHY5?=
 =?utf-8?B?V0VlaGc3Um9XME5vQzRmejVuUlVuL2dpek1nSnExM3pBbzZ5VjI2dEVJMXA4?=
 =?utf-8?B?d1NQYjZ0V2V4a0tXWWR5dWZkMHdZOHg2ZWRiN015YlF6V1RCSXlwVnNvRjN2?=
 =?utf-8?B?bjZDMW5QS1N3QnMwZnprbTk0RFJhTldUOFR4MGk0eU1aeEJXcXhkTlRGZU9m?=
 =?utf-8?B?NC92ak50RkRqaFQrelM0RGNaY05GV2JVS1VMU1ZnQytUNmE3YkpaQS9pbVh5?=
 =?utf-8?B?SXpVQ1RrUmR0amVuSmNKdlJrRGQrWXoxL2lsV1BJYUIyVXR6M1RBRTFXTEpN?=
 =?utf-8?B?OUl0SExpa3c3aDBLaDFpVlJ4TFp6Ykk1MzJmZEFYRzg2RXRYZVpCSUs3NFdE?=
 =?utf-8?B?K3V2L1R3b3diTmE2c0phRWpCZGM2b1Z6NGRxQk9WZ2k1MFM1N25oS0h4NW1r?=
 =?utf-8?B?OFp4NGtOanlBOTVsU1hDQkdOUXluZ3FncWozTUtYUHJZYmVMQlkwZWUzRFEy?=
 =?utf-8?B?RktwQkNuREN3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0tiSktyWjh2aDEvelh1TVpJRGJleCtpUUJNeUxiMm84dVRBSHNjM0ZzNXlO?=
 =?utf-8?B?WWdpM2VSNGRUQnNKdmhScUJXUVFmRmRBYlEwaGJ2VkMxQ2NPcWRRS3hKZ25Q?=
 =?utf-8?B?eFUwaGFrR2NwZkdxdElJS21wYTUwQmphamNKaW5KOStMa2NEUG5CQXdyc3o0?=
 =?utf-8?B?VHFjSVY2bktDTlBheml1ajhiaFZvR2ZvYkxRemQ4UFFKRE5zT3pRcW1yb3FN?=
 =?utf-8?B?V3hXY0VGZk1YMmlhU3JNMXh5a2NjK3FvQ1l6citTb1BFaGFmR28zY2xmOWRq?=
 =?utf-8?B?amZ5TU01amdScmMwSXZnWFVwaU8xUGhEOTJlalNESkpqdXYwejk2OENCQkdD?=
 =?utf-8?B?TkU2MFl2bkIwSm5vMEhOOU40N3FLcTdsTVN2c2RST2cySEZubi9QM1hSNjR2?=
 =?utf-8?B?L1dqMUdXZ1NYRU5FK041MXAvWEJ0NlNCUHllaE56TS94WVpmKzFKT1ozL2U0?=
 =?utf-8?B?WDhHS3JIR0psUlN1czBYdFowUGRDNktpbmJzRE91N2N0OXI5Z1pMUzl4Znh5?=
 =?utf-8?B?c3V0MndibVhRaVZJTFg5NFVzSnMybldOUDloTHhYejNtZ3dwYzNrZXp3Rklq?=
 =?utf-8?B?Q1R0Qm5mSWd5Tm93NHp6TWFHcFp5cmtubnA2cXNDKys3NE85UHR1T2Mrd0sw?=
 =?utf-8?B?MGM5RXlvamhPVVYvd1d5cWNzUEVzYi9Ydm1MMDFFOWJNNnJiL0xNNDVDUmNj?=
 =?utf-8?B?Vy8vSWVaaCtRNmU1cTd6aHI2RFdUT0JKc0lxV3hNSWNMR2V0RGY0UWd4T0RT?=
 =?utf-8?B?YlpDWUg1d1BvOG9hRVJsYlo5aUd3bmdKVlZhT1ZLRUYwdGhnb1MvMTduVFZX?=
 =?utf-8?B?SzVicmlXaGNFdHJKandnTEw4WEJkV0wrQldzTEZPTVVkdlVFcUhEaTZVKzJm?=
 =?utf-8?B?OFFJdmhVZ256N1pXdU5scnNmL3A2eDFUNmFKNVJsaEZnZThXWUFsRGNkSjBL?=
 =?utf-8?B?RkRyalRPeWdiWGNRMzQzRWxuSWZKUUxsNnZWZy9VUksxelpUMDhVNGlId2xB?=
 =?utf-8?B?TjdkKzdKU001VWYrOXdiRCt5ZUhISEhRaEpIUUJlaENjM2R0UDRiWGJQYnpG?=
 =?utf-8?B?UjhSZkhCVHBrVUhvaEVYU1JHMXpEQ1RQVnJsZW56czgyU1pDeXRuNWRTSVRD?=
 =?utf-8?B?eERqbmdqaHhLc0UvQVlSRWNSVmtRLzV5MFVrdFNVenNPY0c1OW96b3F5SGRs?=
 =?utf-8?B?Z3F3dHlka3VIRzlpcU9LQUhpZ0tKb0t0aUYrR1N2SUh1Y3hBSTRiYzJnYlVz?=
 =?utf-8?B?YlhhTGNoTW1uejdya1oybVBRSVN6dGhNNjRkT2NrZzFER1Nnbnk2aGgwcEF6?=
 =?utf-8?B?ZXQ2LzUrK0p4emZXSEtqU3oyYktkUEpQQ0kwM0NwWTlOczI1bGtIYVo4UmdL?=
 =?utf-8?B?QVlKcTNZS0hIVHRTVitteVBsMEFoR3Q1cFgyd0lYbGNlcXlVUjJhNTVLUEsw?=
 =?utf-8?B?L01ZRDd0QjFlWS9JdWVscmR0K2xFZ3FJaVRjaXVLRkFmTkZsWUh4TlBLNlRK?=
 =?utf-8?B?bjRzbm0ydVM2STYvaGZUSDE3STNEb203ZkFpUWYwNm1zdDUrK3hBRjRXZVpI?=
 =?utf-8?B?WlVFOWcwQk1Hb2Y2NEJlUllNMi9ySFRybkpyTDBTZy80dnV1eG1JdUwyUXlS?=
 =?utf-8?B?dVZsU0RFYi9iTFZJeCs4ZlRIWC9EYWU5dXVHT08xSTErMHphdnhTU2RhVHc5?=
 =?utf-8?B?VEUrbGRMMkJ5UE1ZSXlwVUE5eEdiN2RRcGlhV0haUDBDU1VHMklLQ0lUTmZw?=
 =?utf-8?B?SkxVVHY2WW5SNkZtSTRMWWxxMDVUZW1EbWRlQlhueFhMYXo0dVJzcVpsYjBh?=
 =?utf-8?B?RnF4eHhUeFRjT1ZEWnJXV1hwemU1cmFsTGFEcHh0OFAvb0VUdk54TTFUWVNa?=
 =?utf-8?B?L1N6N2tNU3RlcEZobUtNSXh1L1RYdHJNUmFaR2lqRi9tRE1yNVJVemxxOWZW?=
 =?utf-8?B?aURnaEVmR1J3NEVmalpRQmIwOUVwZXQxUUxkUkhHZzZwWXd1cm5ZdytEb1JB?=
 =?utf-8?B?RW9yZC9hR1FuTlhvQ0lqWlZOMWtXWVpuTG10ZXBDczByT3lQWEhUQllDbEE2?=
 =?utf-8?B?SlZTQzIvbktlTk4yZzBnTFFZVUVKSkcrM0FxZ2EzRE1kcUI3YzJiVXh6TSs0?=
 =?utf-8?B?cWFvZEJWN1l5OTFTVVJvUzBWTWl5Y0psS1ZqcUN5eXl3a2IvMW90eVJLZkpn?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cbc337-35a0-4ae6-a61a-08dddae6f1e2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 03:59:19.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1AMrdgb5Fu3mIbdysClNgC6AtxV8ElpPTb1FAHV76dt4VkdxPSEGdzPvcNxMObKM6/6T6Bg/JfCYGONNQEtj1Ll5vXvwC68nl9EnCypSxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5198
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> All monitoring events are associated with the L3 resource.
> 
> The RDT_RESOURCE_L3 resource carries a lot of state in the domain
> structures which needs to be dealt with when a domain is taken offline
> by removing the last CPU in the domain.
> 
> New telemetry events will be associated with a new package scoped
> resource with new domain structures.
> 
> Refactor domain_remove_cpu_mon() so all the L3 processing is separated

"separated" -> "separate"

> from general actions of clearing the CPU bit in the mask and removing
> sub-directories from the mon_data directory.
> 
> resctrl_offline_mon_domain() continues to remove domain specific
> directories and files from the "mon_data" directories, but can skip the

"can skip" -> "skips"

> L3 resource specific cleanup when called for other resource types.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 17 +++++++++++------
>  fs/resctrl/rdtgroup.c              |  5 ++++-
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 66270c230b4e..448c2bf9837d 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -649,17 +649,22 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
>  		return;
>  
> -	d = container_of(hdr, struct rdt_mon_domain, hdr);

This is an example where the requirement introduced in patch #5 to use
domain_header_is_valid() before container_of() is broken. The container_of()
is moved but its sanity check does not follow.

I think the domain_header_is_valid() should also move to be right before
the container_of() and when doing so the resource id should be
hardcoded to be RDT_RESOURCE_L3.

> -	hw_dom = resctrl_to_arch_mon_dom(d);
> +	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
> +	if (!cpumask_empty(&hdr->cpu_mask))
> +		return;
>  
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (cpumask_empty(&d->hdr.cpu_mask)) {
> +	switch (r->rid) {
> +	case RDT_RESOURCE_L3:
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		hw_dom = resctrl_to_arch_mon_dom(d);
>  		resctrl_offline_mon_domain(r, d);
>  		list_del_rcu(&d->hdr.list);

When making a change please check if same change can be applied to other
parts of the code so that the code remains consistent. Like here where hdr
can be referenced directly that is now done in domain_remove_cpu_ctrl()
and will make these two functions consistent. (oh ...  but that change did
not actually make it into the next patch even though the cover
letter states that it did ...? )

Reinette
