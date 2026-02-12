Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB089224D6
	for <patches@lists.linux.dev>; Thu, 12 Feb 2026 03:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770868363; cv=fail; b=b7/NhU+KXl5RL2rGgwGM3nmznC9GdSN1Usj+S4eGPqxqtXUHGUXxrqNN13L58J0E6B5UP7ggBpHE7pAp7oArX5tgtj1ZUQYwL0qZS9KpxqiWd4l01b9cCEDu68OhykYfzSerzkC80T0I1BlrTwqF6cep4PR2hi7o7ohjajoseYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770868363; c=relaxed/simple;
	bh=zRPG1FKMaf+bvtiFx3Ph7wYmtC+wMajIxT/TdMblvl8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PpyLAfz2vrEmEJXPF5km0Wj82A3OWu9nwqLHdU+o1eLw4L4yKRhMFb8cz8KdoORbvHE3LbCP1uDzYO0aq+PWKE4KetyROPf1ehMkqmB56j3h5sJ0QCc1KbeJmz6sUyD5qGpA7wDpULCETIPFhQUYWVyIfFh/uBBG9tXmBnD5zp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e+qITg0r; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e+qITg0r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770868362; x=1802404362;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zRPG1FKMaf+bvtiFx3Ph7wYmtC+wMajIxT/TdMblvl8=;
  b=e+qITg0rjdI3iARH9/eBb6c/OdgBMrrCzFaLVavyeX+NBo7UnB6h3Wnj
   NSYs9uhSyvPPI5NFn2KaA++208tdfsBMByL3YnSgE9+bt9LgawPZiOdB9
   QKIJHjMbqSkXBNO/yE6eIahFL16/tN1u0619A267I8eaEWK47k4aNXzWm
   +goXyA/O3GYz3r0o+NUHCi3HzjJ5oSWjYqcELiCUDSAgcjj6H7C02A1x0
   DPirgGhsSR6ZIC8CaYGAnqY4gatoaQhRQc9qk+20HvlBdxxwytxIcY+3Z
   f1VrEvQ7Tf5C4VDQU+qzhokvSD/4y5VL9PSLZHSrgP1SFnCdv/vCUcezb
   Q==;
X-CSE-ConnectionGUID: 8I90xKXNS2CLWyYAIVuKRQ==
X-CSE-MsgGUID: OGwLqm6vTWSqNzcZYVW/bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="71936268"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="71936268"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 19:52:42 -0800
X-CSE-ConnectionGUID: 13AahvtGT1Cg44Sbz/Ic5g==
X-CSE-MsgGUID: pOXrz9wfSs2pkweJkO472A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="250128107"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 19:52:41 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 19:52:41 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 19:52:41 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.49) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 19:52:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lNBKWStJ8dn+O8bLBODVA74o3vsYJx3QrnPwDn/XaRCNDOMk5UIOP+VDSKW5iCaTXhPq7JV1wUv3WoO8G1SGBJwq3pcS8YbQZEWf6gMEJJc6MmhyR1gpAiCfXSdSxc9rcu8rNL3X1Ge/dLcWH6GGXwlGcrTAPIuLnuo+urv/QPOyXxjYF33bXNV88Kwc6fmXIhFQZF1fAT9bxQT4SeYnO9GkHLj8wCWNn87PX9wSmD2JvBpxCV2o/DnIBgRjdrxS4bn73H7SbyaJQgq47lfh9wcKaxAJoCfqx+QmhC/7BgTyj8FOgT0U7ZpkV2lM3575vxOePxx/DAyypRetT+WEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31mMBoTBn90KuP035jQG5CX9poD/ZJRUlDQjMetINJE=;
 b=Mp+5+o2TT08wInSqW6aqzWyqpiALELLC9fY4sSI/nRtRuwFELA4AzN/EfUfpKxe8tGiFHHF6cQ77d1SN2LdVAZ1UcfwFfR1y8cr+YA1/s6FUSUAEh0SgynodNrCY/npD7j1jfZpekIcvnjpSHoMIDsCto7hzJZYJ753ZIiFgWCVYIp3DwRtoHRLFbvw2pG6Sn85aI8ebCWi9yyQ/g5y5yixBsAGf66bG3rA9WrOgnVv5JtF4MEJQpKPiUdRQT0aXY429w3ByAuOeSIGjPIIVIuiLp8XxKqjRA00iiTmF5Nx0PvjRag9wlbn/U+OwHP2HV42xtCSocVf+Z4jnFinL7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6339.namprd11.prod.outlook.com (2603:10b6:208:3b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Thu, 12 Feb
 2026 03:52:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Thu, 12 Feb 2026
 03:52:38 +0000
Message-ID: <a9e625c5-880d-4d0e-95b9-85c7616b8f43@intel.com>
Date: Wed, 11 Feb 2026 19:52:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] selftests/resctrl: Prepare for parsing multiple
 events per iMC
