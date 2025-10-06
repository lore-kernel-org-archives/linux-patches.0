Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78B83C1F
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 21:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759786369; cv=fail; b=EZOGrPEwYT+ewzCRnd4lmptUQomfXLIkyfoU9yYsw2Sj+8HX88Mm2QqKDfM2LCIFzi3BtTmYMnulEfJvEUt4tT8nJWIJ6DKRL8I3mrbUHXp6UoPOGLXLnWr+rmiPSAxjSHMnPJXP2vOJCnXFHiLdAtpBMQ3Oxzh1ut/jxqbqp2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759786369; c=relaxed/simple;
	bh=Sryrm0OUBPeXZOs2qc4yrnvPw4soum8lZtZ5gdM2iDY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OS2v37vQikFMsCbQRNABfgZWfpkiuB9FafpzHuyz6dujdOR23UmJhQh13vFZ55n+PKgoixQtNAJLzazsnsu0tPNwx1+1s8+Jsp98UZx6AwjUBc7Goqk6ka+Uy9K01Hk+Fs+P3zXrfsDGSyGam74rf+mBeZJ33iQB24ZzxZQFHjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gDreYFYE; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gDreYFYE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759786368; x=1791322368;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sryrm0OUBPeXZOs2qc4yrnvPw4soum8lZtZ5gdM2iDY=;
  b=gDreYFYEpJg6AMKZWtcjScgHuw3FCilHiGZR6yqcLgBxsaTDc3pfpstq
   zPNbwHA+4jwWeiJrmu6YwBJzj+dZTNShEC9Ll0fxV+LUiKh0G6WzAkZfX
   dgnX/fUkdn14135DpIgP5wEAPSyNFnzVqVxtxd9Idfi3CPc2XGj5GWGYP
   cwFBlq+XzBRV17sy50xreE8JGbE3Ee/UvoYDAcLs99e6rJdGD6JdsX4Uq
   kFi0szvyBF+m05ybhMzmwepcbvzNaQz3lh30jwOyqjbC6xHutJ0GuHik5
   3UNDP/nbbpcJxzC/tT0BT4FAB8eufYiQVqeJpVCfeKCHtYC0jFKnrvUQE
   w==;
X-CSE-ConnectionGUID: guFZY/vvR3CoEY0BNJzGYA==
X-CSE-MsgGUID: rwC5IKBHRvKtbWHV00onsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="62003608"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="62003608"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:32:46 -0700
X-CSE-ConnectionGUID: iF2CIJSsSC6c7dFVzxhz6A==
X-CSE-MsgGUID: 18aDKXV9QuCNDM4MihzlKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="180032490"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:32:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:32:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 14:32:45 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.2) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:32:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mwiFC92uvmdHJKId9Hu+KkL6hvt2kfB69cg9xRQ6463oyxQWCxjDWpcRyWT90GC2YwawN2P1Wz+rlMNGdthRExdIaWlMt9S1StoLRIYkrTaxoRnJ1ThMROSvSaiLkYZOAXfHMVFV/cUB19L36VdTdkW4i+fvkHb9HO8NH5BBwwQ/CO8jB75I/1TzzIBsckaNno9629M4C0V22Ij90K32Lm62ckjizCkB4V+vQvCqirG0gcIbxxzcaGvFV6IhQ2ytfhi/k4RPXfZP3v2xSywijDcLa3wOnqXV7/4Ur5xvNx+uJ0CZFINCI/DR00cYvP3lw5Yr3OdiMEZa0GPVyvSFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGPEylLX2ceVj6PinY/0FBzbQC1VeTuRSBCrEeMkF6M=;
 b=YiFxdhk1JYfolJ6mhgC9RPVRHRilY1Nm2N4yByi8VxCAEknnxAkkVhOQy44OHYyG/BaUSXcmwhlm3Fcgla3KBrm1v3GjerP+CyYst9R5qXjKLG6g4MekxUkD2bgibQdBhC1PhMkmSTYG+HEKFxGJBB8pcTrAVGxNZgcuz+l8X4VXGwaIDpdiLA9lzIfYAHQLdkosSnruxuvOBRyouQ2M3Q7dsSl67thujLk561mvrpD46ahFGoE918a0ZzKG2hxkHSEPzMhWrobE1pk+VncdvIZrpQVbmA2bf9JKJM3fZLdsHFjKif61HZxdJUkZxZ0U+bnlBaXfxIjU0CFWnnWtTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 21:32:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 21:32:37 +0000
