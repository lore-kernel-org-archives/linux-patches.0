Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0A7101C8
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715810880; cv=fail; b=aCHQRiynklffPgl8kUpvdsx1DVT6fTrAzR0i/r9kKuBQF3Oyc+VXrBkTFqzZRu5EPHf9I8piN7Rx06Wz502qgMK2BqxkWpUTKgnri61yhkfHvKeaPgkdGnnpZoFrkTD6bLN8samb2jGnxkKTdQqvZX+/2OwvuheY+9aMOKXbyTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715810880; c=relaxed/simple;
	bh=Wt8xSTjhHNK720mXFIhOl7vcy38uoDz8QTBIK+QVMsE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HQK37sNXAZ+SdmDtclOiu92R7bKADF2qIFXn2btk1CNJwFxePQ68WyOZr8jKCdmRftsF6sFB3ZmXsNTkLne6m+OHb0uQcFfdg1BrDHyNKBzUTNpkQ44qPlBdbqjIKKFlpev3COKMWEBfmeS7uQHsfpQw0t6arFOKzckbF82u1y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+QxfRpN; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+QxfRpN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715810879; x=1747346879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wt8xSTjhHNK720mXFIhOl7vcy38uoDz8QTBIK+QVMsE=;
  b=d+QxfRpNOAvmDcZ6nUw05kFEC52bkyc0yk1Alvx2XJG6Ke4sCkLgtqsG
   hTyMROd/WjsxK9xdsPhid5Oqc0kIabKB4wzBpDQ74KCk9o2hN1ea6ghQp
   KmeoxoqIxj+bZfkvv69jAR4VRLrscucohVt4lGaWfwEVbNsR6hBT6l1a9
   nOmhexQHUJD5eb5WogAGcrcwSh473svriCl26LNDv01IGubAvoXucRv+2
   UJAsapEPw3GxXliyqg7waOAsURU/cIA6Q368PG0S2B87cKadDghmr4FLs
   04HgHLO9OkJwib3p+MdDWOIcUlH//76YgoVoRjA8g4mjX2t3crJCeXVPI
   w==;
X-CSE-ConnectionGUID: d78udMLUTWiDX6OEB6bBqA==
X-CSE-MsgGUID: 3m8NNb2+S8mWOvyPsDzJ/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11837047"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11837047"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:07:59 -0700
X-CSE-ConnectionGUID: JuS4W7AWSW+fXBB3toxU4Q==
X-CSE-MsgGUID: 4Am65n8rSFa+mzDrWeZR+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35926668"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 15:07:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 15:07:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 15:07:58 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 15:07:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fk5e4Pm+9jFp/vHziMW3LnzDyusRPhs+AXFPcNuHmOa9nWVd5heqGP5B08pTA8vbKo2V4mUNjK6jhrS0hFuZe69Pb/f7e8JnAZDE+sHdDSWsoK51lhipZKOwzCrNVGr0sD8EZN5IMro2uHjCNK7iJN/g4+vKOPr3xwwzi+qfCWt2Ta8L+iwwyxWMaMFrsNVhNUN36KfTz49Q1osCqwj0biHzkrcncbJJIHBrpawT7989aT0M5PG5nj23R2/910viVPg/Gc978ZOu46Uwdc3RjVKLWO8GtTL7f8iJJYdwgPJ+61fzFBHBj6BXhNvn4U9pijsx28Ie/pPSX6yKrXDiVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wt8xSTjhHNK720mXFIhOl7vcy38uoDz8QTBIK+QVMsE=;
 b=RfgSbppqVV69MetP7zcNMB/fBthxhXXJqUEkAp9uBDYRG6bgV8oIy6hrLDMtxIj/9xi2pWi6wshJBhTIGkJlqQZQeoX8I9RGRPBSzFm/A+P7WhOGR1KKjg0wKlS6IahWCMLMVEi9YRkpr2OcXYsPslIAtD0d66tJYO36PLcft8ym7y1ovY5iP8DsLx7wZgOk0UsxFoFRSX9bYUvj788F85FsbtK6yDBQ5ekZHcTx/g1fIp//rLrBE9g/eKcgYoHR4uZqgE2iM8H4ml5n+HkGKboKpWSdLQO9EbLdHk3HAb3T4kxnGP3CXNeg+FVHEm6M+DhETF4MHN54YP3NGyUSXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CYYPR11MB8388.namprd11.prod.outlook.com (2603:10b6:930:c2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 22:07:56 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 22:07:56 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Topic: [PATCH] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Index: AQHapxEK4jkPis1WW0yjK7d+25yhhbGY2JkAgAABhjA=
