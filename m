Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BFB221FB2
	for <patches@lists.linux.dev>; Fri,  6 Jun 2025 21:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749244504; cv=fail; b=rTlRvCLUyEymh1nSlZ3tgqv0YnuPEZgphnDL8I4r7uqTaTnD9EwgQfCIQuog3Vrs1Q/m1o/hNNBf21R9BOnF29cbOlj8C1yh1f5iMyO+McuD6Ng9pOPYYYLZiKr0YrsRGmGRXq6mAaScfaF1m04AyLPfC8btbX7nOYQH2HgLNSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749244504; c=relaxed/simple;
	bh=XnRwF+MxPWq7k8Mh4XZz6ZimsiFI5D10o0BMzd5/mvE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SOrO2pVs9B4WcJgtwJ8H5A+rE+Rgd++1Pvw+1k7FzsfvtOMfwJChjGY6cpUK+hovD6xWZcA9z/qz4vRori3h1KYjS7I3S06K6yivxf+8HZE/vTC57Clq5FSpC24HMZXN4NpEeioOJuKWaLGoqYyy4RpIGVo+wMC9wa6fF6XY6+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N5UE0Nra; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5UE0Nra"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749244503; x=1780780503;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XnRwF+MxPWq7k8Mh4XZz6ZimsiFI5D10o0BMzd5/mvE=;
  b=N5UE0NraZGvp3KHxVQrC5EmG7oL3oRrquluAyUNp2I9glPLzD53GXric
   j+B6Yonj8VwiM1Tzn0/bpKkLNd9ZmaNDcHzUg9MEaUiKdo+0lzvIx4/zw
   N95fNIg217Mfg0ZN0Rlc1q8VYoEaHUY/WmBTazAbaHHxiy7NeH1tbnZCe
   Ymj5NJuN6+TRyL8QlezHl0DW6mCIxiTvKVJIiQKLLzfqIS/W/yi7yOTBx
   TO94obZY/eisWCKfh+0DrKx5EwLEn8uLM9I91WLbiWuSEFrqns5Y3o5t0
   Wbx+rtH83yOdEDfGDx3aPo0fE59DMeh30nfzlo4J+UFAGpU9A1KvlTfY/
   A==;
X-CSE-ConnectionGUID: QWWONH8QTT6NAhBIhPoApA==
X-CSE-MsgGUID: ABJw+XvOSSSl++bjhmJVYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11456"; a="62799258"
X-IronPort-AV: E=Sophos;i="6.16,216,1744095600"; 
   d="scan'208";a="62799258"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 14:15:02 -0700
