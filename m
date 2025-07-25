Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E725A2C2
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486797; cv=fail; b=ap2BeLUiDirhuHjQBoMBa4PDGTnLGCpnxRfWnGv1qDkEMFvwYYOtWsqE5JVW5TgF6stkenlFuAGhtbBjPUvmWfVzvyBfgWzJjE+dgS8x4gu58381gzsua9Zw3Gsf5K+EEsPoKkv0RRQHGcMFwl2ugLzgqcQKMgKz0yZeC7YyxbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486797; c=relaxed/simple;
	bh=gFHgP1VbjoVD+ZRaSG4LakehC9Eytj0JDIk6L1eLfAE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UKO7afrnKBHMPgN2uZwtIyxEbl03C5Uw5k4VeWCB+Xawp9BJfCfMgSfsgbcXSlp0sjz7ad+2z6v68HbWW1xdi26IkqmnEu1MSlBNWlr5CRoh0rZgNzfgioUxwa2pgz3eBV6GKb+o8RyvJbeXwP8zTjYSMgjG7CKK4LQUanerYGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A6CMLkUe; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A6CMLkUe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486796; x=1785022796;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gFHgP1VbjoVD+ZRaSG4LakehC9Eytj0JDIk6L1eLfAE=;
  b=A6CMLkUex4pw9F6l2q75tlYGyh+I3WNL/rxMRp794s7ln8kgwNwskDeR
   9tImH8HUPBvgxVgGNieip0FT7Ihdx8UgCns5h506aW8ykGcPmCRjSO/pr
   1DS1kBDIzk1FH3oa28j6OEVmZE1FNzQVRjcs7kavSInXlMhQ+6WzhN3Er
   vb6klFKP1UkabqJfMEMWulqOLOM/N28sMYKkot5/caqQH/9L/Xid4DhdB
   JhcWVV3siiofBmMzoFCgp2q9LdXKp66lS3iWWZJi67IToRtXIFRDGbUFz
   H1g3+uKXzfgk9TDj8G3sAdliuk4yr54gtt73FKVZQxnTPfF4f9dcyiuWI
   w==;
X-CSE-ConnectionGUID: GlDQsxqTRlGEGbtkD/+ehw==
X-CSE-MsgGUID: kHKEzVh8TFa2y6mVEh3P2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="59648265"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="59648265"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:39:47 -0700
X-CSE-ConnectionGUID: 6ucGEaGnQZaA9SoLaJd9Zw==
X-CSE-MsgGUID: AyY8x5/uRe6/aiIJYtQaAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160520246"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:39:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:39:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:39:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.46)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:39:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gNylWopbewfJQNSlPJnfecuZMp1K78TZMHbQ5Q9j+o4LRxZVohNfIYL28emAi51XD7buf4zH7v0yUYMIL5AxUE0qu1pT0x4YyiCt04eZOQrUdCOqoTPSG9JpU2uQ33x/FjFvz5DGNf9+AVrrWiLBAFcOlrXNHxadEfoy3bHkQjwKQsL27ycyPMpcqLB2XYzwTgBvfpl3EXbOSK+bwDhdtRlAi/Zj455XibQG8ZbE3lpnpg4ppeiQggqCXWd+ygqN0cnS/nvsNFHrbneBp55Fr7MHXhgVQWOxv+siQ+oT+8X6LG7XCCor209JafJxXz+8mpEU8jeAZxvk5/16i99n6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzGM3aEbng6/KTdWNNZeUF/I9P0S46EGJzCtLr+ojPk=;
 b=ogpGDl8R97i1kmhYYt7SzfgQZCLHe482w9nLmDSFr5/u4B03kOib8u3DHD2EChfd+k8XvVbnja+B1Rt4hqXPKZEun737PASGbFEGcwFgkIG7qUYpIx5c1P2acXUb/27Qhgstq2N+f3EbyCN88klQkcX3EHJeWTzoNZeqgZ371dKT5X7GZMqfBpe98EC0E5O7+yJYArQnzWljhsGVEOAd6nJqw/IwjP9sbIWlezXb09geDNc8buAtpfFSj4At14iLTNc+TJ1UB6wze9TIXhXUOAiSlZdKSnUT+3uRagIw5RRpjNjNjC5ITsWUxGFAihPp95lWty+YZxT42QhvpMNpJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 23:39:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:39:21 +0000
