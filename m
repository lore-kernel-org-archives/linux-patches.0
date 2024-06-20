Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286F084A4E
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 22:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718921550; cv=fail; b=qTO+UAHjKajkKvPrD1IQh0kLD/5DZRr2S6G3ATUdhwzQJ8u+v9n5p6c38XTYyBYfnlJtAvqkldJoGzZANq2I4dXwBi92amYpsftZWQNrPymDRPB4YjpX/P6DJm3u2N0ynaUEUDkSUScyOMBdeEQgetSB0GpHsIpc794ZhoACzX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718921550; c=relaxed/simple;
	bh=h37fNZ9b/i+Ic/HsSVnnG1hR5DmP/GaRq1UkYm1Jx7c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XXVJEoPPGm1ilwArJhTbjlPimJnFEcZDvSWuvqC/DYwXKfygwfuG375AN7iIKKKxXYYHVEKB9ZjzpFFAk+mlZTsiNpK3c6p+H/kFji0bEonklzRSH/txwZ4a0LWGY7gIoOOatO3D9JAH5pV8RhApATQVHk2QpUSAW10On4eQ2fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qzz5n+DS; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qzz5n+DS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718921549; x=1750457549;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h37fNZ9b/i+Ic/HsSVnnG1hR5DmP/GaRq1UkYm1Jx7c=;
  b=Qzz5n+DSuUhh4Vj/8tjYlE2JI/aJE2KHXvZRFMYy1KnY5ZZe9YwdUVmW
   6iVh1PMP938Mt6FkHHkDzTwLJxN3NatvHC9fWxuimoKKVpPvHyQ9eoJCb
   Wv3ZUKadFXLz67JuI8gJhwuVpAUpUGosA8pWjV4hdnOGAEtD0DcvJF616
   KnLF3dh5EH9zvHBdPEYfMKmjk6ZX9VeqWZP3Y1OdgQQh0ptwZd6eTToK/
   ngyx8jMSEkCORYWBH8wIU0Tlh5NuXEgqJjx6YvG6OExRhXjTmciMquDNQ
   ImnO0ySdyDyzbdTNmgRcThzj7D4iK1t1kC5MD+Wi7HTKcE5Ry+vuv36KV
   A==;
