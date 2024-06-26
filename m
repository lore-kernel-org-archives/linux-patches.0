Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F160193085
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 21:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719437026; cv=fail; b=RAXQgkGZHnxZALus7E/CJyYrwp1aU+tc2KN7Qg8wKUGXNOgTt508z0mNWO+g5b/CpBwnA1GxpPtK67RZt9JI+AOtEmmzHIPhN7uPVpUESgMk4gwwhrzeSU4wpfbtxFvmU2WtS6nYD889pjpaWjGvyBh82GDPWOBupxIP+FX+HHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719437026; c=relaxed/simple;
	bh=t6RM892yp4lM4z2+xNXsrvJ9FgaVg+LQ5xKnzwv5uhQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kRpuPI1GnlfZnOD3Fk8j4QtLZe7LA88jeZhZ8srOLs6JuiR/n6iz5RPN/FhsuUK+5PKOg6qxEeIJouUipO+4R7Xn1MWNRA49u/WsGbdeIzE4xAO5A/I4ofYJyrRf4SwSHIHal7GEBrsffbln0ygkqE5uIZ+QNL4kqe/0n0BBkx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eqe8GxgF; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eqe8GxgF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719437025; x=1750973025;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t6RM892yp4lM4z2+xNXsrvJ9FgaVg+LQ5xKnzwv5uhQ=;
  b=Eqe8GxgFaADltq4FVL7hHnYIJ+MyZ9SyDqTv+uW2AzU8CQV6O6Mx3mak
   YRR5LPfqRyOJh/ZLzXW/mDl0kklAYwx1cqZ0Xp8vxLtWgMNgK2EF7PcsY
   QhFqH3cVuj5PWUagGRXNjQ6KKL0WbDxfOyHnuq0zZsgEERwtPio+F4098
   UjqNFkBTx7gSkR1XhQj36/7LRjqfHZo6BOtCLlCuuZPgjg7pB9LoHGehG
   FrLTjEk5999AEtqIW2Dj0pr8FZrJJFYr3qeiOBjZ6iT/jyYc4WIqTkUBQ
   fQjwJyeIckiMPyed5f4e97F3ZC3SXD2xxwCzLsbRnS5f9rL20uW6O4fFk
   w==;
