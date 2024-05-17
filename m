Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA501FC8
	for <patches@lists.linux.dev>; Fri, 17 May 2024 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715969592; cv=fail; b=XGinSL2JpzqtdUeLG4T1rh+dy5fEx/pADBbG5mOptCDbtIrTKSjqUZdYlUlr4I0bPzGrVIgOsx4ffjuDxAK56yd4vpTnaDAAPT/53rRKq1/dBdf6X5jCeJosWFKLBT7Rkbh1EuzWGw+zqyQjv3JvMRzZPwVwEySVoCJCe0MmFyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715969592; c=relaxed/simple;
	bh=ne12P+JTrFSXm995/ggKmaxUP9KCkefmklRJCdxltgM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WiRUdzYndx46I0WqDinjVFXfMxOpJ/K3kbzM5bRwuT85GADAyJ9H4c9WvLVGvBgsMv8cu5AM7XAUgxHnE9xjyv86iasIY2sRhIrU/82Lp8XUrusKnGPxQnhO+vn69FG9hyvU6SIm0KLLUfYicJH6FyiCvwPE+PGVdAWoHbHXK9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kosv4hMG; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kosv4hMG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715969590; x=1747505590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ne12P+JTrFSXm995/ggKmaxUP9KCkefmklRJCdxltgM=;
  b=kosv4hMGmTFgXSVSs1ZeVJ9YGdLkvvJ/h9ePimxo1B24BZDm3KKyGHX3
   0a6bsRlocZ5Uc9I5E35h9sJHHFEKGk2R+/PU1BmcXz4+V51wHlvJFlFGm
   +2kTd7xVcotCO0FtUyCoejYvRlqnPD/9M5rIG61I2RTYQozlAqCesWT/M
   WjX/R2bmaDFQIqde3PYOqShmCKCg8j29mljCInlfeAo33cRkjHoRmELP0
   pX1hC9Pw3fwde9mgBJwNtua3DWdgBVZKA88fNl7ImUrNo3oN8SQn9Iojm
   moG4IQupPau0Z0hNFPqsjxmEO7D+byoQwCEU6/SMBJjHVUgCS6XC+W9jZ
   Q==;
X-CSE-ConnectionGUID: u+aSAQdbThOR0nYGfcjXgA==
X-CSE-MsgGUID: MaNjBUXPS6qVTcOcR/tECQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="12275545"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="12275545"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 11:13:10 -0700
X-CSE-ConnectionGUID: q4PMq/h4Qb67k8MSWubibQ==
X-CSE-MsgGUID: jM5jm3rkTzCq2g1ucvjgZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="31892435"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 11:13:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 11:13:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 11:13:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 11:13:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdAJxgfJV5mwWMF8chk2iX3aVO3k4l3dP7xAPKGHzmxNtXF8ejXr3jto5Owjp44AZhmusVKPjPeGDQI+YmXetZW2y6P6p6qpDP1IxVtP+Ia15DyXadc0W1PTVoQVtsgWsgIBFrgtUGubzwl6OJo10Xg4Pe9RtE6hh1+37zKTY1dVFVhqaO2izlYLA+ckYIxdblDv90JSDUdfrdRVhOsLR0GGB+c+rSVuJVf8Kv0GLajjiFw+0Z6LbsUaC7zt+qOArSQmLZE7nnror3Xqjlm1grRK6tNJPZXxqxLAdvKTbDd/wz8B30/13/BHftnTh0tuHja/vMSN5PBGkFYw8SxqIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ne12P+JTrFSXm995/ggKmaxUP9KCkefmklRJCdxltgM=;
 b=A2iMNrKSf4N2Js4sGeUkynhEB//z5rXGW0xoHsmPHWJR/RPBCrKxuDiChsezrxvICAgh3zCCo5VNraRYrAKwRQSD00u4Vxal+u9Q+lFy+4ULtfdVtskXcqEhnjVQdSdfUglTDoPEjjk1K3GS/0BPCiFVV1+tpJJCjZtG3LEE8lj5es4pQMekofsPUtPc165N+qEX5Ztg2bG4dN6GWtIGmMV3/f0bs+MRoUAn5GkqoYkmmFW760t5Vq58lD4DpPiPW1swBY0YEVl2j7YihZsQp/Yh9w6d1zhe+EC4t1tFPTG4llatFPSsbAEFgOAjNvP4S8VIGwzKQDc0Tpphp1cpKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW4PR11MB6909.namprd11.prod.outlook.com (2603:10b6:303:224::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Fri, 17 May
 2024 18:13:06 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 18:13:06 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
	<mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman
	<gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Topic: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Index: AQHaqH6zwUWGNcLDPEWX8DDSkF3v67GbsPyAgAAAdjCAAAPKAIAAA27w