Message-ID: <6445cb8a-73c6-46be-ac63-3ab185e6dfee@intel.com>
Date: Mon, 6 Oct 2025 14:32:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 05/31] x86,fs/resctrl: Refactor domain create/remove
 using struct rdt_domain_hdr
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-6-tony.luck@intel.com>
 <a6bb4a29-e494-495b-b8c9-fd6b380c9ebc@intel.com>
 <aOBUW81rwl3P7zQE@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aOBUW81rwl3P7zQE@agluck-desk3>
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4958:EE_
X-MS-Office365-Filtering-Correlation-Id: df3be145-5488-4b40-9c40-08de051fdee8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Ly9PTUxDN3Y2NFcvL3FPa3djMHh6RTFOYXNpNjkzcTMxVlNJZTRmQjZTVDU5?=
 =?utf-8?B?eHJWSEdYWTVrWFRKTHIvZlVueUc0Y2xzOVlxa21jdTJidWlWYWR1ZmpUNk9K?=
 =?utf-8?B?TjlYWjU5eWhzU2pKNUNrRWRqc2swUEFyYmxQNFgrR2Ezck53S29uSWJHL3pr?=
 =?utf-8?B?cXAvcHRpUTBGTVpPWWFsTVIveXJ6dGFrOUtGMTM2alJIaGJKRkJkY1cxRktF?=
 =?utf-8?B?NTZ4VzRsYjlrM2xxZmkxaThzcjF5Y3B3cTREVFQ4SUtGMnRhekY1b2xqNmdj?=
 =?utf-8?B?eEVhQWczY0hLdTdJVnRuWGovTW1FZ1FyeVBkNGdmTktidkZwMjhXTEdyVmlp?=
 =?utf-8?B?Sk51cHhIWGJSRWU5djhOdW9KMGJ1bHBlSTEvSGRsVFYwV3R4ZHQ4bTg4MVQv?=
 =?utf-8?B?bDFKUlNtbytoWll1ZWMrb3RQVGtUVDNIM0NoOU43L0FRdHEvUUwxeGltU1Jk?=
 =?utf-8?B?V1NjUmZtZ3ZFcnh1eXI1NGs2aUxUTTJhMTVVN0JNSVlCOFpFSGNkMVpweG5o?=
 =?utf-8?B?T0pEdlVZS2xUaFlxU3FFdTlxNVZDY2JVOGN3WHRQUXRjU0EwUU5TR3ZFTFU5?=
 =?utf-8?B?WVdYb0pwSEswVFRvSG1hUVlFUXpEdWlTUU1mc2g0bWswelBFdU9QZE0zMlBV?=
 =?utf-8?B?WWRTYzRPeWdveGlEZHJFSUkwK1F2U0FxanFmenEwdURyQnhwME1BMHhBNkhK?=
 =?utf-8?B?REJyeUxLSDh4TlhYOXJ1VkZVd1JEdDdwMFNCU2FWRDFRcVdQOGh0ZzJ5M2pQ?=
 =?utf-8?B?WFJWeXJXVzRGMkNrNi9GMkF6ZE1yRDhDV1RJaUFINU5XYjM4ZDFJeFZTN1dO?=
 =?utf-8?B?T3hSSnVTYTl0QzNWNnlYd3ErUGxiUUdkQkZ2dkVTSm9QaDFGQVExQTE4b3ZI?=
 =?utf-8?B?b2VpaU5Yd3VyaTV6RmQrbjV1OVl5eDY4UVJqd0Zmb0g3cU9VamRMUG5BSU1U?=
 =?utf-8?B?bzBIdFBCeHFuZ1c5ZXZZOURCTkd3UWtzNCt1ZWhxNU1FbUM0Uk8zakpyamFo?=
 =?utf-8?B?SW5KT0NiNTFhSE5Vd1pJaHNzUVBoemVnNWJKZFFiWjY5SlZmdzhPWFEwRjFS?=
 =?utf-8?B?TWpaYlRwMndFR2RiT2FzcmhjWVRjVDZqZEY3NDF3L0ZsVzRVMk10cG9Celpk?=
 =?utf-8?B?UDFVcGVQZnpnUFJpckEyaVYrNmpJZW41Zmlid28xL0VBUHE4cEJ5b0pLa3g0?=
 =?utf-8?B?M2F4QkVydXZkeU1EZmVpQ2F2VnhQT0Z0dncrb3JHZ0JNcW5pNDZPanBzV0pK?=
 =?utf-8?B?NktXRkRpRDVoTVZtb1VVaEpWa3l5aHNkODl4VU1od1NPS0I2aG00dHBxUHRr?=
 =?utf-8?B?Y1UwaVlXR3UxQnhMdmVOa1hMaVNDcWtpcnc5MFp4ZFB1bnNOT0FWNkVEdndM?=
 =?utf-8?B?ZURkeGRTRXE3NDdXQjZsRUlLekQwQ1cwNlpvbXNmM2djcXJTMkM2T2JDdi9v?=
 =?utf-8?B?bVptMjdUcTBDTmFtVWhKZ1N5T084aVp2VWE1TkdoTFNhRnhzTTBxSkRIVWtv?=
 =?utf-8?B?b252K0huSVQzNHlCU2JiOXFPK3J3eG55YjBnQ1I4czUxQlpRQ2dsZldQUWEr?=
 =?utf-8?B?UFlja1pkV3NwS1RvOXZvTHBtT054WXNPUzJhd0FSeHlZUVkyN1huM0JaRk1C?=
 =?utf-8?B?bmVvMzJQeFVDdy83RWJjL2RlUyt3VUpyWlYrcHVrQ0Q5blVScHYvZHdjd3ZU?=
 =?utf-8?B?aGdHUU9vM1pTemdrZnhiUVZHMGJicGhsVzV5OEVnZUhVRHdpbTRub1FycnpH?=
 =?utf-8?B?L2hYVm55aWpvWThKMTMzK0ZJNWs1c1NvN1Q0YVJVUmFXTzBZL1RFSnJzQWNQ?=
 =?utf-8?B?UGN0Qlpjb1psd1pTVEVMZElrajY4c0N1dFdaaERRNDg0Wjg0Uk5YSVNIclZF?=
 =?utf-8?B?dHM0bzAzZ0RmbVZWeTVtRUR3Um85eThXZHZqSFNST3UxV0VWTkJTRWR1bDFu?=
 =?utf-8?Q?MSVAMWlLvQ2S8/3aFPX1E6j65nB0EUc9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUJaRXdjRTd1ZnFBdjF3Rnd1RDdwQXJoejBzc0swdWpEQ3JTNWJFUXl3UHNj?=
 =?utf-8?B?anpGb3NQd25oZ2lIQ0h5clZibHE3OHhlbW43anhBZTRXUUk5QVY3Z2cvaE0w?=
 =?utf-8?B?TWd4SDlYanRvSEpQbnJteDcxYzY1ZDhCT2M2VWJmOThrMFR5d2ZmWGwzdElO?=
 =?utf-8?B?Q2E1N21iL3BhZFBrdVcvOEtMQWxHd0ZHZ1BidkJYOFJ1TnZId013b1BORGVo?=
 =?utf-8?B?UVlMZ0ZsZkkreXl0Y1g5VVVSR0xzRTc1VFErNTJhWDFUL2x4SjVqa3cxWFhM?=
 =?utf-8?B?T3JxLzhraGZ0M0ZOanhXWlRicGxSeFNrU3pDNk4yWUMzd2IrR0hTRmY3dXNI?=
 =?utf-8?B?Z1lIT1A5UGRFbnVxS2dhcm5hdEdoUVgwb3JvaEZaMUVQSHByYWl1TG1ZNTlw?=
 =?utf-8?B?WFpnU0IrVmsxYjludEtQaFM0WUFIQjVPZGpJTkIwWGF0YXhRenRjT25maDdi?=
 =?utf-8?B?WVRLMGRtMW1GbFFELzZjN2NPbTh6M3VTUjBNbm9LWTJwZHBxOUlYOEFBNWtt?=
 =?utf-8?B?ZGFLVEErUnYrZWRPRXRnMUJQWjhhWThCRzJud3V3QkRLVm9KaWRRQzVkU2ZK?=
 =?utf-8?B?N0ZKdTE0a3VHSWZXVGlGYlZUbk9jRXN3UkdjbFBSWk1vQ0EyOXFYRzNzaUhx?=
 =?utf-8?B?Mk9BME1VMXJoMVA2cEF4WkN0WWdsaE1wdmY0RDJCZ0FKL2E4d2c5MVZFMGE1?=
 =?utf-8?B?TVlrZ2E2d1lOOFdIN3poN09TTDh5T2FHcUcxMzNDdlBsZ0dHa01HWG1BejBJ?=
 =?utf-8?B?ZFcrc1lRak9LVGwwbjdXVEJLT3pERFhzOW8vNGJFVWVNT3JkRHR6UFNaTWVz?=
 =?utf-8?B?TEI3aDdXK1RwcXM5QmdWdWtSbzE3ODBTVVY3bkNTZFVEeXZmWFdPbzdTOHhH?=
 =?utf-8?B?QjRVUXR0TmhTMEhMandyTFhSUUxSWnJjcG1OczJOUjk5U09xSFk5YnQ1ditE?=
 =?utf-8?B?Rkl1bGdWbzkxSEdibkFIelZTRFFCdmVkVWhzUWovdDRScXpXcWRjamlmRk9O?=
 =?utf-8?B?QklRTmtEVjJHS29zbExQNGJUc2tHQk9wMWhNS1VJblRrRHRNc1dIdC9KK3or?=
 =?utf-8?B?SHpPdzlLRTNmaXV3b0prc3ZCV3dyWlFsQnFydmRRQ2I0WThBU2ZUaUVOaTNw?=
 =?utf-8?B?NUQrYlZPTGVHdEE2SlRMK1kzemFlSGx2bDdOejJ6NTlrY0VDMGRFRUE2T2Zo?=
 =?utf-8?B?MERWR2JDaTh6UitzOTc1cUdUUmxFcWhmWnFRYjNqb3Jrd1U1VHRwSDRZcDJu?=
 =?utf-8?B?V0p1KzNXWWp0enpzRTNqRXFVZ1FSTHVGL0NzOFUrdFVEUkhDcSs5WWtxZ1FL?=
 =?utf-8?B?WDRrRU0zVkh5SkhZVXVOWWRYWksxOWk1V1R0dFQ1RVhWOUxjOE9MRzI4WEJu?=
 =?utf-8?B?OG9qcFJvWmM4cUJpOWcyL2pKTTdmbjA1NHFmK2xSaTlqcHdhVjZ3c0c3Lzkz?=
 =?utf-8?B?ZmhYU09JZkFDQ2pCbDV4eDFaTjI3ZDIvQ092blhOZ1lLSmR2cmQ3Vm1JWnZu?=
 =?utf-8?B?ZWZNQmMySUJSR1J4UUVYNDZmYUg4Wkp0ellOZVZXRy9DVVd4OFhGcXdEWDFu?=
 =?utf-8?B?Vi9BcmVwalFFMnV1b2pxYzdlMEViY3FtN2lEa2RwTFRSc0hEdzRqR3Jpclhk?=
 =?utf-8?B?WnNsY3NNYVN2SzJnNmxuMWVMa1FIVnlWekYzSjRVVXlIRUNmVnNQUGZFdmdh?=
 =?utf-8?B?Vm5ZSnZiOGt2QzVzbmhPbzlCcWUydjNrVzJyK0YvS2U1TVdXWjJCWmNwbkdF?=
 =?utf-8?B?eVY2T1VJaG9CLzRNU0puMnZSTlI4VXJieTN3bmV6QUtLK1ZpYmdKZFVHUEFq?=
 =?utf-8?B?VnZ1K09VaDFFRWh5bEZwaFR4VUphVFFBblRvVXFmR2xuemF5K0lQWnpQS1Ez?=
 =?utf-8?B?eW1aeGJIU05BRkEza1pTaTVSTHZsNUVDRXI3RlN3L2JVUG83NEdZdk1pbWhs?=
 =?utf-8?B?MEl0ekhKbzY0K0Y5UGlMUjFJc0gzOUNzbTNpb3pFK3diT2dDMXJITVJUL1Fv?=
 =?utf-8?B?SHRYbFFrYWZrZmxFR1JteTl5VEExU0xRdlRuS2ZYNW80SExORDRlSFA5djg1?=
 =?utf-8?B?b0tpdTNESGdzSGVVNUdnRXY0VE1qM3duaHhSbmZCSEdnbTV3ekQrZDJmRkVT?=
 =?utf-8?B?REdmamNNeEc1YVdnRkhrMjFhY2srNEwyVFhkS2lEN2lrKzMwaTN5cWg2eWRk?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df3be145-5488-4b40-9c40-08de051fdee8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 21:32:37.7369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZh9NNG7GkyfxVsv+3ultGOVlDs+gJV4d0XIYwZiGABLUc/d9t8DfiYWrSy4EVEgK/ZmnDClj7dfz0ChgL09pLFZR4YN2Kha6hKheBbEeU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4958
