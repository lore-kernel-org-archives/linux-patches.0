Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DBE20C477
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 00:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775263959; cv=fail; b=VRyXHatEGz51wTzclgsff9UJlOguXNUnQS1zfEPRDbC7zkLF5ru27lnmB1hBT/IfUxZ/qCqhR7AhOrCpfeaMGwGW1RbC6WDxwDV68QvQDjJKx/S5GJRCmuIxh4KNOmWU88o1DJo7sy7KQPEnx2ysgabvLBEUVIADWEPFKHdSRIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775263959; c=relaxed/simple;
	bh=2QEKDUpZZvgRCz+U4OcKHfWLLNFkGmuUcCU7zHkkCVA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pJrFcmjFg6C6Lm9swb0QEGJeFyxjrT8vCEGbpH3577LPkePgpfL9nAx+bMJPAW5+L82AooTSCLeuE+aWH9bhLUw/UvgBDL4FwK9l1T3171JB86oFOZ14b6qpLcembsbpYh2wFIQcX6jYv2U3HYuCz2OdLGqIMDMPm2eI4VsplXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TXTzpEXd; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TXTzpEXd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775263957; x=1806799957;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2QEKDUpZZvgRCz+U4OcKHfWLLNFkGmuUcCU7zHkkCVA=;
  b=TXTzpEXd9FyA6ZQlxCrTV7RRaW/go6sd/qD28f5KKsx0/qv7P7t5zKkl
   CaPSfaHsWi6C2SEMedM4vhswCnuTVDxoIl24Tfb81UoI/xA1P7h/OfdkX
   5FP9ztjtJaoMgl0f9AHNi7l3zFLRDJMWeIZLC+M1VsfWdyOC2Nunao98A
   6e6uXP/WjrEox9VllaQyC+ne5RPYfV5DMUDOSw/pIhzWKaVv8HgkGEM7H
   UQED3NjBGh/1swmdQHN/kuDPPwaGV90Ft0X5Uw/rinBhR6UtFawzOJlUG
   NIRK2FN4x6Ath718kW/5/V3gKGgGNuhNsBxox40E63fQr1ELU7QLTAK+n
   w==;
X-CSE-ConnectionGUID: FIl5iM7qS62N8JEsn8IeIQ==
X-CSE-MsgGUID: E9+CwbRhRsOi2YMux3yRXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76291455"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76291455"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:52:36 -0700
X-CSE-ConnectionGUID: hzovi07hQfmR9yPN68Hvpw==
X-CSE-MsgGUID: z6I0/DlrTFGP0L6seyL2pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="265326074"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:52:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:52:35 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 3 Apr 2026 17:52:35 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.27) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:52:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aNqk7swhQT3D/998mJrAboKj+wGkw31p7BRZXaIW3ZnHAL9QeJ7p4isTLyUuSOTALBIZCNLHAguppUCtBU+PITpc6WBfPfCDxBkZrfc6YgAZfI0o3fAJm0veM0zSJHu920fYVNkVLpvULHplXOE7vGLS59Rq+uyr299O6EfIO1sxPvF/c1nvfM8MOVnQA01wpoXG+5+eMPwUKIyblC5AXuwsX4nvwCNAY29D9Rl+4QAZCfb9CxYy7gglYudNT/EB+JKxIsyP1JeS97bLho6kdOYXGTqIQJXQgAF+zKarT6GVmHekFSqbYJCNykqUuy1BItbL2VDCalHseLFgZFq+4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRcynjqnvytrwQbnirYbqWwNL0wMUW4qD/EwrbDuG20=;
 b=SDH3f9BORf3c+y6ueIhpFHec+b5lQogJOSHwBlR+4qt1t+HOPiPeMHPyVt/rRMg+Ky9We9dUyc4xcVKLB0YJ6vcQmmsiga0tXupsgKErDYR+th2mpFaYcnvzaeW/zsYON8VYbqD3M8Dk46dovo2dIslqsqtpJ9ekrAI7HQ3vuDW+xGxmHigOKgsL3CH9beHb8EHpe7IhD3RUsb5t2uSBCICfYDX+iL0qCfbzB+4JxzxgWMM5BVv4H8k8IVgt+XqL1iPug7QGc/eRhR9B9Xm2BeHOl4lvPeORKgO5HxAS7GeI5liYLgpR2hFpTB8kmq/ihcpUGfxt2OipQ6jyOixwcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Sat, 4 Apr
 2026 00:52:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Sat, 4 Apr 2026
 00:52:33 +0000
