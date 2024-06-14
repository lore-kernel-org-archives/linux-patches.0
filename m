Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D1C148FE3
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 21:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718401216; cv=fail; b=Wdd6Xygc/33YcPXFcHlNXfINDYX+r+1dWoXfcRzyfDDlxTMHbJgQD9ixkY3R1J/9a0BbfCjuuHG+xuQ0PrfAA+AhN1rj8wXGtSFeaqSQQAUZidvWLqdiVKCICU/XG1GQDMvhgi54eBjPtuQvGW1ZZ3Iegq/rdKWZ/C+Zflt9y/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718401216; c=relaxed/simple;
	bh=DxE+58XOIecjCUTAr7QFt3Wgdg5r96m/lybDzRa5yCI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ehVrwNOrenXXfg+he0Yhgu8nqIKyCIPh1B9LTAUIrLg4arloF1QrMp0Jvx5PqQr1KbjJBKGbZTOEgOnv8TA22fKPsej4ON1PSnoyDfpqBtK/fcvTqyUf5TfaM44iU3+jYXUaZxuAyurEOLXihshUQfBbDPNg62R7LTeiUOtHsqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jAD8wpt0; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jAD8wpt0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718401213; x=1749937213;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DxE+58XOIecjCUTAr7QFt3Wgdg5r96m/lybDzRa5yCI=;
  b=jAD8wpt0r+RNimE0QLNGPtgi17M2c8SIDwKBy4usQ1+mUcgQC42NjEFF
   SX2eyoAbJtE6Ppj2+ept9jdY0GnrsTzr0tKqGPd68wtigACUdCG9ZIP5e
   kAjITmmrBL8+Kvpep8GlZ3uO0GCUipcVIeUHQPkEDKAjpFwZpmnZshrqj
   VCgD6rtNZqJPMWh4UIAFEkMGlp2FKMboLdfE1Ru97qdPNj9BqzNLaT0f7
   aYk4l9zbXJPp6V44hDOG1JT2Pmwa9Zai4dvR461ItTWAMXuswOLoq/wdp
   X8V8ryGFpW0KDg3za5sdpF3qbS5jupEABTuquDFVPbYGTJ6GhwFBBFQUr
   w==;
