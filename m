Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368BB3803D1
	for <patches@lists.linux.dev>; Sun, 31 May 2026 08:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780216921; cv=fail; b=NhxbxxtS7lgQnmhxwH20zu9WfJXBvu9/ZzgclLAdN6KaBYkp+AwscXC3Lmk+FSPp/FeVc7RRoalFf2RwHZQ3lhr0sYIQirOAVPrL1S0w0OI013o3NB9X7Tz+4DCieRxnmHpnQ7SafCfIu4gDV/leMJHbHQ3Ah/By1bPo13UQSpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780216921; c=relaxed/simple;
	bh=binlPc4MVISAw9UT5HgN3JeHQqdILA4xJ0J5OKgM6nc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VRipCUtGRYmfP+gIFIaHxcRaiqOY7vrhPlTtGP8wfsdKtiKF7fFF0PdO9PxTiWsvkMTO6i4oppbCnghLPD0WrI/uMaE/PlHWkcQ85iQLP08SA+CJUtI+SjjXWt1wmcEI0ZSPIQ28TcH4FaOBf9bcORA6pydoYxPNDlmPDb2sWaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T3OFkdR5; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3OFkdR5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780216920; x=1811752920;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=binlPc4MVISAw9UT5HgN3JeHQqdILA4xJ0J5OKgM6nc=;
  b=T3OFkdR5rR/J6xy2lDMegC1traaH7i0JMGUIzVCc2ywSLNGw+4Fh9jIn
   zM49dr5OLsMxUhOAr0i+Wg1w5LC8smilQ5Hecuh/kMUAMhdNFOR1x0IcR
   xlfDRaNphRIDEnEF9LAo+6zUY2m2fnkS96sePrXpbzITOYiXnzaFUiTpx
   c+p41N0ZN1Xyn92Ub1zmjtAJMHIIzSw8GerHtnzUqbfgazWREVd2RbFnR
   kiT5dBYRMZgcfpM+sx7E0MXkI+qayK6vzlCpCIVa43k2DTfudUz2VhEAY
   Dw5w+FdzXpPi0I5TqX97+qejtm6U2xjED3cfvOL/nsg1yHlYcfSABS0RS
   A==;
X-CSE-ConnectionGUID: Srv22gxQRTGSrJpZ7Z4gbA==
X-CSE-MsgGUID: vSZSTuJ8SAKWIZbUlXVDGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11802"; a="84628472"
X-IronPort-AV: E=Sophos;i="6.24,179,1774335600"; 
   d="scan'208";a="84628472"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 01:42:00 -0700
