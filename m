Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC2B482ED
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 22:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718921254; cv=fail; b=mreAQRj+K7AIFcNXA25BbJL0oLE/MZ1efFqMy1dQ+dI8pJE4yMXvl+UnT1gN3sbBmf76CgK384aeeWbkBjYSly1euT0rXRxMWKRn94KRh6ifNoelP/NS3PGYBLrT985e4sbPnQ6B1KQWthik2jqBBnNdCf7/e1epCGiVgh/KrEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718921254; c=relaxed/simple;
	bh=v7k1j30Mr1cDyCWmLrkZydIeNXfmCAHLG2aBfa4vawU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=opPOe6uJaky1aXAq0/+3s8nVFTML4pSqIL92ZeBOZusJgybQXt756qeNwRwV7ahc18kTulYq0U48m9lAUQGtNTqLFJaZYXBLCakBwGma3QMzz4be/HBqmOeDn21Rp8zZS2leYOgt3Mw7gFe/S+lXOQ0HNvtsNu/9r/VZt0g8Wj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ps4jx6EY; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ps4jx6EY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718921253; x=1750457253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v7k1j30Mr1cDyCWmLrkZydIeNXfmCAHLG2aBfa4vawU=;
  b=Ps4jx6EY9XJpAW1bPauf4P8GoanMuUurH25TT7h4rPNaV5+bEG6ZU8+S
   5d/uy5D2oZtW0sEzH51I91/Sq3VnKp6mUdEyNR/B1bV5xAR8Q2J1ha5VP
   W3oNqGJxWCLtAfXNOh1XlJqUjR+Dj9+pMWvXnzvopuAkotBQTpnKai9y8
   mXWt1FZ0fK9kzS6rW3bcMTn+Hu/6y/SxxYaXdnDPkqeJfRHE3qwdFatFd
   SFOsIgVXwe/9Kf5IJRpZ9VTpunifXXL19iSnafhesHKXsAaNkq6L8Vt2w
   2MEu835kmiJ0jAFVam0CoreYws/imfavVzXS/BXVEzIU9zsNCfyqG3EvW
   g==;
X-CSE-ConnectionGUID: OmsKOhTTTCaqU7xp0hH2Eg==
X-CSE-MsgGUID: 191dekAvQ0yEJoxuDN/YMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="15767773"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="15767773"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 15:07:30 -0700
X-CSE-ConnectionGUID: s9hyuoISSvy7ETYnztpiiQ==
X-CSE-MsgGUID: xYQBPUusRbi0/D3kL2V19g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="46841534"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 15:07:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 15:07:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 15:07:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 15:07:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqmvS6/vuUhFAm6wHw5Iysuy1+6wWL396dvHCLjXCjt2ES5VlNVIwKyA596Nv1E6UIHnrurMBNOhWXuf6CdUkDhu+YlFsjbao8pTUyqtlKdNJp3ExpN34Caqhk7AQV5ki3kqwyZ3738GQGzBPa73/aAqnstwq7rOiGImKqq+vYQYbIacCh7IETnLbEU401BqzQ8run3P9liJh5pxl9tZ6fEhSGoXvJ17Ddq8V1PcW3871m6LT4a3aWPIcDUhhM6xsuCTgwh3KA6dIXPZbn70Waea+qGwr4yjGhiNvvDz27MAYLem8RWSKEhSHXfarZ+18mbGKEp39LOMf7UOSkBVzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7k1j30Mr1cDyCWmLrkZydIeNXfmCAHLG2aBfa4vawU=;
 b=S6l5qwb9UCrwbtJZkmCqD21DMk+E1TTxX4jjBoHGSusJU/ia1kOn/Lb3DJ2544dF1PX1IfFZPSdSQxcMOGKI0+esdF5Fufz0fvl2IfbJoOPUEs4O9PFaQzpS/ieNDQC3otQa+QoXVrKgD9YaACeP4AIfoKdTrpWtSdskmkUYzaTIhURjGTMly5EQKKLCsoFURlbr0nZuykxLlSy4NkWcVExA4L29LC5ENPsb/i4gSfSDszMrtoyOFvBfl+ECSt2Ab1baC5FG0dMvPGK8CAoHRUvwMkyI7bEDY5/vxvdj4LuBTX18aNlRV6+elHPsntNUSjh0bBC9NmOkPPL3/vIwuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB8356.namprd11.prod.outlook.com (2603:10b6:208:486::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Thu, 20 Jun
 2024 22:07:26 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 22:07:26 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v20 07/18] x86/resctrl: Block use of mba_MBps mount option
 on Sub-NUMA Cluster (SNC) systems
