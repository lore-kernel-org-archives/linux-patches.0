Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FCB411A1C
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790282516; cv=fail; b=eWH72IFTsNiuOZlH+Rm/aYmYZoX0wJf0jv/9KicJ9oAL5LwmBzynoN01lAf21PTW0aZhUiPtb20j+4EwauACs97XWSkEAF8H7Pyer81bpWRF/bHCnn+VokiccDRxdNZQRvtwn4E8xL38FzYgczTLiwuCbqU+lCh5cuYcBOD3GLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790282516; c=relaxed/simple;
	bh=UAiGZp/mAjxSSuq6gAnA60Wtobi6KD0R+t5YeDfVm7s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xw32X0ByZqerIH1xPISTlYCyQ9MdbUKQAS3Vg0Pe7Z8Ge61HNylTGVDX4cCcHgDxmkAt9RftC44zsH8/rFvjF4hOQPkbil4CtcvQiJOG6qi8CK/LnbhwYBgFK2AfaJSfkabyjLvjZp9jK3MGnGWl2XeNxZv66N3Ic/kX1z/RUVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jx5GAywQ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jx5GAywQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790282514; x=1821818514;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UAiGZp/mAjxSSuq6gAnA60Wtobi6KD0R+t5YeDfVm7s=;
  b=jx5GAywQiLOGiAMdnEv6D2PbgfrXo9iXHVr+ChHCf9yRLeRLKWH20zXe
   bTS7o6CFloJLsyRIr3u4ewQeJYiTS4xlzHUyJeBdQQh9Yc5LYBMTZHix2
   /ODks0wPC/IRqoluWkeQDbRdMdoPftV1dEVUVMqOGaLp+C2UnFe4sNbVs
   Oh9iKr6ZWbMqCLdQQFJ0lnbMMAKg7ibpDoNFgbtGM+2nAHfq9wmOPK0MF
   nl3fXMWm8ThnLV4s8sKDXfGqSmajQDBUzifK/cLLGjIPcog55rTz0rXEt
   /HSKZ6VKBLETpYaQJK6Wx/bQTlS/AYeFhDjEB8sG1nmkJmzaJxL0UVqzI
   A==;
