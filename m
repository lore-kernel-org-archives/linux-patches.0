Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC5415665C
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007582; cv=fail; b=LkbLF061YF3q3ThW3JgDccYxfALEUHmjoRFl+Ofj6CE0cWcdCl0dIOJZFOuweGNmB5xhR91csXyqOq2ncuzQqROE/on+c2nspc3FzQj04ULDlJ8oKvZnxbo9ht195ueJzhx1yeQhpLytwDVyHe+iJUPMCbYoPOeXMgKgisZzTp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007582; c=relaxed/simple;
	bh=gtMAGBtFuj8nD0OA3kEsYF4tnT72VG4UX4kyvFJi0rM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q4c4sktxGHOrcrrEL4hJKor3UC8znsQsAl2/kACkMuTJSyyAT/mtGXQDT7Iyv/nqAddDusAfaxMFD1IKyWwRGTJi9tTrmA4XHWpUsjYp5lNvrhFf3t9DafUp0M4c86KqFo2NN9RTNdlpQ5ezDFY6V20W1mQ6ehUlAUq1yS8TolE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dy++DwOa; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dy++DwOa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749007581; x=1780543581;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gtMAGBtFuj8nD0OA3kEsYF4tnT72VG4UX4kyvFJi0rM=;
  b=Dy++DwOarAdGZp3XjrI+bS3Z29kcVx+GF+sncC0mNMNGO3oCOYEx9032
   KhY97nV0I4LUR/iF0qTVZqDQJRXg9gIVzaNJmiV5P6iA5PC7aJhot8rj9
   E4YzkfvMJGQt0pM+166csffSiDMrZEjoAZ2In81Rzla0BN0L3KKhS8t57
   7R/175f36Ho1weoBgSXXK2lSfeNzujZ/5Ob31LfNbBFpjiRnn3lbCT2tf
   e0xbQA9soSd7+L8j24fgXA3zFAOwBG2yYUjiBa/a142mo+sOHSC69qZtY
   UEupWXvFGS3dUcbAYBcyt1PqWYsmdFWuaoSDWcaF+PVsj+QyPyGP2kKBk
   Q==;
X-CSE-ConnectionGUID: UKejleO3Tt6bkmU7hYmEQQ==
X-CSE-MsgGUID: Wz6hlfsKT9GUCc0qjsxx2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="68505790"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="68505790"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:26:16 -0700
X-CSE-ConnectionGUID: j6h6rHSOQZGsxImdyv2UiA==
X-CSE-MsgGUID: qxM/KzG0SiuAvhX7xVNRhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="182229089"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:26:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:26:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:26:14 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.60) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 20:26:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRwMCablQTWmdcZS9EUsEmRsl+2BqulX1R2qSndxJaTu4SfATzZmXqbUMWkAI7NVI0Kgc3YV+1cLpmj4Ir1/27fiCotSwSlwUXwXejZm+6R5lj6DgFnCDOvk96lllHtaOpq0PHVF4gEy7pmFwlTRaUnifVfPjTtsEli6HcHbkob9GcBmj/pfPzvy2mOv/dDSEvEvrXao78R8MmZsddtVMGFw892V4LmWpVIRXPxBganKXUn6JA7U4OlXKnCPIPw7+C9VU5ThZo8ULCK6UkKomzvewWXdoI2+Ga6uETLq4Y5qGiNOPnKyxhXnXki5SN5TDN/TQfrwGqQXQ56HKgGa/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5deDwyl1TRZ2Ksu19GnT09akP06Y2C5SsPLFqRLjwc8=;
 b=vrQK3QhXT70EbiHd1/2j8RfrTAbJDAypoSqgJUjzzM5+KUMIiYRGaQhDiOU/Fx7wk1W1VKG9I9ynLRGZ8+PhyeHeufi0LA5HXplT1p2wE2Ecd7SobQkdcua50YorhCxqjHbTvj3szkCpTSpHtZoGImvfVmpDCPcKnma+/eo18HHMg3yVIkUlSaRsIUnKxYutr9lwe6+n38AJLXnrYHRzM09b4U+oYsv9hRiksgc1bk2RPrJHCxzJjCZsLQnlXtVxL+S4YyeWTXtSdZ/JJuJf7TLKOpntfG7vydwbF9NK23EZ/bh2605XVFSBptYkRQuTfssKeIrylJOJonDPJSwtSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 03:25:58 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:25:58 +0000
