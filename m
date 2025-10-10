Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5AD1FB3
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 00:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760055368; cv=fail; b=nDQNveEckplHHfK1SocUVtAO65zdEJ1fLQJZBDyxMYNnr6TAkfmg0gSNOVVsmCkVCPnN3sSqe4P+ju2/vvsGUg0xCq/0emioanY32FsgjH6ZfIH11hUSiDOvnkgNzOhSvc0AoK5DHv187PsuxP4gXLKJAuDOwu1QCmK2pDf7rXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760055368; c=relaxed/simple;
	bh=qDGFvKO2RthWluR0grYo8iMhYLjW60JeZExWlHoWGMw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qiAGO589pSijTmjooWw/zfiipiUTpFV15z4HV9ZhsqaF0hSQTBH0CdmI54kz0uFL9GpYYxd5rs8MMORSdZdRZJWTDSe2OMTnHUuBF8XQ2+poXixWSAHhJSK/qO9QAUgWXUkVgPUfrVH09LQTrMRfqHPcYp6GnYe2x1UyEF7iviA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y+SpWn/f; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y+SpWn/f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760055366; x=1791591366;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qDGFvKO2RthWluR0grYo8iMhYLjW60JeZExWlHoWGMw=;
  b=Y+SpWn/fP7RCW/kGRgnn7U5g5kaXubqJ2gGKau0Fc+NAaeHTiBa2dHIi
   A0+r2fJQ5B1KW597R+BJeHoG8sFyLGk4YM/qdyzoBsnQdVo8YOFoWD+uj
   ioKAXNpEbV75URTrYUIQvI9JZjlU4h8Vosfe3cEdvIHjLYSjlEwvb1izH
   daVxQk6vYx55EjukSiYNCyJywY8XIRVTWTH8u5pF8RHXzkXee7DKF52cj
   /7S/pNXrLzYfXA72zvnOlG2F6mWprU/oWW94qEQk/VzBl6HEkeVcqWJhO
   fIKoA4c7/meQLAvQdW5H27h6OtIHSikh/nsECi0+qkvSGJyZKGqn9YVkA
   w==;
