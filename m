Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0913A8759
	for <patches@lists.linux.dev>; Thu, 13 Aug 2026 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786665364; cv=fail; b=NX80RWPK7SLpjxRS+6Ug6VGsJeaAbmE7W4fumEPAw1PEBqjT/34zqV3KORbc2gKUCd+5labsetCZ5yShG6B5sDAX8WvT4RTib16rWZu9slfITvUvIUXiAkrjbZ7o9UUFf+HDtTyzOqtVtpOQRp7iU4ES7cyk8O2veQy9n5zaBCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786665364; c=relaxed/simple;
	bh=Qp0l/sJ0R9KlxblxKyoMvC523Dg5Gh/Q2/Do0qOmnW0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RhV+jSEZpH9wuc+ILhhJf2LpxqIdJ8hqGHoPwM4vAf2fYagV5HB4yTH5RwbFARoTNcFX67fk0+o3iY/suFq+YD2NB2w/6/7LTioWyISCsPvBs+D0X90raJ/YIzMmKc6wD3uiMZD9V3giU1jpTeMqUEttudgQICCPz6IGudkZWoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AdQXfssn; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AdQXfssn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786665362; x=1818201362;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qp0l/sJ0R9KlxblxKyoMvC523Dg5Gh/Q2/Do0qOmnW0=;
  b=AdQXfssnL0R1r5WpGlnaHl74Ds+Fwjy8xkQajD684n6aZ3QN+5Ft0gqo
   zJrO2AOWuXdF1Icv+xyxbSzbk0NfNRv5woXtMZbiZt6W0R8zKdfOIF2JE
   SVLfsUKhfYdp7REKbtsTFcoSB96vKKH3Tyx1XYOGl+Ux+YfdCsIqoydQ/
   gRwatpZdh/eNeuO3sF8Tt2LFqSEvaV53EQztxlitLJfOipcv9dm/jZayI
   QpnHa08eCpw9ku0SzHHY9mJvp9Q7pGYLidO5n2+tuPvKsWcrNj8w/JBys
   k9EEugcT884+9txjqa6KLWe7CBLJ7qh5K8x69QMIx5+LmgYj/2WnOTYDJ
   Q==;
