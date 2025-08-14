Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C891C235354
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755186249; cv=fail; b=W4n2ERsa/H6JCmidCjw0n6lU+mDbOBF1PV8/lGDCYgxJGQoxBqLdV4ogYA6mjRr3m/1vFJ2H7i2RvGFAMt/hKFyWSs7bSkHfPydY48xwecYL8i8CvGFsS0Ms6qVhW0FzN8CcQhO68pnIpTqKsOB27tX5PZU7nJM7mEaaTQ2XjDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755186249; c=relaxed/simple;
	bh=eLZas06SgCHraITnHpELUX3qp9gFZmSI1kq56tcp7x0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ppaKX+on8lTgDf57wC4vOxV/Bl0Ba2qARav1GpC45jLfvvFddGfEiRHGIvvAe1eFHEFflpdsYcT7P0e0WOoQUK3dT62z5xau7ahy1GVC3cLueOZ+bw4NekCdhKvI1dEeCzCPnvCTGUxKCF/2YWKWFJ1FDOWkprJkTrHZ6R+2JE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n2AAjOk4; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n2AAjOk4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755186248; x=1786722248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eLZas06SgCHraITnHpELUX3qp9gFZmSI1kq56tcp7x0=;
  b=n2AAjOk40QsG0qjEOxUZ31XbW5KgHqYqF+9DI3G3o0bcmnAlBwVV44MH
   32nQPIP44XRbh3lFnYHseLirI1FMji6Tjw6xnHmt8v0Ork3yh41oW81zG
   EEs6nHH5m/8jlDZ0lDcOCApLHAA0MdaZhznz/ptKS156NUjKci68ESXt+
   yX5N0XW5tv2Hw3FUa2U3VRzEJOZk6VIx6oKJ3Ld7hYrxkI73G5jTM64w0
   oA8n6hFKvfQpXj+4Z62i+N1JaILunwsFsyXxES4hluk2rN/iPc10K0skj
   KbWiv5Q7DGiQmP/IJkxuqNbC9dZ4Er6NdEnKswOVSJvaF5TINf/pLIL66
   Q==;
