Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A835949
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534383; cv=fail; b=isthxBbT3YGWrqQ+Zo4GVI/Cqwm/szbwG5TwsJAzABWH+d67qiJaWJMSnRIFFglLd0DjLFzvGh9guEiwnSIYrDrSaNriaAf3RSdIhXTmdVaU31QvepE8y1xWj6g7m3OI7i/3rpqiLo5+R+2VcL4aVJ7c2fAO6tURY494Ws6OP04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534383; c=relaxed/simple;
	bh=/6fqEs5d6su5CTLs6uQSUs0X8Nee1Wq7ub9+zsL898Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bR+pOFM7EksiGVhECt4JH1Hj7pcMwP0EOpahxrYUsitdeTepjPKKpKIQcXeTmu5x4AwOcio6Q4aMi8rPIuHQ253tcNpEWYhgnuTW9RrcEJ6fhgMpC7gdsF6Dsg+JBRYESI8JPIl9yphIXA2rGKehE1dRDfFx5O/1gXIcuyhqh4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V22CGBGW; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V22CGBGW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759534382; x=1791070382;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/6fqEs5d6su5CTLs6uQSUs0X8Nee1Wq7ub9+zsL898Q=;
  b=V22CGBGWmdHyft3ytWopdgFTb+dx6pOofTuJFDFdHb57oq3JicwSznKz
   HOoXQajSEUBmQHtPyeVUx1AyZehTyipIfh0CMPRNwEe64lBYSnAf4Nf1k
   soxbeA5xqOUQT2IQ+NO9pRVINKl8hvgdif1o8u2RCRB89j12uyOCCLK2R
   faTdHfZ4y3HhC5Xm5XbHBKv8IiIv5M70QiHozrWjAmUJcI5xLi0HiyzJ7
   ppOhh9hqmBf+7fr2ULTqVL4yd1By7ia+ClH3iGSeaX03d8Vd4jSfKr9bN
   VLolSpuYDxt6RXJR3tgQpzmRwVjP/yZIm0F5/LpKB4IPt/YNQ1uZbzBma
   A==;
X-CSE-ConnectionGUID: iYvcu4cdSOCuAMkmNnMVnw==
X-CSE-MsgGUID: YbCbp0fYTkOhTz4h4GF3eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61779691"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61779691"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:33:02 -0700
X-CSE-ConnectionGUID: idM7p1XqTTOYMnWz6XkyfA==
X-CSE-MsgGUID: 6iuPtMuWQwaJhBhdDlKaIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="178534052"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:33:02 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:33:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:33:00 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.5) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:33:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJmNymW/Zf3bjGnZir5RbXp+dhy76VmwTi7k0bfaipVaBDgXmxPAxRfVbJUQKdG1FOBwmkOzyKRBA62ggg+AeL+Zn0YonDWhtU+vne+OkJYXurWbQHPD/SC3N4L5Rvz5IqR1eak4NgGlQYXzTJFd/NjFI0k5cjlsmuGOQDyF1RkGvsejVdgXFA5kPo4b2Y2IPdmyaX92TYarOjAMEGVpXT8IGOb4n4UhYH1RP+uw1WXwmWJEUEKWgrU612qHK0x6+tC0EQmPfJwkOI2OirhUWpjfEkKzw97TxLmP7UdqMpSztIdz+9vR6DiFRDTwV67cjfbYRxtj4cIRyLoTZfXr1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NiVuBQD6Tr0EKsTj+UnspxcX57vJD8WiC1Pbv9AyfvI=;
 b=DIwW/1cCf3beYrKJGFooBAr0Q7GkSulX7sL7rLF655CsophjmRGBqQHCUmqZCpjduVjui2hAGnMcj59uvI3X0PRwxa//KdLYmD+ZKN87fYYoNOkXzbbQmms/oSTqpbHkT0hryV5Z/9MLxtJAuMvrSum27eBsBlfAKOJeBO+8OMeyaV3oU/pIP4Oi2+CrXSlO/rxiRgu48AFrvKareTzyRhtqnSeu0tW+yapEjfKKOV2fGNpyT+UdUEPuHc48Q4J0qN6Wo1+SvBAXKePuOZ+s1yowCnlm6rJqEs4F8vIlOyVZGsapXQA2EJnWJEzwL3yl3HqTkfH0GOFMWklzFV1BfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7975.namprd11.prod.outlook.com (2603:10b6:806:2eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 23:32:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:32:55 +0000