X-CSE-ConnectionGUID: HBMdyPtjQ9ixq/BhdXS39Q==
X-CSE-MsgGUID: rb/4X7NXTnuvTwBI9Vv7NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="116597037"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="116597037"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:41:54 -0700
X-CSE-ConnectionGUID: lfs42S+hSDqHjaDTV8tbTw==
X-CSE-MsgGUID: ndWOo6z7RzCJxskj9HNHIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="277894475"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:41:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:41:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:41:52 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:41:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDDSomL98UDJ2kz3bIkFAkh0a7z84ACRly7+qaL4QoUNK6jw96M3b39YPkAUvxtq3hNGFEaYQc4tOJ+1dom9i/ZSCboJ3x5sGlI0RqVnsZnauWRDtBPKnPQZGRHTLV4fhxU2R1PMxBvYgORKBww/oVgaPEKN5Cruf+ZMOJcfK+OYJGAjUwCGnyONfQuPD7qVI8Enpa+JLFoNcfvrkPDKbZ10/0uQwCexSzi0rE4RGHZ2MYYqgbJMgYZdcMgBptn34h/PzsgnyW3pgL5gpXUtQgBDxeLMbeZEgJ434rlcVYqYhZjK1nhMabeZpG1ZBjrQo9zVXoqISE/AW6WyKlFL5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81M6Fw+DWG+5QJshewzgDBGMMjKtPksnbFgBTjSKYCg=;
 b=L4NZL668oiS+pzy8yrf6KZGYlLTSzo1TSdG03b5/lNlvy7b5xEU/bkqTzCZJZn/5DanNr4akdbxhFgqSZfmhGP4jyMciZKeiGnMZO2xUOZuuxuc2xD7urRNae+fFnXhNBginr8ZivCWxMCYKo4vkkEfbETN1zITmyMzuXaL2UsEg8YWkAXMYrRz/LCa7D1sbMwUV09G4Zli+CJOOOdsFmfAkR4lmkt18LtAO5dXabP32ZtPQuEpKN+p+acu6juVngq4im1VQpBD9pRhfQAw7ZTHhbtiLTSBEYt1uAAjggTUl9aPpHy+cBj97WVU5W8jGTfkovtZ4bmnPLxE7CZU7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB9509.namprd11.prod.outlook.com (2603:10b6:806:47e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 20:41:51 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:41:50 +0000
Message-ID: <39582d24-0fc1-4d5e-bc05-01c2f29ddfb1@intel.com>
Date: Thu, 24 Sep 2026 13:41:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 15/25] x86,fs/resctrl: Handle systems where AET is the
 only resource
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-16-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB9509:EE_
X-MS-Office365-Filtering-Correlation-Id: 71463b97-da6d-48db-7259-08df1a7c4279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|18002099003|56012099006|3023799007|22082099003|4143699003|11063799006|921020;
X-Microsoft-Antispam-Message-Info: xQxZvm5QehrOS9dXxy3REJUgfMoYQ3khID1OsqKs5uzZnWqQniQ0Irp4DFhqFRu/c3JeMs7ctZ3hrLmY1/axb8EF63jYHPhGsFPToaxBs8QJiI0T9m32V/Oscnerx8rQFgBwBmBcoprzyFiBAiwjvl2Xq+cprmcQyU1UvHphitDOJk5vZa+e9ypK28Av2GqDhWObiukJjnt9u1H9hqSpuIamlyMBHnKmJBgFAPYooqp68sOYY1x23hpajPTH6xnwmA/QNyzhKihmvJ2O295DxKqWs65ZYAe1PY9uGyWkCFwyaSwV1k7urVlq3MM4A5YGYqNND+X1lTJ5VpeAr90JnsE8JD0NdCCNc4KZMIzC7ntGIpQoRXnzecdWeGKOxto3lN8YU2qeYXbgEkkpEN1rBwTVRltTArukeplG+FcBvEsuH2D/ybbK5IisNT0CF0VZGC/8Hz/9BSOKE8tLS+VbgLyEW9D2eETXsnCs1aZbP9ENP3GeTW5Db2/AwRcYs/rkfKnqNwgni/4GZ4aUuVSUcQ8Y9pVaAk+LyvojZkbg80rjTToI3uI5p3tIS6ptcgx8lHZHZYE5OW1dOEkSWE2GT+qFRPu26bfLXr0vHGaBHVmL95bGGxn7gNTrwIKLTk/rFdMOn4iN5zpF+3H/DW/26RLbmr9unobX3hdvDIgyRjvMwiUlTbVmZ66jW7mEP74nFp5tW6YsjUk2DZqkyTBhWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(18002099003)(56012099006)(3023799007)(22082099003)(4143699003)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWgvaEJmT2ZQZ0s4NUdqSUhRWUJzdWVjY00yVE1IclQ2dXpsaDcwbnl1aGI4?=
 =?utf-8?B?QVNqR1podkRXV25DZ0xCbzl4bkJHR3diVkc2RFZUUjBLcWZvdzFzNmVWd3Zk?=
 =?utf-8?B?ZGpGVmlReTNqRUp5UHZtNll4U3hXaXBMTmZ3Y0RLN094TXRkYXVKdnE3Nyta?=
 =?utf-8?B?YlE0TGNJZ245NElmbXJlcmdZSi8wNkx5YzZxa2tkNXhyU25kZ2Q1ODNIL0sy?=
 =?utf-8?B?NWRKWjN2UFhIaldLem1TUUNFdVJtTlhKYjNJNXltMU4yNzN4VkJVVUd2cEw2?=
 =?utf-8?B?VUJBMUpGSmR3MWg1bXZGL2hGOWl5RE9KSFJLaloxZUlMU2ZHWHBmSGlJUWEz?=
 =?utf-8?B?aUo4enlSZTIrbFV2Z0treFpBazQrRnVnSWVmUzVxWTg0eUNaNFo4blpSekR5?=
 =?utf-8?B?YW04aXhyaFVxUmc5ZU1qL2EyUEZya0VERlNtWW8xblhtczExWVVVaEhGWjl4?=
 =?utf-8?B?SjVjZ2NmN0VOamVsZjY4VnoyMlU3cXk0aktpTDIzQUVDRzZhb2M5K1VIR05s?=
 =?utf-8?B?Vng2cHUvMG5FQlNzQUJPMDBSUUlpVlZMeDFWRUxTSldKRXZEN0FJMm1YaXM1?=
 =?utf-8?B?WVBUbENWbjF4akNPTXRxU2VQcEdjdkkyZ3pLSGRybHZjSGYwWGZoeVQyamxS?=
 =?utf-8?B?aXdBZXFPVEdaeXBlRGRrN3N5U2FEclhJUzBFNHZKMXVvWWJ3U25zNTBOQkxy?=
 =?utf-8?B?MTlZc2xRZVdTZDJHam4zcGlOOTQvTmZZUXkxa0tOdVNPOG1zbCtsSnpLall6?=
 =?utf-8?B?R0xBc1h6aVd4VGRHdXNDcTlZcGhwd3lLZTQvTjJFbTJTTXU5OHlmRGZEU2pm?=
 =?utf-8?B?TjhpVnZzcjA2REtFYm14dE1xTXQwSlQrY29UN1dwYVM3K1NsSFNleXFkblht?=
 =?utf-8?B?K0JjQXYyYmcrV0duS25YeVNEZXVUNkcrODNWZGswRnVtOG9rTE1iZkNkbSs2?=
 =?utf-8?B?NHpHc25GbW42U1VWbXJUZlJxTUl4SmVkenc5QUwzMFM1dzFqM21yeWRKM29r?=
 =?utf-8?B?QXBlelV6dVhSWFRYaldiOUVVajY3THpFaFVDOFduWnIwcEcvN1lzVFhCbFRr?=
 =?utf-8?B?eU5wVVpORGRxeWc2VWtBY3RUbHVEOG00Vi9nc21NYjVjQXhOcElHVE9JM0Rl?=
 =?utf-8?B?TWlvQkJobVNTMi9penExSko2QjBJd0xxQVFna2VzdnpEVDJ1cDNpd2NKOHFh?=
 =?utf-8?B?WlNTUHRIbldMRjRNSUlwYlBKWjRpVHcweGpYazZLVnR4ZCsySU1TelhCVEdX?=
 =?utf-8?B?Um1tK0JBS1Bjc2dQSTQ2bGJONjh0cHFJT1FTbUdabUtPMktVcGRWNVV2dDdI?=
 =?utf-8?B?VlQ0ZDhjVmk1em1rL25CeHRLM2RaZEtPUFpYSmtmb3RkWmNPQ0Ztay9oUG40?=
 =?utf-8?B?VkUyVDMyMml0WlAyeUtmcUM2MHlwcDg2bStUWU1EMVpFUFViOGMyRENQY1pk?=
 =?utf-8?B?NDdibVFSczdQKzVtdk4rdjhPNFpHWkRqckZYQUdOeUx2TFROWXhOb2lDWGpM?=
 =?utf-8?B?bU1rTjNGN05kaGVxN3o0d3JrN3dvYmxzL0F4bmRKaGxEZU11WnU1OWw4RGpz?=
 =?utf-8?B?MHJpTVlSQnM4aHZyRy9nYitqS2h2dzNxQTY2aFFTcEZZTkVMM0VGcFF5U3J5?=
 =?utf-8?B?NFJjMjZ1VnorL3ZRamlnaDgrLzB6OHdrcGxvS0xmNm5Qd0Nqd2dUWlQ3SFc2?=
 =?utf-8?B?ZGFPU3VtNVpsUTF3YXVaUTNSTEtuakhPUTh2cEgrUGJoZlludVNCcHpFY1Av?=
 =?utf-8?B?VXZiY2lDV3BMSVJBbUNMMVhjS0wrU3lkcWtudmZCT3cvdU4vTi9nRmdHTlYw?=
 =?utf-8?B?QVRQUnNvckJ4L0hvTFZNbTJXMUUyTUlzajNTc0MyQUVZWlNJK3NIaEFPWllL?=
 =?utf-8?B?R2dHak1YRHpiNFpPSGw3Mi85TWxVeEc4NHYxNGIvSlFXZ0hiTzdTME13eDhL?=
 =?utf-8?B?cFM2aSs1ZklnaWF3K3BNc1dwWkRjUGdRdXhRMWdSbDFqdmVRODZMWWdDZFE3?=
 =?utf-8?B?eGI2WkxJUGFNdDFyYVF1VjRCM1QrTFdhajI4RzRhVnFNK2dTeDRlNkIxQUhH?=
 =?utf-8?B?WGRpMkZXdWFlRFFuVmdiYUx5SXZtcmJUenlmc3hLUXNoZ1YveVVmOUJrUjhH?=
 =?utf-8?B?OTVqWWk2TzBRSnRIcnlzMjhoTEJqbWdxRmh4MHBVcVdiZEJFY2pZeXNGNXEx?=
 =?utf-8?B?NkRsQ0NJYnFWb3BSeVN4NERKby9FTFJJNUVKSjBBb1hkT25hZkQrb2dSaUxy?=
 =?utf-8?B?NkxPQzhoWmo5TE9pQmozQ0JDcW9CaFpFSDl5eDEzcTcrcW55dGY3TmtMcGUv?=
 =?utf-8?B?TWt4dGQ0Z2FOSkRMWi9DK1ZrOUJ0Z1VVWVN4THB1S3g2WnZrK0RzcG10dDIx?=
 =?utf-8?Q?dvF10Hdk1TgJ7v0o=3D?=
