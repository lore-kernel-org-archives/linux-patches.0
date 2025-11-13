Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F072E1C63
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763073514; cv=fail; b=be3/auyh4GW2D0BEgowT1oWeZzLRNk52peM4Fc+sbrC4SONyhWavX76jFI4WR3ASamTUY7CMcm0WAATKTWaWHZbkdlZxT8S5kRqYEjjtWlM6YljzMosmGivQI0Cl74YZo05Zebl5yDFbAk4yAiqShkHp/guoB4AvsUXqobwkfKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763073514; c=relaxed/simple;
	bh=nDzqBu6TaxNEvWlz9DJJBqmS/1u90+EmOKRE15JV20w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NcvqBtdO+8wZfGe1vvzzryRy+KJHKUBFrWnnHeKKcWMxa8TzBZthNly41bAKukIh00gWVy2OxkZsah1DcOgFpyKlIoUFP6WFjIlV/eDK0oCiRGRvj02S2f6WSxxXjSAF9JOUzX/TCBvwSzRKrfmo+kb+o9k3A3htL/OJKfmqvAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HOvkiLcz; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HOvkiLcz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763073513; x=1794609513;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nDzqBu6TaxNEvWlz9DJJBqmS/1u90+EmOKRE15JV20w=;
  b=HOvkiLczm0+0YPdskENQqdhj4QB/gm2sOsPdKPBcQ92TNnosNxkFD2hq
   IjRLNGy9C7tkGyyrG6R5kVA0UzmNrONcKL3CGKGzdpzfbBuWcf1E5142H
   1AHAzR6PXr4W8Y81do8gk8/3b8rI05CxZzlFWZhn0TPj4v0P5iI0JoS3e
   Lulbepwz5yiQCaROyFG6Kh4B2Yz2+BP3uwZ8c0KHZZ7sWEbFqNtMePf3q
   XkDZSq8n4vIMDxggKolKyHE6E3OGXnPsvLW/4xYzkCzx+R0WP0JNSYuAo
   PtIm0pjl525e/jVAnSM+bs6t3J77wSRjBvndfTcZszBqYypoVW4iw0mGs
   Q==;
X-CSE-ConnectionGUID: K7QlqQ6DQfWpshcEZRXHlg==
X-CSE-MsgGUID: xlNfpFxORHqKUmmu0xShXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="76626461"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="76626461"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:38:33 -0800
X-CSE-ConnectionGUID: gbFjK3txTSuAZ6bOB1BG3g==
X-CSE-MsgGUID: CgeFK7csRbq6rL5i/CjX4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="213024635"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:38:32 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:38:32 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:38:32 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.44) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:38:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkEbTwsIrQwpzOOKrtUC27Mcnvhf4EjszvEFpE28TiyKGU20hG4Rcde8lUOJhwcOwTVsxAz4x3kfzIZcoNFb0sN2YgfKsMaohrcengZVq5AigRTHDfzmvwgmtz5e2b99jYB56O7cLgWL/xt9/pxPzuWrimXYnkjS+NGmFcshTEtnJT6CTrkmKlZY6zdS1jPnlSRKGC2jJLXi8DjXMJ6rNe6fGYxK6W3gdpcGXOVBz4Q3OrZtrvQrM2AXlchAwhZCY10CmJrffjjNTVOAONbR5l7ObfOFdjGgtnivNSffqJHkplyohgs+uVtwMWvzCKzB6O6tjeTGBodNs3aMsyxCbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYshsBCY/LoSw80+0vGXfNGjNv9sFtGUuCRCJxrUSzk=;
 b=tNLP54C4afxt1xN7CADSvNdsTmTgimIkLs66R6kwwPmeDI+9PSCaPCuDQ/JRiwsJuL/+5FFdnzKaDsXP4ARr2XXcidpD6RxPwANWdrUyMIv/hdgfZjqPhPLeN3hCD9H6UYIeSehuMpWzOwAYuYNqNi9IoGUYQmxSdxq7qf+PScRei0P5v9SNoXgo/LBU6Xdg4Yu3GrdP9MOwrc+t2mUk1HWOV06ecnziRbpjSXic59SNR0UNr8JBngUx4J9eQVQxWFKV5b0D7EgeimBJNvuJjNr1T+vXjtDsv0EtS/PH1XHWY//0NO8HragBT+RyI/a2cg/QJ6GUBd8PSFAdbWTUNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB8265.namprd11.prod.outlook.com (2603:10b6:303:1e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 22:38:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:38:27 +0000
