Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6AF27453
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761194047; cv=fail; b=CJBU7bQfFWjcXBX9WKxe9jivjsa2LEsGVT4ilOoEDZGKD9wseqCznvCaIO1WYrkSrcjGqBLsIGKACkr0G7fYI/O2K0PwK8hK2mU4ST0fG0u3iWUtRC8k1w9qZ8Y4vvclF195vC1EGqAnaFXLGwMHaLG6SGktEsL7OQE9NX8wFK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761194047; c=relaxed/simple;
	bh=iMK+fMbZKoq3QubH4KcXvewtbPxTpKpZ9bqwhc50438=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QY0TKo6CN6Y/3qvJnf8CjqwDpCy2e4nLGNTunl1oBZ7EsufGZUnsqrdssUFTvML7W/LERulnTHgDO8bjeIWRtLsuf8+0flGhuuWXQMhD6zJuA6R87NBln77k1Q6DOm80NnP4gYcjuWHaRMFnsbkwlWlgXodedGk48vwuVgDW1GU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N+4izzfm; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N+4izzfm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761194046; x=1792730046;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iMK+fMbZKoq3QubH4KcXvewtbPxTpKpZ9bqwhc50438=;
  b=N+4izzfmd8f21I46TghRata8H4qrMaQIMG9xTs6C1ilKaxgRmKI52gSk
   7KSh/JUR5rSJEtsxtLjxvhe/jlPz0qsINFz4VnrlzeeFoTTrREWrIy0XT
   8zEn/JEab+uAsAwjfn25B7h09n01hzNdv3WqjTgiMndd/1yfqHZ7g2MYe
   plLokypY3GjmhO4QaRT63Wr4Jiljc7/k0ysVufEuskb7eamZIiosXNCCv
   4l2mzSwfsFM6qTjQE4QOKce9HvYAZBBFjKcBHJOgIVi3QEyOTU/ZlGrSE
   sn/WHfYYH+hH03NBQUEOrGwscpbTZk7ndqupC7Jzu6YE3vkxfH7QnK6hC
   w==;
