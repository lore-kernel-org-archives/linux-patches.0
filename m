Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04F923B61D
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099489; cv=fail; b=GFNkhtCIPX+RnMEERL5sucQKKI5gnHumf5hroMI85OXEcjzb/cr17ETX3ELjDMAIFjPEDPtjCCjXSLg2dDQFG2G/CrUJ6Qb3dB3yM7IDYtaIrMpdYbAAkZPj3wQsSDHISQcns2Oo/uN8jz3Ezg7bemmuoImPVqaUn9hWXYhigoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099489; c=relaxed/simple;
	bh=sG+OEjeD/W9AjW1YAhLVQziRzpNdh8qio9M7ejgISIw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qWMY2zyFHxJBNopq7iIEztue5pxFGveWu+hY87Pqb+/+gHucY29KsYW4Pb250cZW/2iEYxFv8/ewPBydZHgjLjUv+BDJVfXbDRuKcpaW9A/TuSjzjkcjESXsDnjM+UQv2pDxvwDltekDERVq1Wci06ZkIi50bpm1QM+3cAll9lY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fN7y0MSt; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fN7y0MSt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099488; x=1783635488;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sG+OEjeD/W9AjW1YAhLVQziRzpNdh8qio9M7ejgISIw=;
  b=fN7y0MStbMCfKVtNfctEt4FJF4sZ7n402EURcPWHj9yqx2e67Cue5ARL
   C8raqEBe9dZrloemVVtNDPzQY1vhVLtVpFOwDJ6xSgMQoiTQgL5tHnT80
   alCNZabpVmT2JIpKZyQYSs+vv7trn71j5kczZEcJGS7lWwMWmSz1bxZfY
   HZ36uZ5OURBARXcDTl37gk0B7XrQGg9drJhX80mJ3pCyX64NIG0g2gIix
   whaYxPQX0mnHDD9HYSNWFEdZI63SE06tbsFtybLUO3ObzBFwSWQRYs3K3
   K2fNFDczHWCGOI/nQuN0aQI2lvd14GUJj8jgug2/xlBXgXeUHdtpcZ4FN
   g==;
X-CSE-ConnectionGUID: bNr0fOiiRvu9LS2oRwg0rw==
X-CSE-MsgGUID: obAkdanYQ7Ol9pnh5XcWKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54501343"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54501343"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:18:07 -0700
X-CSE-ConnectionGUID: zVX/a+jMR6uS0cRCHhFBWA==
X-CSE-MsgGUID: A997tsOyT4OWmWbsrxdo/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="156627642"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:18:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:18:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:18:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.50)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:18:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kUGzgxMbJoe29Y6gfSe+KiBEh1behqsXE70i5VxzBmBlShXhNj6pSK2Rd75M1cKGP6bcc++E9Wsu25PLR1/WVhFlTI5tV2fRIA+4TLz+pdDtP3iTkUIdsPv7Iuw9N2u57zhmMYDF5utsyJN964n3hM6u/6s58OO2xDhaWJocb1lmyOoobCpopna2PS0Xm+kfVZPPEpRYcsSxifjQhcp8mlQHqltFF9gViOZ2k/K+d3EbX0zv0SOGPZ84BK89ldNvDdjGeRFjrMXNpkSPDEJrttmsA06C4llgmeXM45A77Oy8ZiBW+A9T0MPZ7F41N2/c7bDLZlBg45hfEW6Ruma/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dlSV/ANTB3RypA2FNPK9ZdreiOfuA/1JTjZQsSbxbg=;
 b=RhskF/T8wKBBV4AtiNxBZ4pxous47R0kW2MbF8QDTVR/NrukI8lkfKxVCeH1gmG7M3rW1gu+Zyr1CD3ySegsEptJQApw8uQwjWJ80mwwjtPtujhFe0+eNE74QK0BgLoPOJJhVL3ihLgy1zirE+8nR20jAALJfLbYfwUetTyK2t1deMjBbAOzeyaQRl8oasnISaAgUFhkfnS/+PnD8oLpwbq5jP815uRz64VCncbMVYOpA9+yHbAceVNrgrC8MDgy6ti+LF150jG+KmvXbTvMF7hac8MH0+gn8c33kT/oJ1Bq2BZT4Jsgp8oz2kc+NlPi/H0Q4oZ80Wshk4BrjniHeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 22:17:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:17:34 +0000