Message-ID: <e359ede9-afd5-45d1-b61f-ce748024870b@intel.com>
Date: Thu, 13 Nov 2025 14:38:22 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 17/32] x86,fs/resctrl: Fill in details of events for
 guid 0x26696143 and 0x26557651
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-18-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0086.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB8265:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d86efe7-eed6-4952-13b6-08de23055cea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?LzNYR2JPZEozR3lTSTJudzFmdjRucHBKZlo0TldkQVUwQTJjOWE0M2g2N0h6?=
 =?utf-8?B?bm5vbEZyaTUwVXBMaEhXemdQVFRKWFRUYk5ocHB3VmlpYjhaQUQ1RTlibmk1?=
 =?utf-8?B?VGJMeHNXV3BVTW5iVUtIcnZQNUZMQjFFMjdSZ2ROVmtOUkorK3FyYkhaekJO?=
 =?utf-8?B?VVhHWDNPQVMzR1o3KzZWYU1pc0dWd0VIcS9Pck9hUzZBcHZQYzk4QVg2TGZT?=
 =?utf-8?B?akRMWlhCaWk4cGJGQXozZEtKc0V5KzNkSUlqeUgvWXpuVkVvZHJMNldnTlNt?=
 =?utf-8?B?U0FmZGUyeSsvL0NhMlZscDRVNXpzMHpJY05oNmxaNGUxVHcyMHVaN2NiRkVN?=
 =?utf-8?B?OHRVU2lvUE5SWVFDUzZKTHNhRksrRTc5dE5NUVRNQ3pDdXBqNk5QRDdXZlJk?=
 =?utf-8?B?VU5SNEpqSVBuTmhLdGlPQW13SWI5VGFERGxtb2U0NThrYjIrYXl1M2lRdlgr?=
 =?utf-8?B?dy8vaTlXQmMwOHJqaU1DbmMySzFUVTNTL0RjSGJTdzNnaFRBZnpxdHE5SnV5?=
 =?utf-8?B?dXVPS244UjNiUm5OWXVvbTY2SGREOHBYMmhrTGdxZXgwRGRJTHM3RWxnU01n?=
 =?utf-8?B?RkZHNHF0dVpXVVZmRmErZDdmUTM2bEg2ZDVMQU1uNks4WkpJd0NHa3JVRXNZ?=
 =?utf-8?B?ajg5UUV0RTlmdTFpayt1dW1yaWVjeGtMNnpoNEhrSFptUHNnU0N2MW5FNVMw?=
 =?utf-8?B?cnBqclpWTUtvcndKUWFURVJvME9nZFZZUDFCaTExNHRpMHdpcHdDWHZISzh6?=
 =?utf-8?B?VkJxT2RnR0NEcnU0YnZWR01UUGdWQnRRS2RjNEpkMXgvY3VScS9rVkJRenlP?=
 =?utf-8?B?TXJSbDBmK0VqTGRxaXlubVB6K1o1eUxWR2daeHFLL1FycVIvbGQvbzFSMk1X?=
 =?utf-8?B?Z2pQanFESURoaU11Kzd5UUhkcmlHQUY4a0p3RGIyaGlURUwxMFphamZlU0JW?=
 =?utf-8?B?Y2QwcHhYK2N2eEhkbTdZU3grdXY1eDdYZHU1ejE2VXdUNDZYNHhVZFo1RzJ6?=
 =?utf-8?B?elNqd0dNQjNYa3BKaDBaSEhoakhKR2hRMGlzS2xoQ1dpZTBpano3cVpPb2dQ?=
 =?utf-8?B?REZNajg0QXdOeEVKQzk4b2gvM0w1Yk5Sd2xUWjZEMmFmVUkvMTJCazBCT2x1?=
 =?utf-8?B?TVhzSFBqbkRwdC80aUFXWFE4d0NmZ2xkZzVmU0ZhdGl6RXFYc2lMMVF2NlFn?=
 =?utf-8?B?Uk0yaTRrZ3ZQemdwSHYyQjJwTHhkYVZMaXZJdS9YME10emxmUVorYi81b0JS?=
 =?utf-8?B?MGcvT3N2MUJCenpMSFVWWmRCVEI4a1NjRmdGbHBlZWxtUCtOdTZxOFd3RlVL?=
 =?utf-8?B?aXNNQ2QrVENWcUU4bnNMdnJNelF4MHZLelVkVVBoU29yN1dvVlhpU3JwLy9l?=
 =?utf-8?B?cDdJcm1XWGt0T3ROeklOWGZjazhTM05oSzJzTUIvZFloRmFWWnJsaWcxb0Rz?=
 =?utf-8?B?eEp1Z1VUanIra2l2ZjlzWkdiTnpub3YzMXJFaEI3U3cvY0JGM0laWWFkNnd5?=
 =?utf-8?B?RFlnZjRMZHlnNVVhS0Zoc0d4aks1WjNiK21Jc0xmeksyRW43a3JBV0JZeXVz?=
 =?utf-8?B?UUc1RURRZWU5cjM4aHNzV3ZMZzFHRVBDdDRqdHRMYzdmMDd2N05nSktRcjFl?=
 =?utf-8?B?UUlJN1kzUGpLUXFPcWNXb0h3SE9wK2ZRTmJmRzhvanNqcDFOZFBXTE9ZVDBv?=
 =?utf-8?B?dERkYkVUOXlvUklsMk5vaHZrZWNaSGxKeEwzTGJGajlMLzFkWlZGN3BTd0Nu?=
 =?utf-8?B?L0FNQ2tHUHJPSUtOdWlZMFlSQnRWajlRaVE5MkNLbU9OdUJoeXEvMzBvamxp?=
 =?utf-8?B?WTBrQVVOSFdmVVlsOG9ER1lxYkV5QnAxWTlPOXZTYlRxUis0RUxsU05Zbllv?=
 =?utf-8?B?M0x2dU90d2dza0h4MExCeFJTK3JDbjNGT2xWZmpvWVNBS3V2a1VjeTFnWHo0?=
 =?utf-8?B?VDVtSldFNmtkYXg0VVM0eTU2d1JBQVVSRTcydVoyTHhhQW5zd21EcUQ3czg3?=
 =?utf-8?B?cVZBS09VYVlBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVREak9KenJBUzZadnRrdTlKVFB3QllmZnpnQ0hrSUJOanNLdWJwWjc5MlJP?=
 =?utf-8?B?cTExSkY5VGl3RGlTR1plSDlYOVozS2JOREs1QzM4ME9CcStaYjl0YXdjKzhH?=
 =?utf-8?B?TWc0UXkwWkxJVTdZbmVhd0QwVEtZbWk4aGlrZ0dEOFRqVklnaEhtMVFmUUM0?=
 =?utf-8?B?b1hpWXVxNzFkajNHRE5mQjQxUVdjcFdTUjdWNDU1NHlUNlh0VFQ4Rm9rQTh5?=
 =?utf-8?B?WWZFcFZwTHlQeGNWaE9kaG9xdWR4Y3R6MFF4clhNN2h6d0p5bEtpbWV2S3Vx?=
 =?utf-8?B?eHViWHQ4aVoxOFFsQmxyM2cwVFA2RGNqaGVibjc0S290eUZLSExGcThKZ1lh?=
 =?utf-8?B?YnNzZ2hWakQ1OVlCR2RTcmxuRXpkWWgwNlhISUxDcm5ERmNKZ2tBdHEvN0RV?=
 =?utf-8?B?eVZpdG9teURoSmI1YUd6SEdyU0ZXWUZTM2NrOEpHQnFLUnljNzRkcDhMeTcz?=
 =?utf-8?B?SDZQNk8yRHIydHhpUEZrOXRXZTVMMUJYOTVkcW9Jby9LeFUxOHJ6cnBkUWR0?=
 =?utf-8?B?TzdaWk5KTFM3bzRBMGhUeUNZZHFGdXpvQ256MUpXaW44RUtnSjdWbzYxeVBH?=
 =?utf-8?B?VXBIQnBUTy90WWVUWklzc2lmcVdtQVdCUkNSeC9EMStaSi9SQjI4UXZCVGZP?=
 =?utf-8?B?MkpQZ1c4SFV1UEM2a3B0S21YWFE0ckxMb0dTNVJSQlpzZGNpUXlYRkVJSWVy?=
 =?utf-8?B?bFBmUmpOR1QvZDNpbTBPUHpMMmtDSFd1NWREbk9QQkFjbnRSYmpINGdIQmxL?=
 =?utf-8?B?Z0t4V3RiQVNuUGs1aGFTRWtKUVlXakt4VUVacVlwZ2JPM25LVjdwMTlmbUlx?=
 =?utf-8?B?WE9ybWRIeHFERVFlSHA5UXpvQ1VONTZPZ1kyTWwrblZWdzRWMkVlT0owUlNL?=
 =?utf-8?B?Ui8vc1BBOEgyeWQzRnZsc3VXaUpiNlpHaGtWVzlFUVhQeXBEb1lUWnpTcXRP?=
 =?utf-8?B?bEN0Wk5kdTE3TzUyMDExVi94U0pYZldiOFUydDIxUHpJRElNVXpqZGE0UllO?=
 =?utf-8?B?eml2aEFlNWh6aTN6aGI1eFVrK3h6cGtlaE51dFBvMFI5cnNLc2JLVUEvUytn?=
 =?utf-8?B?eVhZaXF6Tnp0SDhBcEhuUVA4aUVweGptSktESHAvQzdJekZvVnROdmVTczNV?=
 =?utf-8?B?cFE0VlppWmgrSXFQN0pZTmg2TjdGNE0xQnJ1NC9kM3N1bkhFNEllV2hvN3ky?=
 =?utf-8?B?SE00dXp3R09vSnpDMG90dTNMWmJJdzZaYytBcU1YZmo5TnplMk9kNkNTNWhL?=
 =?utf-8?B?cVZ1NVd4WGJjK2JiekRaa1ZjbHJSUXRIK3VmYTFzeWM3T0xVR1duR1FkRk9v?=
 =?utf-8?B?bzRHK1Fhbmd2R0hySmN3T2hOdzB4YnQwTzdXaW1UTjBJR2M5djhqenV5RGhy?=
 =?utf-8?B?eE9ZR0kxWXBNaUFFQlBqZlU2ZnVyUkVHNkhmblBqR05YbDQ3YkduMlhDNGZn?=
 =?utf-8?B?Zkp6bEJRYW94dmpCVVVzSWJVWUl6QVA4ZUU1VUF5b3hsVWlCWldBaVBVOXdq?=
 =?utf-8?B?VVlmTWlMWklNWXdnMUJFK3hSd1VzL21ubVFuT1ZaaXplNzNaKzI2M3NIM3Bx?=
 =?utf-8?B?WGphd0tRMVRzRFZOeUhFRnZjZktYb0NlcS9KajQrQkFnbXE2QUFISnEvZTg3?=
 =?utf-8?B?MG1OdllKUlYrbzVnUlhvNkFib0I4bmdSZkV3VzRYNHpEelkxUHNOMnJ6ZzE2?=
 =?utf-8?B?WHZUalNpNG40Ymx6bGltbVE2Y0VJRVdPMGkyTVN3Y2IvaXpSREZCc25lemJT?=
 =?utf-8?B?c25QQnV4dEtIY1BXWE02YnF3bEF1bWU2bEpZY1dqOE0vemRXRGtRd2J4UUl2?=
 =?utf-8?B?NkdmRCs2UmhVL2ZUeVI0NC8zSFBrR2wxMWlEMSsySnR6WVdZMGUzWnVtUzk5?=
 =?utf-8?B?NFJmb0VpSEs2TG1YNmh6R1dubEdkNTc0dzh2RS82NEF2a1F4RElkOW5kT1Ix?=
 =?utf-8?B?RlJtdXdrUkIyQS9hTzFlZXdWRzI1MkZzL0FTeUllWmxFTVIraTJiTGNQTnhZ?=
 =?utf-8?B?b2xyRkZkd21TU3BpZHRRUUI2VVNqcnQvR3RjNk1BSFl0ejRrVDV3YnBUbXNR?=
 =?utf-8?B?L01yV0V4NzFQVDJPWno3cnJUNVZ6VlZmSjVEMFljZ0pFYnlDcG8wSm1hYmRs?=
 =?utf-8?B?b04zRFZBR21GTEszWDRod1JObzZxc2EvajJnQXVYSzZDOXMyUVlxYlpMNTJ6?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d86efe7-eed6-4952-13b6-08de23055cea
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:38:27.6343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9q59SJMqtegSX4moPLZV0+6tb5JmFORGnXfppt4TsZgyStIlkqFeCtb8OH0ujr9D6+YyjExqXRGFx6Zq+nWTkbqVwfR0BfB/5/7RFsE1iQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8265
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> The Intel Clearwater Forest CPU supports two RMID-based PMT feature
> groups documented in the xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml and