X-CSE-ConnectionGUID: CsKdXGAHR4ieDJp55Dybyg==
X-CSE-MsgGUID: iQs5sFAkT5O9GaAWUik6Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,179,1774335600"; 
   d="scan'208";a="240747921"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 01:41:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 31 May 2026 01:41:58 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 31 May 2026 01:41:58 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.15) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 31 May 2026 01:41:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZqqaiZZUZ+NPrmilMek5weK/MmwcasIR6HJ7BBMp9NW0D48PIDz1Sk/Cswjmj8KrAtRZZEVCcaTOWE/76e+U/Putp93wF8/bp5U1VyiiXi6CXAF01+KeIjep3FejuMhzuSV96AoDT8gVudqAlk6oMeLlbu/11Mz7zlWhbs93jMYGvFVwf23eSPCIrwWMCvq6by17RK46bfzYVFRHqmqCaieVGMmqlZbM2O6Uh+gHuyXQBTAzjTaU75piXKlKvhKKpjANi05zH44NHEU4PLFx2uVg6DGdiRHe7zgdMCq0NyCDRj1cqrJAu50t/znPYn/TzCEibd9IZ0wtzOtYn2eEJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQWRm6WwEWN6Am80X3oj9czrCmuhZADMTZXNTwOtB20=;
 b=MGF03W43XinK6HeUORSNt+ECDqryRVO7rFYw76ceL1UMp0vjUICL2keNk9VpGollz+4j5uhSIDAhcFRyB2SvOUuGbzCP0kuORLx+qlq/vncMvlH2tIpAejqR2wQTYDD6lzXcmE9olghrIACd0d5pU7+y9wpROOEE/f+TrebIGKJXwiDBtsTIaOxjB0r6kfokBW0ZlfUy7rZPSFAWkzSR24UyI/W/ZCO8n3myrW0hvY81tiK983Y7XTEixNar0EGCwAOZLu98KXYan9OBB8pgO0sSRzivSpYbzrr2WaW7XaD4IJ9temUBeTdK/4dE0lJ8KMUJRXLAkEz0pjGVaGsbBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 DS0PR11MB7360.namprd11.prod.outlook.com (2603:10b6:8:136::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.16; Sun, 31 May 2026 08:41:54 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0071.015; Sun, 31 May 2026
 08:41:54 +0000
Message-ID: <34aa2c9a-8247-4599-8c9c-ce6dc94f354e@intel.com>
Date: Sun, 31 May 2026 16:41:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] fs/resctrl: Fix deadlock for errors during mount
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<tony.luck@intel.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <2e44b91263f1ccc4403a969524594800bead95c4.1779476724.git.reinette.chatre@intel.com>
 <6140c3f9-b172-4552-b96f-1b8514b0e75b@intel.com>
 <a9b51eee-fb53-4a41-a4f3-2c50b49d93d3@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <a9b51eee-fb53-4a41-a4f3-2c50b49d93d3@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU0P306CA0053.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:28::6) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|DS0PR11MB7360:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a6bd34-7c0a-496b-c2b1-08debef077ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: Lf3/wnxokSJTgGplHkIphp7axRRkFGReJizPFE4jC37rJgEl75UryJhh2DJcZ+4SWNQb7nDYbwFOFVOeLtGDHv4aCQKWxgoQ5PziJggZ9zNTp09eP3A+jWTFdCnvQ8pG6FSi3FB0So6RNIy7DHZY2nXmuOhrki7GbKRbpoUUqAEYPYiZx5PJtaMI+IZZC8mHK1UHNCmAu999zt+a7e1PlwhxYMba29Brm/GZq+SrVQ7SUKUnhyiOMciqhcDSVWok585ej7jpv2oHCrAbGV1q8dcMPIIOdpMU4LSIkf989ANSsegz1DIMWv4EoQ4KyaOPLyP+i6owxm33KiEJEjVcn4HNEIeVAti3jYSkEkCBJPDr9Pr71P2iuGpe9SERTf1MO2tM0y3gCW81s/z6MR/y8r5FvBfwM4sAa9Ce3GvE9ZR0Q0IYxkTOw+3BzoxSsCNO36eudlndG8lkO2wNjopbEYwpaIYU9EyRI4tidnc2tQRkfHC+v8stkuKc0CaUD8H7A/E84ay6zTRFcDHJiZH/2ExzIyQmoiZZimMJeXsnx+AlcXqlkYucTzepcv29decxhwyCFnbawPgd260ZvhH9zx8j1LcQvMb57MtTkEtGWmwFb61Aoho+1OrEw85H834DWbcJU1j/IMD3ekpx0UdlemqaQuqoxbzg0qKX4DyVu1ETpYgP6Bi4aKAeWvpIrlz0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXpIUXh4Ymp3MnEzSnNON3Z1Y1Fyc2ZML0NXVjRvWndyZERiaENGTTFkZFk5?=
 =?utf-8?B?RkY2QnJUQlltNTQyK1JtVzRueGlZMjd1T3IremhNaDBjYnRzekUvaWREVHpS?=
 =?utf-8?B?MGZsVFlURndvMFlHdWF5bTZFbXB3Yy9qQnpRY3o3RTlxV3EzMUFWMkVUNVFo?=
 =?utf-8?B?d2hISzI2RE1QbTNBdzUvdy91YUxIU04vV0xBcmpVRXZzTytubkRKc1U1cGQ4?=
 =?utf-8?B?MExpVkxIWkk2cm1TRy9jZysxNDhwTGxrRXdEd0dKUURiS29CeVlIcUx1aVZW?=
 =?utf-8?B?V085bUxaRC96bXF6Zm5ZTU4xV2d2VXpSQmxxd3g3NVJaRGl3bDQrU1pkamw3?=
 =?utf-8?B?QStYS1lHL0Zhd0UvUVhlMU9tMFVYcEg2dHhpN0VmQUhjMUpLUkZRaFlVdFZt?=
 =?utf-8?B?MGhxYi9PZXM2SjV5UFBVYkZuS0o5bFExNG1DWUs0WE5nTy9vNE5KRTlIencw?=
 =?utf-8?B?cURYcEt4M0l1STVDNWZmM3ZEamdERzhRZmlpVzNrTE9vcXFBdm0xQ2FPWFBy?=
 =?utf-8?B?ZXpGTGxpUWVqckJOMXhlbStlUkI2eDZGU2NrOFo5Vm53d1lURDF4WWhpN1NO?=
 =?utf-8?B?dEN6VW9EMTh4MkRhejYzbUVRZjErcjBTZ2gzR3NUTHhxVHkrdzZ6ZGc0OEwz?=
 =?utf-8?B?Q3R3SHhGelQ1Q2QvdHZ0L2U3QlEwMFg2Nk1MNzBLdjUxeDd1RlJRSkdpRGpN?=
 =?utf-8?B?TEs3TDR0OC9Oa2cvd1NHNmVRZ1FROTVyNll1Mi9YN0E5QWVSMElHME9Cb0hM?=
 =?utf-8?B?dUlwN3huVmxMT2NWMjlIMjJYVlNQcG5aM2pNMDJnN1d3cVllNDY1V3VkK0c2?=
 =?utf-8?B?bU4rSC9BVXJROTFGNDQ2YkFPUVJXa0hMUG1hTE8vQktnWHlTallJaFBZRDFW?=
 =?utf-8?B?Rnh3QzFFMVpCc2pqSUZUaEdiMnNZSzFaNGZ6T0Q3YjkzTnU2YXlrZ3owbEVZ?=
 =?utf-8?B?dzdxK3BESk9aUUgvYm4yY2c0MUNKZ3BmZFJSUC85WGcweDRMQmdNV0R2MHBW?=
 =?utf-8?B?T3hJZ3ptTVNEY2xuRm15STNPUmV4TWQzVXFuTHJIaGhUM3ZUNTl0T3RFemRh?=
 =?utf-8?B?emZtc0hoUEVQUzJLZWxSWmZ6c1BHQmhQWlE0RXJLaWM2R3dGUHRjOHlqNU54?=
 =?utf-8?B?UFpDek1jUFRRTlUvQ1hIeUphVkxCYUk4K1BhMnhrbFZ1bGMvSGluN2VKbTFu?=
 =?utf-8?B?L2psaXNFT0tpMThzRFJlckJXRzVXdEdzbjBkSWdoL01wS2cwMHQ1Y2FleEFD?=
 =?utf-8?B?dWdOc2pLbEtOZXk0dGl3WjhaZUN0dFlZMUt4Y3F2dlJ3dkhTWGFDUEFPOUZk?=
 =?utf-8?B?YU5DRzdlTHdPNlIzZGtHZHloSmRiK0hTYXRuc0NXVEZ0b1dJNEVsWGpUUVl5?=
 =?utf-8?B?aWw5Ykk4bXYyNHB4eUtQUlBUdEtFenQ3RXZST0FTM2pDd1Y1Y0gvYTRMV0ZG?=
 =?utf-8?B?TzVOTDN1NXB4UERrR2pySG5sdFp5NklheXRxOGl6cFFXbXgyR0JHdFlFVGU1?=
 =?utf-8?B?a1F5akIzUkZjMEZuTEJJYjFsYy93WTgzU3UwU3VMMWZBQWo4U2JxS3pSV3gy?=
 =?utf-8?B?SlE0VUN2QWlkcE84cWtVM3Mya295MGNjMk9IVXdKYzY4TGQ5dFlpcUM4MHFm?=
 =?utf-8?B?Mk5UZGNIZ3N5bXdBM1FMbnpmSFJEMFRLUk1TNU4wN1FzYy9aVFp5bHVXTjNP?=
 =?utf-8?B?Kzd1eFRqcldxNmYzUzlRTHd2TmxXS0oxdHlKalJXUWNVS09ibjNRV3FRdmpk?=
 =?utf-8?B?RDVRZHFwOVVsOFBxZVllQlBSYllUOTFnZ0t6R1UvZ01rYTVDOHVCUE9LZWdl?=
 =?utf-8?B?VjVDZWxKL0hYL0FjRjhwSGZCVDRmZmdYV2k1akgyQVVJSkdLRHc5cWQwa2VZ?=
 =?utf-8?B?Q0pBSlpvTTdidUEzbjVGV2QyeEJzVHkvUzRVUWVtUzVaSE5CUHRCU1RCczlT?=
 =?utf-8?B?WG5rUFRRVi8wcDZjeWdIdUl5NDhzcjBKaWFWU3VVRHNhWVcxWURnMXZwditz?=
 =?utf-8?B?Qkd1dTJCalh5WWQySmloeXBqekQ5QmpvQkJpSU9vSnU5SzN2Wnk1U0ZzQWht?=
 =?utf-8?B?aWt1WVZsZkd2eE4vR3E1M1JXdlNMQ1UwaXNSQ3gzZlI0R0xQTWUzM2k4Tjdt?=
 =?utf-8?B?NW10VlllZTFaMERTcnQ1NVZyZFhjUG1TdDhGaXJ3SlR5b3pIcWFDS1c2TjYy?=
 =?utf-8?B?UkV5dUlkUnlPMC85Sm9zVFVGUkpqZXZ1cWRuNFp0YmVDdzVNRmtlS0Z5NVZ0?=
 =?utf-8?B?NG9xQ01ienhJWXVCTnYzc0JBT2lZdU1RYUQxMzU2d3dWNGVlM2ZkanUvckoz?=
 =?utf-8?B?cXlKL2pDK0E1clk3QlBGWWR0TmlZdVIvQnA4dy9pdlIveVVuWDhZUT09?=
