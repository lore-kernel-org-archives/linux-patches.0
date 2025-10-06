Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E65C265298
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 21:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759787654; cv=fail; b=q10WIVRFPt2YbUa3995VMTBLF3aHgmTJbs61PKMPoH/hOw0stoJ4hor+Av1xIwLyG1mx7+JdLQZ0Tfg8K/KcTGIK0+F7HO8aIxIz2ylJ2tyQeb5ICtGx1vAbMhIu6JSyQhnggGd1zxr33LTClGHKqkjq4c6aAANsaR368jbO87I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759787654; c=relaxed/simple;
	bh=J9SXd7s1ih4SUsCs+UXI2UYZGAZKsGmk9Yec/eSJDeo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AEYq41NS3+rdNNbQ9vlKnx8mp7O3GjSeOf/kDAjdji2CXGMdg0LY4KY55CFoNWDI0PqNo/3FasEhKbqXBdUW4idvBm5CYY7khrEGRVEWrdT/nS+b05VQONaiMwxRXm8UJm6XOFyuA4Kn3hVeP8iXjKTvdUEmyJWTLnbGrf7Ky1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xw8Dl9wM; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xw8Dl9wM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759787652; x=1791323652;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J9SXd7s1ih4SUsCs+UXI2UYZGAZKsGmk9Yec/eSJDeo=;
  b=Xw8Dl9wMsXCj/EOFO74bDEKKutwYOj7+Z+/8VFkCwRPJnTVw9VRPkh50
   E5CuGMKLkxT74KWsFhpSjCXFpT72BWNE2Cj1pOqMfmaCQrRXk+J7zht9m
   dQE77TDtXKfqJNJ48Sdo0CDE5eSZ7WbrmZc7Gy8bNW1A+7e795pW2yLn0
   2zWOcU8vzDmBRZH9afGnPm58wVQ4F5caAxngdirKNEOIv7oNONvBYdrvw
   Bu0jujztzEoYAZBhnjXgSp9xIFzuTzl0oLkf0r6Vi5D5wHpfzrDQ/kP5W
   ZR16uGm1BYj2bUfvxk4kmvgZ0/EUjv7PnJVF9qxo6ez5Dn8uCuBOerflw
   Q==;
X-CSE-ConnectionGUID: T9yplD8gR9qIUC1j2V7yNg==
X-CSE-MsgGUID: 2tDC85gEQx+Mxpxs/c/85g==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="49523451"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="49523451"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:54:10 -0700
X-CSE-ConnectionGUID: Ir5OpOU+Q1WMknF+Z5QK3A==
X-CSE-MsgGUID: mgdhRJtxR7eAhklBt4LiWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="203723638"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:54:10 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:54:10 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 14:54:10 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:54:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yR1Wk9FLgAUPtDvBdjtjJXA+Ex0EXbX3Y8boUC/LhhtyAm0a+8mHTKnmnDwtOxJwx2BWEpM3nQZqi+M4x4/afPgksU5IBqRZxLBsKN5oAAEvky34As2/jOOsMoXXFtx4QP2yxPBJ6JFLKW73bqFzWTARxkguFmCt+Vn6Mjv11N1JRc057l+v1ulAha/cZoEWonMLEOXtdtzciuNMDv/ssGYfVhRz5gAe6CcYvTxHZWB7W6VP4AChwjICiVW9OT4neIhXhl3c3OhMq78z6b2jeAFZU5ULgxhiT3TpGj5mxbykipXAyFGVEcV5Knlqe5n/rnuEdVr10aFPPJBms/n4yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9SXd7s1ih4SUsCs+UXI2UYZGAZKsGmk9Yec/eSJDeo=;
 b=XE4TzkMfo5XuinAm+/Hn2PIsIyEI/o/6WB4r+vbo4w/wp3YXLroSpIaL9xjv4ThO7P/e7MJVL3uqc4Au1jTSun2rB3kw8pWKvoqGdX980vP3uT+HRj/iPyDgvZbhI1tLDU+kOmB6kQNgli4yEnGId3C6tdz6tzQrpmR1P7/SW0YV+6rJFjBDAeacPsZEE8bA0H92YUfLD4L78ey9wOXBBUb2HhvYEj12Qb+4LRZM6K+GeIFPQVIC3n/nZXNRCXyvCvRxS6d8faKx4H1/Ak6ovB0xNqXviOO4ApbLjQwOIyB7EI/ffLq4WjDcU85gc5quOFL56w0PSDtyo0XEf1g2bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB4879.namprd11.prod.outlook.com (2603:10b6:a03:2da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 21:54:04 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 21:54:04 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v11 17/31] x86/resctrl: Find and enable usable telemetry
 events
