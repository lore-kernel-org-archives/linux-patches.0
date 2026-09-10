Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AEB361958
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012666; cv=fail; b=crl+uMYXE0sssMvoQXf7K8sy9HF1i8rYAqJuB1xgyqMcpWp7iOGBJWcoTie+Bexr3hKVNwgo6tKdHshOYtbiR9OYgmTvEnYzw4npcXhPwBAk0CAwTXzXkisiee65t4QHl/qiFIg7DUYXMFercjSDjjHfAMdd85pDQ7o5d+O3cyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012666; c=relaxed/simple;
	bh=L/Su7uWU+6iu5ya5fKL30nhHkXymilZiojXOSNs/n0o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GBDAm3nsrkxvOUIwjx24Tu1vsfirLZcD8LWA86djfgSUKNc7jijptHMQbEd/pCZV2dVIBIgOTz7G7RxHlihEwlJ4L8G1duio85JkA8FnI5zdjIofNZZxge+BeaDH+iNA+61S+TMjWR1TBHTXLcXE2xoN6cS1GNi2vxojXhjSktU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NBOdF+cx; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NBOdF+cx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012664; x=1820548664;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L/Su7uWU+6iu5ya5fKL30nhHkXymilZiojXOSNs/n0o=;
  b=NBOdF+cxXzZ7i9tTBeLWTP998FkOk1pFWavK9cvVP+HyvcP7SABHEwUt
   FpbNvKVzeRiutylSrvIoMAiauv83hFv42JGz8eZZT4B9WiKNVOdR4ondt
   YMYmpVCTtmv/UjY2IwoWlx0NiLk6F4MPe3icU9opKDuHYGNfUZPsZYJb2
   w/rr7vhlWxqYKoxXc7lxeQLOlcoaDRzKHlbEmPm4+1ktuYdNRlVXQZSlx
   wTj2/lL9gjnCD7myM1gQ0fKpbpgdK1bdolYjfP9ny/tDpe6d/hhTkKvIh
   yqEPoNsAUlk7r8UIXkqJXl4jKXjoz8ovOjDeM5uJGl36FoiA61zYFG4lU
   A==;
X-CSE-ConnectionGUID: h1YzM4zWRX6Z1wekt5XMWw==
X-CSE-MsgGUID: vay6fmGRRK+j9lT7GGGMuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100617902"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="100617902"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:57:44 -0700
X-CSE-ConnectionGUID: DYRSucIwQJ6/ltn3BxPRUg==
X-CSE-MsgGUID: Af7CwRFxR4SHmH8nsc5n3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="267222252"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:57:43 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:57:42 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:57:42 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.12) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:57:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doh0XBsE2Lf5aBhnY7i/MynJEkJwn/t4AkD8a6UZt6qlLVLXV4lcgrw7js2d1tV+5NLp/xoEXyW5vT9gUPqoQWoWwBL0A4vQaYtq+0h4v5QTa5FOz4JcBceCkCp9x78zQ3KxEL8ePm65aPJq0Gnbb6CHp19IpDKpXamvijOB66k22xugXGvfHTYKOOAP1HEIRgamtmTXuYq7XzITgus9eGfxx8NDwQjBi71fsVtlkqwHsql2kvnLer3z95EOVztUn+5m+uQur/0m0dkf25PDc7mVqpIOyO8bTnt+xipSJ9QTVuc9IhWkKGjUyTm22oE10IrQsis1UcKB5pBAdnwWZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3bRl4pm4OsVx38R4ftPp1ZdFeq2qLBBLVVVcvB6wec=;
 b=Tj62ezoAEvm2AUm/8hOJaJCntQBnkds7BmsaqIPlVHgh5PSPal3nubl2VkzSOJesbyoid4ENK6gQyVNzcV2g21d5OUD2XHAG46jNwYbSuiAyCjqDA8scfgi87PZJxtvNltJ6QMa0rUW5T9gQt+g3pQF61sGEZoALjAhoT2cY1cu+SayQ5SAGeUTy1wQpX00heDyCVUNr3k1J6NLAnhverWRXb/oD5eZ8ZI1g19Ld7jd+jy3b3Cr1mLiaJQRcgoMh5P4Iit+uUIDTk6EhoTT1mcVAWUXN+1JbxGem7460PufjQuvIosuutE6KQ+Nepxja3BSxqR/hZIkJdN+PX7smzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 03:57:40 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:57:40 +0000
