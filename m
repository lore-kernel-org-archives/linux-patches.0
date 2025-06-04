Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EDB231828
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007663; cv=fail; b=MOfjrLnH0CMIQaoYqZ820QwX4C8XymQwWu+wI2sZe3GLhhDwX1eiUIYpD7Yi/SH5cMZG5G5PlZcO/sQWq2tJtEAtdhqbaUBBn5PxLRfrgefpV1fS5zTXxQ3qmXWoZYnNLawKL42jucnkJmHQRo53RuhNILn+TBsIIkmCUvIWbWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007663; c=relaxed/simple;
	bh=WAY+igmPzRBeop+T6z+36Z+6kgD5/z1e2v7vPQJYtV8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AXn3vyfDVwcLzYpXEMtUJsLPULALkA4S+rXeQLm2V/racEbWWdAZaRqdpx4BqVYKTZcHBQAfXmo+jwXKWoQRMdV6+QAvT5RXeZ+lN7TZYSic3FG8lI8pICs185WH4uVLpC1vicz0AWeNLiAYY3taTbCCFgGzH7dEldROcVyTBKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fpCmReRC; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fpCmReRC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749007662; x=1780543662;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WAY+igmPzRBeop+T6z+36Z+6kgD5/z1e2v7vPQJYtV8=;
  b=fpCmReRC2QfizJ6kBrc2jTKpcxeWTdvfleJRfAJgCvhXCxKmSla30k6n
   sIy+0AQdxT+C/LxemJs19RaQOy1p8OrqwBEFuIcpSl7+TuZDwL+diVBCG
   gYso33Wh89FNz7qY0UntK3Ne89dcIIwG83CyLL4ZlZdvF8sIqSAZsnD3C
   gjtyGTVZHDAxYzvAQaG/q9f8VW3wxlUPOUXtm04YJZBP4VQhTXUfHBiD7
   2lMVaqIvQtqMtt/p+iqcf+vFtpcgKYsaavERL5eD4iBZ2X9UAkaC2COCJ
   dVbNWhfHf5fMcaR/LuM/YSDCcI414c4yYQEjNsqyHSp1IHdGIEn+tcA+X
   A==;
X-CSE-ConnectionGUID: BEblmTIQQlW6vRgGnsdjFw==
X-CSE-MsgGUID: HFa5Y9A1TuO/PXPI//K6BQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50985182"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="50985182"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:27:42 -0700
X-CSE-ConnectionGUID: tDoJ3iX9R7Ss9AV5KEm8Cw==
X-CSE-MsgGUID: iNfE7N5fQy2tVplnqn7KLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="145660197"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:27:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:27:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:27:41 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.71) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:27:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=izDQwa3hyVEUHEosrz/Z5eBhKd8P+UPJ16R3aUA79B2SjWhz6+DwKWWayo8P/wBYlBNyc5d8SsFakSlDkZ0LU7o/go3R0mcCBszPyncp4RyU3fj+7Ap0gxnpqZnJs2hc2TtdQqT6ogPOY4ie0+7e5dQR0bNZuHMDyqfkLVkb30/vGUCdbyglBE92SYTBTZ4hHpJPduGq0pxNIPHTRgezRmVjT9X8oOG5cWhPkownkhclskc8Zi6uGopCdzuE7symA/Mzy3yM1kCeqvGH6IwtOT0JSE+K8+JrWs/gOXFbl8Z846E0p48Arhq02ZOh15fEnj/xXxcx/lefki3F5s4rWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECln6mlJkE5NleXHngE5p8ykJALA4+an/LUozR/Cq3w=;
 b=o+QYa1tQ8d6qDCMl+42JEaZOkzc+CxCPQDGB+jkQL+5qivJpywaP2bpC1ULiKRaEMVJ8X4JcS50QEXsBn+YZYsKUuYE9Js/cHHfwa6tsvp7Fg3IVRYWret2G+6TruXxSalYLeygMkfTHlNqq5v3ozh8h5Pv7E88ALFkzGqYHNDD0MuyGa0/VwIeRPC4fgqtAnMDbJ+eWeFG8fzyrXaJ8TCcfVBvuwqwyPhOMFc5FmoPWQcujr0l8gEqVhMmrdhiIW4KR6T3Hb4JKx0wJZ7URy6IzoyppUiuiaF+TzJEO0pxA6n3ZHliL0BVwl9f8MfC02WE0EhfXociIDkcI2Upm5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 03:27:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:27:25 +0000
