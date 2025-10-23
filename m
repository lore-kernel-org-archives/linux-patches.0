Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292EB322C98
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241763; cv=fail; b=fIx4PdqSUD62y241x/El08ZXn0D/lJmWaAN88bDLceqTF2dBxa50B95PbBpdj3+5C96fDWmFNjvhFcSe8sF3ibmD/AENiyGSCEqxEWmqyBkYGBhv40hw/t5ABrDcN1jhOnxHFjfnSNcA9hmNz7I9wIaGr2a5I5znqemKKgvxEnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241763; c=relaxed/simple;
	bh=i5l5aAExe/ASCNMS5zJge6Rc3xRFdJWV6jwpROksrgc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j+Y5E78KQ9UOOQH2fywU5OhwBcGcD0eBvbD+zqyjHII4l6Yw9x0tSQPUByZ1bf9SYwE06JQ4AlfgWcG3Zx2WjU966H7Ed1W3qTNY5snJqb08lvM+DesBMIGTY+R/aD0TcKAUqYyZBcGjYxKuHdYBtwvS37VMFVU7PG/QqtIjrBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N299BidR; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N299BidR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241763; x=1792777763;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i5l5aAExe/ASCNMS5zJge6Rc3xRFdJWV6jwpROksrgc=;
  b=N299BidR2ADP3Xwox/s9h2u4qhdLmpiyOKOe8jEE+RvB4jl4uhcxoeZI
   GoQzpQsL7F40YT+fZnLF77tBNyGvsQ8Ft5VNqd23i5F20EKMRvV+HJp1N
   x0+8PbltVWeUghtEjaToSd7bhdWfRIVvPKMUaT9/Jx5/hocf4iIdUGyRL
   ZnaRh99yaN5oagjjtk5mEEyd1VH2DPtFqYdRdOurYVljVGmYjRgtPPXHS
   Wa2RnGBA2Mr/u1tVaCKvSCIFfwkoNqI+EvfP+hM2A30Ox49oBtiBRpnCX
   3Fw/XRbdyZsakyeLpoW46B5JjpcgM9HCtNJxz5MnNsQtjuksrqj4rZVY1
   Q==;