X-OriginatorOrg: intel.com

Hi Tony,

On 10/3/25 3:55 PM, Luck, Tony wrote:
> On Fri, Oct 03, 2025 at 08:33:00AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 9/25/25 1:02 PM, Tony Luck wrote:
>>> Up until now, all monitoring events were associated with the L3 resource
>>> and it made sense to use the L3 specific "struct rdt_mon_domain *"
>>> arguments to functions manipulating domains.
>>>
>>> To simplify enabling of enumeration of domains for events in other
>>
>> What does "enabling of enumeration of domains" mean?
> 
> Is this better?
> 
>     To prepare for events in resources other than L3, change the calling convention
>     to pass the generic struct rdt_domain_hdr and use that to find the domain specific
>     structure where needed.

I interpret above as a solution that is unrelated to the problem because the problem
is stated as "prepare for events in *resources*" while the solution changes how
*domain* structures are accessed. 

Here is an attempt to make the problem and solution clear, please feel free to change:

	Up until now, all monitoring events were associated with the L3 resource
	and it made sense to use the L3 specific "struct rdt_mon_domain *"
	argument to functions operating on domains.

	Telemetry events will be tied to a new resource with its instances
	represented by a new domain structure that, just like struct rdt_mon_domain,
	starts with the generic	struct rdt_domain_hdr.

 	Prepare to support domains belonging to different resources by
	changing the calling convention of functions operating on domains.
	Pass the generic header and use that to find the domain specific
	structure where needed.


sidenote: I changed "manipulating" to "operating on" even though Boris wrote it since a
few of the functions changed in this patch do not manipulate the domains but instead use
them as reference.

Reinette
