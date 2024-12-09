Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D37619D09C
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 22:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733781948; cv=fail; b=VPelVAzSUOFJ0M+FEQIMdGAsAe2vuT5xK/KBIDZNISR2fqqGP6jau9EABIB7X6uSuIrzwOuCiwdmSjyXuCPmjmdXINwNxsMjZZzN5K6qcFNObYyiJ6YeBUjJuIHt90aMa+se3blJFMghfBIYgefQMmlsgARDpDjiUNb7Uwb8nDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733781948; c=relaxed/simple;
	bh=Mclfi63dHnVRI1n5ZL/aTO9iOksti5GtHXIkmtRBrEk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ot84KpG8/xdiSunsc4RYbwIZxXfvD4SUh2mzSzSShxcgfgrb/QdDT8fK2Dv7MH6ac0LiPXeb52RXjAnX5/wB9+0XBK6NoGlZK7ttfkQmyD6spHuoq9y63oeQ9bgQ3aZsjsloT41vK1iEDAsw+vDEaqT+o9geceL7OKkyOnZ/3bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=heV8lvas; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="heV8lvas"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733781948; x=1765317948;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mclfi63dHnVRI1n5ZL/aTO9iOksti5GtHXIkmtRBrEk=;
  b=heV8lvaskTDdoQUjUlY4vg9yMaF/Nsl5WMjmfgB7ruQ3y3vNQnATBpVn
   ODwO0NsT7izxG8VfwhTVcJ99YCG8Q3mwHQ3IbUO/QlEBgTm+0EHu9iDCs
   3jxKBsbAf90GiMBLydaXgCgLK/X+xVnuP+lJWEyvNGc5z7RrHMRaecQZd
   WbbY5OHPHbzDcljv/sVtlRhzrZtwbDSDveoMryS1OEbNzEW6T4cFywxbF
   zCr7mqJyhBs7Kj6ry/vyqKSskuJZRvAJq37xf0ikqd79bmPEZP97AQj/y
   LpV6W8V2Xzhd18+eOFAqtzfVXykXqSwdqYAKxmLxDJT1aakXAKLvMTYxy
   A==;
