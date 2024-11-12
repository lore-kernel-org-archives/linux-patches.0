Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DB52185B9
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 22:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731450335; cv=fail; b=O1Acf0fOUCFqZDfjCa25I1l/yKIy5gxo2kNxHXfHKqEnqC6C7VgT8LGEhxNrsMFEKoNiJgSzlFhcTynHAzN+yljH99fxhKD49Oev+baFOIg8igU0hikVATPWo0qJ6JT8szRZ+2ct+YSZ7ecuXGKOpn7ShqI0Q+Ag5n/dLK7u8po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731450335; c=relaxed/simple;
	bh=dDio8vbbhaTuzUkdxJklRLF+UzVyboSUwbU3YYj9SkE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cEHpG5q9Kjle4o2i3J1XirUB1OALLdS4ywCySTZtPu/UbfT8G/2nu45w+l67ixgyf2Xee8Nof3JsFopH53InzU4gaIFyaa0HQKhSBs2j3wOl52lllQbrDbf5mcfCkBwDC7nvrsqb1bxgHfIDkQizG5IfTIZlsIuZoaDkaRY80Fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U1EqC7bY; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U1EqC7bY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731450333; x=1762986333;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dDio8vbbhaTuzUkdxJklRLF+UzVyboSUwbU3YYj9SkE=;
  b=U1EqC7bYIu7TGr2cFJ3GKfEQuk96hssZri6vbpHEa7zwpMe7FXpc40cN
   8tdTe3wznKnn3DyDnqziBp79YKLm/TqlIPd2IRHV3DL/5MZLLgKmd0DA6
   AJpQEbWRVRF7sdMMQjiDXSlmB3NZ6xm7CLGlNwgsg3VdTJRTo3tGtX92S
   FutiC9iRL8isUjC1mHXUJ02x1iHIR8or0CSWvqeVpD+Yt5mr+JD2TXQy4
   tZGju5AHinNRazETG8Fjbda08sr7v1ApzbNXd55eOK+vP+YS3fhhxyShi
   6dwSC9/UL9k/N7yX5NBY0+GdgH5iDaHtEN5vOmo+xsdRjSvzfpJ4nC44p
   A==;
