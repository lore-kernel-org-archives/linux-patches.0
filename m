Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B2527A12B
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 22:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760047740; cv=fail; b=orfs15V5/7sxHLSqxbctngQbg68O4LOFhadOtByvAb5sf5T64tZZa/IDr8fhq/7DDPfNuM7gVj03V2btRDRFFg5n72S+BCITx2jpkvXqbyWxYj1+PXaoNZbPXxZEDCmEW86cRh24op85ClzS7mnl0FXu2+DgESPpOM1TweTVCu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760047740; c=relaxed/simple;
	bh=sL9kkSjkhu8kwO2H8DNhFxUkgA/hvMKvQ//i6KHaQ0A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OBdEbOuV00Czp9ux9XPzTEo83+OzV9NC7hvAtUHDjxZ0b1JW6U709bEwyJUR9zJogGo8UkFHAJ62+D5RNbogsXEiA1/WnDyEWOhr3qqtFN+t8YJyY4AEe8LgyYWj9mOWMF9Uhc03Z3x8Jtt0I9ofUWFd4Fm8twyplQG4+0nQvB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kPon5SEo; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kPon5SEo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760047739; x=1791583739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sL9kkSjkhu8kwO2H8DNhFxUkgA/hvMKvQ//i6KHaQ0A=;
  b=kPon5SEowGdEM/GtQN0Vmi1Gld8vbRWb0z3Z7FnKC+Lk3TZmL6NHq4y3
   HJGKyf4+zAdWDBfSWw9G5AZHggMJ6yajhm2lImyxzyd+JnShGbREi8hCG
   TNZHudXm6apLHTwgIt7cLpe+rJdbv0gAMOGVHDuPiRCm4YxTmtwHJNo+8
   6TMN6ooO1JGFd9V/Eexlpe9NkfggDUPLhmkMUqoN3hfCtjGoruGsNrbJp
   ZP8x8UnIWw74ATnICwR3norleT/2OkvdR/7WvOu30qClL8qnswsohhC2j
   Pa3GQQ1RNaQiJk2PgyaE4FxKrSJuGjVGX7oqpwRKBqadarNPeSwiIH/GE
   Q==;
