Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39553148FF8
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 19:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717789893; cv=fail; b=qfc1+cIF5E+hNEQKkij3f2bZkojwFixs0ecbiVvzWS5Zjf6zTV07fKJPdO+ME++4sDJP6ecTabcu1giwGmPa+YOlFSo0NWrAnxNFrpMR0eSUzY53LJLjxUnmfZjRgvzaPI0aKFt3yDYh+1okNEpGWNYu7dCuvDvwwilHjrGU7Es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717789893; c=relaxed/simple;
	bh=ZcCmIpwEl56L/yMu1dX9i/NF/fkd+MaVVOiY6KL+B7E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c4NraHSPGjJ3lL9sxA9VEi/EXdUd33STPldTvmZUP1/V2uNIhkzMs8oGf9BThpaJeasghT0AIJIKwmUj5tIHxLP3w2Ao1ZbXwMZFtlKG7H8tWuYaGkvgakn6VY2QzDOuHrrrbz2bAhQCVQrh03adugT3cn/ayt8fD2i4BcBL9uQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aQXVgiNZ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aQXVgiNZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717789892; x=1749325892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZcCmIpwEl56L/yMu1dX9i/NF/fkd+MaVVOiY6KL+B7E=;
  b=aQXVgiNZ5LNZFdBjVkyD3OrXKpP83DqYeOZhzbwg9RY3yVB+RyYAzXBt
   vJ+M2oYa/ahNSCZMABE13TTplVtkwZSQVQ5y3tER4PnkmWYwGCjIyP10N
   eQC9Cr7xO3EHjrdvVJ4YC6kHHRG0uQG8RFWYaRSL5m56R2i8TSMy0hwO6
   wyJbBHnwumEYKf+4Qc4SOn1n+F1N5HRtQlQTc25QT+Fswql34l0hQg/n1
   EixkXlan2AsNPsdYP1CF+oDbAjiY5vB7P5is8E8z7zscXn63ANwhKgNc+
   BJDgS+uyHqIURrAqQQqmxzdwy0IFkGMTlp0RQqbCPBGqWNx0mo0722pEe
   w==;
X-CSE-ConnectionGUID: NjBVH3LOT46STduIelKW0A==
X-CSE-MsgGUID: m5vFIoTrTtuZCz9QJpt80g==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14327441"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14327441"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 12:51:32 -0700
X-CSE-ConnectionGUID: juGjFHaCQ8a73c8/9sv6QQ==
X-CSE-MsgGUID: rmapdCGhQ028qUitq0RzpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="42855422"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 12:51:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 12:51:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 12:51:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 12:51:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvvz2q+eocr+byOJ2URngEeSscMjErLTs0kRwBNiFbqu3A96TPac0FvFgPD65TpKCp/eFWjHeoWwcP2/nZMPLxOu0elS/7UK5WYbin0bqLi0H5g1LVOEmRqow3E2+9Hh3Wg2QmKHD3w2bD2ggBdl849B46vSAI35KpYP2+M/hXnHX6RWYH+JHnkF9eFDG0eU9YYcrXGzWN54r474ghbimagNk8Z3+4clrpZL8CUHcEY+Dz1R6XshSGW9kFx554nUV21OObDD0IBUoHM2TUKqHDzmAjS+dmdjtGCCD+fa4vnINMXqBAEecQwl5dW9lx6Oo5qz9Tb8H5jwem2Jg/bNIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcCmIpwEl56L/yMu1dX9i/NF/fkd+MaVVOiY6KL+B7E=;
 b=W49jymc2iMVDXT5sonWTACmF/ciKBsM0CTBDlUkp5zAszITRcMcNba8SD3Rlun2yROTjG6mNB4964YNFoVSWCjKzWP1D+4VvQ69lvXJbCc43qgi1eBPKtRpZFzcP4qYT/rU4vV5OAAAIvr/YwAClltSYEJ7An3vou0x36iTOpLaKWOM8mHyrVLRsakwQJUEVdiBzmk44MI4vWEx60i67PvidyjmolIw1LawToM5Yht5Os0ETJeG7QYSeEJj7RMWZryK46+4bLGIYyqvbo8t1ogiVMOgzPHQA2iFKnjtzbktoaK06mmQvZhdBSywnUvFwPgo2UVgarrMsyAcFrQ03vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BL3PR11MB6387.namprd11.prod.outlook.com (2603:10b6:208:3b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 7 Jun
 2024 19:51:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7633.018; Fri, 7 Jun 2024
 19:51:26 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v19 16/20] x86/resctrl: Make resctrl_arch_rmid_read()
 handle sum over domains