X-CSE-ConnectionGUID: 1KYqyiYARnyNma4vlnaPRA==
X-CSE-MsgGUID: 6DgcwNddRRW63sEPGFaU8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11103"; a="25885899"
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="25885899"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 14:40:12 -0700
X-CSE-ConnectionGUID: EVn9tyrLR6a+Rc5vzEJMhg==
X-CSE-MsgGUID: vnWHh2AZSomp/+BUbgU7dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,238,1712646000"; 
   d="scan'208";a="40498188"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jun 2024 14:40:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 14:40:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 14 Jun 2024 14:40:11 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Jun 2024 14:40:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCC/iIccmK3pXOm9Cy2KHcHqLOYAKT0C3Hv/Gppnj69iMR9FnPTze74C4iGdM06hxBTZ6z5PBWD8XA0z7pN2CBA7N6v/kpejNKxVyFYHqaBd9vbizDHiut0iyIk1rcUUPNbO5/tVl1erVmHuc5XU8V3kY+R98gI6Q/OfEtC+UzOXDGVxBznZx6WUmOSsDPxuXMwJaNbo+ima1CTBP4rUOPiNOSMiCafKcvlPXHOp+hR6wITIloH1eviE2DXzsRGW9lNP9TB7iimx1XLrlnOyoIgZmPpTPHWz76IGgenXo/3FDzxvJ6vhJYk4PVb3c/EOWj656LYDJBWNfnjI9yJoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxE+58XOIecjCUTAr7QFt3Wgdg5r96m/lybDzRa5yCI=;
 b=NRwWCqVObN/HWT+PDdf1NbLiiJN4X6AR4cmR+M/iJKB7EgoQxSkTMml00wvrpU9dAE2z1BZMYKOvzWYZ51lNcf/qAMp/DIEe/p6q15kIMJNUyxBtAwE06AnlQZ3ud0ulzlj9vGT1ElfsxIt8zDaS563T6JbPnj8E0uT6oXDdbBVagNa/hKhVSDKbnZyDdC4otTBptgfGvK/8rUWToz/hBUjMs3H+cmZcTPzf+AaHoTcKCxrv3a+EoGXNUOquiZ5gUFlqk4ekBgJRF1YaWfY9GOWieA7hr3TnolFCdnICtZYFXme2JYh4EIQYz1I0mMxHu8Wi00SsG4eVlvhb4rJR6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB8764.namprd11.prod.outlook.com (2603:10b6:8:192::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.24; Fri, 14 Jun
 2024 21:40:10 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7677.019; Fri, 14 Jun 2024
 21:40:10 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "babu.moger@amd.com" <babu.moger@amd.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Drew Fustini
	<dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
Thread-Topic: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
Thread-Index: AQHau2UFsa3KPaHBLkapRoBR10crYrHGFdMAgAAU6gCAAU4PAIAABTOAgABPF4CAAAGi4A==
Date: Fri, 14 Jun 2024 21:40:09 +0000
Message-ID: <SJ1PR11MB6083C6F02ADFC43B5316F71EFCC22@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
 <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
 <e17d3a79-9c07-44cd-b0ea-2d0545680342@amd.com>
 <f57e9cf2-35b6-401d-afc2-8d11b22836c2@intel.com>
 <a65739a4-1c0e-ab36-611d-e2da0bd1d00a@amd.com>
In-Reply-To: <a65739a4-1c0e-ab36-611d-e2da0bd1d00a@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB8764:EE_
x-ms-office365-filtering-correlation-id: 748fc5af-7337-45f8-3c98-08dc8cba90c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|366013|376011|38070700015|921017;
x-microsoft-antispam-message-info: =?utf-8?B?K2VrL1FQTTd0YjZkdVJOVHpVcEU5VVYxc3lMNGRvYXhaNUJrRmtoa1dUOFZZ?=
 =?utf-8?B?eFRtRmxDMWxST3l2NVlOUlZTUDdZUnJOVGEzYzZ4UEplZDgvUVh4NGovMkov?=
 =?utf-8?B?bzNHbHB6UGRKTnpUZ2lmRGhFNjdGNHZyYnU4VmN6NEVyby81Yk5oVVltNlhL?=
 =?utf-8?B?eVpVZHFid3hkZERPc1FpWWZmVE9jNDlYNmhFR3JDb3ZWeDQzaEN3VmlYaEF5?=
 =?utf-8?B?TGNQT2N6cU9zY2VYci9wY3BHb2RYeDVuN2xpUkNSQ3F5K3ZBbHArL2tud08w?=
 =?utf-8?B?MUVnL0VISU92VGVrc0t3dks1SFVlM25PYTIxZlk3Z21PWnplbW1DdE9RK1I3?=
 =?utf-8?B?OThZMkhNdm9UMk5rbnhOWVVnUy9GWmNTUDZSYnUycHN1MDUyMDZhdEFvL2JQ?=
 =?utf-8?B?Mk5CaXhFWmpRSk9VVjFHanNFVXMxcEdNTXlBakF0Q2ZFTEdNVjNDeWJDZEtw?=
 =?utf-8?B?R2k3ZE54NStYR1JYZGJQSjZ1cUNCTTRtdU00bzBzakU5NkVMVHg2Z1JCMWhG?=
 =?utf-8?B?dkJmUkpXbjI4NEROcE5uaUJ4RmNLMmNXalQyK0wrbGljdExBSnR5RHN5Q3M2?=
 =?utf-8?B?bHlINFc4Q09IZjFhZXFuSHpwZzhud3NiTGEzWldFUnIrckxVZ1EzMmoxaTF4?=
 =?utf-8?B?M0tlOEd5ay9RNFRWNEdjd0lhTWZzZk1pSTlFbEhna0pYRHhuQXdFcmtLYkJW?=
 =?utf-8?B?OUpjV09yc20wNUNFT1c3eWlESGRuMFZCcjJTRjU4RE9FYndKeDUrZHBINzAr?=
 =?utf-8?B?bE9LTm9DdkdTM2lwUEpQc014dlN2TlpwYlluSjVLRE1mNW5yRFR0MWYxcjdt?=
 =?utf-8?B?QTN3WmliVnFGKytWWEdzYThad2wvQXQzTXlxcjkrYnRod3pCaXhqR3p4NUFp?=
 =?utf-8?B?dE9lajlZNmxGaUxKNzN3SjlQbVVNVWZ0WDFoVC95YzIwNlMvZFpSOVcyMzVN?=
 =?utf-8?B?RTA4WkUyaVVjMS9SYlI3YU1oTmhxUWt5UWxGNEdBUmFYR3o5LzFPTjhpbS96?=
 =?utf-8?B?V3Z1Ym1RcUJOYWxIMTBMSFhYbkd5YU9YWEZPclE5K1hOdmxjbGRrM2lSQ2lV?=
 =?utf-8?B?a2pEcTBBMjZpZG9yZ2NEYVRWdzR2YWc5K0pPOXQrS29YV0tPNkJuSlE4dlJz?=
 =?utf-8?B?MjIvS3VpK0l1UUxVTXlET1dKSEJBYWNiVS9DUjZYdGdQOTF0bGlzb3h6M0lB?=
 =?utf-8?B?b3BiZkRWN2tDVkpIUUVkOHU0UXRtOVZCeittR2ZSZEJYZk81bU9WYnJ4ZGd3?=
 =?utf-8?B?ZjJiaENydGpRSUtEQTFsbmZtNVpwcjZpdDFxWEwxQkI4SE9oWC93YWhLSW9l?=
 =?utf-8?B?VUgzUEV1UzFTL1hZdVcxQkg4N0JOaXBHSnFIMDB0OUIrb1JvSGhacTgrTHM1?=
 =?utf-8?B?MGJwdWM1d0E5RytuTDZuOUgyMmtFc3Y1M2xzVTM3NEFlYnk2clpwUXBuaTJY?=
 =?utf-8?B?VUl2NnpCd0kwMWFyV3FMYjRLY01PNlEyTGUveHBTNEZFaFhtVWFtYi9SMkFK?=
 =?utf-8?B?QXVCTDFIeTRvajVnaUVsMTZNK2R0M0UzZXJta3dDL05EMk0zR0xmZTFYWWZV?=
 =?utf-8?B?YlZFVURqNjNXWXp5a212enFnQVZUWjVia0luUWhKd2lXcXNzbTQwaVppTjhP?=
 =?utf-8?B?cExsL0dsNjhNUTk3QnVTSnhKT2ZxcVcxMGxVcm9CZk8ybXREN01EYlRuVnYz?=
 =?utf-8?B?S2Zjakk2U3Vwbyt5bThKNEVHQWtFU3o1VXJJT3NKZ0VVN2VzQUxTRkFCU3k1?=
 =?utf-8?B?ZzJOSUpFYnpnYnhhVjVmeGE3ejNVeE5KUW82Q1RLeDFEamxrNlpLZUgrbjlj?=
 =?utf-8?B?SWV3UFc4K01PZnk4bmR1a3ZDRVVJWXhidjV1STRaNWZBRlhHbWxWMGZvWmU3?=
 =?utf-8?Q?m81DbZdR6xxob?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011)(38070700015)(921017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEFUUGd3OFlYenVGaFB2dWo2TU5rUkV1QkhEei8xa3Rscm0zcVhmQzJ3ZHBY?=
 =?utf-8?B?ckhzclFOQ29OL0pFMy9NS1BHbllMUW9jWWpYaS95c2RXYVJtekRBUzdiZ1I5?=
 =?utf-8?B?alpJNVFhVkpiVHVpc0llb1VaWDV1VWxNYWc4MzRadjJNL0pvaFVDTjFpOVVF?=
 =?utf-8?B?UDBSc3RGYW9aemQ4T3lITlNoMGFGZXlTNmFmdUplb2pDbEZlUkZFanJTSW9r?=
 =?utf-8?B?cGsvSDFyRDE2UThqbDhtdWovdGRqZmh6SXhzaHg4QzVseitEczVEV1k0dXFj?=
 =?utf-8?B?OEdkN2xCc0ZIY2RDd1BCL2o4ZTJ6QUNVVlRNZ25MZ2pjcEYyZmNCa1c1dHBn?=
 =?utf-8?B?RFlUZmpRdk1zaHpRaStoSFc0MlVsQTlBdHcrWnhqN1k1WXgvUmxlTzd4UFN0?=
 =?utf-8?B?djI1d1pvL3BzS3BST0Fuck9IVzZnZjJ1ajlwQnI0Rks0YXNsR2JGeW1DRlNa?=
 =?utf-8?B?akxkV0RGTWNsaXVtZUFNemtoWE9ZZ3MxTjk4RnNuV0tqaGJqdjYvWURIeFBQ?=
 =?utf-8?B?L2Y1NC9aTHg4aDFsNkhHSy9maEFvWmNxMmlMUHBubGRvQ2xzZzZHWVNvREV2?=
 =?utf-8?B?QWJKQ1VwRk0rWTVmK0pxckJ0OHlaZk84QzNzMEdiL2R5ZWxDZ0wxc0lqZlFl?=
 =?utf-8?B?dmNkMFNGVWFUYkVVTU1wVXJVL212aFpQajA2bVFuZUxrY3dOSHZxaStKdzhy?=
 =?utf-8?B?cklHY1l3NUI5aVU5ZWJpUXV4WHF5c0FSUnl6NUI1cjFLRmlwT01EL2lRNjdu?=
 =?utf-8?B?MDJvY2I0eHdxQ0k0TEJRWTFGT0JadTJNNjlCNUJjc1VFMnRsWGFKNTVvV0h5?=
 =?utf-8?B?bFlnWWRPblF1dWJTR1VzWWZBUmR2QlVMRHJ3bmVrZnYzZjFMcU04TVl1U0kw?=
 =?utf-8?B?YlFVdHoyWW5BOU1GdWpUbDRyN3dIUnFQVVJTWVVnQkFCa294SktkTCtwbFVO?=
 =?utf-8?B?aGViRjhKbWlrR3lZY2pBeE9HRXFYNUhaSU5rcHlMTmF6NlRUam9jcHpjTHJ4?=
 =?utf-8?B?eUNHaU50cU9DS21XM2I4azlwbzl5L29ZTUUxOVlab1gwMHV5NHJ6RFdKRDNo?=
 =?utf-8?B?SHA5UXA2Vm9sNitXZTBBOXpiRXVSSy9teGpsbHJBNUJHVEpCWE13bjNlUjJF?=
 =?utf-8?B?QXRld0JoT1dRWERmNnI2SXVtM1d1YTB1RlpaTm1WUURWNDd1eWxDNUYzdW8z?=
 =?utf-8?B?WUIxMHVtd0s4TTR3OHQ0QmZhZkZYNVVwTlpuR1dEVGJUQVdIOGprWCsvMG95?=
 =?utf-8?B?UTM4MEw0dURLT04vbktFSWJMbm9XT1BCeFBMV0NXYkdhMXBxbWZYNFdtV1oy?=
 =?utf-8?B?eE1Yd0ZVWlhVN3d2U2p5QnY0TU80NS9BVUJRVXkwSVp1QnZrUlVpYzM2eW8r?=
 =?utf-8?B?Z2F1UFVCNE45V0hLLzJTRGNBNW1tQ2x4bldZV00wbGxpa1hkZ2JzRUtNLzU0?=
 =?utf-8?B?UUZxWGVBTDVlRXo5Mk9YWjl4c25xMmp2OXp3b3VzNFhqWUY1c2U5Unc5MVNo?=
 =?utf-8?B?V1FZdE1GOTdGRmR4N1BMeW1YM0FNc1Juam5RcEd1cW5WdlNxMUo3YjFndGp2?=
 =?utf-8?B?aGxESk43Y0NxeGRjN25mVWs3OGNTMDllS1UzdSsyQlNxdmtqbWlNZVg1Tk5F?=
 =?utf-8?B?Q01Ed1ZHRU40Y2FrYkdtNmp0a3pRbWNxdStlYVI2OVZBUkJSUGJnRXNkRTN1?=
 =?utf-8?B?NFFpL1pnYlA1cS9WUUc5T0s1M01uUjA2Sk5Fdml3aURESUdtOTR2RS9uNXFn?=
 =?utf-8?B?c1lXSm01R2UzYk1lWHVqMERNSUhxMVJlYXpCSUZBckxmSnlHa1laVEFFQUV2?=
 =?utf-8?B?SEdlYWFBMWthUTRxZnA0d1pzTzlXNUJQNTk5NUY0bVlLelhnTVJhWEVjZThG?=
 =?utf-8?B?U3RpWVRQd0VoSG4yWERjckEzaEhsbG9uWDAyL1Y5K1pIV1BCdDdhWXRESmtB?=
 =?utf-8?B?amNsWmdnRmV4ZzI2UnRzbVZzeUZnc2pnaTAycHVvSGZFNUtrMW15ZkUyeHdQ?=
 =?utf-8?B?KzREbWIvT3ZmNzNDRVBCTm1vb2xwSGpIdEdrMFV6WFlMUW9NdFl1L2VkTERV?=
 =?utf-8?B?Zk5xWHdlRVQ5YjRrSi9qZENKR2Nua2lxMU5EWjZpd3ljdTNZQ2txbW9lbit3?=
 =?utf-8?Q?+Hq6XGCkuAGGVkYcjIMzGOBNX?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 748fc5af-7337-45f8-3c98-08dc8cba90c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2024 21:40:09.9831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qqEAr7uL+RYeO9cRscfvEqzAtfGH4PL6OV2G1APnIVt9QTi1/ctdao2fHnRSfamWl88q6B0bhlxjHC3ZyLhZvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8764
X-OriginatorOrg: intel.com

PiBXZSBoYXZlIGN0cmxfc2NvcGUsIG1vbl9zY29wZSwgY3RybF9kb21haW5zLiBtb25fZG9tYWlu
cy4gIE9ubHkgb25lIA0KPiByZXNvdXJjZSwgUkRUX1JFU09VUkNFX0wzIGlzIGdvaW5nIHRvIHVz
ZSB0aGVzZSBmaWVsZHMuIFJlc3Qgb2YgdGhlIA0KPiByZXNvdXJjZXMgZG9uJ3QgbmVlZCB0aGVz
ZSBmaWVsZHMuIEJ1dCB0aGVzZSBmaWVsZHMgYXJlIHBhcnQgb2YgYWxsIHRoZSANCj4gcmVzb3Vy
Y2VzLg0KPg0KPiBJIGFtIG5vdCB0b28gd29ycmllZCBhYm91dCB0aGUgc2l6ZSBvZiB0aGUgcGF0
Y2guICBCdXQsIEkgZG9uJ3QgZm9yZXNlZSANCj4gdGhlc2UgZmllbGRzIHdpbGwgYmUgdXNlZCBh
bnl0aW1lIHNvb24gaW4gdGhlc2UgcmVzb3VyY2VzKE1CQS4gTDMuIA0KPiBTTUJBKS4gV2h5IGFk
ZCBpdCBub3c/IEluIGZ1dHVyZSB3ZSBtYXkgaGF2ZSB0byBjbGVhbnVwIGFsbCB0aGVzZSBhbnl3
YXlzLg0KDQpCYWJ1LA0KDQpJIG1lbnRpb25lZCB5ZXN0ZXJkYXkgdGhhdCBmdXR1cmUgcGF0Y2hl
cyBjb3VsZCBzcGxpdCBzdHJ1Y3QgcmR0X3Jlc291cmNlLiBJIHdhcyBub29kbGluZw0KYXQgZG9p
bmcgc28gYmFjayBpbiBGZWJydWFyeS4gUGF0Y2hlcyAobWVzc3ksIG5vdCBmaW5pc2hlZCBvciBm
aXQgZm9yIGNvbnN1bXB0aW9uKSBhcmUNCmhlcmUgKGp1c3QgdG8gZ2l2ZSB5b3UgYW4gaWRlYSB3
aGVyZSB0aGluZ3MgbWlnaHQgYnVpbGQgZnJvbSBoZXJlKToNCg0KZ2l0Oi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2FlZ2wvbGludXguZ2l0IHJkdF9zcGxpdF9yZXNv
dXJjZQ0KDQotVG9ueQ0K