X-CSE-ConnectionGUID: OZBI5j9GTeqcz/qnjV3tLg==
X-CSE-MsgGUID: krhHYlpeTuiJdLalbEUE6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80790586"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="80790586"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:34:04 -0700
X-CSE-ConnectionGUID: 60jUCFrfT9iEEqYcXRB01Q==
X-CSE-MsgGUID: xeXZfhENRnCWkgVYjgG3eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="188341546"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:34:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:34:03 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:34:03 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.22) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:34:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ybV3sw+MVrW5njK3q72qbB5UkIWZbbjGrIP9PQAhmqs0YnS5DH9ija7xrNQ2+YCy+74ER/KXTuR0L07mkyKkywgCGbn4koGHEWFOtPHy/Wcmf/SNmP7AE9hUrmZYVlfYBktnN2+8EtR7sA+kXWNJk+05E/F7DGgUZZf2mDzmFlUjqP1agDswHuy5cBMitrZWxFIgOnx/7jXh1b8cUbghOwffqZAi8ARW7ip39jqAkHPeTO+YAoEBKNLb7ZAQYt78x3Dkn+Qd1XYeXegL9yUso++5MjAf/AB1phuqDWuCLAI9UFdabjBO+AasgwNk85s70OZepLEidjphaPWD2tsxUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GHYjnjf8aX94sTv6NqVq8/7cdj28a2f2UJ3Tow8eCR4=;
 b=iwEkzYxKI27/mz2EXypf3r2972geOfOfChOGZ+1V44iKVB9+OqORTGVrq69Ron398hmmSrmxg0nt9qZV0zr9DhU2Y02XJiIZVYHYsDS91vuJbEnvOnHoiaqz5L2n/vkeFeTmpu95wlEDqm9jVOMj3ExBkBZXYrZ8rEYB4ynpzq8kHtP+afOrYjTZwTceVzMT1A3E1z+cVK1Ff8RO1F8NVjFAmz5w8copsCJ4n/q3aFirULOjTfIB8w6oFckCyzj40/Hn1/R9VbohamhOYrxKa77lgpBr+B0ZnRxpGX75yjawqceE5SSjghPWjMS3dRTAr4Jkajnj2jzBSe3jfX+ZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8408.namprd11.prod.outlook.com (2603:10b6:930:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 23 Oct
 2025 04:34:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:34:01 +0000
Message-ID: <a10e3334-3616-43ee-84bd-f26469f52051@intel.com>
Date: Wed, 22 Oct 2025 21:33:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 13/31] x86,fs/resctrl: Add and initialize rdt_resource
 for package scope monitor
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0300.namprd03.prod.outlook.com
 (2603:10b6:303:b5::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8408:EE_
X-MS-Office365-Filtering-Correlation-Id: 722e3d70-5c6b-42ab-7bdd-08de11ed63be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L1ZQcFN2MjRXL0Y4aENoN1lweHN5UVFjNWpRZk5JRVFxc0ZlaldsbE9ocFRi?=
 =?utf-8?B?YkZ0a0ZwMkxhbURnNkZkNFkza3hnSG9PRHBNOVo4Wk80eDEvTm1URURVRjJv?=
 =?utf-8?B?MzAwSnVxVGpvQUxKUWRqN0dWSzJrNGZPbzQ1Y0ZmbVlIUm9lL0pLcG84Zyt3?=
 =?utf-8?B?Qm40QXRjQjRsbVYyV3RjcktYU21uWkxTeVVpWDNGL3p4R2I5dzZtU29WSElp?=
 =?utf-8?B?YkRjZ3RIdU5aeXd5Uko1Nm9TN1FWZTZKT3IyOHUzeTZiVzNHREFGdmlMNzZk?=
 =?utf-8?B?V3JzSjhudkYycDU3SXoxTmtNRmtUL1JtQWdVZC9IendOWU1VWERETEpVK3gv?=
 =?utf-8?B?Q3hUTmg4cUd6VTFDNlRiMFBzMTAzdzg5NFNpek9XTFg0d1p4ZTFaNE1UYWVu?=
 =?utf-8?B?RjNmK0FQd0d1WU1zV3NlbzdSNHRZVFhIZTFyMEh0bGtYMFViTjB5NzBHK0kr?=
 =?utf-8?B?UFlaLzYyRjVrV2FqSFpMMDd1MTZ1TkhWWklGUGhmNkhSN2JwbWFLb0hZclIw?=
 =?utf-8?B?dDZnYm9zZldhTFdLcEJ1RGNwN1R4eFYwZU5NSWJVTXcxeTk3QXcrdExSdWIx?=
 =?utf-8?B?d3VsQnJSUVpPQldqaG1rNmZoK3RaakxTak4xRjYwcndUQkNxZ01palBVQVVz?=
 =?utf-8?B?RVJxYUlxYlJhdko3ZG44ZDgrVzg4UXFwTXhlcGpXdlJrcHpHQW5GaFl3TlBM?=
 =?utf-8?B?RnpEUS8rUDdzMW13TENhbHJiQmZzUno2T0J3QjJkZ2thVlkvNHJubGJ4YStm?=
 =?utf-8?B?Skg1YkFyMmRBN0Y0ZjBqWEJGMWRPK0lEZnA5N0pndERUT25EbW11NFBJVWdz?=
 =?utf-8?B?TjRRdW04eEpubVFPbTVhZUR6NUxaU1NWQk5Kb0RVcXFVNlgySnR3QnkwNGZo?=
 =?utf-8?B?R3FlMWtrWW5jTFhWZjc1Zm0rQ3NCVks4RERoVWNzK05rY0N3RnZzRGR0VDY0?=
 =?utf-8?B?cHpVZ2UvZWhGY2tnTUIrZ1ZHekY2N0ZSNkRKYkxOelBBVDRORGtUWXVJRnBT?=
 =?utf-8?B?YndpVS9mOUw5T21ua1gwZFBTQUJCSys2U1N6Q1hTM1ZDUjBndHNDcWl6SG8x?=
 =?utf-8?B?NTJoKysxdG1DOERCZnlScU9PVHNFejlwaWpFMUh5Wm1EV2RpREFOYzBJeVpz?=
 =?utf-8?B?NGxhbkNDRnNXZFhQbG9JSmRPM0JzbnVZT3Jka3BzS2FWcThLZlRGTUIyN212?=
 =?utf-8?B?NTkyMnhEa2JwSW9NTWVtVk1mYWJOR2o5UGZ6bmt0dHN6K0tRUXVJbi9DelIr?=
 =?utf-8?B?T3Z4SkNiQjNHcit6Sm1zM1JXZE1JRWo5MWY3ejFvemZWdFpwRnpFU29LRkwx?=
 =?utf-8?B?L1dHUHVONWtLN2paV2dqRlg3S0xyRzFodzYxVmtFWno1SDJITFkwK2poTE1r?=
 =?utf-8?B?OFRnZVpDSkRDSDhYYy9JVGlLaDhhRldTTVdDdWFwTGoyZEZVUSsvbHJFbE9t?=
 =?utf-8?B?eGwvSGRYVmVuV29zdlQ2RDJxc0w4YkhDZHV5NWNtRDlLM1NVZE1tNTN6U3BU?=
 =?utf-8?B?MngvRzZJZ1FRZVM3eHd6Qy9LRnh1cG0rK3pwTW0zRjZCS0UvVWlrZ0pmK1JV?=
 =?utf-8?B?b212bWtVMFpjNHNRWmdLQmJCUmVJcVZPVmR5Z2JBWnBvQVVhYi8xbW1OWSth?=
 =?utf-8?B?S2p4bmZrUlZKQ01RRlZvdE5qQXk1NkhPbEFWZmFzWFFuLytzb3crNWdPdVBB?=
 =?utf-8?B?cStEVFA3V3A5U0h4UFhZQUY4OE1pZ1Fob3hjbmlJblArVmkxc3QwSmh5WWEy?=
 =?utf-8?B?dm03UDhudXBrRXlhWGk1TnA4MG4wTzhveEVGdUdDdUYzOFkrS09PUlJTZVlZ?=
 =?utf-8?B?U01uRWJWVm8remxIbm01MHVkbCswOU1Lckt3WDRnS2xQNlIzUmNHNEpqRDNB?=
 =?utf-8?B?OXQwcENtWlIwcy9XU2JBSTRvd1BmdnpFdENKOVhOeWdEQUk4NGg1WDl6dFhs?=
 =?utf-8?Q?NJC0PW+FZhDHjTAGoPJTqhb6e40x83/f?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXJpK240S2lhOFAyZUhydHFlWXVTUDc0c2VKQzNIN1NJMDJXTExUUS9qZVBT?=
 =?utf-8?B?dE9nRXdHWXBPK1FoS1BwVjFMUmxnVm00dGRQSWVXOWo0QlZLMnJGUjlpRHV1?=
 =?utf-8?B?bFYzWElZcUE5Wm5wNC9SODVlVzlnSExZU3lyaWtEdUVXb3FZWXJlYjRUbk5j?=
 =?utf-8?B?UTFlV0hON0VvQWRJNWlyTmhYVjlJYkxXcXZiT0tNeFRUL09kZm1BMUoxckM4?=
 =?utf-8?B?aVlWRWVkOHE5NzJnRzVHaEE0RXRnQ3J0eW1YTEV2YkplVTBXRUJCODFNdGhr?=
 =?utf-8?B?anpjWnlFREpRdGVrL094QklHS0MzMU9lRDhOUy9QV2tyMWIzQXBTb040M0dE?=
 =?utf-8?B?cy9ZeWZuYTJ0RThMQW9LYXRkN2FRbHRqM21kdzFxMXAzdjJxcWdNZ01tZW1M?=
 =?utf-8?B?OExGcWdxQTNBL3g0U0V1MzVMNlhQMVlnSkhSRDRWZDI4d2ZtbFpKbFNYd2oy?=
 =?utf-8?B?VFZGQzljZ3IvNWQ0eExmbmNiRjZxbUNDYUU0V2UxcUdHUWpoV1pJT0dYZEZJ?=
 =?utf-8?B?QTZiMDZZekczZUpnUEMrT1VNNTFkVHllZG96cXpNZzB4bTNDcllmQUsyT2F4?=
 =?utf-8?B?NXpOL01FcUdtL2NRZmN2UTZJdDVjbFJlQVNVU0oxYUt2eEJQNXZFQUhFTVpq?=
 =?utf-8?B?QU5MT1hoU1h2RkR2K2YvTUxQMlhBOE9PTGRuN1JIc2NHUEtCb0dLQURjQ0Ex?=
 =?utf-8?B?Z04wZmpPbE5TTlcyL0dSbDZ4QzVTOEFCV2EvT1ZTZVJkWHJmZjlHZXZBTWVT?=
 =?utf-8?B?N2l1cVN1akJkQXlwUWdCcU1KakdlNzE2RTVlMnFKbFZHZmo0MklqbFRIZElj?=
 =?utf-8?B?SFBRdkQ5RS9TbmpBeUJjOXViVlg3MXF6b2twRjZkZWF3ZVB2U01IUTh4S1hM?=
 =?utf-8?B?WVdUSTJJWGEraE80S25FUWwvTE5xZjBFR1U5YlB1eHJDK0NjbjE2TWNqMzV6?=
 =?utf-8?B?MTlTNG0vSjZKQTRFL0U2VmQ0b1NudituVmJHeGNXZld5WFhiOEtZUTJ6TGkr?=
 =?utf-8?B?azJiMFdzaGpIbkJHQkRlZSszQXdWV0N0WUExZHZ6bEhYNWhXRW5GWUFzeUlr?=
 =?utf-8?B?R0Z3WUZ4cU5KdXV2dFFOeTlHTUNSQnJWUUtjWWMrTXErc2VKQnJEMElwMzZH?=
 =?utf-8?B?bVdOQkRNODZJQUMwditKMndyNmVaWnNqaU90ZkFscHBHTDl2RTQzcDQ4V1kw?=
 =?utf-8?B?bGl3U2tZaWNwcm9PZDVNOU9RSmM3N09QWW8rM0wxTTVoNDFlanlDaE5ybFlJ?=
 =?utf-8?B?OWYwT0REWkE2NmQ2UUF5QVZkbnlQTndNeUNXMG5kRVo5SG1PL24vREZreWxD?=
 =?utf-8?B?SHIwaC9IZ2hJbVZ1U3FUL2F1a0N4TWNGRGpQTFFGSWR3Q1RCRGhQano5NHVk?=
 =?utf-8?B?MkorSVI5Mk5jYkVGNnpybEJYWk5jc2hoUWZubythaG05UmFhNFZreFRFREhH?=
 =?utf-8?B?RjV4R3E0aVo0VHJqdzVCcG96em9mK1JXOER3eVhJYmVQbk5XUDZXaGlWSWh0?=
 =?utf-8?B?NnAzOEFGT2dLT2pvU0FQWDRlUitCWGJ2eEFGcFpkNnR6NEswQXpxeTZoL21Q?=
 =?utf-8?B?OUpGbWdZdWlBUSttdmg0U1F2ZHNiTUpJNjFGVk4rb3NlQUovK2dRVGZ0cHZN?=
 =?utf-8?B?aDkybXY1bWYxbGRCelppcGJQNkpRU0YvWFdkb3c0K25DM01sTGZSZ2RUMVk1?=
 =?utf-8?B?ME9DdU9USGJhL0JZdjdmb1Vzd0ZtVm1CVHIrUUxLaHBOa3lVdGJuemZzZHF5?=
 =?utf-8?B?Y3B3RThHdEJlM1YyWjhlWFNnYm9kdnlwK21DSzRLUjM3NVVFQ1ZPeHFJV055?=
 =?utf-8?B?TC9ROWFYQVM5N2g2MTFUaUdzY1hhallwdTNuRFZRaFplSGpuMDZ6RFdYU3pG?=
 =?utf-8?B?L1JYbUUwRi95cnRlNU96aEJ0Ti9lVUlDdUs2UnVKditRdTMvMkd2YWxWamJh?=
 =?utf-8?B?bzVSenBIUTBqMGw4eVRCWHJldjh0Q2l3QjRtdFgzdFM5V3llK0pwVUpITGRE?=
 =?utf-8?B?QStuc2tZdExtbHdOZTU3eUlpb3d4M1YzRkVUd1BPWHFJU1FpM2hBVERGcm05?=
 =?utf-8?B?SFI5YnNtRWJtN2RNUHp4Z0NiUitVNERSMUwrMUx5ajRqY21XTVFRT1ZTTXRC?=
 =?utf-8?B?NVpueUxSem0rcXpYbElQWUpRajAyUTA2TXVZWkROTkxyNCt5RHNxRW5ZUHpu?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 722e3d70-5c6b-42ab-7bdd-08de11ed63be
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:34:01.2533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fIoTYGup/57eJplc9i+ziK6RoNiTMwfgyWaQhTBk1PnQp1Tue/SqBKMWef9RU7yP2OOR01pJbcqJCwnIxFpc7B6EE3gx5xj+LTevA6wHhKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8408
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Add a new PERF_PKG resource and introduce package level scope for
> monitoring telemetry events so that CPU hot plug notifiers can build
> domains at the package granularity.
> 
> Use the physical package ID available via topology_physical_package_id()
> to identify the monitoring domains with package level scope. This enables
> user space to use:
>  /sys/devices/system/cpu/cpuX/topology/physical_package_id
> to identify the monitoring domain a CPU is associated with.
> 
> Now there is a new monitoring resource, add a WARN to places that
> implicitly assume RDT_RESOURCE_L3.
> 
> Update some kerneldoc to point out L3 dependencies.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

I do not believe that the changes added since my RB tag fit with this patch.

As mentioned in patch #5 I find that (all but one of) the new changes added
to this patch can be merged with those stray hunks found in patch #5 to form one
logical change. 

Below is a high level of what I have in mind presented as a draft changelog
for that new patch:

	The feature to sum event data across multiple domains supports systems
	with Sub-NUMA Cluster (SNC) mode enabled. The top-level monitoring files
	in each "mon_L3_XX" directory provide the sum of data across all SNC
	nodes sharing an L3 cache instance while the "mon_sub_L3_YY" sub-directories
	provide the event data of the individual nodes.

	SNC is only associated with the L3 resource and domains and as a result
	the flow handling the sum of event data implicitly assumes it is
	working with the L3 resource and domains.

	Reading of telemetry events do not require to sum event	data so this
	feature can remain dedicated to SNC and keep the implicit assumption
	of working with the L3 resource and domains.

	Add a WARN to where the implicit assumption of working with the	L3 resource
	is made and add comments on how the structure controlling the event sum
	feature is used.

> ---
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index f5189b6771a0..39bdaf45fa2a 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -92,8 +92,8 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
>   * @list:            Member of the global @mon_data_kn_priv_list list.
>   * @rid:             Resource id associated with the event file.
>   * @evt:             Event structure associated with the event file.
> - * @sum:             Set when event must be summed across multiple
> - *                   domains.
> + * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
> + *                   across multiple domains.
>   * @domid:           When @sum is zero this is the domain to which
>   *                   the event file belongs. When @sum is one this
>   *                   is the id of the L3 cache that all domains to be

above can move to the new patch

...

> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index ae43e09fa5e5..d681b71e6eca 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -712,6 +712,9 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	if (md->sum) {
>  		struct rdt_l3_mon_domain *d;
>  
> +		if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3))
> +			return -EINVAL;
> +
>  		/*
>  		 * This file requires summing across all domains that share
>  		 * the L3 cache id that was provided in the "domid" field of the

above can move to the new patch ... it can form a new hunk with the hunk from
patch #5 like:


  	if (md->sum) {
 + 		struct rdt_l3_mon_domain *d;
 + 
 +		if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3))
 +			FIXME
 +
  		/*
  		 * This file requires summing across all domains that share
  		 * the L3 cache id that was provided in the "domid" field of the

I added the FIXME because this should not do a direct return here while holding
CPU hotplug lock as well as rdtgroup mutex.

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 255d4bad24cb..4c984dc6784e 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -501,6 +501,9 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	 * all domains fail for any reason.
>  	 */
>  	ret = -EINVAL;
> +	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
> +		return ret;
> +

This looks redundant to me when considering the WARN added to rdtgroup_mondata_show()
... and it is removed in patch #18 anyway.

>  	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
>  		if (d->ci_id != rr->ci->id)
>  			continue;

...

> @@ -3028,7 +3030,8 @@ static void rmdir_all_sub(void)
>   * @rid:    The resource id for the event file being created.
>   * @domid:  The domain id for the event file being created.
>   * @mevt:   The type of event file being created.
> - * @do_sum: Whether SNC summing monitors are being created.
> + * @do_sum: Whether SNC summing monitors are being created. Only set
> + *	    when @rid == RDT_RESOURCE_L3.
>   */
>  static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
>  					struct mon_evt *mevt,

above can move to new patch

Reinette