Message-ID: <7eec0d2a-457a-42c7-904d-2c85633dc2a3@intel.com>
Date: Tue, 3 Jun 2025 20:25:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/29] x86,fs/resctrl: Consolidate monitor event
 descriptions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:334::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: 1636de1c-534b-4746-2f9d-08dda3178602
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Tlo2bEUxTTAvQ1M4T29mNFJ2ajVmNWppME1YS2YyZmRhRUFFR29JVzJrNDRZ?=
 =?utf-8?B?VjBHUU53NFM4VjJaZHlaeE1ac0xrbWxlOU1RVDUwb0hHNTFQOWovTzFEL2x5?=
 =?utf-8?B?aC9EcmxoOE9UYnJMOWd3aHB5YytuOW0wTWRvbXliN2xmeDZaamJPNmRWR1RC?=
 =?utf-8?B?T2ZXWldrVlR1em9kWk9HSUdiNnNncUVKczdRdVBRRGxZK01RU1k3bzh0OEVs?=
 =?utf-8?B?TzZyLzlJTm5OK09sdVkxRiszOWwramg0WWZVWUxiQ0lzQjRpekw2YUVFb3FD?=
 =?utf-8?B?UkFzL3RQUnlFSW5lRkdUbEN1K0JlOW9JTUI2WDNOdDFXVm5tcXRYZ3hoMW03?=
 =?utf-8?B?U2N6cU1ab2JyUGFITmN1MVBUcWIxbEVHU2xSdURKUnVXRDhVbDRPUzd2NS9D?=
 =?utf-8?B?VGwyN3RtNG9zQUw1cXN6MUZqMk1jVjlBZjMwcEx3dEhsNloxNS8xOEF6dWU3?=
 =?utf-8?B?QUdjOTVsWUJtdWY0dXRuYTdQRVhKaTh5VDIrbU41NmVseHZKbGNmQ1duL2d2?=
 =?utf-8?B?QmdVakh1ckY1cDJIVyttU0RyQ0tJczJvalNLVWg2RXF1ZnBJN3FOR1B0Qmt5?=
 =?utf-8?B?NHVMbThvSE9za0V2OWxqYktxaXlxTi9GNE93Skp6bDVtOC9XejlZaVFQQ2lI?=
 =?utf-8?B?ZzJrQjNGaWhjNzZ4YkNyYkhvWXpsMVAyN2hCcmhIaWhBUW5TNEdzRU9oVThO?=
 =?utf-8?B?eTFRRGxUalh3aDJxN0tVWHFVSWhCaW5kcC9USnJTWmxlM3Vpa1BDWFlxZzZq?=
 =?utf-8?B?dHhZazNVTE43STNoc0RMSkcxOHhEUGNwUVU5RjdyRUd3NE55bTJLenkrMklJ?=
 =?utf-8?B?aGdMQkg2ekN5SzNNcHBsTXQvZGJVWWw4Smh6aHpXbFU2OHdFVFI5M0w5SkZj?=
 =?utf-8?B?MkFaYVNIRFdQdElkWTN3U09iNVpJUWhwZ2ZXYzZvdElNdFZrdUt0Q1FoanhP?=
 =?utf-8?B?a2ZwdC82VjVRZ1ZyWHR0WUJvcU5uaFpGZ2tGeG5aRTY3R25nTitjWlBGNGZa?=
 =?utf-8?B?QmpPL2RMNlgwWEVDTlhyOTM3ZEhRQlpyRmE2MER4MHIrbUFyVGJpcDJsU0h5?=
 =?utf-8?B?TFUwQ1EyekZ2OWdqZ21CdW9lRlZrWTNFOU1QQzQrWlVjYTN1UERLM3pNVE1I?=
 =?utf-8?B?eWVKNU93RlpUWW4rMHdVZEpPWDhRYytzUVJmVVIxQTZyeEh5RHRmbW9ncXgw?=
 =?utf-8?B?Slh1eldOQjczTEw5djBpdjhoWmpPb3dOdjJSWFNnUjdzdTBQMkMyRHdYajRk?=
 =?utf-8?B?SWw2bDRwVHJxdDFtWFIvUXRZTDJPR0JZeVFSM1dwelNjSlJ6eGt3ZEdZQWdl?=
 =?utf-8?B?VWpwNmd1UmdvajRDdEp0QmpkL1R4RkR4TTFxUXQ4a0oxYi9pZ1prcGlKdEgr?=
 =?utf-8?B?RTN1ZW55WkhJcFRvV3AzajhvTW1hSFM3VER5STNnb0QrcW9RbGZ3ZXFXZUFF?=
 =?utf-8?B?eE1xaFVFSWhDbGg1bHVYbmpXS28wMFY5RXZkcmRQR09lUElXTCsveXlwQ1pX?=
 =?utf-8?B?NFJvZmhQVGRBV3ZKMk5rSlJ5aDVSZUtlSzVDZE96aHNKQW4vUXg1OHI1VTJQ?=
 =?utf-8?B?QlRzRG5KbnlCRjBVd2JraSt0OG0zcFV3bzhPTWRsbCs4eWNxdlhQSWFNVW56?=
 =?utf-8?B?MmY3aCtiTG9WTDBuK04wL2JoNFNEVUZ3aEQyM1kwdnE4K0lyYVJnZ01MS0hG?=
 =?utf-8?B?dTkvTGZLelV2dnhzajFjTlpSKzB6anBqNU9hY1lGYm1qVzJqVkZBblBqVUJp?=
 =?utf-8?B?RGVIVE1XNHkzWm8wazhJa3ppUlVFYUdUdU83TXBRMzJhdFVjN0lscTFGYnRC?=
 =?utf-8?B?WGZhWno2bmQ3VWErVW9TaFZINUJud1lOTHNQUkRtSFd1SU5MallXRmZnbS9j?=
 =?utf-8?B?RXhrU2Ria0R5WlAxK1VHbXNmSnB6WlpNVnJTRHBUeXBCdDhXbmZGRzN1akFr?=
 =?utf-8?B?Z1grMXV6Q0FQa0d0aVRSOWc2b2p5VmNDd01oWFdHYTFsN3dLR3ZJUUs1L2R0?=
 =?utf-8?B?R01hWjZLR213PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eENyUVdWcjVvUW5nYTV1RU9LNTRZYXNzTVZVZ2lBRkwzVWFUelRFVkhTdnMv?=
 =?utf-8?B?U0FiWmc2RUZkRVN2eThCYmhiSFdEZW14eGRZcm1IVEhUVEpWVjVCZUY1dFdT?=
 =?utf-8?B?ZVA1alF5NEVRdE95bWo2WmYvVm9xNVpYZVdTT0lkdVZNYXp4QUVtVDRWYlJt?=
 =?utf-8?B?emFCYjhnWk5NTzJTTzE2NlVEWlU1cFoxMzZkQ2lDQU5VSy9VMjU2WFFjWXZp?=
 =?utf-8?B?L0FGdXV4KzhmOHUzajlmQ3hxcVZXRlB1L1dCeGl6c3pVaG9pSjVkbXExVXIr?=
 =?utf-8?B?MkhrSTZjWGJVajNPMytSd3dzczY5K0svNFVReURha1NuVzl0Vnpnd1M1VWxz?=
 =?utf-8?B?OHlndkJKVXVVWWNGQTB2emZYdzNLZStJTWtrL0UralZ6WWttRDU5QVYzalJn?=
 =?utf-8?B?ZDB3dElsTk5pdzRpcG82Nys3eFFGdFBsOUtyR2VLNGp2L1V4UGVZZnNWMEt3?=
 =?utf-8?B?QkcyNlZqVFZwaGx3YXg3U2dQRlo0WVVNbmtTOTFhUk5sNzhoL2lQVU14Qnlv?=
 =?utf-8?B?b1RVVFNzRnFwbHkwL1cvZnRoSHpqTmJZRUZiVUlieVFzU3F3VDE2ekxod2lw?=
 =?utf-8?B?UytzZXJPQnVDVHpTSmEwSGM4TE5iY2RzNCtxYkIrL2FZTWpyNWdlK3ljaGt1?=
 =?utf-8?B?QWo5dHdnNG4yR2Y4UDJDbnZvQUxHeC9uWGw5amdwdUFVaGt1bFVTanh3ZnhI?=
 =?utf-8?B?cUtvZFo4c2dLNVhPMVhIRGV1aXdSSGJML25lTmJjM2Y1UXZxV080ZHRtOFNj?=
 =?utf-8?B?WG40Sk9ZRjVneTNTVlZJM0tVUitLYVA0cEdaeWQ1NXBzU2ZUS1BQcVcya29H?=
 =?utf-8?B?TW50TVZ0T01nck1vbjZTSEk5bnhhamhlQ3NmMXVtRmJHZDBadS9ERERWREVa?=
 =?utf-8?B?KzJLZkEwQ1lYN1hhUXFtRXN6NUxBYnIvMXdrcU9ISUFjSEZPaWVYTjg3VXND?=
 =?utf-8?B?UDl5MDI1WVpBL212Z3gzTEJ4VmNEV0p6aUdsb2dLUTczNFhCTUt2Ujd2ZFlR?=
 =?utf-8?B?cnlKMGFmRmh6QmQrb05teFZjWnBvMFJuUWJZWXdCY2ZVSWxVTEJjZm9OUFFO?=
 =?utf-8?B?YjNVaFY3anhnMkVaTkd4WWpnR2pyai9kazBqV0o3WC94NDNueGFkK3BGN0Rk?=
 =?utf-8?B?b05jWWp1cTNPc2lGd0ZxOEVvcXgzWXhtV1AxSmhUV3pkeGxjWnQwMTdwSTZM?=
 =?utf-8?B?RC9CMzNnWlVqOUZicHRyQ2tjOWlSNGlDNi9tM2tyOHBUVUVLT2daWDgza3FU?=
 =?utf-8?B?aHBXMU92Tm50SWd4VjZRWmZ4U1FkZkJVb3BaZkZjcXkwOVVjVHQxSVhPUXIv?=
 =?utf-8?B?OGYzM0pPNGFtZERwVncwclYyZkFOdkhtZTlUWTR4T0xDWXBYWnBpSTBQZFl6?=
 =?utf-8?B?ZUUzMnNhZXM2R0lROWx3VVIrcEk2UkhOSWFEMjdhTFo2YlVtS1lTQ3l0VEVy?=
 =?utf-8?B?bDhEN05UaUZOenZQN1oyVHRZWGI2R085eEpoV2hoWGZtQU9rSVFJV0k5amVG?=
 =?utf-8?B?ZkR2cVUxQldtWDRDaFg3dVJVYnhTY2czTFVHMEdIMGpNN3R5Y25jTG56WVN4?=
 =?utf-8?B?T25JWVdLTVJmTlZBejJkaHBiTDgzWC9tSVdGMFJOTmZPditKUWlmQXBLbFZo?=
 =?utf-8?B?cXVJczkxVTM4c1pmU2IvY0dERmdjeGF6bm5nTjNIR1RWNzJVamUwSW9FZ2hE?=
 =?utf-8?B?N3ZGWGo1dndad0lkemEvbHRMaklhSi9zU2g5N2lnNDJ1RnR5Rkh0RldqYzgz?=
 =?utf-8?B?ZTNmWFN0SC9IMWcwc0hEQTF5MFJ3L1Mya0QzdnRPV0gzaDRTendlVXkwdW5Q?=
 =?utf-8?B?MGRWbUx0VjJaOURxaE9YNW9laWRtUFlDMzV4V0tOQTZobCtUWGV3aVdJRFdv?=
 =?utf-8?B?NmN4LzU5K0tXOVQ2LzVoWmVuRzJVd1RIcUVheXZIWDRSMXlpd1FVUUtZY2hM?=
 =?utf-8?B?RWdjUVE2Rm5oWFlDTjYxeG1wdjM3dHJ6SGdJNnlORWhkTjVRZ1lFMkhXYi9v?=
 =?utf-8?B?K1grQWdZN21WNnd6ZDhmMTU2bXMweStLOU5NVU0vUnp1U3AyeWF4ai9udDQ2?=
 =?utf-8?B?eGp1ZmVJYzVOWEJraFF5VndlRkxsRHo3eTlnekdQMXpISjlVcUNkTERzd25j?=
 =?utf-8?B?WFdjY3E4Mi9Ba3JmejFwK0l0MWYrRUlIL2ZTVDBISHN0YzQxTjZtR290OXJh?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1636de1c-534b-4746-2f9d-08dda3178602
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:25:58.6238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+FOxAlSz+NF+A2ZX+gtGdxzfrB6GLHkwijdO3M/nTb7W0d6nhnT+CdvGDVTrTzmcSk+XMjAwOtI59ZB4XwbNHw6Hy7ptm0Gekk3YJuxD8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> There are currently only three monitor events, all associated with
> the RDT_RESOURCE_L3 resource. Growing support for additional events
> will be easier with some restructuring to have a single point in
> file system code where all attributes of all events are defined.
> 
> Place all event descriptions into an array mon_event_all[]. Doing
> this has the beneficial side effect of removing the need for
> rdt_resource::evt_list.
> 
> Drop the code that builds evt_list and change the two places where
> the list is scanned to scan mon_event_all[] instead.
> 
> Architecture code now informs file system code which events are
> available  with resctrl_enable_mon_event().