Message-ID: <fde3cab1-032f-4c6d-aaa2-e684ede63194@intel.com>
Date: Tue, 3 Jun 2025 20:27:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/29] x86/resctrl: Remove 'rdt_mon_features' global
 variable
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250521225049.132551-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0116.namprd05.prod.outlook.com
 (2603:10b6:a03:334::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: 130dd2f4-14c1-4926-99fb-08dda317b9c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VE1FYkVMZThWSy9uTjdKdFA1c2tUckl2aDc0MHN5Mk1EYzlhNFgvRzE4L1lU?=
 =?utf-8?B?dExPV0diQzd1S0FSTFc3aUVSckh5RkIyeXZaQ21lUUNrUTEwQjlhTzRuZy9T?=
 =?utf-8?B?WDE0ejZqZHZjdTBHYVk3a0gzMW9yV256SmlZWnZrQnJETTVRZ09aY3JKTlls?=
 =?utf-8?B?d1B1bnY2RHVuV3RsK2JVS3c5Zk5xWCtkRUxxSnJqVlVTNDVOTytJMUtVNkxi?=
 =?utf-8?B?TVRjYTlRUUMvWmpVNUh1Ukd5dVBlMnJKRWowUEo3Z1kyQ3VyZy8zSmd2eUhD?=
 =?utf-8?B?OXhlMWlBNGMyc0orUDEyck9BeXZTdWRjclhSeXV0dnhSTkl6S212R3JCMDMy?=
 =?utf-8?B?VFpLejVsWDJCZmZmYzI1U3c3SHdBTHpYNmFSTlhhTDBpME1jRTB3ZmY4cFF0?=
 =?utf-8?B?SjUvTXZ2bXRTWGtjWEtnYXh6MlhsVFEwRFgxQkRlelZzdnpyS0F3NGg0dXlN?=
 =?utf-8?B?TGFzeXI2aG1UdlhmemVJNVFYcEJ0ZTF6TTR5ZGUwVmRzNUVmb0pzd3VLTjB0?=
 =?utf-8?B?Z3lVbmxUS0F3OTc0SzJzWkh2bExLNHN6ZXlhOWtjYTV0ZnIrMjVmdmNLelU0?=
 =?utf-8?B?S1pSUTNXTXpoa2RtS0owRWpNN3hJNmZ1UjlRakk2VG9VcmFlSnJzbnp0dmNN?=
 =?utf-8?B?RjY0ZitGaVZlOU9wUU56aVpwbTV6a2xnRlkrYUppL0dkNlYwZEtVOU1vc0s1?=
 =?utf-8?B?Q29MTWFNYmkzN2pxWmNCODdESGQrTlEyRTRBN3VBL09ydkdEM29KZTlzOTFx?=
 =?utf-8?B?TW91eTJiL1RMbGtvazJQTUVGaDNpS3I5cFhCamZxVnh5NG1mUWtYQ0Y5TEdR?=
 =?utf-8?B?MlNMck4zbWZUK0g3cUE0UDB1SkZyanY2VXR5Q3o2d1d6amVZc1ZLV010cjUx?=
 =?utf-8?B?bGpwdExmRnNRYTRQbWNpekhsemtlakR1YXRIc0Z5YTFOOU9DeHlpMGxSeGQw?=
 =?utf-8?B?djhrTUVXRCswbmNRYi92dzRRRmpjdVI2NVk1YjBUQllZZExjTzJaRmRmWGE3?=
 =?utf-8?B?ckt1UEZNc1FxT0Z3dXdIazJTV3hsNTFMam9EQUErUk5SUDJFTkxxR2F4RnZt?=
 =?utf-8?B?blQ5S005NCsrcFo0TFVCaUpuVXFVeWEydTRJWkEvS0NlSldnaHNHaXpXYUNz?=
 =?utf-8?B?SDFJVktlZGwwOHlwdllubEpPTXZGb2JUR1JzUk4vUVptMXY0R29SYjVRd3ND?=
 =?utf-8?B?b2x2S0o5YnJqMExGSnRLUDI5ekdOMXBvb3d4d0E0ckZWZkFLVDZTNlZJQnRi?=
 =?utf-8?B?VGQwQldEbW5wU2hyVEdCMmhWYWNyeGdNWW5mMWFEUEh3S3BHUUk5MW9rMUQr?=
 =?utf-8?B?eGROZktIbDdWLzhkK0RTdG1ZYWdOTDlHRW9ONW42bFZxc2Y4ejZZaVV6aHFV?=
 =?utf-8?B?WUl4WnZIT1ZkRjkyZ1BEUXorUENBeSt5Ymx6WVlQTUxVUEFKTXhkMEtwT2kw?=
 =?utf-8?B?SnZNbWZUelM2S0VTeDVQUE5yNDU0MDUvaFVtT3Iwdm9GMVhKb0l5akFkY3Ey?=
 =?utf-8?B?NHFFZzlxRVdwVkRuN0w2dWVoV0RkTjV1UDZ5eWxtc0RaSzVZellNdU55QUlj?=
 =?utf-8?B?cWc5eXV2cTBLTnhSaHFndkVyLytHZ0RjTmhMTElqSnVRWFZQLzNMWVZ3N1RQ?=
 =?utf-8?B?VlBaNythNTlUZUFhWGVuQXNBL29PcEZTQVZhQU1MNCsrQi9Ib0U5UmZYa3gy?=
 =?utf-8?B?cUNmMGhlWm1MTTZuQXlOQVBKYVlkREhPb3MxRlg5a2ZreEdOYkFya0htMS9k?=
 =?utf-8?B?VHZpQXRPMlFxdFhjNWZ4ak40Sm5Lb1JtdVp4V3JwWWpWeUVxZTFoc2lzUkdB?=
 =?utf-8?B?Ni9tZm5jdXREajFsZG1KTXhKWW42VXh4NUNBK2FJMmJQSExaTGlzamQrTjAv?=
 =?utf-8?B?b2pZcWxHdUJVWVcvZUFBeUtwMGdQeDZvcUVQS0JxNzJ2VUhFaFhkTGJMbSts?=
 =?utf-8?B?ZXBJSXI2b2VDdUE0TWdFeUxpeXNvc2xvQVhJZkkzR2F1MDIrUlhXOThnREUw?=
 =?utf-8?B?WkZmVnhya2J3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SER3ZlUyWE82aVBXUlpBK0kwbHdBWUxZcGZxbkx1NTBQOTR0aDAwaWpxVG0z?=
 =?utf-8?B?eFhPQTdxajYvV2pQQU5qWk40KzIxWXByTkFicXhaMU1aZWZudmJneTVRSUJ3?=
 =?utf-8?B?aHRxdVVEZm9Zb2NjQ25SSFhhaklTL3ViRzBIcGhrL0ZjR2ZkMzhONnA2bUR0?=
 =?utf-8?B?VE90NTFOakp3MFNjdXNNaTVoQXNJUzl6ZFNXNTI5Sm9RMEp4NG95dm02eTZm?=
 =?utf-8?B?a2xTdkZKSEhVQk5DQVBUOVcxQVRsdlpFWGhWMytOeTYxeUFSZFRmYVBIOFZZ?=
 =?utf-8?B?UExpcGFVWm1saUJCYkFuWTZTK05wRmE2RUJjZGEwMVNDSktyWUw3aFY3QlVz?=
 =?utf-8?B?UUljdU8veVFFR3JCSW95OFVkeDdEb3JNMmk2YmpJQ1I2NWg0QmhQSTV6cmFs?=
 =?utf-8?B?bmdZazRLSVh1US9pMWxzZDlIMmhacURUWC96SEdoeFNRTkZUY3NxK1pVaFly?=
 =?utf-8?B?V3RrQzI4RjF4V24wSnVmdzZtRkdoOEhBT0o1TFVpUVFZSjVWWk91UDhxbXVM?=
 =?utf-8?B?dkNweHpBZHhvMWdmZzUwMEs4bmVsb3BjVTd1U3ZHZlRPVjF3dTlLVW9jWkRx?=
 =?utf-8?B?eS9lb3hkaG1OT01XZXJ6VEkyS1haNGZ2YmlZaVNLOHFaME1MeTljT2RGajlw?=
 =?utf-8?B?Ukt2R215c0syd2xEcFNsbFN6ZDhkL0Rmd3h6OC9OTVp6eXNFdFFNUHZ5T0pU?=
 =?utf-8?B?d1RpV0JwODN0dmY2OElDNnJYWEZBQllIdkNkdnRGV3pCdGNoSHEyai9zdWFO?=
 =?utf-8?B?b2l0MG9wdWQ4dnl2bFp5YzJ4S1RSUG1OWWt3M01HZjQ4b3ppamxhVUI0TG9S?=
 =?utf-8?B?L3lnZEJRMmVlend0ZWFwS3FBUzV3K1FiZk1kNWZINjJRUit3NXdZblpjaFQw?=
 =?utf-8?B?b2R3a1JxN3VSaXV1RXI5T3paMCsvcitabGZzSE9rZzBIaGRyaTNJcVRQSTBM?=
 =?utf-8?B?cHRXOXpaVStPYUdMYnFXeVh2T0VJTm1RbzNSVHRuV2NDNlhMZ1BodUNUNUNC?=
 =?utf-8?B?SElobmxsV1NrMk9yQ1RhRHhXeHB5OThXdmExLy9rM3pobVpQMXNDNXRPTUNR?=
 =?utf-8?B?Mys2RExsZVJlNTBCTFFJODFER29LblpVblZBT0tFNVV2ZEJycXdzRmx0elYx?=
 =?utf-8?B?YlMzajBHVzR1dFN1RkNucklIN25rYUxwcExlM1BhbDNmcmttZVIwczhlZndD?=
 =?utf-8?B?Qy8vSkJsazdJemFZY1l3Q2ZHeWxaZ1ZGRHZkMXFzcVFwcjhlaDVreHVNcDN1?=
 =?utf-8?B?Vm9seXc0SThZN29qcnR2dFV6THRFdFRhU0JZbUM1WGpjYTRKcDBIbnkzSmo0?=
 =?utf-8?B?amFiai8wOEU0TVJDbzdybHNOdEFRcGZoMHRYL2hpb3F6K3BkV3d1Yk41L3dZ?=
 =?utf-8?B?TWVRdUh2cDlNWFFHa1hWc29uVSs5cjArdXRLVHREZWkyczd5RWxqMXU3Y0dR?=
 =?utf-8?B?bE5BS1JFMjNCSEkvcExYRWJPcWFZRi9XbHdJUnhZbFZSRk5jSGx0M1Y1Tkx4?=
 =?utf-8?B?Y0lzWHRvdUpiYmRPWUwwdGlETnRjNFp3MThzUDJLMVhnaUxzVWc4c2V0Uitk?=
 =?utf-8?B?TGFkSXBzZXpoVmZHckRMWnNYMzg3Qm5CYlRXSTB3Ung1NGVKTjlzZm9JWUZB?=
 =?utf-8?B?cUQrV2wwRkIvdjJ0S1FPZ1ZDUTY0LytWTnZKc0lYQjYwYnFldWZiMHhxU0Fk?=
 =?utf-8?B?N2lndVV4V01ZK2lKN3IvYUV4eWRsS2VWeGcyak1mMjVoT3FWb29vWWpnV1JF?=
 =?utf-8?B?MUcvTEVKSnBodDlWdWd5cDMrTThJTEUyK3d2L3VPTFVaSXFGU2tCdklFQUsv?=
 =?utf-8?B?TEJiQ29yem43VlhLQzhaT2xYdHhuODRTV09EcU5jdmdDOHpxNUZZbW9KQS9k?=
 =?utf-8?B?b1pOZ3pZODQzeVEzWE5TVmFlZ2JBNy85TWIxemRqNDBaZkU4QkRhbUZ4bU8v?=
 =?utf-8?B?SG43YlEwY0ViMHdtYVZBaUQrWjVKb3VBenhub0htWTdFLzJ6ZXVJdmlZNnNn?=
 =?utf-8?B?QmpBTytWVTVWYzE5YVhQSG5JSFpkZzNBNGRxKzJrY0E4bVJWSTVxUk5KNm1W?=
 =?utf-8?B?V0FSMDdUZVNSQVkwRE54OCtsTTBYSG5US1lFZkp2Sk43eVRIV3NCQ05ZQ0Vo?=
 =?utf-8?B?MGw1b3c5M3ljT0dtZEhjb2xQN2V6Q2kyalQvOHc0dnQvR0hlaDBBeUhhYjFX?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 130dd2f4-14c1-4926-99fb-08dda317b9c4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:27:25.4189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IcKS5bscF0/2be5ELugmH55rclyGCoSizcZhM4TFx9NS4WPzg54oanHey5zIjOqZkoPxIemruo6sevIS0b0NCIVmTfq1+45NFAy4hOBIJUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> This variable was used as a bitmask of enabled monitor events. But
> that function is now provided by the filesystem mon_event_all[] array.
> 
> Remove the remaining uses of this variable.

I do not see any reason why this changelog needs to be so obfuscated. Why go
through effort of referring to rdt_mon_features as "this variable" throughout
changelog when it could just be called by name? Same with "that function".
Compare with:

	rdt_mon_features is used as a bitmask of enabled monitor events. A monitor
	event's status is now maintained in mon_evt::enabled with all monitor
	events' mon_evt structures found in the filesystem's mon_event_all[] array.

	Remove the remaining uses of rdt_mon_features.

Patch looks good.

Reinette

