Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902B9279907
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208298; cv=fail; b=N45/gRmn+bT8cfTsEmz4fajQpknuI41kcprQNj1Xb/S8fJ2M9fVTYdBdX299G4hGJni95oPGkms+1dL3WFFqBHQpo3EdVfAZLVgNrR9J0ePinZccEmMurPBD61EraBR7a0YCT2IIdfQ/dQpFVUqTFpxx9na3eO+zcA2OTSzBck0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208298; c=relaxed/simple;
	bh=Zma79Ly3LG28NLL8v70ouHHTdqFFCczMABIzRoyG9fU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BuA1YKjZd0eKp0nyhDIIXQfVNo0v5piqjl8tUasgJySU7AlulXCaG+qGrmvJEaNbrNu0IMgiQ+tseQeWs8xOa/vREq3QOzwZzYABT1gRQwZhENInux08Kh9zoN4mbOINLOt4XQQMf/RqW6BTA8cytbX2vWYt0U8kwgp0r0fK20A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J9OL9edX; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J9OL9edX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208297; x=1786744297;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zma79Ly3LG28NLL8v70ouHHTdqFFCczMABIzRoyG9fU=;
  b=J9OL9edXt6bdA+0mjtij3Y1YoTGBRqQx2yvOYoZFRFYdNFohrROjg+oD
   CFIuBi3rgY+cnCq5OUMJhZyynni3sCetLe7GegW6Qm5UHGtkON/Q8NWAd
   hkygqSMjblzy4kpPz1C6NBz/6R8G7K36pNGLOk7oz2/YDKx2D4Y2wUvQv
   x9VdtAGvRom7THa7RrTRRPa19COHSTvWlkwORVcz4ZfNDVZdeSAIrh4XX
   bpbtlzh8zdGg8J39JSv/bl4PH3kEkDE/vXezbAWUHfYt0XJvy3PqqFhss
   8CjDcbywNDoPpaQGB4EnrML4pnkTcb+4wq1WlgIbjl1MtDLfx9piCXAA0
   w==;
X-CSE-ConnectionGUID: 63HTDS11Tj2TFJU06IklyQ==
X-CSE-MsgGUID: YVIWCSCrQm69gdkigW2aFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="61379102"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="61379102"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:51:37 -0700
X-CSE-ConnectionGUID: Ru/3tFOHSwq/me62KzCWgg==
X-CSE-MsgGUID: dIS2U9p1QsqYY9ZaZF6jVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="171110483"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:51:37 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:51:36 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:51:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.70)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:51:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlfJp37x0AxtETRsPTvesIeIKwPgvRscAZZW3HKzIB12KIVxYFmVNtKa7kdz98KIdi8oNcg1CNu/FvRVwECzyofBY23iMrwQHtwVly+Bgwy37ocA2Ox85MLE4SeW0XCj+L9JNYJosFv1aThU6Lwy0k8X8PJK6GY2l13zZqG54qirT0cWS/1TsY8h4vRC2GJLKEEX8I3A5ms70RHcKSuhIyxvhKzH+KYdfzEwrFUjUgA21nJIdbTSiG2QzOm/yRe/THmiaDpObB5vicc0S1tDtRRVtyCekaUGxItTHnDEzZuEoa3LjPSAJFJZ16BC4xC++ZRZf4ReHBD+Z9g90vKq2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+gZ/TTVeTJ9CdJzjLpiV5KPcUL1XyNgA2NjyspSCkA=;
 b=iOa+oP78BKZqAmokKKH6mdP7pLKSjlmniz9NT2hcSl+slfrWbhsS4ODOFghKIvbDeHNIiWjoD6IA58pA9OfVPaX88+yKl+zJeA8KESE7csx8W36zgSc+Ckx2MCNmuHzuDfgSo9LRSfwnle0gw5Rp2/5RGz8ZPIHeIhJGyYnnyP0Knohp3y5tCiTX/4RhxusNZ0yNS8NBkD49U8ia/pv5m7EEb2V5y+e8VXWBEmjimE0Q6dXBy+h4Q9v8ebcjKqywKJyXGqrLkYzPWusT4/wa4AHX0A3xD5MbxuAXg1CijTqrVkF3rmpECiJNHDXNHGO4Y8owT5S2RW+WUC8U/sNg1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF5A636EDE4.namprd11.prod.outlook.com (2603:10b6:518:1::d21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 21:51:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:51:34 +0000
Message-ID: <062ca116-7e0c-4d64-abf0-d1c73d23362b@intel.com>
Date: Thu, 14 Aug 2025 14:51:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 23/32] x86/resctrl: Handle domain creation/deletion for
 RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-24-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0009.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF5A636EDE4:EE_