To: "Chen, Zide" <zide.chen@intel.com>, <shuah@kernel.org>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tony.luck@intel.com>,
	<peternewman@google.com>, <babu.moger@amd.com>,
	<ilpo.jarvinen@linux.intel.com>
CC: <dapeng1.mi@linux.intel.com>, <fenghuay@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1770406608.git.reinette.chatre@intel.com>
 <3ab21be3fcd9a85e1e204d4e28443fbe984998e1.1770406608.git.reinette.chatre@intel.com>
 <ae46c7fb-dbc4-4f62-89b9-0cb003e65547@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ae46c7fb-dbc4-4f62-89b9-0cb003e65547@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:303:dc::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: b0fc7780-e3a5-4e7d-6384-08de69ea2a06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OENTNHMzVVc5dkNYeFczaFRXSmlkdkJSUzBaeW9GU1ZUTlU4aGtML3FVRVcy?=
 =?utf-8?B?c1kySGFESkpUTENvSHlnOUtnTFV6VkoxV1o4TUUyeERpVHAxdjR4NWdPVVQ2?=
 =?utf-8?B?WkNSb3hJTEx5QWk3d2FZVVFNb0crTjlUcW1ld2VpREdUZlYyeWoyZGRvSGlR?=
 =?utf-8?B?c1MzVGRqZ3IvUzIzNFRFNjhpKzJDTmEwbU1DRGJQVTFqZm9sMGdxNjFEMlJm?=
 =?utf-8?B?aUxnYWtRWWVWdXVobnAzOXRpVHZ5cnRwWFhvRXMrQXlXZ1ZxQUxtdEttaEw1?=
 =?utf-8?B?S0x5UlRqVTR1N2FRamt2bllLYVhpbjNUK3FsSWNIakt6V0hTUi9hUGYvaEMw?=
 =?utf-8?B?YmdUcC92L094bEc0b1JtLzVtcWZ4UUFyckxET0RDOUZ0M2NwcStFZElsNnJM?=
 =?utf-8?B?bGtvdTUrVW5CZURybnlHNmEzSDBSN2Q0K0VxckR5bzdQYzVYRmM2L2NFQkky?=
 =?utf-8?B?ME5JNkRMR3NQdTR6UW15OWRMU1owOXV4S0tlRG1hejRlUFlhdVpSaVY4dEti?=
 =?utf-8?B?VGNsSVZNeUkzTTcxQ01VVDNneEZ5bVdmWUhsUll6Vkoxc0wyN1UvdmJHVE9l?=
 =?utf-8?B?RStoeXNpTUY4ZE1wZ05HSXR5U3BLWjBCQ1pQMHZvaXNUY3E3ZUw2S3QvWFNW?=
 =?utf-8?B?dlo3dFpDV1pBTXpUWUtsWlF0b1RiYnpnV2UyODF0WnJIT0NuVFlXV0pyWWVk?=
 =?utf-8?B?c2x6T01XMlNCVjRZbE8va0JucVp0Q1RCUGxOR2hPMjZ4VVgvNU9NVmxlZy9p?=
 =?utf-8?B?czkvZWMyWnlZbG5od3V6UjA1aVNwVjE5cFZyb2d2WVVXNHdkRTBya0t5MDhn?=
 =?utf-8?B?S0d3V252RlcyaEdJY0NHdm9oaUtFK0cxZktPMHdKZ3IxRnR0ek1GZVFidU1u?=
 =?utf-8?B?TGE2MmFXSnZQU0g4c1d4emtidTBHSVlCUjExa1FSamwvNkdya2tXZFAzSGdx?=
 =?utf-8?B?OFo3aDJ3ZU4xVHpMYis0MGI5THdYY2lsRS9YclhSTGUwTTNzZko3SytpZWxD?=
 =?utf-8?B?ZkpjaSthWWthL2ZiWjRIWHcwTTBTWDRlRlY0ZDlmU1RzYkc3NXZMeEZ3N3NF?=
 =?utf-8?B?dkgwRmx6MTl2TExoYTVwNTg4U3Bla0czRWhBTFR4V205b2ozTk9WaHU3bndx?=
 =?utf-8?B?a2l5cE5rbzZXQlFxcDUvWE5sSzFNZTcxZEpmUW5qaWk1UmZ1N1lNR2Y4SnhO?=
 =?utf-8?B?ZGtYWTBaT2FjeUk1UU9Pc1B1dFF2bTZQUWxXQmpoeFdCQnpsSmx6a2xsTWla?=
 =?utf-8?B?TXljRXI3TGV6bmRxR2RHWGJ3bk1NVUNqVXY1eU1vRnlJWUVwUFdzSnA5Q091?=
 =?utf-8?B?ajNleDFTSWYxYzl4djdtYUJmczlVc3VzcUsvelhxQkp2RkU4eGJEdFlud0F1?=
 =?utf-8?B?S2NVZWVWZzJNcHd1M212SGJNaWIzQjFEM3NkVmM4TnFOZlhXb1lyS3B5TXE1?=
 =?utf-8?B?bnIxQVJnTFc5b0hVcTluTTlZeU00TnZ4S2lsOG1SMVgwamFIQ3BOOEdBOTJN?=
 =?utf-8?B?VnQrdnNiMWIrSFFnRTJLWWRTZDBnRkQvWXFVb1VCTkpueWlqU2I3MFVJZVEv?=
 =?utf-8?B?TXdUNUdRQlNrTy9EU2lwbkVXV3lNU0pENkVJVGtXOGZXSEFMQktsNDJuUVh4?=
 =?utf-8?B?VnZLYkJTd2k5eDY2Vnpic2VCWW04MmYyYXhXRklQNnJQQUU0TDJqTm5hRnNv?=
 =?utf-8?B?clFkSmx5NkNLWEo4MWQyL1F0dnFhby94MmlOQ1Z5b1E2VmJzcFRXOHRTUzk0?=
 =?utf-8?B?SVFwWXRIUEc1TlB1MlNmSGl5OWY0RVpjazhGUlRqalQ0VW40cURJNWVUY2or?=
 =?utf-8?B?MElkK2JBMzFPQjY1TWJud3BqeDIrdEdoQXZoZHhlRHVvcmJNYVU2ZXVSeUNv?=
 =?utf-8?B?OXlUZ1hrcHN5Ull3c09VemNFb1pDRER6TkpIQ3NwUENtQ1NLK1BtTE0yYmV1?=
 =?utf-8?B?Z0tOQWZFUk9wRWNjU29pK2tKUWtRZVlWRTFDSkp1VGd4bjhFVkhzN21YaGZr?=
 =?utf-8?B?dVUzdU05ZHZhWGt6akVXZDNJL1BtL001TjBYVy94S2dJKzYxR3BSZjMvNEk2?=
 =?utf-8?B?SjNYVk1UcDJVZ1QrM1ZVeEtXcm5IY01GME50YWozMnp3TW52eVZQY0xpL0VZ?=
 =?utf-8?Q?xYVE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXNWV3lLekZoRnNiTmRDL3VRbGxpY0t1L3FPV2RSVVZNWlBOejRBZ3V3VVFT?=
 =?utf-8?B?cjlXREtENzlwajlNM2RueGF0TlRhTkpKVTZMZXdCekZ6TklYVEYxdkpMYXRS?=
 =?utf-8?B?TWcySEQxRGl2TGR0WVpZaGY1aGFVdjl0NVB4QW9yR25pdzNzdnVRUi93Z0hq?=
 =?utf-8?B?Mk4yd1lJQ2hXcFl4cTgxWi80L2pkV3l3dm5scVhRNFhHQU4yeUtkbXZ6V1F0?=
 =?utf-8?B?RHZFalpoVjRxR3lOR1RnRVhIS2tnTExKaTNmU1p2NTJDaFNBblhDVG8zN1lL?=
 =?utf-8?B?KzJnV3BzQlNPZnVTTm1HQW5oUklOUVpHQXpKUmt1a0FubDZRWTRVZHdWRlQ4?=
 =?utf-8?B?SU1IeVNSNFRYa2FiU0FLTDVJN1o4LzhzWDBEbFJUSjdXWTkvd2tWR1hJZVNI?=
 =?utf-8?B?ZFNxeTNDSldyRHV3dHY1RUd1YnhtRk53MWhXaTBDRzFPNzBnS3htQWs3bDNS?=
 =?utf-8?B?T2RnWmRUc2txQzlyVld0TEltdXI2a3V3ZzRIcUM0Vm9UVzZVSWtYY1U5aDVC?=
 =?utf-8?B?eXdtcXA4YjhGRkN1S0Y1aXR2enpKODAxRSt1Q0lkZmNqYTJhZkpzSldrN1B4?=
 =?utf-8?B?TkhMbXdDSXkvN1NEOERkUGZwOFVnRkNxaHJSU3ZnNitqTHk0VmZGOGxUeGJZ?=
 =?utf-8?B?eXAxQ0J6a0cwTnJiUlRyVlc0T1ZiSGxCbW1idG1rUThiYS82K2c1Rm1xcDNR?=
 =?utf-8?B?YlVaVlFQdnVkbWx4TG9mUjNlcThuZ0pCUlFRTDdrTitLR0llZjRBRWVSTGZZ?=
 =?utf-8?B?SFMxS0U4Q1VkbDdya2xZbS9YTEYyeDROTnY1S3JOcG9mR3F6QjlXN1N5Ylh6?=
 =?utf-8?B?dW5adk8xYUFUSDlRVWhvb0Y4RU44UENEYkFZTllLVGg2ZHFHSlNEVVZwQmo2?=
 =?utf-8?B?d0QyclFVOEh4Y0syajFqeE93OXlIQnN2TmpyOTJNeTZOS0UwRTJQcHQxVFU0?=
 =?utf-8?B?ejlhUFYwalA4d3VmcGlxMmFFdm14YkxrVTVTRWFqdjI2eGwyZE41NVh4Z25U?=
 =?utf-8?B?TXFVMFp6R0xWNDJEK1EwQ3ZjOXVMdDJXbjh3TEFzS0NzUHEyYmd2WWQxaGdl?=
 =?utf-8?B?aHlBY2FVMy94MHNQalhLTmt1bFBWUnNINXdDZlJkd3VMNmI5USt0cC9EaG5J?=
 =?utf-8?B?UXV5Yzg2cmtqVmtWQ3pRdUdRSkNISEJGUEZhcHhHSUZxV0pFeWg0K3JkWFFt?=
 =?utf-8?B?bzQxOXJFR3cvMDNRMFhtbm9BMTF6SHYydzBLSDBZTy9aUnFIM3V3cHVrSWVL?=
 =?utf-8?B?QzhFUVNkTWIyeEVrcS9IcCtpMkp5Ky9NcTRMSEJnSDA5OHJWc3BJTG56MHhM?=
 =?utf-8?B?azBXYXhteWNuTkRLQmFpT2IydENoL2RqWHd5eStDcFRwcUd4K1dXem1TM0t2?=
 =?utf-8?B?aUoza1NjUllxZUY4b2Q4cWhkTms5WG4vV1FMM1dSLzhlMHFnKzJtdlkrUFgz?=
 =?utf-8?B?MFYzN2tQYXM0VXRKZ3RwY0llTENDUVpjUVVsbEJsK3RiVXY1bU9qUjR4aXRP?=
 =?utf-8?B?My9BNEw1ZW1lMGdtdXZvbUJtRWRnQjhLclhOYUQ2ZmdkTVpUNVVzU1RoK2Fz?=
 =?utf-8?B?aTBmVFdDNTI2YVcvQ1BDNUNlUnVHVFdyeWtuVkprZkhXYis3ZEo0YWlveUww?=
 =?utf-8?B?VTlJZFhpMVlBWXdIQ3Q0c2VncUZzOVdyVENOVU1vdjJrV1VOaWQxTzZEZGFZ?=
 =?utf-8?B?UUxkdXN6a0JPVEZBSzVuM2JxS0RFYTRFbGpzbDZ4ZUk1ZVZNS3E1NFBDOGp2?=
 =?utf-8?B?UW9pWkQvY3c4ZUxxTTdUUzFsQUl0a1p4eG1kaWorNUpNekJyeDRmYUppYXUr?=
 =?utf-8?B?czZjMnNMUkt2SWsrWTF4aGlnTUtNdUF2SWJWWU0yNHdQU1AvcWZmNFplaGRW?=
 =?utf-8?B?UlFScjQ1dnIvN29HRDFNZnFMelJ6cEpKQXZVRDlxU28xWlVvU2JlWnVua3I0?=
 =?utf-8?B?TngzSmdXL3dyZDJOVzZXQ0RVU3BUT2RxNWRyWEoyVUU5QTFDL20xZTVpZ3JY?=
 =?utf-8?B?TFZmdDQweDlmRWJBcS8xTFcxdG01eGRMWGlxcUMyREpuZS94ay9abXBZeTN2?=
 =?utf-8?B?RnJxSVJUUjFhc1hobEwzTWZSUWZKQ25DeWtKK1hXNU9NR2RTaUVRUmJZY0xY?=
 =?utf-8?B?SG9GdzFYNUltcWdTL2ZIdG16WWZ0UGJ0RENMdDlWNm1VanhDMlhQd2VpYmNP?=
 =?utf-8?B?OU1WRERSZTlTU3hHc0hvZkVzVEU1eUF0L2VYNFdVYVc2NUV0c3NyV29CMlBm?=
 =?utf-8?B?Z1VUVnNwY1p1anpEK3JicDM4a3FsVzFZZVFPSmhnYWQwR0NiM2lIVjFaRS9o?=
 =?utf-8?B?THYyeDJlcUtEdUNpOExkQ20xeDhOWG9UcXZ6elVQbXpLeWNGYjM3KzMvdlM4?=
 =?utf-8?Q?ItVK4M/ufxHRYJPA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0fc7780-e3a5-4e7d-6384-08de69ea2a06
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 03:52:38.2577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kMu/CIpazYdzpNIfgoPElx/ZnW6TpySdcJQ32xu/dI6CahuN2O3eSshY0tESecq9Uhqquk3Mw3PdQDFibthEicWCJClxACP5pqoi15kxqr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6339
X-OriginatorOrg: intel.com

Hi Zide,

On 2/11/26 3:37 PM, Chen, Zide wrote:
> On 2/10/2026 8:50 AM, Reinette Chatre wrote:
>> The events needed to read memory bandwidth are discovered by iterating
>> over every memory controller (iMC) within /sys/bus/event_source/devices.
>> Each iMC's PMU is assumed to have one event to measure read memory
>> bandwidth that is represented by the sysfs cas_count_read file. The event's
>> configuration is read from "cas_count_read" and stored as an element of
>> imc_counters_config[] by read_from_imc_dir() that receives the
>> index of the array where to store the configuration as argument.
>>
>> It is possible that an iMC's PMU may have more than one event that should
>> be used to measure memory bandwidth.
>>
>> Change semantics to not provide the index of the array to
>> read_from_imc_dir() but instead a pointer to the index. This enables
>> read_from_imc_dir() to store configurations for more than one event by
>> incrementing the index to imc_counters_config[] itself.
>>
>> Ensure that the same type is consistently used for the index as it is
>> passed around during counter configuration.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Reviewed-by: Zide Chen <zide.chen@intel.com>

Thank you very much.

Reinette