X-Exchange-RoutingPolicyChecked: X7YzQ8sKCscIOyYgg6WKv4ZrdpNnEwMASN8jDt7zYBpPzmjDapGqOXLPr+xnCJ2BmdVAXs/6yHkK6pgsOmGhKEMkwJ8xF66p83X3YGkjZPDj1adWbHexs0ksVriApx/SdIj8FABcAclTVzaNQYXyBzC3KUXVCitMkqimtaWbfabEWdYbsoDVstRNjOW7H5WqfRhdvhtDDtOL5Tfsj5fuuqgnWnfCKkYn99QV3FCJ4Hj8UGde/NA3ipXRr63THdUy3LtQpDBLtYWfh9JJwpVlDig6OUUk27VBgPscR1/o+XYKDRD+fvM0cRatPtWv8H4rCKnqDVDeP/k498+SPkdy8w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a6bd34-7c0a-496b-c2b1-08debef077ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2026 08:41:54.7674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JtL+Mzohpe7Ug3eytK7YzqL0mLR9BfuUYV86KK8U2gfW2UhplaWdh3BMaACiLIHAoS4PpB2uJAG45f8AQdDjcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7360
X-OriginatorOrg: intel.com

On 5/29/2026 11:53 PM, Reinette Chatre wrote:
> Hi Chenyu,
> 
> On 5/29/26 7:06 AM, Chen, Yu C wrote:
>> On 5/23/2026 3:15 AM, Reinette Chatre wrote:
>>> @@ -3085,10 +3105,37 @@ static int rdt_get_tree(struct fs_context *fc)
>>>                               RESCTRL_PICK_ANY_CPU);
>>>        }
>>>    -    goto out;
>>> +    /*
>>> +     * Ensure root kn remains accessible after mutex is unlocked so that
>>
>> Maybe a little more accurate to say "Ensure rdt_root remains accessible"?
>> Here we increase reference for rdtgroup_default.kn, and protect
>> against UAF of
>> kernfs_kill_sb(sb) ->
>>    info = kernfs_info(sb) ->
>>      kernfs_put(info->root->kn)
>>
>> where the info->root is UAF rather than the kn.
> 
> Right. The UAF is indeed on the root self while its lifetime is controlled by references
> to its kn (root->kn). Dropping the last reference on root->kn causes root to be freed.
> 
> rdt_root is the name of a variable though and its value can actually change in the flow
> involved here so I'd prefer not to phrase it exactly like that. How about just
> "Ensure root remains accessible ..."?

Yes, this looks good to me.

thanks,
Chenyu