X-Exchange-RoutingPolicyChecked: Ecnkks2Q+C1pBBo/0l/WXGhvdoY5eN+6zaN9XUamxPTKF2duJxXCR24JUpDv+iI15jOm90TbStfpA66xUQ5pLnIG7IMaCuat0mLwWFhvWZPbudDk6O0SLH+MInkYwoPeO443OyFlNQsux12CaV/u/SHcfsZhj4MnQj0WisE7FpPQd7ZA5IYocmM/IFPbLUwb8VU7l4wCFbhLLck2R1ciNU8FIqZ0odCjsMETiSQ9jIDwP+a+znMornI8eWD7XdIm/f8cWDcw2NyUGloZIvZvQ4B0GMJ+CbPrj1fGe2X1WVpDcSJuEoFRTTMox3PdlTyR2UgqPmat3VZqZnm/yJeLJg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 71463b97-da6d-48db-7259-08df1a7c4279
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:41:50.6386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vg+rXpNgajAiRORkC5oUVbczMEY42uy0fQB9JcOr6fbkkkpRMOJkJipRUbNjpx9hgYKQe0vMlyToVPlp+fDWLMsvMjpLHCRGe7es70TdgHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9509
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> On a system with no L3 monitor resources it should still be possible to
> run with just AET.

This needs more context.