Message-ID: <c50d5c25-1c7f-4665-ac42-239d9074dd14@intel.com>
Date: Fri, 3 Oct 2025 16:32:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 10/31] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7975:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a3c4e51-a3dc-4f16-9864-08de02d52da9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OVhEOUpBSUVDSFJUWjZ5aEdnNXozeWpFaHg1Yk5aRnpzMkZWeCtvUTJ0bDI2?=
 =?utf-8?B?UUtYR2RFZ3lOMXBHd2ZoNStaMTFUTTZtYjJXbFM4NTk2dTBLMld2cWZCbzUw?=
 =?utf-8?B?WlpyMFpmSWxwVXVweno3NStSQ2JEV1NXNEhkQ1RlT0FGV2ZuVktxRDZpbHlW?=
 =?utf-8?B?alNNb01DL1lTc2N5VGk4V3AxVGp5UzhYWEZ5cjhvMXBsODBsakpMZXpLZnY5?=
 =?utf-8?B?Zlo1cG5ibFIyZDIxSkJuZCtQbHQrc2FVY3dQN3NpUTBNZndsTXJCSllQQ21L?=
 =?utf-8?B?RkQzSXRiZXRyaSs1VXNnUzRlWHJHdXBvTkR5RDUyQ2h1eEtqc2twWjdaVjdM?=
 =?utf-8?B?Mkp5b0FHcmR2QVBCYU14S2xRYW9uL0NULzhBWUFkTW9MTmxLVDRmczl4RUJZ?=
 =?utf-8?B?Yk43OC9HT0VCTEVRK1o4T2Q2Z0lhTzRNMlpxQVdtQ1YyTS9rbFRjRWx3aVRV?=
 =?utf-8?B?bkYxRFh2WllHa0VGcTFoVi9Nbzg2TEF2RU94V2lJR3hrcGpueTFjczJBQkdu?=
 =?utf-8?B?cEZaa2JLYTZydFNsTytnMDRwbUM5N25MRTNpeGtRZXNLQ2EvalNGTVYrNDVY?=
 =?utf-8?B?bnFLMHI0S0pFRTFkdkZzOWxhZFhTTk5TSElKK3MxbmthaVlwdjJ0SVc0a2VH?=
 =?utf-8?B?M0FDS2Fqa25PNFZlZGdKc0w0N1VrSy9qNm9aNVZOMzA3aStpMjhsVzZZekI3?=
 =?utf-8?B?cm9icHVObjNaVitkbkRZTG1EZHFoNlNYM0Y2dWdaZFlkc2N0ZlNFQ2tnNE1i?=
 =?utf-8?B?NkpJd1JxZkVrclUzSHVYK2FNOEEySHFWS3VDSzBjQ21MZDR3U1d5THh1VzJM?=
 =?utf-8?B?ZFE4Q3ZxSkF5Wml5cjQwL08vTE0xejNaWlpVbjRBbG1VOFpoVXZvMUFSL0hW?=
 =?utf-8?B?eGtqODhYOGdnemFScUxXdzMwMkI1UUxmcDFydFRoRDNBaHRySlZSaWNjUWJs?=
 =?utf-8?B?QkIzUEQzSzBMOWhMMXlTYkdOSElscWxXWXlNSEJBK0M5ejEzMkJ4MVlKSVRv?=
 =?utf-8?B?eFVJd051dDEwWldXM2xmUnlnNkh3Vzh0VGdvc09nRDNwQm9pMkhRN3dBcVdh?=
 =?utf-8?B?WHFTSEI4QlJEc3NpNTFTR28xaUIrbkdYQmdna09wMW1NQjFUazlnYkRCM3RM?=
 =?utf-8?B?UW5lREdKVHRLaE8rK2psWjVHNXZsWUxkZC81QmxQeXlIdEhHTVVNZkFwN2ww?=
 =?utf-8?B?eDRtNStIZ1hJalZmbnFzQnp4UGNnMDh2VVRmNjkxamlaWU9ES25sTC9Bb2pi?=
 =?utf-8?B?OStvYnNJQ0ljSi9BdjRuOW9TQjFnaE8rTEhOT25QcWRMRW5GMzRnSFUra2Nj?=
 =?utf-8?B?Y3lpMWlxNFkyYzV5RndxVXQ2OEZtd1p0S3RWbldBOVYyYUpyamcxam15UkJ4?=
 =?utf-8?B?eEN5S291YVRrbDRxcWNyaU56Y05rUUFCd1RDMGI1cTJxR0ZVVVd4RHZYL1cz?=
 =?utf-8?B?MnRabVZwNTJBUFJ1T1pQVzVNeXk1Zk1GeFkrcWQzb0cxOEpxVERGS2FMVzg1?=
 =?utf-8?B?NnZDNmFqNTF1enU1aVp5ZkZ1NWlVcElGSndWZlAwejEyOWVHZDY2WUpOdzc5?=
 =?utf-8?B?L2cxb1hJV3ljY05zRW91OHJ5WHJPVzFHSFZJUHJwRVpZMW5uZXN4YVhWeGRP?=
 =?utf-8?B?b3hyd3hWUmtETGk4MTMzOEdabktDWEJRa0tFVmhZdGtaNHBGYktnTEFWN2tv?=
 =?utf-8?B?NmNxelp6dXpRZDFjMTZsMHpHTzdzYzQ1Z2txQVM5dHRYUjRWRnRwTmF5Z0RC?=
 =?utf-8?B?VXZZblp4eU5JSlJBTVlIdFVFYzlNUHE3dlE5bmdrOHdRcERQanZGbkZjeklr?=
 =?utf-8?B?QUdUc1h4cU9ERkhoU2ZsdGtjcGo5VGRqNk5zbmU5L1VxdGxTZzNmQnRIcC81?=
 =?utf-8?B?WDI0M3YzWGtncHY0TGFKMk82alY0QUNvTzh1Q3dWcGx5UVFDVTBYQWFKTFNu?=
 =?utf-8?Q?SgrnHyd9ZAuh0GHPJ1xLW88lUIiZlW6v?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFFSaldzRUJwSTlyOU1vTU9wdVR1VG02ZjdTQ0RCQTRTV2llZFJxU0VxanZN?=
 =?utf-8?B?c0YxUkRlSmxvMEFxT29adEhCY05MZldXUjE1TlZVRnZNSzE1YUNySFl2VTdB?=
 =?utf-8?B?OWhJT2xOZHhCQnh1dmVqVWFCUGVrd1p4UkdBcmN5a3FTZ1psb0xFQVB2enV4?=
 =?utf-8?B?d3cyYys3MVhydkpzMCsxYndBcm1oMG0vUExFVkpvTDNlcVFaTWtRYlVjYkVY?=
 =?utf-8?B?Z3FybmpZekM2bzF2S3dSTUdYVXU4YW5DSVhmYnU2bUJ2bnkrRGh2VnZxVjl2?=
 =?utf-8?B?SmFNelpqNytYZWdTY0hMQzJCcHBSRnhSendhc0k0S3JXU3VIR1VGZzhxMWlV?=
 =?utf-8?B?SGJBR29pckYvZlAwQ3B5REJtUWRCUGwwcHE2ZUJsRkErZUhNMnpjaG5ERTFT?=
 =?utf-8?B?a09adFhGN3ZVUjd3UWpNdTMyczB2TnpscldYajZYaS9STmcrZjc3ME9tN0F5?=
 =?utf-8?B?blFxMVZJRDNndjRSZXlRM2M5aGdqZzhHV3FuL1g5VUFvOUFjM3M2eXA3NlRE?=
 =?utf-8?B?WmN1MmtLM2g2SUlwc2RsK2FMQUZKYzZxdFVzRHBKLzVYU0pQNWl2akNKVUpi?=
 =?utf-8?B?REZJWHdsSkxQWCtzaHFsMHhZaGc2NFJWU3dqS3NaMVR3RDFkR2JiNy9RUjNz?=
 =?utf-8?B?dXhOTWl3UTBlK0o4MnVlY3B6ejE3ZFVIMmJEZ0cxOGxaeUlJVzNqZFk0VUJV?=
 =?utf-8?B?ZmNDd2dCK3MrQk5OaXpFMGlpV21oeUZCYzE1cUdQWHU1WTNHWTczSzJsYW84?=
 =?utf-8?B?ZnRNbXkxV3lGYXROek0weVJXUitBZU84V0Z1ZWNPYU9TL0xRYkY5clZWSVU4?=
 =?utf-8?B?OS8vZG9hZUl4K05OUGovanprM21nNjRsdytvRnBLRWRBcURmcWdyTW1KMW13?=
 =?utf-8?B?a1YzeWNhaXZyMSt1QXprdGkyREVmYWZJY0dNQ2hoMXFKblR1b2FsaHovQUxC?=
 =?utf-8?B?WUlQcWM2QTRwSWhVU1d6dE05Wm12QXlEZWFLVXF2Z1lSNEZZZlhVZ09RckJG?=
 =?utf-8?B?cFJBNlZxd2doMEgrMnVscnc1WHp4WExyYW1LUjVrYldpRkdCTXZ1bzJBaFg5?=
 =?utf-8?B?YVpTYTNway93M3pkbXVocFBleExpV2RMU1FrYWR1OTUvVmdxS0NlbVdUakN5?=
 =?utf-8?B?SDhQTGdERlFYeFpZZ0xQdWFma0YvbnNqU1lLUzNTT253K25ZN3U4TU85MjE0?=
 =?utf-8?B?MEdpazJRYmdXdkhkZmU0cFVJOUkwMnhlcnppWVl0N0FKVWNJZm9HeWpDRjY1?=
 =?utf-8?B?eTRmY0FPb0YyTW0xRS8yWGU5blpKSDQ0L2VnTzFXZjh3cUoxSzNRcXFsTzZI?=
 =?utf-8?B?amx5dnhkK0ZPdWVMRy83cmVnVW5XR0FURFFQSnFZR3g0QW4rbXJLY3V0NjZG?=
 =?utf-8?B?elR1bjZTejhaakc4dVNNWkxEYXkxa0NHdGw3YVRXVnJsRklRenhMVVpTWkMx?=
 =?utf-8?B?ZnV5dlQwVVJJOUwvckNGVXZzSUphL2V1TnRhZmdkN3dwQldRdGxnMFl6b0FU?=
 =?utf-8?B?ZzM1Rk8zUEl0R2tRQkFkZkZJbUlUVnRrVlhiUTZXS2VMSzFwM3M5OHpqTSt2?=
 =?utf-8?B?VW1Sa2RMdUpyOG10dm1MdlorMWlQN3F1dWpvc2xMdHVlaEh4VG52TEhUNXZK?=
 =?utf-8?B?QWJpZ0lDT21OK3lPeUJDR3hsbmo3bTFjSm14THg3LytBQTVNdWZWWHptSEwy?=
 =?utf-8?B?VGU5MXJXZ0RMVitleEpPWHZFUFl1OWg0cXQ4SjRWcTR5ZEpWNkZHOVQ3Ujhr?=
 =?utf-8?B?WmxELzg1NDU4R09mdGNyT0ZVNHl6bHR4SC9GeGpEcTBKbEE0Y0pqVmlnUWVj?=
 =?utf-8?B?VEtYRkljWlR3OGlRSUNQTHc3djMyc0xXQ0ZwY1MrV3Z5SHBUNjBvZTBsWnY1?=
 =?utf-8?B?SFk0L1FhWmJKYUhGajBvM3FRSVN3TFVsNE9uR3BnSTAwNzhEcUZzOVRObVla?=
 =?utf-8?B?YitscnZXRkczbWU3UXNUTXloV01QUGFkU25GWWx6dnNGV242K2g0ZmhKMzZw?=
 =?utf-8?B?blZWS3kwMXNMZ2xGM2NtdzdZd0ppRGFURlZ5ZnlsL2RGai9Pb0lkZEtiWXZo?=
 =?utf-8?B?czV3aEtIUmIveVg0T2J1WHBJRkRBQWtVMlcxZzN2TEw4ZmtXUmhDK2ZSWG5K?=
 =?utf-8?B?MHF5SnFNb1FYSjdwUDVLSDUyUHc2U09FNUdDVWJZU1YybkNXWlZaeTRMTjZZ?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3c4e51-a3dc-4f16-9864-08de02d52da9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:32:55.2015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /yKiTWYxTx9/joFtxAYWQhWFCdkVyJvWr0OH6E54AjBacA42UIpUIqilrwAfXalP5JtbkLe1cOz/3cUOq7jqZlLGu4Q7Ifjk3zbp3F8jnrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7975
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> resctrl assumes that monitor events can only be read from a CPU in the
> cpumask_t set of each domain.  This is true for x86 events accessed
> with an MSR interface, but may not be true for other access methods such
> as MMIO.
> 
> Add a flag to struct mon_evt, settable by architecture code, to indicate

"Add a flag to struct mon_evt" -> "Add flag mon_evt::any_cpu"

> there are no restrictions on which CPU can read that event.

Or rather:
	Introduce and use flag mon_evt::any_cpu, settable by architecture,
	that indicates there are no restrictions on which CPU can read that
	event.

> 
> Bypass all the smp_call*() code for events that can be read on any CPU
> and call mon_event_count() directly from mon_event_read().

Above (from "Bypass ...") can be dropped since it is clear from patch.

> 
> Simplify CPU checking in __mon_event_count() with a helper.

Above can be seen from patch but when trying to do so it is not clear
why this helper is needed and indicates that this is missing "why".
Proposal:
	Refactor the CPU checking to avoid always calling smp_processor_id()
	now that events can be read from preemptible context.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