X-CSE-ConnectionGUID: MfFrJBK4RDOrslfjbDeVPQ==
X-CSE-MsgGUID: k0MvqovLSrC0r/4x/xbASg==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="66131203"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="66131203"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 17:16:06 -0700
X-CSE-ConnectionGUID: 8heth+i9SwCcM073g//F7w==
X-CSE-MsgGUID: w1qCeBXlRQGF0wzGiJzvVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="186108889"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 17:16:05 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 17:16:05 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 17:16:05 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.17) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 17:16:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVTwWSXJ3YplkcmqyAdMoISHp/iTDzOwH0/+0flg6bHO4X6juEdvWmnJX51+cwHhPvTmu3AbREJYc7CUBu5qEeZRcJWjtZBNFQsUQ47KXHPt4J3om+utS8wM9r7mBHls/MNtZ+WaM9nCtizF0o4iJ3AcKmzKq6e3/0YEUz/A78QkZaDbH1tlWUbGvQSFdT8tgoCsJB6NIaKc70Hz/idz2agIDxNZiEcKw0L2x4z++wSaRhn51wq3NNMXDM2gQXbFx3oDEfq9C8VNoYHa/0HtRhCcs3Iwnzbdk3FBa9RNRzPpZ44j0vz/W7rzzPvt3455CNyaT0/7xs/R1u+svOJ4mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HerPKCCWjYkyCp3Z6crAEYcrrMM159OuqDQIC/qL0Wg=;
 b=FxXnYhsXwB7q/4zaBpIU1kNo5eXkm5WWj94jj8y/aHaxb3shml9MCe4iaTdabC0sfhV9JolOOpRxYH4+zQqH+y15zA/Ja7zSkEoVaPCwuIMZw4152HEJzSLsTtbRyx/KxhO0bHL5qBU79gaQs2z4bcsRUYR35LRXE7D876k3jRtz/sjh2TAXqaCkC0BHKGOW5Loc38qtmHelRuXcyy6H7bH1+4RuQDI494THZV8SFMbJ6gvo8KaqQqZiPyolb/kuyF92t7v10HFgAkNLYBxraAACZeR7PPwv59bwR54Bw6DAo8DGkql9Up04R36P9WusN5g671vl7bk19t6DElzCxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF496D5EAB2.namprd11.prod.outlook.com (2603:10b6:518:1::d1c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Fri, 10 Oct
 2025 00:16:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 00:16:02 +0000
Message-ID: <21cd6535-a51c-4a8a-9e82-328b03a8fc40@intel.com>
Date: Thu, 9 Oct 2025 17:16:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
 <aORMZ6NUXMpECHU6@agluck-desk3>
 <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
 <aObUZU8rnWIDR_tH@agluck-desk3>
 <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
 <DS7PR11MB6077A0323678A68DF5878C0CFCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
 <e536ea0b-c466-4381-b92b-993be92fe65e@intel.com>
 <aOf0yA1AWlzJLf8H@agluck-desk3>
 <6778a8af-5312-419e-a064-bcb6a495a207@intel.com>
 <SJ1PR11MB608328747C28F736C6DD5FCFFCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <1ea9cff4-e93d-4be8-bbe2-308fc05eb3d1@intel.com>
 <SJ1PR11MB608302F7FFA34D93EBD77640FCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB608302F7FFA34D93EBD77640FCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0316.namprd04.prod.outlook.com
 (2603:10b6:303:82::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF496D5EAB2:EE_
X-MS-Office365-Filtering-Correlation-Id: b37d4b84-362f-4a17-9561-08de07923207
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RmpqaFNNck1IQ2xmaDZNWlEvVWk0TFhUZWVLQlhEMDhXbHdwcWJZbTFwMjUw?=
 =?utf-8?B?UCtaWWh3VWpXdmhPaEwwUXQxZWtha0ZPMHBwcU5zZ29CcFNEeUNzS1JIc3Fo?=
 =?utf-8?B?cDVtTktja1pnb0FCQnV4QmpEa1l5YUs2UEJ5ajNjYUhkckYvSXQyYThhak9Y?=
 =?utf-8?B?c1ZHMXBZV1pOb3dmYjdGcmU1NXE2UmJjL09GcXl4YnFuWWljVVdOOGpUWVky?=
 =?utf-8?B?Y21rWGRRdGo4MW5GZXlSb2pIK1JqUTgyL2k1YWJQWUVtc292L1FYVjl2ZlB0?=
 =?utf-8?B?R0h1Q0FWQlppRm9kU1h1cU5JS0tjb1lIZ3J4TlFmYmZBRC9OZUgxYkViYkNx?=
 =?utf-8?B?Z1owNS9nL0xhNHpJZWpJTkFIMm1vaVZ6TlhqN2dLNEhMTUxuN0x0V29mc0h5?=
 =?utf-8?B?L1JDSWY2ZzZFTlRYR3pIZUM1cU5lWGFCWGpqbmRwcmZxRmg1YmcrY2s0akhO?=
 =?utf-8?B?eEE5RjY3VGI2S215UkhYT2lObkFiWGVrbEd2SjlDTnA1NTIwOERyV0hqOU1E?=
 =?utf-8?B?SkkxbTBxWU9odmVZZERUL1NnRHdFTGszalBWRUM3M1hNbndqbUVRR2pJT0c0?=
 =?utf-8?B?RkFKUHFFS2t2TDEyelBzenFCU2djZ1BNemdMY0JLVDlmWWVjTkpIN2ZWWEhu?=
 =?utf-8?B?TEtnU1MvVzNJNmlla2tRYUY4bnBIYk9hakRQU3JJKzBmTG9EQXhFWkQ3T01C?=
 =?utf-8?B?TU1YZmpHQU81a1F0a1BIemRIQ1dtTWN6N2xKcTVlWm41azhRYW5tcXIrNllW?=
 =?utf-8?B?VEdYLzF3NmhJVmw5MGRhdWw1dlFoR29OTWY5UUZkMmpJYzRKeUlBQnZiWlFz?=
 =?utf-8?B?aFZ3ZE5UMEp6UHBZcFgyRFlIcFVGLzhQV05FZnVTWW1FR3ROa0NkTjNrbFNN?=
 =?utf-8?B?OXRzM2xXYUc5VU5MZ1VNSEU4ak5iV0RZajBQT0F1STYvdlZici83ZzU0a3Fj?=
 =?utf-8?B?eU81Zi84dlo0a3AzUURGOVBidmwwejQ5S0xZYkY1NnRzbmdwc0dJQWJaMXFh?=
 =?utf-8?B?ZnhuUTVOMDRQQWNjNlk2TjZpOHdEL2syN3I0b3BKVWY5d0kwbmVDYlp1b0ZU?=
 =?utf-8?B?S2FETTU5bW9yOE4vRzNEQk83TmtqdW1rdHd3MjladTNURUxZL2Z2enhLLzB6?=
 =?utf-8?B?dWxvYTRKMHFlQnI2ZXVGdmdFVVlDRzdLUkE3ejYrVTkrNXBxN1V0QngyMXRk?=
 =?utf-8?B?OGxHMURDK0IrNGlQNjVGd0oxandIMlIralhhbnpBOTk1cS9IRUxWekwyRkFv?=
 =?utf-8?B?WUZkUkVXTGF0bDk2d3U3TzllMlp5Y1hZaGNLUTlzS3pxc3JIRGJFaC94YUU4?=
 =?utf-8?B?TlFOcjJUZzJybVJLVG5ZUExGRXhwVXNCZkdrNHkvWVRCOXhnZ285SUtnazM1?=
 =?utf-8?B?em1PbzA5QVNsYWpTZlhCcjlNdFFWV1JRN1VvRkxkdWpZWUYwZHd6V2k3dUdx?=
 =?utf-8?B?aTRpZUxpcnBWQlZvdmpuS01vYmpNQkllT3g2T3FTc0szUUJoS3krR09BdVZW?=
 =?utf-8?B?Y2E1WVJvRmd1d0MzbDRxQ0JHV3gwalFmcHFIczZqc3d5cE5iQ3QrNEsvQkpU?=
 =?utf-8?B?d0xkSjJXMW9LNkxFaGRwS29wZVFLUGgzbGIzT1UxcDF0VWZOY0I1Q2xJdU95?=
 =?utf-8?B?TS9jU3JBcU0wdDZkZlEyaGFPbE5KbGMzUlVHL2doZWZIRm1LUHlQRjl1MG4x?=
 =?utf-8?B?SWhuUkw1MHhZemQ5RUFaSXJ4N3JsZzZ3akgvaHd5aFV2aVNCVFdjQWlCNjZ5?=
 =?utf-8?B?QklGK0hjNUo0RG9VUW1YOUIvNXNGQjFteEtON0ltM3NZV2JIVFBVSE5DdXFs?=
 =?utf-8?B?UWg5R0FpNjEyUFZ4TmI5T3N6YVlyWnFxcVZzdVVMcjFvRDVOOVJaVjR0VmlL?=
 =?utf-8?B?VkFhNjlWSGZTL3RwVEFhMG1kdnhUTUFZdVYweHJjTTNiNUllcWJqeVlvYWtl?=
 =?utf-8?Q?BGvWKxSJCyc/1RMhwAYTbEhDF4Mk64eU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2d2cXZxbXlBS2lNa0R3RFhXYzF2UnlscXdXYk5EdC9UUThwUldOOXBPVnU1?=
 =?utf-8?B?UFdHdDFMSXNjL3FPc1NLMDFaTjd4dGRHT3BnZjAvT1dYY2RYTFMyTkJhdHZm?=
 =?utf-8?B?ZUVINkdEMEpyMmhudGM4WTNTZE9UWit0eGZIMGhpUUhhK0RUU1VESjFpQnUr?=
 =?utf-8?B?U0RjR2N5bWtpdHkrMjlJNDBFNm5yZHVNUWVKQzdncFlZNVRQM1l4MGNkT2V6?=
 =?utf-8?B?UXRnWkxxcDlnVVk5THBTTUgwOGk2QmM5UVRzWFJXcGpmTHk2dHNTRmsyN0gy?=
 =?utf-8?B?Zk5JM3BTdWpyVi9YSXFwM29Xc3U2SzMzZHEvU1htS085UzdZWWRLTHJqWFJZ?=
 =?utf-8?B?NFFWbzd2LytZSExiRlNEMDZUL3hONGd1OWN3V3hsa243cE5MaU13UzFFYkww?=
 =?utf-8?B?VXdhUkhlNWZvbXZDZjRjV1ZqL1Y2aVE3WXpZUVkrWjlMbWQ5OEJyNDRhSFRZ?=
 =?utf-8?B?Z3RUcVVKWXM5ZWU2QUhockNTOVNzTEp0bERPa3k0TTkyV3VWZ3RLOWRjQmEv?=
 =?utf-8?B?K3o3TzhsbzJwSE1LRWtFdXdqTDErTDMwSUlPWTQrK0thakxqNUptdEZSOHM0?=
 =?utf-8?B?elJHeDJqK3VpL3lRSUU3ZjdrUzJVLzE4WHZIZnJTR29pNnJpQjU5T1VZOVZN?=
 =?utf-8?B?RnZaRWdjZE0reEI3bjhCOTc5TDlDYjh1eW5DOTVTcXVuZ2htRXRMOWdyVjM3?=
 =?utf-8?B?djZBQ3ZYSXlwNTFtWWQ3NFBNdjhwMFlhWGI2QUtyTlFxdHNjRjh3citvMmIr?=
 =?utf-8?B?SjJoTUFCNEZSZ2IyeWlWNjZjd0J4L1hKbnlQT21wTzRvSU1rVWpQeDg0d3p6?=
 =?utf-8?B?ekJMMUdGVjZlMHRBVUZWWkdTQUQ5eWdpTnRUdklGbzNjeXVpMzFoUS9XOVk4?=
 =?utf-8?B?N2liRmc5d0JTcFN5WU5UbXVIRzYvTkpaNSs0cnRJRTVGREoydHFQZFJyYnJF?=
 =?utf-8?B?YlFvNms4NG1IRHErdWV2K1JtT1plY3ozRk1sOTRPUzYxYm91YTA1Szd6WkZP?=
 =?utf-8?B?MGpCWUVSRUxIUDVyM281SkN6Nk5NMTQ3TG54NzFrZ0J1ZVlWQWxndS9MTkdL?=
 =?utf-8?B?MEozSUF1ckVMeStTUm5HL2dmZHhOS3Nqcll6bDNnYWZubm9oTXJVUC9INTZF?=
 =?utf-8?B?NVdDWWRHV1RWRGUyKzNTWDdBVjJkTDR3ellNN0dreXVReTBSeVdhM2RHMnZq?=
 =?utf-8?B?bzZva1VGb2svUG5OR2FGdWxyeFhySnYzRTFhRSsrdEYyOTd4MmdJcE5XOHFq?=
 =?utf-8?B?aTR3RWRzcThNV0doT2s1SVVwNThKMG9WSWlFd094UC90TXhtdDd3a0NMS05s?=
 =?utf-8?B?bUhYRXo4ZWhISDhUbHI0bjBqRmp3eWF5MUV0clVnelFRbmNMMG9wRUZWWTlh?=
 =?utf-8?B?RVpMNzNYZHZpRTVEMVFVMGlmaE9MNzd6ckJxc28wUXp1NHhHcjVGYUFZOUo5?=
 =?utf-8?B?Nm5oNENJeUVJd2dqcFBvMjRwTHA5ZFdvSE82UjB2S3FYaVNxYUtvVnJua3dN?=
 =?utf-8?B?SDlCbUhLNW56U1RtT1Ftbk1zN2NxVFBSMVBVNWsxNnJWTVVPWlIvWG5EbGFT?=
 =?utf-8?B?Nm5kdUVxOWJLSm1XelBqT2RKZjdqRmFQYUFVWitDSUgzbVFKMnB5czdKQ3kv?=
 =?utf-8?B?RlNjUUV1ZGttSDhvTys4TnZiNTE4MjE5VGtHSTlTclU1VmZ0VDkzdHNocUpQ?=
 =?utf-8?B?dkVRanlVSmVDUVFscS9MRXAxWmRSa0dLQ0U1SXRlOHdiQThTdmZ0bGJlV3hr?=
 =?utf-8?B?NGJjL0tvY28zSkRlYlhNK2toeGZPbnJMZzJlaVNFVUVoN3AxZ09GZFgrNU00?=
 =?utf-8?B?Y3dNdTRLaW1mdVcrRXVUai9QUU83d05TY0RPaWU5VjFLMGJGS0tRT1lDTFVH?=
 =?utf-8?B?bTZYd2tCK3ZHRGkyNEJ1dk11NXE3aWlzY0oxL1FrTTdEWWVFTGoxdTkyYTJv?=
 =?utf-8?B?WTFqWXRXcENmcDF3SUZsRXloVloyVk4wZ2IzUHhIMlFRSDY2MFVzaFFwUnRY?=
 =?utf-8?B?WGJHZGE5Q3hEd0Y2VUVVTXh4L1hmN1NuRUh4dDl0R0ZoMi9KTCtqRUlmenVj?=
 =?utf-8?B?MHMzclVTbG5KTjZXU1MvdGE5YlBYWXdzc3k2QUlGZkkxbWM5OXJKeDBpQTcv?=
 =?utf-8?B?Q1F1WGJ2NU5jWGVZeVI2bjQ5QmgrUXZnTEpQanB3T2xxNWlZYzZMenVETXhN?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b37d4b84-362f-4a17-9561-08de07923207
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 00:16:02.1451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mXx6jdKaBT1AgHlCv4wKaUJjQwl7p+MvgEbiYCPQGCZHLHto/bN4NuNYT6skEH4qsL4Hmn3210Hwd9YFLnLYnE1H/XYub7la1Lln7RfZvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF496D5EAB2
X-OriginatorOrg: intel.com

Hi Tony,

On 10/9/25 3:08 PM, Luck, Tony wrote:
>> I did not mean to imply that this can be supported without refactoring. It does
>> seem as though you agree that mon_data::sum may be used for something
>> other than SNC and thus that using mon_data::sum as a check for SNC is not ideal.
> 
> Reinette,
> 
> Yes, we are in agreement about non-SNC future usage.
> 
> Is it sufficient that I plant some WARN_ON_ONCE() in places where the
> code assumes that mon_data::sum is only used by RDT_RESOURCE_L3
> or for SNC?

From what I understand this series does this already? I think this only applies to
rdtgroup_mondata_show() that does below ("L3 specific" comments added by me just for this example)
in this series:

	rdtgroup_mondata_show() 
	{
		...
		if (md->sum) {
			struct rdt_l3_mon_domain *d;

			if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {
				...
			}

			list_for_each_entry(d, &r->mon_domains, hdr.list) {
				if (d->ci_id == domid) { /* L3 specific field */
					...
					/* L3 specific */
					ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
				}
			}
		...
	}

This seems reasonable since the flow is different from the typical "check resource"
followed by a domain_header_is_valid() that a refactor to support another resource
would probably do as you state below.

> 
> Such code can be fixed by future patches that want to use mon_data::sum
> for other things.

This discussion digressed a bit. The discussion started with a request to add a check
for the L3 resource before calling rmdir_mondata_subdir_allrdtgrp_snc(). 
I see this as something like:
	if (r->rid == RDT_RESOURCE_L3 && r->mon_scope == RESCTRL_L3_NODE) {
		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
		...
	}

I understand that rmdir_mondata_subdir_allrdtgrp_snc() may look something like below
but I still find the flow easier to follow if a resource check is done before calling
rmdir_mondata_subdir_allrdtgrp_snc().

	rmdir_mondata_subdir_allrdtgrp_snc(r, hdr)
	{
		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
                return -EINVAL;

	        d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
		...

	}

Reinette
