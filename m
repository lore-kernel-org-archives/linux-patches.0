Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766C31EF09B
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760046378; cv=fail; b=eZ2wipJjSwM5DkRpI8PltJbtzju84eHrQte81rz6twK3K1xuGlVKtPTW69EnU1oR4wYz7qOSI7YP8A2uxGNccYXwm/v0dw/zKm26FU8iQUzwbiPWABU9daQRdASfhsPNXfoayjMCz/QJddmw5hqtugXVTQQqpTt+qtwXmk28lMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760046378; c=relaxed/simple;
	bh=MPazJUsX0ydOcyhDFnB0pSwiQZ/Hd+Qwvfs36ifZaPM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CTzTSeMlUiPxAT88rkY/MbS/juEZ7M/Du2gmQyY1SedX/HDsk7W2cdrNamiaBsMbsinv1VKLsbDR7Rjuae9JcrjexJsWiuxvzt9UN6IIRo+YVHhVQrwBqD69/O9M3xev0XNUkQf/Jj2EFINZefCVwn8ADxYZ6CjwTiCU9H+Abuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AtyqVwEY; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AtyqVwEY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760046376; x=1791582376;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MPazJUsX0ydOcyhDFnB0pSwiQZ/Hd+Qwvfs36ifZaPM=;
  b=AtyqVwEYODwOz4XW5raj67PLI+95IOVulXehxODi/kn7nDELQYpmpF00
   Lrt96C9zLdhFe6bwmnJ2lT1i4ziloNnrk45WpFLMpSx49E7KkHb+xRJmO
   E6vth23ySQDZx1qELXKYdnDO638Dj7cOsHWQLqBCB7z37glI6AoQB67OM
   djz6JdL7QPPCXh51OmzBHCy3U2LdeRCBEnHXsptrdMYN/ZpMU25zjoTtN
   fLHOmI8nppzzPC8bR52AmujoLo4/ckwkGw9AzGVDdMBV8qHHIARMVdcJR
   2HRXOyWzaOCcOh1hjD+w6dEuqIN6CKHzUU+jy55wJD6pYwLJO+wuzonSD
   A==;
X-CSE-ConnectionGUID: uuQaYYQxRDa2f3TQf8GbJQ==
X-CSE-MsgGUID: +vBd78glQ7+wLx3p0XSMag==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="73699900"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="73699900"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 14:46:14 -0700
X-CSE-ConnectionGUID: QNHjOA+6RLC18EA/8k9cjw==
X-CSE-MsgGUID: btmQ92VgRlWFhZjr4UoXZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="185938686"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 14:46:13 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 14:46:12 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 14:46:12 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.16) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 14:46:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M0IOklwaWGij3Ttmu0l++eehN22PTsD+u7EygYi2YkrKgu38EJp45xx6nqc+A8uK7CMPXrIxD4H8lWzfOiUCTWdf37ExrODhdrH9S9MPExcEdNuQRPHsfheeoEfKREdvUfEx80e7jze0+b/Kxo217koLQyTz7x9q9dcSyjQhUm49TVYg45e0/SGCN2N4NDQ7rFYCR46sZzorSxxernjdtgd5hbtC6CMmHgjOpQ6a2/5DkNHmDWgShxrnBLKLx08TWgiqn3Ll6MfvOexWrVTqpKrsB8azrciX91o8/gE/rwPAi8GfGXDjjKV5rD1+BIthUQNVmmSJuKvYPWrlAwCLNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gg3yqZcUOnmJysbNFo+2cfWhghzNciP7jt/6N/YwLM=;
 b=FL9WurLBMQIrFkw02zHnisK2CfWIJGwuGEexDrVpnQkuzY8DQaXzGWLi/S1FGNgn/JfB4qZSwJY3rAtQHAt/rIj4lFUCnxvWROZ+gk6sC7imHcgAPSWRjuNE//XtK8OQaZsu9InpjjFS9lwgGhpnuvBGNrNw0AkHCWj19X/PlMergJklxZTL6kk8C2JQ9eYCUOtLXB8bJ7NlPKKUdmo2FzXbq4ktPIxQDwn5FCo8pUT+UfjAFp3KClZrbVa3FjFmm12nOtuNyzYiJCsOI8sA7l4lwmTkGgskt5yrWGTC+8Ddj1oq9KW61h0db/6uE7KHAYWW+KD+QyTicvYlgdnDjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB5219.namprd11.prod.outlook.com (2603:10b6:610:e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Thu, 9 Oct
 2025 21:46:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 21:46:10 +0000
