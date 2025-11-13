Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3CF32693C
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074313; cv=fail; b=s8BDNdpOSrD+8WC5vD1tnLVxeWm2WHcRgGuts0z/qACZbyppPLD1tkvQHqWpRODjvNTwvz2Y5P4mcBTWsPVrA2bxUD7koXYvRfFiyYwQ7ZNzjMxa1gGs7tKqyw6mFY8nLBvVEhexDzdnzHhPCYafUB9BasiipA1L1cFKvnP/ZEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074313; c=relaxed/simple;
	bh=6RYDVNqVhrHzwA/oOUNfTirIil5GfCqY6NSFg4v469E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TnVjFin1pi+ryN+saEV/kXDAVFCkm85LKVS/hMaaXFe2TmlGchXs1ymCULJU8qLQjhmZlctorQzPSsMqhj07SHVP2tG+G0i55/deEbLGk5k7MPAMqnoMzp/Ok72oZOorEtXalR/I2PcPPA1g3OX/kdD+nrmK7YPurx1WXqErsYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kdv4q9Zl; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kdv4q9Zl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074311; x=1794610311;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6RYDVNqVhrHzwA/oOUNfTirIil5GfCqY6NSFg4v469E=;
  b=Kdv4q9ZlUsNmjow19rNrc5r40aOgq8IJ2Mc3bUkMnKDym+szU2QWWeKZ
   p/6pL8WXA078ImmuIwbRFpDMO9/I9cCiUMM6TVqDxJnb22oFkl+eDLuEv
   ibwnBTckA4gJ+IP29qoq4PzGBD1YyDZdHbi5QzEQuB4RLxCuw4df0B21n
   SY5lvSA5eIh9ex52YbvE2fXVXQATZdBghCN5neD0kjjQOL63o27yX6nqd
   8G6fTIXHAIPVwFjnD6UF4osjdoF/DU8FZio3LRW7RiACJlW7uG8VJQ+F/
   DAd9IOwKNiuFQ9aMhw4G1wHTy6X63dAGMPoTobUI5p19xPtyD1ymzFKBY
   A==;
X-CSE-ConnectionGUID: 8QEdP9SdRHyupFdiFrG4pA==
X-CSE-MsgGUID: 9Dv2TFzfS7ik1h6q/D5hPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="64876339"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="64876339"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:51:49 -0800
X-CSE-ConnectionGUID: Td0sWeCITUm//tZSnY2mJg==
X-CSE-MsgGUID: yEq4mapSSiSeQBPNLAGaZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="226951612"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:51:49 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:51:49 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:51:49 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.69) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:51:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HiP+WZBJGIwA63+vPvk0bBr1jOd045Re+REgqW4FKOS7iLP21g9Ix1FH2AC8ls3VoIj0MxAKW/WyT/MN4gYolbEmMCvSnQq/xQQAQQ6D1UwHDGzEYdZcWQqCAB715hEPvhyz8bpiidj474lV2dcdJqvvKp7YU71nlp1trPLSSUtULhdSRy4mgbNvxvWHxkeNanWcVE5ODkqOBNjsOuCfOCMJk+z5/tgCYHIX4DX0kAO4316BRmMh8J3AXqV+AkK2IY+j7uWUv2sNG3CgXtnS79T2DyMC9lMsPwRCztq4PfOecQcm+zRl/vBlczNIok8Xn1lVa9TLWZzDKVViRqzRZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ed/h+FNLh3FqXW7MLC5UPBxZjl4T0OXNXyBKBCD0JWs=;
 b=qHNRvk9YdliAFyTMtOjrLzo5v1vfYjRFwt0dHjwTB3BnY5GIRzgsYxNHlaGKAMrz9ClJfWl7ZvmyrLPJc2r5KNtGI/2nzErM2P0rCV3yCSBFN4R7Wcy4tbYLPZC37T4SGHsNlgk9DwP0exT/oJs6fu7UQf/mMfxm6HIcgwloKPE0I+4gPIj2E+/PCLfNfs/xPA1pS6tisJALvF9aTs6Bj0h9vJIMLhBlDorreXVSRZtFYmLmMKSkBi7cS8PD1Dog/iclj/7v0+5zZ/s2CpEiaMe3yiIrjqKQmhMtaA+wOn4wrxbHnytx0PgMpcHZiQSZ9MCu06eFquKq3IXNfv7nMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:51:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:51:47 +0000