X-CSE-ConnectionGUID: CL4qYv3AQoCZ9NCe3iOHIQ==
X-CSE-MsgGUID: 4pvTNr/yQvmOb/R3DKcYGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,216,1744095600"; 
   d="scan'208";a="146520522"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 14:15:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 6 Jun 2025 14:15:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 6 Jun 2025 14:15:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.72)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 6 Jun 2025 14:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8zChHllanIhktpEQMIA8EQSph2kxG+3bIJPp/SZobl7ETCVHfU03G1A3l/XMMuQLrMwU4QzV0U3fZvAnztlq40JGeSuRci/mOTao2D08OHffnZGCnpUvKR/gf8o0fbaKyjYBOwMPlcJUoku7ayVSYoHLgkR8sR/zOePqHX4wqNg/Nk+c5FtLv2FrpC7R58WuRYYNVQ2COBsWiwZfbzrmycZHslyWKk6wY452hZbBBuUPsk7KPzuesqPr+hcjakkVJnvsTdFAaph8G13HXL5N4kvrmIPs50lQKvCnA/xnZxyscj1pJoo/S2hra1Dkdi43RezHqJuitW2EQZc46do3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5qL1DA1T2mvk6LYYSIRNJLl4nLZFY+fHIlcGp7H9l4=;
 b=j0+/n1wMC+eEtbcgZTdECmaeWlRwBta+UTia7yQZ5FFFOyo3x8NC1RBwiKXw+dWegUvnw4xcf/bqUokoz9genhmab9Mjm24dx0RWJo9eEzdVaXsF78Z272unVL+XKrzdeYcQuu5hmsx7vY/qO0ge4lnm1LmcsEtWzssr0RAL4+yO/tRh9t5xL2ONUYBVd9e+kVD/wkFNua3bvUtdzug/qcw5/QwvYaTZDdltoO0c/Wkays2uusU+lLashwkPJR8aYB9XTIl9ENBDXqCsG0GpAba/ZttUI8M3SPm4S4CoOAnAYk5vFeka5Snef9H2xisAyZkyuB0rskPbxeoRqgkjpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB9085.namprd11.prod.outlook.com (2603:10b6:208:574::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Fri, 6 Jun
 2025 21:14:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Fri, 6 Jun 2025
 21:14:57 +0000
Message-ID: <d2be3a4e-1075-459d-9bf7-b6aefcb93820@intel.com>
Date: Fri, 6 Jun 2025 14:14:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-28-tony.luck@intel.com>
 <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
 <aEIxzbuFybLBE3xt@agluck-desk3>
 <9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com>
 <aEMlznLgnn6bK9lo@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aEMlznLgnn6bK9lo@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB9085:EE_
X-MS-Office365-Filtering-Correlation-Id: eb32a009-bcfd-4467-b8d6-08dda53f30cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dlZ0elhMb2kzMk91OHBWbkRGTFdNQkk5ZVNSQzE5bXZ5S3JYMFB6UGdQYi9O?=
 =?utf-8?B?K01kbDhmODUyL2VyN3VNM09MdFJyZGIrQi8zMVVWaC9tNkMveWg2RVZGVUEv?=
 =?utf-8?B?NElGeUtwUUhKVmUxZDVxRWJISStyU21aUE4rZkExZTBraXgxVEhvNHBZc3Fa?=
 =?utf-8?B?MnNGTVBHT0VzRW5JK1hMYzJuWU9VTTg5R3c5aVFuVWVsS2R6MnF4dGN5d2ZU?=
 =?utf-8?B?Yk1RUHZleWZtOWZNTVNYRHJ6R1NBSktqa1lWR1owT0Z0V3E4VDFmWVF3cERw?=
 =?utf-8?B?blAxQ2daVmpXRzRFaVp6ajFaNEM5bFQvKzBPWTNCeXBSV3VSbFYwNTg1RjVR?=
 =?utf-8?B?em1aYkQ4Q1ZPVmZmYmZoVEJkZFJyRDJ5RTE5SGZOdWdXUlo0OXpucE1CdEg3?=
 =?utf-8?B?N0NxM0c4c3hWM0R5cWZtMEE5OUo4UkdRa0F4UTRGZTRiSWovenRXWGM0N1Az?=
 =?utf-8?B?bGxVUk9BRXloZ3c0dG5VdEF5Ti9NNmVjQzl0VjlIMkllbEVwYkdYTnRHVzcv?=
 =?utf-8?B?N3F3NGx3N2pCamFWeUdmcVZTL1g5K0NFVTRPNktmbXZ2blFDM2lUQStEWTVZ?=
 =?utf-8?B?dFM5R2ZwVlV3RlhnM1g0SE1LbFNrSTZiTFhISTN3NUxMRzV5UHhvNThSVXly?=
 =?utf-8?B?SHlpRC9YUUdjTTJRSmw1ZkFsbHZVN09NVXVlYld1QUZoc0VJeWFYU0p4ZjVJ?=
 =?utf-8?B?eDhqSGFpKy8zNHB3U0lZYVpKMDgxK3FtYVBnejFLWUl5OUJjNTNhWXRSeFIw?=
 =?utf-8?B?dllQMFV1QlpwSThaM3htU2c1VTJlUTdIbXU5QVZPZ0FNWmROdlVSTFJkNGdz?=
 =?utf-8?B?Z25DWEYxWU5wMFprOWoxbGx5SjVyQy95Ny9YclJpZjJXdG15eDh4Ty8rM05v?=
 =?utf-8?B?d0hDT0tLZXNjUDZnMzU3Wm9Odnc5Vjkra29IbWs4NzBCKzVWUkJpS01XVDVP?=
 =?utf-8?B?M0loOU1tSlppbVBjelQxeEY1UE5SeENVSTdCMGZXT0xNY3FGZzRxdENjUW00?=
 =?utf-8?B?YjdubmNhc01ubjN4ejBmUXpONnFEOEFHM0FGcTByUmxMTEUyRjh3U3dKN3lT?=
 =?utf-8?B?TUVqczRjUUFSblJFZVI5TWluWWpHZWdSd0RUdjZKSk1Ob0RENVgrT3BEVFA1?=
 =?utf-8?B?MXNxdURLVFVWMWFWbHBnU3VVcnlsYkVkWi82TEpYbWxDbWo5UzV0c2xkQ2JM?=
 =?utf-8?B?dWhKQVlVdUc4ZzkwM216NXZMVkprakV0OCtuQUpQNkZUZ0VBTmxiSEtnamVE?=
 =?utf-8?B?aXhkVXl5ajdkdzJJd2hPSjQwb3Brc21aWC9ka0owVHhwQkZtc3ROVTUveDZ0?=
 =?utf-8?B?VitWSzRxVktVRWtjY2VRNUFZSGp6TU5kVHBDQ1FINGE1QStSL3FxWmdxeUht?=
 =?utf-8?B?TmRqY3R5MDFoMkpnbkgza1NpdFhkK1lhZDNvTmxlWlhTeURnUHRTSEp6dEx3?=
 =?utf-8?B?NnN5dG84U2Y1KzJlN1JNajkzQWRWYk0rNE1iOEdaek0vb3lhRFlyZUpiOURH?=
 =?utf-8?B?TXp3Vm1tVDgrei9JUVBLekIzbU1tVnNOVlJhcGQreEh3cnJjYVRFbXNwVTJi?=
 =?utf-8?B?YlNFRmV2VHpoblhqc25tQW04Rzh6dG5QODZnenVmdU9GN1NhWnVwOGFLWE5i?=
 =?utf-8?B?ZG5ma1JJNzFEUFV5UWVsdVBCQkJzMkhIclhSNmVibkg4U050TFZxdFFBM2Vn?=
 =?utf-8?B?a084Mlcwd2kxUFozQXJHZHlWdUdXcWdoMzRWL3NjVElQWjF6aVk1bVBtVStF?=
 =?utf-8?B?cmk2OWNXd21SM0pkOVRvR1RVRmNISFNlRTd4OU9PZHVld0o5bkgrbzJSVzFn?=
 =?utf-8?B?TVRaZVBvdHZZSUV0M1F6c2gwQnVoUmhPVzlhR29OTlprcVB1bE13enBJMjN3?=
 =?utf-8?B?cXRxNVRRRkZZN3A0SkdPRTUraTF0Y1lwTUxIanRTbmRuQ1VTSXcwQlQyQlBu?=
 =?utf-8?Q?UjAZsfP+2U4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckh3dWIrUmhoVHIxbHpzdndaTmtGMWx5eXNOQ1Q0bG04UjE2U2xlbC93Z1FI?=
 =?utf-8?B?eE1TaHBLT1RvbFh2NXFiUE5sMzdhTzkvVzZnb0g4Z2YzYXNPMklnY21oY2RO?=
 =?utf-8?B?MzFHWndjUWdPMHFpRU9Tdm1tNEpucExpRTBrcm9Tc0NMZnU3RW5VN2ZsWEoz?=
 =?utf-8?B?WHhHYnlWZTM1eVE1MzRmUnNEbUM3aWpSeGFMbC90ci8veXIvOFl1bWtWU1J6?=
 =?utf-8?B?YjU4dUhRUGdoQkRFK1pRZnphNG5ZS0lZL2Z6b1dVdXZTZHJFamNydTJuaDRH?=
 =?utf-8?B?Z05sQ3FOSDg1VHFhdVpJS0tYaFZXMzVFZzljSUZmakFIUUFBVGhpQjYvUUFX?=
 =?utf-8?B?WXBqNkxxN2Y4MDBTeGhER0M1eS9pS2g4SzRWL3RiVFNldHNHeXVhU2NGaGIx?=
 =?utf-8?B?N2lUK3RMUUdHY1BwUmZVNmxGYllQSWI5NGtudk5QN00zek9hTUR2cmNYMWlT?=
 =?utf-8?B?UThjUStZaDZiZW5NSGVYVVdVNy9DSEp4eHplL2FHenUzdE83enZoSnhpNldW?=
 =?utf-8?B?aE9GZ2luRlJoRjBYVk9VWklzOTR2ZGNiaTF4Rkx2MG1vWEpxZzRvdjdMS2Zk?=
 =?utf-8?B?Z05scDh6VHFGUW84MlB2Q1poMG5nc1l2SFkxaWVBUVR1MXVDMDJHYXEzaUxX?=
 =?utf-8?B?RGtaZXl1TWE0VXlzVzVlSWxqdzArSk9VKzZRVEhmaksweFZZdVJlT0NaYVI5?=
 =?utf-8?B?cW1zbDloVEJISHJsR2QxbGlQVFpISnFSZ2pIbnM2dkFyQ2ZQWDhBRThFcmk0?=
 =?utf-8?B?SE5tYlRlb09veldlU3lZNlF4SyttM1R4Y3FsUG05bURueWVvVnh5cUpPQ2U5?=
 =?utf-8?B?RURXamFNbzhGaHJOYkdvTXZaVXh6YWRyR083My9YSW1henhNRHIrRXIvNGxi?=
 =?utf-8?B?TUJiZnVvakQvSmJ5WS8vcnpPbzJZUlF0dmFTeGd0RXNSb2N4UzVXVWdGcFZz?=
 =?utf-8?B?ZmRrYVljQmlyVi9pa1RNdkMxZDI3VHQwYTNOdVBFOEN6NVpyZFp3bFduTHUx?=
 =?utf-8?B?MlJBL1lOaWZpcWZJZFpUMExsUjNrQm1WOGY4YllNeGw0d3h4bm0yMHZkbTR5?=
 =?utf-8?B?WC9mb1diREkybGJHdjczME00N2VQamZLWUd5amxKWGNXRWhvVHZHL0E1cFc0?=
 =?utf-8?B?enhSa1k1SUM1VjlNT25OZEV0OTE0cnpQdTJ0aHhlMW5lRmVpRVp4Q1M1RFV3?=
 =?utf-8?B?cXZxNGsySndIemM4ekVGKzZvZHRKWFhsMDF2am8rNGFpWFpidWRmdmNRcnQy?=
 =?utf-8?B?UndCdTdKYTFxcEE4VmIyK3BvUFdRdnlwRWUyZ09sWENtcENOSTVBa29vbko3?=
 =?utf-8?B?NSsvRG9tZktrRzVQZWRub3NnalBaUnFaOUpOSFBqNU5lamRLZDM0QU9IWEtx?=
 =?utf-8?B?MDIxUVNEZ2VNNFdDanJnV0lOMmRPRDNlZUJEVks3cU1hejMzRDAwc2RUcS9z?=
 =?utf-8?B?Ui9CWWlZSGNGSlJXRW1hYjdzMHltYXlrWmlhNkU2NkdYZThjM0M2RkJ5UGNN?=
 =?utf-8?B?MnN3TzVwSVNxeFRFSmxNVEZGU2JEMDF2VXVpakltbi9iUVdNcU1xdFRvazl5?=
 =?utf-8?B?NkZJczhnNmFJeHM3a2p2MjFsQ0xzZ2JkdlJJZXVrcU1VV0szQ2hmV0diQS91?=
 =?utf-8?B?eWdMQWF4U1JoSjdIaW5JOEZDa3lFV3owd2xvOVcrY1drKzcvWDR1NnhUcWF4?=
 =?utf-8?B?MlZYdUhEKzE2WVExUi9ocjJQME51TW5aYVZaQmJobnpZa0xBbTVzK3NyVzVo?=
 =?utf-8?B?ODhZTUFMakhQVS9IVkloRUx6dmgwY2RZOElWNVRiRG9ja01rbmlHYk5Cd2pt?=
 =?utf-8?B?ZnJxcklWUFdTZFlnWm1kcGRCZ01TN09vSFl2ZnplWUFvYTA1YzFLdkV1d1E1?=
 =?utf-8?B?am5xamVjU3N5NzkzRGhsb1EyMnVMWGlrY3NHZ3R5SmF0L2o0eWRIRmdjSDAv?=
 =?utf-8?B?emdMNGVBU2xwdU9FUVdLMGRqa2lBRFQyQjFsVDVHNXJDeTQveHl2V1dneEFB?=
 =?utf-8?B?dzhBTWVwbnpXSWNOeXVBbG5tSmtxQ29zdUgwbnBOQzRCaWVBZFhsZGs5UGMy?=
 =?utf-8?B?WWFmcjZPVFBIM1hyT0xBMlNicTNJRHJnRzlzbG1VdnV5N2xlL1RZN1pnV3Bt?=
 =?utf-8?B?ak5VNFErV2JwZXhuOS9odEp4azhrSUJjYy8vR0NienAwN2JaTFpRZ1FTOWh0?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb32a009-bcfd-4467-b8d6-08dda53f30cd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2025 21:14:57.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haNm6ZpPK3d8K/K2c0zc7kw/ZzIwq84jbwsl+Fq5hk/IKA/Zx3QDqI6v72P5V/JZBWitLu6xOAHBnsxMP96TM4F6SmjgWeUsU5p+tRqOXqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9085
X-OriginatorOrg: intel.com

Hi Tony,

On 6/6/25 10:30 AM, Luck, Tony wrote:
> On Fri, Jun 06, 2025 at 09:26:06AM -0700, Reinette Chatre wrote:
>> With /sys/kernel/debug/resctrl potentially mirroring /sys/fs/resctrl to
>> support various debugging scenarios there may later be resource level
>> debugging for which a "/sys/kernel/debug/resctrl/info/<resource>/<debugfile>" can
>> be used. Considering this it looks to me as though one possible boundary could
>> be to isolate arch specific debug to, for example, a new directory named
>> "/sys/kernel/debug/resctrl/info/arch_debug_name_tbd/". By placing the
>> arch debug in a sub-directory named "info" it avoids collision with resource
>> group names with naming that also avoids collision with resource names since
>> all these names are controlled by resctrl fs. 
> 
> 
> That seems like a good path. PoC patch below. Note that I put the dentry
> for the debug info directory into struct rdt_resource. So no call from
> architecture to file system code needed to access.

ok, reading between the lines there is now a switch to per-resource
requirement, which fits with the use.

> 
> Directory layout looks like this:
> 
> # tree /sys/kernel/debug/resctrl/
> /sys/kernel/debug/resctrl/
> └── info
>     ├── L2
>     ├── L3
>     ├── MB
>     └── SMBA
> 

This looks like something that needs to be owned and managed by
resctrl fs (more below).

> 6 directories, 0 files
> 
> -Tony
> 
> ---
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 5e28e81b35f6..78dd0f8f7ad8 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -281,6 +281,7 @@ enum resctrl_schema_fmt {
>   * @mbm_cfg_mask:	Bandwidth sources that can be tracked when bandwidth
>   *			monitoring events can be configured.
>   * @cdp_capable:	Is the CDP feature available on this resource
> + * @arch_debug_info:	Debugfs info directory for architecture use
>   */
>  struct rdt_resource {
>  	int			rid;
> @@ -297,6 +298,7 @@ struct rdt_resource {
>  	enum resctrl_schema_fmt	schema_fmt;
>  	unsigned int		mbm_cfg_mask;
>  	bool			cdp_capable;
> +	struct dentry		*arch_debug_info;
>  };

ok ... but maybe not quite exactly (more below)

>  
>  /*
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index ed4fc45da346..48c587201fb6 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4274,6 +4274,8 @@ void resctrl_offline_cpu(unsigned int cpu)
>   */
>  int resctrl_init(void)
>  {
> +	struct dentry *debuginfodir;
> +	struct rdt_resource *r;
>  	int ret = 0;
>  
>  	seq_buf_init(&last_cmd_status, last_cmd_status_buf,
> @@ -4320,6 +4322,12 @@ int resctrl_init(void)
>  	 */
>  	debugfs_resctrl = debugfs_create_dir("resctrl", NULL);
>  
> +	/* Create debug info directories for each resource */
> +	debuginfodir = debugfs_create_dir("info", debugfs_resctrl);
> +
> +	for_each_rdt_resource(r)
> +		r->arch_debug_info = debugfs_create_dir(r->name, debuginfodir);

This ignores (*) several of the boundaries my response aimed to establish. 

Here are some red flags:
- This creates the resource named directory and hands off that pointer to the
  arch. As I mentioned the arch should not have control over resctrl's debugfs.
  I believe this is the type of information that should be in control of resctrl fs
  since, as I mentioned, resctrl fs may need to add debugging that mirrors /sys/fs/resctrl. 
- Blindly creating these directories (a) without the resource even existing on the
  system, and (b) without being used/requested by the architecture does not create a good
  interface in my opinion. User space will see a bunch of empty directories
  associated with resources that are not present on the system.
- The directories created do not even match /sys/fs/resctrl/info when it comes
  to the resources. Note that the directories within /sys/fs/resctrl/info are created
  from the schema for control resources and appends _MON to monitor resources. Like
  I mentioned in my earlier response there should ideally be space for a future
  resctrl fs extension to mirror layout of /sys/fs/resctrl for resctrl fs debug
  in debugfs. This solution ignores all of that.
  
I still think that the architecture should request the debugfs directory from resctrl fs.
This avoids resctrl fs needing to create directories/files that are never used and
does not present user space with an empty tree. Considering that the new PERF_PKG
resource may not come online until resctrl mount this should be something that can be
called at any time.

One possibility, that supports intended use while keeping the door open to support
future resctrl fs use of the debugfs, could be  a new resctrl fs function,
for example resctrl_create_mon_resource_debugfs(struct rdt_resource *r), that will initialize
rdt_resource::arch_debug_info(*) to point to the dentry of newly created
/sys/kernel/debug/resctrl/info/<rdt_resource::name>_MON/arch_debug_name_TBD *if*
the associated resource is capable of monitoring ... or do you think an architecture
may want to add debugging information before a resource is discovered/enabled?
If doing this then rdt_resource::arch_debug_info is no longer appropriate since it needs
to be specific to the monitoring resource. Perhaps then rdt_resource::arch_mon_debugfs
that would eventually live in [1]?

This is feeling rushed and I am sharing some top of mind ideas. I will give this
more thought.

Reinette

[1] https://lore.kernel.org/lkml/cb8425c73f57280b0b4f22e089b2912eede42f7a.1747349530.git.babu.moger@amd.com/

(*) I have now asked several times to stop ignoring feedback. This should not even
    be necessary in the first place. I do not require you to agree with me and I do not claim
    to always be right, please just stop ignoring feedback. The way forward I plan to ignore
    messages that ignores feedback.
