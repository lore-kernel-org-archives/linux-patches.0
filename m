Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B5F24466F
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099253; cv=fail; b=sQMt9YbeKA3Vpt532oT7BDrCwIoP+FOfGrQVxDs94v5kY0NsecLi70eSclcgp7USt4aWHYKdyeMumWrvoDTDAfwwky8As2BqmgcYdYw7zbWJSMTtRS56jaz1w0WbKJIgrBlv5P16qDg2Z8bdG+2CVwz5vDwqM8Inv0HjIhkCeT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099253; c=relaxed/simple;
	bh=emlsrqrH3fpyBZg+1eYQ5Fro6cii76+wyQKZ5zVDyx0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DazIBWEiDQeFWH5OSz9P6+/HGPAubC1phy2y2+ZzIP0mA6c1O7NCHB80dqC89ffhcbV9Z67XVQR0VNfdXRPax2gtNoIgEx8ME6rW99mmLtzGct/nkkDF8WYDpHd1ByMvx2r7yz5Ah8OCk5Sk+dAoEGBmTNWF6wDduUvQ44dZKXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ul/X+71C; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ul/X+71C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099251; x=1783635251;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=emlsrqrH3fpyBZg+1eYQ5Fro6cii76+wyQKZ5zVDyx0=;
  b=Ul/X+71CR4kNukPzoV6EgRDqAz0d6+zfm4XIdsbQmyz8Y6HvveIq84gq
   M12IL1O7XuJkOfdapY7maYxkLSQDwYuc3cPYcOj7l+uA3USKB7YOKM0Kl
   jgTfu0KS5UfcraxzalOu28gqj8rDpt3WEfVofGjRejH3Wds+E/ou/s5vT
   HhPOWEPRaScP+PpSbQXHF9vq6buVcKTNvcLRrg23FDyY7tDYRhiohw6af
   zFMAdNhyWz1iJtH7Sqorzt/UbzEBr2IymHIGlT8Sgvnrv8eqQNsFfLv+7
   M5LkmkekgU3Dm8XGDBKsHGiHN3Fxd79zfuOd0QlCYYGgh0BKCQu6YyWiB
   g==;
X-CSE-ConnectionGUID: 6cnBcFU7QiamQZ7wZRAfzQ==
X-CSE-MsgGUID: 4l2xPubJQpWaHvXaB4YXHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="65722587"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="65722587"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:14:11 -0700
X-CSE-ConnectionGUID: WnTQyce8TTSF9wquL+7xYw==
X-CSE-MsgGUID: 1Wp6g7j2RoSMHvM8W464TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="186865405"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:14:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:14:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:14:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.69)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:14:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LM2A4Ps1PFc5euh/0sJR8mlEMVDYqrzO8pJmZrz4JJlvu5yQJ+WBEek2lfUWSFtLlToSxmVobybiGZQV658tvdu9yYXvNGWHNima2xAz3hwEwZjCz6qdmQCRT8xZJvhM3z9nJMgbS8RLdxmD/T9+nUqOrRj9d94Q1cwz2ECJ3Up3dEIN2E7cKxBC83BGmv9vVO9kb+SigGqp+NPaqCTDppECrTZjy4lq0/oITWSbfRDtnnRad3Rkl5YyICGlsXAwBF0yqHszELoskOJJY7R2m3e+zdrw5/D3nrtcv3NpMskUT8WLw60fULwLEhme3mNScbx5yYsZTuSklbXAJzvFIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2C3HpW6AdsD5TzzdM0vYzIqji4dVSqV3VVbtP+kyVBo=;
 b=MC5SuKJjt0Y7fKkmInYx/6fKkEkJecN+Tl5K1+FycIGfle+NWzZVE0CIAhWV8oyKZp/5+s767rKPXWSAEn7DGFygbebDZV0SWvQPu+YtGQg3rTINqrmjev7Co49spvoIAwvWNCYwOojImq4fyTqmQEJ7A4liZHj5HZBrCrhPhrhEdcdjgBwb3gf13bDB5aMAaVFT6boCYKkITxqPn2lGIP+qZ6P2kyNkkw2e6eVi0LfjyCstol9xVDxcaeRJmY2fwzk+S7VzNSKrA2IBSs+X06Wr+G97KEnCk5ZWPO24FLlYehFdFd8VVJ7bzs/Bs7HeUeziBCgneUpoUfvAmI5dxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 22:13:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:13:54 +0000
