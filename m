Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40154968E3
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784042339; cv=fail; b=dh/ID0t9dyBLoj9qZspaq1Hr4kifCinmUmly2kQ/jId8//3NToRhE00NRWvlZMEuF8Ad+VCWOSul2e57/ZTj2UBBWmTHaVFpgwTybdux7zVoZEfLLSaLwlpo8ybRKjh/hclUq/eEsxh7u6kgJUqi2liTDtM3OG349Rk1BVCrkoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784042339; c=relaxed/simple;
	bh=H5bNthqLAA8hGcGr8gRQIDPex3XqpKACl8/RQo5LYkU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BhYmyhigFyzmrnbPc8Mj/qX1dz9Cgfd32Dbrl0plDGUCUBw7HVTBKACcEakOmAmE7L5++7phSiAtaQiMIJjwqMRoveUAx7RWCSu4jPHtyxABx8MlcOi7OzjvIZq6Qwe8wno6Vhy7+KfwIiWjwXHdXzbjnaJeg+iT22e9+6Zunmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AybRRRk6; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AybRRRk6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784042338; x=1815578338;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H5bNthqLAA8hGcGr8gRQIDPex3XqpKACl8/RQo5LYkU=;
  b=AybRRRk6bafnEEKjKH37N48hjXldS01pZE127ZWx4aZ8CjkZ9rRMkvNg
   mihEtBRswaOLy+HSYEjtynyZTuhvMt6wXdQFjTJ1XVTD8W/lNe9KK4PyQ
   Lz9nvVjeiVSH+OZiJ9byNObjkGdem2VpT9WIKpovxh6nTAczKPSbgIIwu
   N5kqVt5S/1/XQTMnOlQpIOILPiO4WwrHzIQLA/dlNs+/JL1ti8yECHjpf
   vQYSzbrcUCtW0IlkFZVFkVf3Q7Ug54l5V0vVLOk5tcMUtJq1wQDyDXL4I
   cC2vbPn+VzxSSjQLZgFAO1VSL31TGZtZyI9Siq1Idvewm7N4+XCRTPTnE
   A==;
X-CSE-ConnectionGUID: Laeg/F4wQGSCBZfcQTIHug==
X-CSE-MsgGUID: sYfQpfkYRqu5yjOdEBi6fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="102221216"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="102221216"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:18:54 -0700
X-CSE-ConnectionGUID: Jm9BslTER8C0wDkHk2/fgg==
X-CSE-MsgGUID: V9zuRQZGTrKiViu2sX+WLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="254144452"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:18:53 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 08:18:52 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 08:18:52 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.65)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 08:18:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kuk8Y02AwTiXO634XnAaMWfZDbIxBWrjjGvp2XYHmGRB0vdjRlZJebJvJzXnBA2HLMaONSB94jgjdBydjlmzj2k27C9dukmWWF4y0E5cg+omIZuUAFM9y6GmuIP+OdGHFH3cW/h05nRXR+lK1bkyCZIHqGk/H9ZWBDYvlRZE+bPDuRiRx118CCNczr/YBOBsLOPPYUj2eBrI8IuYjEj9VofsHFOnZ8TX6cqdXT2i6Ig7r3sWxWbB5L9gcf4MQNXi1Acmk5+O/7Pv0n4K6QCI+dDt3scBPP7xOeVG4gg3mSnjCxtJKqBg/ER/vMwQoIdZ9jqzkiS+pa+QaelOO0Y+tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sfjjQp8UfDv5GBeAnMARE96Ld5QiBS3omcTHDOlc9k=;
 b=gUthImOWbcQpRs1VEw0Q/uVjh5XsPxcxR2Ft75I0awGGcgf9OLC5BrCX2cmPCIfZSZ9A3UuX2OCykxS6q45UcYt4/mz9ils2gqQDpQkDXjHgcA4y01b5hteXjOMWU5vwO5T5BUNbRn4tns7m8YA3Nej+qwshKgqDCMAgmPAuhcz1gssAqyG1EQ4PuRLJkmka7BQDQJaomHh99IjgXh1nwIbPv45izfysxDZn1Yt4OClLxpH8da9plx1OVz57HNL3bOEc81MVxfLxXwuuQKweKCyQhZNAdrYAj6fCIZKMuco52pr1ROgMvqM05tSiluQlshsuJNGmQbkPPl5XzdVeBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB8090.namprd11.prod.outlook.com (2603:10b6:8:188::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 15:18:49 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 15:18:49 +0000
Message-ID: <6cf66f70-933e-4b26-ba80-83222fac17b1@intel.com>
Date: Tue, 14 Jul 2026 08:18:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/12] x86/resctrl: Add PMT registration API for AET
 enumeration callbacks
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-8-tony.luck@intel.com>
 <b128216b-cc06-4e6e-b6b4-498a6e135d16@intel.com>
 <alFcHbGmaDXygQpL@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <alFcHbGmaDXygQpL@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0163.namprd04.prod.outlook.com
 (2603:10b6:303:85::18) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB8090:EE_