Thread-Topic: [PATCH v11 17/31] x86/resctrl: Find and enable usable telemetry
 events
Thread-Index: AQHcLleVK6/xd5m800eViTfH4xVsRbSxJL2AgAR12ACAABqJgIAABFUw
Date: Mon, 6 Oct 2025 21:54:04 +0000
Message-ID: <SJ1PR11MB6083F8C67C6C8C5DBFF3832AFCE3A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-18-tony.luck@intel.com>
 <aecb9aaa-5b94-4787-a976-a633831596bf@intel.com>
 <aOQfevoOYWsftGG-@agluck-desk3>
 <9a6f5016-0997-47ef-b7d9-2dc4c578e345@intel.com>
In-Reply-To: <9a6f5016-0997-47ef-b7d9-2dc4c578e345@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB4879:EE_
x-ms-office365-filtering-correlation-id: 760f3cae-c126-4fcf-f65a-08de0522ddcb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WUtkcm51Rk4xakJkWStuTjAvNS9oQm9ia09TbEJZOEZHTWRlU29oZmhZWWR6?=
 =?utf-8?B?NjAvNHlmcVgwLzZJb2poNTFycmtzem9pZDE5bXU2R29ub1VvOWFDSmVPUUxC?=
 =?utf-8?B?Tm1TblBqOTB3ZTNubkZTNVc4cFVMdm8zaGFQRjRjcVI3M0pIZnp5TkV1Vzdz?=
 =?utf-8?B?SFh3UVRNWVpTU2huQkViU3dSSVN3RWRES3VaWnNDOCs1aVRKcjcxWlZ6N0xI?=
 =?utf-8?B?eW1QUmE1bEpBV29VV3RpOGZSYmRCeWR0bCs5aUZVR0hNT0p1eVZBc1R4QXVo?=
 =?utf-8?B?NzJXVEpHT0I5VEJBWlJySUsvaG5JSE8zeXlIbE1kSi9oOHRkc3JaRVNvcUw3?=
 =?utf-8?B?UDlPVjUrQWlzS2VRempCSUxFZzJTT3V0SkhIUFlEcE1Dcll3SERWZjdZQ3Za?=
 =?utf-8?B?MFh4cDhmZS96d3Q3Vk5pSHArTVBibUlBMmd5a2tlVExjVUdjV2R0UTFiMDNW?=
 =?utf-8?B?S0FZZlA3cXpzb0hNUHZIVFdnR1JYenMrL2c2a0RNTlZIZWZYbDZydDBvaVla?=
 =?utf-8?B?SVdFUDRsK3JXSDc3UUJxU0ZBcHlVUFlHZm1jbU5qTDhpdFNCa3Fxc0s5OTNn?=
 =?utf-8?B?TjBLR2IzTUg3WGxhaWtRZ0VOdkRpWE05RjNuQnRVZnBOQXllOWdxUjZWRkNZ?=
 =?utf-8?B?NUhTc0NvYW1SdFRHZTJDb25JTTVudUI3dFBkbGV2ODBLYTMrMjY5RXBBUnZO?=
 =?utf-8?B?bXpDZ2NiNmdXNWptUkI2WkhpY3RacDdmVkR2ejNsOHhWZE5zOEt3KzdTTWdJ?=
 =?utf-8?B?Y3lZb0ZBNkRNN3V3ekZvL1U1eWlVWkJ2YmdZMjFRaVVEQ0dDL252bUF4ZXhL?=
 =?utf-8?B?MG5uWS9ZZml5Z1JUOHA2cVJYRmRud2l2Mjg4TTVpWXVEclNCZlZYK0hadm9a?=
 =?utf-8?B?eU9aby9NN3lUQjArVDlSMjEzdWxDZDQxTmtWeXY3WStBbG1iWkxxb3pVRWZz?=
 =?utf-8?B?NnlPMUpTckFUZW1LVXdseTVkRXpkV2dQdWZXNHB5K2Q2Szh6Zk5PQmsvY2Q0?=
 =?utf-8?B?VVc0NGFvZ3VZdTdpUlhoc1FqRkhLOTFtV0hNRldGV2N1ek9xRzA2K2ZWTTlO?=
 =?utf-8?B?YjdjV0dVV3dWakFFTEZoYitxYUZGUDJrc0VvVkhMSExXRnh2MUIvdnNzbnBI?=
 =?utf-8?B?cng0UE9YMUtEb3gxaGNjYnFhTEpYRlBjTHNWdGxsUk9xWGx5LzJQalhZbklE?=
 =?utf-8?B?MnNHUldEL2YrOU45OFVZS29SZUpjaTFOR2p3dEJOUzJQNFUzbFVORHZ1Vi9v?=
 =?utf-8?B?K1NBd25STDdVWUtSU1NZM29zOEp6RXdhVlhOYS81Nkp5ZHpUS0xONXZWUVp6?=
 =?utf-8?B?cHV1OEpYMm5UcSs0aWVGYmc1cW4xbEVVcTZNM1dFdHVLYjNpbytxZ09aUkJE?=
 =?utf-8?B?a0xIVEY1c3FFUDcvZks0SG00QUZsaE5IUEptaHZPOHAycWpmckVSTHBvbEI1?=
 =?utf-8?B?K2JzdXdkWmdMTTVMbDF3aTc4TkNkekQrUG1ZbGVPZkZWa2JIRGFsSlVTYXlP?=
 =?utf-8?B?UWxQY2NLUDd1NkVYa0pYWkdZNXpRT1pkTXZXb1c5dzZheUFyUW9USVBKRmg0?=
 =?utf-8?B?UEM4WjRmZDVhNnZKYkMvUWhLRjhrQWpKSzdad3hodXh0MFNKUUF0cWhINDhH?=
 =?utf-8?B?Y0RrWTBTK0l5Ri9jQlRkR01La1o0Z2o0N3U0SFVlOEtabjRSaHBJQ1ZDZU1D?=
 =?utf-8?B?MmQzb3Z5cWpiQlNmTzVvVkdsNmZ5S2JGYjh5dGZoTHhQbmdqelgzcGJPd2RP?=
 =?utf-8?B?R3p3bXFoY0ZMblBueHNRRUdQMERma01zY1E0UVU4eFdXMjY5aGRYWW56OHlY?=
 =?utf-8?B?Vjk5SCtKSkpGWDlZRkllbVNSandwZVplekJzRy9TUHdZNFNVeEw0anJEc2ZQ?=
 =?utf-8?B?Y2JhdFIrNlFuc1ZlUklzaXA1cmh2SEtxMlNxenRlYUFYaXk4andkWEtzYnZT?=
 =?utf-8?B?V3VPTzRhUEdGSTNPNjQzYm9jV0cvelQ4V3U5aVVhc2hkZ044OElnUnJuOGhk?=
 =?utf-8?B?bDFXMHNLNWRSRkVHRHQvbVNkRW9kSm1LZ0MyOXNUWGluR0lvM3FPYkh3Q0pW?=
 =?utf-8?Q?cHCMXT?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZE1LRDMrM3I5L0dvOWdlS0pKejhyNi9DcUNpdHdzNXdjQXFpaUhTOWp6RWpW?=
 =?utf-8?B?dnhZOW8vMDhBeHJGMGhBTUh2ZVpQYjJRT0JuZTk4WnFtY0VMYTJYUktnTUJs?=
 =?utf-8?B?RGNTN29EaEsxbWxhWkI1enhwQy9pQ0l6eHR1OW9mZnJWZmhGcFRwclNvYzFR?=
 =?utf-8?B?SEtUa3NkMWpDR2FjMG1aQnowR3hveXplekpoTGY4MXh5YTZreFFpTmhTbUow?=
 =?utf-8?B?SlB5ZkYxWnlWWWR1RUZ5dUJNbTdLL2ZRaEE1TFRlZjFrNjdzbndYcVljOWVK?=
 =?utf-8?B?V0JZOUNGM21iVHlLTFpBK3B3SW5rckZCMCtxYkxMOXU3K0gxZFFzWmZOMGxs?=
 =?utf-8?B?UUxUclhRa1V0M3kvaU5jT0d1LzJ6SEtjbzZ5aHhCR0lFTFN0U0RrazUvclpv?=
 =?utf-8?B?dUhKUGx5Y3NTSjcvZXNkU0NGblBCMVJ2RFRnQjMxNG1rSEpmbWpMTUphMm9a?=
 =?utf-8?B?VTNwWWFobzN3WUY2dGlyOG56bGl5TDBIdVBscmI2NGNRd29CK2xVdDBUTDZ4?=
 =?utf-8?B?bEZIbjVFNTlVMFRoQnp0SlJKdVcxUHFiVFdDaGxFMk5kOFZjenYvN0MrckpK?=
 =?utf-8?B?RVdMM1pwY2c0L3BOZnZWNXFML1J6Vm0zRkJwM3BpcG1CS0R5RHJiRjNMdmRl?=
 =?utf-8?B?VDMwTjAwSTlVQ3lsUEVCWGxnTW0yMklCZUdLWk0yNlRGQmFRRDZ1YTNaWllT?=
 =?utf-8?B?OWY4bDFsSGtMdy9XQ0JHNlkzSnVCT0ZCQWhmV05ReFdRSmpyY1liQ2tMVXlV?=
 =?utf-8?B?aWtoNmxGbENheHV6M21aKzlVSVNEcUorcWJDcVpadDBuS0VzMVdDNFVQUkRi?=
 =?utf-8?B?bnk1SExXOExhSUZoUlFoL09rTUhBeEpNS3dkWFJnbGRyQ2oyN0R6ZDF0OEt0?=
 =?utf-8?B?WXhmVWJIYytFN0dWUDRscy9wcWlOK3RrR3pnNG94ZFZOb2dIWUROREIvU3g3?=
 =?utf-8?B?TXFJQ2xORVBQalltTFdNNHp5azltNXQwak5nNENTQ1dEMDhvbGNJL0VlKzhR?=
 =?utf-8?B?bjNBNldyc2QvUEZLSmRHeHFOaDVHc0NJY0NwVnRaYlZRc3J3UXc2L0c4RVdC?=
 =?utf-8?B?aWFtREMzbUdvbVlWOGxyU2FPbjBFd1hNaHRyZ3FEZmhPUENFbkdYRktiSDVy?=
 =?utf-8?B?bUdQK0VVOTArZDFCTG5BNW1Sd25BUmFIVnZMYVhPWCs5eGNiSHNjNDlKZ1cy?=
 =?utf-8?B?bWlYeEpsWGM3aVc4U21ZYllibWpacDNWMTJROTQ3eWJIVTF0K2o0aHZOcFFS?=
 =?utf-8?B?ek5UampMNjUwWXg5YWszWG9CeWV3OXBJenVvQWx6eHhKNXZ5YnlWVU4rSVRH?=
 =?utf-8?B?a3JpajdYQ0dwanBKSTlUR25qeDdCdEl0THA2c0JJZUNISDIxb1lSdy9rbHVS?=
 =?utf-8?B?Rm9KUnpyYzNGelJmV0RQZ0VIWVN4MlF1WTUycGtHVkw1TGJQM05iRTZ2NWlO?=
 =?utf-8?B?dDFBcStyL3p2aHlxWWZUTC9sbE0rUHh5T01jcnpHWlBWbElmOEF2ck1aNE5R?=
 =?utf-8?B?Nm9RTlNybU1pOXg0ckRmZDV0OXg5bWFxSlgrZGwveVlxbi8xR1NEUzNyc3Fh?=
 =?utf-8?B?bk02enQ0aWF1ajdiZ1pDcWZsQlc4a3hjN29GL0VGNFlyaGtHZXRCbk5uek10?=
 =?utf-8?B?dDNvZ3EvOTJTQVVzZGc0UzdEWFZPL0pERVZYSzVkcEJzVTU1WVgzRU40Q25E?=
 =?utf-8?B?TEVmZUJBREZYUjBtZytremZ4RjRXaGhTVEF5cTZIMHZ2clNuQU1xaE5uSGU3?=
 =?utf-8?B?Y2Y0VXFJd0ZVWDIxZ0pCZ3IzSy9WYXBqQ0VlMTNCQ3c1R3NLRXVTbzNRZjda?=
 =?utf-8?B?UjhFcXFPM29qWVk0NUlvRWhMaVA0ZjM0VHY2MU1oTUtaTHU0dTVZQkdNd3o4?=
 =?utf-8?B?UGhOVnBZYk5CNkIwYjZ3UTlxTnE0NDJFK3B5OE03ek1BZWFNSDlaSUVhbEhU?=
 =?utf-8?B?MnYzS1Vkclhmam16YTRBc0JvOVVBUVNmYTd1aDViSVNrZjJNdjBxVU5UaEZZ?=
 =?utf-8?B?OWpWb1BUemRocjEwY3RFY0pnSG9jRUV3UVhBcHhZcHRSQVVuMkt6SDNvbzdD?=
 =?utf-8?B?N2F2cW9QdFVTRmV3OTNvZ2RpNVJGc0I4Z25kU3hLMFNKZnRHUEFscGJCSzlX?=
 =?utf-8?Q?zL2Joq42ZbsNQIMB3NuQEqIdH?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 760f3cae-c126-4fcf-f65a-08de0522ddcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2025 21:54:04.1186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6392myce4JYCE7WQYKCg/uy6FsMzWOIMjZ/NAuBtTXLFPPQwk3xxwAFUZfsUOgTcVE2JMBVT1rqCexRiu+xvYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4879
