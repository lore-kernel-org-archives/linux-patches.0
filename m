Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03244211A35
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 16:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437901; cv=fail; b=eO1H48ReacmanBwVC4GtyS5/iipcDwoRsAbqSkafNuScBqkLhQ63dCNX8lnYxuVrNqcOY2C45E6ifW1EwsbWcDwg2S1ARorQqVZZpNV2Dzw7hGl3kytrb0QAc85i0L80EQnIy1fzj1uUcUnNijSuZDkIUH8G0OcTIriT8V+liHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437901; c=relaxed/simple;
	bh=7weQycOXRsxVmIQ+znbwHGJVr6FpOT2MMVNSSJ7kiVQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QKlXVYja9rD3cN+GSeX2PbATrblvHHh/MIpY3R5qjFtOIVDD1KwmxBF7XFu0dYQ+oGg/GTQxn34gNmDiC43FN+6cIGjYK/XYLI74sjf6qbrYcxVXtlfN4wVJu5KBOyuisYrBJyQAnL5AcNSWqGrSv0XchbRbE5MpoL+bMg6gbiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EjQqlNuW; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EjQqlNuW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743437900; x=1774973900;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7weQycOXRsxVmIQ+znbwHGJVr6FpOT2MMVNSSJ7kiVQ=;
  b=EjQqlNuWBwupl/4PvE3u7Js7V+B0aKHeRFQVR7tu2FEz2yGV4QKmXqJi
   ospV4R/qM6hu8b7OJdiMXBFrlAVIxj9RGd5sfADRR8UOgl3FDpyh4X6tt
   N9XFUPTwgQdPqRUcFryNAcJmL+ge9PhWJxOLbHnDTFfsreGs2PIq2/++w
   ZU5CRDvywcQVsiTekQW4F7ADKiJOTxD3v1nhds5vjMEy6XYC9/UARqHy1
   xpyuoAApc12KqnLM9v+D96jerwSpFLZM8k30QcO3ij+ySaPAKDWBwO9FM
   3/T0s87FXkbkZrBEKiOwYQKs1BGdGuIYwJMl3Kh7MfZSG0TgRSIk4MHIl
   A==;