Message-ID: <d9d355fc-cba9-4d6f-9b98-1cbdfdeb58f7@intel.com>
Date: Fri, 25 Jul 2025 16:39:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 17/31] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-18-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:303:8e::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f808a8e-2a38-491b-55ef-08ddcbd47af4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TGp4VjdFQ1pWKyticEp2R2pGUUpDU2NMTFZxeHpzZWozTk9qS0JvSzJ1ek1E?=
 =?utf-8?B?blVRMXAvOUVJVWsxWStqenVJRUovZjRTRzVKQkUrZWhRZXJlTGNXWHl1RS82?=
 =?utf-8?B?UlBQT3lpQ0grc2paSk9qVTVxbXFicEJXN1N2NjRFWE9yMmlNTnpldkVlQ1NS?=
 =?utf-8?B?c1R2SzZTWmI3U3lCQUVKWVlWUmRzVjVJM2plVDM4bWQ2MFd4UlY3bDI1cGRV?=
 =?utf-8?B?ME45b3RaRzJWWFZDVlVuTlJoWVBvNFM3YW9LbjhzaHc1SmNXZlppMVY2YXVu?=
 =?utf-8?B?SXJkSGNjYWRJK3ZHMlA5RWxuMFBBeWhnTXNoaGt2TnBvd0VOR2QzM0lyQWZU?=
 =?utf-8?B?a3R6bytSc0RPZUw5THJFd1V3bkg1aXNlMHlvSnhGWWJ2RnRIZE9ieWlvY1NM?=
 =?utf-8?B?YkEvVGhzTitnLzNBa3NtSXlaME9hSGp6bi94dlZua1VoTDI2a01TRVF0SlFa?=
 =?utf-8?B?WUxLRnJZczJVYkQwWUE0OEhGeG5XRlJIZkloVmJPeEtoN3J1SnlleXZVbGxS?=
 =?utf-8?B?R0xpQzNQUVl5V093N3N3aEVtVk1pc0Rva0crdEZlR2JyTzBSV0EzV2ZReXVn?=
 =?utf-8?B?MFdtUGNCQysrR0hmUHJ6aTdvVnpCeGZmdUVUUlE5cm04YjBsM0U1em9hZkN1?=
 =?utf-8?B?Tm9sZHFoQUJqZVdYa04yU0x2MEVjZEppM3orK1NHUXp4OE9uUW8weDhPOG1U?=
 =?utf-8?B?d3ErYXUxTFFGZk1SNnBhYm01b2ZENE1NeFl0Mm1mMzg1aDltY1lIS0pKZFlI?=
 =?utf-8?B?aG1wNGtBcjAvZ0JuQWV1Z3NlUU52SFR4ZXNXR1BOcERPMG1zQ3RjS0dCeTFa?=
 =?utf-8?B?RjhEcDhqa2N1RFFaZGNKNC9BaFkzNmRtSzdzUEcxa0I1YWZ3V0EyNEREN29Z?=
 =?utf-8?B?OVBqQ3VXMDBrSHpwUlc0YUk4VWZmcUZuWUNibm45YitjKzZXcnN3YzJOU0xI?=
 =?utf-8?B?VmlZSjUwaUhVdEpRMFh1K0x1bHBUblo4RS83Q0VXNWZxMHVLSHdkNVF5NVM0?=
 =?utf-8?B?c09nTGhxcWU0U3NJOERFd0FRL3hPZXlvNktoVXlBcUxyaHZmK3FEczBHN3NR?=
 =?utf-8?B?cVhmS2N5NFNxNG4ydlZraW5YbjdoWjcvRHlUeW94dzJRdUYwayt5UzNvWW03?=
 =?utf-8?B?MEZMS0tHYldqTUxrMm9Rb0ZIWGlzejAxZlFVZmN3Y1BtSHl0RGFXOFZmaXB2?=
 =?utf-8?B?WXNndHlvbXJEd2FQNFpNVm5TY2llc1U0UEViczU0S0JpR0k1M1Z6ZWRBRzRW?=
 =?utf-8?B?WXoraGhjVGFLWnRxK1l5aG8zOFkxRzNhbEZaLzh5dmo3cjVEcWRObkFOUHZG?=
 =?utf-8?B?TDlVRHN4RmIvc3drbzA3TGRIdUh0OW5WdW1CbzNvRjY5RWM5NktiRWZWdjBk?=
 =?utf-8?B?SnNSd3ZGYmNncUFWTHg0emFYaEhRVnVWNWZzd0g5ckx5S0dWSk9KTU4xWVky?=
 =?utf-8?B?eTNkdlpod3NQZjFQN2c2VFdaek5oMys4SVpCMVpOcnUyT1UxVmJZcUdTZlZ0?=
 =?utf-8?B?UWtKRUthNmNlYm1NN1B1QzVCQ21kOFJQMTkxWVhrRzE0MkJPQVJMVEx6VXQ1?=
 =?utf-8?B?TkhSZGVUbEhDWlkzUWdJWUN0MHQ1RzJ4TWU5NlpCUGtWV0VENkhyRGhnNzd4?=
 =?utf-8?B?ZlA0YjJrdFRFWDZpa1Z6b3pwdHJuczVTNTBLWXNyTzFsd1BQSFBhOSsrT083?=
 =?utf-8?B?TVEzYmF5L2l6MG5VcEMrL2MrOWY0Yzk1ajBINFAxN2RRb0I0bXA5OUs0WjBr?=
 =?utf-8?B?SmR0MW1jNityTG9QalM3Rk9rYkEyOXpLYUVKVHVURXdtQzBia2RCck5GdkRz?=
 =?utf-8?B?QVl3dC9jY3g1UnRxVXFrSlFMMDIvV1UrWTVwWmYwOFcyYW9PbHpMM0tNNDlr?=
 =?utf-8?B?dzNyNlJscThMYjNVa2VCQnp6Z2ZtVlhQUWpMRVAvajlGNkpBeDMwQUdKaE4v?=
 =?utf-8?Q?5Gcr8IFZK2c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHNvMWEyb0o0WDhUdGx3U3lxMnYva0pYa1UzUUtuekh4UUtVdFo0cGVTdXJ2?=
 =?utf-8?B?bmNUM1JtZkVXSnR3OWRNVEJBRk5jN2VKVEJCWDhEVk8wcnVSaFl4enMyV04v?=
 =?utf-8?B?b2N4RnBTbDg0YkdoTTQzL0RxMDJyNHRoaVRFMC9TdGZYakdYWkVnUjhJMGZy?=
 =?utf-8?B?S0hlaUdVMm5EcXlzdHZxZ012L1NVcFVxeHhacFlJdzJqS2JZcDhYd0t3WG8r?=
 =?utf-8?B?R3NzZ3JxZE1TS0pCRUY2Qm9IS0c5eWFaSTVlZEsyVWlscDhCR1pDbDd0Y2hr?=
 =?utf-8?B?WFB2My9YQTNtQ1VyUU5xa2pCSTFDcHpsVFhiRU9WWlZMbmlEMHgxMExrMXV2?=
 =?utf-8?B?eHpzWlJzeW1QVWJxUU42YVlqT1hmVkFiT1o0dU5qK2RaMU5uVnU5UGNZS1dQ?=
 =?utf-8?B?cHFZOXlSaWt2ZFdvVGl1ZVVpSi94WG5uaXNVYWlhQlZsUHRWYWFtVGIrdGts?=
 =?utf-8?B?dGpSaCtjTER0UFFoeG9yUzN4QlRwRmttUVA1UGR6T3BFb244OGNtOWJHWmEr?=
 =?utf-8?B?NlNwTGhrd1dtVDkxUkVnbkVxTFByTmtjYWRQRVlnTGJ3MWpaNUd6Mnk3UVhF?=
 =?utf-8?B?a0F4RHNCM084THM2RGpJUXJtWTZQWmF3cXp6bTRmcVd2TnNlUTIxM3hIVDZT?=
 =?utf-8?B?VUMvMlg2OVErVENMMGovQ05ZSEtQbHU3aVdyd1dNcEp1UUJQdFlDQmh6ekNk?=
 =?utf-8?B?bS8veThoUjByOWcwbi84cDA4emZQVkFNY2dnbjdtR05hS1loc3l0RGRZTTNh?=
 =?utf-8?B?TnhPb0lpRm1XVU5teklzb1l1OGFNN2RMdDQyem1BNVN1UG5wS3hpMFVJWmp4?=
 =?utf-8?B?ZWJhMXU5MUFqZndwSThGRnM5bk13WUd2SFFzYk0wWXZjOC8zMzBhYU1URzR5?=
 =?utf-8?B?Rk1tZUtud1RrRzBlYnpxelROK2djSnBtZVpUNTBzUTJtOFo2RTJTeU0zcEkw?=
 =?utf-8?B?R2ZSNlBsZDBySTdoTWIxOWNWV3EyTkl2ekpCZ0hMaEluM0doQ3E3QnZwZGFD?=
 =?utf-8?B?cmRSYWVQOG1NWjl2bGZNQWxDR3NtOXFqS0hqeDZkcXF3N00raUl4ODg2SlA5?=
 =?utf-8?B?UndqNE8wdUxQTjFvSmF3K21JT2lNcmlkMWNZZUZ3ZGFESkdXWHRTRzRvT09E?=
 =?utf-8?B?T21iSDFVQlZaUG42NlIwVHdOWWVjYkRiTEoxVUpxT214MzB3L05CbjN5TE9B?=
 =?utf-8?B?MGdYMkJRZ0dUNHlZK25FellvanRDdTBncFV5c3RyVmVYSUxPYStCdlB2aEtr?=
 =?utf-8?B?OTFLTDkzNlFFNHMxTG9nVTZYZ3g5Zy9zR3l0VGx4eDY0c1NzeE1qRmVKUGsr?=
 =?utf-8?B?aFB3MnhadmFGeEl5UUh1WWZTOTlHaDNTT1ZOZG1EMXhCNTV0azEreFhIZnpC?=
 =?utf-8?B?Sk5YcEpscC93MnVnK1NqUDZpclN0dkIrRHp0RTFzdjZuT0hWWW5FdVdSajh3?=
 =?utf-8?B?MU5lNW1NbVZwVURIOTFXQTc5dWJBK0kvTDhpaktXaXhTM0JJaFJ0RlgyZTlT?=
 =?utf-8?B?Y3ZqOHhQUjNUc2lsa2U1TE1PMXBKcXVLWlkwbVVJNnRhaFJJSlk5R3JrdW9l?=
 =?utf-8?B?NTNaQXFoNDJqMDF6czRkT2F5WXZxOVdRQVMwRjF5MEM2ZytXUFJQMkpCWi9B?=
 =?utf-8?B?RytjZGVsVWF0MEwrYnBla2xCdFlrS1Q0YVRURGZRbUNlRTNweFBFSDZ5MHZC?=
 =?utf-8?B?MlJUdTNadjdZSm9OWmpWdmx5ZWJ2cW1Mcm91SXNZVG5wL21TbURIY1hoUzhG?=
 =?utf-8?B?b3FHQlhuc3N6TGRMMlNta2tKNmxYd1k5cys0MnJiamFXUzE3bDRpOGJZQ2Q0?=
 =?utf-8?B?c0VRbmFpUTBEL0hlVjFtcVM0ZEp1U0VzaGZGUmVoVk5NRHVVdlU1WXRsS3lO?=
 =?utf-8?B?bHgxMTZBOThhSGNBUkJ0L001ek05blU5TVdqSG0yYlJqNm1wb0VHdG5uTDY0?=
 =?utf-8?B?T3k5U2YxWGNIbjJoZjFJZ0podkd5bndvNldKMmZKdGZFWVFGcDJNMzBsbzRq?=
 =?utf-8?B?ZjZ0Z0JxVUFUQmFKM2FMd1MyNTlwd01aNlJRR1hsQm4weFFNVGJUNEF3QjQ5?=
 =?utf-8?B?dGVtTzYrUHA3L1EzU0JPRk1ZcHVoR0pTRzI0VEY2NFVXb28vSG5wN1RNaGls?=
 =?utf-8?B?S3VqdStTQkFyNTZEKy96MGVxcUZvbWYwUVo5a0tnQ3ZsOEtHUzhqV2lYeXQ5?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f808a8e-2a38-491b-55ef-08ddcbd47af4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:39:21.4249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3FuBy5V7VuUKjfEUUTFdpHXMfCjuC5OrwOh4sQL+mVl93ZAsgwNzyNDAu3wiEPrStXGCdkyjnh8gRIHyY1lvfiH5Qu4HWqskQgxiu513Wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Hardware has one or more telemetry event aggregators per package
