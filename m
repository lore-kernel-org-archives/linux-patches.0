Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED0BC13B
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 01:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745027672; cv=fail; b=j7trYKd2PcDgK3uPltLk+84DEMsMWUPYCLyVkSWftbpVTb9c0d6zZi03ugHhPyS4cSqQBc7w8VUIY7KOG8bWb8LwdvTTJJd+slYoW1CKDG6ih/KgjbDVdMHaH45ogBmejRpnp2gi0eNJVXzgZiDdjQg+GvJCj2jLtJ3BMXL793c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745027672; c=relaxed/simple;
	bh=GIXbsrN5uL24ds6OCAfVJy5ABnx6cJhT4pLFdHWPwaY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kIp7PjlvwApp/XS7zZP21th2SmHkUVcQ4TBW9uQALhwc9XKYOu841z4Q8oLmFDhs1GKox32G/xF10eOhutUPKeaG/zeRC8mJvHOeDxYgn714EXImqunDU/VlVawvt42T5gLKV72jAd+nTetvG1JE0EVZ5s9/Opw6HEUCiFsdtSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i75fmws4; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i75fmws4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745027671; x=1776563671;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GIXbsrN5uL24ds6OCAfVJy5ABnx6cJhT4pLFdHWPwaY=;
  b=i75fmws4n6l18FZU7s1jhufd7UY58UB/f2KCVIQbb/zf6fnMvxPQHFlA
   oRd4Krj2lj5pA2pnuRyhq2aJBEg2a8eMU6m1HURYCEWstG4MVUzhZPzlC
   hu/ectj33raTvChEM8jaHNggbTrLe2PMsCwJSuSJQFDT114nTYiLRFROg
   6Ku8JwcUr3dHd8mlv4V+U8Mn7T0mC3buYQCKldzjdPhI8Cx6tsO1WCBB3
   X/Pw67O+N67UxqqQ3TpnENLCVKZpezE5q5rZ+aBihFDnJB0jPoorfqHuq
   ceS2zwifu7qvHGwo356zxwYnK7tdyS8ixJpJzMfSQLNgVT3jB3+3IfgFE
   w==;