X-MS-Office365-Filtering-Correlation-Id: ecb02ebc-3559-4212-cbb4-08dddb7cbc4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d3FNaEc4dzZuSU9zN2JPd0ZPQzJJU1QwQ3JlMVRDR29yc0YxdndOOGk1VEdj?=
 =?utf-8?B?OWVyMVJEdWE0cnVPNDdBc21FLzluaGVCRVpPOG9aQk9ZNm1nVG9ZYnpDbFlx?=
 =?utf-8?B?eitmNS9yQ1FjSUtNRDBLNnU5YVltZFRodWZ0WEpGVFVIUS9xOXc3eW9qYy9P?=
 =?utf-8?B?SlVDdUdXUUFoUm4yTTByZ2lBajRQam9oTUVaNHN1LzEzWFlRWm05bkVNTG00?=
 =?utf-8?B?ZGVXcVpyajdvd1M1UFZkTkJYTXNpUGhvMUdkVUJObmVQVEFUSTdPZjF6TnVU?=
 =?utf-8?B?RysxZG4wSVJNS0pPcDllVlVOOUFJN0oydU1RWVRwK09wODRpbGFPaUV4UTFV?=
 =?utf-8?B?SUlQQk9BVDlGQWozQ29DUElqYTBNS0t2VmpBMFFkQXUzbUJPeWNtK2pQUm5u?=
 =?utf-8?B?ZGI4d2lhT0ZPOWJVWm8zYlZ5bUtMc1BOekFrbU03S2xaNVpLdUwxTWFxN1NY?=
 =?utf-8?B?RlZtQUNyaFNsTlhieFVRZWY2dXk4U01lSGRBaTVSejFDdisyOThQQ1NucVR1?=
 =?utf-8?B?TWh4b1Y2cWNmekVQVkZiQ0RlY2NiQ0JkTTFQT2hFRE1KL1VMMWpuazFtZVlp?=
 =?utf-8?B?TEpacWlrakYxamtZb3UrNWtCRXU4Wm9Fc2MrZEpTSFdFbzI3WXBtY3UyT2d0?=
 =?utf-8?B?ZllwNWp1d3RySHg3QkdFNWR0LzRXdWxwVmwraHVVRHJjZjN3STArLzduQzls?=
 =?utf-8?B?QUNVU21wNmpxY3J4NkRMYnl5c1h1czhxcVhhTXIzT3ZLbWNuM0FiOUQrbE1w?=
 =?utf-8?B?UHZoWXBDNVYyWDRGL1kwQ3VVRWpIODhEcUcrbGRZV1lUaFB4djZZY21WcnRN?=
 =?utf-8?B?SFNTbGNuOFpVTHZTMkpHSGQ1Mi9JNy80eVRHNkQ2SmY5VWlqUjVEdG4velFq?=
 =?utf-8?B?MGJpYmRlKzR2c0gwbEhaSTJsRHcvWjFNY0dBL2QvaUxCYkVWa293L0xCRnFW?=
 =?utf-8?B?b04rKzc1Ynh6eW1BQWNJZDdFaHFwVldNM1hKT3NpQXVSeWJJK3RnSFcyd0h5?=
 =?utf-8?B?aHBRK20veklMVTRMY0F6UWM1ZzVoZmFFY0RiMjRtYjlraUtCZUhma2xhOWNY?=
 =?utf-8?B?VFNkZk91RmxGSFh1eUN2YklvTDZSZEhSb2hPV2NQUzA0RGNZUHB6bWdlcStl?=
 =?utf-8?B?Y2JKbVZkQVF6LzIzUVdwdnhBc3c0Zll4a0JlZjFyclNIU2EwaEdoVFdnaGhk?=
 =?utf-8?B?Qm5LUG9URzVvV3Q3ZlpmM3RrMXZLQ2UvNGVVS3lHbEwrdkR2R2xjeXRSSVRq?=
 =?utf-8?B?ZGI5M2JHcUFZL3hsc2NhcCs5WnhHQ0ZWM1VaMGhLdFdYZEdaa1FnWUgvL2E5?=
 =?utf-8?B?V3F5YWVxRCs0WUFFT2NvRjZJRHMwMzZ4eVZRazNnWnJHNEpkSlFQczFjbDBP?=
 =?utf-8?B?emFESzBZS0pIbWV6bWtYRy9vMmVLWTEzd3hubC9FWEFhRGUvenVmWUhOQ3JU?=
 =?utf-8?B?OWRMMDhaSTh0U1dkdkJhb2w5dW03T211U0pPb284R1dhYTlOT0UvQ1FrVVFa?=
 =?utf-8?B?QXJxMThQekVSckgwMHUvQlVPeXVMS3NSVjZ3NDVCd2FaMkRuVmJmcUNVVWxI?=
 =?utf-8?B?bllmYm9pYURlanFEWmIrMzRsZ0YxRkhPMFllQzc1bmEvcnZWL3JRYWRoL2NV?=
 =?utf-8?B?Wlo0b2kwcmJoeFJ3aStjMzQ3czZSNDJIb2ZuTUZFbnhseGloVDVVV1JBYUNz?=
 =?utf-8?B?aXJOU09zeGR6Vk9CYVJkUFR1Ujd1YlNUYW0vYy94QVVLbll5aGRHNUpTcWlU?=
 =?utf-8?B?ZTZNcEE2UDF5QlV5akFvN1YzSVVkRDcvTGwvSktLN2dQdnJNSFlGbHdHci9a?=
 =?utf-8?B?ZzRFT2Q2TjZTcGdoWkVBNWxmQzIwVStWL3gwVlhqOFRtVnEwVXIyVjdGVnBm?=
 =?utf-8?B?cVNEYlFIMmhuaTVEMkRuT3c0YXlsK0VNNlNKalUyQk5hRGJiVnF0NzJoSExV?=
 =?utf-8?Q?OUd1i7RZYYI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODN4cFhER3lJVlFIQzJ3UjBvMDFOYitMM2JxbmFLaXZUQzNxTWxUVFIrNG5Q?=
 =?utf-8?B?RHRDdUdyZHk2bHJLb2FmVGRlKzNDTmlEQzIyN1dMRWtnWVB6TlN4NVVJZnNu?=
 =?utf-8?B?T3ZvTW9LU0MxcG1zYzVOa2lzSGlmbXZQOVlGZGt5cEprY05JaGNQSWtKRGZD?=
 =?utf-8?B?VUpUdUUyaCttTVlaOVp4NWJjTThNa0I5TnlPRFBobHJFUG1sK3JqY1NqeTRx?=
 =?utf-8?B?OUVoc0VGb3FmeWlmYldiWFFDVDI2Z2lkRERKd0FCcXRyN1dDNTVHb292ajJP?=
 =?utf-8?B?VkVnQUFHYkxXQStYU3NMY2R1TWhVUTBuM1FBMTRwZmZhS0g3LzhJZGpYQlJL?=
 =?utf-8?B?OEhOeUo0NzN3TlhIMWVwdmk0MHJiYlNId00xbStGaklyeFlSdWpmYzQ5aUY3?=
 =?utf-8?B?aW1reVRjRHJPTGY4UlZiQmpsN3Q0QWMxaXZKcHg3K085RzIvdUJBUXcrSTVK?=
 =?utf-8?B?dE5YRWxKT2FlN1JBbFdnRDRiaU9xVlZKNXZVcSt3V3V5TzlaUTdscks5ZjNP?=
 =?utf-8?B?ckhoRXRKMnQ5QkZ3SGxNNG9JaFlCWks2SUh4bUpmV0ZDREZTcXZvUE0vNnFN?=
 =?utf-8?B?MU4zYVphL2RRL2hacnVYY3h3bGxMZzk5VGswWHlUWC90bTJOdE5ZUzNDbG5j?=
 =?utf-8?B?WEFHMktaS1VrUDE5Y04xNjRwOGlFV3Q5T25ETjk1ZmNrSWJWZzlmZlp3OG45?=
 =?utf-8?B?aUlTTTFPZDd3dm5lZVhkcWowdUdQVWtMYzEzSGRWSkhCSU9yRGNLb0VPTVhZ?=
 =?utf-8?B?dnRWd0IrcFh4MXV0TFBvTVRvVGlEMDZ3UDhjcGk5VGFJWkRVMFIvbXBpelQr?=
 =?utf-8?B?TW9nV0IrUEV3aFBNb3JLcFZ1UXZ2U3cvVWNKWGFvNytwbW90ai9jQlZVUFFn?=
 =?utf-8?B?eWUxRmtxaXhwZUJSckJaeWlSL2lNNmUvZlpLVnNuMTVYTkVjT3g0dGI5UzR6?=
 =?utf-8?B?RW9zMTJnL09lK1pCazA1dlB4SVJSNWFiQ09EbUJjR3RCenFTODFqMy9DOUFQ?=
 =?utf-8?B?SFR6endDRTRqRUdMeTRyZXZSdkw3cVVGTktnQjF3dE92NEVUalBlZjN1RUZl?=
 =?utf-8?B?REprZWNCVXZRb2RHM3NZaklaMmxkR2cvemJTWmpzbGxnTE5XdHhvYlBCRVMr?=
 =?utf-8?B?L0Zlb2dhcmtOZXNqM1YrUC8rL01RY3JUYVEvQk1VN3kxS3ZubksySDF1ZE54?=
 =?utf-8?B?SFIrU0NjQmRoYWlsamx4VzRMcE14a1dlcFRvU3hSb0poeHRLdGFBdndpTDVh?=
 =?utf-8?B?bElpMGluTmErTFllSlBPR1NnaWo5OUZaZENOMFc3b2NhbkxyR1JWQkYyY0E3?=
 =?utf-8?B?dHZXRlFOSmNsMjNGZGZtcU9iMFdGdTdiUElOZWxNUHVrRFlOMXJEWm9VUFhE?=
 =?utf-8?B?UzV1T2FtY1BmeUd3MkFDMUJSR1Yza2FTT3M3OHFBZjlYTDNSRERrVG9Fd3d3?=
 =?utf-8?B?WjkyYm9PY1h4bU9KakVzMWh4T3B1bFNXeXJVZGYrWExHdmo5NktUNHhQUFVH?=
 =?utf-8?B?WVhWUjhUUXRjWVJIYlo1KzVUV3lvVHV2NHFFNzhkYnp0SkhZV3JCQXJhSCtY?=
 =?utf-8?B?aXZNTFNYUHBRcC9RdkxOSmpVZk00Qy9kWUVhaFg5cVorcnBDNzdPTlA3TWN5?=
 =?utf-8?B?dU1uRE1qLzhDSlh5QnBDMnRlTHZFSkNIT2JnMkZvSGdXbXY5eGlBWFFRMEt1?=
 =?utf-8?B?RnUvbjhjQ1pSTEhGKzQ4VGYzZFBmOGJWWUtybHB3Z0tmQkNFeGNSdysvQjRY?=
 =?utf-8?B?MlpFUW4vaGZxbFk0S1UzVUlEa3BJU0wzbCtyY1pnbGhMWkxmWld3NnpLdE5R?=
 =?utf-8?B?dFV0QmxvWDcxQThtNTc2WDQ5QVNYalJEekMvOElsZm1Cdmd0Q3QrenVVeXFY?=
 =?utf-8?B?SmxkbWZSWDg4WTJHN2ZjVHVYdi83Wi81QzhNMno2bVlDRDFGMUhCTC9UNXVp?=
 =?utf-8?B?SDhzcWpmTUFlc3h5SEdjWTkzamllcVlaWlpaOU85Y2lIQlc1ZVBzNHJTSXVO?=
 =?utf-8?B?ejdRdkE1OE1WUzExRTFNSVJoRlJ6M3E0WEhNL0c0TlNkMnV3TU5lT2dyLzY4?=
 =?utf-8?B?Slg1aHRtZ1YvSHRSS2NZeThSbXRZSE5qdzQwSCtHQXlwYUxsNHBjSGZSdWx1?=
 =?utf-8?B?ZTdwbkVYL0ExNGRtQnMrWjc4dlA3UCsyOUJlcS9pRHBhVCtNVkxJaXp2M0RU?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb02ebc-3559-4212-cbb4-08dddb7cbc4d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:51:33.9855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnQK+wvfuLOBbjowxcVEQB5295f+arRdJP8u7qsucOuhLDyuISACBaKXFQZ8OWPANpvM7W9zFzEOVUeANaK3XfHWkHhMVzOVJMigKPYpsqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5A636EDE4
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> The L3 resource has several requirements for domains. There are structures

"There are structures" -> "There are per domain structures ..."?
(to help connect with new domain structure later)

> that hold the 64-bit values of counters, and elements to keep track of
> the overflow and limbo threads.
> 
> None of these are needed for the PERF_PKG resource. The hardware counters
> are wide enough that they do not wrap around for decades.
> 
> Define a new rdt_perf_pkg_mon_domain structure which just consists of
> the standard rdt_domain_hdr to keep track of domain id and CPU mask.
> 
> Add a case RDT_RESOURCE_PERF_PKG to domain_add_cpu_mon() to call
> intel_aet_setup_mon_domain() to allocate and initialize the
> rdt_perf_pkg_mon_domain structure.
> 
> Also add a case to domain_remove_cpu_mon() cleanup when the last

"cleanup" -" to clean up" ?

Regarding the "Add a case" usage ... you need not document the actual
code changes in such detail, that can be seen from the patch. Just describing
what the patch does on high level is sufficient.
For example,
	Support the PERF_PKG resource in the CPU online/offline	handlers.
	Allocate and initialize the rdt_perf_pkg_mon_domain structure
	when the first CPU of a domain comes online and do necessary
	cleanup when the last CPU of a domain goes offline. 

> CPU of a domain is removed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette

