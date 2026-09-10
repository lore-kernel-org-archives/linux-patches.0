Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA8D3043C8
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013322; cv=fail; b=CnCoXMUdn8yQ7cMUdTxMmA3TDIcSU5IierAT0lsQtTfCJycArJD1hlYcDph/NTaeWgquICrLy3xtiYU4NaxfBRqomxZCL0FMmxhGRaEKMCI1Tfl8fzex3cIcUkEqFJFvi3Kuq6Rr606llSRqO1zKxQobwcDTpG1q3wMcn2xL+AY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013322; c=relaxed/simple;
	bh=Fcfe/TuUeFHL9PcWBWwnIM07RrpMso7Vs+C4pOV4EGY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QFPSLBlab+HFeVx8UMrGcRp0AlB46umWW6sScjgxEqRr7y9g36rj1FS5P05FMj52+jMNHN/4hZibgCllghNlRGzVZoA+gg3loJijkxU0+EvnNktvi/ayxfdqV7c638MuitPpm0VaUQ3MHyMW2L9OcFfYRsOY9r+xyZTqBrLy5fY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FhHdZSgX; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FhHdZSgX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013321; x=1820549321;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Fcfe/TuUeFHL9PcWBWwnIM07RrpMso7Vs+C4pOV4EGY=;
  b=FhHdZSgX/hv8SmZhzcnPmZ1yh+IIh+v+hlxUVTsDkL6SRtns//NibLHm
   eWu4cVQS+calFWBGh8wUfCi5+TUpchDK27ndMjTYcD+fdJ5JqLAvswN9N
   PBl93w3XZtB1Wm9ph6ujRks5jZgg4x9STYza7zF9VjbMH6avAd59+HknF
   3T1sPIJA2t1DbmV7o3TxN23wHMjvcctAnBg6g3S8nrp46tN7uyosyGRXP
   d60+cKG/iQFV4+FEoY02DhRrvqWKTASjyD8Vn+5UqUiXLEyjBNDa4K31k
   P1UZ/BNCXzimMB4cAnL5jB4ROEb3dyGfrQf9f1av59/WjVL5c53ujWoDJ
   Q==;