X-CSE-ConnectionGUID: T861QixESOSwNXAjV++VyA==
X-CSE-MsgGUID: hYbpqfHuT4u5SBB+yCT/Zg==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="45891118"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="45891118"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 18:54:30 -0700
X-CSE-ConnectionGUID: sAQIvKrhSU2OV/NDZyArLA==
X-CSE-MsgGUID: NxExyIccTOalfLaPX87uwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="136423802"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 18:54:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 18:54:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 18:54:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 18:54:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DglbUTkBL1AFr4C6I+yQDD/7EmkJLryt9FEaPaxkIBaQ98zNoWhphI9b0f2C5n1UzizYhvaXh3rQV9cX3Htue+C0jPCV7BeHKbZWNwwbKEM0cj9bTRCm6dr1JJKiNUiQhTrJUtfgE8tHxuUQM7pfRmF4aECX8D1ImMGWmNjIbVIUgy+2PnNttEkvUY9AE/sd/C0IL5K8CigwVU+NgiObUAl1jaihJF15phksI6PafQC+Ew9oKhkYK1+Hm71idyfZMZShU6jr0ZCIzbQXOIRRsYoTFEW/9smfXkqiQNv5aUcpPZKi3hYDQuT6UXFcnzH5VE/oMg9vqe8wNiekZkFYIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sKZuNB7U5VVA9V1emRtpWI/BP0W2x7NksbxbQ7BlSUY=;
 b=ULDavnJwpOWIU9/ATPk2Dm5WDKKvcI9wHTzbjQH4a6lpAolqkH9QmDbi9Suj6zNyTkchHdz4m5rSvJDHfv0/e3Y+cwbfZHx8N0BOnuTxO6ergBEIHt7kaR9Fxo1pCavvCCBLuFwBBNeiCM7agfq2nr1h/zSEZZWi/fN1alZr7h4C/Yzj47e/1TbCAgjmRUSDD9SUrR1KBBDHd12Y4e87z1GHpvaK7feigfluOrLZdAYzrd3wbj8e0rdgY0Hqhgdk/3+6NjlYQw2iWUhV8grxbf3/0lo12nSH7m1QqxnDmwFG5FZl/AXkC1OOol7sUhwpoJJahLRuHI+v1o1AsQRFqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV8PR11MB8582.namprd11.prod.outlook.com (2603:10b6:408:1f7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.30; Sat, 19 Apr
 2025 01:53:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 01:53:41 +0000
Message-ID: <e8314281-2778-4cbd-be01-0ac00b8775df@intel.com>
Date: Fri, 18 Apr 2025 18:53:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/26] x86/resctrl: Add code to read core telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:303:6b::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV8PR11MB8582:EE_
X-MS-Office365-Filtering-Correlation-Id: c4cab648-a5c0-4784-a029-08dd7ee502b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2EwYk5XOVZ3cWRZUk5oOUlRNUE3N3lIN3dZSHUvWlZGSWV6K2gxTHUycllo?=
 =?utf-8?B?cUJsd2xuNW9laG1aR3RtQmdFeEc5bURrcFJxeGExTjJyVFgxRzV0QTl6T3l2?=
 =?utf-8?B?ejVEVlJTRys3a204c01qNUJoazFKQWpZMzEwUUJGdHNUNk16WnRBL3J6M3VP?=
 =?utf-8?B?OGRQREtzR2dHNlhYQXVCV09FdHJDVkwrUnNidXd4ZUJJUVViejZlcjhicy83?=
 =?utf-8?B?Zjdpb1NOeThGa1BuVmozU3pQZFRHMURodkI3YUNSSWUvbkN4cVNrdC8rNjQ3?=
 =?utf-8?B?M2h0QTU2aEJQMXhyTlk4MDllclFQK3RqRytCRTZWMDNHTEJCZDRUR202MjN5?=
 =?utf-8?B?VXNKRXBiMDd0VG05empaSk1FQTVuc2lsUDgyWWxzMzNUQ1lneHF4VEhqQTk5?=
 =?utf-8?B?N1FVQks2ZUtoRFVkRDlFeHpUandWek9yNFYyTlFkeWpjOXdMbjhEWnY2U29O?=
 =?utf-8?B?VnptZVV4Um1ZcmZDNEY2VDhvcXBmcklJOVYySjVaZVJpZUtjTlhDK2Z2SDdt?=
 =?utf-8?B?dHMvTjc0dW5XSWt5SkxGbE1wZFg1VlhwSVdrTlBvYkZjbkNjUEM5VDl1R2lz?=
 =?utf-8?B?RjlrYW52ZmgxYXEzUEFwSnE1T1BJdzB0T3dnN3hNNHVjaThpdFVrb1BQOUVI?=
 =?utf-8?B?aTdxbWNHQ1lqYlZkcUhoSjVyUmRpZHhxUjc5U21NdU4xQjZabjBhM1pWZ1Fv?=
 =?utf-8?B?RzBIelZIaUx3bGE3Y2R0NGN3SHRzZE9JQVJ3QmxJRFJiT0lDSU9yNWovMnZJ?=
 =?utf-8?B?TjlVT09GcGsrMlJXaXUwV2o1SHl0QTJBR2JrVFFUOGs1MC9uYTJxeUY3ZTNP?=
 =?utf-8?B?Y3lDWUhPakovSkpEWHQvZlQrZDV4UGJ6bkxFTjlKM0RhRkVLMjFIRkN6VXBn?=
 =?utf-8?B?YWZMQzdod0VQVnA3UXM2WHo1bTBJQTV4TGhTRkQyNjR0Nk51ZEJDUHhGRndY?=
 =?utf-8?B?WXRlQWlPQVVFWHUyN3drTm90MHd5OElkTERVWXpscStFcWI0Rm1YWUY2c2tl?=
 =?utf-8?B?V1laaExFQi91STN1ZDhHSVh1eXlHbEt6d1dyR3BDNXZpMDh2dHJ4QUpUcWZ6?=
 =?utf-8?B?UHBLN3k3bFZHWWkwWFhiZnJ1RE0wRk85U21vYmdlTEprbUxXM2RkVkJ3WHlT?=
 =?utf-8?B?WUhRR2VnVmdnTHZsZEYrOStqTkJVVFFxcmpVWUd0UGZETWEzeU9vQTRvTEpT?=
 =?utf-8?B?Rmd0Lzd0NXpqYnpuL1RseFQweEV2aU5JRjkxU0REQzVhSUxlTjlBcXhyTjVD?=
 =?utf-8?B?MEthSTY2T29WcDhLY1VFamltNTUvK0dnTUZUdUMyZ2NWZGlPZzg0bTkzM0Qw?=
 =?utf-8?B?LzhVdmVtT1Y1TXd2ZnNjeDBZWHJ5QlZJWTlBK2ZER1J6TU5aVzhUNk4vODVK?=
 =?utf-8?B?ZEFuNW1EWVhad0tFTlNrVld3RmRsOTJUanFYNHNzRlBoUzlKK2hTM1lITXlM?=
 =?utf-8?B?L2luVHpBZEhNOFg5TG9KSi9QMmR6SHZ1WU5kT3Rja1kzS1VESVRUL1V5YlRr?=
 =?utf-8?B?VzNtczVnNUZDSVE5ZkVzRWowRjJ4UmJqdE9qQ212Vkl6ZzJHck5KaG1xSFor?=
 =?utf-8?B?UjdwS3pxWnJiM2pGZklURzROWmJjNnZJNUZFaWo5dzVkdHpnblh2QUtxZWl2?=
 =?utf-8?B?V25rbFhrV0dOaW9GTzBEZGdqY0FwaUJYSGtCMXI2T3RDeFcranlwcGluZC9j?=
 =?utf-8?B?ZTZjT2FGN082NHlVenRTSi90cSsrVEdEQUdJZTNGcDQ3RUdvWWIwam1pYjN1?=
 =?utf-8?B?SHdnKzhuNVlpVjNBenZTYmRETnA4YUJ2OUJOeGlZT0tndk5LcDdnWTgwUitI?=
 =?utf-8?B?UU9LdFRCeHkvR2lTMk1DUFBOQ1VTTmpnL0lMLytSdjVwaVFsNGNxd3VZYVNm?=
 =?utf-8?B?eXZTc3Vld3FLNWthQkNpelo4aUV2NFdkcFgzR09Db09Oa2lFejBDS0NKUjBz?=
 =?utf-8?Q?DqJ25si7iIY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjRsQ0U1bW1mN1NpZ0tablFrY1VxM09GM1RqZzg3c3lnZC9xazVvVjRuUjhO?=
 =?utf-8?B?eE5xRUlDMDBEMjBMQXhlM1R4TnVKenJKMkdPOFdqTmR0MUVuNGxmaHd3ZTli?=
 =?utf-8?B?YS9rS3pvM0s4WjhDbHhUVVIvdEtLSHY4cDR2SkM2THBtSzAyL3FsQ0Mzb1Rj?=
 =?utf-8?B?dU9lNTRXTm5hUWNreWJ3c252QklvM1VsWUJSWmcvSXcxNnJRanJyT2pMUDlh?=
 =?utf-8?B?OUZXQTViL2Vhd29DRXA1VW4yVFNyZzM5ZS80WmJyTklCNENrcjVkM3d6b1Vj?=
 =?utf-8?B?bTlKeEZlb1l1cFY1STdIYVlCOWFmWnpmbmM4RTBWZ01Pc0VZNkxXT283ekZ3?=
 =?utf-8?B?SGN1dHQ1N04zZk1xUUU5bmcrdlhQZUpuKzgwU0dGcTJycEdEeU9LRi9pdHpS?=
 =?utf-8?B?NUNQb1Q3RFpveG1zTmlER1FrK0s4KzVYeERtNUxwVXI5UytZd3gvaGJobVVz?=
 =?utf-8?B?WTUzR2pGdmJ4SzhCMk5KMFBMSU5scmVuYnJsMENjeDVwY290TGU5RzVYdFlj?=
 =?utf-8?B?RytSaFdCYXkwakpwcnd5cEJqcXpmVDNpU056NTc5MzQwMEo2YWZ2SkltL2lk?=
 =?utf-8?B?MEI1REVIMHFYUitPRWVVdlJ0ZVQ0RHY4bVNnUUdNODFMTmZkZ0IxYjBtUkNl?=
 =?utf-8?B?R2lzKzVxdzBCSSs4OWNwdlBzQlpMZkpxaGhXVnMrZjJoTU9WUmJURnh6UzQ3?=
 =?utf-8?B?QUM1Vi9nK3pqSUJyazI5WnZrU0MzWmlTOXg0ZDc4cFd4bXFjSzlqZjRIdkNh?=
 =?utf-8?B?SU1pWm5WQ3dJeGtCbWJseFlEQldYdU5vZGdnRXozM1dxYmQ1VG5OTURIejhn?=
 =?utf-8?B?VFlmNWdrVFdtTWJtdm82djhVK2lnVzVRdjRJdVo2REw3bm5EV1Rnam5lNmxi?=
 =?utf-8?B?a1ZoRDUzN3MvclhuSmlKdjdUaU4xN1FVTklKc05paGlMWGk5QlVhZnZUcXUw?=
 =?utf-8?B?NWpEbEIxdGl2Q1FqZSthRTV3ZWIrQUliR1ZoaGQ1aWJtdUVSSnBCbU5MbnZs?=
 =?utf-8?B?RUZlUUNGYVRnNnlIKytFMGxyMkNWNFl5RUh3MXR6RGxvUDB2OTRRRUxVVjZX?=
 =?utf-8?B?NC9FOVYxOUkwVEdiODJ4NnlGQ29ESTA4dzlvZWc5aDNYSjBVb1hYTllVWEZl?=
 =?utf-8?B?OFcyVW1ZRWpaZjhibkhWcEdZNEpIaVFCWVk5UCs1cWJBMnJEdjdkZEk1Q29m?=
 =?utf-8?B?QkppSjh6YzF0cm9lVWNZRjQ5VHZ0dU1uYldlL0tTOGdyVVdXZGpHSUY3cnBw?=
 =?utf-8?B?Rmo4QUJNb3dFNlBaRmJTajJuZDBtK1huNjBWRUFpUHpjUStkRTV0aGt1MjNj?=
 =?utf-8?B?RlJFLzNIYVhMdmluM1JCbSs4Wlo1R1hCS3JvaGdTVUZFMVcvYVpiWW4vUjB4?=
 =?utf-8?B?NjFzWHMybHF5YVo5N3o5NnI3V2RsVTk2bmJCZk5heUFRMm54SXVnS053dlNx?=
 =?utf-8?B?VEx4NHNoSlFYdFpUcUVicElmc0FkSkovWFBVdGVhYnhsZk9SdUR6K2tFSmk0?=
 =?utf-8?B?NDU5c2phUUJ3bStEYmtwL09KK0MvMXl2d1dTSjVBM1pnV0FOTVAyVndoZ3c1?=
 =?utf-8?B?Ni9YRVd6VlUzMmEzWGI2blYzL2JmbVlBSEQzWWF4RVRod3F0TlZudzJ1U0ZH?=
 =?utf-8?B?bFdKaDBHbG41VTQ1UXBReHI0RmlTRllaUGNZVHM3UlJrTTZTVmR4bEltRTBF?=
 =?utf-8?B?ajBUeFFkeWlNNjZTdVA2UGNFM0NqRERNb2tXbWR4T2RhRXlTVWtwamV6NXhq?=
 =?utf-8?B?dUdqZk5BaStLV2ZobUlXV2NDaUpUWkFWamc0VWtXRVVsR05LZDNZNisrYjRo?=
 =?utf-8?B?akp1Mlk2RGhSZDVPS1R5b0M2Qm0xVkFZQU1HOEJlQUdlVlhaTU1haDZaak52?=
 =?utf-8?B?bWE3TWtaNkxYTXY4ZkplUkc0WEhBUmtNUDM3WHo2Vkp1bWZObDFxNWtKSFhm?=
 =?utf-8?B?NXFSOFBwNzdXMmhVemRWRGpPdlhsMHh5ajdoWHlaN2tEQ2grZVIrMXgwbG8x?=
 =?utf-8?B?K0xvTzB6VnpUVFE5OWtiYmV3UGRDOEd1OEF3ZWN6L1hDc3ZKdk4rd0FKUlZL?=
 =?utf-8?B?eE4rWVl5NTlWd1Bwd0tEeFYxYlBLS2hJL0lNUWp0Zm1rOEY5Smc1UTJwaUh2?=
 =?utf-8?B?bVZ0aGxkVWp4WDZCQU9nbk5XS29RRkhvZG9WT05xRlNocFlkWklEaXFteGhP?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4cab648-a5c0-4784-a029-08dd7ee502b9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 01:53:41.6280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uy1D95RGdNoLzQq/wW86d1Mn45jpdO0AOrRMqObkYQW4CksG8hWge0xXh+87sxMRwT+PSoB2CmUrH1z8fNKPLz7l+YS5A0gFoeMS8LOkO+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8582
