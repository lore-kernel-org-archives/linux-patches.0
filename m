Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFBD12A16C
	for <patches@lists.linux.dev>; Thu, 23 May 2024 21:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716499546; cv=fail; b=J2hFC85pwaLA/UWa+LxZlaWxk7DRuhyqjxOIJ9Dao0yE7j/qx/lEEsK5IgmzEm0pBDTvKs2FlGtiM8I9eT4L5VqhAhJH4Auebqbr+HlHBcPn9mF3Hs1XGswrgPLxuxZ+0lu2v4Adcm40C+nkXMYAmfpb71MY6xKXi2xmrM2US6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716499546; c=relaxed/simple;
	bh=1DZ5No1egl6WRqoNAbePBjhDSq6MgXpXe96dOuPWXRA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iWd9ffYZv2XAKE8mNjI7o+GEYjB+GRWbGGEFMV47SMFuGFHxY/YmNGt8uud1yD0qbXGOCePo9QA/wEqzaWazmBckqFgtFM/QkQ9XCzSYraSiP43XT5uL3/1Kh/F1sM0QXyPfX5S8+j/53G2Gb9u3HSJAbGMUA8uFYz+Q/NECgiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=muwRR4YE; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="muwRR4YE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716499546; x=1748035546;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1DZ5No1egl6WRqoNAbePBjhDSq6MgXpXe96dOuPWXRA=;
  b=muwRR4YEVLXlb2Pk+wR16Shk6TdM4yTD7MzyqJBk/UmDBXVtgv/cypjn
   WmWjYhbhHqHktNiJ8bKwM2qwB32lZyzIa1b3ectLkj+HTkenQILj09K/+
   okcExQ9Io5LlwyVsgv1alWJQbPdUSGyGtWku9tUujFlWB5AuAFA7iyvhw
   HFyQUNhTAqGhSy4615cb+JTeciqGOpbhszclHgONkhWxeHjr0cio3Nf2C
   EhBNnDwPZTSP0dAMFkNijT9j/kWFRcvMH5V/9+V9vgvQPeVovE/H5Hr6C
   3x3Rdj9qDb+JEyNm2qkQshMthQxZj17ywdHTt0DlCEQudzEkmuG+cxkJZ
   A==;