Message-ID: <c74dfbb4-5570-40e6-8598-5cceca87746e@intel.com>
Date: Wed, 9 Jul 2025 15:17:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 25/30] x86/resctrl: Handle number of RMIDs supported by
 telemetry resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0136.namprd04.prod.outlook.com
 (2603:10b6:303:84::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 07edca75-96a9-4629-a207-08ddbf3667c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bE9zcmozUXVDMnpQa0xTQ1ZXb3JEYldpR25IRGFEbkxLb1BMUFg5UVU2b0Zt?=
 =?utf-8?B?a3BySUZyLzdhYUlyZUtTZzlvVm1Obnh2bVcwMVlPanVtVnRVQU9WY3hkY1Z4?=
 =?utf-8?B?NkVsTzlqdTYzdytYTEZHeGJCQ1gyYmhTcVVybDVEY2w3QllHQXZsSWNwaGxy?=
 =?utf-8?B?Zmg0YzA4eCttYll1NFNpcGdYMG5ONGRyZGhMUEZTMW95Z1RWSjFvdzBNL0tq?=
 =?utf-8?B?YTlYK0orUmNVR1lzNnlrNnF4Yk5jUGhINGFLRHN3cDN5VU1VOU12eU1ydytK?=
 =?utf-8?B?Rm9EZTBFUTAydEczelp3NUFhYWx0SjE0bjVzOExyN2ZINXF6K0Z5ZlpwUjdV?=
 =?utf-8?B?b2QzS1p1dWFKbjFGVm9BMmtYWTY3VmUxMG5oN2VBcTVlOHhaeGxxcWRhalRs?=
 =?utf-8?B?WS85eEJvUGROS21QR1BrV2RNSW91NDFtREdhZ21LaldHTjd0UHpweUYvRTZh?=
 =?utf-8?B?REJmb3BBTXhOQ1JBYnAyZkR6NnZBcHdVZmtCRXRIbko3czIyZmxnZnU0NldG?=
 =?utf-8?B?NU5LbjE4eFJyYXB2QnFaNFlGcStvTDE4MkZ1U3QvK0p4VnRGMStwRVZkWURy?=
 =?utf-8?B?NUVzbUZmbzJyVE5Ra0xhT1hBK0Nhc1o2ckdweFE3Ym5LMFZDUnhUZHBEMXor?=
 =?utf-8?B?RThqZEYzNnpReDl5ZlZaYlF3MC9FbFhvb1RwMWhEaVRRSlFma2JseFcrdlJK?=
 =?utf-8?B?eXhRSjk4Y1gxcXh5Vk9VYjV1YU5wQ1VtdTljUDEzckExUWJPc2lRTGsvREV1?=
 =?utf-8?B?NE96L1NML1JrWDFGOW04dFZmeno0RkZmVFBMdlg0aHFNdS96UGN0M2NKaDRO?=
 =?utf-8?B?T2UyZm1vaWdSL3BjZnlEUG9ic2dpSkZmbERvVzQvOWF6SzZNbmFiemJEZDRp?=
 =?utf-8?B?Z1FiYlAwejYvMXdsNEFDSFdaK2FFcmx2UUJhZmxBdEllTkcvTnhqblFmVlEx?=
 =?utf-8?B?ckFlM1Q5S3NtV3hIVE4wYVpoWURCdVZQV0ZHRFBPR1ZyNXo2QXFGRmhTLzdo?=
 =?utf-8?B?YlNmQ0tzRCtWQmRzaHQxcVhCT1dtT0dNSGhiOXY4Mm4zY0owS0pLRzJFTmZS?=
 =?utf-8?B?Qzl4T2tNUHhoRjNHY1Y2UmsxMGEreGZvdnpHako0ek02NjE0MDc5TVpobTlq?=
 =?utf-8?B?ek50T1Vud3Zja0pDc29ROXdkSTlFeHptak1aaTNEaDhCdkdKRTByVVM4S01Y?=
 =?utf-8?B?ZXNmRGVZMWZ4MGdBajE0aVVRRlRWdGY3TjNVeU11VTAybjVoQnBxc1BrdHJP?=
 =?utf-8?B?YjNaRUlJRFlHUmQ0NlBiNzV3bmpPVnpCazkzRkpYN2ZLaG0wK0kyVGVFdEs3?=
 =?utf-8?B?anM2R1FlNnhvckVLTVNReEJoMWJLc09QdmtjMWgwTkt2V1F4Z0FxOXNQcnJT?=
 =?utf-8?B?QXF4U1FiZUE4K1pHcitFTCs5eW15amtpMUpDWDFwUHlXSkhkcDVBMlp2Z010?=
 =?utf-8?B?Wk9ZUW5oUTMrMmdpNHh4Y3lwMm1JazV1R2k1dmh0M3lpSHh2bzFOa290cW92?=
 =?utf-8?B?WUhJeFJQcitkUDhxb0NTckdsR2lqdndJcHlKZXNBaVRYZjVsTlhid3BQQ1Vy?=
 =?utf-8?B?UGQ0a1ZvSmNWNEh4MVpJYnJnRUFHYy8zajBtWWtVZVMvUGZRd2FWQ3I1dEtL?=
 =?utf-8?B?bURKbFNBdmRXWEZCNFpCUlFQYW9HbVlzZm9PTzdNTXNwY0NGYW15OGZPMkQ1?=
 =?utf-8?B?aVozSGt2MTVVdVA5T3pDc0dLVUZmam1lNjAyTUQ2OWdDR3J6WVB5bW80K1hw?=
 =?utf-8?B?ZUFna1Bra1B4cFV1d3l5OGJvU3E4MTczVXp6cnorZ1NFbWJ5NmpraDUweWJu?=
 =?utf-8?B?THIva2VzU3NQT3Q1R2ZGNU12cGNlUkFwcWduQzlrdXN2L3IxczVFL2FNVHJv?=
 =?utf-8?B?RkZRaGM5VW5tK3hyYk9VZ1BmZU56bHZJLzBENjM5L0pCTjFQeXVvY0xoK2hE?=
 =?utf-8?B?Wm54RVFDMisyUS93UkluRXFYSlpWSzlMcExWYWxieFJDeE5tVEF4dFZqQ3pM?=
 =?utf-8?B?UDEzQ1h1VklRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFNPcXZMU1ZNOHFVTE1kQlVYT3E0UWJTS2tWanI1cUVTRDB3aENVL1ZDc2Jm?=
 =?utf-8?B?Rml6ckxFUHIzOHUwYmVTM2pyY1JvZXJGa3pZZDZNK1hkekxDZzVwNE1OU0Vj?=
 =?utf-8?B?QjF1NllkWFdTNmUzdmg5QUJQQnVpVlJQMTNlN0VUYmxBeWF0alBvQnRaL3M2?=
 =?utf-8?B?WWJ1ZVExbFFPY3E5NUxvZnlVVWJRNG9TaEhacTBxcDNTeE4yMndEeGRhaDdl?=
 =?utf-8?B?NTBsbGlQb2U3S3dNZFpabE9rQkxWcmRudXlPOGU2Zm5wRmVMSlpVd25veTFa?=
 =?utf-8?B?MmpsdlhDQ01yMDZqOGU2MjRTcW05S21MK0xZS1pGQzhPL0RUMWJ1T0xFY3No?=
 =?utf-8?B?aSs3OGhKSnRJckVVWVlYdmlobkp4ODVIZjNIV1p2QUVyNll4UzBZbUh3SkRQ?=
 =?utf-8?B?aU1KT3ZhakRmNEo3LzBZV1pETDl2SDBaT1g1WnVSaDYvKzZwaWNSN3FRUWZl?=
 =?utf-8?B?QnhkZU9UZ0lnemJQcDVpelA5N3d6WVhMVVRiVkM1ZW11VThxbGFhUVQ5TndV?=
 =?utf-8?B?WGx0WjdKYUJpalBwcVZYTThTZm85R2d1Y3ltOFZRTDJHWTNGc2hOUEZ0ZDNk?=
 =?utf-8?B?MU5EOURYMFhxbHVMSVFOSFA5S3ZXOU1laEM3SUl3VVBOR01yK3NocXQ2dmZJ?=
 =?utf-8?B?NC9xYmhQcXBSMDcvcHBjbFhaOGxjSm5DWXJTWG5JTWJ1VElqNUhmeHpjMmxV?=
 =?utf-8?B?TUVRSjg1M0ExM1h5NWNzNHBvdW51WXJYYWpTblB5K1ZTUzZSbWdqL2h4eDlz?=
 =?utf-8?B?L3ZMa3pIcUtZVHpsaWowZEY3WDF6R0VZUEw5ekFhNzc3dTNRdTNJbStSY292?=
 =?utf-8?B?L1B2amFtTUlVdkVDK20zNlh0bGtxeURDekxpb0wvNlFmQmxnbmFvN2V4aG5s?=
 =?utf-8?B?OXNhaDBMc3cvMysxNEJleDA2OERSempoZXhobWI1Njd4a1pFMlY5VW1zS2ZV?=
 =?utf-8?B?WVVXc3FzRGhwREc3K1hMK0kxQ1V4TXliejIyUkk2VUtCUUR6TTdYYlMyR3F6?=
 =?utf-8?B?RWlQdzlHUVZFS2pCRXFHbnNKOElpZXRCb1VMV2s3czB3ZDNIQmUyY1IvdnZU?=
 =?utf-8?B?YUR1OEhCanp2VWZRVE1Eb01QKzN6R2c5akg4YW8vRytsbzdHOW5nL0ZrT3ll?=
 =?utf-8?B?TDdPNERrY3NUeWRwenNodnVEbXhzZ2xBYUI5Q1pBN214Yys5T0k2bWQ5ZWFx?=
 =?utf-8?B?NGVzOUk5YmxVVWZQNjlkSktBYkxlNWZzSW94TFMxOEN5MG40ZzM0cEtxNWRx?=
 =?utf-8?B?VXA5NjJHVkJhemljdzNBR09jMFByekw4MUpsaUNSeTBNM1M5ejFYWVB5blpw?=
 =?utf-8?B?N1hZTHB4WVJxa294dmlFelFKaXNCcnA5OW1rWWFVM0s3WDFpM0JvL3c2eGRU?=
 =?utf-8?B?TlhWMWhyV1lVeVNzTWpJS1VsTlFjeG53bkt0ejlkaWlZeTdnNVNvS1hPSkV6?=
 =?utf-8?B?eHF6R2xkdjJLTisxbFE1Y0NtbWo2aXFDd092TzhNUFR3VTVScnlaWUlCMG4v?=
 =?utf-8?B?YXFLOUxScUkzck9yOUtGUGNqNHA4NVllNDI1NVluaXJwYVVhQUM3Uk91L3M1?=
 =?utf-8?B?YmEzZ3ltWWVGSDFPSDdkcTZpcldEOEhPK0FBS2tPUHNYamxKOFUxNFdsYzFu?=
 =?utf-8?B?YkRReFFUQ1JXR05NOWRtanRTT0dORHNQQVJScVBneVEzMFdwS20yWWE0S3VF?=
 =?utf-8?B?UmtRUU9GdmdpOVMza01abmhYcmhaMXNUTTRqbG5Pc2V3N3ByRnZuNlZ3VGZ4?=
 =?utf-8?B?dk05eWRqZ1pBdWxQK3dwMXpYeDBFV1NuWmZaWTQ3RFlJbmxicGJLK1JtSWVD?=
 =?utf-8?B?ZHczUVVMUnA2elZDY3RTcUhlTVowWlBpaWRXdUVpcjltdTRFRHhUbE9hRS93?=
 =?utf-8?B?TjZ0TmNIWVpIYUE0M1ZxK3FnTEl3ZkxaajU4cW1BSFlNRkRGMUJ0ZkRPZGVl?=
 =?utf-8?B?dHoyUEp4RzhIbXJYOVN0K1hZbFgxSXB1c214ejB0cTN5SllGNURhTThqSGNk?=
 =?utf-8?B?bjFSRW9hMnVscEJXK2FzNHJWRElWNjBsQ2NQTGYxOGp3OEVFWnlnRHczVXVw?=
 =?utf-8?B?SmZyeVE0ZjlMOEluMks3Yk9HSGhUR00rUWhQdDlEV2dla3YzR3VyRHVjeGQv?=
 =?utf-8?B?MFFsTnpoNnJ3Z2ZFNHdVZTd5VHk5eW0yMDg4K1B6dXBGZ2pHT0JPNExDNFVV?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07edca75-96a9-4629-a207-08ddbf3667c1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:17:34.8237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C9GXhiqlk+COAEujUrwjaGyCXhZCG+MblFzLaC9Xqm+QVY16rDXmhhmoQOu4df6b3Ty5NVQhePydwqFH6cCbMX3lh/nSA5395KOpij/Dq1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into the
> IA32_PQR_ASSOC MSR. Note that systems with Sub-NUMA Cluster mode enabled
> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This
> is enumerated in the XML files and is the value initialized into
> event_group::num_rmids. This will be overwritten with a lower
> value if hardware does not support all these registers at the
> same time (see next case).
> 
> 3) The number of "h/w counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "h/w counter" to track all RMIDs are
> difficult for users to use, since the system may reassign "h/w counters"
> as any time. This means that users cannot reliably collect two consecutive