Message-ID: <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
Date: Thu, 13 Nov 2025 14:51:45 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF91320C45A:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b4b7d3-990d-49ea-17b9-08de2307398e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Mlp3c1J6TmxTZytKQkIweStoajRlUkVKNG9oMCs2MlVGSUVIRStJREw2SXJI?=
 =?utf-8?B?eVpDb0JrNmJabjBrTW1FLzZVcWZQdit1b1E3NFo1NGJ3LzY2NldvUEg3ZmdH?=
 =?utf-8?B?V0xJeVkxc0RIMEFzb1V2UCtKUFR5UXZWamdSTWJON005cmdpZjBTY2V0YTlo?=
 =?utf-8?B?ZC85bUVlZm1XTUxKVWd4SHQ2S1o2T2dXVXFQNVQ3TVlHbWx1dXU2aW9mQkky?=
 =?utf-8?B?bXloNGkyVWNWOEpvNmFEOXptZjZia1ljMjF4MzlhSkNGR2hVZ0cva2g3VHBK?=
 =?utf-8?B?Vld3SDVWNWxKZ0lmVlErdVcra0FrVXJ4dVdJbm9UL3FMdmxpQ0VkSU1XMHRy?=
 =?utf-8?B?MjlRcnJVd2s0Q3BUVnNCTjRGcHhWWlpSemxSc1ZpNmo1cUJCeWh5d3g1QTUz?=
 =?utf-8?B?VDFDMzJOY1JLUXl3bE1tRmdpYjRaSy9yNmZBcWM4SFB3a0ZHNXMwRmdzVGhm?=
 =?utf-8?B?VjFVOXJIM09jSjBTdHVQR2YvbnovZGtSTkNMbFA0bFExR3hVemk1aE5GSVZ4?=
 =?utf-8?B?cWppQ0taN1JZVHY5UytkVi9LRFhIV01rWk9MZVkvdjBXTnNwaDRVQmRXYTJP?=
 =?utf-8?B?S2tsR0ZDUkNNdTQ4TDluejBQYUI5M3dLdG1ZREFtQUxjTkpUK3hDQ0grUDMz?=
 =?utf-8?B?UVdhVS91dHozUUJQL3Z5T2o3dFpYa21MZC9jSWNsVlZ6OTloUmQxR0NTREFj?=
 =?utf-8?B?NHpWZVNmQkdrMytZYWxHbDFmWCtobWd4L3BlK2FscE5MMnlqZEhGZGZpQ08r?=
 =?utf-8?B?WkF2bi9MVlVOcmJmcnVWaENTS1BQRlhtdm5CUzlKQlR0d0Y1M2RabTZnbnhl?=
 =?utf-8?B?QnFobHluLzk4M1NaRG1STkhtbVNyQVdqaXRrdVNoREo1VUN5SFRuWm16MGg0?=
 =?utf-8?B?OFN0NGZ3QXdQSEJwQmtDS00vcFdtd3ZNT0pOd1V4aU12dUdTMFZSZzNwY0xj?=
 =?utf-8?B?cVAzZ1dYazh0SUpRZHBLV2ZEVXhvZ1BrbkhSeDYxWlByKzRMYUFmYytjVWJv?=
 =?utf-8?B?bXpCZHk5amU3eWZKY0VuYUQrUy9XQndHT080SjdqcFY1L0c5VEJ4UjZLcnBK?=
 =?utf-8?B?cXl3Y2R4SFRQdlFVYXlQbmhGb1BVbWg3TXFuTHMxVVdwRU15RGR0RDhmbThk?=
 =?utf-8?B?VHg4cW1ER3FUREVYOUdmNzM5b0ltVVVDenFTdHdJc1J0WjFocEdKZzVveitq?=
 =?utf-8?B?SVBGK2ZENzN3azAzYVl2bERHcFFLQndLVHJwNC9EbS9paytVbmpURGduZlNT?=
 =?utf-8?B?Z1R6bEpPRnl1cE1LcDZuVzlFdGFQNFdmUGEyKzJSTStQcGhqdFRhVFNGczV1?=
 =?utf-8?B?QXEzM2h1c2I4YW1hSTlGZTk0a1dqQ1pqK0RIVllmTVNrazlUT1JoWjVNUGw2?=
 =?utf-8?B?Ny94NEhjT1VoMnQyVlhRY2tmVXFMeFlNaWF0bU1sdFozRW90Z2E5YnZJWVRH?=
 =?utf-8?B?U1dOckF2N3kwTUJyV2QrS1hvY3F4MzBpeDNyMHNDYi9pSVVneVRySC9OYUVn?=
 =?utf-8?B?UFZEc01iUzRLNWZHZjdacDUzTzJIanJXVVBiV3Rjc0U3ZmRMTnVwZEQ0UGl1?=
 =?utf-8?B?REpzS0ZNY1ptRGc2dm1ZN2xMMEJpTUFjUnExeWdlZEZYYkhEWVJ4MkpsVTJU?=
 =?utf-8?B?c0lnTUZkbnB5eGViaHhEb3lCOWx5ZHZnN21xejdDck15dlBiNFpPeFlQRUVH?=
 =?utf-8?B?T3JxZFhQTXV6NUdGMWFtbjFqYldxbG1tMjdPSGhmMVBSdFdxd0NXaE95WVN6?=
 =?utf-8?B?UUdZN3lhYUtUa3c0VzJGOGdoV0FIR1N3YlBMMEtZVktJN1RWR3duWE1lNzZx?=
 =?utf-8?B?ZzUwWkZ5TGM1VlYwM2xFd2wwK2RqaStUZnRPUDhJRE5WdHlJVmlrbjJ6Tlg3?=
 =?utf-8?B?eTNmM01qNjkrNWJQOWIxNVg5alpITHk5WnNsQUdkTmVGaEVackozeDRZc2pj?=
 =?utf-8?Q?6ceZ/fovvoi4O6iVnaLb0fZATKnyCn0W?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWVYOHpCazF0RitFeEFXMHJUbUlVcWV2Y3pqcnRFcjYyQUFmOElvZUZhemtl?=
 =?utf-8?B?clZKWnU2L1MwZktSakZUc28rSHh2NXJLZktmaTB3ZTlxbVFjSzc2WDlKdG53?=
 =?utf-8?B?blRrbkZoeWJrUlBnR0FqRFNydTNidlZUbzkxa0dmZjkyQjVCbVN3WTBKM05M?=
 =?utf-8?B?VW1wVXNTUjdzeWZ5SHJlS2RPZ2xqanVzdDVNa3NkS2E3QUk4TmY4RFFnMnhJ?=
 =?utf-8?B?eEFjKytNOUZUTWV1bk9iMHRBRjdockRhbWM4d0VBVGZBbHRkTDd4NlZxcEUy?=
 =?utf-8?B?bmlOenhodWp4VE43SllsbWo1QlJodUpRQVprTEdhS0FxUHByYXhEa1R3QWw4?=
 =?utf-8?B?cURxeTRXQVdSVFlpdkRsV2VVRkF5S2tvVE0wV25PSjdHeDdEenFwM3UyeGwv?=
 =?utf-8?B?VGtUL2dXOUJ3RGVGVUdTcS93U2xvbVlESVMrSFlqOTVCWk9VS0hFYnduUGFU?=
 =?utf-8?B?dG5BbEpjdHd0NExncmxza1dPdlpBa3NMc3VyRlRpNWdHSEpkWjZTdTJJN3p2?=
 =?utf-8?B?SXBFVDB4TmZoQXAybmhjSDRzVStadVdscjVvdWVBU0JWUHZKeWorU2s5c2Fs?=
 =?utf-8?B?Q1RiWWFVdWtPWlk4OElsZ01yYlI4R3lqbnpmUFoxcWh6aVZVRmdCTkQ2RmRE?=
 =?utf-8?B?OERMWXFnc25xbC9pUG9iUGZzekEyUUlhY1V2allMZjd2c1RDMzE1blRmYWgx?=
 =?utf-8?B?SklMZU9OMktyMzhRbmZFN096bzM1c1RMSWlaNUZtaG9wbkNSaG1mL2VDRWRn?=
 =?utf-8?B?TVEzY0pOMWdzNFNicmY5U1lCR1pxOGt0TW8rODZzeWFZYjljVWVjMTBkU2J4?=
 =?utf-8?B?QUVmY0YxK2lmNWlOeFEvTVVSVm5IcUFOK09KTENaNnNsdW9zSVN6M3lCc3Nv?=
 =?utf-8?B?ay9oWnBnTTBEbWRMUktDaGJFTFJOKy9ORU44bE9lekJoODRmNGxKeHdQNnJJ?=
 =?utf-8?B?TG54WWNHMWhOWkozRlVxcjk4SWU5eStQL1l5ZE9MMndoNlZSTlhaOVBvVUU1?=
 =?utf-8?B?aHYwZVhWY1lLVVZUT01CSmtiNjZTODB0SW95M2kzd2tiYkFVeStSa3k1eXZJ?=
 =?utf-8?B?MnRoalNEZmlDc2NabFdhaXRLSUFXN3VDbCtIWDhqUW9nbXJteFo4OWFEWVIw?=
 =?utf-8?B?TUZPMitTTnd5bk1Lbm0vSmY0Q0p0ZFM2UkJCMHlyVWpMZ201aXgwd0RhSVI1?=
 =?utf-8?B?TDE5ZWVhTE8xdjdrY0x2YmpwSUM0VjEranl3Z0JYcmF1a0ZrcElzSFp5RUVy?=
 =?utf-8?B?cnNWdXJTbHJTb3BRaHEzaTVXNWZoYlFsS3pIR3d1UVdrUGoySVRWaGRJMERs?=
 =?utf-8?B?RUxoYXlJeHRnVjJ2Zkg4NURhMnYvVERXUjRGKzU0V0VZNDRBK2tYVDd1RVhE?=
 =?utf-8?B?a1VvYWRBQ3R6YWJONXRJenBlNlRwWEx2amIvY2JmWmZHTVpwb3lQaUtva2Vp?=
 =?utf-8?B?OWJOaE5oZDNyOFhiSUNBT1UreVpRbERnRVdqTS83QXhDRW4vZXhXSjIzYWNJ?=
 =?utf-8?B?UExJSmVpNDNjQWhPWkc2WGQ0QW1sTUQ2NEJPeWVDRHBSZG11cmg2Q0pNVzZs?=
 =?utf-8?B?NURaNFgyaFZwT2JlelJHeG93QlAwMnN4ZXZKM0xpMDFGSzBCSGFSU281dUxX?=
 =?utf-8?B?ZmhJWFgzS3JnVXRMb3FsV1pQaUpDVGR4RFZuakRzb3gwblRxRFM0UVVtbkYv?=
 =?utf-8?B?bnI0VjRxTEczR2pHVVBCNWdPTmd3RUlwdDFPVWdLMTQxVzQ5YTgvNnBRTVh2?=
 =?utf-8?B?OUFzaGJwbm0zVkhPTElPa2dWeXh1S00wOE5ncG9Oa0pIR085MEtNNVUvcFNx?=
 =?utf-8?B?cjZwV2ZCSjdxR2pxQmJHSXUxR21EN3RLSU4yeVY1WTQrOG40QmNMbUhmQ1dX?=
 =?utf-8?B?ODZwYm1mN1NoNXc0ZXlydUZocTYza1ljOHIvM3BGaWRxYlRDczlRdWk5RXo2?=
 =?utf-8?B?WUpSRWtUNDM3L2UyZ3lkY0lRQ2hTKzA4Rm81VGEvd3JSMDRzOHc0MEpOTmJz?=
 =?utf-8?B?SjJOTUZMQitxeGRwVHhndjJjT0g2dERPN0c2bkZKaXVsaVNQSVRwa3g3cDRp?=
 =?utf-8?B?TUlHRmt0ZWZUUXlRTjRPR053SjQ1MHMvNnRMemtNVTNPSEZYYkVkZ3pNVGlJ?=
 =?utf-8?B?VlhCY01BbzNVRFNsZTRqTm9BT1dOTE9kUjdOemxKeE0zc1oyWW9VNlhlU3Iy?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b4b7d3-990d-49ea-17b9-08de2307398e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:51:47.4078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrDHRNSKQAKvwCkMUzN2X7UA5nsXYv8Bv3veqV7f3eLEKlIK0E84iFuVXIDyYtTFZM4fijawFPHtpcVvQ71aVZPf7rt3N2PsBKfel/Lh/N4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into