nit: extra space above

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> @@ -372,6 +370,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> +void resctrl_enable_mon_event(enum resctrl_event_id evtid);
> +
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);

nit: When code is consistent in name use it is easier to read. 
Above there is already resctrl_arch_is_evt_configurable() that uses "evt"
as parameter name so naming the new parameter "evt" instead of "evtid"
will be much easier on the eye to make clear that this is the "same thing".
Also later, when resctrl_is_mbm_event() is moved it will be clean to have
it also use "evt" as parameter name and not end up with three different
"evtid", "evt",  and "e" for these related functions.

>  
>  /**
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 9a8cf6f11151..94e635656261 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -52,19 +52,23 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>  }
>  
>  /**
> - * struct mon_evt - Entry in the event list of a resource
> + * struct mon_evt - Description of a monitor event

nit: "Description" -> "Properties"?

>   * @evtid:		event id
> + * @rid:		index of the resource for this event
>   * @name:		name of the event
>   * @configurable:	true if the event is configurable
> - * @list:		entry in &rdt_resource->evt_list
> + * @enabled:		true if the event is enabled
>   */
>  struct mon_evt {
>  	enum resctrl_event_id	evtid;
> +	enum resctrl_res_level	rid;
>  	char			*name;
>  	bool			configurable;
> -	struct list_head	list;
> +	bool			enabled;
>  };
>  