X-OriginatorOrg: intel.com

Hi Tony,

(deja vu ... "Add code to" can be dropped)

On 4/7/25 4:40 PM, Tony Luck wrote:
> The new telemetry events will be part of a new resctrl resource.
> Add the RDT_RESOURCE_PERF_PKG to enum resctrl_res_level.

Please follow tip changelog structure custom throughout this series.

> 
> Add hook resctrl_arch_rmid_read() to pass reads on this
> resource to the telemetry code.
> 
> There may be multiple devices tracking each package, so scan all of them
> and add up counters.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl_types.h           |  1 +
>  arch/x86/kernel/cpu/resctrl/internal.h  |  5 +++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 58 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  6 +++
>  4 files changed, 70 insertions(+)
> 
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index fbd4b55c41aa..3354f21e82ad 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -39,6 +39,7 @@ enum resctrl_res_level {
>  	RDT_RESOURCE_L2,
>  	RDT_RESOURCE_MBA,
>  	RDT_RESOURCE_SMBA,
> +	RDT_RESOURCE_PERF_PKG,
>  
>  	/* Must be the last */
>  	RDT_NUM_RESOURCES,
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 70b63bbc429d..1b1cbb948a9a 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -175,9 +175,14 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  #ifdef CONFIG_INTEL_AET_RESCTRL
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> +int intel_aet_read_event(int domid, int rmid, int evtid, u64 *val);

This can use enum resctrl_event_id for evtid?

>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void intel_aet_exit(void) { };
> +static inline int intel_aet_read_event(int domid, int rmid, int evtid, u64 *val)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 44d2fe747ed8..67a1245858dc 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -73,6 +73,12 @@ static struct evtinfo {
>  	struct pmt_event	*pmt_event;
>  } evtinfo[QOS_NUM_EVENTS];
>  
> +#define EVT_NUM_RMIDS(evtid)	(evtinfo[evtid].telem_entry->num_rmids)
> +#define EVT_NUM_EVENTS(evtid)	(evtinfo[evtid].telem_entry->num_events)
> +#define EVT_GUID(evtid)		(evtinfo[evtid].telem_entry->guid)
> +
> +#define EVT_OFFSET(evtid)	(evtinfo[evtid].pmt_event->evt_offset)

Please open code these or use functions if you need to.

> +
>  /* All known telemetry event groups */
>  static struct telem_entry *telem_entry[] = {
>  	NULL
> @@ -224,3 +230,55 @@ void __exit intel_aet_exit(void)
>  	}
>  	kfree(pkg_info);
>  }
> +
> +#define VALID_BIT	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Walk the array of telemetry groups on a specific package.
> + * Read and sum values for a specific counter (described by
> + * guid and offset).
> + * Return failure (~0x0ull) if any counter isn't valid.
> + */
> +static u64 scan_pmt_devs(int package, int guid, int offset)
> +{
> +	u64 rval, val;
> +	int ndev = 0;
> +
> +	rval = 0;

This can be done as part of definition.

> +
> +	for (int i = 0; i < pkg_info[package].count; i++) {
> +		if (pkg_info[package].regions[i].guid != guid)
> +			continue;
> +		ndev++;
> +		val = readq(pkg_info[package].regions[i].addr + offset);
> +
> +		if (!(val & VALID_BIT))
> +			return ~0ull;
> +		rval += val & DATA_BITS;
> +	}
> +
> +	return ndev ? rval : ~0ull;
> +}
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain).
> + */
> +int intel_aet_read_event(int domid, int rmid, int evtid, u64 *val)
> +{
> +	u64 evtcount;
> +	int offset;
> +
> +	if (rmid >= EVT_NUM_RMIDS(evtid))
> +		return -ENOENT;
> +
> +	offset = rmid * EVT_NUM_EVENTS(evtid) * sizeof(u64);
> +	offset += EVT_OFFSET(evtid);
> +	evtcount = scan_pmt_devs(domid, EVT_GUID(evtid), offset);
> +
> +	if (evtcount != ~0ull || *val == 0)
> +		*val += evtcount;
> +
> +	return evtcount != ~0ull ? 0 : -EINVAL;
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 06623d51d006..4fa297d463ba 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -236,6 +236,12 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>  	u32 prmid;
>  	int ret;
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG) {
> +		ret = intel_aet_read_event(d->hdr.id, rmid, eventid, val);
> +
> +		return ret ? ret : 0;
> +	}

Not sure if I am missing something at this stage but it looks like,
since resctrl_arch_rmid_read() can now return ENOENT, and rmid_read::err
obtain value of ENOENT, that there may be an
issue when this error is returned since rdtgroup_mondata_show()'s "checkresult"
does not have handling for ENOENT and will attempt to print data to user space.

> +
>  	resctrl_arch_rmid_read_context_check();

Please keep this context check at top of function.

>  
>  	prmid = logical_rmid_to_physical_rmid(cpu, rmid);


Reinette