> for each group of telemetry events. Each aggregator provides access

From what I can tell this is the first mention of "group of telemetry
events" yet reader is assumed to know what it represents.
Where is this concept introduced?

> to event counts in an array of 64-bit values in MMIO space. There
> is a "guid" (in this case a unique 32-bit integer) which refers to
> an XML file published in https://github.com/intel/Intel-PMT
> that provides all the details about each aggregator.
> 
> The XML file provides the following information:
> 1) Which telemetry events are included in the group for this aggregator.

Regarding "in the group for this aggregator" ... does this mean that
each aggregator can have different events from the "group"?

> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for this aggregator.

Does this mean that aggregators belonging to an event group
can have different MMIO sizes? (I expect this ties in with (1))

So, specifically, the "for this aggregator" implies that these properties
can differ between aggregators belonging to the same "event group" so reader
will be looking out for how the code handles this ... but it doesn't (yet
can only be seen in later patches).

> Each aggregator makes event counters available to Linux in
> a region of MMIO memory. Enumeration of these regions is
> done by the INTEL_PMT_DISCOVERY discovery driver.
> 
> Add a new Kconfig option CONFIG_X86_RESCTRL_CPU_INTEL_AET for the

I proposed same namespace prefix before, yet this keeps being different.
Why not just be consistent with exiting CONFIG_X86_CPU_RESCTRL?