X-CSE-ConnectionGUID: F7bdDDtJRbOvTPdviPUhXQ==
X-CSE-MsgGUID: 2dgadKG8Rte2d0eAGFPaFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66100154"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66100154"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 15:08:59 -0700
X-CSE-ConnectionGUID: sJu5uW9mSemFUrzuicTzYw==
X-CSE-MsgGUID: uCvQBoSBT/eXJg3kBSf6qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="186088244"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 15:08:57 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 15:08:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 15:08:56 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.1) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 15:08:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWIqrVifdBlujwwU1tI1i8HuZpIqLvkxxC5zkB9G00iCvkA/O5nMYFHo+Lr2M2UyuntM/KMcNIvmUov7QF2ftAUBglrs6W/qhN4I7oMOTLnTAGYBZNqPuNWWYbr5GHG1eU9ZXaZvxe4PAye7En8o9mwBiv7ZRXnxsvuXPZ9+zZsZre/yEu3Cz3xzEf3F9r9wISy5dRHx23KJRFLaXLiuq9Jcm46ZsWBOT9KUCh721n1A5WCdJ1pbDTAXBKF2g040t/J/IblF+gtcw9fTlxQ/H632vNqrONEnrLqkeW6ENEmMIwuJECIaXGovoDNmCyzMmMnF34ImWPTpsW7dB+nH6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sL9kkSjkhu8kwO2H8DNhFxUkgA/hvMKvQ//i6KHaQ0A=;
 b=wB4KeqvI1WBIdbOSaD2FeYVyvRYpcaU08e4BIdCR3X3HaQUtF8lNS/AyEaeMjaKzveNrskt/uGR2PETglc00+DRwgUs3ZOXqkAYy3EkXIITVUFJWcxzwHOt1smNoQJmGihr3bHoWcILCIT3USuprryIp0ypQ1G3MV83DxaW6L2c/98LHwK1LkZZKRRR3JGHCYoF9rCOk0J4YwmtBGk5/J2aOvYFFA4Qy0H/uq3yr2Yzlf0HcXKBGKuaFH53JzLkPQXMFy8qIym8+ec07Gink2R86Kk5c0KAO+v0T6vDvnwnvIU765LKzwt7ONNtMqc44LF3+u3mQiCJkw5sWMj0vzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ1PR11MB6204.namprd11.prod.outlook.com (2603:10b6:a03:459::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 9 Oct
 2025 22:08:55 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Thu, 9 Oct 2025
 22:08:54 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Thread-Topic: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Thread-Index: AQHcLleU0msvp58alkOhnd7F/4XHxrSxJp6AgASphYCAAsCpAIAAQ86AgAAP+ACAAANVEIAAQMGAgAEDuwCAAC3RgIAADelggAAHcICAAARzwA==
Date: Thu, 9 Oct 2025 22:08:54 +0000
Message-ID: <SJ1PR11MB608302F7FFA34D93EBD77640FCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
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
In-Reply-To: <1ea9cff4-e93d-4be8-bbe2-308fc05eb3d1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ1PR11MB6204:EE_
x-ms-office365-filtering-correlation-id: f01bb7e1-7501-4649-fc64-08de07806ffd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aUNIMjViZ0liMEJIWGd2ZkVPWExTSTVmSUVNM0NpZUxoNWRIOEtHNVNNVkJz?=
 =?utf-8?B?eno2V055cHBGLzF2aklBNm4vcFRkSHN4ZlV6amxXOUtzazlESVlEM3RJRklv?=
 =?utf-8?B?WGdGNjdmWFBTOG1ZcytXTDFzU3FaQTR6RUdqbUtDWDlkLzVCUldLdFh3NUZT?=
 =?utf-8?B?aWc5MEtuS0ZhcmN4ZXRydEZjWVZGTmlYeEEzMzVDRlMvSVQxWDdCZW4zeUR6?=
 =?utf-8?B?cjZRL3B6Z1QwV09RbGI0MGpkRHdXakt0WnN2Sjd4VFlGdUdLR0ZoUkxXS1lX?=
 =?utf-8?B?OWJQbkJWNzJSbWttdmNqbExkRmVKT2lOazkvSE1hZFZNV3FCM1pTaFlRNUp3?=
 =?utf-8?B?TTRlekFYMWtOSU5pb3laVUtNekFyU2tRYXUrZjdETTFZWDhTcDQzM1IxNzI5?=
 =?utf-8?B?bzhHazRtTjlwM0dZZGUxRVFzZUgycElISnB1cFpaYjB6dHdxRTROL0hseU5t?=
 =?utf-8?B?OUQ3OEFBNzFMUVRGR0NtMFZRUjIzamtJQXNYSiszVFVUT2JQWWJYbWhLU0dX?=
 =?utf-8?B?bmRLdUJJZU8yV2RZTDZkUms3TTRqOTdsMmlMOGlNRXRadEtyWWhRanpGRVF0?=
 =?utf-8?B?bi9QNzBpdnVoY09SSGx1TEdXdS8wTlBETEJwdkE1M3M0anlhRjhYRC84NnU2?=
 =?utf-8?B?c0YxUzNKdzhoL0pDczdicTFSQ0JTbGE3TU9DUGN0ZEo2YVhtY09kVmRwUFU5?=
 =?utf-8?B?TnFqZFhkVFlrNHhwZ1MwWm5TWEkvSGFyd2J6VEp3UjJlTzN6bVNRZVR2Y3Jm?=
 =?utf-8?B?S25tTTliQzVlYzZKSWxHNDNIR0lEOXp4T2I3ZzlYQmRXS3Z5bGNPdzVZMStX?=
 =?utf-8?B?ajc5cmVwbDZ5Sm94R3JPR0hiU25NSXF2UVR4SFI3czZNR2hzblNrNmxyd0ps?=
 =?utf-8?B?Y3l0VTVwYnU3MnhranFTbjlHT2lNMTZ0ODlvMm1NNDlocXdEdWdkVDRDZHpI?=
 =?utf-8?B?QWVNM3VXYTNOSmlFb0NBZlFmMHIrOGptNVJ5TmNRTDhBSldFSkpnT2drK1Ry?=
 =?utf-8?B?Ti9xOGZlU1Q0czEyajg0VEtMVFljNmcyRVU1eUZ3WlhJRG5PS1hvd3ZVV01U?=
 =?utf-8?B?OHRPMnJMMUNmRmhYUHh4eGxwbUtGbi9ZZXJFWUxFY3BpalVvZjJ5Z0NwQVFZ?=
 =?utf-8?B?dExYeTRuNzYrUVVMQlM5RHNTRGV1eEVydFdQdThpZml4SSttaXVyVnNVNzY5?=
 =?utf-8?B?VE5qVUlWdVU2WXhLYisraGpDWWthd09ta3RHZTVQRUxBN0RXWnBNSjBhdHor?=
 =?utf-8?B?L1FBVExMOGt2SHQ4NzhXNmFtZ2ZhYVdQLzYzQXNIRGc2SFJqYUxqV3BibHZW?=
 =?utf-8?B?L2xkdDdZTDVWL05RNTFHMGVWNzE2R3A1TzhuMjJQa25uQlZmeTExbVdVOXpa?=
 =?utf-8?B?SGdQZUZlMGN0NmxIcDV2bWJCcjhqVk1CL3gwenAybHBva3M0N1NDNVB5bVpL?=
 =?utf-8?B?RnFBZ0x5NGwvZVZ2YzgxcHJwZEFaZlRyOVZ3ZUwvQkcwZC9VcXVKT21NMDNK?=
 =?utf-8?B?ZHExWU5jZ2NrTmxLVXgxNEJPTDl5QzJrODMranpzbkRiVWUzNmNoaFVnS0Y5?=
 =?utf-8?B?d1BoMHc0ZCt2MVhPU2NIUzNTYTZDRnpYVVNSMWx1UHdDckR3S3diWlBXclRK?=
 =?utf-8?B?TklEblJ0czFFalBETVJCS0Eyejd1L1VRZHFCWWN6V1FlZHo5NXc1enlrMFVk?=
 =?utf-8?B?MjVEWVRaT294d1d4enAwUXNoOHBreGR2UnkwMkRRWDBrTjk3blBEMFdrQ3o3?=
 =?utf-8?B?aXozcDZLc3dmbXgxalQ3b1g2SVk1bXk5UnZ1RERuZ3paM3ZwZW0vMTV5d0NK?=
 =?utf-8?B?NXY4NUZmTjE1a1A1RGViQVRTcTU1OW5ZZnJUZU92VExWbFVzeHNSRGR0cU42?=
 =?utf-8?B?WGw3L1U5dUx6Yk9CeFI1Z21XMmRtYkxZNzV2bjR6QVZtU0d4K3QyMUFKMVEy?=
 =?utf-8?B?aWN1VDNBWm9qb25JNmNIS3NCZUNRVzNSdUJtUDlLVER2MEs1ZTBmZUFWR0tT?=
 =?utf-8?B?c3o2NzY3SVlMMVBiZ2E2NGFHbW5QbE5nbTlBdDlpVkY0Um1uTmsxcEtSL1lT?=
 =?utf-8?Q?i2t8GC?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alR4NzNYYXkvakhOVXJqd2NET1pLS2dudE91VUcxTEt6bmJweW5yMERIaXFp?=
 =?utf-8?B?ZUdYald3eDduZFJOYm0vVmcvenROM3ZLc0RvbW5tVkN5Mzh2aFZadGd2VFNG?=
 =?utf-8?B?Y3kyeXYzbGowNFZUQTNVQzV5ZlZob3FvTmJBZVlydW5DSHRaRXhkSjM3V25C?=
 =?utf-8?B?MldoTTVjV1k2d2NkUDNIdmMwSlJjRkRWdVlKZ0tQa29hRVkyalpWZTFGcVBz?=
 =?utf-8?B?Syt2U3lhVWJCUHZsY0pKTGtGNkVwbmNRRDZZblgyL3FLR1lQajcyajl2ZnJv?=
 =?utf-8?B?ME1YamtPSERRK3NrK1lWMEdyMGpaVmJ2Vjk2QkpsQUdDN2F2endnUHBJVFpK?=
 =?utf-8?B?MXd5SFRZeWQzWWZRQTdKWHdTNkRNOG1ySVAwbk9UejE1eFpvOUk5cFMydnJy?=
 =?utf-8?B?WHhrdWQ4WGhzQ0RVQmFBMnpyVTV5em8vNkRzbDJXbjcvVnVOcnhzSWRES1l5?=
 =?utf-8?B?KzlpeHRRRmVMRWlORUNqNlp0QjF1bXA0aGJST3hTQWVKN0VQUnpjZkk0UEFW?=
 =?utf-8?B?SGpnbGxkaFhGbkl6enl3c2NBUy9QMHhyeCs5VU5FWXlWa01mak95c2pCSlAz?=
 =?utf-8?B?UEQ0MFBmd09MWEZTL3Y2eHFVMXVyYnp4cnZSZjRqTjh6dFVTV0U3bitkcjBm?=
 =?utf-8?B?anJUdG5nVTVsSXhFZ0FLeHpJQ0xmU1d5K3JWUzIyRGZUZzdNQ3RDRTNLejh2?=
 =?utf-8?B?cTdKVGhVaTRpT2NHQ2kzQ3JEUGswVFdqUTVER1dyS21VcTFYeFgzdFJ5UTFU?=
 =?utf-8?B?Vi9GazdtK1BXUjQ0cUdsTU9KZXpidk5yUTZlS2ZDM1lmZWszSGJPcGZ1TkJ6?=
 =?utf-8?B?S1poa0g1VXNvL1pDNG5CTUx3SVd1Si9QNEJUbGt1bklYSnhTM05QME4zZUtF?=
 =?utf-8?B?UmJOcDM5N0JUK0ZTaGxNU2MrNjgxVWFtcTlSZnRhR0NRNDJsYXd1VE5JSHRk?=
 =?utf-8?B?bGJPQmU4TDhXSk5WSHkrcHlGM1puNk5vUkVMUmhMU3pHWldOYzdMUytuTkIw?=
 =?utf-8?B?QlcvaWdvVGdyVzQvaUFsZHdReDY4NUNCY0F0cWp6T2NySkRBdkc0RzU5akll?=
 =?utf-8?B?SnYxM29FQjBOU0Z0bUVKajdWOHN6MkZmaU9EOUtHNzdlU0p0Z094ODhtZFA5?=
 =?utf-8?B?ZEtWWGV0VVJkYjc3K2diaUpOWnQ0aFVmeGFINFJhMDM0WXg4VkNEck5jT3lO?=
 =?utf-8?B?cmxyQzFzdXJHcXI1aDM2VExHM2dJZ3JwcnN5SjZPNmNXWEFaUFczYjhaMGpT?=
 =?utf-8?B?QitZT1Y5NGlKRU1Tdm1mQ1dtZVVqRjVSWGRaZHRJNERERUxnUEJTTWxHV2F0?=
 =?utf-8?B?ZHBiWWN5Qnk1a3BLeXY5dkxhZUVNV3ppd2cvaVQyZVIyNkQ4KzVPaE1qQnZX?=
 =?utf-8?B?d1ZKYmhiWjljclhvVTQ2SnVnQ3ZlNTlFNkdheWNLdU1BU3RvSlBmbTlvNHF1?=
 =?utf-8?B?eFQrKzZkdmJhcUNyaytwU0ZsbnVrRnhrcjliWnVEVkN3cm4wNFNlMURiMXl4?=
 =?utf-8?B?YnRUTk1hSG1kR2xubGZSSCtYR0c1Q2NNZG9USkRrWHlIeFMzTkZZYTVGeDcv?=
 =?utf-8?B?NzRHbXNmYWt5K2ZRU05mUVNNempNVkQwSFhtR0RuTEhxN1BnWFVxV0VVdmEz?=
 =?utf-8?B?SS9sNksvMWJ5UVg3bzZJSXZhUkd3U0RzS0lQMjBNRjlZOEs0K2o5R3oydjdp?=
 =?utf-8?B?VTJLaU5CQmN6VmtiZDgvY3RveTVEb2wrYWZNUmRPbE9WaTRVZXpFVktsOTZx?=
 =?utf-8?B?elc5MVdRUG10ODN1SjJRYTBVMWtLNXBOajFDTkxQYm85VGI1Tkx2cVRNeXMy?=
 =?utf-8?B?YXFmSFZBTXhwMGtqM2FUeGtUbndUc3VsQjVCeHMxd1NJaGc0MGJkNHkxSFRu?=
 =?utf-8?B?M2l0T3JRdGRRRzE4N3lYMGZ1dFBQTGFzZUhTanRKQ1VzLy9rMksxaXY1TzRY?=
 =?utf-8?B?cFlld0I3elV2SEs1djZPZUQ1Y3pKUXN4ZnlFeGJtMkF2RG40a0ZpVk9BcmJL?=
 =?utf-8?B?L0NWWTNBbzVORUxHZFNVK3dzVGxyOHpXN3I3NytBT25YOHlvbUVuU2dpY2R4?=
 =?utf-8?B?NXQvcXg5UUJkZTJBQ1dvMXZFRzFBS3RBWkRBUHU2cWhlSURHcGhndFlQcXRC?=
 =?utf-8?Q?6IhwuE0LxkWgETzKx7QNJQ/sd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01bb7e1-7501-4649-fc64-08de07806ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2025 22:08:54.8856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S+0meR59GU8qDKVJjAk4i6mnNVNAcasKg7pbKwZl86EnxgEydUsL9rrbcSOBdr3CGPaXcEq3frZJ/VHKKDtRjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6204
X-OriginatorOrg: intel.com

PiBJIGRpZCBub3QgbWVhbiB0byBpbXBseSB0aGF0IHRoaXMgY2FuIGJlIHN1cHBvcnRlZCB3aXRo
b3V0IHJlZmFjdG9yaW5nLiBJdCBkb2VzDQo+IHNlZW0gYXMgdGhvdWdoIHlvdSBhZ3JlZSB0aGF0
IG1vbl9kYXRhOjpzdW0gbWF5IGJlIHVzZWQgZm9yIHNvbWV0aGluZw0KPiBvdGhlciB0aGFuIFNO
QyBhbmQgdGh1cyB0aGF0IHVzaW5nIG1vbl9kYXRhOjpzdW0gYXMgYSBjaGVjayBmb3IgU05DIGlz
IG5vdCBpZGVhbC4NCg0KUmVpbmV0dGUsDQoNClllcywgd2UgYXJlIGluIGFncmVlbWVudCBhYm91
dCBub24tU05DIGZ1dHVyZSB1c2FnZS4NCg0KSXMgaXQgc3VmZmljaWVudCB0aGF0IEkgcGxhbnQg
c29tZSBXQVJOX09OX09OQ0UoKSBpbiBwbGFjZXMgd2hlcmUgdGhlDQpjb2RlIGFzc3VtZXMgdGhh
dCBtb25fZGF0YTo6c3VtIGlzIG9ubHkgdXNlZCBieSBSRFRfUkVTT1VSQ0VfTDMNCm9yIGZvciBT
TkM/DQoNClN1Y2ggY29kZSBjYW4gYmUgZml4ZWQgYnkgZnV0dXJlIHBhdGNoZXMgdGhhdCB3YW50
IHRvIHVzZSBtb25fZGF0YTo6c3VtDQpmb3Igb3RoZXIgdGhpbmdzLg0KDQotVG9ueQ0K