X-CSE-ConnectionGUID: kYmDvFykTVGIF+75isZ53Q==
X-CSE-MsgGUID: XnRtlKk6Tc2Kra6mPu0LgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="34027969"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="34027969"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 14:05:47 -0800
X-CSE-ConnectionGUID: 2weYpOUSTSee0nK0ETRVqw==
X-CSE-MsgGUID: gvWtocDRQZOih0gsn/h/wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="100149360"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 14:05:46 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 14:05:45 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 14:05:45 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 14:05:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wH9mr5QuVEd5YYzUiHdFgL7GrM6MlNdAEWPWePL9vojGcT4NdLC6LhCV52EDW3C1mQGw59tTA4DWUpJjd5qBYxoZsz2JoSYAuFUwbDjS5jqwg/4g1tQTqnIUlhh27unGySJeSm7t05SuaNy5cQWbtaoRkfhgzcrtK9PQmHktwTAMkyUj4uJeDDD3vqGOEpiT+hY3crhz3TFmYnYCv3YJMD1oL4NaxSbSHAHlV0ZRU5E5uIyBiUn/Bk/CqYLPhEyUTIwNe7rdOQMy4nolrtAagv5am+1nLWuStrhqqKtgDUjZzaqfOPnOH3pznzFZz7NvD41PkpQ6KF09n2ql54essg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mclfi63dHnVRI1n5ZL/aTO9iOksti5GtHXIkmtRBrEk=;
 b=MgHHDHuEEGdw5m9WBwlf/vmRnOitcPDTgqN8AuXzrkDH2Tw5bwFlgOrjQyKUPWLH4jeKyAPIMZh1GoCeVIMCyD6tlJkk5SQSioy3ClKUphV/xrT/M60jbstJPMWDJYVRr1x5cMgHmlk8dQa1TEycde5E3XuvM7lpfHyTu0qxPwT8ThhDTS5l598iPziNuso9mxmhOc6ik62kkcRhWMZxNQPwwg+Dxtvv5j04Hr3BAeAqav29i0Mwqi2ZHwUbGaaq/cBYVC4KuUkT+N/XZsiOIeE0EjqJwZnzgwxrlddg817sHLBl2inYm9wJQy/ZfGXg4AV0boBIV7Bjlc46S9fl6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB7990.namprd11.prod.outlook.com (2603:10b6:510:259::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Mon, 9 Dec
 2024 22:05:43 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.8207.017; Mon, 9 Dec 2024
 22:05:43 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Babu Moger
	<babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>, "Shaopeng Tan
 (Fujitsu)" <tan.shaopeng@fujitsu.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v11 2/8] x86/resctrl: Prepare for per-CTRL_MON group
 mba_MBps control
Thread-Topic: [PATCH v11 2/8] x86/resctrl: Prepare for per-CTRL_MON group
 mba_MBps control
Thread-Index: AQHbR/xl4acp4pgYNE+Ib74ICcEb47LeZouAgAAVKBA=
Date: Mon, 9 Dec 2024 22:05:43 +0000
Message-ID: <SJ1PR11MB6083BA367F2CDFC92D87FDA1FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <20241206163148.83828-3-tony.luck@intel.com>
 <20241209204519.GAZ1dW3-NjcL4Sewaf@fat_crate.local>
In-Reply-To: <20241209204519.GAZ1dW3-NjcL4Sewaf@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH8PR11MB7990:EE_
x-ms-office365-filtering-correlation-id: 08d96934-9f5d-466b-991f-08dd189da015
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eWRHY2k2QnI4elJMUGgxYTRDWWxnbDk4UE1ycnk3L1YxOUJaUDBoK29QNDQ5?=
 =?utf-8?B?VG94M1I4cUFSb3JZTGhudVg2TUNxZE41M0R2NUFKdCtiUGpCQ3k1QWlkbnVr?=
 =?utf-8?B?WDNqSjZtTElCa2xQZ0x5WWxacUhzUEx2M0cwbXRuVkNId3ZGMys5MEVTVVhJ?=
 =?utf-8?B?MEtlYmhTaHlpZEthdExNRWN1SFIwUW5IS2grb09qcXZyYmI4OTF0RjQrUjhJ?=
 =?utf-8?B?c0V2Y2ZocHRvSk9BK09lRHZIa0sxakJ4LzZiLys0UW1wcHBxWWtjVUZCRHlk?=
 =?utf-8?B?dnM1WVZwdXJvd3k3WTRrdWhLK3o3ckhzWGpobSswWlNFckZ4bS9uOW5rbEM5?=
 =?utf-8?B?aVBMaEd4SllWUWJDU0Z3ZkVEcU9uZWgrdlRzaVNuMXNPS0VsVTgzTG1ZNy9M?=
 =?utf-8?B?VEZ2RHZDUDN1QWdJZjdjb0dVTmM3QUtIT3VtdmJpV2U1TVhCTHdJMURnelJx?=
 =?utf-8?B?dUlhSnRUQnZ6dFkxeXZyVlgwZWlQL3BaMGwvTVpDMHhrSkhBWHlGS3BpOVJ5?=
 =?utf-8?B?aEwraE5FZHU2L2FBVktYMkxHaThOaFFlS2pnM2tsbEtaY1hqM2o1K1VuOTRU?=
 =?utf-8?B?eHVGMG9ncFcwb1RwS2I2T3h4QjFmRlNheWk5elVrR05wS0hodmorZVRNN05r?=
 =?utf-8?B?QWROSkRiUFcvR3dTQXZoWmpWRlY1WkRPcXJDYWJLcnVtUjh0RFVkb3NHd1p1?=
 =?utf-8?B?bFhkYnRMZVZlZ1dFSXVFVW1hTkxIV0JkZ3dUTTlPdmNYM2NDNEVSVzdGVGM0?=
 =?utf-8?B?OWpyTmpaRUVwSE5ENmJXUG5sT3l3TXJRSUJIYU5PcGdHemdyQjBRaVZPcjdo?=
 =?utf-8?B?NDgxQkdwT05ieDBwK0FYYkVGM21FMzVSS2I4UjF1ZDg4MnBjbXZPangwd3Bz?=
 =?utf-8?B?b3R2cW4vVjBXK2hFbmc4c0hpYU90YUJudHRpeWRLSGtmYXV0V3hvSW9XUTkx?=
 =?utf-8?B?OHNaSjgxQ3N1L0Q0MStzRVd5cytiQytQbjUycFJVeWJlSy9ocXpsbFZhbThm?=
 =?utf-8?B?L3lYRkxPbHo1T09aa3BmQ0VQWnBwK1lHdzlOUXMzajdwZGIvWlJaUHhjOTgw?=
 =?utf-8?B?Y1FScDhWN2hpYlA5dndCZXFDWkhTY1RHMUFrM0IrSkY0eGliQjNGRGNxUGcv?=
 =?utf-8?B?dDB0MFA4aEZpSG5Xekd0a1gzRytCVVpFZlJ3ZkdjVTc5QmRkb2pvUmNRdGVC?=
 =?utf-8?B?aWF4MzkrZkYvcjVGYWRPYm9SYk0yY1YrR20wTDlqZ1ZXWUFPcGU4ZFFNREZk?=
 =?utf-8?B?blQ5Wit2aXZaNE5meE4vOFRNZ0p0bk9Jek5GRUlDWmE3Mi9xUGhOUHNZOVNF?=
 =?utf-8?B?UUJqODhZN1ZjZTVUNkQvZXVDcFo3R05FSjcydVBnbFRTdkVtd0lUVytISjZS?=
 =?utf-8?B?MGRwR0NINmFIcFJLZXczaElvdmJ1WXFkZzJCYUU3R29uN1VTNGxHRENQUTgr?=
 =?utf-8?B?Wi91VWVML045dTNiNjMzdnU1Y1l3cEIwUUladzY3OVJQbXp1NDRzVFVwbUd5?=
 =?utf-8?B?MnM4a0FIY05tYTdHdmZTZjYzUzlKNGJzSnQyZ2thV2liZFdmSG1nRlJyd1Nl?=
 =?utf-8?B?bWpHZWdEVDBEdHZESDZ2KzIxUGJTOC9VV0NlYkROeWNwb2hGWS9hdnMreXp6?=
 =?utf-8?B?a2xLNnh4b1JwdnJtcW9QZURjSUJPTG5id2RiR1ptR01nYndkMVNCVG9CTk1D?=
 =?utf-8?B?cGR1VlJCcE5RM3BxU1RLWUJGWUhZTFhucVRMaVQ1SXZucldsR3RrK1k5aTEw?=
 =?utf-8?B?enE3Y3F4NFVSNDRWSk1BM1o0aHoxMDAvRndJams4bEt0Q2I5WldSM3ROalhG?=
 =?utf-8?B?T213Z1ovME5LVlRLeGFLTHhQVFBwYXA0dmpvZnMyTGN5d1ZWRjZSVVRSZUtJ?=
 =?utf-8?B?WkFNMFZXanlXakxrRktVcm1NVG1EaXc4NXRYbC9vcWpkbGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NlZyZUhmQzZLdWFxVjJWdDdmRWF2TGhBbUs5ellNdCtNRjZVcTlnM2ZwUXA3?=
 =?utf-8?B?Q0sybS9EVEowakF5VDFLUmwzY3JsVXdQQnF4dGQ4N2M1bDJnNkNnejV1eW8z?=
 =?utf-8?B?TE9PM1BWWWdzdGw2VllMR3p4ZTRHR05rMk5Pai9OMCtEV3RiRDFqQTZLcTZz?=
 =?utf-8?B?aWNDcndDdURwdUQyeGVMZFhVYlJOaFY4Z3dkU01yOG1iU0N3TWVJODBEVS94?=
 =?utf-8?B?N3Q1T3J1ZXZnS3VuUEVKRkpyZkJLUGYwUmdGN2VSaWUvSS9WVjA3aWpPMDFi?=
 =?utf-8?B?S2t0akNtbm1hWjhha0xxdUJLQUNqNGk1RC92TjQySEZuVkFZOFVGVGtvOXVt?=
 =?utf-8?B?MVFuWVJmMm5xVWxFeFZSaUEvNWM0b2MxRmFwZmhMN1p6L0IwYlpVd3JaRk5W?=
 =?utf-8?B?UU1zdnZhYTFnMlpNZ2NnZ3ZOWUtNZEpidnEzTjJ6SjdSZythbjdiZzNINXZY?=
 =?utf-8?B?WFUwdjdlRHFCMGhTMGtPUGxTZ1RwNmdJeWRSc1paa254bHdLQkM5c1lnNzBP?=
 =?utf-8?B?cEV0SHFQREpSaUdwLzFWN0ZGdE5kcFNGaTRqSVNvS0JpcHoycmNaM1c3c0dG?=
 =?utf-8?B?bDluUTFzVWtTWlJnMm9aR1E3cDJPZndLTk0rbkxHdk4rL2hRemMxYVhvNmF2?=
 =?utf-8?B?STJ0b0MxU0FzT1JHNkFSeXd4UkFZQjdiajRRZWZuV2MwaXgxcG5BMVpXaXds?=
 =?utf-8?B?c3luL3BXN0w5bzRIMGJDNDNZb3l2aXJMbWZFVVlFZUVDSU0zMytpTlZjS2hI?=
 =?utf-8?B?bGM4ZmlvOXNoM3BIZEpZaFUyU2JwdjFJUGNSMWlDeG15NGt1WkFDelJoL3h6?=
 =?utf-8?B?UVQ2Sk55MHh5bG1rQmdVMWdRYldBYTZzb29mMFFkN1UwRDUwaDI5NWVWODUx?=
 =?utf-8?B?RG92a004cUg4RkpVVVlpQ3pJeUdEOERXS2lDdHJGYjExeEY0Ujg0U2tuYU5a?=
 =?utf-8?B?d29wOUJVU1lHVVRxVldZdmZ0V0JtZFR5cE96a2JxcDkwOHBhdVFjTzFaN2xp?=
 =?utf-8?B?ZkF2OEgwZ013NU83aG4vMWRnNW0xcFFPVUtMQmZ2dTlMcVBZbE5QWUFUb1l6?=
 =?utf-8?B?MmpJdTNoaDYrNnVVVnNQRUlPL0IxUWpKRW0zSmNwY1ljMXo5cnI3QUVlSk8x?=
 =?utf-8?B?Z2xMcXdTcGt3NW1KYnpxUVVDV2cvekF2RHB4RlFnSzZ3U3RqTTVGaWJ0OHI0?=
 =?utf-8?B?Vk9rQXRxUGZlWTR4L2trYWJxN2dUTDZZUlc2SGtGTk5SV2hkOTJTeGtuc0Fo?=
 =?utf-8?B?QkFXUXgwTjJJUkg5L2RsNXRSc0p3OEx3NVdCdnVtdzVNOEhFMjZNOVFyQzZN?=
 =?utf-8?B?TDF2Zy9lNXgycUprdGorSHFnV0k3T0RzcU5PczhWcEdmZWUzdmlHNGZpcU80?=
 =?utf-8?B?VXAwWnUzMCtoRllkV2h5VkZpbnR0S0dPNlU3RWJvSlJZd050Y3U2c3RveVVx?=
 =?utf-8?B?V0NLNWc2QWJzT1NGemVhL3RCRkpXTmd6RHEvemlHdFBScDh5UVFjK3NqNm1I?=
 =?utf-8?B?VG9NeTZ1MHdvQWhxVWJmTGYvTnhkQ2FjZjdCdVozUjROWVYzTjBaa1FWYlNu?=
 =?utf-8?B?WCthMzhMK3locjhpOWlFa3ZTSTEreFQzclMyTG9SekNVbnprQjcrT3Vnbmhn?=
 =?utf-8?B?UVduNXJVa3JwV1N2YjVCUTd4Nzh0Z1VWcHZWRzhGQlB5UXdsVHpNSVpCV2tl?=
 =?utf-8?B?QzduV2Ftbm45UnYzOU1qalNRaHhDTVNCYjRWK3BBTjR2TlYrRmhOZmRFaHVx?=
 =?utf-8?B?Yi82MC9KQ013Nmg4cm5rV2JyS3dzY0VkbnlMZVFLR3hBSkxpR3lhUmtXVnYw?=
 =?utf-8?B?Z3JwRUpDWnRIVjVCWGl6UFRXb1ordC8vV1JRYmVXSXRUYmNHNklDS2R5d0xS?=
 =?utf-8?B?ckVIQUlzbzE4OWZkMmZNRVl6Y05ucHJGeXdXSm9QN0lFWUJ1K01RS3ZZNkNK?=
 =?utf-8?B?SERXZmpDaktuV25YaEhMQnVheFJzNS9XaGQvNTJ0a3RrdHZ0a2R1ZHFSV3gv?=
 =?utf-8?B?NUJsbDg3N3FWaVhDZ2t1aUxwYnhvdlBZRXIraEpLMjgzRHk4MDV4aGh2d1FH?=
 =?utf-8?B?RkhMdmMwbUxQTlVKbTRIYi9vSS9CMnlRVVRBSnpsbmxkSW41aWtERm05VFVv?=
 =?utf-8?Q?u+uH3GoKitJ9YwNxVfms37O7F?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d96934-9f5d-466b-991f-08dd189da015
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2024 22:05:43.0675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jKfpmrQMD+UiGG8k+B345HQq9gxc22YX0cX+y6fPMRVusajLbHtEYyuvpZqKkBupUO7SMeGNSIqUlt/wDW+gxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7990
X-OriginatorOrg: intel.com

PiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Jlc2N0cmwuaCBiL2luY2x1ZGUvbGludXgv
cmVzY3RybC5oDQo+ID4gaW5kZXggZDk0YWJiYTFjNzE2Li5mZDA1YjkzN2UyZjQgMTAwNjQ0DQo+
ID4gLS0tIGEvaW5jbHVkZS9saW51eC9yZXNjdHJsLmgNCj4gPiArKysgYi9pbmNsdWRlL2xpbnV4
L3Jlc2N0cmwuaA0KPiA+IEBAIC00OSw2ICs0OSw4IEBAIGVudW0gcmVzY3RybF9ldmVudF9pZCB7
DQo+ID4gICAgIFFPU19MM19NQk1fTE9DQUxfRVZFTlRfSUQgICAgICAgPSAweDAzLA0KPiA+ICB9
Ow0KPiA+DQo+ID4gK2V4dGVybiBlbnVtIHJlc2N0cmxfZXZlbnRfaWQgbWJhX21icHNfZGVmYXVs
dF9ldmVudDsNCj4NCj4gQW55IHJlYXNvbiB0aGlzIGV4dGVybiBpc24ndCBpbg0KPg0KPiBhcmNo
L3g4Ni9rZXJuZWwvY3B1L3Jlc2N0cmwvaW50ZXJuYWwuaA0KDQpUcnlpbmcgdG8gYXZvaWQgbWFr
aW5nIG1vcmUgd29yayBmb3IgdGhlIEFSTSBmb2xrcyBhcyB0aGV5IHNwbGl0IHJlc2N0cmwNCmlu
dG8gImZpbGUgc3lzdGVtIiBhbmQgImFyY2hpdGVjdHVyZSBzcGVjaWZpYyIgYml0cy4NCg0KbWJh
X21icHNfZGVmYXVsdF9ldmVudCBpc24ndCBhcmNoaXRlY3R1cmUgc3BlY2lmaWMuIFRoZSBtYmFf
TUJwcw0KZmVlZGJhY2sgY29kZSBjb3VsZCBiZSBpbXBsZW1lbnRlZCBvbiBhbnkgYXJjaGl0ZWN0
dXJlIHRoYXQgc3VwcG9ydHMNCmJvdGggbWVhc3VyZW1lbnQgYW5kIGNvbnRyb2wgb2YgbWVtb3J5
IGJhbmR3aWR0aC4NCg0KLVRvbnkNCg==