Date: Wed, 15 May 2024 22:07:56 +0000
Message-ID: <SJ1PR11MB6083D455CE90AFC3251703B8FCEC2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240515214357.73798-1-tony.luck@intel.com>
 <20240515220058.GEZkUwmtNazjQaLdDn@fat_crate.local>
In-Reply-To: <20240515220058.GEZkUwmtNazjQaLdDn@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CYYPR11MB8388:EE_
x-ms-office365-filtering-correlation-id: 7b6d7387-7bd3-4d87-2d95-08dc752b7971
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Q3BYZjRLQjRCQ2hXRWV5N3QzdEV0dmc1YVRoa1NyajJYbFBGc2hkTG1adjcy?=
 =?utf-8?B?QWpsN0RkRGNTNWlQUDJrMnQ5MTkzajUxUGR1Nkc2SmhNcTgvVmpzWGtZalNF?=
 =?utf-8?B?ZEVPSDMrOCtGbURXYXBqSklwTU9na00ydERzdXZMNUJ2bXM1UXRMY1BnSlhB?=
 =?utf-8?B?S1dHZGpDakw0WGNlaGs0OEw1K1M1OGF2bFBGMVFNVm13cGIwb291TFJ5MG5D?=
 =?utf-8?B?S05xQnp4U1hhbjNVbFhYa0JBYVpQeFAybnJTZWtha2RqbVVLak1TamJqaEJQ?=
 =?utf-8?B?QXJHZzFWdUx6YnVkb3NXTG1EV2RqZ1ZiRlh1SEc1NUxSQ2dPT0tDNVQyc3l6?=
 =?utf-8?B?TkpWQ29rUVNSb3AvNVBhMWNsU3B3aDllTkhoWlVHZkxsaVRzUXhSWVYyRjBF?=
 =?utf-8?B?RHZqaTZqTnB3VjlHRFJqV01oSFluNW8yUFBINDFNL3VOL2c1b3ZxNUlaeG9V?=
 =?utf-8?B?ZEtPRFBXVmNKUENBOEQxcThjV3N5cnFZZ3BlL3dPbUw2T3BzU2djNVVnak5j?=
 =?utf-8?B?S2N2UDNBaWxUUC8vNFVSaFRXWU5BSk05YTNtZDBpc3pLVEY0eVIyNTJCQUZI?=
 =?utf-8?B?U3ZLMG1BRkg5VmNHVFYyOVVhay9aZ2o0djVmR0FYbFdLaXRhaFhSNHhtL3ZL?=
 =?utf-8?B?WTdOWTZOOU1HUUhOWGFkOTZWOVR6ZDk0ZnZvcmFnK2p0Sy9VNVptT0RBa1Aw?=
 =?utf-8?B?SDdCbStNdWJod0RmRHh0QmVISjJQWFdyUXV2cUVhS3FrWHEybHltNHJBK1Yv?=
 =?utf-8?B?VlFwc0xrYkFVdURnc1VUamw2c3JNTnNjclM3UjJOb3BnbmhTYkRQcXJwWXEy?=
 =?utf-8?B?MkJYUEZGU2R2Rm12dUVpUFpSOGZDSGpNb2twN2crcVc3K3dBM21CcllVenUy?=
 =?utf-8?B?SG50WkI5SEVWOUZCQ0hmcHJYcFQvcG1DWjFSZS9hcWlrM1YydG54OG9ZODV4?=
 =?utf-8?B?b050dUtPUngySk9CNXoyWjFJbDQ0MWlWN3JmdmlSaFdMT3cxRERGRDJaZGE3?=
 =?utf-8?B?NEhnV2JSZGl6ZkVydGVMdEdUR00wYkpmc1F4VnV5V2k2OGNvR2duUDRTMEl5?=
 =?utf-8?B?bFg4Ri90Z2dmdm9wSGhtbGpnZXYrTnYvLzZrWVBuYWVzTUFBM0NkUHZEMGJH?=
 =?utf-8?B?YjJWZTJ6aGRTSzA1ckgxdjJZQ1RHUE5oUzFkemNnOWZyQVFPa1JycVR1TXhH?=
 =?utf-8?B?aVpJUEtnN0JsTTlLc2EzOXJaT3lDamVDWnlvcHI0WnlGeVhsMWlnU2VNdGlC?=
 =?utf-8?B?MUFDUU1HS2Nld3pjbkQ1MWVXTmRpOFRkRFRLdmxEelhmcWsycUgwbC8zWGhG?=
 =?utf-8?B?aE9PeUxvVmswMzhwMW1vdjFmdzN3SWhJRmE2T2d3WkRYNi8xLzZtK0NiY1Vx?=
 =?utf-8?B?Nmh3d0VSb2EzSzh3QTNaNTZqa0dQUXQ2MTJEdG5zbXdaYkhTVk94a3N0bXN3?=
 =?utf-8?B?elU3R1J2TjJKYVZNVkhQSUV5ZVNYaU1iekU0N2M5RXZyekV0SjVFTTUvQnYw?=
 =?utf-8?B?UkIwdXlTT1VnNUQwSlMvYjd3RGFuUWdjWnQ5Z0QvdjVXUll3ay9qVXBKeksz?=
 =?utf-8?B?Q0lpYWI1VXdPRkdhL0haVkREZUFNRFhySFM1OFVjelZnL244Wk55a3ZEOW11?=
 =?utf-8?B?QzI0U2hQREdXQ3VnQWd6L0pQMVduQUVNVEFtcEJSZWFhTVcrYUU1R0h2UjBY?=
 =?utf-8?B?dnQxZDduT0pOSnVGV0NOakZ5NTA5MWxwdjNYcktPTmVJODUzcmNzVllIYUJv?=
 =?utf-8?B?cnY5Y3RkejlGMjRNNTAzQWJXbjVQSC94RXI3NHRTZDJjUnBqN2FNVTBQTUNG?=
 =?utf-8?B?RjZRdkM2UEhyc3Q2M1h1UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmFqU2ZRYllYeENuTFJNV2lZc1o2Ky9zNENjTXo2MDN6MFZBa08xcW94Mmdy?=
 =?utf-8?B?azMwTWtiUkQ5d1JqUnQvM3IyV0lacHFsZS9ITDREcWQzblQwemdBVjFiZ0dB?=
 =?utf-8?B?a3RSM0VObEFleGhsajBjWUY3ZWUvT3VuSktwMytYSktRN3dFZC80TEFCVHht?=
 =?utf-8?B?MC9HRzZwMGd1RmswdGF4OWRqUHFYMlVXUHFtV1JKb3ZFQmRsOXZNd3NrdE90?=
 =?utf-8?B?Y0dOQ1FGckJSWlJhSnJwbG90SDNDbW1NS0NpZHRvY2lwZEFFYnM0RytIVHcr?=
 =?utf-8?B?SkNhNEMvbDYwWWY0QVJGTEVTUzJyNGN4Y3JTZ1VaSks1QUUvU2dIeDJxdkpV?=
 =?utf-8?B?bE42MzZwVTN5N3k0a001WFV1TmJIelU0VGQxcFFwbit6dy8zV1hJSU5VZ2Fm?=
 =?utf-8?B?VHZvakc3djl6K3RwZHF4TzhpaUFOakl4OGFWczgxUVkwUEJhMkxIZWsyazdK?=
 =?utf-8?B?ejJER29UWkM1Z0FpRXJTMnR3VlpIc0U2eUtNWnUzQ2RhczNGTE44WnJuTE82?=
 =?utf-8?B?WHJSVHA3UkJYKzVpQUNkWXJVYm0vZEwrb2lDeWVRL2pZU1NTUS9zZGNuWDFM?=
 =?utf-8?B?UEg0UEkrcFBmS1MvVFlFYVZac0U1dStaM09FdFNqNWI1SmZEZlBwYlB1TDhW?=
 =?utf-8?B?TE9HUWMyTUNERldkOThvam1Dc3BPREVka2xNb1pOUXRlSE9pRFZXR09mbHRz?=
 =?utf-8?B?S2FRNkNLV3VsOWRyOEFraGRHeXg0K3N2SFFTUHdOdjZQNWoxbVU5Y3VVVjVK?=
 =?utf-8?B?MGU3cmJ5Ym0zbTlsVkx4dkxlUTJCTmNzVjU2TlpuaGVReXoxUW9VVEtmNTZo?=
 =?utf-8?B?RlEzVS8yUTZaRnRFQzJRaldhaThNMDl5aFlweWdGOWxkcDNYTHA2L3puYU4y?=
 =?utf-8?B?SXJ3YVp0dTAvUUZxZUFtYWZzUTJrTmRHYkJRYUg5aDQ3MTRRcnl0OUZFdThS?=
 =?utf-8?B?OGRaRm1tLzlXTGZlUVlrUmxmdGU5dGhWSDh4VG5SQ241cElvTExRTXZUV09R?=
 =?utf-8?B?SzVnYXNEeHpkQVFsZS9jUjRQTGZrdWw3ZE5pYUxvZk9ycVdmN21ZTHhFdnRW?=
 =?utf-8?B?STMxSVpwdXloNHByZHpGcUJnWmR1RTBLWWRCVXhHMTIwQzNTZjFEaW1taXJw?=
 =?utf-8?B?WUtpWEJZd1luNGtYZlNyQUxYd2MrRDZhQ09aRWlLWmhMWDdSNUNhL0FacDJm?=
 =?utf-8?B?SWtIR2tHdWs2UXNsbFFIOXlKTXE5UnJjbnRJQkp1QVFFYjVlYkJWSWdJY2Uw?=
 =?utf-8?B?WjdUWlRpWjkwU0F2dWNVOWhEam5tcjBpem1BWmg4QVVPTmtZZjIybytUOGlr?=
 =?utf-8?B?Z3lzV2pQbzdPZjhrenl6VEkvby9XbGY2M0g0ZEVMMDBBay9adGVOQVBLbVlW?=
 =?utf-8?B?dTRuWktVekN2VUVKTWlLZmNwZDJpOVhxdXkydkcrNGgxODQzU2hsWUVIQjBR?=
 =?utf-8?B?bG9JVHg5RCtKNFU0S3FqWjVDY2x3MjBZREZjNTdVMW85UjFhdDFwZ1VvNVFM?=
 =?utf-8?B?M214QkJXL2pFWFJ2MjFYZkVyajB1N1NkSFpEVTNmZU1OQko5VFp5ZFl3cTRX?=
 =?utf-8?B?VHRGZVVFU25BcWh4Z1B5UThEWHBIajkwdm1CUmcwakZCd2s0NHZZcituL29Q?=
 =?utf-8?B?WFBQR3MzSG1tdHJvZ01wTTVOUG5FRS9PK1lYZ1QvVzhadldGNHJZSGx2SVd0?=
 =?utf-8?B?MVhiT1g1bzdXTTFhSTYzZHJKTk0xTkxUc1dRbDQrWjBqaDhrZU4yOGtYbUk1?=
 =?utf-8?B?UFhjUGFmT3ZQVmZ2WVZXZ2hmVDgybFZEcjBEWWlPQzJ5Z3Z3S3lGNlorOFpl?=
 =?utf-8?B?ODB3NHJ6L1dWQTdvdlU2aXFYNWpkcDRXRkkvaytuWmNFN3ZpVy9OUVBEZUFz?=
 =?utf-8?B?KzZ2WmhjVFpOSGRmVjFuSXdPZ1ptd1N3ZTg0VVhNamxYN25DL2lHTFFBV0Nk?=
 =?utf-8?B?b2dPNnBRQ0NpVlFzaWM2b2tabW1RU1FxVDAwNWs5Z2d3QlczY25HLzZIeTR3?=
 =?utf-8?B?cDFkNlZlcGJTeFFtV08zR3BtZHdZM29wNUJBaXNjbHZxWFJSY05OWHJtRE40?=
 =?utf-8?B?MFRzWGd6ZCtHL3hZeXlhMVBLRS9iSmppTEF1STU4SXI5UDAyMzEwT3BwT3pW?=
 =?utf-8?Q?mdY85XjlgsZScwKzM4jEuVyOD?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6d7387-7bd3-4d87-2d95-08dc752b7971
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 22:07:56.1205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7lVB7AGLi1D6RKBDf2GSKp5rOU+cvAb9Rgf91r+oTp+0zycoZpWw8RHntzS50DasFnGEF5jjuefZv/LcCgS8QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8388
X-OriginatorOrg: intel.com

Pj4gVGhlcmUncyBhIHdpbGRjYXJkIG1hdGNoIGluIGFyY2gveDg2L2tlcm5lbC9zbXBib290LmMg
dGhhdCB3YW50cw0KPj4gdG8gaGl0IG9uIGFueSBDUFUgbWFkZSBieSBJbnRlbC4gVGhlIG1hdGNo
IHVzZWQgdG8gd29yayBiZWNhdXNlDQo+DQo+IGludGVsX2NvZF9jcHVbXSBvciB3aGljaCBvbmU/
DQo+DQo+IFBsZWFzZSBiZSBtb3JlIHNwZWNpZmljLg0KDQppbnRlbF9jb2RfY3B1W10gaXMgdGhl
IG9ubHkgb25lIGluIGFyY2gveDg2L2tlcm5lbC9zbXBib290LmMNCg0KLVRvbnkNCg0K