Thread-Topic: [PATCH v19 16/20] x86/resctrl: Make resctrl_arch_rmid_read()
 handle sum over domains
Thread-Index: AQHasU1C4Vit5qsKPUyXByqi62YjFrGwPEWAgAxWewWAAClLQA==
Date: Fri, 7 Jun 2024 19:51:26 +0000
Message-ID: <SJ1PR11MB6083EE537A820BB7CD42D2BEFCFB2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-17-tony.luck@intel.com>
 <9818c304-9056-4d79-acbe-2b35cb847ecd@intel.com>
 <Zl5OmVWFpBtA509j@agluck-desk3.sc.intel.com>
 <03ab405b-d7e4-4c35-8a3f-546ffd590954@intel.com>
In-Reply-To: <03ab405b-d7e4-4c35-8a3f-546ffd590954@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|BL3PR11MB6387:EE_
x-ms-office365-filtering-correlation-id: 0e6045f9-c3b8-426e-0eaf-08dc872b3759
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?bTJNVmIxc2VySmJlZmdzeXhZQlpyNVd2RGJpVDRRSmlLMXFaUFNZWUdvc2NS?=
 =?utf-8?B?eVpBMlg4Sm5iNnRKMUJld2JVR3VyS3ZRWFl4UXNDaEJZR2dqR0VscHdMMm5r?=
 =?utf-8?B?ZlJwS255T0QvMWFWWUJkS2p5eFByMEcyWCtJN1cxdnM5d0x1aHZtMVJpVVh2?=
 =?utf-8?B?a1l3TmRqNU9wdVc0SEdESENkbllQVXZrWjFDYThjVVpQbU1rQ09XcmNzTnkz?=
 =?utf-8?B?amVZZGt6ckVQZGNicDFURnBmQWZrL1BBYnkzSXhyNTNvRUJ1TklQMWFPSC9B?=
 =?utf-8?B?dk5BdjNTOWR2ZmNBbW5lOHJaTk1QYTFjQndEZkg3anU4UlhoV0hUZTVsak45?=
 =?utf-8?B?dDJZYU5YUG1mbFRKenNRc3MybjVXb0ZlaDVhblR2Q1VBUUVUcHIzRnZ0ZlFl?=
 =?utf-8?B?YzJCSDVuMEtvY24xVWFHVXkvQ25LUTBYcjFManBkVHJEYTRqcVh0bCtjS3Qy?=
 =?utf-8?B?TGpWaW5ESjd0MjRDUlp0dkFxMHpRZ0dIV3RrdWllcnpvQmZ6bEl2Q2NqSlhj?=
 =?utf-8?B?R3BHNmdYSTJmZGxEaVhuVjFYZlhReXZYK0sxUVRHbXFJQUx4T1ViTUFVZlZr?=
 =?utf-8?B?ci9tMWxJZ1dvZ2M5eGU4dG1qVmJFblJkWUxsK24rU1ZKUkdCeFpIMGNYWDUz?=
 =?utf-8?B?akxWMFN6QUlsbmZJOVFSSnVEWk5YWUpoRW1JVGZSODFRc1ZMYWZPVFBLMGM4?=
 =?utf-8?B?N0JnQ0E3cWhlSjl1MGRKdndDMGlsVDZIQmhqQW1BTGJBSmxYVy9QZC9CUGRn?=
 =?utf-8?B?WVFvTzJRcHJPUGJXdVFKVC9wK085MFU3aGZHUXpmRWFEQnF2UHluYVNabnFw?=
 =?utf-8?B?ZFozcytEYkNTcElIdC95Y2xnM3BPcVhkQzlTak45Vk9rZ2NhTW1TU3g1cG5i?=
 =?utf-8?B?YXRkUmtWRVZGMDFTWCtvYy9sUExGY2l3TWpWTXQ4L2lhemNNK3d0RkplNU1h?=
 =?utf-8?B?N29wRFJhbHZueml1NWx4aXhUWHpSRG9XV3M4cVRNai9RckFCSXFmV3NEamlV?=
 =?utf-8?B?d1dTYjVqQnArQ3puTWU1ZGR2UEpYVzhvbFZaM3NTVVdPaTFNeS9obnR1L0wz?=
 =?utf-8?B?dXgyd0NRSFFLbGZYS29kbEhaZ3RsbzdVUXQ0UklIOHBWSkNKVkpRRSt5OEdG?=
 =?utf-8?B?STlzR3pNSkRIYkY5OWplTXNLOFkxaTVOTm10MHFCUjlnalZCOEdNVDhCaEZa?=
 =?utf-8?B?R0pSR3JnZnJ0a0NPdUZZbENkRlV5eWtOS3EyamMyUTdOT0ROcmxjRi9McjN4?=
 =?utf-8?B?TUFCR0Qwd3RITDJHTW5kK241ejIyTWZIQU1kUStNQ2d2K05wZm9pMkRYUkNt?=
 =?utf-8?B?T0d2ZGZsUzN4b25PcEFCdnhaSVUwUHNINVlZNTBJNmluZE1vak5hMVViRXF1?=
 =?utf-8?B?eTMvVCtYTmFBZU1SQ1FJMVI2Y1Vab0dxVkFCYkR2MUl3NmtCbXBmeWpWQWhE?=
 =?utf-8?B?cW9aOGNtZ1JEc1paTDBkbzMzQUpqeHpZZFE2RUlsQjl5MjUzQStiWlluRkQy?=
 =?utf-8?B?VXFsUkRPaVhGcTdVeTRSdVhBcFVNQldNSC9BbDdCMGJySDNCUGZPRE03RVdk?=
 =?utf-8?B?VXpZR0ZnWXlQbWhYYVBhVzc3aTQ5K1l5RW5mcTZoaENlWXJXektEOXNIc3BW?=
 =?utf-8?B?U2RzQ2NwNkMzY21xbmpkZGZkVDJtZlhkUENEZ3JXZnNNZ1FCOTZqRHJBdjFa?=
 =?utf-8?B?VE0yQ1lEZWVoeERGWlBJSG9CdThyUWdWTE1qMk93WERxNTRIY1pVL3hNZzNO?=
 =?utf-8?B?V013czVBQ3dDdTloODc3dHN3V1lIN3g4TXVzZ3M1R1RYczRSN1JCTno5cUNj?=
 =?utf-8?Q?fpVWtC+CK3h683xehNJsOIeM/KgPrv3Tx7GyA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWZNejU4NzlVSW1MN1QxV2pURmozRnMxTlVKTzFQTzB2NEFDYzRGWEJDSlhP?=
 =?utf-8?B?K0ZIeEJQYitKd3hQd1BBUmxRS2VTaVVoMDFZWjROeHJXMEdUSnBtOEJPbVZk?=
 =?utf-8?B?aTh3K0lWMXhJZ1VFblNwSU1GNlBjYVQranlENmdxZjdKWnBBalhXcFBKN3dk?=
 =?utf-8?B?Kzl1ZjJlbTNTYzNoQ3BpYmJOa1VzcnFoSU5LS0ZVRmJQdUVqelIwclRubkZi?=
 =?utf-8?B?Qm9hd25yV2ZoTEd6azVwOTJ3S3czWmNONVNhZnFUT2RtSGM2d0N2eTBScVlW?=
 =?utf-8?B?b25zd1BWK1dQZ21WQWJNVUFIaU1TU29ZREN6WlFrcGY5cXFmdmRNYlJMK00z?=
 =?utf-8?B?RjZRbE1ua0tYUTRPanVRSGE0REVqT2dxL0ExVXN3TFlSUmE4YzlrY2VGQjFO?=
 =?utf-8?B?ZFBacjVIb2lXMHk5MzdMK3I0YkttTWg3M3hTKzZXYmtlaTk3WXRPcHFnMmVZ?=
 =?utf-8?B?eGwyRlNHU25yeWlHb3FSMWtmZTZrY0NXMFJhOXQzYnFpMjl5dUtmMFhTb201?=
 =?utf-8?B?ZG1PZGFkOTkydFBGM0QyWXYyMnhKWm9TaXdCZEdUWE1IajRpMWdrU0ZjdUpJ?=
 =?utf-8?B?MFNua0l5UjRvV1VhQ3dFSGRmcEtnbElzREd6MTZuR0dkdDB0OW5qNmRFaGVZ?=
 =?utf-8?B?SFBSZmxFSXlsYS9TdkY0ZXdXNEY2OHZDRHIwODY3KzBiN01IQ3pKaklzeFJX?=
 =?utf-8?B?em0zL1hRY2ZTY0p2RzV6NnBHdThtdS9rZWZPU0l2amxTQ2o3ekJpZk5xVlF1?=
 =?utf-8?B?S0xISHJ3dnIvUDlDYkdpbWVQOUEzRVpJZmhLNjRrK0dqc2VxYmNWT002R1Jq?=
 =?utf-8?B?QmZHYWtQajdDVGpCZEI5eEU0NmlZai9qampSN0c5UEtacXhSL1RrQ0lqSlI0?=
 =?utf-8?B?RUtrRlhPbVZJdDl3enlhT1UxdUNkd3NlUWJSYmFRcWpyVEhxdnFSeThIQld0?=
 =?utf-8?B?WDJhNGhNeExQakxqZUo1bUlZNDRDZ2RTRVJrRE9ObWJOcVd5bFdkOUtuQk8x?=
 =?utf-8?B?Uzg2NHRzREMxWXJ1TmUrS2VETmdXdUFyOUpNODUveVFCMjRrSnV2K1dUcWpD?=
 =?utf-8?B?dVVaaGxzVGVYRDU0Z3pOZENqZ1NDdktuVFI5bVQzNlBkbkdqUVV5MXVsejBX?=
 =?utf-8?B?VDFPVklGTUU2OStiS0h0c3E5L2JkYSt4bGtybjlnUTYzZlFpNXBIY2c0TzF2?=
 =?utf-8?B?ZDBFelg1c1A2NStOK1JtTHNXaWFHZ0xyQmNWUUhjS3c5cXNtUGN3R1JqcDZG?=
 =?utf-8?B?WkdOYmZIbmI3ODJHZXVZZFFScHZwemhTNVptUU0rRE8vSmt4dzVLQTJDN2NL?=
 =?utf-8?B?eU0zejJvMnFOdXh5WnpmRHlqTHBuRXhKMGU4NVhjellsYVp3L3kvSXNLMHZp?=
 =?utf-8?B?cGJXclNzTkVsTE81SG9LNkdaWlczclp4VzA3UUJ2OXA5NTBRM2o2NU1ZVjN5?=
 =?utf-8?B?VzRYUWV3WmVkVW11N0lKOHVGRjlYWU5ZRDhITUtLOU02d29obHAxaVFyTnd4?=
 =?utf-8?B?cng4NTBXY3FxbVFwSE85Z2RSSEZybXl2M3A4VW85cmJjUGptUUhxTm50bDFX?=
 =?utf-8?B?SVpLZi9oUUE1dE5vbnVONXhqQklGMEs4RGdCbjd5OVpYSXBvKzI2Ulh5SDdr?=
 =?utf-8?B?Qk4vVFdvVkU5T3NZZFJjM0NUWVJwT2FjVEQwRm1xZnNFZVJLTTdrTFlSUCs5?=
 =?utf-8?B?SjlROVg3bUFyK0kwTEdYczB0Q0I1Z04yU2w0UEc5blRjcGJ0VmVGWDhqWXBo?=
 =?utf-8?B?b0J5Yk55MTRVVzVLRzJBTTlIYXJDRlhqRjgxMUhZQjZGK3RNZUdFSXdTN2NH?=
 =?utf-8?B?dk16Z3lWZm9QNnp6amI2U05Ldk1wUVZxQVhKSW9tQnJ6MG1NZVByQTdGZmlC?=
 =?utf-8?B?STFZakM3Y1lUcDhhVWxxaXlmM2s1MGxFeWJiRGRraTNrQWsxK0tzaXJBZHpP?=
 =?utf-8?B?UkNadkJkYUxTV3dheXlCL2RqVFZQd2JoUm93Q1k3YnVPN05kZXF2ai9xeHpa?=
 =?utf-8?B?TlhUVGwvaktpa1FBK29uejdQcFVuZndkaUc4UnZhTXRUbVQzSTJseU90cGV2?=
 =?utf-8?B?YzdydmdoR2VFL08ra0dVMTFaM2VMbjM1K0pHSFlqY2pNWHd3RWV4TFpVYmVZ?=
 =?utf-8?Q?wljN1KDR5YAT4mCjbylrooo23?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6045f9-c3b8-426e-0eaf-08dc872b3759
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 19:51:26.1341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SLQYM4maTgvxqk84fYJ1jHCHVKNNc3VGpRGCTwrjbQ3FB4KQDCs2nakRyvRSSboRojBWsqTPE5u00X+oZitIyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6387
X-OriginatorOrg: intel.com