Message-ID: <1ea9cff4-e93d-4be8-bbe2-308fc05eb3d1@intel.com>
Date: Thu, 9 Oct 2025 14:46:07 -0700
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
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB608328747C28F736C6DD5FCFFCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0262.namprd04.prod.outlook.com
 (2603:10b6:303:88::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB5219:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e7e1dfb-efbb-4bc9-cca8-08de077d423a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UE5LNmtRWnA5VkVJbHd2T002MWNoZ2prZFVMV0hoc3FLdVdiUEFiRTZVeEFo?=
 =?utf-8?B?ZFcvc3dNS0ZLVmhvSzNKdXhZSkN3TTl0RklNOWR0VS9kTGNLQkFyaVhRTmRx?=
 =?utf-8?B?NGZuWmZQZFc2MXIvK2R0U1hVeVArTlFkUFEzMjBvMG9WVkNUUEZ4Mk9CQU9U?=
 =?utf-8?B?TnRWelpuOGgwSVpkSGkwd2FkMExWMFpSdWNicnNOM0w3eUxGVENFaXhKSm91?=
 =?utf-8?B?VEZMeENuK1U5VWFrOVdyc0JabWcyMWMrN0F5aVBtOGtTWS9UaW1KTmxyYlZ5?=
 =?utf-8?B?WW5aTXUzUld6azFXc0RsRlovaDFXN01CTlNGc0ZVTThJUmwveE1TSUk0U0tm?=
 =?utf-8?B?bEFjRVdLTWgzY3NyTHFWZE8yaE01Q3Bnc0xMVzR5aStqUm5ZWWVXOGpQcjl2?=
 =?utf-8?B?NFdsdjByMDlJa2IvNkhzeHhndkFpaWpNWlNRZVFRR2Ewd2tsMWFzdmVJdTVS?=
 =?utf-8?B?RU9jNml0ZFluaVl4SVZqeGxFRkpiclU5VG1XQUtlWXJoWjVQcFpPdEZ2VFlK?=
 =?utf-8?B?OUlnZy8wZDNoWGFScjRTTVlvbVYwTXVmZytkQlRyaHErNno4alZIMFBNaDFG?=
 =?utf-8?B?bnAzajR5WXBRUVBZUWNVM1lRNEEwTDBxWUQ4c3o5ZFJjUmIzaEtVSGN3d29n?=
 =?utf-8?B?ZndhSUZ4b20xWTc0VDk2K2ZkemxGb1dkNTdKMHRkNlF3eTRPT2VFdWtyL0Fy?=
 =?utf-8?B?cDA1c3VOQnlkN2w5c3QyNWI3R0VBNGp5VUt6TlE2TGFnMUd6WHpFU0J4aktp?=
 =?utf-8?B?T3kySkZCYk9XOGsva1lMbCtnZTBPdWo2WGJNelAyRjFBdHpzWlRzUmNsRVZo?=
 =?utf-8?B?ejQ3SHovaDFRRmZTSjFKR2tPcldsREtEUXBPM1ovd1cwTEJybTFEcURUSHd4?=
 =?utf-8?B?Z1p2RVdNMEh4WVpXUnV3T0xVeDRhMEhVWFpQMzBYZFovZ1N0ZFhyemJxZG5H?=
 =?utf-8?B?M1dNWHdwRW9BeFRRaExlMWlDMUhFWTRQcUpUbGxaTm5xZ0hlOU40NXBFalow?=
 =?utf-8?B?OU1tSEVXRU90ekd3dDlOUGUraUIxblR0b3E0ZTh1aXZuY0tIY0xUZEZDODRW?=
 =?utf-8?B?SzVYQWdiOWc4Mi9jeXhUVWVYV2dpenkycldYMG5hMDlYVDIvSEIyeW82MUJl?=
 =?utf-8?B?RlFZZGVpWUkrL3UzM1g5N01oWVlQbURmbGJ6UHF4ZmxmSGhCcXpIN1krak9Z?=
 =?utf-8?B?OSt1ejlqSjZjYzYvY2lvSVdESHE3Z09NWWRXVXhldlVvRzFiMTMzOFk2bnIw?=
 =?utf-8?B?MXNDc1dFN1gvWjBXK1laZDRkSk11c0kwTWloNVZ1Z0Y3aVpxaytyalgzR01Q?=
 =?utf-8?B?bnpHWXdPeU1UR3FaaVhrQVJoaGdDWTdDTVQ1UVBtYnZ2UFJrOVdBQnAwYzdE?=
 =?utf-8?B?UzlNRlRlb3FpcFlrTjYzUVNyN2xhZ3I2TS80VStycklrQmtFODZXcTl2ZVpw?=
 =?utf-8?B?WVpaZWllL2xMcWwwQlJUKzJJQzVnOWVQdUU5TW5xQmtVUHdla3RUc0lwQXc4?=
 =?utf-8?B?OFI2MzBBOFkrdlNhRFllSmhVdXBVckRwMDdpRkw5RVZQaHExVnl4QTZjM1J4?=
 =?utf-8?B?U1I0VS9kaDZaUnRjb3B1TGFMN00rRFkrUURHSDlPNmdzTjVMcW5vMGV3RUp6?=
 =?utf-8?B?bWRjOHdoMnNZeUZkaUNldlVSdjE3Q2txRWZQTXBNOXkvT1NJd0p3SjdKTVdK?=
 =?utf-8?B?TmUzUkdSNXJXeVdYL3hDM1dIalNrc3VQL3hIdDhwVFNwaXQzckdXZmQ4QUhJ?=
 =?utf-8?B?Z3lDMkxPTW5mTlhnc0d1dXUzYTJ4SUlZQ1pKZnpZSmw5MitxUFJSQ2NkL3Bp?=
 =?utf-8?B?Mmx5eUM0d2pQbWFXR09UcmFGcVMyNUV0WDc1bjZPVFJ1N1A1bS8xL1JEMlIw?=
 =?utf-8?B?eDRyTGQ2cWU0TmZ0V2lwRVVuc1RDaTlZd29rS2ZQdk1PL256c09uMUdKZC9Y?=
 =?utf-8?Q?9coic6iDQ+R3wVYB2oKxHfSOCaJkWjC3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1FrT1FBUDhEUG1wb2EvZ2FmaXpsNzg5azBjQVhZMFdPSFZETXRCc3d3ZUxz?=
 =?utf-8?B?Y0g1SWt4dis4N2txQjRjQldvRFJKSndxOGM0OHRmSHBPTzZLMFFqYzFnblAx?=
 =?utf-8?B?M0gvc20wY2xsaFE2YmpXWlZsK1hCZS82QjZpOVVkcDZsMGVpaVVYWlVtN0pr?=
 =?utf-8?B?OHZiOEpWSS93ZGZ6ZXlVVTk0Q0kzQXluSTNWWkgxbXhaQnRhRjJBbWxsVERx?=
 =?utf-8?B?RzBuZUJwNTRhYm1kWHlUQ001eW5iYnVJSmVmSDNyQmJIb0paMEkyYXNQK1o0?=
 =?utf-8?B?d2FOTTFnSWxQbC9DdStJSTJwSmJaa01aNW9VMjZMOGRCRkhaam5QZ2dQU0tV?=
 =?utf-8?B?WncwQWRJSWV6bjhybDQ1Q2g0Q29mQzkxTmc5NWdzYklNVFJvRXJmWnd6YmhE?=
 =?utf-8?B?RUkwbjFPY25vTkNrSUc2K2JiRmNMSVFhNUZVWVR0NFRhYlRPVitjT1djSm90?=
 =?utf-8?B?SzVkWmVsenhrSHE3KzlIcUlxQmx4aWNhV3JTa25hWjhwTHN2cENWRlVSc1FN?=
 =?utf-8?B?dW05SFdXOTF2VU0yZHNDYzlXRlFCVkRqOEc2OEhZMEFYWmtQYTZwdDBkQU9x?=
 =?utf-8?B?R1lrZGorN3cvcTZ0NXNLVlloZzZMV2pTU2FwNTk0VEI5SnYwSnVaMTNQSlBs?=
 =?utf-8?B?YllRM2JUZUdHaGViSE5tWFQzaDVsUUJWUmN5T0RKbDkvUjFRdmJLUlpDSHU3?=
 =?utf-8?B?bWg1bitob1JTcGovRWdrZHQ1V3h2aUUyRmYzK2w4RFFrWmhBb28vSzNma1Vr?=
 =?utf-8?B?UFBmMTVLOXMxSER5WnRtcWh4SVc5Mi9XbWhLaW1lWndyR3B6VTNKRmRHU1Zq?=
 =?utf-8?B?RHd1YlBFN050cGFCbXpsaXVianB3TkovRnhWWUVTSDlBM05HaDNFOXJuZFRt?=
 =?utf-8?B?VUFFL0hXQXNQd1I1TWRPV1pwbk9ZUVZGNGRtUW4yQ2xoZGdRRHVBQ0QrQThp?=
 =?utf-8?B?L3hPdnZ6RXhSTzBkOTZOc1FidjAxUjBkU1VMSUFuL09SYzBVN1dRcTN0andL?=
 =?utf-8?B?YmtSUEFEbHBHODFqWmJtZWlKQXlYSDdXb1dBK1BIa1h1S3hoa3oydGV1UTYr?=
 =?utf-8?B?U2FvWHJlYzMyUXNWajJlMjdiMjhiQTVXakdZMnBSL0ZSenllK0s4UmRxYVI1?=
 =?utf-8?B?ZmRBQjJDQk1IM2VJeEhVaWxBU2l0bFZQekpIY0Q2U2JkQmljOXRxS3M2Y3R6?=
 =?utf-8?B?TnpOa2RsdWZ3Nm5yNUJUelRIKzFjQkFJekZzQVVySHlEUUg3dDgydFU5SFlQ?=
 =?utf-8?B?QmlZc250VU44R3lHajBhVGQ2WDVaVzUwQkR6aElMS0IvZWVQLzJOekovcS9R?=
 =?utf-8?B?RHVMK2pZWGVxcmpZU1ZsVjl1ZUlEODMyK1pjNjBtQ2c3RWlwNDdsVUwyeGJm?=
 =?utf-8?B?ejlPL0ZlTHhrbFhsaHFXZE9PWkNVcWs5UVEzT3JiaDFlNTE4QVEzaURwWnRj?=
 =?utf-8?B?V1NRZzVSdWVtNjZQU0dWeHhNa3RqVXdZMmJzQ1B0Z0Vpb002OTNFcXVNNSts?=
 =?utf-8?B?U0tSalZiU0tJR2lwQ1BBdm9URmRsL1c5TlZXNWRxR0ZuZnE3dlFLRTVCSHZM?=
 =?utf-8?B?ZzFjaWhLbE4zcmdqNmJYdW1xbmNUaGthN2xFZithbTVDdkQxL1oyOFJLaVd3?=
 =?utf-8?B?Sk8xT0FteUtkRlIxejIzSE1PM1VYbmVZamNaZjBURUs3ZmZidFpmMkczeTFV?=
 =?utf-8?B?RVhQeml1Z09va29TcWE0WlFTcGJlcUw1UDVNMTZaamhiWkticVRVV2Z5Ynlu?=
 =?utf-8?B?NjJZRG90U2psUzVLZUwyU2R6am02amdkcFlmM0hwQmpWVHhNOWwwOWdEQnVi?=
 =?utf-8?B?QnFXSmY1bVNoL3FzTEg5MmllUmxrU2ViaHE3RWEyckxPWjUrOVVwOWFZdUhQ?=
 =?utf-8?B?S2JhQW9UbDRuQVdkWExGd2JCWDBWRmEweTZubEpsaStTMDIwTi9xcU9qT1FC?=
 =?utf-8?B?ZDliTW8yVVMwTDB4UnRzSmorK3FIc1VXbElyVFl3dXNsc1RLWTFMUzk1MWxO?=
 =?utf-8?B?WDUrc0xZbTl4VGVGNXRJbDFNMjZjY1FDUnlXdWFZVWtuTEh6RUJITnZJaVg5?=
 =?utf-8?B?TFgvODQyeVVIUzdLbTlzR0t1WkwrMzhVaXRBbVZtYVNxQWxQM0FGb3VzbGdJ?=
 =?utf-8?B?Wm1oTG1kVUZQU05LSHRSV1R1UUZDZFJFUDBTZE4rY2pOWEFmb2tFekJacko5?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7e1dfb-efbb-4bc9-cca8-08de077d423a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 21:46:09.9781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtK1uOdrA60ByZoQ5UF86CbEm3Lsen+MeENLY7/9XQhLOVaWbKAh9+dpxP8CJL/sPwkooWOQzbIttN8JkwRESsiyXQLoHGmuY7B3sX/+CnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5219
X-OriginatorOrg: intel.com

Hi Tony,

On 10/9/25 2:31 PM, Luck, Tony wrote:
>>> There are only two places where SNC mode is checked in this way. The
>>> others rely on seeing that mon_data::sum is set, or that rr->hdr is
>>> NULL. So it seems like a very small improvement.
>>
>> This is not about SNC mode or not but instead about this code being L3
>> resource specific.
>>
>> I see the mon_data::sum and rr->hdr checks as supporting a separate
>> feature that was introduced to support SNC - it should not be used as
>> a check for SNC support even though it currently implies this due to SNC
>> being the only user. Could we not, hypothetically, even use these properties
>> in the region aware MBM work?
>>
>>> If we ever add a node scoped resource that isn't related to SNC, it
>>> would be needed at that point. But I'm not sure why hardware would
>>> ever do that.
>>
>> Right. This is not about just what is needed to enable this feature but
>> about making the code easy to follow for those that attempt to understand,
>> debug, and/or build on top.
> 
> Reinette,
> 
> Region aware MBM work will need to sum things to support legacy resctrl
> "mbm_total_bytes". But while SNC sums across domains that share the
> same cache id inside the same resource, we may be summing across
> different resources (assuming we go with separate resources per region)
> or summing across regions within a domain (if we bundle the regions into a new
> struct rdt_region_mon_domain).
> 
> So __mon_event_count() will need to get additional refactoring and helper
> functions, and struct mon_data an additional field to say that this other
> "sum" function must be used.
> 

I did not mean to imply that this can be supported without refactoring. It does
seem as though you agree that mon_data::sum may be used for something
other than SNC and thus that using mon_data::sum as a check for SNC is not ideal.

Reinette