X-CSE-ConnectionGUID: 7UfgZ9elT+ScIWOW0ic1Lw==
X-CSE-MsgGUID: d8fyA7b2SZ+9ZfAXcdbigA==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89298020"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89298020"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:08:40 -0700
X-CSE-ConnectionGUID: Rkq86wGFRdmIS8XUS3ap1w==
X-CSE-MsgGUID: GNs+/PSjRYCBblzKOMXJMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="295009520"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:08:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:08:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:08:38 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.2) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:08:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJAaKJaFLIMcyl6MPf41jUj67QPwVJjKyH0QSSLm83/GLza+HAdzG7WlIpG6darHf2yr250IqiEtoUGsZygHZMlsZ6G8x3YmVZjH2oGOq7deL2neCfVqhvkyN5+is6lN3fi0NCk281DPcOHRDp/U0oWTiwGnIuOGAsh+SP4QqYuodaTg3aZnatZfOnH8f3sBAfuqXTWGfXkKtdtDs6UD5zoGC5RfItBo8XC/pWbt2Q4WiBWc0gO7wvw7vBJrsMMgCgg8ttgyTlOe0t/FHf/raH+8OxbzGO9C3eRwFPC8AkzOXGA8WZTtCVALTzhM+KBtgK/Lnprh2p0e+B2ONA4SQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q91npErXFU+c342HXwQJmQkPDbrIBeRkBn2/BHvEvT4=;
 b=NL4ha5LMzONTU+pAuQ5jJ2kRVR40ClHP4+pfeRBuKfBGJJX3HTBa2UhbkKWClEs9zkz/HHIb9E24AMLMpPxbYrH6LRhmxlNtA1W3iGTtSsiH73XxLsobmYbdDt6VhAKxvEET0D/c2rttWTtJ4AAdZxD09ouXvaMPY96UrLGLCxszd0o1IFCxSFgNRNfMsjnv660fMkyhEZRv7UjgFDTJAOi7GK4EC2LhTnZ1k5vDT6kUEo8rC6KHi3sjzCYdo/4S0GRI5MiR+ck106+czgXeUkLjUnwPUKGKzE67u67cg5+UxAzGCwul9o5P6AbLA/70aP1aD1u4IA8GV+yeERO/uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSWPR11MB9583.namprd11.prod.outlook.com (2603:10b6:8:36e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 04:08:32 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:08:31 +0000
Message-ID: <1a418996-fe0a-4553-bd21-9881ab182e51@intel.com>
Date: Wed, 9 Sep 2026 21:08:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 19/23] x86/resctrl: Export interface to report
 telemetry unbind/remove
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSWPR11MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: 78b4dcb0-32fa-4758-99af-08df0ef12d30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|4143699003|10067099003|22082099003|11063799006|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info: 8Kbf48gcjG6DPW9orhEmvRiZMtnQVec8ojGD6gGaJOPKIi3aHPqLWHP/P3y3/gIxzLEHQLQt14MGExXLDOuixCMQOGxkVQvqrr2tcxCnT6M+OfQq0RM3souhPA3zBS3aBciZ6xjR/DDrT6p+F9eB157lSqD7gnJ8QV8k7y40gpMCa2w33f8wF2gxMoV9uDXsplmLsx9eeesx6B6bhus2ouRiOkaNBpsqSh8mFw17lcxJ7cFdNfvfj7d2cdWh9rpXysSjWvTcpgquc3NcazUcRpDjJboeDiPq2rKwueGMStlWCpDC95cZPd8zm4fWHo8/ggzbZS0qqz6OUuuUwSq0ue5Le00xxFOIivHF3Ei66BVqtlerdLjwK6mqqTd5V5+GNOwajbW4ZejJpWCJBIhZMtW+2hLYnCwWsCAS6pBsvuEjvVfD1BKGOQ9iSVdsHrr5g5o7fRVCSOzKDKRr2+kRFI2LHQ6yVRDL4cMkzkssHnDyAfy+MKIYLg+Ax36Cwmbf6V8AnIGElXAVDszISS72KPgLkXFUhzCpdDAB8/vwyolRqPNnpOpHpWvMc/7XtHG+nUAd0A9opQ0Mgt3V8i8omgTMX7H+I37ISQUzMregz4fXK0WFVrfhs/OAEdTe+XdpLlJ+Uwucahv8L8nohKm03LajbroW/2LJKN35/Lv+rjhCskGhq52bMw//1UWFZXJ0K0WuzB4G9YwOGwaCy9jPow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(4143699003)(10067099003)(22082099003)(11063799006)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUNyajUvVkhtenpybVpRcSt4R1k0eUtGaXpVOGdtN3RDa1dJaWRKTTdRR1dz?=
 =?utf-8?B?OVR2Z2FWMnhKS1J0Ujg4MzZrUmMxU0wyQStJbHNZaGpZV0xmM0QrWWZVUHdp?=
 =?utf-8?B?T05PMGRMY2RRd0w4OTVFelRLMTNyUjY4bElQbDBFY3FJQ0NiMHlSOGlTOXZs?=
 =?utf-8?B?d0wrVXJQWERMUXRWczNVOTNvUWtjNlNOME9GUjBOc3R1Q3VaNjVvYTNDUW1V?=
 =?utf-8?B?SkdUTXo2dnFtMUVIbUVOV1ZJZnhkdkZBRGRDVHU0em1vc3JLYmU0QTdiVjlI?=
 =?utf-8?B?STVUeVpCSHlMVzhjZ3RoRXFybU9HWDl5eExRTUFpSDIxYlNDbHQ0aVc1SzBV?=
 =?utf-8?B?cDllTTNUVG8vMTM1b2YzTS9Td3dYcVFIRFdYdzc0cU1sbHBraXQwbDJ3c1pF?=
 =?utf-8?B?ZUZRYzRiTFlxZUR2anF5QkxNWnhnT1krdExPTlIyaGcvOTBqS3ZyMU9STE5J?=
 =?utf-8?B?NDNVYUdxMGJOYmg1Sjk3Q2FvQmE0UkFCMFdRL1cwdjJpQk84aFJXbWlHd2sv?=
 =?utf-8?B?cHFXYlJiQUY5SGx2cE9RcmQxeWxKNW1Icngwa1pLc2JYWjh3TjJ6K1hpejNl?=
 =?utf-8?B?ZThlUWtnSjhSSlF3eHBWcnM1TXdEZUZmTzRJcUx3RGtWTFI4YmkxSmRnTTBZ?=
 =?utf-8?B?ZUZwbXhiQzhuampnRktabVBURDVGYTR4WDRHWithQXFLQTV0UFBHaEYrelFw?=
 =?utf-8?B?UVFjWHF2OXRqUm41aWVlZS9rN09ZYm1hWk84cHZWTTgxTXloemhLWWFYUGFY?=
 =?utf-8?B?eHdqV0tBSHdtYXZIblpXMTNKTm9vb2h4UVd2NENHSkdqQ1R3Ty9ZOWxmUWJH?=
 =?utf-8?B?bEE0dlRaclVOUStJemdTNTJHSUhyOWxHY041azNrSmJPZFk3YlFUcnd6UlRw?=
 =?utf-8?B?V2ZoNUdmcmswZi82MUZGT2lmZHhxK2Q5WmhraE9OeHVYRFhrRkhnWHdNSHFS?=
 =?utf-8?B?b1ZnYWJZd0RTZFh1U3N2MDcyTXF3c0NUNEEyODl3WmpKNW9wZWF5WDBxSWpE?=
 =?utf-8?B?NURSVi9XMnNEaVdNa0l1K0J2TzN2QWlyazM1TVNoSmxlK3pPV3N3bFJTa1N4?=
 =?utf-8?B?Zk9PY1pra09XQzI0ZlhQd29SbjRQVHVkbU5RbEJTblZKR3NoM2lVVUxnekpO?=
 =?utf-8?B?M01KUmNTVHorSVdHL2VDZjN3WFFtUFBzd2tZRnpPM08rcGVNMDRyWW1NeDRy?=
 =?utf-8?B?T05qcTROdVZJMTN5ZmYzc3J5UzVtM1h0UWtpbzNJZE9FeWtaall6UTY1dDk5?=
 =?utf-8?B?aG1rUG1EbCt2cVNOZkZoMUR4YzVVTnlsdTZCRFNscHNMTmJBVWRQSnBBN25v?=
 =?utf-8?B?RXJON1RxS2h5ZVNXYzYvc01qdWpVbG9NamxiT1FnUmdWeWVwOVpSdXhieU5i?=
 =?utf-8?B?Vnh2N0dCakdoQjlObFpaZmQ2RC9qT1VVVmZPOTZYdVlibmhQNU82SjcyZVF5?=
 =?utf-8?B?aUs3Q3g2QVVzYmhtbnRqYkVSeFlIL0s4bEp2VWZjNGtkNlh0UEhKRzFvWUZt?=
 =?utf-8?B?d3VLZlRyY0szdmhjcnNMcWpwUXR1SXRTNVFxYWZwTDBXLzRITUxsKzR6RlJy?=
 =?utf-8?B?bnNkbldIYWY2UlRiWDVRbUFuK2RMM291MUpFRmxKSVppdm9YMnBzVkVZalNW?=
 =?utf-8?B?enlqYjVQRit5NFE1KzRPZGg2ZDZ6a0UvbW1JSDVDRXNlZkRrL3BmU1RaTWxN?=
 =?utf-8?B?OFpwbDZBNHY0SUFUSFM4NGJ1ZENmcXlSdGROWWpRcHZJV1puTkgvMEJydUVS?=
 =?utf-8?B?dWJCMTdYZ0NuMkVyM2Q4VEtQT1RxdEhvSUNpWDBQRmI2N0JoM1lrUUZpY1c0?=
 =?utf-8?B?RDhQbS85S0xyd08rbW9QZXp6V0s4WnUzYS9iWlNVVktORXlRUXBCZHJIeE1t?=
 =?utf-8?B?OHA5VWJvK0prczZrN1pEQnZqb0IxdzA5TjkyWVIwaWZISmJsT1V6S2I1QnRP?=
 =?utf-8?B?OUZ1UjJ5VGRXSjlTR01pREYrc1BZUVlxN0hHajN2NklVSUEwSjhOM2tRTXdz?=
 =?utf-8?B?dCtLOXcvaEtrUTNxRi9qTHh1Vm5DaE1kRm9rTmpZaXJxUzJuN24wdEd2cmQ3?=
 =?utf-8?B?TStJQXlDQWh6azAvU2hFcFlIMnpPcllCSW5BT3BFeDk5Q0RFajlhTWNWTWpp?=
 =?utf-8?B?OVR3U3Nzb2t6Q0Q5aS94WGorKzk3Q1d4VFF4UTF0eUJyWC90YlUwaTl3VE1x?=
 =?utf-8?B?S1ZzMFdLTTdBZTdJL1VGZ0VZR1pTTUpZdTZXT0U1V0lrSExDZGxXczJMNE80?=
 =?utf-8?B?eEgvVEt5YXREYzk4cG8wMzU1empoSEhGMW9aZmlWS2VBZ2NxZTkvRGlpWGdD?=
 =?utf-8?B?ekxQVnpacVEzSExodXdZRWtNb2RrUGs5OWliYnA3QkhIbWxzbDVEZi9nQXVJ?=
 =?utf-8?Q?nqdDv63UupoCY/K0=3D?=