> MSR_IA32_PQR_ASSOC. Note that systems with Sub-NUMA Cluster mode enabled
> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This
> is enumerated in the XML files and is the value initialized into
> event_group::num_rmids.
> 
> 3) The number of "hardware counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "hardware counters" to track all RMIDs
> are difficult for users to use, since the system may reassign "hardware
> counters" at any time. This means that users cannot reliably collect
> two consecutive event counts to compute the rate at which events are
> occurring.
> 
> Introduce rdt_set_feature_disabled() to mark any under-resourced event groups
> (those with telemetry_region::num_rmids < event_group::num_rmids  for any of

Extra space above, also note how line lengths differ between paragraphs.

> the event group's telemetry regions) as unusable.  Note that the rdt_options[]
> structure must now be writable at run-time.
> 
> Limit an under-resourced event group's number of possible monitor
> resource groups to the lowest number of "hardware counters" if the
> user explicitly requests to enable it.
> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
> resource "num_rmids" value to the smallest of these values as this value
> will be used later to compare against the number of RMIDs supported
> by other resources to determine how many monitoring resource groups
> are supported.
> 
> N.B. Change type of rdt_resource::num_rmid to u32 to match type of

resctrl_mon::num_rmid

> event_group::num_rmids so that min(r->num_rmid, e->num_rmids) won't
> complain about mixing signed and unsigned types.

May be worthwhile to highlight that resctrl_mon::num_rmid is already
used as a u32 so changing its type does not need to cascade into all
users. Something like "Change type of resctrl_mon::num_rmid to u32 to
match its usage and the type of ..."


> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 781ca8ede39e..252a3fd4260c 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -25,6 +25,7 @@
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/overflow.h>
>  #include <linux/printk.h>
>  #include <linux/rculist.h>
> @@ -57,6 +58,7 @@ struct pmt_event {
>   * struct event_group - All information about a group of telemetry events.
>   * @feature:		Argument to intel_pmt_get_regions_by_feature() to
>   *			discover if this event_group is supported.
> + * @name:		Name for this group (used by boot rdt= option)
>   * @pfg:		Points to the aggregated telemetry space information
>   *			returned by the intel_pmt_get_regions_by_feature()
>   *			call to the INTEL_PMT_TELEMETRY driver that contains
> @@ -64,6 +66,10 @@ struct pmt_event {
>   *			Valid if the system supports the event group.
>   *			NULL otherwise.
>   * @guid:		Unique number per XML description file.
> + * @num_rmids:		Number of RMIDs supported by this group. May be
> + *			adjusted downwards if enumeration from
> + *			intel_pmt_get_regions_by_feature() indicates fewer
> + *			RMIDs can be tracked simultaneously.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
>   * @evts:		Array of event descriptors.
> @@ -71,10 +77,12 @@ struct pmt_event {
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
>  	enum pmt_feature_id		feature;
> +	char				*name;
>  	struct pmt_feature_group	*pfg;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	u32				num_rmids;

This addition is to resctrl where there is already a resctrl_mon::num_rmid.
Can this naming be made consistent with resctrl instead of INTEL_PMT_TELEMETRY?

>  	size_t				mmio_size;
>  	unsigned int			num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);
> @@ -89,7 +97,9 @@ struct event_group {
>   */
>  static struct event_group energy_0x26696143 = {
>  	.feature	= FEATURE_PER_RMID_ENERGY_TELEM,
> +	.name		= "energy",
>  	.guid		= 0x26696143,
> +	.num_rmids	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  	.num_events	= 2,
>  	.evts		= {
> @@ -104,7 +114,9 @@ static struct event_group energy_0x26696143 = {
>   */
>  static struct event_group perf_0x26557651 = {
>  	.feature	= FEATURE_PER_RMID_PERF_TELEM,
> +	.name		= "perf",
>  	.guid		= 0x26557651,
> +	.num_rmids	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  	.num_events	= 7,
>  	.evts		= {
> @@ -174,11 +186,54 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
>  	return usable_regions;
>  }
>  
> +static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group
> +*p)
> +{
> +	struct telemetry_region *tr;
> +	bool ret = true;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (!p->regions[i].addr)
> +			continue;
> +		tr = &p->regions[i];
> +		if (tr->num_rmids < e->num_rmids)
> +			ret = false;
> +	}
> +
> +	return ret;
> +}
> +
>  static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +
>  	if (!group_has_usable_regions(e, p))
>  		return false;
>  
> +	/* Disable feature if insufficient RMIDs */
> +	if (!all_regions_have_sufficient_rmid(e, p))
> +		rdt_set_feature_disabled(e->name);
> +
> +	/* User can override above disable from kernel command line */
> +	if (!rdt_is_feature_enabled(e->name))
> +		return false;

Considering this from the user's perspective I do not think there is an easy way for user space
to know that the feature was force disabled and that there is an option to override this.
What is the use case considered here? If I understand correctly there may be a way to deduce this
by consulting files in /sys/class/intel_pmt/ where the telemetry regions' number of supported
RMID is printed. A user can compare that to the XML files to determine that there is an issue
that can explain resctrl not exposing the feature. Considering this difficulty I wonder if it
may be helpful to print an error message here? This is of course not perfect since the kernel
log cannot be guaranteed to forever contain it ... but it may help?

Reinette