PiBIaSBUb255LA0KPg0KPiBPbiA2LzMvMjQgNDoxNSBQTSwgVG9ueSBMdWNrIHdyb3RlOg0KPiA+
IE9uIFRodSwgTWF5IDMwLCAyMDI0IGF0IDAxOjI0OjU3UE0gLTA3MDAsIFJlaW5ldHRlIENoYXRy
ZSB3cm90ZToNCj4gPj4gT24gNS8yOC8yNCAzOjIwIFBNLCBUb255IEx1Y2sgd3JvdGU6DQo+IC4u
Lg0KPg0KPiA+Pj4gKw0KPiA+Pj4gKyByZXR1cm4gMDsNCj4gPj4+ICt9DQo+ID4+PiArDQo+ID4+
PiAraW50IHJlc2N0cmxfYXJjaF9ybWlkX3JlYWQoc3RydWN0IHJkdF9yZXNvdXJjZSAqciwgc3Ry
dWN0IHJkdF9tb25fZG9tYWluICpkLA0KPiA+Pj4gKyAgICAgICAgICAgICAgICAgICAgdTMyIHVu
dXNlZCwgdTMyIHJtaWQsIGVudW0gcmVzY3RybF9ldmVudF9pZCBldmVudGlkLA0KPiA+Pj4gKyAg
ICAgICAgICAgICAgICAgICAgdTY0ICp2YWwsIGJvb2wgc3VtLCBzdHJ1Y3QgY2FjaGVpbmZvICpj
aSwgdm9pZCAqaWdub3JlZCkNCj4gPj4NCj4gPj4gVGhpcyBpcyBub3QgYXJjaGl0ZWN0dXJlIHNw
ZWNpZmljIGNvZGUuDQo+ID4NCj4gPiBDYW4geW91IGV4cGxhaW4gZnVydGhlcj8gSSd2ZSBkcm9w
cGVkIHRoZSAic3VtIiBhcmd1bWVudC4gQXMgeW91IHBvaW50ZWQNCj4gPiBvdXQgZWxzZXdoZXJl
IHRoaXMgY2FuIGJlIGluZmVycmVkIGZyb20gImQgPT0gTlVMTCIuICBCdXQgSSBkbyBuZWVkIHRo
ZQ0KPiA+IGNhY2hlaW5mbyBpbmZvcm1hdGlvbiBpbiByZXNjdHJsX2FyY2hfcm1pZF9yZWFkKCkg
dG86DQo+ID4gMSkgZGV0ZXJtaW5lIHdoaWNoIGRvbWFpbnMgdG8gc3VtICh0aG9zZSB0aGF0IG1h
dGNoIGNpLT5pZCkuDQo+ID4gMikgc2FuaXR5IGNoZWNrIGNvZGUgaXMgZXhlY3V0aW5nIG9uIGEg
Q1BVIGluIGNpLT5zaGFyZWRfY3B1X21hcC4NCj4gPg0KPg0KPiAicmVzY3RybF9hcmNoXyoiIGlz
IHRoZSBwcmVmaXggb2YgZnVuY3Rpb25zIG5lZWRlZCB0byBiZSBpbXBsZW1lbnRlZA0KPiBieSBl
dmVyeSBhcmNoaXRlY3R1cmUuIEFzIEkgdW5kZXJzdGFuZCB0aGVyZSBpcyBub3RoaW5nIGFyY2hp
dGVjdHVyZQ0KPiBzcGVjaWZpYyBhYm91dCB3aGF0IHRoaXMgZnVuY3Rpb24gZG9lcyBhbmQgZXZl
cnkgYXJjaGl0ZWN0dXJlJ3MgZnVuY3Rpb24NCj4gd291bGQgdGh1cyBlbmQgdXAgbG9va2luZyBp
ZGVudGljYWwuIEkgZXhwZWN0ZWQgdGhlIGNhY2hlaW5mbw0KPiBpbmZvcm1hdGlvbiB0byBiZSBh
dmFpbGFibGUgZnJvbSBhbGwgYXJjaGl0ZWN0dXJlcy4gSWYgdGhpcyBpcyBub3QNCj4gdGhlIGNh
c2UgdGhlbiBpdCBkb2VzIG5vdCBiZWxvbmcgaW4gc3RydWN0IHJkdF9tb25fZG9tYWluIGJ1dCBz
aG91bGQNCj4gaW5zdGVhZCBiZSBtb3ZlZCB0byBzdHJ1Y3QgcmR0X2h3X21vbl9kb21haW4gLi4u
IGJ1dCBzaW5jZSBjYWNoZWluZm8NCj4gaGFzIGFscmVhZHkgbWFkZSBpdHMgd2F5IGludG8gdGhl
IGZpbGVzeXN0ZW0gY29kZSBpdCBpcyBub3QgY2xlYXINCj4gdG8gbWUgaG93IHlvdSBlbnZpc2lv
biB0aGUgYXJjaC9mcyBzcGxpdC4NCg0KSGkgUmVpbmV0dGUsDQoNCkZpbGVzIGluIHJlc2N0cmwg
dGhhdCBzdW0gb3ZlciByZXNvdXJjZXMgYXJlIGdvaW5nIHRvIGJlIGEgbmVjZXNzYXJ5IGZlYXR1
cmUNCmZvciBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eS4gSSdtIGRvaW5nIGl0IGZvciB0aGUgZmly
c3QgdGltZSBoZXJlIGZvciBTTkMsIGJ1dA0KSSBrbm93IG9mIGFub3RoZXIgcGxhdGZvcm0gdG9w
b2xvZ3kgY2hhbmdlIG9uIHRoZSBob3Jpem9uIHRoYXQgY291bGQgYWxzbw0KYmVuZWZpdCBmcm9t
IHRoaXMuDQoNCkxvb2tpbmcgYXQgdGhlIGVuZC1wb2ludCBvZiB0aGUgSmFtZXMgTW9yc2UvRGF2
ZSBNYXJ0aW4gcGF0Y2ggc2VyaWVzIHRvDQpzcGxpdCBvdXQgdGhlIGFyY2ggaW5kZXBlbmRlbnQg
bGF5ZXIgdG8gZnMvcmVzY3RybC8gSSBzZWUgdGhhdCBmcy9tb25pdG9yLmMNCm1ha2VzIGNhbGxz
IHRvIHJlc2N0cmxfYXJjaF9ybWlkX3JlYWQoKS4gVGhlIHg4NiB2ZXJzaW9uIG9mIHRoaXMgcmVt
YWlucw0KaW4gYXJjaC94ODYva2VybmVsL2NwdS9yZXNjdHJsL21vbml0b3IuYyAoSSBkb24ndCBz
ZWUgYW4gTVBBTSB2ZXJzaW9uKS4NCg0KSmFtZXMgYWxyZWFkeSBhZGRlZCB0d28gYXJndW1lbnRz
IHRoYXQgTVBBTSBuZWVkcyBhbmQgeDg2IGRvZXNuJ3QNCihoZW5jZSAidTMyIHVudXNlZCIgYW5k
ICJ2b2lkICppZ25vcmVkIiBpbiB0aGUgYXJndW1lbnQgbGlzdCkuIEkgY29uZmVzcw0KdGhhdCBt
eSB0aG91Z2h0IGhhZCBiZWVuICJJZiBoZSBjYW4gcGFkIG91dCB0aGUgYXJndW1lbnQgbGlzdCBm
b3IgTVBBTSwNCnRoZW4gSSBjYW4gZG8gaXQgdG9vIGZvciB4ODYiLiBCdXQgdGhhdCBsZWFkcyB0
byBtYWRuZXNzLCBzbyB0aW1lIHRvIHJlY29uc2lkZXIuDQoNCkkgY2FuIHNlZSBhIGNvdXBsZSBv
ZiBwYXRocy4NCg0KMSkgTVBBTS9vdGhlcnMgd2lsbCBhbHNvIHdhbnQgdG8gaGF2ZSBmaWxlcyB0
aGF0IHN1bSB0aGluZ3MsIHNvIG1heWJlIHRoZXkgd2FudA0KYW4gZXh0cmEgYXJndW1lbnQgdGhh
dCBzaG93cyB3aGF0IHRvIGFkZCB1cC4gVGhvdWdoIGV2ZW4gaWYgdGhleSBkbywgdGhlaXINCnJl
cXVpcmVtZW50IG1heSBub3QgYmUgbWV0IGJ5IGEgImNhY2hlaW5mbyIgcG9pbnRlci4NCg0KMikg
T25seSB4ODYgKEludGVsKSB3aWxsIHVzZSB0aGlzLiBNYXliZSBpbiB0aGlzIGNhc2UgdGhlIGFu
c3dlciBpcyB0byBkbyBzb21lDQpyZW5hbWluZyBzbyB0aGUgInZvaWQgKnVudXNlZCIgYXJndW1l
bnQgY2FuIGJlIHVzZWQgdG8gcGFzcyBhcmNoaXRlY3R1cmUNCnNwZWNpZmljIGluZm9ybWF0aW9u
Lg0KDQpTa2V0Y2ggZm9yIG9wdGlvbiAjMi4gQ3VycmVudGx5IHRoZSBjb2RlIGRvZXM6DQotLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCg0KVGhhdCB2b2lkICphcmd1bWVudCBpcyBjdXJyZW50bHkgc3Vw
cGxpZWQgYnkgYSBjYWxsLiBFLmcuDQoNCgl2b2lkICphcmNoX21vbl9jdHg7DQoNCglhcmNoX21v
bl9jdHggPSByZXNjdHJsX2FyY2hfbW9uX2N0eF9hbGxvYyhyLCBRT1NfTDNfT0NDVVBfRVZFTlRf
SUQpOw0KDQoNCglyZXNjdHJsX2FyY2hfcm1pZF9yZWFkKHIsIGQsIGVudHJ5LT5jbG9zaWQsIGVu
dHJ5LT5ybWlkLA0KCQkJCVFPU19MM19PQ0NVUF9FVkVOVF9JRCwgJnZhbCwNCgkJCQlhcmNoX21v
bl9jdHgpOw0KDQoJcmVzY3RybF9hcmNoX21vbl9jdHhfZnJlZShyLCBRT1NfTDNfT0NDVVBfRVZF
TlRfSUQsIGFyY2hfbW9uX2N0eCk7DQoNClRoZSB4ODYgdmVyc2lvbiBvZiByZXNjdHJsX2FyY2hf
bW9uX2N0eF9hbGxvYygpIGp1c3QgZG9lcyAibWlnaHRfc2xlZXAoKTsgcmV0dXJuIE5VTEw7Ig0K
YW5kIHJlc2N0cmxfYXJjaF9tb25fY3R4X2ZyZWUoKSBkb2VzIG5vdGhpbmcuDQoNCk5ldyB2ZXJz
aW9uIG1ha2VzIHRoZXNlIGNoYW5nZXM6DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0NCg0KQWRkIHJk
dF9tb25fZG9tYWluICogYXMgYSBuZXcgYXJndW1lbnQgdG8gcmVzY3RybF9hcmNoX21vbl9jdHhf
YWxsb2MoKSAod2hpY2ggTVBBTSBjYW4NCmlnbm9yZSkuDQoNCng4NiBhbGxvYyBmdW5jdGlvbiBi
ZWNvbWVzOg0KDQp2b2lkICpyZXNjdHJsX2FyY2hfbW9uX2N0eF9hbGxvYyhzdHJ1Y3QgcmR0X3Jl
c291cmNlICpyLCBzdHJ1Y3QgcmR0X21vbl9kb21haW4gKmQsIGludCBldnRpZCkNCnsNCgltaWdo
dF9zbGVlcCgpOw0KDQoJcmV0dXJuIGQtPmNpOw0KfQ0KDQpyZXNjdHJsX2FyY2hfbW9uX2N0eF9m
cmVlKCkgcmVtYWlucyBhbiBlbXB0eSBzdHViLg0KDQoNCklzIHRoaXMgYSByZWFzb25hYmxlIHdh
eSB0byBzcGxpdCB0aGUgaW5kZXBlbmRlbnQgZnMgbGF5ZXIgY29kZSBmcm9tIHRoZSBhcmNoaXRl
Y3R1cmUgc3BlY2lmaWM/DQoNCi1Ub255DQoNCg0KDQoNCg0K