Message-ID: <9696596c-59cd-4d8c-b6a5-50977947e31b@intel.com>
Date: Wed, 9 Jul 2025 15:13:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 23/30] x86/resctrl: Handle domain creation/deletion for
 RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-24-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: deb6771c-2db6-4161-9f60-08ddbf35e4a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RVo5YVA1T3lNS01jdUhjOUZqL0s3Ui9pa2RXbWhCMXZ2VlhMeUpyRG5Xb0Mx?=
 =?utf-8?B?ODhlenBnRnEzcFlzd1BQTDFDcFArUTRVZ3BCNWF2NE8zYkY2TnB0QXI2Vm1L?=
 =?utf-8?B?UTVJL21sWGRua0ZDSUZPdFNjbFVwTlNYSGRJNE9MMXJYQ0VVaGx0YjY2NUFj?=
 =?utf-8?B?ZHQ2NzNqWmdkZTZlMkxxWTJQYm81aUM0b0tQUndPeURsb042ejdkZFA5RU44?=
 =?utf-8?B?eEJyaktHQXphd2RzN1hGOFFQblAxUTZrTzVRNXQ0anVBOFdkTzJaYWhXYXZS?=
 =?utf-8?B?MWc4ZEtMQ0pONGoyRVY2SnF5NzBXMllyMGl2R1NteE9CSmRzd0VYYkZTK3JF?=
 =?utf-8?B?ZEpEMnhzdTdYVExDUzU4Qmo1ZlU5MEU5WExET2RXeFV1OEtPUXNuWG5IUTE5?=
 =?utf-8?B?VDY5cGFRZElWU1AvbVh2dVFhUlBzK3FXL0Q4MUhZSGdJZUpuTWc0TngxK3or?=
 =?utf-8?B?Nld3dGN2WTFlUm1PYlptazUzRENYOHc4NzNXbG9Db3BWMWRFMkp4aHJZYnMw?=
 =?utf-8?B?c2xaKzBPdTA4cFp5WkJNblBwOUNoNGovd3l6YjVFdUdpRFQrL05xcVBqQzln?=
 =?utf-8?B?TTZ1ZVVzdjhsRkt6T3Y0OTI1U1NOajlXbXhjWTUwemVmNmg4b2w1ejdRKzd0?=
 =?utf-8?B?UVYwUUNvU3lxck5hSksyQ0QxNVgyTC9ZSThNY25meEQ2d2E2a21pTkdzbW16?=
 =?utf-8?B?VXFabWFWTnZDMTF6NkVXeks5bTlDbWdUeTBhWVRhSHhndjVoR0RSWVZhK1cw?=
 =?utf-8?B?RlpDTmJubW81eTVJdjhXV3VyZEVZYzU4QXBGd21Sdm9Jam1pV0Y0aTFIbnIw?=
 =?utf-8?B?ZGVvS09hcWQwWnRGc1BZOW5nZUE3ZDRlN2h5UzFSR1A5ZW5VclFqU0EwOEFR?=
 =?utf-8?B?RGE2ZzhnM29jTzRXNEhJZ2R6UXhYZjlRT1hDZkhWR2RYWUtVT09PT1FMV3lN?=
 =?utf-8?B?cHMrQ2NLSkJ1ZXhYcEtzTlN5bDdHOGFrUjhYYWZkcnEwOEhtVkFta3lVVksy?=
 =?utf-8?B?dHo0Z2ZKL2o3NWpVeC9rdUMzZzdXRE9NWEh4MGE5QXBzaHNtRC9GSStoVTEz?=
 =?utf-8?B?dTIwS01iQmtHNXl0TDBPVGdGc3N6cUFyS0lITEl0Szl3Q2Q0MS9heXdCVWp0?=
 =?utf-8?B?ajhWV0JwZGtOeXB6SG8wbHloUGYremJra29CYis2UGhNbzRjQk45Wk9yNlVz?=
 =?utf-8?B?SWNCY2ViOXByOHNZMjczTUFCMU43eXJ3QmFiQXJrS3FjQ1RYTFEwZXE4Yjh2?=
 =?utf-8?B?QTBrazUzT2kveE43Tng2TEM2YUxVU2E2STFPZmhOcVhBZ0xjMWZCTGo0T21M?=
 =?utf-8?B?M01BWXZHMDhQanluMWY3MGhxRlhVSlVrNVhSblJCeUorb2RCNmNpOEs2ZDNn?=
 =?utf-8?B?dnYvbFRZQWJLdFJ0TG05djJsUU51K3BZeEJXS1d1ZVNJeWdxRG9rakkzZ3Iz?=
 =?utf-8?B?bWxPa2ttbEpKR21zR3lKS1JwQlpFa1BGeEw4WGpheDFWK1FVeUovRXdkSFFW?=
 =?utf-8?B?LzRvZDdSeEhpUWdkbC9hSkg5UWEvUGs4Y1hEWEFwZURDMEtCcm1HcjBYQkZa?=
 =?utf-8?B?aGNMcCtROGVrcGRkcnBWZVdsM1dkVmVZT0pSTGQ1VTBYWHVuSFFLaVUxZ1lu?=
 =?utf-8?B?bGxwei9IbXVkakI2V1ZTOUJlQWYrWDNoUWpVeTJhdlhYVGczQmJ6SHNhSGRZ?=
 =?utf-8?B?OTdRYkxtZGVHbmNYaHlpMEdLSDJjTi8vcFdGTnpwRk1rUUQ4cWdEUGpXc2lV?=
 =?utf-8?B?N1JxMWZ5U0srMkdwNjhOb3lKWm5yVWtsamtuK2NlVEFuRE5lL2xIVXk5TTRW?=
 =?utf-8?B?TDBJeGFESHlKSzJuSW9CSkl1T0tNZWNZUTdCVDdYK2VoaFJSSzBOVTg1ajBh?=
 =?utf-8?B?YVNlTXRidzJrdnhFWUJwNjAzS2VURTVmN0tuOXFNZGpaYTFKejRiSU96MEVi?=
 =?utf-8?B?cUJYMjVpSWJna3ZJVjBFSWh0TTkvMTFlcllIV0U0b05TdXNJQlY5RWpmOThO?=
 =?utf-8?B?ejZINDdQcGJ3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzNmMDBDbXhWNFpzdkg5cGN3Q3FqR05WdjBBeDJuTEoydndrakpNM3dkQkcv?=
 =?utf-8?B?K05JenpvY0s4S2wzYTdDZ2V3aExyeGYvS2FZL0UwZGJRYi9LUXdSdXJMUVBE?=
 =?utf-8?B?bUwrTEErWHFZN3d5TGtsUnhDL2dQVllKZ2I3SDB5TE5uUEZES29rNVRyZmNq?=
 =?utf-8?B?SEdkcVZ5MXh6dVhySExTYitrdUsvYkZSNVkrRXFsWnVvR1p0bUpFZHNOdVFp?=
 =?utf-8?B?NHdaZit6aHd5c3hWK1FGYUpHNjBPNVdJNGR4NGM4T2YzTm0wME1JSTFXZlpl?=
 =?utf-8?B?c0x1SnRLZUU5Z1NGME1XRzc5bTVuUzhOVm94bnBwSlIwRkxaQ2dDZ1FNblNR?=
 =?utf-8?B?akFzOE1FK29odTlXbFdyL0lKd0IvdXR0eis3V0RFNnpjdkFsamtvVy9vUnUr?=
 =?utf-8?B?RTAzVFdxRmpkRVM5Y1ZRVmN0OXpvUnh4bmJOSnFrb1JKZ0hCTUNGMVVtNkRV?=
 =?utf-8?B?aElhK2JJWHJFYUJhV3JxaklGNHdaUFdCSVVVY2pJajMyVTFSbVdabWxVSkl1?=
 =?utf-8?B?eFF6VVJSdEdoeERWZm1QYXRTSURyd0ZaOUNZUk9mVmw2VzVZM3M3L08rQ1RN?=
 =?utf-8?B?NW5tWTA1azNuR3FxWTFKTGw3UHdUNGk3dnNRTE8waWNoUm5vSU0zZFV1NG5R?=
 =?utf-8?B?bjN1V0Yyc0tIRm9XMEszbi9qbUt5OWlZdVREUkZobmpBVlFubjI0cm5acHVz?=
 =?utf-8?B?NDl1M2hIbmR5RnJNRTRSR0cyMUl1MmpKc2ZRRm5oanlYY00vQjRFNXlaMGlt?=
 =?utf-8?B?M0RDZWtZMWtmOFQvS3dQQ1JXSjNGMVRPTzRDQXMrQVBlY0U4N3piQk9DV09J?=
 =?utf-8?B?a043aGZRTzZXald5bGVBdnFmdXVSYlVPMXR6V3Zkc0Jjd2duYWkxYUUzbzVO?=
 =?utf-8?B?YXRxMG1oRS9rRDBoM0U4U1poMzRjcjk1ZFZ6dnRxUnlsYjVIaGVuL1ZvK25G?=
 =?utf-8?B?RzdMTUtGL3pOaDk0MnI1NVJVa0ZsWDY1ejBuNzlqeGV3Yjh4ZmZMUCt0dDBi?=
 =?utf-8?B?am9PQkp0cUdvRkFUSUpsMGtqRGNQeU1PVVNDdllXeXFGb2lxTUtRb2I1UVVH?=
 =?utf-8?B?dkNvOEpsUkNWT1QrMmYrd2M1d0Q1ZitYTUtPWEV6Vkp6aXdsc08zMy9OK2ho?=
 =?utf-8?B?bWFEWHdhd1FHMWdOb21kZG5QSzRjQkxxeFNIK2l3WTg1enQrZEdvaU1XTHh1?=
 =?utf-8?B?Vk8reWR6RHJoQ2N3RTM0OXpTNGRFM0pMdVBOWUY1ZEcwRXE4Zkd3cnREdTg4?=
 =?utf-8?B?L3Q1TUdMcGd2cE9oZWpvNktPR0l0QmNteVBoR0JMMGJSckVYUW5IOUVNaDNE?=
 =?utf-8?B?TC85bWZEQ1BhN2xMTUJkbVpVS09ndlpQWk1lbWpXdmVud3FtdkZYcjU0UjQx?=
 =?utf-8?B?clUzdjZXb2J3SmVnV1YxclN1Tyt3eW9URWp0Wi9KclJmTUhvc0RyeGx0aTNQ?=
 =?utf-8?B?eVhmc2Q5Q1hBWHFQeG5VbXl2SWJoYXpSbndKSHF1aVJLS2JvOXR2Nzc0WDB5?=
 =?utf-8?B?WGgvc1pRWllsVVNhU3cwQUROYVZSb05wQ1lWWmNaajRhbXA5UlZxektra09K?=
 =?utf-8?B?anZRaHNZNDBGRjkyZDduYWIrc3NIYnJsRmlIRzZKWVNPaFMxQTZoSzMvMG1n?=
 =?utf-8?B?UFRSODR2UURYL0N3RU1mdWg3cW9JdkZhaTZ6MzRTbHRNVjliNmlsTGNBOXla?=
 =?utf-8?B?WWZzMGJmSWVSS0JMYnRBbGJPNE81U0N5TnZ1Y3kzK1F1M3gvb2U2dWtQblVC?=
 =?utf-8?B?YXppY3QyNWZsUHdKOUdETVB4ZTFXZ2VXOC9tQU9wTnE4S09oUG0xVkVJVCs2?=
 =?utf-8?B?aUxWUU55SXltTzVYc21Id1BUWWJEbGc3SEJlYThoQlZYYVU2T2lzWlBXUTdV?=
 =?utf-8?B?eS9aT0pHRWhNWC96cW5FbVNueFNKZ1VCWHNvdGN2WTBsTGdvT0NWK25QWGEv?=
 =?utf-8?B?V0RDNkIyaHRTaVMwM1lhYUtKSGQ2TVlOUHVqK1hXYnQ4eVhmZkY5N1Zxbkdq?=
 =?utf-8?B?NVM0eE56ajJzYm9uZUtmbU1hTHRTQXI0MTRoYUZTUURMZGNIUGJOZmF5L0d3?=
 =?utf-8?B?WHg2MkNOSzdTSDQvNUhQOE1oeW1rWFovUGUxdmlWNGMvTC9YMGlieTRtSkNu?=
 =?utf-8?B?eG5tdzJoTFZUNkpYUkVtSnI5dUJNb0VpV0JocDN2cTBGOWwxSnFMbFdqUVM4?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: deb6771c-2db6-4161-9f60-08ddbf35e4a3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:13:54.8508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMrFlzIAfQXQcqzUHhWMPdf4zInYFPZ7cV87RDvruxKJlfMIasB779n/dYACksXqRDf3g/mCTgNO+PfRKK08WrxQmuwnX4B//mfT+S7XdOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> The L3 resource has several requirements for domains. There are structures
> that hold the 64-bit values of counters, and elements to keep track of
> the overflow and limbo threads.
> 
> None of these are needed for the PERF_PKG resource. The hardware counters
> are wide enough that they do not wrap around for decades.
> 
> Define a new rdt_perf_pkg_mon_domain structure which just consists of
> the standard rdt_domain_hdr to keep track of domain id and CPU mask.
> 
> Change domain_add_cpu_mon(), domain_remove_cpu_mon(),
> resctrl_offline_mon_domain(), and resctrl_online_mon_domain() to check

This patch does not seem to contain all the changes referred to here,
there are not changes to resctrl_offline_mon_domain() or
resctrl_online_mon_domain().

> resource type and perform only the operations needed for domains in the
> PERF_PKG resource.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good to me.

Reinette