X-CSE-ConnectionGUID: KSEXKOJiTRiBNMY8qrIXog==
X-CSE-MsgGUID: P3Ky3/N8Rbi4nLGc3wzCfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="41340937"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="41340937"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 15:12:17 -0700
X-CSE-ConnectionGUID: JOyUgwH+QZKbipvMcVgrBw==
X-CSE-MsgGUID: LQpWpqUQRmuNTNJmWTaSTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42843152"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 15:12:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 15:12:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 15:12:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 15:12:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDkqviFNICcf6MwvG8Ff6pFp7X0tc8/1oohzJiqf5+pHGJZTOIP4Vg+ppGCZY/NzhfTSoVo0upN10JnbV3I7Qv7VtGHVbMkqAUxBnHxRGSu6T760JfoZJPDQHWgHfe4w+hZ3t3kOlfUkH3loDLczxOGH2gwlSPPtQEqH8INiyG+d681v+CNJslHhTBEvJY0R/kckeKuMeGjBkiL5lbfZdGbuPQqjX26BlopJu3x3WcI6U/l1I6lmYuBIzCzM7GL1d79YGmu7onoBK4LCTl7fuiitaoltzAavteMrhR5f2e4o8aErX3ih2lWvvlFHDdFr91bsKU1FMOJAgiYxuQpAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h37fNZ9b/i+Ic/HsSVnnG1hR5DmP/GaRq1UkYm1Jx7c=;
 b=UyhMik47dnmBpcCUfvtBFlm+TJMBxu+E0gaP4gTB0dJycRTLApUT1/Zlh+PpIhZS3/nWM3egTgczhWMZd2yENYG+EAEI++WgxjitOfuwT+hKAgOuU1nnIdFUrxq+MCPUXA5POZ6uwDrD/QRF67+kmnZTk1uSGADvc7J4lidQbP0KOg0Nj3c3Ail9azodKBtLY+v3tDPkUM0XkTEkjiAi74Go/9mLX1uGwfVFc9K2AbsOMc5tsWTT7tPMN8lLKt+idAltLvEPR11jwpxU5n5wZf1mrhHqjqtJ3rrsIQOCBAej70zeCTj5ZHRjhQw9w6WHRZ23qL0TW5j267W7Z9LZxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5136.namprd11.prod.outlook.com (2603:10b6:a03:2d1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.22; Thu, 20 Jun
 2024 22:12:13 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 22:12:13 +0000
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
Thread-Index: AQHau2UDrMnMeZvDwUGVtLGcPNuHh7HROMIAgAAKEYCAAAPUUA==
Date: Thu, 20 Jun 2024 22:12:13 +0000
Message-ID: <SJ1PR11MB608307FCF1521E1F0BBE4B54FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-8-tony.luck@intel.com>
 <649913a3-0694-48b6-b4fc-0ec6e5e85bbc@intel.com>
 <SJ1PR11MB608342C2230D448CF27EAC26FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB608342C2230D448CF27EAC26FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5136:EE_
x-ms-office365-filtering-correlation-id: 64efe6e7-3323-4722-5977-08dc91760997
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|921017|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?MlRBcjljNTdsb2RRbjJYMWpQODRFNDM4Z29IWGY1ZzBlSHdRaUZVNXB3dURX?=
 =?utf-8?B?VVJSYXdWK2ZHSWphMFZuV0Uvd0UyUmNJYkNQZ1ZjMFNpZlB2VzdLaStBaGkz?=
 =?utf-8?B?SjNvb21rN1lEUUt3U3k3Tzh1QjNHZVl1RnZtWEVFMlo0SCtWN1hFTG5xRXha?=
 =?utf-8?B?VFpjeWlDQTF4czRYYmlDZy9BR1RId1Iwb1ZiajRWUXFjMXN1Z0s4aHp0M2p2?=
 =?utf-8?B?d1FjSE8vc3VGVHVOcGRkTVR6Vm5iRjVaL3ZxQzJFbGNjbDAzUnlPUFJWUThR?=
 =?utf-8?B?STVxbzZyYngwWkkzMG5PbVJYUHZRQ2ZLVm5XUllhak5SRUFFTWxiZE1PSkdX?=
 =?utf-8?B?OFQ5UWJveUdwaHArT2ZJdFdiWlpneE1OK2RVRGVGNzM4azlLeWlLWXB1T1ZI?=
 =?utf-8?B?c1Q0VFo4b25aWjY4b2VEY3NNVnFidnlydk1OTVN1QU1yVi9raWpFSkUyVHI3?=
 =?utf-8?B?dC9UdEVzcGxlQThUb0prbmNzV09UOTMybEFQdmluNU1vb0d3RytlZ2lrdUJQ?=
 =?utf-8?B?R2pWM3d1bUZXdk1QWHdOMFVEWlErRHdMcTcrdFVHMUdwVlZUMDlia3Zrakgz?=
 =?utf-8?B?L251UWNaY28wRDExUmREZGxZOFkyR29leWpNUVZqR3FsZEtHcEpWaUxOYmhH?=
 =?utf-8?B?cHlyOC9mOEw4bW1IL3hia24rZ080UEJyWU1tV29YYzhrbWdwT1JVcG5sWXNp?=
 =?utf-8?B?OFYxZVBINTVKVnVoeExuMk1maFVTa2lWZXlLVGsxWFpmY2E0a1JUQzRBN2lD?=
 =?utf-8?B?OW83dEdSY204RXl4VENjemJ2aTdPcnllK04wYjFrWG1RSVoyN2p6N0hTbjVr?=
 =?utf-8?B?RUltaUdyNHlTM2E2UG1ZZU5oRWR5RHdaVjI1TTR1V2g0eU10aTlzUDZWK3Jq?=
 =?utf-8?B?R2dSbnhIMUlOVkpIVGpmaFNwYVExYU9Ia0RpTUpZdXRjWUZqVGVvUzFUUEFB?=
 =?utf-8?B?NTl0S01HSm5RVmozMmcySjN5Rk00OEhRTzAxVnMrZStxSkQxZ1lWWHNpRDh4?=
 =?utf-8?B?NFF1dlJLbGZ6WHRLenRSYUFqYWk1YXg1U2tUZm85K3Y2UkJ3TldUc1ZnSU5h?=
 =?utf-8?B?Y3p3ODBrQ2tQa09HQUJuZStmTkloOEE2RG1iQ3dNemw1ZXpxejQ5ekVXTWpi?=
 =?utf-8?B?VUwxTmxzVU91Y2dObHVuSk42UDByZ0pSbDF4ODljdS93eUptNlpqMWRMcFA4?=
 =?utf-8?B?WmlHZWJSRmhpRTJtL2pCNm5rcFpCeVJZOUdmWlNDY0Y3V01XZkVSOFZLSWJp?=
 =?utf-8?B?Q0Y0M29uaWhOYjVpb2R5Mlo1ZmdkUGpvSkMrcFpjWjlYVXRBcmlzNnBCcG9J?=
 =?utf-8?B?TEJsWkdHd3FlMnNncThlem02c2FmQ29lcm5hMDBka1ZhdkJuNFhUSVRTM0My?=
 =?utf-8?B?Z2pkTkdrQU9Ud2MxcHRRcFpYNGt4cm81UVdPYUY0WEJDMWFNdGZkcDEyN3N1?=
 =?utf-8?B?QVJzZS9GTWZ1bHZpSnVZZDhXdnkreTZvbUJIaTh1UEhjRWRjQVB3NDM4cHlU?=
 =?utf-8?B?cVg2RXBHK3Q1SWRhTEtWdlI0ZGNhdkEzcDhPV2hrVTluOEpXUzQ1Sk4vVWZV?=
 =?utf-8?B?SzBZVFo0VWNqVjkzdlloNjdKdUUwWDhudkZFV2hOZlUwNWMraERXYm91NEdm?=
 =?utf-8?B?TUtxU2lqeTVFQjlRYnhKLzRiYTFMYVIyazRBWGtuRkhEajhoQVluY1B3b2dk?=
 =?utf-8?B?M0orR3grQkRHUjFiYmdZM0RmNHRkNnlnWXZSWWhwU0tDeDN6NWtTZUw5Wi93?=
 =?utf-8?B?SWJkcG5wZWthRmdRM1VJaW5tK0xIUDhjRXRBVHlTV1drSjN1eGNPWDNyMlZp?=
 =?utf-8?B?ZzM1SkZuTmQwcXdhMjFzUGNpNy9ZZTJ4V2NCekZDNTgwSjdWamdEVk9pMndO?=
 =?utf-8?Q?H5tCfThdc9j7/?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(921017)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXpkaW1vQmZNSUVvRXVRdC9YUGtuZFA4NGN2RE9WYmEzQzVwNFFwZExaR05n?=
 =?utf-8?B?YWozZDNZR1d0TGJsc0hUNHVhR040Q0F6OHg4Y3hWbU9KeHo5UHFUQUxuU1ZG?=
 =?utf-8?B?S1VQVnNNbnR3NzFTd2pBZkI5UzZQWXpGeVVPenVLcnp0QTF2RktlbXpvRWxW?=
 =?utf-8?B?bHVKWDJzZ1ZwSFZJS0MybituTlZtTUdZQXdidndpRFNIUlErTlZOYURNQXF2?=
 =?utf-8?B?R2ZMa2FEMCtYeDIrQ2V0QXA2amJsUFFTM0pqWDdVdzZabEtVQWZrdEwyVXdp?=
 =?utf-8?B?Mjg0VEFacHBkaVJBSWJXblVvazZURDEwcVFtYnczcldWNitRbVJOL3JibG9U?=
 =?utf-8?B?QnNuZkhITGZrcXQ2SGQ4TDJZOTgwV3BWdEpYVlVHa2NZVnhjaklJQkw1dmhl?=
 =?utf-8?B?dS9PY0pmRnhOL3FBWTlaZks4c3ZvZjFMLzRNU2lsVkw4VDJTcm5aN3hXWS9r?=
 =?utf-8?B?NkJGcG0vdW5sVlVabFhGNUk5OGdobTFNUWhVYUJtSGw0djJTYTZKa2JZOWg0?=
 =?utf-8?B?VmRYbCt3SW9TVCtkK2pyQzQrcGpNdVVEZ2t0bWgyYytWR0RTNTFWOW9PNW44?=
 =?utf-8?B?ck90cmFxU1V0eFBwM21SK05YVis4dVMyRWU4RGVPN04yQytWb2srclhJakZE?=
 =?utf-8?B?VEp3OUZ4NDZCVThIRkdYM1ZjVkphOVdDaEl3aGxPSVg3azZKVzZqL0dwam0v?=
 =?utf-8?B?dUo4ZzJ2Uzk5b3V1QU1FWTh0RmRWWHZrWVd6QzZPaXpyckdkU2xMZkt4NitS?=
 =?utf-8?B?bHNjSUpjUG00a053c25EL3JpMVFML1p2b3dERmo5dnpLMzlaTklmM2x2OXhL?=
 =?utf-8?B?YlhvNzBFNUdaTDB1NXh2dGx0OEUrejFJWUdXUm5LL2dhd092RlIvM211Yjkw?=
 =?utf-8?B?L1JJTUh6UWNqRTlUY0V0OWNGTkcvaWw2Zy9EanQwRkVuUDZpSENtU2ZXQlFS?=
 =?utf-8?B?bENFN0NxejJuWXFmSkhuc0JicTVUOGxNeU84eERYUE44THd3aVNsVCtnN0py?=
 =?utf-8?B?TU0zV3Q3d2IramVBczFCN3U4R0NPeCtUUms4L3hFc0UyQldReHVTalB3VjN6?=
 =?utf-8?B?NUFCNUV4cGdsWnBSd0NUY3VUNWFDdHp4clF4OVNhRkdUVUthVU5qczg5enl1?=
 =?utf-8?B?bExJSG1jQzIvSWN2SG9JRFg4Q1NFb2NCVGZxeFdjOHVudGVsZ3JkMGhSVWRX?=
 =?utf-8?B?YWhMQ3diL3VxdithajZhNFB1cU44aHRlaGJvWXc3cS9wMjB1cVQ1aEZVVjF1?=
 =?utf-8?B?aEtrN0JnemkxZ3VXMnBzMXVQMC9VeG44ckk1K2o3NEYycmNTTDgrdFBHVWkv?=
 =?utf-8?B?RnoweHRibVY2UXFVbEcyZFBXY0JFVVdZSWRJK0pGdTJtVDZLdVZrVzFlbkpt?=
 =?utf-8?B?VVkxc0l3Qkl3TGd6cjROQnRmaHIzeE0wMUxkQnFlaGQ0Q3JxMGxpdjc3bFpP?=
 =?utf-8?B?blVKcy9QbDhabkwvRVVtRDlsN043Y0dzRG1FTE5USEdoNU5aNkFrQStTRC84?=
 =?utf-8?B?Q2RSMFBMeUNSTHgyQzlZNVlqWS9jeE9WVjFadEkvczQ4L29LcURkZjlWelFC?=
 =?utf-8?B?SGtOQTcvejV6ZUQ1TGhTL3lobFRaMENHenBlRllHTlRDWmpIVUFWSlUweDht?=
 =?utf-8?B?UERtOXNkMXl0SCtWaXZ4UEI0YkYrejhaM1hVSjVRRE1VTG45dFNITEhRRk4r?=
 =?utf-8?B?cTU1NDNPS1NIbTAwWm5zQUtZWkFMOUtPd3NBbzAva09mbm84Ym1TYjRoK3pE?=
 =?utf-8?B?VXk0a0FPQ3RuZ3pMc3BqdWQ2dzBEMmRxWFpWcnFEOFlOOVNleENiaWZQRW11?=
 =?utf-8?B?ZEI1ZGF5UnJzZ3hUdldQSzRHQk91YXdUdG1JdGc5RnB2OFk3VFZZbDg3VWZW?=
 =?utf-8?B?UjlnOWxLZ0RKN3AvVlVtMXBYa01JMkQ1ZVdsaDgwVWx6SHhHUnlXZXN3aTJU?=
 =?utf-8?B?dU5wMHdUZVNaVXFXaGQxajNKMDB2QmZKaW9kdlhocGhUc3VCbnBRbFllRFJ3?=
 =?utf-8?B?eG1wSktkU0NEN0VCNUtTdi9QY3lsZ0xOV3daaWpVZWZXYlNmYWVDTlA0UlYr?=
 =?utf-8?B?c2Y3OS9KczdOeTBaWkJJTDdYWFR5b0cxeS9ocDZoZldYaDJsUmJWRXpiYXVS?=
 =?utf-8?Q?cX1LMijmpaiFaaIkeR53KVaSV?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 64efe6e7-3323-4722-5977-08dc91760997
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2024 22:12:13.2664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kEM7kHoQ7jdoQdtA4Nzcp3woVfetfZLwtwbujgmFHV/FbsWlLugiazbd4a/9YPd1hlKHjWEPydWm42PXy1SOgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5136
X-OriginatorOrg: intel.com

PiBzdGF0aWMgY2hhciBtYmFfbWJwc19pbnZhbGlkW10gPSAibWJhX01CcHMgcmVxdWlyZXMgYm90
aCBNQk0gYW5kIChsaW5lYXIgc2NhbGUpIE1CQSBhdCBMMyBzY29wZSI7DQoNCmNoZWNrcGF0Y2gg
cmVjb21tZW5kcyAic3RhdGljIGNvbnN0IGNoYXIgLi4uIiBwdXNoaW5nIHRoaXMgb3ZlciAxMDAg
Y2hhcnMgOi0oDQoNCi1Ub255DQo=