...

> -static void l3_mon_evt_init(struct rdt_resource *r)
> +struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
> +	[QOS_L3_OCCUP_EVENT_ID] = {
> +		.name	= "llc_occupancy",
> +		.evtid	= QOS_L3_OCCUP_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
> +	},
> +	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
> +		.name	= "mbm_total_bytes",
> +		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
> +	},
> +	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
> +		.name	= "mbm_local_bytes",
> +		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
> +		.rid	= RDT_RESOURCE_L3,
> +	},
> +};
> +
> +void resctrl_enable_mon_event(enum resctrl_event_id evtid)
>  {
> -	INIT_LIST_HEAD(&r->evt_list);
> +	if (WARN_ON_ONCE(evtid >= QOS_NUM_EVENTS))

If the goal is range checking then there should be a lower limit also.
With the event IDs starting at 1 it could be useful to ensure that
the range check considers that. To help with this I think it will be
useful to introduce a new enum value, for example QOS_FIRST_EVENT,
that is the same value as QOS_L3_OCCUP_EVENT_ID, and use it in
range checking (more below).

> +		return;
> +	if (mon_event_all[evtid].enabled) {
> +		pr_warn("Duplicate enable for event %d\n", evtid);
> +		return;
> +	}
>  
> -	if (resctrl_arch_is_llc_occupancy_enabled())
> -		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
> -	if (resctrl_arch_is_mbm_total_enabled())
> -		list_add_tail(&mbm_total_event.list, &r->evt_list);
> -	if (resctrl_arch_is_mbm_local_enabled())
> -		list_add_tail(&mbm_local_event.list, &r->evt_list);
> +	mon_event_all[evtid].enabled = true;
>  }
>  
>  /**
> @@ -900,15 +901,13 @@ int resctrl_mon_resource_init(void)
>  	if (ret)
>  		return ret;
>  
> -	l3_mon_evt_init(r);
> -
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
> -		mbm_total_event.configurable = true;
> +		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
>  		resctrl_file_fflags_init("mbm_total_bytes_config",
>  					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>  	}
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_LOCAL_EVENT_ID)) {
> -		mbm_local_event.configurable = true;
> +		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].configurable = true;
>  		resctrl_file_fflags_init("mbm_local_bytes_config",
>  					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>  	}
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index cc37f58b47dd..69e0d40c4449 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -1150,7 +1150,9 @@ static int rdt_mon_features_show(struct kernfs_open_file *of,
>  	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
>  	struct mon_evt *mevt;
>  
> -	list_for_each_entry(mevt, &r->evt_list, list) {
> +	for (mevt = &mon_event_all[0]; mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++) {

This looks risky to have the pattern start with mon_event_all[0] when that
array entry is not fully initialized. With a first array entry of all zeroes
a blind copy of this pattern may trip on a false positive with 0 being a
valid resource ID. Here also I think it will help to have a new enum
value of, for example, QOS_FIRST_EVENT, and have the iteration start with it.
This could also be simplified with a helper, for example for_each_mon_evt()
or for_each_mon_event(), that can be used instead of open coding this. If you
do decide to do this it may be useful to rename for_each_mbm_event() to, for example,
for_each_mbm_event_id() to better reflect how that helper is different.


> +		if (mevt->rid != r->rid || !mevt->enabled)
> +			continue;
>  		seq_printf(seq, "%s\n", mevt->name);
>  		if (mevt->configurable)
>  			seq_printf(seq, "%s_config\n", mevt->name);
> @@ -3055,10 +3057,9 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  	struct mon_evt *mevt;
>  	int ret, domid;
>  
> -	if (WARN_ON(list_empty(&r->evt_list)))
> -		return -EPERM;
> -
> -	list_for_each_entry(mevt, &r->evt_list, list) {
> +	for (mevt = &mon_event_all[0]; mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++) {
> +		if (mevt->rid != r->rid || !mevt->enabled)
> +			continue;
>  		domid = do_sum ? d->ci->id : d->hdr.id;
>  		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
>  		if (WARN_ON_ONCE(!priv))

Reinette