X-CSE-ConnectionGUID: jEE/75/PSNyV+t2IjBGckw==
X-CSE-MsgGUID: VFBWDPUlQf+pekrr+DASfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73710974"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="73710974"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:49:22 -0700
X-CSE-ConnectionGUID: hHinXdflS0Wl19PzzydsEg==
X-CSE-MsgGUID: bNj0EBjvSnqOwMO39ApStQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="207871393"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:49:21 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:49:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:49:21 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.47) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:49:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQVpBPuWGa4RlhYflcRNRfDW1VVBkZYLKMppa1K+7uUoxBoN+Bv2DeSYdoojQcIlnB5tdrEmeAhXH8GA5zx4ghlA8muIWaLU+9CnS42xf1IAbtUJNxqjBVKjYQH+90+Wfm/gl0AE1fBnLahDWmXTMs53/Qstarnhq3O5pmIopNP0TmWcBM7lhun3Kv3UbW6lgVumly3mBmWyWnaf+DFLndOEhYEO3A0YewDUP+TO3bZqP2BgEXBU3t18+hxpZd/Zl5DDkN4AP1Hp9TF7P5K1Gaw46PtgQKrbmY+retcgykLnwHZBfCJ/6K45+75FPtw3EMsbMjUsIvH9l/YvUqLolg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7W6J9qtt81S62mwzy7u6zVhKRpCV/OQLZ3ae1QkaSh4=;
 b=RNmFOMZ9uZxeMDAenR5kDW0VLBkXsgbEt3QJ2sBJtzjTM8ewU4HwAqwraJkmLSktFF3jdv1nSwYpnPxHlm1OZuBWW6JKE0GFXMz9wosz3IBxzN/8ieOnqSI8yzAOGg7qatoHX1qqITmMSl/JlTANypNHG6CFVhsMHHwXakUHAj/F4lGWKyirXOo6lsYkgWBBPkF9Peumqao2s7ac6VZnu5eW2uD5Q75lT02eHRErfryirzNVquD3Ku0891wmDfY+/njpX74cDIBBDyj0457xKmFkHbZf/uoowMsCt0srtghnvhxPJy1e89J5thZq3jUdHzdjMFJOZedh8/1K4q5X0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8469.namprd11.prod.outlook.com (2603:10b6:a03:57b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:49:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:49:17 +0000
Message-ID: <3b4b4892-c49b-46bb-8ae4-a3f1c9358c7f@intel.com>
Date: Thu, 23 Oct 2025 10:49:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 25/31] fs/resctrl: Move allocation/free of
 closid_num_dirty_rmid[]
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-26-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251013223348.103390-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0132.namprd04.prod.outlook.com
 (2603:10b6:303:84::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8469:EE_
X-MS-Office365-Filtering-Correlation-Id: 871284b8-9aac-4380-5b0f-08de125c7cc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OXczNW1mQlRmUGVDeVNzMHpsSjZYemwrazBLelNodS9JTTkxUXU2ZDdXNlBi?=
 =?utf-8?B?NUUvRjI0d1haWHRwaEM1ZmphTXBNTFNveVl5ODVWQXdrcG9kOCtQaHo3S29Q?=
 =?utf-8?B?RDFYamVaa3BxbUhISkkybStUU0EyWmZPZnJNUzNGRDdnVUF0UTdFTThTcENR?=
 =?utf-8?B?Tyt1ano5WVlwbXpTbGt5RlVnUmlFVnZqenJiTEhEQnpsTVEzUEg2cjIrME5U?=
 =?utf-8?B?dVgwR1Fnd0hsOEFFOU9HdmtHSDdkWWFHQ0h1dGZlOE01SzJGb3grd2YwTVFw?=
 =?utf-8?B?MWxobGhBNWFtSHFocTY3OURrM1V1VWwvNThmaytMNjNrcWtPQ29PcGlVUngx?=
 =?utf-8?B?RElLWmpKaUFHVWFKanhCQldvMWlHZnFOM05ESWZybDNHeDFQSllIT3VwNDVt?=
 =?utf-8?B?YkJCU0grUHliOFBlcXVCV0FHbFROR2JGQ3dsbVlaU1dnZzhBT3o1TXkwVG43?=
 =?utf-8?B?elB5R3JJQzVGYWJySVVsR2Y0eHVOOGhqclRnblVhamNjNm52R0F1ZFQwamNZ?=
 =?utf-8?B?V0NCN1l6MSt0ckNpSmVkMkdCWm15Q2wzR1VEdmU0WjJIRDVvMmdFUGp6TzdO?=
 =?utf-8?B?SmJ5ZTlCSUwySUtERDJ1WSs5dEZSMUtQWVpabXlVMU9ldEJXbHRwd2FoZ2FP?=
 =?utf-8?B?ZXQ2aGh4SFF4cXNZUTdSZzdhME5vNjlsMGVhQVpJUnBkSElUZC9zSFpzR0sv?=
 =?utf-8?B?ZDRmenhqbkhVdGFDQTdId1RlMXpOT05KUjlwU2JkdEpiYythci9hcklwTlVR?=
 =?utf-8?B?VXMzWVNySkh4TDJucXlROVFwY0N2TnM3QVNSS25TRndvano1MFZyNytKaUVJ?=
 =?utf-8?B?MGprNXJtNDlxRVdad0h1VlFiWEhVNUE3WmFqWGRnL2RwcXJodFd3WjhId2dh?=
 =?utf-8?B?eGJaL1FrSE9nWWgwS3FyZDNjT1hOL3h3Y1hPV25zTExiU2s5V1lHdkdsVDZS?=
 =?utf-8?B?MEVLQS9WU0RMYmFkNUtFRURQUHhzekJkTEY1Ly8rNW93YjNFSTBYR0NTeklJ?=
 =?utf-8?B?U0ZmNFhmUVd2dERZMGY5NWYySHpUYTZPNFFOUGFuU0M2Y1Ixd2wzRlJnRit6?=
 =?utf-8?B?K0pyd29ZVjJPVUw2NlJPbEZhbEc3VUtCcmJCcWRXY3M1UFVHcURxcUtla3Zx?=
 =?utf-8?B?SUxGdFByNDBKbit6Vm1hMGtDOGVGUHE5Z29PbldCc0ppYWt4Y2U4bGhpaFNP?=
 =?utf-8?B?aVdXRjdGcVZXR1lrYUMvNGplQ3YyZXp3eGI5enpXT1o2dUlNdll2anBzRnBW?=
 =?utf-8?B?T2xtUlhLLzZoU1dWVE1sMkt0STM2ekNoZjBEamZLbmZWRDUvVld2M3p0b3RS?=
 =?utf-8?B?c2dEU2doVGxGZ0ZaNDVxc2xybHQ1bEpGZzBvc24xT2lrV1VwVTBNWjRvM2hz?=
 =?utf-8?B?eHFTdGI2ZVFiWmxCTGxpbTB0Y0hZYTVlTlBPWnY1V0g3WU5CcUM3M2lVajlJ?=
 =?utf-8?B?SUt1MHBYYlp4NloyWW9oWE9IVE9iMFowdDdpa0NtVElNVThKY1NSdnZPODZ4?=
 =?utf-8?B?Q1ExZUtyY3R5NnZxcWtoWVlCWmxKL3RIUDlWcFNrR2ZwN01jNzErY1Bab2Zs?=
 =?utf-8?B?MzZCV1pVT0srMGZucFpHNDlLQjlOVWpmR0ZBbkhhSWhLYWIwRnBNbFk1K1c3?=
 =?utf-8?B?MG81ZzBwSktrdENpR2RoTWNCb0NkWHZ3RzFaVG5Iajl0K3ZiclZPN2hGNWNJ?=
 =?utf-8?B?Q0c5a2RRay95RXUyRTNNZlZTVEhVSURWZVVGM0ZzVis4b1RsT3piYkFnY1pj?=
 =?utf-8?B?cVBGQ0M5dkorVWJ4Um1pZjRkUlpESVcycnZFbHBjNVBXWVBsWTFhMnl1aWR2?=
 =?utf-8?B?RmcvdWQvUFN5aG9ORE5EL01NMG80YWVja3pPMmZJUXJJNUpsa1F5NGZidzcv?=
 =?utf-8?B?VEwramdOdEZwemhtN014RUdTbVBUOStmbk5WZFZ5K3FkdnpnZ1pZaXpWcmVq?=
 =?utf-8?Q?SrsoplHwf3Mxwo1rZUAAuRX8YeUE0fs7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3N5Y0xvZkgzN3hEb1NiOXNyZUtvemZZaXhmbFVlVFdCWEtXU1ZhckJaS2tU?=
 =?utf-8?B?Rmx0MFFBKzRsMnlDK1BkaHRwTzdIUTh6QVVpK2t6Y1lIVGkvSFBvbHJoLzNW?=
 =?utf-8?B?N0d2a3gvZTl5MWlob3VFNXg3dXNnRDhDZ1dDeldMOGVmeXdZZEsrditkQ2N6?=
 =?utf-8?B?WklDQjhsTGliUzBiZjhrSDY4M3NRSTN1SHBWSFFzaFlqYkdUeFFUZ0FGeWFJ?=
 =?utf-8?B?N1IyMGs2OE14cWRqREtVTEJ2S0RyMEhNMWg0ekdtb0N4QUJVVjY1TG9IVFpT?=
 =?utf-8?B?a291WnVRNG9MMjI3dVhKYTRqWitoNGxDcW9KcEFnL3pqUUgvR0Rsc0VlR3FJ?=
 =?utf-8?B?SVdPTWpQbEtxd0VmYk5MWHhvU3QreEJ1cERublBNWVFvVDJuK1F5NUd4aHRp?=
 =?utf-8?B?NWpZcVRGUGp2V3BmRTIzdm84ZmowckdrK1JBTlpKdmtYUURpckxvVUtiRWho?=
 =?utf-8?B?ZkM3b0NMMFdQWEhRbktndkxpU0V4ZGZHbDdaUGc4Y1pYRG1nV2pLMmFvU3Jn?=
 =?utf-8?B?YlZCMGFSV21xajFURXpqS3NUTFFXU2xnSEdZdzVGdFRzc0VEVmdONXora3dw?=
 =?utf-8?B?dFIrL3crN1JVOGRpbVFpbWpvb01LNExxQ2hsTERJeDUvdGdxQ1ZLU2NkY001?=
 =?utf-8?B?TnRLNEJSZ3J6bkdWQURrOHhJSHlCZjBsSUQ4NkdpZ0d3aWFrRVBjRCtyUkpP?=
 =?utf-8?B?dldpSGdQSmtWQ0tpSlM0SXZzWVBzdjhGc1Byc0FCcTQxTkx1TGZ0QTJ2WVhY?=
 =?utf-8?B?NEIyQ0t0Q3I0dTdXcVhhTzFLeGpxU3ZxQlNVdXlWQlpCenloM1ZYTE40V08r?=
 =?utf-8?B?SEc3bklGdzRoVjEyQjZOcXVLb2xMc1NMR3lWckg1N0EwRkJPK2I1Q2NBVkp2?=
 =?utf-8?B?QUdGM2pMS0FhYzM3a0ROTDBIaFA0clRpRDdSMUM0b3JKOENKWGZ2ZVdzQUNG?=
 =?utf-8?B?a2RuVXZYWHd4R3JxRU0yeXZmdzl2NGdkKzc1YzlvSjY5NGtOWUppTVVWR2Nl?=
 =?utf-8?B?YXZMYlF6cXZac3BlMTJsd0V5dk5jeHNhNmxwekovNmhPOWVYekFRcTBVUGlp?=
 =?utf-8?B?bUtVb0JWYzB0QjV2TDNWRGE0aG9acU1jU1lncEF4ZTltWm90Yk90YnZUeUp1?=
 =?utf-8?B?bDFXTmRab2pLSWdDTGpSTnJlQzJQcGc4WnNBOXloUDB5N2ZBVTZqaFRHNWZE?=
 =?utf-8?B?TmZkUmo0V1RpVmJtcnl6MHViclFjcThmd0RmOXRLZnFQMzdUOFZyZFZpaGFX?=
 =?utf-8?B?L3hITnV4Z09HeUZnM3J1b3Y4VnZmYk9rS0FIZ09rZGVsbzFRY1pmdFVpTXJm?=
 =?utf-8?B?clZPZGJyTTlZbEI0a1h1SitaMjRkYktEUm80RTUwWkVKVzFKSzdTOHAzQUFJ?=
 =?utf-8?B?MHo2cW8xa0pGK0VmYmk0QnhVRStkOXdBUVNZem1lb1c2WXlYWVVZbzRrUnZE?=
 =?utf-8?B?TFFXN0RBMThIUnZHTjJZSXBDTnJSUE9XSDd6R0xkOUMzU3BIRE9USlJ6SnM0?=
 =?utf-8?B?aURZVjlScnNhYXVZaExiUms5bldpQ0szanh6Nk5zRTRya3BhbEIyZGpWMjdr?=
 =?utf-8?B?b29jbkRZQ3BQVHloNUJ0U3BVOUh2OGh0TlB5Z1ZaNkIxcmdNNU5sN0V0VTdj?=
 =?utf-8?B?YW9yZHI1Z3YyVG54djdqdXd0Y3Z0Rm03c0dMYkxaTW0wVVVqazROcWVOajZF?=
 =?utf-8?B?S0tSd3h4STBaOTVlMVdINnZ4ZFNmYUE3Y3EySUZ1MTFja05BM2dtY04wU2Fs?=
 =?utf-8?B?N21lei85KzVLSFVvUHJlcWNrbDYya2NDQnNHbEpwbkhRTTVSOVB6LzFyVG1j?=
 =?utf-8?B?NU1la0FCNU9ETmpGUWRsSGFMZWhram41OWlJeWVDM3NZdXRSM01HNXpNREhC?=
 =?utf-8?B?c0JWcFFqYjdRdDlXK21WRXNYWkxKaU03NjFsOVNtRXo5R1Y2R2tHQ0k5WVZ4?=
 =?utf-8?B?Nk8zSVh4d21zOHhMNlBvSXVJdnlDWTVkOWZMMnByZ2ZWUUprOXZ5MmlrSjJZ?=
 =?utf-8?B?cXdsMVhDL3NTN1FKM0tCaFZ5b1g1aGhPcXM2cDlWYWhRd2RBbktpUURWWTI5?=
 =?utf-8?B?YVg5bzU0UmZEQXFmZlNVVVMrUEFKUzNrQmtmRnRVVDBWU0ErY3NnWW9lRmFj?=
 =?utf-8?B?RUNEQzkxblJnWHhLaVlGTkJyU3JqRWhiTzlqYzZHUnJrVVdSNWN4bzJuZG53?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 871284b8-9aac-4380-5b0f-08de125c7cc0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:49:17.4029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/+gIvPhYR54W3A3WrWgAUQNEQ5Dr/R0iun8FocXTaRN/OKVez8j/8EvHPG6RZ2qyKgTa2ExkmPA8+PVztSQsHM5Py9T+U23vqLNAN9GD9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8469
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:

> +static int closid_num_dirty_rmid_alloc(struct rdt_resource *r)
> +{
> +	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> +		u32 num_closid = resctrl_arch_get_num_closid(r);
> +		u32 *tmp;
> +
> +		/* For ARM memory ordering access to closid_num_dirty_rmid */
> +		mutex_lock(&rdtgroup_mutex);
> +
> +		/*
> +		 * If the architecture hasn't provided a sanitised value here,
> +		 * this may result in larger arrays than necessary. Resctrl will
> +		 * use a smaller system wide value based on the resources in
> +		 * use.
> +		 */
> +		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
> +		if (!tmp)
> +			return -ENOMEM;

Drop rdtgroup_mutex before returning here.

> +
> +		closid_num_dirty_rmid = tmp;
> +
> +		mutex_unlock(&rdtgroup_mutex);
> +	}
> +
> +	return 0;
> +}

Reinette