> Intel specific parts of telemetry code. This depends on the
> INTEL_PMT_DISCOVERY driver being built-in to the kernel for
> enumeration of telemetry features.

hmmm ... attempting to build with these dependencies met result in:

ld: vmlinux.o: in function `get_pmt_feature':                                                                       
SNIP/linux/arch/x86/kernel/cpu/resctrl/intel_aet.c:292:(.text+0x6f4e9): undefined reference to `intel_pmt_get_regions_by_feature'
ld: vmlinux.o: in function `__free_intel_pmt_put_feature_group':                
SNIP/linux/arch/x86/kernel/cpu/resctrl/intel_aet.c:274:(.text+0x6f708): undefined reference to `intel_pmt_put_feature_group'
ld: vmlinux.o: in function `intel_aet_exit':                                    
SNIP/linux/arch/x86/kernel/cpu/resctrl/intel_aet.c:382:(.exit.text+0x286): undefined reference to `intel_pmt_put_feature_group'

Looks like the dependency should be INTEL_PMT_TELEMETRY instead?

> 
> Call intel_pmt_get_regions_by_feature() for each pmt_feature_id
> that indicates per-RMID telemetry.
> 
> Save the returned pmt_feature_group pointers with guids that are known
> to resctrl for use at run time.
> 
> Those pointers are returned to the INTEL_PMT_DISCOVERY driver at