Date: Fri, 17 May 2024 18:13:06 +0000
Message-ID: <SJ1PR11MB608353ACE099975A02532C6FFCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240517172134.7255-1-tony.luck@intel.com>
 <20240517173811.GFZkeWAzKjYtEMwe1e@fat_crate.local>
 <SJ1PR11MB608386716D1DA533791DE7A2FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20240517175324.GGZkeZlNgjGxwfumLu@fat_crate.local>
In-Reply-To: <20240517175324.GGZkeZlNgjGxwfumLu@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|MW4PR11MB6909:EE_
x-ms-office365-filtering-correlation-id: 162b3640-8710-457a-4091-08dc769d0039
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|7416005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?M2hTT3lVdGo2SmpvdFdPSGNtUEdzY25pVVBrUDN6dXdzaHVCQ3hUNE5WVkdi?=
 =?utf-8?B?OWp1OGJtMUgycnlNK3Rma2tpZ1hFN0NZUW92L2hicCtOb2d0N3FsQzhKRURL?=
 =?utf-8?B?ZEVrSTdydERaQm1qcGovd3hwTmVnUGE2Yy9admtMZzZWQ2QwZmlySlBkWjZB?=
 =?utf-8?B?M3h1YmNpQjNrYzdIZjREMGx0bWpncERhaUFsTXRCS1RHa2R4MHBuczhuRWpi?=
 =?utf-8?B?dk5HQzkrbWVPVjIvTm1LSllBNmJKS0NZU2VhRFZzWUdFQlRYUld6RkwzeDk5?=
 =?utf-8?B?bTMydUZrWVVhbWkzWW1wdWdjaFdhNlc1Z25xNDhFZGNkUHVRWlV4WXYxRUQy?=
 =?utf-8?B?YUJySlVVN0ExVFBwclByeExrZEREdFlBZVo1VmNIVlgxcG92OUp6QldnZitl?=
 =?utf-8?B?VkZXbFRjV1hOak5xejJVUEhkdVRCalZoUzI4Zzk0ZmdSajhlbDd3cHNFa0E3?=
 =?utf-8?B?WXV6WmlsQi9NcWNvR0k5L3pSK3ltZHlDYTNNSXNvd0Z1d1kyRnRJbCtjVnox?=
 =?utf-8?B?L3hqc1VFemd4ZisrSnBabi8ydTBBTDZBTWlySUNvVnlpMDZ1RVBJUWNCNDl0?=
 =?utf-8?B?UXBnbzZQRGI5VkRLRElJNlVMT3dDajVpME82Y29VTlFXTnllTUwxVmxFa1Q3?=
 =?utf-8?B?ck9EN2VNR01yb1htQ0gyOTA5N2phU2lGYU9hK1hZb081SWQ3VlgzNXROc0Jp?=
 =?utf-8?B?dDVqN29acUxma0RTY2RjbjBNL2FLN3c5MDgvNGFWUlhqYlhRdC92dGprNmt1?=
 =?utf-8?B?Ym9SbG5LS3ZkNWdGTzI5RTZRS01neERTUUZvc2FBN1FFNDBpZ1VCMDhMMkxt?=
 =?utf-8?B?eDA2T3ZJeGpoclN4T01QRjZhSmZtVjVRUlBuT3h6Smh0U21vZjhQQndBZUtE?=
 =?utf-8?B?VkpiUDRYRitWdlFDMWtJQXZNc0tMVkNtYVAwQnM5SmVhZitJait0SVJUczJu?=
 =?utf-8?B?RVFHRWZmK2N1LzA2UmZ2dHdvRVhjYUl4Z2E2NURWQVRHNndDaDNFWXdKcU9P?=
 =?utf-8?B?UTNWQmNMQVlielZZWThvNEZpVVltRlpnYzVvZW1oSFBlcWxseUlnQitiQzgw?=
 =?utf-8?B?S3FlajNEYm1hZmNiMENEc3F3QWdhNTlsRUxTTktqUHcrT2RrSDJmOEJjUlpS?=
 =?utf-8?B?T2xhL0Y1cmIwUXd2aGFVelFJSGxsZEh4ZTRpWWF6MllKUHJsQTRwTjlmZE5a?=
 =?utf-8?B?c0FKSkRFc0p1aEFHK1ZNVnFHeVpSNjhvbTc1Q3h4Zm9mWHJVRGpLbE14WFVp?=
 =?utf-8?B?ZW1ZaGtwRFVnVlhVVTEwZ3k4UzdLeWswOVJNeEhVZWF2NkNBQzZrR3A0MU1Y?=
 =?utf-8?B?VlpKd1pkbG5CUmFrbjRQNDFrNDRMc1hJK0pRbUpWZHhHcmVmdktXYzNoTnE4?=
 =?utf-8?B?bXcvazhnN21TemF5L3VTWEs5SWxvcGZMdmVEeHdTdDZ6YlcxYjZESFZVSlZI?=
 =?utf-8?B?bDljRnd3dXNGSytLaFlXek9ycThtTTA4S0F3ZnNtNjZMNXRYRjAyNlVISXlZ?=
 =?utf-8?B?b05KVHhtdS92eGFzSUptRU9oQ2Y4TDRkWFM4aWsxNEhnVzVudzA5UFdWQ3FF?=
 =?utf-8?B?eDBmMWlGL1JKTXNIeUJ1SHJCQ1F3dlZkUmNPNkNIbXA1aXNxdi9wYjV0cS91?=
 =?utf-8?B?YmQvaDFaN2NmY3RFWW5DTENJSWY5eUdoVHArSTduL2RUbTBlZlNxM3dRYm9z?=
 =?utf-8?B?TjZ1MUxhS2xxL2dVeVhtMmpsSHE2UHcyZSttMUpPYktQUjZkelZ0cEY1eUhm?=
 =?utf-8?B?QlhqUFNQUzVkcHRjbDBiZmZQRC9PcDQ3RkFXdkdQUVZkZHYxS2szbENuVXVj?=
 =?utf-8?B?UWNmZGpWcFNIQWhvMzl5Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVVxZytyL3Zkd05nMjQxTnAwQWQ0QnMvK2JOUFhkbzlZN280ajFZTEV0Z3pV?=
 =?utf-8?B?My92am40NTN2MUh4ZVY4VW9nVksvcHRNSFpyaS9zVElSVE15Z2xqWkE1TWJn?=
 =?utf-8?B?VkFhNkp3aGd4MlF2bDVkdlV2RnNKK2hlT1RUZzhFYS9jNjlDY205YmNoN2hV?=
 =?utf-8?B?WWV3SzVYY2hVeU8yK0Q1QXAzQjh0RUpXVFNwYzJDVDI0bEVBc3lFR3U3SE5i?=
 =?utf-8?B?dUNnVlFHR3BkSENjSUlMZXpZSVJJOTRpMWwyaUdPeDBDdnRtOXZrVmhSdGRy?=
 =?utf-8?B?Q1ArTldUWXZ6S0lHQi9DWFduOS94ckdzNmljV3ZXRUU4SUlmcks2MFVSMVJH?=
 =?utf-8?B?S0w0ZnUzaTFwN3g1RE1LVmJTc3plTmlNQ1ozeHF3TGRtQ0VMUG02aWVDNXpa?=
 =?utf-8?B?YTJCUGUxU2FYRVd2U1hHY0I0V2JIMHBsNEZ3MjY3UFBTdE90K3N1UjhrcGVl?=
 =?utf-8?B?NkpvU2hrWGVrbjkzeXlicE9JbmxxbmJ4RVJRdXpWczVTelpSMk9ybUE4R05v?=
 =?utf-8?B?OGVXc1FDMnJ6bGN4bDNIb2F4QXlGNWRmcjhzU1BQRklWL2VnUnhyUktRd0t4?=
 =?utf-8?B?dWFNa2p1NmJDakRvazErUUtvMlNkVTFsbm53bGNXbWptM2Q1czBzSFRGTkZT?=
 =?utf-8?B?cWxXK09oZzZYRk9FVU94TExCWjZsYjFEKzRmRG00SmE5em9TNGgvWHBLUit0?=
 =?utf-8?B?NVFRakZPUnJnUmJ0VENtUEd0enpDakFjczRWTlZGZzdYd1ZZV0JwY0tMZ0Fo?=
 =?utf-8?B?TU5zT1N1YzkwbzM5Y2VxOHlIN1YwK0JtMWF1K1R2Qy9PYXVoNS9jb3VoeERO?=
 =?utf-8?B?YkhNWUhFcDg1aE0ydk1tckd2TFk2cU5MVVNmWXBVdmpjQis4cTZWTUtydVRj?=
 =?utf-8?B?ck1vVEE2Q2tETzJiLzNUaEpKdUFyWlA1MjdUOC9DK00rTnMxaDBjQzNNaVo1?=
 =?utf-8?B?NERoRGkreDVWbUJYNjM3MzZIMkV2V1oxL0JEWHJWcDFraTRUTW94dTlZaysx?=
 =?utf-8?B?MDhaSHZ3L3cyQmtEbWwyZVo0enlqR1hiM2dDWTEraHBLbGxMZDlWN1BWMzFY?=
 =?utf-8?B?TDJiL3RCVXVnd1ZuUEdrNHcrRllDTFIxTS9SdlA5czNYYXhRclBqSUhQV05v?=
 =?utf-8?B?cGt1dG5CTFc2VTUyaUNpKzJEYnFvTWlxd3duVXR6QzFPU1lPeHp0TUR4bWsr?=
 =?utf-8?B?TTdLcUpRVklmbjBhM3pPelA3RHRybk0yRkw3MVpLN2cwT2ticXNuMDkvcUtK?=
 =?utf-8?B?ak5SRDhXem9TVCtrTzVEdlkxQWJQcHdsRlVvYlN6aFB0dzZEMzBxT1FOdmNm?=
 =?utf-8?B?TXh4Z3NVVDk0NkwzeG1KQm9USmJpbFRzVWU4NUJucHpldC9BU2dVSGhzUERn?=
 =?utf-8?B?VDk5R283RnFKYy9VR2hFUy9JRDBHQ1pIZDk5clZ4SFpuMDY3d0o5TkhOQUk4?=
 =?utf-8?B?aEczUFpkaVcxbCtkWDd2eG5jL0NsTldML1JwYytXUVl6ZzZvblBTSUFmOVRZ?=
 =?utf-8?B?L0p1bThJMy9ZOTJQRzA0M25HWklWNWluY29UUUthcW9Uazh0U3FlU0d6eUpJ?=
 =?utf-8?B?dGdaWWpOcWE5eFFURWdaVCtNbFpLUnl4UTRWV0FYemlOUGV3aGtmQkk3cmNQ?=
 =?utf-8?B?UmdaWXRub1FZUjhsRUg3SVNQN3NRa0J5MXJxdkMvaFNMRVJqNDIrT1lPTE1r?=
 =?utf-8?B?VWxTTDYxSmhDb3BOT2tsa3ZqclY3LyszNGI1Nnpqazd5OU4xNW9QSWhHQUcv?=
 =?utf-8?B?bzgwYk9LK2dVMGFvQTlPRUZoUklQM2lmVDVJZ2xpdk0xa05Kb3FkN3F5RzRM?=
 =?utf-8?B?d2JRK3ZISG8vY2hjQ1ZMaXR6eCtreVNZQUhtQm5aSkk1UlN2NDlvazlyZDdE?=
 =?utf-8?B?VGJTMWlwYTNLRHRudGFCN3BCS3pCMk1mbmVCaWNkaC81ZVl3c1JpUVJnSGk4?=
 =?utf-8?B?cFh6Y055a1VNTjVoM01tZUpIQlJIN1RGOXZxZFFKYTAzOUF6OVl4cXNnaER2?=
 =?utf-8?B?R29tWHRBaGRYTUV1bXN3UmhyaGthRFJRc0ZxaWdERWFQVmhST3lLbUxORTdh?=
 =?utf-8?B?YVZMY01LOEsrTXBRRVFPK0R2MnNRUVZBWEt3bXNsQnZSeCtEdWxKR0Z5RDFu?=
 =?utf-8?Q?wbCsFASWIH8zO7wOtkzc+KRc4?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 162b3640-8710-457a-4091-08dc769d0039
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 18:13:06.4962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IZeFGcmJfEAOiLBo4dSRtkDUGpYlJFVzsmjlwX0qdWGhum1vF1lUBcvo3sgyFIIJ5tZ1Tp0ykjxxnrAZR1f7Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6909
X-OriginatorOrg: intel.com