X-CSE-ConnectionGUID: W6CTWlofTxO0HWnuieaIAg==
X-CSE-MsgGUID: JRtpxYUDSXKwpPRzWPPmuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="97839179"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="97839179"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 16:56:02 -0700
X-CSE-ConnectionGUID: nEACXGpATUqBwpCIdcW3Iw==
X-CSE-MsgGUID: GEu/GFf/TyugF8DLFnMXOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="261431971"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 16:56:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 16:56:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 13 Aug 2026 16:56:00 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.60) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 16:56:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XcNsBK7niUUgRBNXdqhswbt2p+ZtXymIK362aKfUNqtJv9NybLEf1eMdnS5V3/4fJn96VU+4xUEfD/coyotHS8ztjgXATIQGPtLUzr9v4QVQ9m5Yv+lMNMIw7TCKb1DkozL9Z5EJww7AquV37AOP7czUrj8tm9NDnZImwl3RRJvQ0HqMXm2LdGxn0edNX6i025GcsCh3APxW6ypy3j+sxfq7LFPfAPD9/ZSbEbDJfggdf6saVjpN8GifHbnQaKQ76XJi4TmzikyGswgGPCJntqAfEPE/s+ofrXGTBQ1R+ktVDtiNSd0eyO2ow+zX6WcIYUD4TqpwbyMXsllmx9L3wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/x15Elj7GlIynl3o5kfVqQq5yJlg0edWKbMv+gh53to=;
 b=TSLMtQe4HLmbuci4IxnZimn1PwZ5i7WuYEw92QrUEQKrLQAmM66AtI09BbxNcrMDGI3U1/RBu85s8llRamVaiRcJPb5N9p0eUsO7jtolDoqbtRK20q3E+Ldfa9cLyIpNH70trxKd0lwKwDMy5IG7T6AFo1gjUkMOuKYDUKZbDPgJUp7ZnW5bSRBtzLgPQBMta75ihJQvRShF4c1CdeTOAckQ1u+5KNjKbNQotiNlj8LmPckAu/GvG1QbMUiWnc0zJDh5ifsvzpioOOIWIldaWSNanuRI1D1RYqIExWNccUTa5nK9AgPrElcN2jCBwOCn2MTnIjUKfQqcGgC4r4Uf3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB7037.namprd11.prod.outlook.com (2603:10b6:806:2ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Thu, 13 Aug
 2026 23:55:55 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 23:55:55 +0000
Message-ID: <f06e6b33-4d31-4174-80ab-8ebc51132fa4@intel.com>
Date: Thu, 13 Aug 2026 16:55:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/17] x86/resctrl: Fix enumeration of number of
 supported RMIDs
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260729172752.11561-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0364.namprd04.prod.outlook.com
 (2603:10b6:303:81::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB7037:EE_
X-MS-Office365-Filtering-Correlation-Id: 764b65f2-9e12-469c-f885-08def99669f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|11063799006|4143699003|56012099006|10067099003|3023799007|6133799003|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: BdfdaEIZEq4OL5E16dj/Cbs56/vycsk7Yw8G0d63K/dls7OGvejFmye/YcBfsaUrsWk0ZkDpBx/YhB2gOxMAJBnd6EDexyEKzRZ4YSZrSd2AiwKHWbgHeP8o3IA7UkiYZTeA8N81u9xs5r80UYg3R/oNCgYS7c9skIhXOIXiY5Rg+aUA46hkNq+VhNGPI0Csqy2n9CEiyI5Am9hfZO/Eld4dqZDYQc9waYKbGxwQfCXVFjjtyVaWiY36/KfAe80FQ25fRlUrjhuZ9Vi0bQ5q4z22BY0IWVq/GZFWpnk8SiOFr3eb1xar/hGL4JpOLRaJQppdw2/WwMUQh27uXNpgoXX8P2GaUk67SspRSQNOK7OrAcddFg8sSWgpmWy8YmLyXO8XFY2FbVBHdJR1El8tNxTIBTSTmoDvnMBNLRiNTjLiDnx1UJfw1vi9PVaSGp1xcJLqN1bljV+8z5sbW2bRwsIGj9M2Eb3H+drtex2C0sOn4q6jl7LtvmQdAcV7hWi52PfNMPMRlciN7YkQkx/Cdig60hcwB6WdtihpC5YFiWKcT1dkTKWwqQoLNVOU0mq5L8JWQFxhVIgM3mtsskuUx8UObw2/LkkkeK4E9BJvapmU70vLlkhb1ap18Tiv8d0iGlCdEKv6gqGbCEcgs3AHd9V+hrVp+i3d8c9fHwkXWfqyNuyvPXpYH5zEV8bSpJ8dBGgyTnbghNozn5XwYPuRaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(11063799006)(4143699003)(56012099006)(10067099003)(3023799007)(6133799003)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnFkc1ZXRHJjYm1IT2o4NFVqRzk3OVcwWjRtZFlyam5RdE00WWw1cUd4QXkv?=
 =?utf-8?B?YUNRVnMzekJRVXc4b1UxU0h3ekh5NUpLR2lJN3lpWmZsYjlwMmJOMU13NDdt?=
 =?utf-8?B?Q0lYSGlyZnVSZjBlaTBtTnppa0xQdGZOYytKS2JlOTZ2SHNGcVFodFhSMVdZ?=
 =?utf-8?B?Vjg3U0l0K2RVdEowSDM1bEtmK1NqdEo2Y016Zk1sRHJzaGRZMVZOVzRaRjhH?=
 =?utf-8?B?UEZvdEV6cGtmZ04yUlU1dHVQck53aGF0ekZLVGlFbTQxc29OL0FFenQ1b2Fv?=
 =?utf-8?B?c2hhTiszTHJWWWhNVEtZcWhwY05Ub2doWUdPc0pSVldiRjhMQWhUekc0ZHZq?=
 =?utf-8?B?L0trc2w2TnFTUzlDTGZyb2tGWmV1OHhIYXNWcW9vcTZmVHY2Y0x5NHUxd1M2?=
 =?utf-8?B?N01FY3lEQXNYenl2RnJNbE43aWFraUxhZUovWVF6b1p1K2hKelF1ZHdkaXQ4?=
 =?utf-8?B?NkFGZ3hFejZLRElCdkdiOGxRT1ptREdQcFdUNm11UFNsbDFTUHZtVjhpVit3?=
 =?utf-8?B?eENYOTNHdWhkMXlLQjI5dDg2RnBWUHFSYSs1bXlMWXovRFRWUE9FVlVHT3c5?=
 =?utf-8?B?dHRVajdGMGdmcFVKeDMwYlRRbVZKdmdmM3UyTTJrTzNqaU41YVdWVWE2cTh6?=
 =?utf-8?B?aGYvbGdTQkcxVHo5azdlc2d4QUhWTDEzdkVtekUrT0lJZ09jSGhTVVgwaU4w?=
 =?utf-8?B?bEU3UnZKMWVGQVVkNzRMVWNZOHE0VEgreWxwTjlQNk9ZME5UMlJlc29SNHph?=
 =?utf-8?B?UGVBcDBWQWlyQUpaN0JVY0JhZ0VxUDdyTmREbzdmWE9qUGpyb2N3aHBXRmFO?=
 =?utf-8?B?emZYbEVMa0p4bExaVSt4L09NQytwcmdTQVE4SDRJT3dYVjR3bEJjNDhaZVFE?=
 =?utf-8?B?cDk1TTRiRVZISjc0Zm5DOHppTmE2R3VVbjZzSUpTNm9RYlRaOFdjenRVaTFM?=
 =?utf-8?B?UTZ3M0ppZjhKQXkxbDdwcFErL3gzb1ovSzJrOUl0S2c4LzY4ZU9UZkJlNUZV?=
 =?utf-8?B?R0RIV1BPT1NpNWZ4TmZQV0VXYzFGWVp2SUpJbWlkdVFGMW5LdFNwSURyNXVW?=
 =?utf-8?B?aUJQaE1oMmI0ZE9ZK0l1b2c1TG9EUnhkUWxBMzNBT1BSbHJnQkpab0lRb1RR?=
 =?utf-8?B?dWxlM2srRnBwTThZbTl4UExUQ29iK3d4M0g0aWp4NVVnejZBTWhHekk3YUtJ?=
 =?utf-8?B?RW85d1NKMUF2S2p5K2d6YnlTUVZRbWVzZlBxVWVTMXF1SUw3SURTb09SNlhj?=
 =?utf-8?B?NnVRN0dGS3hXV2F6d1JsN2w1cE9OMnNKRmZPRW9HaEppNU1haW1PMGZ2enZx?=
 =?utf-8?B?dVJaSTB0dlNZNTc2S294WDVUVkp4ZEs1NkhvditHRE02WDhZc0JxTElOZmZE?=
 =?utf-8?B?blNaUFV2bmZDZ3Ywb1d3R1dhdFNMT3pOcGhzS1NCYlNFOWkyNU1HWDIyZ1Vj?=
 =?utf-8?B?OXhaV0pkZGt2RkpJTUpnbXQxakRmS3pWUGppS1k3RmRHNytsbTNtVExwQndx?=
 =?utf-8?B?NHJJUXp2NzdjV1M1R0YvcUtSK0E2T3Y1NThtOWRCa2x2Zm1GbFQ4VndHYVhi?=
 =?utf-8?B?MUJxZGo3bEtLcGpHWktUa2JaSitlUEw2eENDSXlxQXZmQW1nY2dEWHc1cUpO?=
 =?utf-8?B?LytmYjdHY01kY2tJOWZJcHlBejhpWFN3WFRPZUR0NTY5d2xVMTJESDQrRlFl?=
 =?utf-8?B?dDZ2UndiUHJBZHZUOUpvZ201MXBhMUErYkNPdWNJUU1laEJEU3BMRHh5MWIw?=
 =?utf-8?B?bGJva0tvR2dYaGV3UEtCbVNOTDYrWUdVa25nTi9HUW52SWZZQnZHa2lKZVdU?=
 =?utf-8?B?K2lGWmw0cktsSkZDWlNoQ0tTYkdQTHFqNWFJL1NYcmxYcHBYa0xjMHZ2enkv?=
 =?utf-8?B?RFF6OWs2R1JwVHRJWi9PNW5xTk42dDhjdXlkWVFjZFJESVhHZ0U5L2t3eTJT?=
 =?utf-8?B?T1F4alRSdUU2cnh3YU0vQlNISXdKdnNFNk9rUmF3Sng0eUZGSHlNY0h3QUxj?=
 =?utf-8?B?dm1HdTRBWG8rMzRTRVg1RUMwQ3U2eWxOZDdINXpDZlNpWU9xem9CVUNRd1hN?=
 =?utf-8?B?dmk3Ujh1cVdock13MFdEYy8xdWk2dFpzMllpWnlFTmtZbERFS0FNZnZEVmRO?=
 =?utf-8?B?SUlaYVNicEVWbncrV0p6R0FQYklsSHZyZmxSNDJTbW5UMDNlUDVTbS9zckNr?=
 =?utf-8?B?OXNtenowNVByWDBnRGY0NkxqN0ZBMGxicHJGeU43ZFVINXhVcURybGtOaXk1?=
 =?utf-8?B?bmF2RURJaHRZcVc4VlVTdFZjTENNZ2l3UXR5T0Z3ODQrNzcrZXI3ZDBJbmg2?=
 =?utf-8?B?VWhVSzg0aUlaSmJHOFRlU0JDS1EzV1hmQUo3U2Y4ZiswUnQybUZoV3VqYVJP?=
 =?utf-8?Q?6psi/UFW2pHBIbvY=3D?=
X-Exchange-RoutingPolicyChecked: X2JXe9phpkdpBN+lYW6Hli3nfBzYsdKIN49oTwjD1+KsCvHYC/iOD/9B2rEWppP2UCWNkO/Tgc73YQklwf70iRH5uA9F64bxnLmiM68iY51KHWE+FlCT/ZUo34z0ofz4YjsfIAa9a561VZEKH9bItVkIl2OUZsWmrL3qbFyGcx8QFjc4YYaLi8gmEgZ1K8lmQB0LUVnA5/GmnSV7tmwQBQAspgrzuA3/OaH76qxUwZ+fFLRIcW8Zi/DCS5R0zdd3Wj+djj3boP4AA4UUH+O8tBIJCHzwUA9kUwYJ9KZVmCpMidQ6gMIF4U0zQT5YyCQeLZY2oeRwSsb6CSPF849Z/A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 764b65f2-9e12-469c-f885-08def99669f2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 23:55:55.3387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6J5hE8K+wIkd7G0Nm1FjfDMJEL3Szr5MTjVThrT73kwvM9NcPNAibzUmQHCas8ZlQb7h7+VJekvaBpn/IaDHbSjofijS4/RBkg4EcKa3DjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7037
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> There is a multi-step decision tree for enumeration on X86 of Intel Resource
> Director Technology (RDT) also known as AMD Platform Quality of Service (PQOS)
> 
> First check CPUID(0x7,0x0).EBX{12} (Linux feature flag X86_FEATURE_CQM).
> If this is "0" no monitoring features are supported. If it is "1" then
> monitoring is supported, the IA32_PQR_ASSOC MSR exists, and the RMID field can
> be written with values from zero to the value enumerated in CPUID(0xF,0x0).EBX.
> 
> Second check CPUID(0xF,0x0).EDX{1} (Linux feature flag X86_FEATURE_CQM_LLC).
> If this is "1" then one or more L3 cache monitoring features exist and
> further enumeration from CPUID(0xF,0x1) provides information about L3
> monitoring features.
> 
> Linux skips the check for X86_FEATURE_CQM and begins with step two checking
> X86_FEATURE_CQM_LLC.
> 
> This is a problem for systems that do not support any L3 monitoring features
> (or have disabled them with the kernel boot parameter "clearcpuid=cqm_llc")
> but do support other features such as Application Energy Telemetry. On
> such a system cpuinfo_x86::x86_cache_max_rmid is incorrectly set to "-1".
> 
> Correct the checks to follow guidance from the Intel Software
> Developer's manual and AMD Architecture Programmer's Manual.
> 
> Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 9b9495174041..e3544c99cff1 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -1075,20 +1075,17 @@ static enum cpuhp_state rdt_online;
>  /* Runs once on the BSP during boot. */
>  void resctrl_cpu_detect(struct cpuinfo_x86 *c)
>  {
> -	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
> +	if (!cpu_has(c, X86_FEATURE_CQM)) {
>  		c->x86_cache_max_rmid  = -1;
>  		c->x86_cache_occ_scale = -1;
>  		c->x86_cache_mbm_width_offset = -1;
>  		return;
>  	}
>  
> -	/* will be overridden if occupancy monitoring exists */
> +	/* May be overridden if L3 monitoring exists and supports fewer RMIDs. */
>  	c->x86_cache_max_rmid = cpuid_ebx(0xf);

There seems to be a lot of history behind this code that I am not familiar with making
a couple of things unclear:
- Why is resctrl_cpu_detect() needed? I do not see why this early initialization
  is required since the only consumer of the data initialized here is called
  from resctrl_arch_late_init() and it could just obtain this data itself? 
  At this time the enumeration of RDT/PQoS features appear scattered between this
  and get_rdt_resources(), the latter already running CPUID itself when needed making
  this early initialization scattered in all the "BSP init code" seem unnecessary? (*)
- Why does cpuinfo_x86::x86_cache_max_rmid, cpuinfo_x86::x86_cache_occ_scale, and
  cpuinfo_x86::x86_cache_mbm_width_offset exist? Only x86 resctrl uses this data
  and making it global seem unnecessary?

(*) The one problem with this seems to be intel_rdt_mbm_apply_quirk() that uses
the data initialized by resctrl_cpu_detect(), but that just seems to be for convenience
and it is still just called from resctrl_arch_late_init().

What above inquiry boils down to is that I do not believe that this change addresses the
issue that the patch aims to solve. 
step 1 (above). c->x86_cache_max_rmid is initialized to maximum RMID that PQR_ASSOC MSR
                 supports (sidenote: c->x86_pqr_assoc_max_rmid may be a more appropriate
                 name considering the expanded usage)
step 2 (below). c->x86_cache_max_rmid is initialized to what L3 monitoring, if present, supports.
		Ignoring for a moment that this just blindly assumes that the value will be smaller
                or equal to the value set in step 1, it does not take into account whether
                L3 monitoring may have been disabled on user request or because of resctrl
                quirk. 
                The comment above states:
                /* May be overridden if L3 monitoring exists and supports fewer RMIDs. */
                If L3 monitoring is disabled on command line or via a quirk then this will result
                in fewer RMID available to AET than what the system can support in PQR_ASSOC, no?

It looks to me that moving monitoring enumeration done in resctrl_cpu_detect() into resctrl proper
where the RMID range checks can be centralized on features gated by rdt_cpu_has() would be simpler and
accurate?
  
> -	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
> -	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
> -	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL) ||
> -	    cpu_has(c, X86_FEATURE_ABMC)) {
> +	if (cpu_has(c, X86_FEATURE_CQM_LLC) || cpu_has(c, X86_FEATURE_ABMC)) {
>  		u32 eax, ebx, ecx, edx;
>  
>  		/* QoS sub-leaf, EAX=0Fh, ECX=1 */

Reinette