INTEL_PMT_TELEMETRY?

> resctrl_arch_exit() time.
> 

What follows is not appropriate for the merged changelog and is instead material for
the "maintainer notes" that is below the "---"

> Note that checkpatch complains about the alignment of additional
> lines in the definition of the intel_pmt_put_feature_group
> cleanup helper. I didn't find a way to appease conflicting
> requirements from checkpatch.

This just mentions one checkpatch complaint. Could you please expand this to
mention what the conflicting checkpatch.pl requirements are? 

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
>  arch/x86/kernel/cpu/resctrl/core.c      |   5 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 133 ++++++++++++++++++++++++
>  arch/x86/Kconfig                        |  13 +++
>  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
>  5 files changed, 160 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 684a1b830ced..36a2072c19c7 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -169,4 +169,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +#ifdef CONFIG_X86_RESCTRL_CPU_INTEL_AET
> +bool intel_aet_get_events(void);
> +void __exit intel_aet_exit(void);
> +#else
> +static inline bool intel_aet_get_events(void) { return false; }
> +static inline void __exit intel_aet_exit(void) { }
> +#endif
> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2b2f76c76d73..b8288f5d4aff 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -734,6 +734,9 @@ void resctrl_arch_pre_mount(void)
>  
>  	if (!atomic_try_cmpxchg(&only_once, &old, 1))
>  		return;
> +
> +	if (!intel_aet_get_events())
> +		return;
>  }
>  
>  enum {
> @@ -1086,6 +1089,8 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> +	intel_aet_exit();
> +
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..d177e5aa1f6a
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,133 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/intel_vsec.h>
> +#include <linux/resctrl.h>
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.
> + * @pfg:		Points to the aggregated telemetry space information
> + *			within the OOBMSM driver that contains data for all
> + *			telemetry regions.
> + * @list:		List of active event groups.

How about "Member of active_event_groups."? (although unclear how this
list is used at this point ... may be more appropriate for a later patch)

> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	struct pmt_feature_group	*pfg;
> +	struct list_head		list;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};
> +
> +static LIST_HEAD(active_event_groups);
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> + */
> +static struct event_group energy_0x26696143 = {
> +	.guid		= 0x26696143,
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
> + */
> +static struct event_group perf_0x26557651 = {
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_energy_event_groups[] = {
> +	&energy_0x26696143,
> +};
> +
> +#define NUM_KNOWN_ENERGY_GROUPS ARRAY_SIZE(known_energy_event_groups)

Why is this macro needed? I think the code will be easier to understand if this
"ARRAY_SIZE" is open coded instead of using this macro.

> +
> +static struct event_group *known_perf_event_groups[] = {
> +	&perf_0x26557651,
> +};
> +
> +#define NUM_KNOWN_PERF_GROUPS ARRAY_SIZE(known_perf_event_groups)

Same wrt macro.

> +
> +/* Stub for now */
> +static int discover_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return -EINVAL;
> +}
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
> +		if (!IS_ERR_OR_NULL(_T))
> +			intel_pmt_put_feature_group(_T))
> +
> +/*
> + * Make a request to the INTEL_PMT_DISCOVERY driver for the
> + * pmt_feature_group for a specific feature. If there is
> + * one the returned structure has an array of telemetry_region
> + * structures. Each describes one telemetry aggregator.
> + * Try to use any with a known matching guid.

"Try to use every telemetry aggregator with a known guid."?

> + */
> +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> +			    unsigned int num_evg)
> +{
> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> +	struct event_group **peg;
> +	bool ret;

"ret" is of type bool but is only used for return value of discover_events() that
returns an int? So when discover_events() return -EINVAL ...?

> +
> +	p = intel_pmt_get_regions_by_feature(feature);
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return false;
> +
> +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> +		ret = discover_events(*peg, p);
> +		if (!ret) {
> +			(*peg)->pfg = no_free_ptr(p);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Ask OOBMSM discovery driver for all the RMID based telemetry groups
> + * that it supports.
> + */
> +bool intel_aet_get_events(void)
> +{
> +	bool ret1, ret2;
> +
> +	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM,
> +			       known_energy_event_groups, NUM_KNOWN_ENERGY_GROUPS);

Just call ARRAY_SIZE() directly here? I think it will make the code easier to understand.

> +	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM,
> +			       known_perf_event_groups, NUM_KNOWN_PERF_GROUPS);

Same here.

> +
> +	return ret1 || ret2;
> +}
> +
> +void __exit intel_aet_exit(void)
> +{
> +	struct event_group *evg, *tmp;
> +
> +	list_for_each_entry_safe(evg, tmp, &active_event_groups, list) {

This cleanup does not match initialization done in this patch.

> +		intel_pmt_put_feature_group(evg->pfg);
> +		evg->pfg = NULL;
> +		list_del(&evg->list);
> +	}
> +}

Reinette