It makes the series easier to read when it uses consistent terms throughout and
avoids needing to keep redefining things. With "feature type" defined in previous patch
I think "PMT feature group" can be replaced with "feature type" and then the second
and third paragraph can be dropped?

To help keep things consistent this could be something like below that also gives
users a link that works since, for example, appending the provided
"xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml" to provided
https://github.com/intel/Intel-PMT results in a "Not Found".

	The telemetry event aggregators of the Intel Clearwater Forest CPU
	support two RMID-based feature types: "energy" with guid 0x26696143 [1], and
	"perf" with guid 0x26557651 [2].

	Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml # [1]
	Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml # [2]

> xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml files in the Intel PMT GIT repository
> [1].

Taking a step back there seems to be an ordering issue since the previous patch
already uses the two guid "introduced" here. 

> 
> The struct pmt_feature_group provided by the INTEL_PMT_TELEMETRY driver lists the
> guid and other information for each aggregator of a given type (energy or perf)
> present on the system.
> 
> resctrl has a condensed form of the XML description in struct
> event_group. An event group is enabled if the pfg field points
> to a struct pmt_feature_group.

Above two paragraphs can be dropped. (They anyway were just pasted in without maintaining style nor
connection with rest of changelog.)

> 
> The counter offsets in MMIO space are arranged in groups for each RMID.

(to remind reader the context)
"The counter offsets in MMIO space" -> "The event counter offsets in an aggregator's MMIO space"

> 
> E.g the "energy" counters for guid 0x26696143 are arranged like this:
> 
>         MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
>         MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
>         MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
>         MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
>         ...
>         MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
>         MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY
> 
> After all counters there are three status registers that provide
> indications of how many times an aggregator was unable to process
> event counts, the time stamp for the most recent loss of data, and
> the time stamp of the most recent successful update.
> 
> 	MMIO offset:0x2400 AGG_DATA_LOSS_COUNT
> 	MMIO offset:0x2408 AGG_DATA_LOSS_TIMESTAMP
> 	MMIO offset:0x2410 LAST_UPDATE_TIMESTAMP
> 
> Define these events in the file system code and add the events

(to be specific about which events)

"these events" -> "the events tracked by the aggregators"?

> to the event_group structures.
> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT # [1]
> ---

I think it will be more appropriate if the event groups initialized here,
for example "static struct event_group energy_0x26696143", are defined
as part of this patch also.

Reinette