> 
> Update get_rdt_mon_resources() to return true based on whether the

"Update get_rdt_mon_resources() to return true" - this is obvious from the
patch. Please replace verbatim code descriptions with high level
descriptions and include _why_ the change is made.

> system supports monitoring rather than on the presence of any of the
> L3 monitor features.
> 
> Refuse to mount the resctrl file system if there are no monitoring or
> control features.  Add invalfc() to rdt_get_tree() so the console log will
> let the user know why the mount failed.

This is obvious from the patch.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e46eb9a4c725..d70c8cb1cb81 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -226,7 +226,7 @@ union l3_qos_abmc_cfg {
>  
>  void rdt_ctrl_update(void *arg);
>  
> -int rdt_get_l3_mon_config(struct rdt_resource *r);
> +void rdt_get_l3_mon_config(struct rdt_resource *r);
>  
>  bool rdt_cpu_has(int flag);
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index e633da548959..addcb2a19c98 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -991,7 +991,7 @@ static __init bool get_rdt_alloc_resources(void)
>  static __init bool get_rdt_mon_resources(void)
>  {
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> -	bool ret = false;
> +	bool l3_mon_found = false;
>  
>  	/* Any monitoring at all? */
>  	if (!cpu_feature_enabled(X86_FEATURE_CQM))
> @@ -1001,27 +1001,29 @@ static __init bool get_rdt_mon_resources(void)
>  
>  	/* Any of the L3 monitoring features? */
>  	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
> -		return false;
> +		goto skip_l3_feature_checks;

This goto looks unnecessary. Why not just "return true"? Even so, this 
also changes behavior from the previous version in a way that is not clear
to me. I was expecting this to consider the number of RMIDs supported by the system,
now that this function added:

	pqr_assoc_num_rmid = cpuid_ebx(0xf) + 1;

Should this be:

	if (!cpu_feature_enabled(X86_FEATURE_CQM_LLC))
		return pqr_assoc_num_rmid > 1;

Although ... looking at this closer it does look strange for pqr_assoc_num_rmid
to be 1, thus reflecting that the system supports one RMID, when zero may be more
accurate?

>  
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
>  		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
> -		ret = true;
> +		l3_mon_found = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
>  		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
> -		ret = true;
> +		l3_mon_found = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
>  		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
> -		ret = true;
> +		l3_mon_found = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_ABMC))
> -		ret = true;
> +		l3_mon_found = true;
>  
> -	if (!ret)
> -		return false;
> +	if (l3_mon_found)
> +		rdt_get_l3_mon_config(r);
>  
> -	return !rdt_get_l3_mon_config(r);
> +skip_l3_feature_checks:
> +	/* Even if there are no L3 monitor events, AET might be supported */
> +	return true;

Is it guaranteed that system can support AET at this point? Previous version used 
supported RMIDs (return resctrl_arch_system_max_rmid_idx() > 0) as return value and
it is not clear to my why that changed in this version. Although, when looking at this
check it looks more like this series blurs "maximum index" vs "maximum number of RMIDs".
For example, resctrl_arch_system_max_rmid_idx() appears to reflect the highest RMID
index but it returns pqr_assoc_num_rmid that reflects the highest number of RMIDs.
This series should take care to make the distinction clear to avoid (now or future)
issues introduced because of different interpretations.

Reinette