Message-ID: <66038771-a3bb-4b8e-a075-275716b9a476@intel.com>
Date: Wed, 9 Sep 2026 20:57:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 09/23] fs/resctrl: Remove redundant calls to
 resctrl_mon_capable()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0359.namprd04.prod.outlook.com
 (2603:10b6:303:8a::34) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 1124913d-358a-43d2-b4c3-08df0eefa8a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|6133799003|10067099003|56012099006|11063799006|4143699003|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: CWT7VtONUJYyG42Jiz9ARoHiH8qdM+z65b7kUQzb+CTPHt2ZtTFeNdtz1rZEraInasKvy5nzO1LrJEQlaEOYkJVGaYGklGaIFjL72dapSMaJMLdlUKBbAAAdhpbWrI69OFxY+No6UbxgAUG9/UszGzYgHgQZhJlvnV3GtGtIni8hJNOUVr2aIGVgrLPYD8XBApEXX2cF9wScHOV/B/uKHaPNYiMHUPeHh9yn+O6RkfTdz19fQa/lIYzko3lR6w/+II5sJOu4ai1AnT0sFIIzsn0TYio6zHl2Y45EIBo95MyxhoBFT9f9GOP8waXBmGvwzSbNx/q4nEZB7lxOlpzXP5t46X/81HV93YQh6Cm0DRBE3IHJuyG0qDqdQm4H+3jBqGey5DG5g19AYA10AB+niQn0gm+gsAdeghM3GXHKZje/aq6mhKRLQV2dLW4bbUW6UieGkiLUpgpzhOXNCzuQ8VRoe+BWTImm+yv18Uq4ZR/BBWycUxqfn5KOJPDpIJ1tvo+FIbqpQtPbDrAOfdctyLKVrLBYjeNj7I6hCVr4lIk0nt26/lr8g6LHqVxxpohk/CRlDTekKHDujN08GIfEmaU2cc27EQ0Hii2i1x0XtyNzohoLGdjVnt2IMi/LPBgebKcaKOgWqD6ztDbd0J8OhbV9LeNi63oUOp4rWB0Dw+JpR1J9lgmagG2155ySb7EmsuOEBmYxYlTvpwF2gXhGlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2xoVzd3MmNFN2ZhZW9rYkpSazlNVUJHT1lFMHAwSWdGTnNMaXhhOFpFcWo5?=
 =?utf-8?B?dnVPekFJd1Rwejh2bzBSeTBYQ1lHNlN5d2JrcTlPdGMydU4rUGdndVpUMjBp?=
 =?utf-8?B?V0xWc0dNSkltMUtWUGMxMGtZNDM0MnNidHRJVzVseHkvZlVpRnBBZm9jTnhr?=
 =?utf-8?B?WHlMcVFRNE5QUnlJUXZYZGc5dDZ1RE1FNUdCYUJQcHVrRlRTMENVejBoYWRa?=
 =?utf-8?B?Z0w1YllTUHdhSkNacVpqSDY4dkZqcXdoOG5RRXJDalZlMUR1MGhNeExwUnpR?=
 =?utf-8?B?aEpCT3UxNmtHemozcEp4c0tTQU1MdHZ1cFkyeVFJMWtPTERDZ01WWFlOK05U?=
 =?utf-8?B?NWJySHc0eHdpa1dIWFFkcUo0Ty9MZzFLLzZDb0RuSzhwS1VPWG1RSG1ZOHQ2?=
 =?utf-8?B?Y3AwUDlzcUtBYWlDYTdLYzlUM2pKaFZHSTUrTUZtWFlCWGNXSm5hRzVZMnFS?=
 =?utf-8?B?aHFCcjlpTWx6S2hRTElaTWR5VHl2T2FBZEowMzNzM2pKWVZHWU96RklFc1Ro?=
 =?utf-8?B?MVJ6VkZTVmNMaGRMdUlncVh3dXF4Ui9ZNVhJcXd0cVY0OHJXL1BFZ05uZjdH?=
 =?utf-8?B?U3F4eEtwY2F2a2RZNW9OZGNnR0d1dkZET1pjUUVVelc5SlgrWVNDMDBhQzJ5?=
 =?utf-8?B?ejlYMVRES2VsTUVYU1ZTczlrOWdnY3BLMGlwQ1NqUlhXR292VlI2aGczNkw4?=
 =?utf-8?B?aGQrdHAxbTVKZEJsMkJ2TEhKTGlTbWd1OEpKeVVWNmJ6QWJLbWdWaDVkWk1j?=
 =?utf-8?B?YWlZdEpiRkNmQlVyU2FMQzcyMk1reldPeG94Rk1yTHRKSVlzNm0vTFVCZUg5?=
 =?utf-8?B?L0NiQVROM3dpYlFaeVYrVDdOYmFJbVprR1YvTkt1RE9zbk1XWlVEalpaTFdG?=
 =?utf-8?B?RGVOck1QeUxIdTd6d2pGNUtUOVNtOWdVVnhxMG4xZVlNYmdJYU1OU21tMkhD?=
 =?utf-8?B?M3EvbWVQYzBtdDdpaXN5TkVzbUpLdUpiSHBMOW1CdGczdXFzVEdLK2tnQ0hB?=
 =?utf-8?B?d0VPWjFhdTdiM2ZBRzQ1cmlnZ2xuNmwyRGpCZTUyZnczN3FUYmlQTkxIUjFm?=
 =?utf-8?B?TFd5eGdUeDMzTGF3U2wxdmpVZ05kRG5nQmUxemppWmtOdDJXYzJUZVkzWnJw?=
 =?utf-8?B?UTRJY0RTNEdSMXhkTmVORWN3NWFvd3M3MGtxWmpnekVqUmhyUHVJWmtnYmNu?=
 =?utf-8?B?aXRYcDhDVVhZOU1XSTZRTkYrVkRpdDVlaUFnWXk2NC9qTG5RVHZHU0RqUENp?=
 =?utf-8?B?eitVTDFpTWw4enRKOWh3MjdpRG1QanpvTlFMdVdmbVg2dktyRDF5K1c4NnVu?=
 =?utf-8?B?YVVuR0dZOFBrdHRQTGNxbllxbFZNdG9GSkdNZ3p0UFIrdm4zczVBcVE5RDRE?=
 =?utf-8?B?cjdDZ0I0ZExOblRBSThUbC9yUWZuNDhNRDNsVTk5dHczTmkrbktpT0toaWRF?=
 =?utf-8?B?VDNIUllpcFd1aHJ1T21tdk9sVmQxQnk2QjZlcHVSVTRERnIyenFrL2h6L25w?=
 =?utf-8?B?clBVd2t5NTF5eGN4eDBtazdmVmlMMU1kay8rVm5jVkxKUllMcnREMVhjNDFX?=
 =?utf-8?B?b1E4MEhhWFlSdDlUelVVaWZlUXVEZ0dQSWR0L1ZLVmxxakNDTEU4cjd2NjZv?=
 =?utf-8?B?bEZsbVdYQlY0dmsxaFFLOC9nanJvSFBBcWJ1eFhNVnYxZXo4a3lJT2tuWjJa?=
 =?utf-8?B?S2FjMlBiTWFFMEVBZzhWWlVmZWcxK29xTEhuZmx6dGZ5a0pQclM5d015UjFs?=
 =?utf-8?B?bmZxU3BxaHVvWit3QWZneWp6ZkVEVGFTVWJEU05ST0FTQ08wTTluUjF5c0hP?=
 =?utf-8?B?di9sTU1XOWY5aGdueDZzRDNMTVByWXh0WTMxUDcxWjZDMHYrc0cvTURYK3BD?=
 =?utf-8?B?cnlSaVRrNjdBald1QUExa2tNVVFySDQxcm42KzR6QWlpNEhKNm1pYTdvbGVJ?=
 =?utf-8?B?MkZ0MnRCcHhYeTF1OFhtemdHVWRsTGxaWjRPNCtueWlVUVdkeWFDY2VGdDJo?=
 =?utf-8?B?ay8vc0xuek9TRVpQWlB0MmRmYWNWcStoeGhEazVQUS8za2FNRFhJd1VneVZL?=
 =?utf-8?B?ZUlLMmQrZmFTWWJ2WlFna0krdmUybDRHeVpoYndoOU9vYTg2aW9NSVFiOERD?=
 =?utf-8?B?amlDWnBFb3U5eDY3STlwT3RhRG5tZ3JyWjhpWmMvUlVqOCtBZWdocTNpREt1?=
 =?utf-8?B?SGNJS045TWRlbXNpWGpXakJvU2R4VFEzUGphQ3N3OXhmVVJ3UVR3Q2lnMzNY?=
 =?utf-8?B?K25QYjVCREhuRGFLZ1lMV3JOL3ZBaXJxYWpFb1RhM200Ym92TEllNlBKVmhz?=
 =?utf-8?B?Z3ZDVmlBMDNCV1h4WGhUOXlaV3V3VHlZNytkb2xrb3JFa2gxYm5VdWE1a3dW?=
 =?utf-8?Q?EavzeT0dh+RXH9hE=3D?=
