Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD1072601
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007975; cv=fail; b=uX+vg5pq7T84pYf0NTtJy3/B9XFKs/vkytnfb3sWASnTncl4WuRt25e3wNC+mlU9vmcw2i3B6Sk2tGyZDOrowEnCw/hE8cMGit/lg90cLGy51OclQtEX4Xt9lP4oUYMo4zDgCwzK/RusTAC/YZoscbWX7AO6K6gBiGVg7etfIEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007975; c=relaxed/simple;
	bh=OCFS6aTfqJhmYVtNzJ+p3P1nZblHPa0ER+ZxnfY6/O8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I6IE0x+V3Lz8X4V/LBFgL80zkNFKKzmk5d9YGXIMJ3Qh88Di4QJTc7CYbM4zs7g4ayfeJxClRCk45PdP9rzSRDsFsgC2xUrXeSjUUTkCPVsYGRZ0SE3UB8sG5u9K56k4D9kLIA2rvdE+IlpxSegcVWmlUIp+ln9dFmR59JYWRCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SnQl+vYB; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SnQl+vYB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749007974; x=1780543974;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OCFS6aTfqJhmYVtNzJ+p3P1nZblHPa0ER+ZxnfY6/O8=;
  b=SnQl+vYBrdkcxffr4XYHsePBn8QpGBv8Mdn1RbwFZQpjDbMW1bUR+oNi
   X2Ti/RM65SeGTb5v9H1vYfG2ZUmJc5DKncbUp+3W0R92h+MoadmfHQTAP
   KYwDmlFfV4HInkqn/yiuHJEbxbZ9WBusiAAEiuIR/0m9qjej0JZ2bhN/l
   6Rb4izamc5C60UlEcPQm1x+pUeAnUsTwBVYO6FOcCaxRcKKkkETPpZR8+
   Esahjp47aV4FO/YWziQja4O94sX4olewIZxxk83T/IeX20kys/p0W+rON
   IbPWTMxX+Vp5wKwGh0PDivIfGvYrqy0XHV3rhHI5ogjPxUqxUmRB0Ouww
   w==;
X-CSE-ConnectionGUID: C2LTXd4NQh2mqrKPj16jFw==
X-CSE-MsgGUID: AXjZ2/qQR4uXfIB5Oeb98Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="73602994"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="73602994"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:32:53 -0700
X-CSE-ConnectionGUID: yMUedhQCRLWxYYiqKlkxtA==
X-CSE-MsgGUID: 4mE3AIS3QK+OPWdsvSdanQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="150209892"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:32:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:32:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:32:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:32:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YuEgR+MaCk2yB9PpAnONzFJmCftkrl7pDen715/dC0GxRWZ2EBosqlwsMGHbNpH5Osg2M4D1Bx1HAZ21fg213cJjS0AxFBNAYLe6tR3Xuy1T5Y7r1tcrlEp3VscGmaDhmsINhpdgr73C2C1A06HNCdYD3tZ1mJFgszZn9CBJeMHjvL/QfPcfcIqve75ITd2fbBNGPFZWER9pkRnHFnl1oZremH2P69a8tleP214Rc1htke5jOwoJ2p50P9NeLT1oezQiHGR0mZXpwNFlFBG1RISUxFGE1KE1s+BPZS7tMaqBhL/uG9oaGLLubib1AlfcxHUtIr+RON25GtYkqkW+ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuU0+4GpETvCQpnpnh+H1QG0Vmx3it9kw3BwYVEA7Og=;
 b=ypDkrg5L+1XI3c9tYFdWpcOjVWP+/chFEoKQ1IURnLnACYFPEUO4S0OIJTAhsfdhqOVqUws50ogWIsfms4Yv/OWCru7B/I4eABdN1XkE92jdlHql2Rxvk7tlLJst+kJzzM9d5piC70ra0bZJrYffvHc7ccv59lcn5KPJM9lMkkhM4D0Cy8wz++TZlI/NKe1U7prSGgvti74B92MBxnh4f0tStNgG1dJxV+iz/VRhw24bgGvHSafIRWNzoiIDpAdlAFlQJanz/1hm4BTinzc7Op2VYaHp6YsM5C0HdqREDM0gzRVVQohOD54+CNuEqiJ2Fm8zucwaLYvS13qcIanP4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Wed, 4 Jun
 2025 03:32:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:32:50 +0000