X-OriginatorOrg: intel.com

PiA+IEkgZG9uJ3QgZmVlbCB0aGF0IGl0IHdvdWxkIGJlIHdvcnRod2hpbGUgdG8gc3VwcHJlc3Mg
Y3JlYXRpb24gb2YgdGhlc2UgZmlsZXMgZm9yDQo+ID4gYSAiY2FuJ3QgaGFwcGVuIiBzaXR1YXRp
b24uIEknbSBub3Qgc3VyZSB0aGF0IGRvaW5nIHNvIHdvdWxkIGJlIHNpZ25pZmljYW50bHkNCj4g
PiBiZXR0ZXIgZnJvbSBhIHVzZXIgaW50ZXJmYWNlIHBlcnNwZWN0aXZlLiBVc2VycyB3b3VsZCBn
ZXQgc2xpZ2h0bHkgbW9yZSBub3RpY2UNCj4gPiAoLUVOT0VOVCB3aGVuIHRyeWluZyB0byBvcGVu
IHRoZSBmaWxlKS4gQnV0IHRoZSBjb2RlIHdvdWxkIHJlcXVpcmUNCj4gPiBhcmNoaXRlY3R1cmUg
Y2FsbHMgZnJvbSBmaWxlIHN5c3RlbSBjb2RlIHRvIGNoZWNrIHdoaWNoIGZpbGVzIG5lZWQgdG8g
YmUgY3JlYXRlZA0KPiA+IHNlcGFyYXRlbHkgZm9yIGVhY2ggZG9tYWluLg0KPg0KPiBJIHRoaW5r
IGl0IGlzIHN1ZmZpY2llbnQgdG8gZG9jdW1lbnQgdGhpcyBpbiB0aGUgY29tbWl0IG1lc3NhZ2Ug
dG8gaGVscCBjcmVhdGUNCj4gY29uZmlkZW5jZSBpbiByb2J1c3RuZXNzIGluIHN1cHBvcnQgb2Yg
ZGlmZmVyZW50IHNjZW5hcmlvcy4gSSBoYXZlIG5vdCBlbmNvdW50ZXJlZCBzdWNoDQo+IGEgc3lz
dGVtIGJ1dCBjb3VsZCB0aGlzIHNjZW5hcmlvIGJlIHNpbWlsYXIgdG8gb25lIHdoZXJlIGEgdHdv
IHNvY2tldCBzeXN0ZW0gc3VwcG9ydHMgTUJNDQo+IGJ1dCBvbmx5IG9uZSBzb2NrZXQgaGFzIG1l
bW9yeSBwb3B1bGF0ZWQ/IEkgZG8gbm90IGtub3cgd2hhdCByZWFkaW5nIHRoZSBjb3VudGVyIE1T
UiB3aWxsDQo+IHJldHVybiBpbiB0aGlzIGNhc2UgdGhvdWdoLg0KDQpUaGUgY291bnRpbmcgaC93
IGlzIGxpa2VseSB1bmF3YXJlIG9mIHdoZXRoZXIgRElNTXMgc2xvdHMgYXJlIHBvcHVsYXRlZCBv
ciBub3QuIE15IGd1ZXNzDQp3b3VsZCBiZSB0aGF0IGluIHRoaXMgY2FzZSB0aGUgY291bnRlcnMg
d291bGQgcmVhZCBhcyB6ZXJvIGZvcmV2ZXIsIHJhdGhlciB0aGFuICJ1bmF2YWlsYWJsZSIuDQoN
CkNYTCBzdXBwb3J0cyBob3QtYWRkIG1lbW9yeS4gU28gd2hldGhlciBhIG5vZGUgaGFzIG1lbW9y
eSBjb3VsZCBjaGFuZ2UgYXQgcnVudGltZQ0Kb24gYSBzeXN0ZW0gd2l0aCBDWEwgc3VwcG9ydC4N
Cg0KLVRvbnkNCg==