Pj4gCWZvciAobSA9IG1hdGNoOyBtLT5mbGFncyAmIFg4Nl9DUFVfSURfRkxBR19FTlRSWV9WQUxJ
RDsgbSsrKSB7DQo+DQo+IFllYWgsIG1ha2VzIHNlbnNlIGF0IGEgZmlyc3QgZ2xhbmNlLg0KPg0K
PiBUaGlzJ2xsIGtlZXAgdGhlIHRlcm1pbmF0b3JzICJ7fSIgdW5jaGFuZ2VkIHNvIHRoYXQgd2Ug
ZG9uJ3QgaGF2ZSB0bw0KPiB0b3VjaCBhbGwgdGhvc2UgZ2F6aWxsaW9uIHBsYWNlcyBhbmQgaXQn
bGwgZXhwbGljaXRseSBzdGF0ZSB0aGF0IGFuDQo+IGVudHJ5IGlzIHZhbGlkIG9yIG5vdC4NCg0K
PiBCdXQgdGhlIGRldmlsJ3MgaW4gdGhlIGRldGFpbCwgYXMgYWx3YXlzLi4uDQoNClllcy4gT25l
IGRldGFpbCBpcyB0aGF0IHRoZXJlIGFyZSBwbGFjZXMgbm90IHVzaW5nIHRoZSBYODZfTUFUQ0gg
bWFjcm9zLg0KDQpFLmcuIGluIGFyY2gveDg2L2NyeXB0by9hZXNuaS1pbnRlbF9nbHVlLmMgdGhl
cmUgaXM6DQoNCnN0YXRpYyBjb25zdCBzdHJ1Y3QgeDg2X2NwdV9pZCB6bW1fZXhjbHVzaW9uX2xp
c3RbXSA9IHsNCiAgICAgICAgeyAudmVuZG9yID0gWDg2X1ZFTkRPUl9JTlRFTCwgLmZhbWlseSA9
IDYsIC5tb2RlbCA9IElOVEVMX0ZBTTZfU0tZTEFLRV9YIH0sDQoJLi4uDQp9Ow0KDQpUaGlzIG9u
ZSAoYW5kIGxpa2VseSBtb3N0L2FsbCBvdGhlcnMpIHdpbGwgYmUgZml4ZWQgYnkgdGhlIHJlbWFp
bmluZyBwYXRjaGVzIGluIG15IG5ldyBmYW1pbGllc1sxXSBzZXJpZXMuDQoNCkJ1dCBJJ2xsIG5l
ZWQgdG8gYXVkaXQgdG8gY2hlY2sgdGhhdCBJIGdvdCB0aGVtIGFsbCBiZWZvcmUgY2hhbmdpbmcg
eDg2X21hdGNoX2NwdSgpIHRvDQpvbmx5IGxvb2sgYXQgbS0+ZmxhZ3MuDQoNCi1Ub255DQoNClsx
XSBJJ2xsIHdvcmsgb24gcmViYXNpbmcgdGhlIHJlbWFpbmluZyBwYXRjaGVzIGluIHRoYXQgc2Vy
aWVzLiBJIHRoaW5rIGFsbCBidXQgYSBjb3VwbGUgb2YgdHJlZXMNCnRoYXQgaGF2ZSBjb25mbGlj
dGluZyBjaGFuZ2VzIGluIGxpbnV4LW5leHQgaGF2ZSBub3cgYmVlbiBwdWxsZWQgaW50byBtYWlu
bGluZS4NCg0KDQo=