X-CSE-ConnectionGUID: hzEM3uU4SCC22aMuXvknTw==
X-CSE-MsgGUID: oYvPwgZaQXW7w1DU6YmsMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="34067712"
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="34067712"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 14:23:45 -0700
X-CSE-ConnectionGUID: mtYgaDkiS8iZIOrnae+qKQ==
X-CSE-MsgGUID: 7gR3AV3WQvqYsFkIZ5sliA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="48592268"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jun 2024 14:23:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 14:23:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 26 Jun 2024 14:23:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Jun 2024 14:23:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTimJiNajQmc9To7QejakSQTe9sElL9815+E6GjFk/ZJ2/tY17+9IwlzLpnbABWRBk7EERWjAeEZVYTCp/UGV3/qoOy7xiQWjUKrA0eAetaoXs3tpR7O/p4AVQI/fJWbpCxAu5ZLOsGODGz7v9631RRPRbqA8NchKoZeYD09nZSftCMlN8hVshCTu/vah5yJ5ro4iPxi2aLb8aHuDbvDlx6WquGKDtEGzRFw9QWR6dqPq7aLC6HvWBq//umipPYJDaItQ3LkladhLQezuljUxn/sGi7Ya2hqwNQgYcKjxh0DFVKYZbsNev2U4tAapLVb8TVDob61CltdTdIWHMhYzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2/IBH5eu8I1wOP7FUOCVyobdLh5CNbzhTWvISK58nU=;
 b=TiKwq6ES1Xmn3FUXsKInJPBA3AaBoAqKdVHLcZIU64E0L7HmQOsVKLT3gcTl0u8ojJ/Ye1UFUSXL/JmL2BygpMFDKBlhMi1CziwNDKtuEVFVLoWA2I4fYPelH6NWchm8XXQiDeyGlS5yXJMm+osJ9bgxfPU++8pQJU/BoCJOcTAKeTOVW88WUI/ztjV7+4yk8yxXXt69pSA9MxltiIMsNc+gGhNVqUn8Z+nRNQM6xGJvaH6YhAaivFmXgF6f0NmBtuxXRhmYD91LPQarPDw23h5FuJs7zCFMuT/4LQVxmhkIPilAhh5cbLrDOfyFq8naignzfJ8fI51m+fWY2yqyHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB7056.namprd11.prod.outlook.com (2603:10b6:303:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 21:23:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 21:23:41 +0000
Message-ID: <d82a0882-1b92-476f-bc14-e8edb6ec43ca@intel.com>
Date: Wed, 26 Jun 2024 14:23:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 14/18] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-15-tony.luck@intel.com>
 <8df55906-23b1-4772-ab11-703da64d5ebb@intel.com>
 <ZnxtZc140S11gFKL@agluck-desk3.sc.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ZnxtZc140S11gFKL@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0014.namprd21.prod.outlook.com
 (2603:10b6:302:1::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB7056:EE_
X-MS-Office365-Filtering-Correlation-Id: 0303b840-9ddd-4908-c4bb-08dc9626407b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|1800799022|366014|376012;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K3U1Wi95TkRBajhEcWg5QWVmSi9aS0QxVnFMZUJiU3dxYkZPUVB0ZGJraHl4?=
 =?utf-8?B?RlpJRWlpMCtxR01lL3VjVkpya1E5MUl4eU9HUGRXb0NGaHJrcHFheUVTVitK?=
 =?utf-8?B?YWhqVE03TXVoNHdmOGRxeUlSWUc5dktQanlrbkNZYWtRZXRPc1lQNHFRUStM?=
 =?utf-8?B?YXJhT21LZ0hyNFdodGt3dm8wSzhOa3hGNVgyamd6bklobUIyWTgxMi84Q2pE?=
 =?utf-8?B?TTZMWTNCakNBSmE0Um1adStQL0FxWTJOME5LdFliU0JPMnpybjJkOVJ6UStq?=
 =?utf-8?B?RFRFWjdCZjRPdEp3Ykp0Q1lsbWJ2Q0JPYnNnT3FKQkUwcUNWZXpFMnpoS0x1?=
 =?utf-8?B?Q0hsanZ2emlQN0g2M1A5ZkticzhOU0VLZkFZcjJFUU0xcXNMZmJFZUI0T0FU?=
 =?utf-8?B?S045Ri90RjZkN3plWkRQZnVHbWR4N1NFRmxBNTNuTVRLcVgwTHByZWRKL2dK?=
 =?utf-8?B?U0RjMGxZeXI3MHZHZklBOENmYUZBdGxVSStOYkFmRUZBNzZNZWVKNDNielNm?=
 =?utf-8?B?TjJPeVNQR3ZmcTdrSzRFUmliekd5STlpd09iRGkyc210d1h5Wm1HNUFIakU3?=
 =?utf-8?B?WGloZ2RGVnZELzBFakRNNGFFYkxUSFdKUEduU3lCR05YUDdoOXlKYkhvUWlt?=
 =?utf-8?B?czU5QVdTZzRpNG5raFJydWJXRlVCZks1YWIyRUlkN1hSS1NzcHVnMVJhQWdn?=
 =?utf-8?B?U2hHMVRVVkkrOXdVc2RjSmNMbldVZHE4WXNGV21uRUVUNU44YTc5ZXBUYnhU?=
 =?utf-8?B?MkhCODZtRFhWNlJJRXU1cWl0STJoekVkenovWGd3UFNjUk0zWmxmQnU1b1U4?=
 =?utf-8?B?VEFzckVFUUQ2S2QxcjlzWlJDcXlrVUc4YVZIVU9kTHVVNUxLbXlVSXVkWW9V?=
 =?utf-8?B?UGQ2Zlh6N3NRZUxTRUxScTRqUXZSVklBWWh6VjBtekFnK0tWcmxpbGIzOEVz?=
 =?utf-8?B?QzBHTGxnd3lIMmF3cU4rdmlVTXlWdDZuWDQ5ejhXTElEd0xnb3lKeGMxL2tj?=
 =?utf-8?B?aUNrUFoyNzdKTUJrU1Q5Wm9iMS80WGhCNms5aUxuY1dJVEJCTFJqRUtSci9z?=
 =?utf-8?B?UElOYlFGTXZBRU5kVVc4VjhkWDhNSTV0blh2NzNRQ2xScndpVnA2N04rQjFV?=
 =?utf-8?B?djQ3M0JrbHpYdjlIYWhRL2xaN1hhVXBFdHZTMXZmbjJRRzZ3V3pqcVVWUDdm?=
 =?utf-8?B?QVc2QXBGNkxPeDlFekNRcWxPdmVPcmxWRzF6L2NlTzdoaWF5T3J4WUJtV3hD?=
 =?utf-8?B?SHdZLzU2K1d6Z084eHMwRGF1ZnZSSGZpc21CdnF5SmFmcERMNlRaNFNZdU12?=
 =?utf-8?B?bEtqcFpjb2p0aE00WlpzTHFSQ2JWUTlWcjJ0RE5YVXd6d2d3NWxUTGRCaUhU?=
 =?utf-8?B?L0ZZMzVhN2ZhYzlub0wzc0hpTmFEdEExYkpGd3RWU0ZuUE5LQmgvekYyUXYx?=
 =?utf-8?B?d2JlZEhIMTdVb2haTEludDIyUzBwNHV2em1XWVY4RkdkUjhGMkVCSUVVSnRE?=
 =?utf-8?B?UnplcTFiaFJ0cmN1a0IxWHZCcHBFZnB1cnlzUE5nRjdOaksySXpMS09iU3g0?=
 =?utf-8?B?N0V6RWYrVDFyV0twNFZTd0RPRXp6UVN1QXRRUlgzVi9pRHYzLzdTd0g3cGZT?=
 =?utf-8?B?eTFyUlZsSFhrMUJDTzdyMGdWWWtoN284YXQwM2R2V0RTZjFpQ0o5b1N0ejhM?=
 =?utf-8?B?ZjYxSnRRcjdzYVQ2Z0xLRy91cFJHZWdRT0VGR3ZRR1QvMGpGbGQ1T25ta1lN?=
 =?utf-8?Q?sw7E92wGbml/lVWSGHKhFRacctRE67QFtgmZeoW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(366014)(376012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk10Z1JIS0RwcllibVJsTTE3RnJrUE5aTjlxbDcrTFRFTytKRUMxZTNTdXRR?=
 =?utf-8?B?NXVPdEJoYk1WQmMvTFllNVVzYW1LMHNjS292S3lZSCtHSldJejV1dndMSFNF?=
 =?utf-8?B?bGRobWdVb2phOFFUSUg2T2VMWGw1NXZhQjlVMVFDamZvaWFuRGdySUFCeWtE?=
 =?utf-8?B?SHo5K2JackVxQUMvUHl2c21KWCtVYnhtQ2dlVXhpTThYWEg0aGZVUk5Ca3hP?=
 =?utf-8?B?T2M3ZThFWmhOWUtUeFNUcmVDK0dxdHpDQ3g5Nk85TkJJYW05SWFCN1BZSTBl?=
 =?utf-8?B?b3l1d3QvQkFKNDV5eU1hczVHaGZaL3ZyK0liZWVEcTIxclFET2JIRjUybTBN?=
 =?utf-8?B?QlhtY1gxYXQ1cFlaYUlGQnNKR3NoU0VwZ1o3SU9Yc2U3azVESlRhaE8ydHBo?=
 =?utf-8?B?ZUtaTitiMkZWTlNiaHRkTFBGaE12U0VodDlvZzRKWnZ4S0ZuOGluSlZQd3dr?=
 =?utf-8?B?WUZVeHRQWW56Zk1NSWQwRWVHVVZySzU1bk82ajNocmR0aEVodDIyTHJNTXA0?=
 =?utf-8?B?enNMWDdwa1BlZU8xN1Y0ZVJtL1pGNEc1SGFXaWNTWkQwL0lJWDlKRjZua1NL?=
 =?utf-8?B?bXUzY0ZJZEJMZStzb1VUck1vUEIxTFVwU2tYUmxzenNLa2c2c20xa28rOXlB?=
 =?utf-8?B?bnZ4Z0U1YXdDcExlSE93VUpnekluYlFhMjVmeXZad0tkTER5WDNheUlMTHlW?=
 =?utf-8?B?cnBvT0RiUXFpKzUvZmovY0NzRXVrdlp2L1BBVGJhU3dzeCsySWw5VHZzSUYy?=
 =?utf-8?B?T0JNNlFqOFVJQUQvUHhnZVUzc2FmZHhlQ29KMUZjeXhTaFQyNnJZMnN5aVJU?=
 =?utf-8?B?dnlERm5uM3hWK3lkOTRRMWc3bU4wWUo3RzU5aCs0QUJjVjhhU1g3bXRGTzc1?=
 =?utf-8?B?MFpmZmh4d0FrUW9TbzRZNFN1dy8wMDJUMExpTXgxSjdGaGxJaUJSbEdPRUNM?=
 =?utf-8?B?TGJzdDVadXdNMjF1RFdlZCs1UjMvUEp0L3hJZG1FNFhaMit2QnJjTVkwK3Ju?=
 =?utf-8?B?VWdOREZQQnIxSkFXaGRTdzl6b3YxeWRlL3RwK0JvSlM2aWZSR3lVa1dxeWZp?=
 =?utf-8?B?cDRxTGxLMWhJcGJQcTNEcXJ1RlRnczFrR1Q1bU54NUFwYXRNVzFDQW90R1I4?=
 =?utf-8?B?Z05Fd0lvNXJxY3IwWGVhbURuS2pFcnJ5ZFJlYXpkZlBSblBGZ0ZXOGRFNSsx?=
 =?utf-8?B?amJYYm9UZ0pLYjd5NGlLUkUyTTUzK2tkcUo4K1Z6YWx5cTNzTEs2UjZSa2tW?=
 =?utf-8?B?blF4TXRwYmhQeU0wNzBoTksrOEQ1SWR4YzNFK1g3SVUzNDFOVFdrZW1ZTlNP?=
 =?utf-8?B?YXdDbUpMb24yc245VmlmYzVOb3JIS0VhL25OQ0FIM1ZRVTBxZzhKeEVvdkhK?=
 =?utf-8?B?SGtseGZ0dzhHbVZQVTVkeEErbUZua3NtaEVKZXVnTHVRcTZlY2J4TEc1Tyt3?=
 =?utf-8?B?RlN4S283V0hQU3RWeWZXcjZXU1VFWlZNOStxR0R6K1NhTmtiNjRLM3RWbnhk?=
 =?utf-8?B?VDdYS29VaC9qZ3JLRVVhUFlEYjg0cUFKUGJJc1BWVGd4NnVhLzQ3UFkrMWdM?=
 =?utf-8?B?SWc1YUoyR0JjVTAxNU9lV3IwdUVIWkdkUGVCQUgzd1ZtaVV4cVF3cHE5Vkcw?=
 =?utf-8?B?T0dobE9CZDh3U2tJL0xkdkh0K1dMRkgvNFAyU1hOZUMzclFWMGZ4L2tFalVk?=
 =?utf-8?B?QWFLa0FxNHBBKzl4VHFQRVMrOWp5byszVk9WUXRvYnBWS1dLeSs3bnp1NHJT?=
 =?utf-8?B?NzRGeXpxTDJRb0FpMjIraEE4dmNPUXlkT2FmV3c0NnJXVG0zUllPT2ZSc1FM?=
 =?utf-8?B?N2FNS1FJTkNzaXdFTXdGTTlEVStGWXNQVTNLa2l0NEZvYnVQVHlVbHBIbjl1?=
 =?utf-8?B?akFOY1pBWnNoK0dSb2dURVBLaktJV0M1ZktuTVBuRHhGdThMY2NxanF6K05U?=
 =?utf-8?B?cWREZDVEOE5MZnVRTVZYaWVOdmtjSU5sc3FyMU5kQmhtYUc4Nm1ERGw3aHZq?=
 =?utf-8?B?UTJNUW84dEs1MDJHWXMyVnYzbmtiNGE2YlQ5Q0RYQSs4blc5KzdsRjh4OXl5?=
 =?utf-8?B?R08vMmVIZEIxWnBaNHltOTV4RnJ2VThIZVRmamFWR00zQkZkR0l3MGFBV0M3?=
 =?utf-8?B?bzlveDZFMTlMTUJ4b2hwUFNIYk9IYXI3VzBEOWtXNEgvL2lXTGxuanUyUlFh?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0303b840-9ddd-4908-c4bb-08dc9626407b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 21:23:41.6088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkqCYAbxqu53if1mBqi7tYNI/RhF0G4NV0v0dT7VrmmAKLmxXDb4WjjBdmLkgFyw7W0EQ1ZEzM7LdQ1G/G3AsUrWMvyRLZwm5TuJla/uSHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7056
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/24 12:35 PM, Tony Luck wrote:
>>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> index ff4e74594a19..877d898e8fd0 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> @@ -785,6 +785,7 @@ static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
>>>    	rr.first = false;
>>>    	rr.r = r;
>>>    	rr.d = d;
>>> +	rr.ci = NULL;
>>
>> This keeps using a struct rmid_read with random data from stack and initialize members based on
>> knowledge about how the called functions use this struct. Could you please add initialization to
>> all these places that use struct rmid_read with whatever is on the stack? This includes
>> mon_add_all_files() introduced in this series.
>> Something like below should do (in mon_add_all_files() - done as part of patch 10, mbm_update(),
>> and mon_add_all_files():

(I see now that I wrote mon_add_all_files() twice ... the latter was intended to
be rdtgroup_mondata_show()).

>> 	struct rmid_read rr = {0};
> 
> I'm making that change to the three places that struct rmid_read
> is defined as a local variable.
> 
> Should I also remove "useless" assignments now that the structure
> is zeroed by the compiler. I.e. in the above snip the rr.first = false;
> and rr.ci = NULL;

Indeed. Those are now unnecessary.

"useless" assignments are subjective. When considering this rr.ci assignment I
think it is insightful to consider its lack of a partner in mon_event_read().
Of course, rr.ci should not be set to NULL in mon_event_read() but I think it
highlights how issues can creep in since without proper struct initialization in
rdtgroup_mondata_show() and mon_add_all_files() rr.ci will contain garbage
in non-SNC/non-sum flows.

> 
> I suspect there are others.
> 
> Or do they serve as useful hints to human readers of the code?

You are of course welcome to keep those you find useful to readers of the
code. My goals with this suggestion was to (a) stop passing garbage in
struct rmid_read fields, (b) use struct rmid_read consistently.

Reinette