X-CSE-ConnectionGUID: kpHyi1xRRGeiM91gNU7dmA==
X-CSE-MsgGUID: /BU/oqRFQ/eEQ0hHWtdr5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="30717887"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="30717887"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 14:25:32 -0800
X-CSE-ConnectionGUID: 8W5naNK1T8qutqyj2xSc6g==
X-CSE-MsgGUID: hK9tGQxuRgOi06DsFBeivA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="87416852"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 14:25:26 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 14:25:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 14:25:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 14:25:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pz5s8Bth4uDIv/9y3Q4X2lpwdltmscDwYfGDv7FbPgJbaIBoHu03iEaA5GXzHFn3rN4/EW2BqU2hqT6Z6jEIN2UA2ba9gYxYxILj2rmKt3esg/V+C5CXHlXSJF7ZG71Uk7TcgohigbyMi0+jRtg6+rTyAqPKgbvtaF6Y3AVBX2Q5ElzHbK9mQ6FzRjxSyKagttM9XgP96D3k+l0E6L7p3ESfahAz4CQh22rNoQL2kVLxOAfITycBw5qDiN68kklK3Tpu81prgrD9lvUKWAhVCMSn7N5PT6LkZY0VM6hMF/AlPVkvdirCtjyRRgD9lmn5Zo4o8c9T2HN/9NYWWfjhpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v81zssh42pUTrmacoxKZt+DoS7qdw+un0VI6vZuNo/U=;
 b=vUU96N7m1403tHKBE+RZgw1SDQmuRpRrpDOtkigKOIOdAK6duipT9+uLseLq7+IxS7IKFXnLxatVOvkRUWzcKJVIldVy8lWP0YlEPaev54npDiXE/FLsK3MOodPPbZ4LLnE1dyQp99q9WivfngCOBXLIl2O7JMEJfesKpHCRGNbOxeosgkXM30pGIz2Q4U1Wc+hbFL/UCIf5jvgeQpqUfbSldw2vDhY9J3CR5Ljkur0Ip4pIsNXbk68vLsCFwWZUzJ/VImy2+1Dyf4c7eEeIeTxBGLbJnxdRdGqa1ZDjRbVGNQoi4qqE4Ehmst3bAPZQnHN3qNp+0VHhEG+YktJvkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB7351.namprd11.prod.outlook.com (2603:10b6:8:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 22:25:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 22:25:20 +0000
Message-ID: <6e614ae5-b7ee-44bf-8d33-93bd9a92aae2@intel.com>
Date: Tue, 12 Nov 2024 14:25:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/7] x86/resctrl: Document the new "mba_MBps_event"
 file
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241029172832.93963-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: bcca9b26-3dab-4a1e-1664-08dd0368e488
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bW5ESGQ1N0FxYnNJMDJZV2JtS2tOMVdHNERKck1hVjNiK3NHNDN0bnVBZkNT?=
 =?utf-8?B?RHBkakp2MDVrOTdrK09hSWJKczdxMjI5R3VVaHZXMW55Q2RrVFRJNm9SQUJM?=
 =?utf-8?B?TkVVZTlITVlLNWRSZWlCUjdGZHlwMUpvQ1ZoT0pHUW1HMlhTUFNyQVRmMXRv?=
 =?utf-8?B?RW51NWhobkhMMGxVSUVSMW9GNVdhVEJCUXNiV3V6Zk1IMmhXN3JqSnpHQ2Zx?=
 =?utf-8?B?SWJnSjV2cUI2aDNPVXZ4eTRQZjcxN0srOWVXNFVYclpEYzZiRlNFS0o3N3lu?=
 =?utf-8?B?QlRpMll2SzFKTE0wT3FrRzB4Q0lMcFJmWGpxUHRTU04xQU8vV2RXVTdJOUZU?=
 =?utf-8?B?ZyswaDRDbnc1R1pqWUtmVUxFbHY5dTNUYnA2cnpvMjRLbWR5SnkyaDhJZEpa?=
 =?utf-8?B?TmVJTTc2Nm9VdFpCaUk3cVk5d2dDRVhVWDBwaXphQ2pJR3E5SHQ3RlFsd0dr?=
 =?utf-8?B?Tk50UGVqSnhOaEo5dWtFY1Y1Ri9Zc2MyM3ozTTNOK3FxNkczUm90aFNXc1NS?=
 =?utf-8?B?bTFuTklTeXNtRmlwNlRUbllLWFk5MzFYbHQ2dEhKeE5EWDYyQmFMTFhtRmJ0?=
 =?utf-8?B?N3R6anhsU3kvbERiYStXQ1dDbTgzeTVYdTMwaGUya2JpN2VFM1BVaGpsTE5p?=
 =?utf-8?B?VVIyYTFlL2FPbDhKMEp0eldJbXoveldpbTUwaXQxVDkvb3cvVE1ZSE5ra0Jq?=
 =?utf-8?B?T2JoRWxzZlEweFdPSFRQOVIxYkloMWxHdjVTNTROYlA5ekJOaHlTMUVyOHI0?=
 =?utf-8?B?d1hpR1U2akJIOWhTTWVyLzlwMU0yblQvRHZZMVpkSkpWYW1COE9jMEhDWnBk?=
 =?utf-8?B?RTFYVDYvOWkrR0x4d1VWbWt5Ty9IV1RmOXhXN0JWQU5MNk1rdzR5NHJkU1N4?=
 =?utf-8?B?K3o2eEJRWDBybFVIRWl2STkwQ0Q2a2dOdnNoWmVFS21jbFNnd3RNeW1ENUdW?=
 =?utf-8?B?WW44eEQzSm82TFFNSG1IQ1NtNzdBZERVNUlRM05CeE84YTN4cHJMWmJITGgy?=
 =?utf-8?B?anVaWnJkcERjUzlkNlBjd1V6dUZieEV0bVdqYzI1NFNRNEpSRU91N0o0VTh2?=
 =?utf-8?B?a2xmL1pTT1FxLzdxelY5R25EZTc1TThZUVdnaWVyYXdMQ2ZHR0o1dmdrNGtV?=
 =?utf-8?B?RlNjc3I2MWVZZDRiT3JPNVExd0cwekFwQTdOTk11b3lzNEdaYU4xaVJrWS9l?=
 =?utf-8?B?bE5MNHk0UDF2a2hMTno1RkpNSy9kVGtrLzdXU3JKUFByMlhXRHV1R29sZnVz?=
 =?utf-8?B?dUtCbWd1STdpTFBZNWR2S2txaGI4dE1wYmJCUXRPNWM3S2Z6VWxBUnoyUml3?=
 =?utf-8?B?ZmNxVldmZXJodk43dWhOWGViZVEvcDVtOVp3VzJ6ekN5TnQ2cExBWGh0RnZ2?=
 =?utf-8?B?Vy90bXFKdnkyQ1ZzOE4wNGxkVG13QjA2dDc3MHhUUkxDTTU2MUhOWGg4aGNE?=
 =?utf-8?B?K3lhS1hnRVBGMUhINlF5WWRPZXJUQVJ5VnhKVlNPbDB6cUFkSTJRaGdJR0Uw?=
 =?utf-8?B?c04waGZwMWFhekVFa3JpSGlQV3dPa0FoQ1FmcVhsVjA5cWZ6ZnRHdndhVW9C?=
 =?utf-8?B?ZDR2b1A3ZXVNZXhYSEQ0aURHOXk1MzcwemtjczJNdXAzV2FkZEJ1aE1MeU5F?=
 =?utf-8?B?a0ZxT0VJdVo1RS9DYzlUN2pic29wbHF2djBxMVkzSHc2WlFtbEZUY0ZrWi9r?=
 =?utf-8?B?L2phbTFiSVc5cmFlK1lMNjA3WHRGTG9BMjJJTnREeWVvZ1VJaVo1N3hVNCsz?=
 =?utf-8?Q?eke87mjN+L7s1hpCM3BhxgeaiC6IFp1HWSpt0ES?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUJpUjQ2Z282VmxLSDRFTXB6UHdBZG1mNE5KQnFCQ3ZiNU54a2N5WUlrejJj?=
 =?utf-8?B?bG56czJHK3dXZ05MVE9SSjNBSGYwVFZITFJJbVVIZmNvbnhmb3VEM2hSS2N1?=
 =?utf-8?B?ZTI4VW55QXpPMnRLNy9IQWZ4RzBTVjJ1MDN4NXhnUCtPckxERXpEOENnMGl5?=
 =?utf-8?B?VkJOdmFUaUprcXZQMHR0ektjSHVDUk9FUlhGTzdTVDRwck8zK3M1MU5ybysv?=
 =?utf-8?B?MFF3RUxFYStoNnA4S25CbWFDL0g2NlFMM3Q0Q3YyTmZsUVZrVmlWU1pmdlc5?=
 =?utf-8?B?YXkwNkQ5ek9RanhHOGxVMDRnQk1vNVBRSW1oTisvdXpmVFIrWWZIbEs2bkRR?=
 =?utf-8?B?dEgvOHBmUUdEQXVPNzVrZXFZU0pFbnYvY2NYUnF3TG8yMDZwVzhtN1ZTK2lP?=
 =?utf-8?B?cko1UlZYQ0dYRHJHbGR0dDF4bGZZSFFMSFNkNDRsYXpXcnV0b1plSkNDMG9P?=
 =?utf-8?B?V2M5Uk5BaWV6R2owL2FvNldTYWg2SHhwTVZaZ0J5eDlNcE5RS0lpVUFveU43?=
 =?utf-8?B?ZmVRa0FQb2o3M1FEc2g5MGZYTUwzL2s0TnZBb0c3Vk0ySSt6eEd6cURPd3gr?=
 =?utf-8?B?UkZrQ0xHdEpsb0luR3Foc1JzT3hvOFdkWUtwMmNzUGtveTN1aVRrYUlOTWVx?=
 =?utf-8?B?WlNaakh5aFZGSVA2cy8vS1NSSExkbjYrVzZBS29HdlFJcXlNUHJDbU5wT1JO?=
 =?utf-8?B?YkQwM2M0STdXWXZxTXJ2WUxzZkJ4WGtjbTNZMFk2YUJ2NWd1VlNXOHRPanQ2?=
 =?utf-8?B?U3RmVDBnK2xtTEtEVmVXUmJnemFiNmFJMkc0SDNZNEtGQTFMcnFtMXlWUFZh?=
 =?utf-8?B?WUR3c2ZFRTZwV3M0dG4wQlJpR0dubVhJR21YT3BSL1UwTEZiZUJJVlBVRmZW?=
 =?utf-8?B?TldsOFUveDdGMm5OYU1ySEVuVFNkZ0d5dldzeFEzejdpalBaMmNBdWlkM00w?=
 =?utf-8?B?M3hRYVBWR3U5eEwvbFZTMjBHaklna01mOXdWUFpnWVAzVVM3dFlFRTV6UEI1?=
 =?utf-8?B?UXJFZGhWbHZkc3VYYTF5WlNEUjNZdkRsQ29nWUluSnY5YlpjWmY3YkEwOXFK?=
 =?utf-8?B?dDJFTzhTVGhIa0huNGlZYjdlcjF1ZmYwY1lWUGZYYncrT2lPWVRTKzRMYjZS?=
 =?utf-8?B?Q2ZyWkVHdjNjK3NoZTBpRm5oUUxmUmlHK2N4eFUvZEFhT2NqcE5vQk85NmdZ?=
 =?utf-8?B?UzRZQmw2RXdaVnl4YkhYUDNGOTBSczBkNUZobG00RTlHNkFaQ0FuRTg4Lzlt?=
 =?utf-8?B?T0RJa092UGRBeDZ5aDdKMmYvbnpVSkZueEppaktIaTVMcjZ6OTRMYkI0bVVY?=
 =?utf-8?B?SERwaDJubFhqSDRuOW5BaHFGWjh5WUVxc3JYeWNKbEdrMmtyVUpJb1p6WmlU?=
 =?utf-8?B?T2FQSFJwVnBLTEw4WmltZloxYjlLVkJYS3YzZDRFU1FPWGxuUTRXaTVBRmwy?=
 =?utf-8?B?a2ZDUmY0Nmwxb0JIT2JPL3RIUWs4Tnl2cE82ZVQwNmpuTVF6SkdJRGtiODJn?=
 =?utf-8?B?OXRvZVM5YTNnWXM2MWx4TjhobUdKaTgrb3B5bGpDQXR5V1A0bm5CVVJnU2E5?=
 =?utf-8?B?MFg5MURRQzRWZXFtWDJQM3ZsY0JrUncrQXUyaFRYYlpiMmI2dzVZT1pSbVZK?=
 =?utf-8?B?U2ZBN0MvL0NxZVRNQ1BUL1Bzb0dLc080ZTlvdGV3TVlnazVBVmVwSktrbFM5?=
 =?utf-8?B?ZkNMeWptbk5PSVNWQk1uK0IyMEM3ZndsblNNTDZFV1IySVJkbXEyd01odThU?=
 =?utf-8?B?K1J6ckYxaDJ3NlQzbGxNVHhPcFNlcUFvZGZXUUNCYWo0clNYbWxLYXE3NFZP?=
 =?utf-8?B?M2U2VVhsVG9aYTUrTlEyblhla3NaS1phUzNvNzhzUE5oS3duK0VvMzFEandm?=
 =?utf-8?B?WHMvR2pESGJ0akdTdEZoYTVOQis4WHkzUWtOUkFId2ZscXhtSmV3M2pOUlJk?=
 =?utf-8?B?WkJuNG1iOTMzR3dvSlo2SXY4Y3lDR1hmK1ZsUGlpUUQ2UmQyQmx0VlRsU0Mv?=
 =?utf-8?B?VGdoVnhPZnk3VmJSOU5ueFRqZXhOekR6ZWgwUkhFTi9WYzBKaE5meitXb3RC?=
 =?utf-8?B?S0NFS1RoRituVzU1bnprTFQyVmFLdFdzSVBhRktsODMrUFEzMkg2UzhIYkhO?=
 =?utf-8?B?WHVMQWxHckFGUzFsYlRMSFZaVXJXQWIxWHBOS3dScldlUnhWc2wxQ3p2YnN6?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcca9b26-3dab-4a1e-1664-08dd0368e488
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 22:25:20.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhfMArvlEPtl1P31aym5+0itPSTz1mq/fYeXtd2MCFkZeD++3KdowBiGwJB2aqRX0pwX59s40KpKYqsaJHC7NyxL08IkfIfXuFXukE6HuJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7351
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/24 10:28 AM, Tony Luck wrote:
> New read/write file to show/set the memory bandwidth event used
> to control bandwidth used by each ctrl_mon group.

I expected at least a verb to summarize what this patch does.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/arch/x86/resctrl.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
> index a824affd741d..d86081e76bbf 100644
> --- a/Documentation/arch/x86/resctrl.rst
> +++ b/Documentation/arch/x86/resctrl.rst
> @@ -384,6 +384,16 @@ When monitoring is enabled all MON groups will also contain:
>  	Available only with debug option. The identifier used by hardware
>  	for the monitor group. On x86 this is the RMID.
>  
> +When the "mba_MBps" mount option is used all CTRL_MON groups will also contain:
> +
> +"mba_MBps_event":
> +	Reading this file shows which memory bandwidth event is used
> +	as input to a software feedback loop to keep memory bandwidth

Since there is only one "software feedback loop" it could be specific:

	" ... input to the software feedback loop that keeps memory bandwidth ..."

> +	below the value specified in the schemata file. Writing the
> +	name of one of the supported memory bandwidth events found in
> +	/sys/fs/resctrl/info/L3_MON/monfeatures will change the input

"monfeatures" -> "mon_features"
"will change the input event" -> "changes the input event"

(changes to document expectations wrt timing to be included)

> +	event.
> +
>  Resource allocation rules
>  -------------------------
>  

Reinette