X-CSE-ConnectionGUID: 2cmOXYpdT02uZsfh0ubc3w==
X-CSE-MsgGUID: dWxht2Q/QR6F1Jej2amN8g==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="23423201"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="23423201"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 14:25:45 -0700
X-CSE-ConnectionGUID: rNg12wEpSFm0WOu503bjNA==
X-CSE-MsgGUID: CWIrdzKERiafkkD3GGE2kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38651645"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 14:25:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 14:25:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 14:25:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 14:25:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 14:25:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rx3DsBBSJH8UDcWn04edo8uqNfgXzo4W7WhXWmRTnihaugv/GbeUn+/VAUTlnBB4j42jwVmkPcNY98mHTlXm13TwTgryqh2FS5lFNnWX5fVNXeN2+vTTRPaa67ITbfPfe+HrwrMCCtKE2lDZzVi2gw9TpMRntt0fq9f4AcooXmGQC6Nmg+2ozkbNURIru1vnt8oQph7vx2zDeaOgfkV0j5WNvkkNWqdh6SOiQ4ELGw2p3ugNjWchdj+g4VUz1mh2iUa8MAZEJhZ9A6hI0O9rhl574J6ThnaEds+r32ss6nDDudHdhx18FnjfLIQgtNtVnx+z0ClgTuquH4sA9gmOPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DZ5No1egl6WRqoNAbePBjhDSq6MgXpXe96dOuPWXRA=;
 b=D7H79JfnjkEIJ7o6vUuAP90QvzgKtJuIha73dFDDjEsVY9STrdAi0ot5BgSfiD7pIAMV3dZ29NtW+SGXAt7CTuPo0Ov1ZL8zPGIayb+Emw7bjjX22VDNo6ozW1+9kCECWw7j2qYg246hcbDwOaD1sKBD6ifIJ7OE6eFRaKgoEKZiXM89bxzt6EuHM5Ibkb5ux8tFxPTNPmosaO+/ZUI4SSsOGg8Qz1w7XesFFS494ythb93/pJWT+SscH21wtl0oCWnSLj9Rp+ST123shgE9IPk+/GnoZRbB2BuR6RFpwNfpIastb/W/gqh3BqJ3mdugrkBoOAdvLsvOCgTtl/sy0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB7314.namprd11.prod.outlook.com (2603:10b6:930:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 21:25:41 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Thu, 23 May 2024
 21:25:41 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
Thread-Topic: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
Thread-Index: AQHapxaLlE5h/oF4QUmt1DBuxjvwvLGjyhSAgAFrFfCAACP5gIAAB3Dw
Date: Thu, 23 May 2024 21:25:41 +0000
Message-ID: <SJ1PR11MB6083C6A9DFFF58FE305A33F3FCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-7-tony.luck@intel.com>
 <beee3369-0075-462e-8449-88fee807463e@intel.com>
 <SJ1PR11MB6083117715CD53FA4360C56CFCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <013c9532-cacf-4604-b1d9-e90fdc80e7dd@intel.com>
In-Reply-To: <013c9532-cacf-4604-b1d9-e90fdc80e7dd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CY8PR11MB7314:EE_
x-ms-office365-filtering-correlation-id: ca92e74a-775f-41fe-7a8b-08dc7b6ee627
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009|921011;
x-microsoft-antispam-message-info: =?utf-8?B?ZjA5VGh1RWREVTV0ZEJDRncxRUNVbk1SRTFnTzhmeUJ4NDkxd0hCbEY1NVpS?=
 =?utf-8?B?MWJyUzRuSmt3MkNINE9iOGZHaVczcFB5M3o2OE1lMk1pMUxVc3B2bXE1RmYz?=
 =?utf-8?B?eFViSjR6Q295Um5nM3FDMnhlb1Zad3kvaU1mWURUK3V1T3FOL1puODY1UDNx?=
 =?utf-8?B?VGN3YVJ4VG41dnBBbzE5VFpsaFVHaFlWR1hJVEhZMFV1UXlUMXg4ejdCSFln?=
 =?utf-8?B?a3pCYzJwcUV6OWtFK2FqTXN6dDNOODhzdjFZRWVqamtRNlFJZHFlL0E4S0Vs?=
 =?utf-8?B?Q2F2M3BxQVhsWmtRL3BpWTdOVTFQck9QTEpOd1JaNllTNXFzRnpxY254WjhY?=
 =?utf-8?B?aS9iMEpnbTBQaE5KWHZHN1JOZm5DS3R3Zms5YzhDa0FFM1hMTVhvTW9WVXJk?=
 =?utf-8?B?Myt0VWpvb1RhTnhGbEN6Zm56LzBSNnY2OElRc0Fickd6SlZMZXpqYzNtUFdX?=
 =?utf-8?B?WjV3L3JNVDFZVUxjNzMwTzd6WTV3ZTZsdjRtb0dtRnFsSHpYUmV5ZDBTTmdL?=
 =?utf-8?B?V0U1eGdVM2dFRU9IWHpGOGc3WVNDbGlRTFlNd013QTVob2gwRVFpbXFrVit5?=
 =?utf-8?B?YS8zcDhVemVtMkYrNXVkTTlmWStpWFFqS1Z2MWxVSEJOZWtObzM1eDU5bDlh?=
 =?utf-8?B?QzdZT1k3dHZoWVJubHN1a3JEcHZuUVBaaDFNdlhLalc5enJEdG96VHJVNEZh?=
 =?utf-8?B?RDJvK3NKMzhHQVRrZEJRSXVZTDlUTzlrNlJORDBpMC9TUStnZW8xSStVdDRI?=
 =?utf-8?B?ekFkMFJXSmFuWFRWV3NlMC9jYi9GeGFMeWo5ekxvaUd4Q052dkRLTHBSSHZQ?=
 =?utf-8?B?NDNVaDhySWM0Q3llWW1HbFlhTGpRUk1weTRZYlRRcDZJNEZwMmdma01aSVJJ?=
 =?utf-8?B?TW5ES2tTRzBGbFZ2eXZ1bmFzaDFNWm1mTjVMZFlGOVVaamVaclNqcnkrRnJJ?=
 =?utf-8?B?QzVlc3NaZFFwKzRRUVNoZmoxMC9WdS93OERFMUZjOUlZekV2SkFOYjhlMmh2?=
 =?utf-8?B?TStYMjljRDlzZzVGcU9JTGZzV2duVno4RDBZR0lCU1Z4T3RITGU5anN1dElB?=
 =?utf-8?B?YldLNnVLUWJ5eHdBQ3ZmZmlnUkFzUXhia0Njd1ozUWRRQ0xUQVZkTCtsYTFl?=
 =?utf-8?B?T1BKTUowU3lNQm9PSFZYd3BXc2pxRjZyQXdFYU11UEdudU5oK2luVnpyNHNh?=
 =?utf-8?B?T3BSakllc0VSTHI2WVN5RUlIOStwckk0bzg0aDlBbkF3VU5zUWUvR3c4Z1JS?=
 =?utf-8?B?cjkxR3N4M1FNQUZYTXBYcjkzT2E4RHFsQmV5eUF2VWFyaUw3SmpFaUIrdGRT?=
 =?utf-8?B?ZjJjcTMrUkNBQ3AwNnh0aCs4RlJFZTBraWNkTmpaRWgvYVplNUZTbzd3MmVW?=
 =?utf-8?B?RGNlTjJ2TjAyZ1pQUEpxMWVVTjgySG82aFlETzh4UkY3eXpFSFdibVZJRlh3?=
 =?utf-8?B?UTMyUFNwdllPeFF0NDkxNHpGVTl1YWErQ1p6M0lHTjYrbVIwdDUzaC9kK0xP?=
 =?utf-8?B?UWJsTG4yTFVNNmQrcDBGNjJVaGtQdThTbzV3eW5rZDJGMXpickIvZE41MitT?=
 =?utf-8?B?R1lSR015UEFzcEp3TngyVkdQRExPbmJIckNPUm1XWXhOYVFwTXVmcFlTb2ZE?=
 =?utf-8?B?NkZaL1JJSndpdmRqTjVhZnNrWWQ3elN1Qi9EbGVoRGZJcXZzZ2pWR0lrZ1Rr?=
 =?utf-8?B?OHlDTFNUaXhQSTdad0RWeGo3N2t5anhjNkxwYXY2M1dNTldSUGxUMTdpdVVV?=
 =?utf-8?B?bk9NenRtN3hPWGVSYTNqYTlONHd6ZHQ0L1JGSFhyQkp0S290QysvRU5Wd01y?=
 =?utf-8?B?ZzhnVzFOTFpkM0pvQ1hPZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjFLWmpBaXM5U01KbXNGd2JoNk9qaDU3YkxwRk5DTDE4MnFTYlMya2RoeTNo?=
 =?utf-8?B?bVZOTTRqZ0NKc1VBV01KZ0VFV08wQ2dTbFBRSnF1NWpEaVM1MVpFOWJvNHJY?=
 =?utf-8?B?a2lNMnpub2RJWmRrTk1EQ0hnZjZuS1ZzclptRmJGV3ZyUEJxL3h4OGVBMmdv?=
 =?utf-8?B?RFgyNklXSEs4WTlZT2VCUDhnQldCV3R3ZnUrSzV5Y2VTMmlRTTJ4OXAvTytT?=
 =?utf-8?B?RjBzNm1kNkVzUTNPTmxFS2dnZ3hGSkVBc0NyT1VMT3ZrYW9Id2wzcisyZjhp?=
 =?utf-8?B?eXZyS1NmdUxJWVdSdjZrbWRmemlSMGF5cVpFZXVxUWdPMmJiaWZYaUZmcFQy?=
 =?utf-8?B?c2ZaSFp3MnhKY3lzaWNaUE5QTEtpWkF5bWs2VnM4WGtuMXBaUXVZYUZRYTVR?=
 =?utf-8?B?WUQ3bUp6T0hyWmtyU3lSQ0J6d0I3SXVleWxrenBDWjZWYkhvOWYyckx3QTBW?=
 =?utf-8?B?NXBOUkl0Sm5VanQrZy9zaE1ycDRXZy90OGpsTStDOGhiMTdkZmFTUWFTWWFw?=
 =?utf-8?B?aEUya2w1Q1BMemNvNEZuakF6bnFXZGw3eHc0R3lLZ0lEM3RHZTVWZWp3eUlw?=
 =?utf-8?B?NFR3ZFY3c2NnMnZ1RmVNalk1bFE5U1lzM1Rzd1l2RWsyK0RML0RFelBNNTBt?=
 =?utf-8?B?WXUydG5BWXFka0RMbVhuR2hUQzl5NGQ5alV3aWRGdnh6V0hQQ09HcGd0QXFn?=
 =?utf-8?B?OHdBc1g1Rjg1M1NySVlKN09pbTRoRmJ4NU14OEc1WlhVTSthU3hwa2k4aWEv?=
 =?utf-8?B?T3pFMXRwOGJqa2NMQnlrZzVKa0dSZktVSlA3bWVrMTJ6b0N6amhKUVd6T0pP?=
 =?utf-8?B?c0JkZExSY3IvK25hV09EUmxhai9GMVRtZkR6V3FVRCtLQXVsSW42VEY2blZH?=
 =?utf-8?B?VTFGN0NQc3M2T1lYMDRMZlYwRVFacitZWlZxcGxWanhtenQ4VUNRT0F2K3pp?=
 =?utf-8?B?M1FaUFVQN1N1SFh2bGtMVCtJd0ZKM0FPSmpkaERuVVR0MzUwY3AwdTI2dVJ3?=
 =?utf-8?B?TVdsT2NiR1YxendCQ2prTVg3VGpNd0I4U2Q0amkzdmY2dm42dmpON29aZm5S?=
 =?utf-8?B?bXM5OTZzMzBBNjdpUTdmRjVYN2hPekJKVHZNcXVISENVNDlSS21ZZnQzRlBx?=
 =?utf-8?B?cHoxUi9BZ0ZFZXRFMWlBWGhWbTdScE9zcjVIckZRdjNXb0lyZytnMEcrREho?=
 =?utf-8?B?ZmdGaUhqbkdXZFRxeDllTjlhc3lHV2dMRDFNYkVvakxzblRPZWlORUkxZU5R?=
 =?utf-8?B?TklPZXFvS1NRYTdiNW1uMWNhNG1HN0h3a2RkUlZvZnFFZmcreUZaVWdCWTRt?=
 =?utf-8?B?Z09KY0poeHZqTHhPY0hEZG80RU5rTnEwY2oyYlJtcjV2bEdNVHVmS2NUcVZr?=
 =?utf-8?B?RG9Ocy9kdEhHSkROZFpBWjdsT2VTWTZXSFZpK3ZaaUZQZXYzbFFSNHVKL1da?=
 =?utf-8?B?NVF1dHMwVGlyOWVlSTkzUUhIWHNrZFRzYUp5a0lMdkJCVWJiOTVuaS90cVh4?=
 =?utf-8?B?RG04dGZsQ0c1RmtGczk0U1NITXo0eVhhSEY2QXFJYkdVSXhzcElCYVFnaTRD?=
 =?utf-8?B?dXhHMTZkZ1BId2hWbnpaQlROV0FTRVMzaXVYV1BSTTJ0STZNOWxleDRoajBO?=
 =?utf-8?B?YkJLOXJDNXhlL2xqZVNOdmV2blhheVpvN2lGK1VGeTZSc0pHSzlSSE9icUlJ?=
 =?utf-8?B?eFFlWGhONHlFWkRWY3VsczQ2QmM3cXdpbzRiZDhjZnB6cHFQR1k0MkVDdUVC?=
 =?utf-8?B?R2VzZEdyMVF3ZTQ0UVcwT09UbjFoL0U0VzcyMmY4YjZ3OHpBL1FNWFBibm9L?=
 =?utf-8?B?Y0NHNDVPeE5qSWE5VWYzVFl5YXRpVUVYR2g5RzNsa044SU00Q2p1aFhNbHFL?=
 =?utf-8?B?Z01EYm1qdHcrakl3L3dVNjl6RVV5TVF4SXJQK3hjVXVtOVdLeUR6ZnVlTWpq?=
 =?utf-8?B?SmNmbFoxc0Q2REZCRDlYTDBOL0xTYi8vR2Zua1Q3UGxaSGR0bjZROFRSS0VE?=
 =?utf-8?B?cEE5c2YxcFh2SWJKUitqRUdybjRScWxYZWxlZnNRc1ZUVnhxaGR5aUpBTG41?=
 =?utf-8?B?QnEySHJKTXJzZ3gwN1FOa0s0M0tzbVFLeWRHbkpRUnM5M2hBeDdtNDF0cy81?=
 =?utf-8?Q?Bhq6z4oEfo/kzpxs4WGUM+6w1?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ca92e74a-775f-41fe-7a8b-08dc7b6ee627
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2024 21:25:41.7210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Ts2tRNuhnsGU2sYXxxWYNd6Ki4WZ2Hlp9i4wmw2+VAtgBuYgJFiPcc+nf6grzZb6wXT38Lzui48dcDChYZb2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7314
X-OriginatorOrg: intel.com

PiA+IEknbSBhbHNvIGNvbnRlbXBsYXRpbmcgZHJvcHBpbmcgc25jX25vZGVzX3Blcl9sM19jYWNo
ZSBmcm9tIGJlaW5nIGENCj4gPiBnbG9iYWwgdmFyaWFibGUgYW5kIG1ha2luZyBpdCBhIGZpZWxk
IGluICJzdHJ1Y3QgcmR0X3Jlc291cmNlIiAob25seSBuZWVkZWQNCj4gPiBmb3IgdGhlIFJEVF9S
RVNPVVJDRV9MMyByZXNvdXJjZSkuIE4uQi4gQmFidSBoYWQgc3VnZ2VzdGVkIGl0DQo+ID4gc2hv
dWxkbid0IGJlIGdsb2JhbCBtYW55IHBhdGNoIHZlcnNpb25zIGFnby4NCj4gPg0KPiA+IFBlcmhh
cHMgbmFtZSBpdCAuZG9tYWluc19wZXJfbDNfY2FjaGUgb3IgLnN1YmRvbWFpbnNfcGVyX2wzX2Nh
Y2hlPw0KPiA+DQo+ID4gQmFkIGlkZWE/IEdvb2QgaWRlYSAoYnV0IHlvdSBoYXZlIGEgYmV0dGVy
IG5hbWUgZm9yIHRoZSBmaWVsZCk/DQo+DQo+IFdpdGggdGhlIGNoZWNrIGluIHN1cHBvcnRzX21i
YV9tYnBzKCkgY2hhbmdlZCBJIGRvIG5vdCBzZWUNCj4gc25jX25vZGVzX3Blcl9sM19jYWNoZSBu
ZWVkZWQgYnkgYW55dGhpbmcgYnV0IGFyY2ggc3BlY2lmaWMgY29kZS4NCj4gSSB0aHVzIGRvIG5v
dCBzZWUgYW55IHJlYXNvbiBmb3IgdGhlIHJlc2N0cmwgZmlsZXN5c3RlbSAob3IsIGZvcg0KPiBl
eGFtcGxlLCBBcm0pIHRvIGtub3cgdGhhdCB0aGlzIHZhbHVlIGV2ZW4gZXhpc3RzLg0KPg0KPiBX
aGlsZSBzdHJ1Y3QgcmR0X2h3X3Jlc291cmNlIGlzIGEgcGxhY2UgdG8gcHV0IGFyY2hpdGVjdHVy
ZQ0KPiBzcGVjaWZpYyBpbmZvcm1hdGlvbiBpdCBkb2VzIG5vdCBzZWVtIGFwcHJvcHJpYXRlIHRv
IGZvcmNlIGV2ZXJ5DQo+IHJlc291cmNlIHRvIGNhcnJ5IHdoYXQgaXMgZXNzZW50aWFsbHkgYSBz
eXN0ZW0gd2lkZSAobm90IHNwZWNpZmljIHRvDQo+IHJlc2N0cmwpIEwzIHNwZWNpZmljIHByb3Bl
cnR5LiBUbyBtZSB0aGlzIHJlYWxseSBzZWVtcyBsaWtlIGFuDQo+IGFyY2hpdGVjdHVyZSBzcGVj
aWZpYyBnbG9iYWwgc2V0dGluZyBidXQgSSdkIGFsc28gbGlrZSB0byBoZWFyIHRoZQ0KPiBtb3Rp
dmF0aW9ucyB3aHkgaXQgc2hvdWxkIG5vdCBiZS4NCg0KU28gKGluIGFyY2gveDg2L2tlcm5lbC9j
cHUvcmVzY3RybC9tb25pdG9yLmMpDQoNCnN0YXRpYyBpbnQgc25jX25vZGVzX3Blcl9sM19jYWNo
ZSA9IDE7DQoNClNldCBhbmQgdXNlIG9ubHkgaW4gdGhpcyAoYXJjaCBzcGVjaWZpYykgZmlsZS4N
Cg0KLVRvbnkNCg==