X-CSE-ConnectionGUID: 7qqvFpp3S9C0r7WrRdtaYg==
X-CSE-MsgGUID: 80ISv2TgR8+9cRnX0uXnbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="56529289"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="56529289"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 08:44:07 -0700
X-CSE-ConnectionGUID: JdB1CFW4T2a0Z07AAjfQ7Q==
X-CSE-MsgGUID: xcb3MxNPQpKvnF87A8K5AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171033061"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 08:44:07 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 08:44:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 08:44:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.83)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 08:44:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oqIsx5CwX3Oq63Eh9QOYsO1zrTfFht/19q/eE1WuWIzt0PbHeJ++Qbipq0NOcEj1lYGIQQhOGk8Hyy+vqzY+bbabV++b02qn6ANkhLbLFxIcVA1dBaoEcI/j2Jh6Nhb3IB4vu8Ht7QzIZkJYOQCC5hEOcvwmV6ofK+WfyC6mNZqB8ML1L1QVnijLapbPRV6l23uXfl4SbTRbjmBTrE3J5Kx40xEFYDWsTDYCDJHlp63SINkFTz09gCqta2WBKdkywMEwJWKt3wnBrVQM3wIP0eaclcWeOJ/D8m6PXx1LuE9tjjS6pCPTHOm/nKNfrzsMWVAv9uj6Qn677bDQaGxGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLZas06SgCHraITnHpELUX3qp9gFZmSI1kq56tcp7x0=;
 b=DWbSIxucJ0TzLnEpq81JCJFhZ61y8Y+LQxeiXDONFOPdK51MXGSViyf5H5HyKUo0miOF/LuMOnGpay9y3hJNN++7jJi1JdKcqtphgEsfImamuCQ6Qqa5f2ZsEyFBaPCLTVMEzI0kafWlLGsdarfddc3lLKR645k628kqkmDG7DDe6Hi/ywcE7tkileVJ9+EQ2khoF2ZAGEjnqdAl9HvLHHRq9QcfVaAY+fReBu1W5tm5D+EEoDGklFiS02pYgoFBQP+/38A0S65/TDMe5HA7in1foAiqQkfhotwW7LZ2NDfl+s2spK6tZGWE+vTLpXNcPsfSXXh91vfzw7W6keys+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6332.namprd11.prod.outlook.com (2603:10b6:510:1fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 15:44:03 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 15:44:03 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, "Chen, Yu C"
	<yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Thread-Topic: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Thread-Index: AQHcCuw1uJ+c6s9abkKfAjwTQIKC47RhiNWAgADE0zA=
Date: Thu, 14 Aug 2025 15:44:03 +0000
Message-ID: <SJ1PR11MB608356DE7D16654F7674240CFC35A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <7c2a1c79-7ebe-48da-ad39-11bd3cc7e6ac@intel.com>
In-Reply-To: <7c2a1c79-7ebe-48da-ad39-11bd3cc7e6ac@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6332:EE_
x-ms-office365-filtering-correlation-id: 7760018b-c8bf-4a78-5d66-08dddb49653a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cCtOV2tNYXlMZXI2L1hoTndhWjRib2FFZkhFR2R6UERWQVRjUC9mdWZJNUZS?=
 =?utf-8?B?ZWIrU1ZaM1JRajNIWkFFS0M4amhBRHJ0QUpDK016TS9QUFl3RU81T3lHNW5Z?=
 =?utf-8?B?Y1NnUWc4N29DK1dVWDJjbHRRdzdCOXhxZFNKTjRnNHQwakl6bXdrS2dKTTVr?=
 =?utf-8?B?NlMweVQ2RW1IOFJFcEJLWHFibW82d0s1VWh4ZlI5YW1NOUcvemxhSlExR0dP?=
 =?utf-8?B?YkVUdXlST3R1UFRKUlpHcGovMzZFcStscGJTbGJzTVRqaDB3YU84b2hGbG1n?=
 =?utf-8?B?K0pvNktHSU5EdzYvaEtsQTBkYXFXMUV5VnNlSEZFdEpEL2V6U1BnWjJTUWRk?=
 =?utf-8?B?WjdPbnduOTBIalF6cmswcTF0bmFJSVMrdzEyZXorb21oV3JIQ0c5N05FTzVk?=
 =?utf-8?B?RzZuYVhualFrSXpwSEpjZUx0Mmk4SGRYQVU2U01mdy84cGVSdVZEeHg5Sk01?=
 =?utf-8?B?L3k5RjRwRXk3SGkxOGhqZ3Z3bWR4WUZBeHU3Y2hSdlF4Y2duOGQwTXVJNWZr?=
 =?utf-8?B?R1djb1JheVdKdXZOQ0k2bE8xOWtJazc4WmpweVNvTWdjYjJBb29DTTExZ05V?=
 =?utf-8?B?Ung3K0FqUEQvYXNzc1J2VmtmWEZGTlhjWXNTc2JxaGVmWVFaNmI2NlFYMk5K?=
 =?utf-8?B?cnQ0ei94WnFVbHcwWjBGalR4TWUrQm1HWTBXdGM1WjVEOTVoRCtJNzhhbFM0?=
 =?utf-8?B?OUU5MTliUFJWclV1OTRIcVl1VUUxajN2akxSdGpiQVloV2Mzc3hHUitkZ052?=
 =?utf-8?B?WGtLUmVnanIwSDRQUDNlSUc2UHYvRENWeEs4dDZjSDJIb1pZcTZQZGFmNWNC?=
 =?utf-8?B?UEF3c3F3ZkpERlpuUEtNWnpyd2RYZFVRVjZnNm1sOXAycmZac3J4RUlwcW9v?=
 =?utf-8?B?UDl6Y3ljaHdzcEh0ODE3TTBsVXZTLzFjZS9KMUZ0THI3cXY5OUVCdmlYT0Qw?=
 =?utf-8?B?NzJ4L09CdXR1MkNvOXJEeng3cTdMNzFUZG1sQ2U4YnR4eDc2cnVRNDNGQmZT?=
 =?utf-8?B?QXpIWnBUWVpKdFJBd2JCZTJTNjNSdk4rbXpHQ2FPSFRsNVE3djRGUTJOeVhr?=
 =?utf-8?B?YktjOTZBa3hQbnhBUWYwR2crajFSRU40VU1xa3dzMmJQM0txTkptRnFaYXBj?=
 =?utf-8?B?RE45cVRqMW1NZXBWTUpMVXczWGhtTkRsdm43aGJkTXVDemJyYWlITUp5UzZW?=
 =?utf-8?B?OTUvK1dyVzREZjQwempCS2pCK0dtbkp1Y1hxZHZDVkNPbk1FTlBhWDBZKzBG?=
 =?utf-8?B?VW52aHY4TnBrSEFDMHg2M2NwUzFQL0ZNdE9vT0dKTmhMQkdTOUpEZnMrb0VD?=
 =?utf-8?B?clJ2S00xOFk0RWQ3VkhXRFVuaTlRNFg0ZHZhcjhhOWd0RjFHTEU0bytUL2Rl?=
 =?utf-8?B?NWMwbEdnTzBzb0tZcldxUDIwYURJWXdaMmlqRFM5enBvbTNoaWt6cjZJZTNa?=
 =?utf-8?B?QnhrYkdDNVpTTDg4OXZzUDY1YTlIdEVtd2NlODRWQ09rN1BBZzgwMENiUy9D?=
 =?utf-8?B?REIzbDF0VmYwbFF6dDA3SFFwYjhPYmVIUXhaRTJwdEVxNUpIclNhMFFGQXhj?=
 =?utf-8?B?TVZKb1Yvb3B5TXRJSjJFSDVROUhwN1hNMzRpdVpjeEJ1NVc4QjV5d0RqSlo4?=
 =?utf-8?B?a256WDc5ZkNEQUJWOTMyMUdYdlFWbFlEL3IzUnB0NkgzenRlTXZjTi9mRmpz?=
 =?utf-8?B?RjVOamo2RUV5bkpYcDh6bGZQM2c2dHVTTWk0b0ladUJieEJoNS95Q3hlVzk4?=
 =?utf-8?B?RFRaWEJ3NGJmaGo5dURhS0tobmI0aWljT29ybTRHYjlCeXBVTXRWM3Nna1dI?=
 =?utf-8?B?amovVExJQkN2VHJDTE1jMkdWZm9QcEtVMS9NZFJnYi96T2F0YXZVaS80YnpV?=
 =?utf-8?B?U3dVZnZLZjEwUlhGKzdNM2VVSkZtbVVmWXM1R0xBaUlRQ2gvK2xNMEEvOGxk?=
 =?utf-8?B?c0FPVGI3cTAxbjZKWVh4U1JGcFAvenl1MFJNSFlrV2tZY0NNOGRrMS9mbUdP?=
 =?utf-8?Q?DHdogrT5MA1I63WDy1eC42mafGdOms=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnVlVmtrZitqdGwyVE1MVFlRVG9qTGVkNGNLTGE0clFUL213TjIvLzYrMi82?=
 =?utf-8?B?cWNPR01NYTViM0drMkd3WlVNVzN6a0JqQng3dk8vQ0J5NkVscFRodFRscUgr?=
 =?utf-8?B?M3lYWXRTbjhlZXF4N0hrbUsvenVNc2xBNDUxaVNZUVR2V1pNUGRnOXFLUGpC?=
 =?utf-8?B?NE1PTWt0TWFDWDh6RXBLSndHcFVWMHRIcUtYZlk5d1BXWHdpTk5QK1lpQWNp?=
 =?utf-8?B?cTJERWI4SFRrVjh3TEhQNjUrUm9uSE9vQmhheGFhQ0UvWGdRNHJwQW5VR3do?=
 =?utf-8?B?R3lYSTRaUEZrVnU2WElUQ0IyOG9mOXU1dm9ZVUJycGpQTTZ2ZjRGQjNZU29R?=
 =?utf-8?B?Q3JjaldQV2Y2d0NBWFV0WWlSYzUrenlKNk5pOU12ZUZYckNPaGxQaS9mbTNh?=
 =?utf-8?B?QU44dXhwZ1haY2FwTGZ1bDBHY1pSYVpSZ0lLRzR4MkRjZjh2cEFsTHg5b2xE?=
 =?utf-8?B?WXJvSEJVNGlPR0J2alNOSldLZlJZOVpSUlRra2orUlVlQTlmQms4UXBVenJh?=
 =?utf-8?B?VG9pYVJVNVpHQzRIak1qZ21MSnVHSHh3d0lJL0t2MjRJZlNWZE5rYnFvZGlo?=
 =?utf-8?B?d0xxS2J4T2lMakhWVFRudlZ5MUNaYlRSTmVLYldBRzFOVGtNcVFjd1I0Y0Mz?=
 =?utf-8?B?Z1J4VHlrc2pmTHBGV1hGM2podFQwNkc2MEhDaWViK2MxaHlEQ24yMjVUVUE3?=
 =?utf-8?B?ajFuN0oxSXRReWlEOHkvUmRhMFVlWDhnRVN4WVFFQWdML1VuQjNNbUd4MkhS?=
 =?utf-8?B?WG5ETGNGSW9oOWZEMFV1cjEwbFI1OVpQWUpkS0pYNGVKK2NCQmlQV3A4TmdQ?=
 =?utf-8?B?aEV2QUg2U2l3UVFTQ0FGM014NnpaYVZ5alhuNjQ0Z2dnRUlFOGF6enhnS25N?=
 =?utf-8?B?SEpUeXJqQ0NOWjRLbllGVW1CNVRLcnB6ckNDc1dhVEpOQlBzV09lQysxcmVi?=
 =?utf-8?B?RmZRa0ErRllsMjJGKzJtWTRlNXBVUGVtVWZOV3ROUGZGeUhkM3V5RWVWNk9w?=
 =?utf-8?B?RTRHNVowMVo0ejRZdFhxYm96ZnFOcjFYdmNIZ1N0K1BFRTZTWFBQakxvalRX?=
 =?utf-8?B?MTczMWJVaTVBTUVUSHU5OSt6ajlNUnB2U1p0VjJBTXRWd2RRa09xUnVMOTJ2?=
 =?utf-8?B?UDlNbUR5QlRoazc1Wm1VcmExS1hDN0pXbmtVNFdRTkFHSnJRYXVBajNjRXBp?=
 =?utf-8?B?VTRucHdyODg5UlVpQ2tqVTczT2ljT3lqQUdOQk1pMG5FYUcvZmpaNFJXbC80?=
 =?utf-8?B?bUVQV2FVeG9RSHk2VzViYWFZL09FZFB1emZobGtwUDFyajMwcWdxZjdVa2F5?=
 =?utf-8?B?SW1qV3VRakNvczdQU1BMMXlHQVRLMHd2TmNVVVNKaWhUL0dkbEhqekE1bjhN?=
 =?utf-8?B?NGo0clA4UnkrV0RrSDdxOWd6NmNPL2djVkgxRlliQzNQOVhmWnlFektOY240?=
 =?utf-8?B?R3FNL0k1TnorQWFmd25IOEJmNTZVTk1ZUHFOQThyUnZBeE55QkhId2VIZ0FM?=
 =?utf-8?B?VFpCVjJ0YkxYMHlWNCtocFRnU1p4RmdiV2h2TW5vREwxVWZva3ZpSThRMXcz?=
 =?utf-8?B?cEQrYXVIQ1Q0WUt2eE5kSWpQdE4rRzdibkdLa2xDNHZzV2dpRCtDS3N0bFVq?=
 =?utf-8?B?RFROem04OXJpelN1V3RlL0JQTjVTNE9NeW00ZTJhVGlNQzJETHlhVG43TzBh?=
 =?utf-8?B?N2hIZ3JsNXVQbUlNaFJJaUR2V0k5OS9DN1dsY1dzdGtxZlR0YjdDbWZESEYw?=
 =?utf-8?B?THA4S0x1SDdCN0Z6MmVkSDRiYzRzNWZTNVVxMFNES1V4T3RGYitWYThWTU1I?=
 =?utf-8?B?amovbW5WbkN0T0RNQlZyTFFWaWltdExsSGNuVDVqNEoxTHRDWWxQcmpWdlBs?=
 =?utf-8?B?aFNDUTRJMHVGZmdEdi9JaDFuOHgzdWNNeDFlMVZTZElMbE1vdnpOeHB1Nkw3?=
 =?utf-8?B?OVZyalZFRHBIczZtNHZvSGFDWWVBb2ZKTjNVc1JLNVpvNm83WlhleFQvSW5N?=
 =?utf-8?B?Y0t1VHZhMUpNb01jM0MrQXdLWnFXVmxlQy9yZEFWU3dvaFhuRExrbGJDL3h6?=
 =?utf-8?B?VHpJRTk1TW0zbTV0R2dJMkFBOFZCeTlla3NVeWNaNGxVZlZ1dHlUbWF1U29n?=
 =?utf-8?Q?QPm5vwlh2aUNDH/DUnJjPNRiT?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7760018b-c8bf-4a78-5d66-08dddb49653a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 15:44:03.3748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F/oVRRPxPIYaD0opD0MtTHVg4XLvqR8N6M+Z2Rfyph3kgHLcg+JpT6FkVUnBlpkVp3PFlgeJXIrF72GH45E3mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6332
X-OriginatorOrg: intel.com

PiA+IFRoZSBJTlRFTF9QTVRfRElTQ09WRVJZIGRyaXZlciBwcm92aWRlcyBpbnRlbF9wbXRfZ2V0
X3JlZ2lvbnNfYnlfZmVhdHVyZSgpDQo+DQo+IElOVEVMX1BNVF9ESVNDT1ZFUlkgLT4gSU5URUxf
UE1UX1RFTEVNRVRSWSA/DQoNClJlaW5ldHRlLA0KDQpQZXJoYXBzLiAgVGhlIGRpc2NvdmVyeSBk
cml2ZXIgaXMgc29tZXdoYXQgaXQncyBvd24gdGhpbmc6DQoNCmRyaXZlcnMvcGxhdGZvcm0veDg2
L2ludGVsL3BtdC9NYWtlZmlsZTpvYmotJChDT05GSUdfSU5URUxfUE1UX0RJU0NPVkVSWSkgICAg
ICAgKz0gcG10X2Rpc2NvdmVyeS5vDQoNCkJ1dCBpdCBpcyBhdXRvbWF0aWNhbGx5IHB1bGxlZCBp
biBpZiB5b3UgZW5hYmxlIElOVEVMX1BNVF9URUxFTUVUUlk6DQoNCmRyaXZlcnMvcGxhdGZvcm0v
eDg2L2ludGVsL3BtdC9LY29uZmlnLWNvbmZpZyBJTlRFTF9QTVRfVEVMRU1FVFJZDQpkcml2ZXJz
L3BsYXRmb3JtL3g4Ni9pbnRlbC9wbXQvS2NvbmZpZy0gdHJpc3RhdGUgIkludGVsIFBsYXRmb3Jt
IE1vbml0b3JpbmcgVGVjaG5vbG9neSAoUE1UKSBUZWxlbWV0cnkgZHJpdmVyIg0KZHJpdmVycy9w
bGF0Zm9ybS94ODYvaW50ZWwvcG10L0tjb25maWctIGRlcGVuZHMgb24gSU5URUxfVlNFQw0KZHJp
dmVycy9wbGF0Zm9ybS94ODYvaW50ZWwvcG10L0tjb25maWc6IHNlbGVjdCBJTlRFTF9QTVRfRElT
Q09WRVJZDQoNCi1Ub255DQo=