X-MS-Office365-Filtering-Correlation-Id: 094a059b-c0d5-4685-b41a-08dee1bb349c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|6133799003|56012099006|4143699003|11063799006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: KmvG+xxjbXQ+zmnmBKcU3maLiZxZOEFWVnBxjla9u8qn9Dw/iVkggUqt6qlBM33FrLWt7lcc9Tw8XpknjwhbZN2u5XCi2RoTqqW9lZP51jlD3Y2WAwhx/yT20GTQ03ceBaWLKY4x3iKxdFh5eI4D2Fafx+JRz3W3Lmh+FnFuy6U+UdWJIFj9G4PQS1iR1nkBX6KtodC87JCJuhaGkwSJlnG1LCPoDR7RXJT82rMNDBVulQZPG5xX0XeRtqEjI3exeJjEaqhJN/QzXnIqlvShTbVXnGNyiaEhstzJmouD4533hlTFEv6zpTu7OvwttITvOj8I1zwhtr7eB2Of0+pU0pxKCq6/fJc4GFgOhVTbD7hfo8BIi8uFTl+BCT49waBNb+dt00jIMJGBE9susGviLt3EqFwyInmJPoC4PPrKhKqW9q1WXMD6YzfJ4j5lXGIrOaJeX3wD/c+43TsF+v32Vg/PeXYgTypp/Eb0NhCUwonisyQlCr3ZaE3BV5AOCDbgkAe3y7/ceA0RJAfwPc6RndjeUoSX5k7JaJfOSvcAW2/HTZS8VnPUyD+cjn7CP4lxxwuRU7i3DLmXGFYQ8iiZo/JSso+4eyET2W6ytaaBhCD7+BUDWI00HIsXJ5gC19BcmoyV5AzQKlzExsZHCYRquMh/Ke9QoNCHy7byzjs2quc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(6133799003)(56012099006)(4143699003)(11063799006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UExQeFk5a3E2L2FmUkFDNTdlU1NSSzB5SitwUjJMQU9YMDQ4c3FLM3BZSkl6?=
 =?utf-8?B?eUJ4WHVBRTRtZW5yTUEyTVVwaGkxZVgwRnZZY0VmWlBnZSs3Q3h4elJJM1Fy?=
 =?utf-8?B?dHRXV1hheGprNStsdVNzWUY0bXZIZEthREp4a2M0TGxkajhmMnU1dWhTemFr?=
 =?utf-8?B?c2U4ejJNa0pjOFRSR1FpcWJSd1V6OUJhNElIa3RYa1hpNjlTbEpHVG1Oc1My?=
 =?utf-8?B?TE9EbU9leUgySW5UR09NQTd1ak5iLysrNUk1bVFDRVkwS1lSRjgwSEZwbFdv?=
 =?utf-8?B?cjYzVHlCaTZ5VGVhQ01jRmdCcUowc0xjdmhpbFdybHgxdHB6L0trQUM1THgx?=
 =?utf-8?B?NG0vOWRlMWhoMGNXWWpHU1JhUitpQkQrV2lwRFlzaWgxZ0NVVHdhUS81cWxB?=
 =?utf-8?B?WFovK3E2UUZpdEhtMjZscUoxWWxudWlJZXZmSXR4WEpWdkVDNStxSlBsVnZl?=
 =?utf-8?B?QkJnR3p6aG1QUHJMRzU1M01MN2NRb1ZxTUtYZkJxRHZHMlQ4ZDRZbUtMUjRU?=
 =?utf-8?B?Y1lhTkMxOWFQcys2RkNSSDY5ZHZUR05sNVRtNEF4cThpQUsyUjNrMTZhSmJK?=
 =?utf-8?B?Rk5hRFl6aXdXKzczSFlNeHRRUXM2ZXFmWjRvQnpUSFFqdFcrc1phNmJvbkUx?=
 =?utf-8?B?bnQxekV6VmlpSFpJNzVVWGMxdm1razFBWWpCVkJKeVdmbU9wcWppL0VUYUVR?=
 =?utf-8?B?cDZwVkZFRVMweDREOTBnbWJJWit6V1NpOHVGa3RTVXJCK1FsaXNYSWVrMU5C?=
 =?utf-8?B?Y2VrQ3JCYnF4aURNbjRucDlULzlQWDVwUDhmN0VzMlZIWWlZS2tEZnFTVTZP?=
 =?utf-8?B?cUhwdDJRYVJJV1RDT3JXQ0xlSGZmV3BnbytXVnFvS2k5TkFlaHI1YXRLT2tQ?=
 =?utf-8?B?ODZJeCtMdUkwZzVVUU5YbWNGYjFiNlZIR0hiZGNCRmVwb00zd0x1dFF1L0Zy?=
 =?utf-8?B?YXFJekd5eU5oQ2hwVjRSQXJpSkZYTXZ5bEtMZ3hVaFJwUTN3MkFEN2Vya3Iv?=
 =?utf-8?B?dFprODc4RFJHaitLRXRTSmNod1JvdVpDYlFjTFJ0MkptdjZRTk5YOHRDNEtC?=
 =?utf-8?B?bS84SXZFN2RmVk1TU0EzUzA4ZXJTQ3BKam5vTVhYMkt5U0VpUUM5RnNWYnpX?=
 =?utf-8?B?MTVXRkRaaUxncDlvRm1QcUlGMG1DTUFVZWViblgxRVpCSGJPcHRGR0dMWUdl?=
 =?utf-8?B?WGlZRVFiTG1XSmMzN1BwTjRsZFppVHZPNkFaeE1kejI4a2h6VmF6dkwydVU0?=
 =?utf-8?B?dEJ1Sm5RVHRpNmd6UXVGaldWZ0pHU1BCM29SN01uc09CZ1hZdnlsRnZYVVFR?=
 =?utf-8?B?aU1SNnYrTVZLaWdiK2d5clJ3ajBKaG5lR2FqeE9wc1k2VEVTLzZqZmJldGcz?=
 =?utf-8?B?N1RxalNoeiswNkdnMVEzWm1hY0RhMGdlMjQzeGFtUlVkSmdtMU9GVVN2OFJ6?=
 =?utf-8?B?T3lOOUN1QnlKcDBSaEtsUVM2M1h5dG5ZUE42TllwWlF3bnZnSUJHMi8vczBY?=
 =?utf-8?B?SndGamRKVGd5V1lLcWZOZW9abmM4MlFlOHBnMyt6dXFGdzkyQXlwWkJLTmxK?=
 =?utf-8?B?MEVkcVN6S1JGdjkzdFYwbG9oNTMvSkExcWt5ZUlJT2tTQnRaUzFoRTVLWmhP?=
 =?utf-8?B?Z0Q2SWs2d1ZXaXJZTGVFc09ud0Ryd0ZxUUV4NG9hTnRGc0pxaFVIazhITjV5?=
 =?utf-8?B?R3pKZ3VJQUUxRDN5WkVEOEVRSEQwYkw0Tjd6SUR1dkxSQ2xHN2VtbVo0bnRX?=
 =?utf-8?B?WmtNL0M2aitPR0ppMExicFFNb2dFNUF4ZTh0QkExSVFhbjhLeDd1Rzl3UGpk?=
 =?utf-8?B?Y2JUVmJuaGU5WElkK21NYkFXRjkySkpUVGQ2RWVTY1NpUnR2aG1SbGliaHdi?=
 =?utf-8?B?c1IydHQ4VGprRnR1Tlc4SGw3YjVjTjFkSUN4dlZYWms1L08rRVV4eUJkUEli?=
 =?utf-8?B?cUFMMmluR2o3MnI3YWZYQ0FSTGpoYWZjTmczU3VzMEF1eElkQmdBMStNZGhD?=
 =?utf-8?B?eDRkcFZjcUl2YzcvcHRETTNnL1p1WmFVQUwxL25lU0FCMytoMEpoMDRibGdv?=
 =?utf-8?B?amFTTVViNXV5aXk5RVg4Q2p4M0NUaWFzbGY2NXRXYTN4NVJVL2lqNW9IUU9H?=
 =?utf-8?B?T0FMZXdhekZXT2VnRDhHaEFPZitwZTZ6MkZxclkwNmhsa0ttbnJHZTZ2dUxy?=
 =?utf-8?B?eEhxS3NCbndyTjFYa1VDUEU5N1RpQVhsV0hnaUp5bzBCLzhBaVArYmxrczF1?=
 =?utf-8?B?MFRsUVByOGNlcXlOaG5EQmJ3VFhRVU9WeHhnUEJXUkhhR253R3lzVWFGRWZO?=
 =?utf-8?B?QWxWbFcxT0FsWjc3VXRuRlcxQ3JLdUZ1S3JqaURPeUcvVGVTdkVSYXhqUWl0?=
 =?utf-8?Q?CZsuRet6fRnHmI5c=3D?=
X-Exchange-RoutingPolicyChecked: sh2Mk+lhWTSxU2tkHYV219nCscEZmB8FYVFrVvllWQjEtRJsS3yZgD1QmhJGS82W+UfjRYlczxzT1uummcuXnZefNw5CUlDXruQkoQu2tZbogEN5e5PRLJcAUvGjfNGB1ka0ZFqraMJ4xdeeRhVNRw+l8G9BKH4ApG8Clfr+KFzi+Gc2c0DpZVr5KGnkRxIitdTG5X9eN7rKNbRI+6JwODHIg9bK2JQ5b9WgsdiuVALorA423NS0njtZocHJE6fPQb9l9r93IBrLOBfg2vsn049qS98LMMU6dqKsCDVv46dcZphtbpCX/pT/e27+kY3NELV0FBvSMd+DXbpWBFKh4Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 094a059b-c0d5-4685-b41a-08dee1bb349c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 15:18:49.3991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: weSbwtVgD8Y9NVDlrXrWJETNqbpIGfNqexicXr/pLz8Kl8tGFQSai2VbKsi007kiJ4x0XnJf4LBgRw5p2f7q9frA1+nSQhAgJ/9MXZhEkzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8090
X-OriginatorOrg: intel.com

Hi Tony,

On 7/10/26 1:54 PM, Luck, Tony wrote:
> On Wed, Jul 08, 2026 at 03:51:22PM -0700, Reinette Chatre wrote:
>> On 7/1/26 2:35 PM, Tony Luck wrote:
>>> resctrl is always built-in; INTEL_PMT_TELEMETRY may be a module.  Add, and
>>> export, register/unregister functions so the PMT module can supply/clear
>>> enumeration callback functions when loaded/unloaded.
>>>
>>> Suggested-by: Christoph Hellwig <hch@infradead.org>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>  arch/x86/include/asm/resctrl.h          | 22 ++++++++++++++++
>>>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
>>>  2 files changed, 56 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
>>> index a9f481b7a8ed..48ad55bcda66 100644
>>> --- a/arch/x86/include/asm/resctrl.h
>>> +++ b/arch/x86/include/asm/resctrl.h
>>> @@ -4,6 +4,8 @@
>>>  
>>>  #ifdef CONFIG_X86_CPU_RESCTRL
>>>  
>>> +#include <linux/intel_pmt_features.h>
>>> +#include <linux/intel_vsec.h>
>>>  #include <linux/jump_label.h>
>>>  #include <linux/percpu.h>
>>>  #include <linux/resctrl_types.h>
>>> @@ -189,11 +191,31 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
>>>  
>>>  void resctrl_cpu_detect(struct cpuinfo_x86 *c);
>>>  
>>> +#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
>>> +void intel_aet_register_enumeration(struct module *module,
>>> +				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
>>> +				    void (*put)(struct pmt_feature_group *p));
>>> +void intel_aet_unregister_enumeration(void);
>>>  #else
>>> +static inline void intel_aet_register_enumeration(struct module *module,
>>> +						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
>>> +						  void (*put)(struct pmt_feature_group *p)) { }
>>> +static inline void intel_aet_unregister_enumeration(void) { }
>>> +#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
>>> +
>>> +#else
>>> +
>>> +#include <linux/intel_pmt_features.h>
>>> +#include <linux/intel_vsec.h>
>>
>> Are we sure we want to include these in arch/x86/kernel/process_32.c and
>> arch/x86/kernel/process_64.c when resctrl is not built in?
> 
> I'll look at this some more. Maybe this code needs some X86_64 checks?
> 
Some forward declarations for the needed parameters may be simplest. Another
alternative may be for include/linux/resctrl.h to get a section for definitions
for when resctrl is not built in?

Reinette