"as any time" -> "at any time"?

> event counts to compute the rate at which events are occurring.
> 
> Ignore such under-resourced event groups unless the user explicitly
> requests to enable them using the "rdt=" Linux boot argument.
> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
> resource "num_rmids" value to the smallest of these values to ensure
> that all resctrl groups have equal monitor capabilities.

The "to ensure that all resctrl groups ..." seems to describe the next patch?

> 
> N.B. Changed type of rdt_resource::num_rmids to u32 to match.

rdt_resource::num_rmids -> rdt_resource::num_rmid 

Please also check that existing code accommodates this changed type.
See for example,
	rdt_num_rmids_show() {
		...
		seq_printf(seq, "%d\n", r->num_rmid);
		...
	}

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  2 +-
>  arch/x86/kernel/cpu/resctrl/internal.h  |  4 ++++
>  arch/x86/kernel/cpu/resctrl/core.c      | 20 +++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 29 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  2 ++
>  5 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index b9f2690bee1e..35ae24822493 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -288,7 +288,7 @@ struct rdt_resource {
>  	int			rid;
>  	bool			alloc_capable;
>  	bool			mon_capable;
> -	int			num_rmid;
> +	u32			num_rmid;
>  	enum resctrl_scope	ctrl_scope;
>  	enum resctrl_scope	mon_scope;
>  	struct resctrl_cache	cache;
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index ee1c6204722e..11f25c225837 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -18,6 +18,8 @@
>  
>  #define RMID_VAL_UNAVAIL		BIT_ULL(62)
>  
> +extern int rdt_num_system_rmids;
> +
>  /*
>   * With the above fields in use 62 bits remain in MSR_IA32_QM_CTR for
>   * data to be returned. The counter width is discovered from the hardware
> @@ -171,6 +173,8 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
>  bool rdt_is_software_feature_enabled(char *option);
>  
> +bool rdt_is_software_feature_force_enabled(char *name);
> +
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index f9f3bc58290e..7fe4e8111773 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -895,6 +895,26 @@ bool rdt_is_software_feature_enabled(char *name)
>  	return ret;
>  }
>  
> +/*
> + * Similar to rdt_is_software_feature_enabled() but the test is whether

This is just too similar and makes this code quite confusing ... (more below)

> + * the user has force enabled the feature on the kernel command line.
> + */
> +bool rdt_is_software_feature_force_enabled(char *name)
> +{
> +	struct rdt_options *o;
> +	bool ret = false;
> +
> +	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
> +		if (!strcmp(name, o->name)) {
> +			if (o->force_on)
> +				ret = true;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt)
>  {
>  	if (!rdt_cpu_has(X86_FEATURE_BMEC))
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 1d2511984156..1d9edd409883 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/resctrl.h>
>  #include <linux/slab.h>
>  
> @@ -55,6 +56,9 @@ struct pmt_event {
>   *			telemetry regions.
>   * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
>   * @guid:		Unique number per XML description file.
> + * @num_rmids:		Number of RMIDS supported by this group. Adjusted downwards
> + *			if enumeration from intel_pmt_get_regions_by_feature() indicates
> + *			fewer RMIDs can be tracked simultaneously.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
>   * @evts:		Array of event descriptors.
> @@ -67,6 +71,7 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	u32				num_rmids;
>  	size_t				mmio_size;
>  	int				num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);
> @@ -82,6 +87,7 @@ struct event_group {
>  static struct event_group energy_0x26696143 = {
>  	.name		= "energy",
>  	.guid		= 0x26696143,
> +	.num_rmids	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  	.num_events	= 2,
>  	.evts				= {
> @@ -97,6 +103,7 @@ static struct event_group energy_0x26696143 = {
>  static struct event_group perf_0x26557651 = {
>  	.name		= "perf",
>  	.guid		= 0x26557651,
> +	.num_rmids	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  	.num_events	= 7,
>  	.evts				= {
> @@ -177,6 +184,17 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  			return -EINVAL;
>  		}
>  
> +		/*
> +		 * Ignore event group with fewer RMIDs than can be loaded
> +		 * into the IA32_PQR_ASSOC MSR unless the user used
> +		 * the rdt= boot option to specifically ask for it to
> +		 * be enabled.
> +		 */
> +		if (tr->num_rmids < rdt_num_system_rmids &&

This check comes as a surprise after thinking that I understood the changelog
and function comments. I was expecting a check against e->num_rmids instead?


The changelog states:

> +		    !rdt_is_software_feature_force_enabled(e->name))

Having this call here is unexpected. The way resctrl has handled quirks thus far
is to disable a particular feature explicitly based on some external knowledge (eg. errata).
This is different in that resctrl does not hardcode that a feature is disabled but attempts
to determine this by something that is discoverable from hardware self. Integrating the
feature enable/disable into the flow that actually initializes the feature looks
complicated to me and the strange rdt_is_software_feature_force_enabled() supports this.

Could you please consider adding a new function call at beginning of
configure_events()/discover_events() (before calling rdt_is_feature_enabled()) that
peeks into the struct pmt_feature_group to verify if all parameters are "sane" and
then explicitly disables the feature (for example, set_rdt_options("!perf"))
if any parameter is not "sane". This makes it clear what requirements are from
hardware and what is considered a "quirk" and not even attempt to enable it by default.

Following this function with rdt_is_feature_enabled() still enables user to override
such disable.



> +			return -EINVAL;
> +		e->num_rmids = min(e->num_rmids, tr->num_rmids);
> +
>  		if (!pkgcounts) {
>  			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
>  			if (!pkgcounts)
> @@ -263,11 +281,22 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
>   */
>  bool intel_aet_get_events(void)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	struct event_group **eg;
>  	bool ret1, ret2;
>  
>  	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
>  	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
>  
> +	for (eg = &known_event_groups[0]; eg < &known_event_groups[NUM_KNOWN_GROUPS]; eg++) {
> +		if (!(*eg)->pfg)
> +			continue;
> +		if (r->num_rmid)
> +			r->num_rmid = min(r->num_rmid, (*eg)->num_rmids);
> +		else
> +			r->num_rmid = (*eg)->num_rmids;
> +	}
> +
>  	return ret1 || ret2;
>  }
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 51d7d99336c6..b36634f1439b 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -33,6 +33,7 @@ bool rdt_mon_capable;
>  
>  #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>  
> +int rdt_num_system_rmids;

Is this necessary? If I understand correctly the next patch will ensure that
resctrl will not use fewer RMIDs than what can be loaded into IA32_PQR_ASSOC MSR.

If it is required, considering that this patch goes through effort to change type
of rdt_resource::num_rmid to u32, should this also be u32?

>  static int snc_nodes_per_l3_cache = 1;
>  
>  /*
> @@ -358,6 +359,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>  	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
>  	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
>  	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
> +	rdt_num_system_rmids = r->num_rmid;
>  	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
>  
>  	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)

Reinette