X-Exchange-RoutingPolicyChecked: NRB3tjOUXTJxiXtNCPpQBxvfIv5jpZbhitk+vZF+r+20UQQhdA5zyAmzLjnUkhLBk2YC0/Dk9wHwedY3yafSVoYlHb/Wf6HrnifdspzWeCFHB+aMN/gAQRAIXkeVtoHROeyuJm5PRKweqUPgPHaDRBKMe45EtAvwG8raLnMnXT5RMgClDrmr583oGntXdInPeQ89AtU7zSr2D1N7SNjyUPS9M7DRfEVf18clEV1Wf7bPClD4J5GrwfBa4LfCD6WNOw1aJDAebUFaLYEH++jX/A28J3I8YtsP6g7qUfvtmwiLreII9okWY//snLMXIskWzIIPoGeMDDNfL8bH0X29kA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1124913d-358a-43d2-b4c3-08df0eefa8a3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:57:40.0559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ue5cZLzliV6lhiY32CDLr8g20GnGBcykxyb1z2b3ws2IQJztv7zX+9BgdSzY9y+ZpBg/vK1fpJkAbdNFFLJXeTZ9aLmU31lv6aDMHNsoauU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> resctrl_mon_capable() indicates whether any monitoring resources
> are enabled on the system. It does this by scanning all resources.
> 
> Redundant calls to resctrl_arch_mon_capable() in hot code paths should

resctrl_arch_mon_capable() -> resctrl_mon_capable()

> be eliminated. There are two prime examples:
> 
> 1) mbm_handle_overflow()
> This function is called once per second from worker threads running on
> each L3 domain. The call is clearly redundant because worker threads are
> only created if the MBM monitoring feature is enabled.
> 
> 2) is_rmid_match()
> This is called for every task on the system so making it less expensive is
> appealing.  The call is redundant because the function also checks "r->type
> == RDTMON_GROUP" and this type of group can only be created on systems that
> support monitoring.
> 
> Remove the call to resctrl_mon_capable() from both of these
> functions.

(unnecessary line break)

Patch looks good to me. I agree that sashiko's suggestion of an addition looks good.

Reinette