X-Exchange-RoutingPolicyChecked: uimoeUd44FMiAXWDzCEUDoyGpfKqzxeUXSVW9+GJopai55JXnIs2G8O6Jd/536g+9jfYcvHiwnZHAWyOEHbY4QgbdP1LZaPUbMyVlOteuW14viW9nDHrMNXBUkrJaPQVAYhXLl/hhnJXmXbB1ITPyqPlCZEejapePR4CVNLDEl85H+5yTVNjid9QTSQ14wM+Cy+rJIg1p2ftOwp1RRKHcFGV21IWpURg1G9UEaIuZdhowi2/EnyLkjQZabi9Pod1FLeIeSprnYPzCXMFbgzx5dqBj6ZqHgbTLTbwhxBb3SMYdA+N2XQtGidv9FB6YfX1wP73aPhcwopmNFnXzFFxJw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b4dcb0-32fa-4758-99af-08df0ef12d30
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:08:31.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5xwfI3PzXhUzsRePA+brnkuOe9DT50TdYTgkxa2/9nplZbRP8QBnF+DskXDokwfad1YMxYaizauh8OHP7l7Mo2by/kCB4mzn3U/APRFGn8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9583
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:

...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index c3bd3536c514..5cd2711d00e7 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c

..

> @@ -439,6 +462,8 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
>  	void *pevt0;
>  	u32 idx;
>  
> +	guard(mutex)(&aet_register_lock);
> +

hmmm ... this means that reading an event can sleep now ... but it is still
possible to call this via IPI (smp_call_function_any()) if the CPU is part
of the nohz_full subset?

>  	pevt0 = pevt - pevt->idx;
>  	e = container_of(pevt0, struct event_group, evts);
>  	idx = rmid * e->num_events;

Reinette