X-CSE-ConnectionGUID: WLzO4+/JRI+pEIr0hsQuYw==
X-CSE-MsgGUID: VYX67mNIRJyDQGt1s+/uTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="48397556"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="48397556"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:18:19 -0700
X-CSE-ConnectionGUID: xW0N4b5gSKykpzo1Bp6yTA==
X-CSE-MsgGUID: zSv30kxbRD6f3LbbL04zeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="131348618"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:18:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 09:18:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 09:18:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 09:18:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zSRby52CH4nyhk/UEBj+uLCizwa9kxg1U9jidHB4Vy4CdU4iVPrbqSB5Zy9OBeYf8FN7RKSTvVZEj6LVLE0jR691VRtLP3e2todk6V3+huBVf+ukKhBVjYEh/UcImBQsYGtRBHLhdbbuWkwD/mFr0rBmbs7sxpMK0RWaJwzLr36fEvdOhQDoacdLic+6TSZ8e3jzOuYJSZGnk18yoXieTjyslQO4LBRP0mvf8ni1ntGQCsLtfz5jFFdw4RsE9qTNwHSkPfziRxlxRwJGA2FsViLapAyFk68sgVJRPdvhDW458w8PGHZi/Mo2KKMzuwMwzuA3kjWvWX0vBq7pII5lqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSfJNxCShb3XsWyhJ4f/sPH816RG2QdX7tcx0Nj92h0=;
 b=V+XNlyqaAnKNmG2jwRzF2fihKHP4BFonfZshx/qSYAGxwMD+j6vbUVcgGtlpJi/nI/fQnCL5UZQOnx+SjDc3kyKs0/PtuI9V3p6R3eh81L+5o3N0SpmM/vCVpDQZ3fvJL+SSxme1DVWSGCNmHhU03xrQ5sEE0R5CMQAZxaFFC9dRC80UbtIIfr0K6VTwJnV08NOSy3yLsQgsBx8S4B/JtbAI2oYCGCI0v5ls52z7MoDkTIIiBoOQnxKFtHAIF7BCCthob/pKJzmZZX+DF90mT+Lx4q6wVJNqD6cdPMdKCfDkGG/7RdzCeUVdjARgbErQroGVRelQyjnd5Eo/TZqzmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6930.namprd11.prod.outlook.com (2603:10b6:510:205::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 16:18:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:18:14 +0000
Message-ID: <1dcd185a-17b9-446f-a19f-fc2355c4c6ea@intel.com>
Date: Mon, 31 Mar 2025 09:18:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/16] x86/resctrl: Add and initialize rdt_resource for
 package scope core monitor
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250321231609.57418-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0062.namprd03.prod.outlook.com
 (2603:10b6:303:b6::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6930:EE_
X-MS-Office365-Filtering-Correlation-Id: 5661a218-d80f-421d-3b84-08dd706fa366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UWU1LzNIYTd1RHVKK29RSUszSmRYNXdETzhudDhoVHVXaTFRd0x1RFIvcDlx?=
 =?utf-8?B?cjRFMW5OUjdUOWJMbmxMYVlySWhWQjJPUDBmTFZvV0wxbFNnQlBxSmcvUWds?=
 =?utf-8?B?bG9pVEt0Zzl3OEx3VXZ1VmRUUElFR1dTc3FKWkJaZWNnL3pGaEtKVkNzUFI1?=
 =?utf-8?B?MEdRKytIYVg4amFUdGFSVjVJd2JSNC9WU2RmdkdHU0tRcnFOQURzYzV1QnVp?=
 =?utf-8?B?eXlsUVNlRHBtZ0JBbGNTTmdCWnFVR3k1djZPeGpZT2RaV1dOM25iZmMvTUor?=
 =?utf-8?B?bVhnaEpxbUppNlNTVGJ2dEpOSEFLcHhLRExQQ0paQzhKRFNLbTZ4djczZzVj?=
 =?utf-8?B?dXdGTkw2UmUvZUlrejBlME5uV05uUU15bVkydUxsTi95RURla2lFWUMwbGs2?=
 =?utf-8?B?ZzdhYVBJYUVndEpiQWV2N09RZU9BNGF2L0IxTThwYUszbXFDS3RSK2xYQnc4?=
 =?utf-8?B?blRSWHQrREU3SUw4OS9HK2ZsQjY3cm9lM3hrbzQxNmRuQ2FYazZ3ZnhKUzhw?=
 =?utf-8?B?aGo1WTRaK1ZRSitadGFZU3I0cWw0eWlrZzIxQlhKL2pySTYwcmEzVWdva2kv?=
 =?utf-8?B?S1BFWmNFa2FBYmdoUFJ5TER6d3dZT0lrUlZiOFY1a2xYUTRQblIyK0RSZUlT?=
 =?utf-8?B?V1ZoQnRSQlZDL1RVeGhqUnVhTmJ1U3JSSzNFamVCWjV2b3M0UCtxZGkyK29H?=
 =?utf-8?B?Q1V6bW5pWEhCMVNLNVVtcE0yRlp4TG1EM096blVzWWNJRWw0Y09sc040bGs3?=
 =?utf-8?B?V3l1RkRzSWFIcjdGeE5mQ0luWHF2T0JsRmViSGl6c014dFp6Y2RzaEpiNEhh?=
 =?utf-8?B?S05Cdm5OZlNBYTdTRlNYdjJ1OStwZ1NuOElpcHNxU1JLRnp3SFNkem5hYWZU?=
 =?utf-8?B?dlZ1aTRkaWpPeDk4bFhGbXNxNWJMcjRLSEExY3B0RVRBdDY1Y3lhWmtySWxI?=
 =?utf-8?B?MURIWVQwOWx3c3hZN0ljZnBwQ1VWaGZvTnZsYnVSMndjVVhqbGs3eXhtcDAy?=
 =?utf-8?B?cDdKYzZMUk5tWlZRTU1YK3J4U0ZnRUpLSWo2dlZkRTdUbm9lbDFmT014OTRq?=
 =?utf-8?B?UFNycWNLaHM4UEtpN1BKK2p5VG1SRXFncytGWnFmcWgrRjNJd0RYa0JDdnNP?=
 =?utf-8?B?Njd3bU1qSzhsdGptRVdORXF3YjV4M1NuN2FuQ3lQZTUvVzlHZkhlSFFSMGoz?=
 =?utf-8?B?VmswMXJmTW5FTC9TWGVrbWQ3U25EaUtRbXBkYUZ0eDFudUVYZDYrckxhd1ht?=
 =?utf-8?B?SFlLczZrMmdCVHNaNWVTSys2OVFtbCtTRXNORlNrb05NRGFuQkphWUVEVUhG?=
 =?utf-8?B?UnhTQ2lieWFpQXZPdW5PQzZwdlpvSnZXdkdCVUpoV2pHbjFlRllYcUNFa05h?=
 =?utf-8?B?SEZ4MDFlQ3BMMWg3ODlyTDJlOWNVN2pMNEsrTkNmWjlsU0lrOHZ2TThxL2U0?=
 =?utf-8?B?dlk5VEdua0FYencrZ0NwVUZ5VENSZlVsVHVUMG12NmFlNUJ6endRaGNFaU5p?=
 =?utf-8?B?NCszOWlxUmg0MzcwTmJRQjRzeWlmdFdxcmpaLzFTeWZaVTFFajUxOEpsTnVE?=
 =?utf-8?B?Z0VZWjZJSnVZSEVEOTdKQlhKelpGbVN3QUxlMnV6YTlXb3lDeFp0b0dNOGlj?=
 =?utf-8?B?QTB6TUpMK3R3b2szdFBKaG9TVWlramR5OG5pWERQdHpQclM5K3ZYMGd4dkhZ?=
 =?utf-8?B?WmRsU1pVeVZZY2hUN042WWlwV0orRVVXUUFNcDU0eTNETnBlMS9pUi9CVFox?=
 =?utf-8?B?ejRsRlRrY3NnNHduanI3WHhoV1NJdER1NkFBMWJ5b2ZTVG1xOFhRZFoyWWxx?=
 =?utf-8?B?MzNDTkZseHkrL1Uvdlh1NzJraU5QdFNLTjlIbDhzTHduNUdWOUwrT01Jaklv?=
 =?utf-8?Q?LPGA3MOqI8hkf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K25DSXRZUElJVVFoWGlpWTdRY05LM0FyOS8wNnpkN1pjN002eTdxRHpoSGNi?=
 =?utf-8?B?SHE4enNWOS81Yk0zYUJWbjY2SWtNQlFzb2N0N2k1QldmWWlyak81cSt4UmRs?=
 =?utf-8?B?MVlDWTViRzBQMDBZaUhnU0pBbk1Gb3I3L3d4ald5RnExZjB5MUxTVnhrby90?=
 =?utf-8?B?VEJreTNpdXlsZzJvdFRhR0dIQitnTXV0YXk3N0FXK2VQTTViRUhYUlY0RVA5?=
 =?utf-8?B?bC9qcHZsSk1ibFlPTW9hc3lsWXl4WmJyOFJHc3FiU2xCeWFsajBPZGhBZnVR?=
 =?utf-8?B?VmxuekpBbTNTRTYwMjZZWmNRQS95Nk9SclhmQnZvZ3RWejYvTjJ4cmpLZjV3?=
 =?utf-8?B?eWVOT2c1dUtyY0R3QjBnM3lLMWFoRERoQ3RlNFpINmtEeVlPS3A0Y1cwM29y?=
 =?utf-8?B?UHQzb0k0TG04b2QyUU9XOXkwK2JSZUdFZDVWTk9oNkFTWlVpTGtuVVd1aWFi?=
 =?utf-8?B?a3UzQ3dTaDVvK2hsTzBvM1h3dTV4MW5YS2pGcHp3aDgvYUh4NlB4Z3pyL0pu?=
 =?utf-8?B?OWlPTms4aksvWEVHNTFCQVd6RkdyQWduaUM3UFkzd3JHa09xYTBxM09WZkNU?=
 =?utf-8?B?TExrMkNSeUt1YUFYTm1HMWs5ZlNnK2RPZk5JTm1mRHhlU0NmZkdyc3BScm0z?=
 =?utf-8?B?MTVoVTF0U1JEbktUK2x0SWZXViszalZleXZqNHdyTWg0Wi9qUmFOT3dFOFZ1?=
 =?utf-8?B?WW02VUduNGtQUXBmUTUrMFJDUHFRK3lpb0RnT2NyVTkwT05NY0R1eVcyMXRK?=
 =?utf-8?B?QnVCWDBzV1M0YXpBdUtlZUZJaUpHMDA4M0JkbzZORGcxNXpTU1YzTlR0Q0hH?=
 =?utf-8?B?dHEyM2p0VUx5V3MzaFhSa3locC9NKzZBTTI4NjZHZ3dlQzVqeEN5dEVlcUpZ?=
 =?utf-8?B?MjVCSDFtSzAyYlNmak9pUC9RU1luVXByTktrMFFyVEJSRHJJb2FZR2ExOXBj?=
 =?utf-8?B?cTNlamxia3F4WkNVWThJMEthMWVycDhhcVdOSzRhZGY1Vlp1YmdENkpzVFZ2?=
 =?utf-8?B?ZGNsYXJqa21zU3c2ejdwZCtxODQ5SVVQVWpLb3VYUEtmdUtRcE1LdlVhY2RY?=
 =?utf-8?B?ODduYmdFQVkyR0lXSmZwMWVqcWpCMi9YQ0pzMmlqSzRsVDhDNjZuS3FiMkpR?=
 =?utf-8?B?TEpDaHdhcGZTbUxpbDh6MmpRWm5oV29xVTFXb2VPcCtWbmxlSVV4TE5wd3Fv?=
 =?utf-8?B?cExhTkhHRWw2cnVJT3ZiRnJYbkhURW0xNG9GVE9nU0Y4M3JDWlA4WmRVMExy?=
 =?utf-8?B?UTFNSWZKMjZ2Qng1U2tqMWsvQnA3eDhJd0JnVDlyNDRYRkJEaHp5ZjVMbldS?=
 =?utf-8?B?bFRmcTJ2c1RaTFllM3UwY1ZwQjZmMVp4RTMrZlR2UFl0YXQ4bmZRbHk4bjNz?=
 =?utf-8?B?RDBXYlFlU2NLMlIvREhrRWxUcnpvWkJidHJTbU5pcTFHVWNJcXNMZnk1QnRm?=
 =?utf-8?B?T21acTZJRWY1UnRFWUdLbnNkNWJDWWlxTVI2SWh4L3JGZG5sZFVIUEJRQmFw?=
 =?utf-8?B?K1VaMlB0S3Mxa2RNZlUzSExCZXdINjA1Ny9LZGJwTTdKc1l2ZWZtWmEzczdk?=
 =?utf-8?B?eEZNSjliTU1NOG1FcFBDbm5xT3g5SzRsaFBBNkNucjd3V041ajc4bFZRN1ZC?=
 =?utf-8?B?WEJiS2x2UzZsbDBvaVRCUW1aT1JtcjJ5RDVFbXo2bnVpVEU0YU16VTN5RnJJ?=
 =?utf-8?B?UmRQdkhPc0wyQmoxMDFoVUdGMVJDek5PdnU1Y2wzVVFSUnlkdGlidzlmNE5x?=
 =?utf-8?B?dHpZek40M3NPR1B6eldRb0JsbDJFUXYxK25vNk9yVkNuaHRFY29oN3dVclBr?=
 =?utf-8?B?a2V1V1BzWUtYMVoyWkhLM3RGWDN3RTlSRzZQWjJ0TUxDdm9VY3pqVFNzRUp6?=
 =?utf-8?B?ZUxONUZ2ZkpJNTQ0VW1lZCtyZ1lqYzhVSEQvWlA4djM2akdoNDFtdTBCTExr?=
 =?utf-8?B?NjNzdkU3YXQvTHdVZDNCLys4Z0VJMTcvYTFNUE96dml6VWUvcmhaR204TVBL?=
 =?utf-8?B?RElqdWhPamcvSmg2d0tCMThpdnpwTU5yVGNZWVhhVmtSUGlRN1BwazVlVFFm?=
 =?utf-8?B?OWp1SFU0Z2tqazdKUlFZdUN3Z2RlMldVaHp3a3N5dmdFTkpLeXdHNUZOVkUv?=
 =?utf-8?B?bDJYYllsSDllNzJmSmMrVVgyRWQ2NEdBdW5PWHFkR3N0VHJUYklIS0tsNUs2?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5661a218-d80f-421d-3b84-08dd706fa366
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:18:14.4026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: za9SviVRS1IqCpF9etgVbbzYUPReHN26OzTSlez7qPhoAwZnDK+PKELzT/esv3FK/sLMyPfnPTNEU0YGWda94TRYRzKunYvZ8bRrbd7Qruw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6930
X-OriginatorOrg: intel.com

Hi Tony,

On 3/21/25 4:15 PM, Tony Luck wrote:
> New resource for monitoring core events reported at package level.

Could you please add proper (per Documentation/process/maintainer-tip.rst)
changelogs to all patches in the series?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  1 +
>  include/linux/resctrl_types.h      |  1 +
>  fs/resctrl/internal.h              |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c | 11 +++++++++++
>  fs/resctrl/rdtgroup.c              |  2 ++
>  5 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 25c3ee78de3d..6c895ec220fe 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -233,6 +233,7 @@ enum resctrl_scope {
>  	RESCTRL_L2_CACHE = 2,
>  	RESCTRL_L3_CACHE = 3,
>  	RESCTRL_L3_NODE,
> +	RESCTRL_PACKAGE,
>  };
>  
>  /**
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index a7faf2cd5406..8f967e03af5a 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -39,6 +39,7 @@ enum resctrl_res_level {
>  	RDT_RESOURCE_L2,
>  	RDT_RESOURCE_MBA,
>  	RDT_RESOURCE_SMBA,
> +	RDT_RESOURCE_INTEL_AET,

This is fs code so architecture specific code needs to be avoided. Any other
architecture that may need to report similar data would be forced to use this
resource name.

>  
>  	/* Must be the last */
>  	RDT_NUM_RESOURCES,
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index ec3863d18f68..3a100007301d 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -240,6 +240,8 @@ struct rdtgroup {
>  
>  #define RFTYPE_DEBUG			BIT(10)
>  
> +#define RFTYPE_RES_PKG			BIT(11)

"PKG" is not the resource but instead the scope, no?

> +
>  #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
>  
>  #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index c316268b4442..c8cc3104f56c 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -99,6 +99,15 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
>  			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
>  		},
>  	},
> +	[RDT_RESOURCE_INTEL_AET] =
> +	{
> +		.r_resctrl = {
> +			.rid			= RDT_RESOURCE_INTEL_AET,
> +			.name			= "PKG",

The resource name should not be the scope. It should be a name that reflects the
resource being monitored. In this case it is "core"/"cpu"? I understand that this may
create confusion since the data is provided at package scope so perhaps the "resource"
can be "perf" and then all the events can include "core" in their name? If the intention
is to guide user space in how to interpret the domain IDs then we could consider
something like "perf_pkg" or even "phys_pkg_perf" that prepares resctrl for future perf
events that may need reporting at a different scope?

> +			.mon_scope		= RESCTRL_PACKAGE,
> +			.mon_domains		= mon_domain_init(RDT_RESOURCE_INTEL_AET),
> +		},
> +	},
>  };
>  
>  u32 resctrl_arch_system_num_rmid_idx(void)
> @@ -430,6 +439,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
>  		return get_cpu_cacheinfo_id(cpu, scope);
>  	case RESCTRL_L3_NODE:
>  		return cpu_to_node(cpu);
> +	case RESCTRL_PACKAGE:
> +		return topology_physical_package_id(cpu);
>  	default:
>  		break;
>  	}
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index dbfb7d3bc3bc..a90291f57330 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2179,6 +2179,8 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
>  	case RDT_RESOURCE_MBA:
>  	case RDT_RESOURCE_SMBA:
>  		return RFTYPE_RES_MB;
> +	case RDT_RESOURCE_INTEL_AET:
> +		return RFTYPE_RES_PKG;
>  	}
>  
>  	return WARN_ON_ONCE(1);


Reinette