Thread-Topic: [PATCH v20 07/18] x86/resctrl: Block use of mba_MBps mount
 option on Sub-NUMA Cluster (SNC) systems
Thread-Index: AQHau2UDrMnMeZvDwUGVtLGcPNuHh7HROMIAgAAKEYA=
Date: Thu, 20 Jun 2024 22:07:26 +0000
Message-ID: <SJ1PR11MB608342C2230D448CF27EAC26FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-8-tony.luck@intel.com>
 <649913a3-0694-48b6-b4fc-0ec6e5e85bbc@intel.com>
In-Reply-To: <649913a3-0694-48b6-b4fc-0ec6e5e85bbc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA0PR11MB8356:EE_
x-ms-office365-filtering-correlation-id: 4dc3a90b-f29c-42c9-3036-08dc91755ede
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015|921017;
x-microsoft-antispam-message-info: =?utf-8?B?eW8wclF0a0kxTktiQ3lRM2FtOVhPemhJNEMvR1c5eE5FYWZQR204QmhmNisw?=
 =?utf-8?B?dnpYQjFmVS92dDJ2aG5BTmNrTFJhOTZ5UUF3MXlncHBrL21rN3R4THlQT2Z6?=
 =?utf-8?B?WHNqNUlHdkZZQXZXNllUUVE4Sy83ZUlLZWxPWmdhdjNKTTlkVmU4Z25tZ05Z?=
 =?utf-8?B?VFczSWo5NVpMYUs5MjYzc2syamY0WENGM1VhUG95OTZ3N1YybUh1WDNIYnZX?=
 =?utf-8?B?QW0rT2lEcGUvajB3VjZ6dUVIbnF0cy9TWm4veFVyK2JVWWRWaEpqSS9pMjR4?=
 =?utf-8?B?SmtGaStRdWxPWXJmOEVSb3hKZzhDZ0pZL25jSng0dVgzSzl1VXlldEY4UWNQ?=
 =?utf-8?B?Zk9oUWZNakNZTEFhM3VRWit0N1JNL0x0R3BWWXB4UWVTemE3RUp3RE5PNVlB?=
 =?utf-8?B?RFd0N1I3c3JqMmhVYS9IS3BsUk1KaTI0cUtNcit5UENOVWRMaDVXM3lHUTNU?=
 =?utf-8?B?TWR1U2VUTUJiZUZvVHMyYW9OeEJITGRBb00xSDFGVVVwRU1Kd3hmNkxhVCtn?=
 =?utf-8?B?T0gvM01ZdFcyU0o4VmxaVG94NTFUUmtLVStLS1BJUjkyOGZXNjRQL1RCbFZt?=
 =?utf-8?B?N3kwOTZBa0dmWDVtMmhQNHBVQmVONjdhMCtNblJmTU8vRWtCMFZmNCtYNzY4?=
 =?utf-8?B?Y0hzaFdudElpMGMyQTZEM0JlRngzOTM3UUZFaXNoa2Q4RWFVVmxHYTRaQmFV?=
 =?utf-8?B?ZFRhbUtNK2tWYTNYWjJHWHlZckszZ2hNc1VoYTdDQ05MQTFKUUJzTEdjSGd3?=
 =?utf-8?B?czRVWUhMWThDeFBxMHBOdFFtMTlZTDl2RTJ6am9ta2htN1Q2VDhtQjJLL2Iz?=
 =?utf-8?B?aEpvYmx4TmFxOURzb0lMTUdMcnR3RUM5WEMrSFI3VUFidWxKVnd3K3Iycjdr?=
 =?utf-8?B?YnpqS0hBK3NXR3dxbVZUcmhvaHhTV1FCTFRxN1psUFkyY0M4ZGdiMlYwRGY3?=
 =?utf-8?B?Y1Y0dXhDd1pKWmt1VFdwV3ozeThRSDNlL3BoSXNoV1VtMnlJeHVCT3hPSHV0?=
 =?utf-8?B?NkhtRHRaenBRcndabWQzV3dpR3BRSzBZVkI5dHQwNmFEUjZyeEp0YkRLdEd5?=
 =?utf-8?B?YWExZ1dmRVlUVGluenVrcDJxZ0sxUEhSeHlsc281Q1R5cS85VmJnNUs3SEho?=
 =?utf-8?B?a2wyYUJnUTVTaVMra0grNmJXQVlSMW9ZYVNpb3daNytJckxEckdieEdSM2VH?=
 =?utf-8?B?S1dNbG9PSUF3ZG5GaitXYjJsSTBZN0JqMzEvdkdEUllBRDQrd2dETVhtQkhE?=
 =?utf-8?B?V1VpMGF6SHRHQk5URmJvaENuc01nT2I5Mjk2YURzM2VGVWt6MzNmWHp6bHMr?=
 =?utf-8?B?RzBHRklIL3VrRUZVMHE0bDhYcE13WC96OWljY2ZLRzQwc2xwWFV5ZkE3RWE4?=
 =?utf-8?B?UCtYZ3F6NVFDeTFCeW5Wb2E5R0FGN2NlL2l0RWtlRDkzVHAxQzl5ak5Rd3Zt?=
 =?utf-8?B?bVJrM1JkYzQwbnRHMzVOV0F0NHlUendIbFFDSFNTWnFpdThKV3oySmVCM3BD?=
 =?utf-8?B?NEUvVlc2VmlUWUJ5RU9iSGpBQWhDY2pDckQ4ejVhY3JUcHJ0WWc2ZHNwcTZB?=
 =?utf-8?B?b2tyR0VjQ25lQ1hCYm1qTFRlQk1hbEMzZllMUlBENFhLTU9jcUZmaENpNkZi?=
 =?utf-8?B?UHNHVHptaWpLK2JaQWtDN05QQ3BjYnVrallrRzhDSmVlMXliUDczSDFsNjJq?=
 =?utf-8?B?KzhNOGdPS2dWRi9rZmRYQ3V1TWthL2lpbmJ2WG9FOUlTNHVKL2dYMitySVVF?=
 =?utf-8?B?dk80T0pQeVFxc0dUV1VLZFIveTMxRTRlaTkvczlKbmhCS2R6NDRaMWxGRmlW?=
 =?utf-8?B?d1owalhnVElkbDFXbHRHU0JCME1XUFR2TjVPVUgyYlJqcEVSUkRRT2doelor?=
 =?utf-8?Q?TgQy9144NZVUO?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015)(921017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emFwVGJSejJtc1pKRVo0QnhpU0NUblpGYmt2eEtPWG9QUTdnNW1hTWlEcXhX?=
 =?utf-8?B?TUlJT2I1TjczbXc0cXp2WFdxckJ6TnYzelZGa0QvYTZEc1dLMG1VQjZLMVBt?=
 =?utf-8?B?OEhIUUorZVU5VjU3Ukw3RnNjMWUwVkZKOVpabVlDOTk4NHFvK3hBUDVkMnIw?=
 =?utf-8?B?eG1GQnVYSHFzQUFQcFFveWpVSkx1d3JxUERPSWlYN2FWZTFudlRLQVloYTRn?=
 =?utf-8?B?UEhWT0MzYkJONi9pdkI1emZsdTRrRFBiUWYxVFcrb2JlS0VhaHV2em1oNzV4?=
 =?utf-8?B?akRpbVY3Z1lvNS8vdUlQQmpOcUhtRzJrcUVML0RCRDBSOWZwT1dFekVoaE95?=
 =?utf-8?B?KzkwZ0lqZ2lod2VlZUljcS9kVUY2K1QycW1TdXVHWjk5UXEyNXNiL0llbXRX?=
 =?utf-8?B?am1kTUF6Ni96aGtIZ0xHUXloUG8rRTRqc0FnMjlhb2J6akpsQWV4NEpuUnZO?=
 =?utf-8?B?SlhQV3pUclJudE5nUnRwbm5LS0xMQU1YamUxM0VWWUFPaHN4ckYraUlhN3Mr?=
 =?utf-8?B?T0lHWkFBRWFLYUpZOHBydnNqOEZ6T3EzVEZzaElGbUhJMnhMWDZvWUlJTmZr?=
 =?utf-8?B?Q3JadnJMVVpWc1RlSnVPVHZPbWRwMWlmcUdUY1RzT0lFT3ZSMjljZnh1WUxy?=
 =?utf-8?B?dXUwTXNUU2NjUnAzOEJmMXlrTFVic1JBRWV6MDFnM1NFVExlM3VlSjJGRVFT?=
 =?utf-8?B?STFuSHpjcXYya1pJT0hYTzN4akVJak1uNWp5QVJMaDdPSWhKSWYwRUdubUxI?=
 =?utf-8?B?RUpSRlRtd2piNmVHdnZtZmw2eU5QMjRISlhkTSs3eGw5Y1ZlV040MkZFNmx1?=
 =?utf-8?B?OXR2V29TaTZhRVp2Sk9abW01TE1zWkJTaU02L3UxWklBV0tnOGFPbnpjaS9G?=
 =?utf-8?B?SGxqYnZlamQxams0QlVndlQvdHBOWXYxUU5FYXc2M3JZWFM2eTBtSE1YVGpu?=
 =?utf-8?B?VTJHUXdWRHltL2YxSUx6dkh5bjVTZTA5dThTMWtyUmE1c29lc2t0RmgrM2Q5?=
 =?utf-8?B?dE1rUXliUXYwMmxXNUZhbW5NZlN0MndHa0h1cER6cDRseDdHV1BIelhwa21k?=
 =?utf-8?B?U3VTL2prSFlhNUVKWTVERVROUDFNVEU3Z3JuUCtLSnlQQ2tzVjQxNVNCaUVr?=
 =?utf-8?B?djFOSU9RajlSQlN5b1djM2lOWDdLSHVsd1pmZnR4RWNNNCtRTjd3elZpM1VE?=
 =?utf-8?B?T3NCSHRMSUZwTEc4eU0rVUw0YzBLenJCSUozS0tyMlBjWjdtdWNkNWJMMFp3?=
 =?utf-8?B?VTVWVkNYbFNQS1ppdUF6Sm54ZlZtTC93OElzWXoyMkRzYitOeGtKc2d2c1Bn?=
 =?utf-8?B?SzB1Umh5c3J3ZTA2dVd2NkxxS0VMY1E0R2ZhTGlOcGdtTGFPODBjSWZsdUp3?=
 =?utf-8?B?VEhqNlF6S3UwOGVpdTFBMWtLVlB2dUlRb3kwSzlKa2JsQXBVdUhxVXd0L052?=
 =?utf-8?B?T0p4MC9YQm4xVkFPc21aTTI4d25iZHFMdkwyem5TUHFKUkJEYWFmcVpMWmUz?=
 =?utf-8?B?T3JMZ2FkQWJlVjhFTHpLN3ErdHNNL3pDMDhDb1FoSlFVdGRyNm9XbEIzbEoz?=
 =?utf-8?B?enBHdUZhNm1hVkppUmVyVnBGZGpyZGRjRkp2TTRSOXFUekVselg5MG9xOW9H?=
 =?utf-8?B?cXVFeERvOTJjZ0tzd1pVejY4RGlWdFdJbE4zTThmbUJKVy9aZFRxVCtZTDBp?=
 =?utf-8?B?QlFqNWNmNFo5TkNybTlWTUo0WWNHdGRNWTVOMXdPZWFDeUdodzJKUHd6MW5y?=
 =?utf-8?B?NmM0V2FYUU0zY29yMTJhN2xPYTBhb21rUE1GY0FaN21KeWdMaWEwUnkxOTVT?=
 =?utf-8?B?Sld6Rk1VVHdJbXZLdlZVb1FobVVsS21LV29qOFhnbEJMWDU2M1A2ck5paFBu?=
 =?utf-8?B?NlpoKy8rUFhoNzRaZFQ5SGwvNnVaUFpGcE11U1F4WWE5NjA5Q0luSUtCdkI5?=
 =?utf-8?B?aWFqRlR1eHl0Tm1WU09IVmI3c0J5Y2tQWC9WQW5TZ0J2QkZzb0tiaUMrWnMv?=
 =?utf-8?B?QUo1V0hKM3lDa0dBcHFKTFZmV1JEYWZtc0pxUmhjT2hkTHdFNHdoTldWdkxH?=
 =?utf-8?B?UXd0eWNkUDJaa2ZiZFFuRUxJNTA5MUtkeXkzUldOem4zeGUwZFVOZnhxcThM?=
 =?utf-8?Q?wIsVcJVDYu1R0vJ3wy1GxrbhO?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc3a90b-f29c-42c9-3036-08dc91755ede
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2024 22:07:26.8350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Nm2Pk/SxrlN6U8SjepLHh5vuL9D+cxQ8I4AKGKSVF9Z27eaCWw0kOLBRMmFt6jztJI1ON5TXkPMNBxnkqo9bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8356
X-OriginatorOrg: intel.com

PiA+IFdoZW4gU05DIGlzIGVuYWJsZWQgdGhlcmUgaXMgYSBtaXNtYXRjaCBiZXR3ZWVuIHRoZSBN
QkEgY29udHJvbCBmdW5jdGlvbg0KPiA+IHdoaWNoIG9wZXJhdGVzIGF0IEwzIGNhY2hlIHNjb3Bl
IGFuZCB0aGUgTUJNIG1vbml0b3IgZnVuY3Rpb25zIHdoaWNoDQo+ID4gbWVhc3VyZSBtZW1vcnkg
YmFuZHdpZHRoIG9uIGVhY2ggU05DIG5vZGUuDQo+ID4NCj4gPiBCbG9jayB1c2Ugb2YgdGhlIG1i
YV9NQnBzIHdoZW4gc2NvcGVzIGZvciBNQkEvTUJNIGRvIG5vdCBtYXRjaC4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFRvbnkgTHVjayA8dG9ueS5sdWNrQGludGVsLmNvbT4NCj4gPiAtLS0NCj4g
PiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvcmVzY3RybC9yZHRncm91cC5jIHwgNCArKystDQo+ID4g
ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9yZXNjdHJsL3JkdGdyb3VwLmMgYi9h
cmNoL3g4Ni9rZXJuZWwvY3B1L3Jlc2N0cmwvcmR0Z3JvdXAuYw0KPiA+IGluZGV4IGViM2JiZmE5
NmQ1YS4uYTBhNDNkYmUwMTFiIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUv
cmVzY3RybC9yZHRncm91cC5jDQo+ID4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9yZXNjdHJs
L3JkdGdyb3VwLmMNCj4gPiBAQCAtMjMzOSwxMCArMjMzOSwxMiBAQCBzdGF0aWMgdm9pZCBtYmFf
c2NfZG9tYWluX2Rlc3Ryb3koc3RydWN0IHJkdF9yZXNvdXJjZSAqciwNCj4gPiAgICAqLw0KPiA+
ICAgc3RhdGljIGJvb2wgc3VwcG9ydHNfbWJhX21icHModm9pZCkNCj4gPiAgIHsNCj4gPiArICAg
c3RydWN0IHJkdF9yZXNvdXJjZSAqcm1ibSA9ICZyZHRfcmVzb3VyY2VzX2FsbFtSRFRfUkVTT1VS
Q0VfTDNdLnJfcmVzY3RybDsNCj4gPiAgICAgc3RydWN0IHJkdF9yZXNvdXJjZSAqciA9ICZyZHRf
cmVzb3VyY2VzX2FsbFtSRFRfUkVTT1VSQ0VfTUJBXS5yX3Jlc2N0cmw7DQo+ID4NCj4gPiAgICAg
cmV0dXJuIChpc19tYm1fbG9jYWxfZW5hYmxlZCgpICYmDQo+ID4gLSAgICAgICAgICAgci0+YWxs
b2NfY2FwYWJsZSAmJiBpc19tYmFfbGluZWFyKCkpOw0KPiA+ICsgICAgICAgICAgIHItPmFsbG9j
X2NhcGFibGUgJiYgaXNfbWJhX2xpbmVhcigpICYmDQo+ID4gKyAgICAgICAgICAgci0+Y3RybF9z
Y29wZSA9PSBybWJtLT5tb25fc2NvcGUpOw0KPiA+ICAgfQ0KPiA+DQo+ID4gICAvKg0KPg0KPiBU
aGUgZnVuY3Rpb24gY29tbWVudHMgb2Ygc3VwcG9ydHNfbWJhX21icHMoKSBuZWVkcyBhbiB1cGRh
dGUgdG8gYWNjb21wYW55DQo+IHRoaXMgbmV3IHJlcXVpcmVtZW50Lg0KDQpXaWxsIGFkZCBjb21t
ZW50IG9uIGV4dHJhIHJlcXVpcmVtZW50Lg0KDQo+IEkgYWxzbyB0aGluayB0aGF0IHRoZSAibWJh
X01CcHMiIG1vdW50IG9wdGlvbiBpcyBub3cgY29tcGxpY2F0ZWQgZW5vdWdoIHRvDQo+IHdhcnJh
bnQgYSBjbGVhciBlcnJvciB0byB1c2VyIHNwYWNlIHdoZW4gdXNpbmcgaXQgZmFpbHMuIGludmFs
ZmMoKSBpcw0KPiBhdmFpbGFibGUgZm9yIHRoaXMgYW5kIGVuYWJsZXMgdXNlciBzcGFjZSB0byBn
ZXQgZGV0YWlsZWQgbG9nIG1lc3NhZ2UNCj4gZnJvbSBhIHJlYWQoKSBvbiBhbiBmZCBjcmVhdGVk
IGJ5IGZzb3BlbigpLg0KPg0KPiBQZXJoYXBzIHNvbWV0aGluZyBsaWtlIChwbGVhc2UgY2hlY2sg
bGluZSBsZW5ndGggYW5kIGZlZWwgZnJlZSB0byBpbXByb3ZlDQo+IHNpbmNlIGFzIGlzIGl0IG1h
eSBxdWl0ZSBjcnlwdGljKToNCj4gICAgICAgcmR0X3BhcnNlX3BhcmFtKC4uLikNCj4gICAgICAg
ew0KPg0KPg0KPiAgICAgICAuLi4NCj4gICAgICAgY2FzZSBPcHRfbWJhX21icHM6DQo+ICAgICAg
ICAgICAgICAgaWYgKCFzdXBwb3J0c19tYmFfbWJwcygpKQ0KPiAgICAgICAgICAgICAgICAgICAg
ICAgcmV0dXJuIGludmFsZmMoZmMsICJtYmFfTUJwcyByZXF1aXJlcyBib3RoIE1CTSBhbmQgKGxp
bmVhciBzY2FsZSkgTUJBIGF0IEwzIHNjb3BlIik7DQo+ICAgICAgIC4uLg0KPiAgICAgICB9DQoN
CkxpbmUgbGVuZ3RoIGlzIGluZGVlZCBhIHByb2JsZW0gKDEwOCBjaGFyYWN0ZXJzKS4gVXN1YWwg
bGluZSBzcGxpdCBtZXRob2RzIGJhcmVseSBoZWxwIGFzIHRoZSBtb3ZpbmcgdGhlDQpzdHJpbmcg
dG8gdGhlIG5leHQgbGluZSBhbmQgYWxpZ25pbmcgd2l0aCB0aGUgIigiIG9ubHkgc2F2ZXMgNCBj
aGFyYWN0ZXJzLg0KDQpIb3cgYWJvdXQgdGhpcyAoc3VnZ2VzdGlvbnMgZm9yIGEgc2hvcnRlciB2
YXJpYWJsZSBuYW1lIC0gbGluZSBpcyA5NyBjaGFyYWN0ZXJzKQ0KDQpzdGF0aWMgY2hhciBtYmFf
bWJwc19pbnZhbGlkW10gPSAibWJhX01CcHMgcmVxdWlyZXMgYm90aCBNQk0gYW5kIChsaW5lYXIg
c2NhbGUpIE1CQSBhdCBMMyBzY29wZSI7DQoNCnJkdF9wYXJzZV9wYXJhbSguLi4pDQp7DQoJLi4u
DQoJY2FzZSBPcHRfbWJhX21icHM6DQoJCWlmICghc3VwcG9ydHNfbWJhX21icHMoKSkNCgkJCXJl
dHVybiBpbnZhbGZjKGZjLCBtYmFfbWJwc19pbnZhbGlkKTsNCgkuLi4NCn0NCg0KLVRvbnkNCg0K
DQoNCg0KDQoNCg0KDQo=