Message-ID: <45436044-202b-4d77-b552-2156be47a52d@intel.com>
Date: Fri, 3 Apr 2026 17:52:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260330214322.96686-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0328.namprd04.prod.outlook.com
 (2603:10b6:303:82::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB5175:EE_
X-MS-Office365-Filtering-Correlation-Id: ff608a7a-bc54-4af1-60c9-08de91e4749d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: BvvvaPNf6WlLO+nsWl9WGFQWtb5JKrIGI19VsRONVW8+/H/Q4iZeL8etpbzfFhgl3DhvZ9/J+ccm72vLVg5Al3YfHmh7aNEqFpHXLYEIc27wEYYJCMpKhGICRNMDeaHkO6uSH2XtYwZNYS5NfuJ6+90WNSUJJPK2G260auRnU1Lv0rCNN1692xhX6BHjDjGEXGsMpljpgqI/m3qR8egr6GIZQoPUvP8uSGV/GtlAxL9m7eF3X9qWphggkFLz43tGdT6SP/QCqqMPehDZ2bI1JiYF3avR9WfKR/68J10NvyVEtd8pCHimT3SfGXbFUOwaOJ5uOCyqXdup9JadgPo7oBjr/ak0AdglhTVlQWGhDrLe22M/RUGvKBj7GhNm/DC6Tpq/+igJYgllCl8oDHzwLblROqe/x0B9FSe44YE5mHafF/uwdbehDFzX8AhLO6uyGpeXtjk1moT81hozdinrOlqrEOTWUcVYBqycL+X9aitr/fo9aGSvX0NsjhNF3fPboYmEEX4BU7cYlu7E/kNb2g0gyUuMgmkdU6JJKDV+7/ZFk6lpD+J30aLFsnjZE+Zpx1gGEwR8cdHXLzYluMNClGqIan37UTKHjSrA44Y0aKIMo3tqoJKmFDSkKm4NbJcZl/h02PndJMBavVOiojNOHuc4oMUtCGp3bfhNZbAWWs86C0WHWE96GkVeOyBuDomnOoNFH7FgucSA4BhDNL7YXEBrtmANQAZGWgOz/GhfD2Xeo469LHo2n6imBvfVDPb6hnVjRxTd3fXUlbLg0RZ5ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckhmNWVlYnNIcFdVb29lbnhjbU9sNlZFNXFwYzdFRkJUY3Fqc0ozOEI2ZjB2?=
 =?utf-8?B?QnJRRm4zZnB3TWE5L1hIWVIvLzhWOWlCVXl3dlN3ME9UVFJXdG02blBGUGtH?=
 =?utf-8?B?MXI2UGdnanAvaHN3bjFtV3pSV2NaOW5UcjZKVTZGMktjV3RKcTd1Y2hVekJL?=
 =?utf-8?B?cmN5UzlCQkpwcVZJbWRsTXNrS3VqLzZ6b1RGU3ZPbHlYMTF6eWpOWHNBMkV2?=
 =?utf-8?B?bTQ1VGtzckIvQklZUG1wUENOT25aU2FWeHpPWVZRZy82aFJZcmxrRHZKOWxn?=
 =?utf-8?B?Ykxtb09keUFQRUdKUWwwNHJLYUQ0NGQ0eU9VclVnNy9hRm1xbTcwSGVvRWtk?=
 =?utf-8?B?R1JHcm5qRDZlTFoxL2hCVjhJakRaVlhVMFpBUVNvY0s5Q0F5dHNKOEd3TytS?=
 =?utf-8?B?SitJRFdoMGxFSTRpYjZHakpWeGl4VnVSSWZiM21RWGRCOU5jd1NyNjFLZGhm?=
 =?utf-8?B?aXQvQ1FpNlNyaU9UYUxzM3NwYko4SlZvZThqT0FxS01zRVFpNkxuTENwb2ds?=
 =?utf-8?B?Qm85WmYweHpiQkU2WG9xUG1rMzUyY3VHYUNlbjVTNTh1aG5nNXptcU9neE5n?=
 =?utf-8?B?Ri9MbjdoTnFnaGMvSkYyaHFpOURtTzV4Y1VhOUhZdU1KOUpvS29CRVdKdHI2?=
 =?utf-8?B?WSs0ODVGQ0hBV2tsajhOM1VnTC8rVmFrOGZIekdBM2lkbmtvanZ6U21hQXNN?=
 =?utf-8?B?YjRkZFlmdVV5MXBIUnpDcEFnbm9rUVJuNm1qMzFxL2NrUHJCcG1KcGF2NFlV?=
 =?utf-8?B?K0ZYUGU5bFlFZ2JacjBWa2Y0M3Z5bDlqOGN3UEZPRW1pUm45UmZiT3RXRnpJ?=
 =?utf-8?B?VExJaElvQkRFVmk5Vy9oVVNkaTl6anhpdjhCVUUrT216c2ZBY3FlSkxvOEQx?=
 =?utf-8?B?NWhlU3ZIV3ozRzFhTnlPUmRyd01nMVFMSGZpclFNZld2TzNkZGVTREpDeE8x?=
 =?utf-8?B?dWVaYUNzV3pLNklzYm1ObDEvTzRsL3pONjFEVHU4Z3BQOHZHbnNYbkMzaEFv?=
 =?utf-8?B?VGROdFlPZGhaOEhMU1BuSkdpSEZXVTYvLzhSejJINUUvSU0xVVpYN3lycjMw?=
 =?utf-8?B?R2h6TmNSZjdlNkwwNFFwOG1WU1YyTm8rMzJCQUZFWnpBYVNKYlZoak5QK1ho?=
 =?utf-8?B?bmsrM1VNRHd6dStTOWRnUkJvckFBLzdpb3ZKRXR4UGxmVDhja3l1VGRVTURQ?=
 =?utf-8?B?U3Z5VWF2R3dTUTJuOTN1eGI4T0luelI0ZlpHUUlBSGtaRDluQkpxRnd6bXNH?=
 =?utf-8?B?Zk5ueU9aTFNpRnVoOW9JaUg5ZkRKNHpXM2Y4R1ZXUmtlb1BzYjV0d05GQ2x5?=
 =?utf-8?B?T2x6OGRpK3hRbzdnay9uUlR3RjdRQTN0alZScTNJS25pVEo2YTYvbHJkeVpa?=
 =?utf-8?B?Z1JlTmhHb2RJb09QSkRvRE9xcHdiTytXMVduZm11MGJCbmxIWFhwd0s5WjB0?=
 =?utf-8?B?cUN3djFyaUZXWUNaOHA0ZHNSaXpWbzRxamI1ckpsYzk0RE5OZ01GVU1sTmNV?=
 =?utf-8?B?aTE0aUNEOTVySmJ5NE1Kbm8wN1RORTU4SmsrWUlmUFZqV014cDN0VUN3cFRS?=
 =?utf-8?B?S1lLU2diRFhjekQrVW1vY21nOXgyckVSajBMSXduRGFXVDJEekRsTUhvOXFv?=
 =?utf-8?B?NFArKzh4SUdqTXA1NWpVY2xrbVc1dll5WmIydTBlUlZGZDBBRmMxZG1FU2px?=
 =?utf-8?B?a2Z4bktTdDh3SEhOSlBCZ2l4ZGowcGxFbVUzQ2g5L1cyZEQwS1I5dmwva0M1?=
 =?utf-8?B?YTMrS3FPL0phZjlqV1piVWxmVmxpc2Z2RjNvcmp4eHU2bHBqTFhtQ2pkTCsx?=
 =?utf-8?B?SUdpbnNmbGFaTW9UbkpodTB3dG5RN3FOVzJDc2tKbTg5M1J4NG51QjNBVTdx?=
 =?utf-8?B?VjdYeGxKK0JKR2lNY1lxNTJka0I1Q3lxY0tQa0NsOG9VbFlOdmtGRnBhQjhJ?=
 =?utf-8?B?UlE3eUdBUEdVNmNKNXFGQUYxZUhOTC96NXZVM25wYjVDL2dTWkZLbytpZnEw?=
 =?utf-8?B?eFhDRmtSK1gvMmVIVVh4YW9kR3lPWDdtekZ2c1M4R3ZmVlp6YS9mLzFLT0hE?=
 =?utf-8?B?QmV1OXVXcjViMmxobDEvUGpsMUhabWJEZW5XQjRNMXlJc1psbHlFTkJhcG92?=
 =?utf-8?B?SkphM1p6MDEwVDIzclZyaStNL1NDemtIOWFyTWdPS0g0eGdtNm1DcTlISDNU?=
 =?utf-8?B?dWZGSkxHZjFBWUVrZGxqR2h2R1BGUmI2ZmtpVFBObnpUTUJNTmV2MkJwZDk0?=
 =?utf-8?B?UURKQmFCb2oxbllld0g2N05OQ1F1Q1UvNG9nNEt0WUdML0JZeUluRkUxZTY4?=
 =?utf-8?B?U3N5TEhSQnJiVlAwbjMrWktMTy9rSitDWHplU0dtdzV0a1FlcDNUMHhtOE9p?=
 =?utf-8?Q?w2ptYhz9TL8Ma4BQ=3D?=
X-Exchange-RoutingPolicyChecked: iJuxxC06zgVE5klpQgm2Myxpk4gzM/eBwKEg5bGJA1JMbw18ea/DOx/4DzOyleJ04vygLswNZcQhEHqBvmOBD3sMvUIlcWmH0bidsih+M/vtIU5dcrpAavDAt0HWpMMoWZXpOORrqk5RlUO5zDLzJ7R8s0eADFL4gnwBB2fxXj1FHcTpf085dwJ6XgapZrmVuJ1R/PK4ACm9ByitfCooB8pBmhivt04mbLJjfHvFodmm1/Xp6E0U9k9QeqQgIbdvX0jDswlOkmxM9Q6Gznr/ZtbqhooYTz4tj9nlZX253H3hxQt8RIQCiMgqDz9z2fQZ1gOss8t2n9trEIHTvbz3BQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ff608a7a-bc54-4af1-60c9-08de91e4749d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2026 00:52:32.9542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/VyIRd8LMG4TokURNkR4sosBt/ECXrwUh/IjMLRlJXvvzQ/RgiIY0IUuaofsQEAirEe0dpORQWBeO9z83yDnYXsDjIEv0gKSwrsAqDCbpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5175
X-OriginatorOrg: intel.com

Hi Tony,

On 3/30/26 2:43 PM, Tony Luck wrote:
> Add hooks for every mount/unmount of the resctrl file system so that
> architecture code can allocate on mount and free on unmount.

Please use the changelog to describe and motivate all the other things
that this patch does.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> Note this patch disables enumeration of AET monitor events because the
> new mount/unmount hooks do not call intel_aet_get_events() (which is
> not ready for the change from "just on first mount" to "called on
> every mount"). That is resolved in the next patch.

This could be part of the proper changelog.

Could patches be re-ordered to support incremental changes?

> 
>  include/linux/resctrl.h                 | 12 +++++--
>  arch/x86/kernel/cpu/resctrl/internal.h  |  8 +++--
>  arch/x86/kernel/cpu/resctrl/core.c      | 14 +++++++-
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 13 ++++++++
>  fs/resctrl/rdtgroup.c                   | 43 ++++++++++++++++++-------
>  5 files changed, 74 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index b312aaf76974..489c7d4ae3e9 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -518,11 +518,19 @@ void resctrl_online_cpu(unsigned int cpu);
>  void resctrl_offline_cpu(unsigned int cpu);
>  
>  /*
> - * Architecture hook called at beginning of first file system mount attempt.
> - * No locks are held.
> + * Architecture hooks for resctrl mount/unmount.
> + * Each is called with resctrl_mount_lock held.
>   */
> +
> +/* Called at beginning of each file system mount attempt. */
>  void resctrl_arch_pre_mount(void);
>  
> +/* Called to report success/failure of mount. */
> +void resctrl_arch_mount_result(int ret);

Why is this needed? Why not just always call resctrl_arch_unmount()?

> +
> +/* Called to report unmount. */
> +void resctrl_arch_unmount(void);
> +
>  /**
>   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>   *			      for this resource and domain.
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e3cfa0c10e92..6f322818a9e6 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -234,14 +234,18 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>  
>  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> -bool intel_aet_get_events(void);
> +bool intel_aet_pre_mount(void);
> +void intel_aet_mount_result(int ret);
> +void intel_aet_unmount(void);
>  void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  				struct list_head *add_pos);
>  bool intel_handle_aet_option(bool force_off, char *tok);
>  #else
> -static inline bool intel_aet_get_events(void) { return false; }
> +static inline bool intel_aet_pre_mount(void) { return false; }
> +static inline void intel_aet_mount_result(int ret) { }
> +static inline void intel_aet_unmount(void) { }
>  static inline void __exit intel_aet_exit(void) { }
>  static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
>  {
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 7667cf7c4e94..162eca2cfcdb 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -769,8 +769,10 @@ void resctrl_arch_pre_mount(void)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int cpu;
>  
> -	if (!intel_aet_get_events())
> +	if (!intel_aet_pre_mount()) {
> +		r->mon_capable = false;

Why is this needed?

>  		return;
> +	}
>  
>  	/*
>  	 * Late discovery of telemetry events means the domains for the


...

>  #include "internal.h"
>  
> +/* Mutex protecting mount/unmount operations */
> +static DEFINE_MUTEX(resctrl_mount_lock);
> +
>  /* Mutex to protect rdtgroup access. */
>  DEFINE_MUTEX(rdtgroup_mutex);
>  
> @@ -2788,17 +2790,8 @@ static int rdt_get_tree(struct fs_context *fc)
>  	struct rdt_resource *r;
>  	int ret;
>  
> -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
> -
>  	cpus_read_lock();
>  	mutex_lock(&rdtgroup_mutex);
> -	/*
> -	 * resctrl file system can only be mounted once.
> -	 */
> -	if (resctrl_mounted) {
> -		ret = -EBUSY;
> -		goto out;
> -	}
>  
>  	ret = setup_rmid_lru_list();
>  	if (ret)
> @@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
>  	return ret;
>  }
>  
> +static int rdt_get_tree_wrapper(struct fs_context *fc)
> +{
> +	int ret;
> +
> +	mutex_lock(&resctrl_mount_lock);
> +
> +	/*
> +	 * resctrl file system can only be mounted once.
> +	 */
> +	if (resctrl_mounted) {
> +		mutex_unlock(&resctrl_mount_lock);
> +		return -EBUSY;
> +	}
> +

This does not look right. Here too is resctrl_mounted accessed without rdtgroup_mutex
held. This change implies that resctrl_mounted is now protected by resctrl_mount_lock
but resctrl is not changed to respect this throughout resulting in unsafe access of
resctrl_mounted.

Does this new resctrl_mount_lock need to be in resctrl fs? It really seems as though the
needed synchronization belongs in the architecture. Could this instead be accomplished
with a private mutex within the AET code?

> +	resctrl_arch_pre_mount();
> +
> +	ret = rdt_get_tree(fc);
> +
> +	resctrl_arch_mount_result(ret);

Could this instead just call resctrl_arch_unmount() on failure?

Reinette