Message-ID: <ec532d7c-df13-46ad-a4aa-1b9c553cd14b@intel.com>
Date: Tue, 3 Jun 2025 20:32:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/29] x86,fs/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0091.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ba307f0-a136-4781-ea85-08dda3187b51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c2ZFVlUyZkExbkpscXRvU0c4blViaWtwQzFzR05CRmh6WVZHRHE1RmE3K0po?=
 =?utf-8?B?NG4rS004d3VaN1dzQUZUeHI3ZEdseUwyL1RjOFB3RWQ5TTlocjdyZ0xhSkM0?=
 =?utf-8?B?MG1WbW00Z1ZjbHdHKys4RlY1SmpmaUFtWjNrUnRwRVRiNzVscGltRE1PWUtw?=
 =?utf-8?B?NXR5VWVQR1FLNkFLcEY4ZmlJMGRqOUY2bDdjSDJYbkhGczRWdGtzQXdDRFpW?=
 =?utf-8?B?eHhjK1ZvSWdtL2NBV2NKMGF3SUEwQWw4YW5aMWxUVHl6TGowOHFCMFNxNHlR?=
 =?utf-8?B?UC9tUnE3YXpwUWpwNXdBay9yNEhNU1R2d1dHTGl0emgxT2pPaGRqbzRLWGlN?=
 =?utf-8?B?aE1NN29oeFE4VWNMcXZzR2toMFVSa2NOOGlSS0R6andqcmY5eFJINFJKMmlq?=
 =?utf-8?B?OUVyNnZTSlluL0lHVDFRUll5MkJMUkMxMlRmUmhmb0N5VXpTQ2JlWmNZalFv?=
 =?utf-8?B?OGxJejBxWmNaeUJyN29MQWdsTDdUVWd1aDlLcjFQaU11RHp5S29kdHlRcUxk?=
 =?utf-8?B?UnZQSzZoMWJRblNYODBjNWl4Y3lsWGFGVUVJUmo2Q3M3cy9GeGtRY2ZPd3k1?=
 =?utf-8?B?Q04wWExrbmwyVVRUMzJyNDZBRlZ0MDVhNkJucGU3RDd0b3E5bjh5aGhkWXJl?=
 =?utf-8?B?QUM3TUpJazZkdlVDenlGUVovTDJ2YUd0OGd5Yi9FeG9XajZ0Uzh5N1BjNUFh?=
 =?utf-8?B?bDhLOE9kR09PZDFwZmVnbDM5OG5TSkdjU0VrN2Z1VjFCT2NuNk1NakFUOFZP?=
 =?utf-8?B?Z2xYelZUT0JGLzlDM3Vhcno3am11VDQ0UjlETHBVZW9USDdWbHRLbVhnOXlv?=
 =?utf-8?B?dUxSTTQ5OUZFMzJKbGFRS2wvcFdkL2VTNGduL0M4YlJ2cTdheXl3b3Eydllk?=
 =?utf-8?B?dmErSXFraTl3RmxSSkxSMDBua1k3YVhBeWpTcEpPMEVrd0VwWEt4SmJmbERT?=
 =?utf-8?B?MUVHODMwMHg3Z0VvdjBPNjE2V0U5ajhwMC9VRW5GYmNQa08welBYTHVTOTJR?=
 =?utf-8?B?VHhPWjEzUGpVTUsyL3hQK0JMekRiWVQrNS9JMWZ2RXlaSHlxTHM0T3hnZERU?=
 =?utf-8?B?YUVWbW1YdmdDSnVyR0daaEtSRXBZbEVNbFlidmV3NWdUQjFIand6ZjJuYm5K?=
 =?utf-8?B?L2xhaHlaZ2k2dlhWY0JTb0dzWnJEKzIvbmNqMXRUYkNDckRLTW12a0NLWFlj?=
 =?utf-8?B?Z0xoekV0RlcwTjE1VnZiRXRod1JUYWl4SFRkUTJlT0p1QnFQcGEwTXg1K2Vw?=
 =?utf-8?B?SVFIdDN6dDBSZ0ZpZkFBRW8xQUxxYVU5SHNrR2ZNQnpMRytDbVFZdmhUTDFX?=
 =?utf-8?B?SHh6cGtPOC83MHRBRFBwd3I1aXlXclh4NS9SL29RNUxsR1J6cEd0cjdHMjVj?=
 =?utf-8?B?TEhyK3dSeTBZeTB4WWlMVmJsVzRua09lSm4zbmtySEtsME16VjZxYjdqUjVF?=
 =?utf-8?B?TndXNTViQkJ1TnFYZE9GL2xRa3RLRCtJU3VCKzdHNU1tSCsrV2prTDhBcVpi?=
 =?utf-8?B?bEprUUloajBjVW8vYXdmaDZNcFAvWUMyMEFFeUtNcllEcVFsT2lCTmVPaUZw?=
 =?utf-8?B?Vmo1blVVdTdjRnlNTnZNMWUxdVBHVEgvYU5QRXQxY2hkV3dacjRLQVhJY2lW?=
 =?utf-8?B?TitmZmI2NVBJNGk0QTdzQ1RRM2hzSkxsMkxSY3hPYVdVaGNXbDZlK0tVMC9n?=
 =?utf-8?B?Y29KWGlySm5DVytkbmw3NGovTWg3TzhLT2QvRVRiQzRPUGVzTHR2WFFld2dp?=
 =?utf-8?B?WVNiL1poR0JqWE8xekRxY3d1VmUwMU93OE9iMHFaU1lpaWVrQ3E1YXlzU05G?=
 =?utf-8?B?T3MzUTgwR1lCU1VDUUVQTjRRbzZqZHRac0NjSEcrWXBPaFAxU05nVGs5Wm9Y?=
 =?utf-8?B?b0NRNTczMVhRN2FDTEY2OE1LZXV5VzNBb2MrZTBmOFdwTS9rclMzT1RvWWFi?=
 =?utf-8?B?dTFxWk4wZUY2QXdENzZWb2VPU2d3RTdpYXd1NE9EZ3BqaVZUQ1g4NHFEbXpi?=
 =?utf-8?B?MGdzRGNsR3V3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXlEejkra0NBa2NYV082VGdnZTR6NHFTQnljWjlLZUxBSXJPYTNMandqM0to?=
 =?utf-8?B?bWZlUHNxWmpvVUlpS0oybnloalJ6cHRoZFAxaG5HZ2xxSnlwUnNrTHAvd3B5?=
 =?utf-8?B?UkMxbmdTZ1BHNkJiNjVQai9SL0lLQ3NBdFduRkN3V2hvSWtLSFkyNExNOGlC?=
 =?utf-8?B?VWFJVnl6cjJudUV5UjNUM1RsdmgvcWRsUzRleGkxK1hMcVJIUi9HQ212UE5z?=
 =?utf-8?B?elo0VDZ4ZEZqeXg2MWNjYVhTMCtETk1qMGhpRVBCRXlaT2RJWXdDbjgvYlUw?=
 =?utf-8?B?Q3RjUFhEdEhhQnRWNWpDcjZJYmRUdWtFWTUzb2tHbCtjOTFlVGRMNC9ocXJ6?=
 =?utf-8?B?cnNUZStoS0ZsSmdNVVUveFpueUJYdmVXanNZcXhickZKVm9vU214L2U2NEYx?=
 =?utf-8?B?TmZGYk1IZjhaSEVYTVFDTyt5Skg1NXVLMlo5YVFlYjdaSUVteENJWThCbUc0?=
 =?utf-8?B?bnNONHh1ejNJYkpIQXloZCt6UnlSM2hLV1ZnYXlkZXplTWVEaFNyaWd2Q0V5?=
 =?utf-8?B?SzlXUmNKOUtFdk9CSHpJSkFxbG1NYjk4VDFPaTJIRUc2eVNkRWd6MElLNG80?=
 =?utf-8?B?ZVFTQnBxNklBS0Mreks2TFlIa3B1YzVDTHdWdHN5dUg2L1NEQUN1SkxycDJv?=
 =?utf-8?B?V0c1YlBNV0VwSnUzMnhtN09wdWJaY1h6bUw3NUNVMTVrNXJUcThTalRGV0ts?=
 =?utf-8?B?citxNXFzRnp0T1FqZE1kYWJ2Nk44Y0lwcEVDOE9pblRBYVpSVFZ6c2oySGJp?=
 =?utf-8?B?c2IrTXRpLzFacW1FWSsxRXA2ZHljOWhvaW1iaFg3RmFJaWRIdjdXVElCTEtk?=
 =?utf-8?B?Vis5VjlvWDRBODhvUDYrdEU2VmU2My9RRzJ4S0xSNmwvRVNLb3ZxZG9telpQ?=
 =?utf-8?B?djRkYzg4UTNpVEdCbCtUZEdaOXZjakRoZ2t2R1djcnkwenJjTWN1V2JmY0la?=
 =?utf-8?B?VEcrVVU3K084UnpIT0V0ZzJQYnRtVVdMNjd1YXppUStOZTVURnRaQjRaOGRv?=
 =?utf-8?B?TldIMFdtSEZqMlBxcGpYSnc0aWVGWm15Skp4ZDdVU0dLUzNON3RZblIxTDJU?=
 =?utf-8?B?RGlXbXV2ZlhBQzYzU2JXd1R3WlZCRnBLN3AzQjBqckVvRVVjMXRSNmFuTjlR?=
 =?utf-8?B?eCtralorWUhMcHlLaVBOcFZONW8vTytuZjQyMlZHclZMR2pBSFBla2dDRERl?=
 =?utf-8?B?TnhVdCtGclMwWTlrWFpGNGt1UVEyaXdrZGtGRFhzM2ZFOVFCQlU1TVFEOVRX?=
 =?utf-8?B?Z0NWeHJQbmNoaUxLdXdhUklwYkV2ajZ5SXhQTDdlSWJHUEthOWc3N1Y0T3Ay?=
 =?utf-8?B?OGZmTE9rTFIzSTFLWTNITmVyVUN3MHJtQnpBN0pySnM4UExHM1g3Y1NSMmRV?=
 =?utf-8?B?WFJOMzZhVTdhckpDeVdia0ZqOVF2MEEvTHpPR3B2MGwrY25mZnBqSnAvdUln?=
 =?utf-8?B?aTZEYzhPYkd1VXBIMVByYnJNeUxMRnhHU21PbFR6K1NzMS9EdmJJOXZyc0Fu?=
 =?utf-8?B?dDFaMFBnbnUyRkdEdUJzbDRRNTRESldoaU92a1REWjhKNjhyUUpsZFZjMVQw?=
 =?utf-8?B?UTR0bkM5cXpQNmRUYWdvTFk0Z1F4YUM5MHZ0MU02eEJDalNFbVoyS1R1UEdl?=
 =?utf-8?B?cmhPdHNURVVKdW9qWE92MW9oVndkbWg3RjBYVjRqR1VIZFpaTHVBaGhDSWNn?=
 =?utf-8?B?eDZMMGRldEpWdk8ydllWU1NVU1RaUmczSWVoK2xGVWxTL1UzYXJGNWMyOVMx?=
 =?utf-8?B?Tk41Q2Fnb0krOFMyaWxxUFR2bjhuNFlqdlNGMUNzbVRQcStmMXRzWG1WY2tm?=
 =?utf-8?B?bnlGemtFNHh6ZEJlN2pyRzRqb3pvS0duai9FVmVEMDZEUlYvSk1YVC9lSmdZ?=
 =?utf-8?B?TjBtSUp4enZPU2RFYmhldk9sUjZwaTR2U0JaM3NuTnk4c04yRlBoYWFDM2VG?=
 =?utf-8?B?OWwvcm4xMktpeVNRWU41TVhyN2lVN1U5dGVrbTR1b2xLNngyY0FiZmF5eGtk?=
 =?utf-8?B?d1M3a0xXSXhNL3REOENOcFlIdHl6WUVvL1ZTRE9NTTU2SElqVmdiTVNja09o?=
 =?utf-8?B?SmU0NVR5QzJlN3hRNmJWQyt4WHBoTnJXOHpJRC9hV0VtcE5vYzNvQTUyT1FK?=
 =?utf-8?B?b3lrM0FtUElOTWIvTWMyTGZ5WDRjemo5dGdZbUVubU9YcEZ5K245QnVBTzN3?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba307f0-a136-4781-ea85-08dda3187b51
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:32:50.1314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWC/U8yO3zOwQbTlg3LxNHBKZ2+6+12hhfPCFFs61JISdlBkCDp8xWOd3IUzdqdM778MErsusg8lSFUXelfjM8Oesz06T/Af1bXjWR5/c/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> @@ -4041,6 +4041,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
>  		rmdir_mondata_subdir_allrdtgrp(r, d);
>  
> +	if (r->rid != RDT_RESOURCE_L3)
> +		goto done;

resctrl does not use "do" or "done" terms in goto.
"grep goto fs/resctrl/rdtgroup.c" to get a summary of terms used by this file.
Typical is "out" or "out_<term>" where <term> is work jumped to, for example,
using "out_unlock" here will match other code.

> +
>  	if (resctrl_is_mbm_enabled())
>  		cancel_delayed_work(&d->mbm_over);
>  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
> @@ -4057,7 +4060,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	}
>  
>  	domain_destroy_mon_state(d);
> -
> +done:
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  

Reinette
