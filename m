Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EA186250
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 04:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749009758; cv=fail; b=PwiVTghx1HzrEcUzIc0tbTXrm0/iUZnG4SFxFvYAC4CNOfpUtyjLW3NFBOvOE3UhNWUDwCzR2u7qrM0jIVFg5la206E7OR33Al1y938J15fLvvpuJrjxk0jQfv6EN+0fGnRm9BCSSevmko+vnBap5DnjGp0Qsr4UVTOted3SCxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749009758; c=relaxed/simple;
	bh=V+z7sRDR1qTZoK31J6Aj1ZdP253cO4SP6+LrNifuaXk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mdy97g9FmlwHPFrtcUBTs/7x3mUCbMUpkRoIHl5D7gcl7qP+/Oj+YLiCvE0i9OYTcKeGuBinzKImNJ5lH+mC/8QFSe3YvkOz/LSJfnZcftB+RDkL/eiR6UqClGpSwo/m0/Nch5bC2XuEFWWMR+X5hE50kR0pJw726EHhonuacs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aeqsYRoW; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aeqsYRoW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749009755; x=1780545755;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V+z7sRDR1qTZoK31J6Aj1ZdP253cO4SP6+LrNifuaXk=;
  b=aeqsYRoWwF5NBW0QZrkVhhz3rKYsQS0/hrLWFONOzaezKGdkTbOMwo1k
   OUXehZjAaww8rTh+EQtXHu3EcoScGdNafH+I/Z7eZ4b3lunONQe2lS+dL
   uB9Dq4XKVnTd2rWO0PSQaqLAELC/O76vdyKnexT0EamBR5zkOLDFOFVPU
   OUClvV8lT5wGaucn+fi7M9z5kkyTS+gd2YnZoP08ZAbT6w6SRROdiN1pb
   v+ZvbdnlMq3DsviO2ixueOMKK7uR68tebR4XmWnGvwM855mWNNMtOwKlx
   LylGp1tXAfIe2eWtwNG+KNUsJQPHB+NBQgxyLV+EfS+xowlx7hmZiNM/f
   Q==;
X-CSE-ConnectionGUID: ydIpzMrgSIWpC4McTpqChg==
X-CSE-MsgGUID: Ia1B2JHnRa2Wj9+yDqvqJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="73604552"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="73604552"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:02:34 -0700
X-CSE-ConnectionGUID: zZfvMU+3TT2+E9KvXTR02A==
X-CSE-MsgGUID: SHIACUZuS0Wk/6BmOXB5xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="145077261"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:02:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 21:02:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 21:02:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.80)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 21:02:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzIaRBIBtzt2C5fxq/UWARpmjzEu87C5Pq6DLaQbPjyd7vVJaD/1UKapFuDu2Si6R7OWAel+abIojhfGxAY9bZGTEGEfv6FPBjL2uF1Ggc/VY4fQHNGnZkNlKB6InkRQ2Gr1o4nDMjX8tLsctLXvbqhZu+i+2yuMxmX+KQYyWfqGWXxizeKgZTB3BPkyFdP74ePrtGpI0f3CZS9HH4A6UrzR509QbAnMtbTaYwjoWcsAsmkMoeiWqFSlKWDqF7wbwvgxBihMSMxJHYUJHPD04Vt1o7vQYhYt3VjFxFXszJx1eoNj70sG/65bXDXwHn2jWWOhpUw3Jh1Ps2ZpP4Kmkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkvdFHhICVqAcnNZDl89wTRmX6pgUu1YpaHZNg4c14w=;
 b=wvaLnNHuDOTMRLubVRh/kJoPiywH2iFGQ0dgUo3LGzoJc4Zvyh+JWwyqDP9uf1bXcifAVkLnC2G42WcMN4m3Fsc7z7lW4WoLU93XCBoX+j2CL95sISegXTpD6x/fM5pdYa2BhOPtqy6Qj02MGvwaAnH56XlaBpAXAlQcJC09vpwhLuz2vDPGzWWGQ6pdpdddiCfjiVVU9N/6uD1sORcsZqXEVVCH3KQ5mnMkssadgmz/nnMWCmvNfrRyDH0UeCqg8/cm7ptsajAF8mTzubisQx0z638HIvx4X3gVCyP8Iv4qv5SMFodbQIoKDw2/rFj+zw9/aylkVD0zNAsKSY2lZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4515.namprd11.prod.outlook.com (2603:10b6:5:2a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 04:02:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 04:02:30 +0000
Message-ID: <bdeab410-df46-42a6-8dff-89e082178245@intel.com>
Date: Tue, 3 Jun 2025 21:02:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 21/29] x86/resctrl: x86/resctrl: Read core telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-22-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250521225049.132551-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0091.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4515:EE_
X-MS-Office365-Filtering-Correlation-Id: 38b216c2-c7c9-4d7d-97cf-08dda31ca097
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|13003099007|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OFd5V2J4clhSb2tpdUcrbXhiMUVIZ0ZKeW4xeHRqNWZKSUVLQW9UbGwxZDE1?=
 =?utf-8?B?M0Q0MGdiR3czSUo1UlNIdjhZNTVTMmVXby92K0xFb1dCYzlUT0lCMCs5S0kw?=
 =?utf-8?B?bmpFOEdiMzFpOTQ4bXhoY2lIM0tld2h5VHlJV3pXL0ZlbUlHRk1hY3dlcWtE?=
 =?utf-8?B?MUNLQWFVYjMwOVY1NlowSlJWSzBqUGl1UjVtcWRHcG9YN2JLc3NxRlJzRTRW?=
 =?utf-8?B?cDN2UGRkQVZXQ3JidHd3Njd6TmpuZm1aN2VVZEJPN0xLeFZSUm00UXZHUHRV?=
 =?utf-8?B?dVZTS0FiMHk2WHVyMU5qOFArdEM5NTJlcXo0T2dldTBDR3RvbUtSYmV4KzRn?=
 =?utf-8?B?bDNJUk9TR3hoTDZzMXhsS0RQaTNlMHFxWGNxcGpZVGhKWUQ1S1VRT3FOY3hC?=
 =?utf-8?B?MGZQSTU4UW1ZbGluY3lKbWI2UlhOdThOYndqQ1NIV0RxVEZJYTdueGZ6SWRa?=
 =?utf-8?B?MzAyVU02WkpyUTltL28zMlNLUDNmUXpJdDZSQ1Nkc1lxeUdiQXBoaTF6d1p1?=
 =?utf-8?B?V01XbWNLYmF6N2ZicFM5dWxDZHVIZXNEZmFMaVdzMzBZTUl4cC94QyttZlZF?=
 =?utf-8?B?c29ocXlaT0JUdVlOSG5iQ1E0TzRaVWs3KzRUWlpwNzNSWWx2YjhYbmhaTDBx?=
 =?utf-8?B?NlpCS29Da2lzS3AvK0U5aUEyZ2xZMk1KVzdYWGtYUERvMDhMMkpiZE41Uzgv?=
 =?utf-8?B?VjFmRzNlRzFZUW1HRFBwMm9leGppbnRBcHY1STcraXg0a3pqRmZ3aCszV3Ry?=
 =?utf-8?B?dml1eUI3Tk5CRUptZmswK2ZrdU5HN0hzYjZkaHRldXdpelZxTTJYd3F0RFRZ?=
 =?utf-8?B?T2V1L1I2QWlCYmRLSTRjZkdja3J5SlFobkZsZVpTZU0wdlh2elVzQWc4SUNN?=
 =?utf-8?B?KzR6SE93d2RaNmRPM0xBK05INFBhQ0ZtZGtjUzQyMDdWcGRtNndZazFiSFNu?=
 =?utf-8?B?a2JKZHVJUjNKT0IwQU1SZjZCMFE4ZklETFA0N294M0JyZllMSkVMSlpjbkJ3?=
 =?utf-8?B?T2pMcDNLMENYSzZLc0MxcFJLOElYRnZzUm40aldtRWlCTnBVNkoyNVBCUUs3?=
 =?utf-8?B?eDlkcnVUUVhXYzI4V1hKSGptZmUzU29QQU1mQ3A2eWhoRDdES0RLU0cxTDR6?=
 =?utf-8?B?Zis0WWRaOTZZd2hBWUQweUN5bXRsVHBYSW9CMEJFTERqa3MvSUR4VFBMa3Fa?=
 =?utf-8?B?ZUdodHYyN0tZM05SV0NTSHdDRmp2MnZHSjBDWC91YVZ0RDJLa1VKYUUxM1pu?=
 =?utf-8?B?Snk2aGo5bkhTN2VKdEJ0dFpkd3FtTmRxbVVLRXBTWGlkNlNuclBjT1FLWmgv?=
 =?utf-8?B?N2xHdkhsZ2VYejNKdUpYaitHQ3pFQnFkMlZmenRCUDF2V0xtVzMyajFDV2VQ?=
 =?utf-8?B?YjRMbnNYd3M2RGVTb05qRThnM2JsNTI2dW1BZmJsVXBMcXdMbmFpTDZxbDg1?=
 =?utf-8?B?MkNOWkM1Z3dncFVuMEVtL1k5amtlOHlFWW12c2pFbzE5aFpnTkhPSWpWYzNm?=
 =?utf-8?B?aWsrRTJpSG5kK0pUOFdpU29EbkNtS0FUSk9yMmUxSTc5V2creGEwRFNjZFJ3?=
 =?utf-8?B?c0s3Z2hMc25LS2hMTFhBekliS3VzVWRkTUU2L2Q5d0hjK0FFcVRhR3dXLzk3?=
 =?utf-8?B?cmp6c1lKT2VLV0JXSlV3RnZVbTc5TEZBaC9IdjVkdTQrTkZ5bWczNDY2dGtH?=
 =?utf-8?B?c2ZPU3dudkljbldoZitOajd6Q0lKQnMvZVNaYXNvS3kxQUNtTS9kTUxZNTAr?=
 =?utf-8?B?VXArR2d4b2h6TFc0QUhKdWd6REw1MUNPS2t1UXFMdDhObW1iRlZyK0NMNXhP?=
 =?utf-8?B?UkIzNDVZV3duWXhSVWJ6VjZxUHRVOVM1R0dvblFJblhEb1ZFbDA5V2dFQTRq?=
 =?utf-8?B?OVJZaVpuRWpKNG5KVUlzR0hwN1JnaUVIR0VuMkpLcFhWWFlobjJNbUtrOGNC?=
 =?utf-8?B?K2E1azhlMFBHek9sMWpOZzhhUFFmOHo5Z21xU0tyOXF0MmRUcDloRnduK25E?=
 =?utf-8?Q?JB7TgugiUpDf96hlmIvZrzgmOgQX3w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnNTVUVNRTRleEpBaGIzRWFGZlk1SXJQTTkvY1BHMHVXRXFnWTBISHdjb0lp?=
 =?utf-8?B?anh1VWlGNWVvOWJDTjNSdkI1TE1GcDZrbWF2QlQ0S0pyZE01WWQyVllxRk1t?=
 =?utf-8?B?YmMwM0RxV3R2Z3dlbVk0WlljOURIZ1RkeXk1M2tkODVjSnFneUhFTWtaUCt6?=
 =?utf-8?B?aEduYkVBVkh3VmRvbzRNL2JDM2drWHI5cmttbndYWWFGcTBXSG5zNzV1bnE2?=
 =?utf-8?B?SDJINisxQ3psRFlCQkZ0WVhaOUdJbUhKenI4RkdSYTlHSzI1N0szY3VuTzZT?=
 =?utf-8?B?KzljS0ttOFd5aXNUOTZmWXVYVElSUUw4OTlxYWNqeTlRbkNqcjQ0M3hsdjYy?=
 =?utf-8?B?b0l3YXpBSWV4Q1cwbzR4Q1JUZnVUb0RIVVl4SVkvc0tLWC9MWEV5VHZjcXIz?=
 =?utf-8?B?K1lhYTJPNS8rUzJ2bEFNbEpScmkzRVhoME4rcmxKRmlSZEVQZjdFb3JDRHhu?=
 =?utf-8?B?Y0JrdE9Eeis5VnhGNXF3SzNFN2VQUTZDU0RtdkN3Sjd1Mi9rN3RnWm01UFh3?=
 =?utf-8?B?ZU85TXVITW82cm9IelQ5anRYcFNZV083N1ZLWmNhTWNucnlsUm5ITHZQM25X?=
 =?utf-8?B?eU45T2RtYjIzQkpoK1duWUJ5cWZuY2dZemxXNW5WR2pQZjVPK1lWVEFzSUdy?=
 =?utf-8?B?OXdIdmwrUWtQOGd2VDh0elViRjVQOW5tWE1XbGlyaTc5WmpNenQyck0wclJl?=
 =?utf-8?B?ZU1wRXl4dG9OVm04K0FtR0FjdCtDMk1wTHNST1lkK3VvV1RTOVJHcVEvZ1Iv?=
 =?utf-8?B?endRaFNmQlQzdE9yRHJ4L1BVdTVHNTg4Q09LTDBTYThTMDBaNFc4VFZvSnNq?=
 =?utf-8?B?NGNlS1BxTi91dHJZYUJYeWk0OEZFWVc4TEJRMEZ5R29DdVhYVE9zM2pLNUhF?=
 =?utf-8?B?am1rbXJ1MFFmUG0za252RmdoSGQyK2JPQ0NPeGN1NjBGWnZIYzRtT2wySWQ5?=
 =?utf-8?B?a3hNd0JnMG9NYnpWK3RjOTcxWS9vcmcrcGozUW1LdEJMQ3loVVF6TnpDcFpj?=
 =?utf-8?B?RlhqeThrUXlDMGlBeWNsWng0ejMwbDdwZlo3RFY1V014R3FJWnpWSHlXcTg2?=
 =?utf-8?B?Qlc2bVFCNzJRelNZM041UWl3Z0FMT0ViWFp2VDRtRjh3L2t5ZDYxZlBRSXNQ?=
 =?utf-8?B?Y00xdk9PZDM5OGpxS1cxQTdEMEU0cXBLN25lbU9sYWtFZzIyV3dNVXdBR2t5?=
 =?utf-8?B?aWhNeDFxV2N5blN0czR0WFprMEN4VTZWMjVKOHhKNzFHK1h1TXFjY05Ga01D?=
 =?utf-8?B?NjBTRE9zcDhSSWhjN0hSYWFtUWZLNmVHaXdPLzdFeUN6VUFWVlV4N3VJQTZQ?=
 =?utf-8?B?MFgxdFlIVmhFSmtaMDVPZnlkY1VkUm53U1dlWkRIaG1iamJLNXJxR2hKd1pE?=
 =?utf-8?B?Zk42VUlLSlE4dTFlWDNVVks4VnZFWURXZFBmU0U1cUIrM1Jib3ZkZ0swVzVT?=
 =?utf-8?B?MktTN0hJVUN6TFpRd0JqbVVzc1Zva3M3emtkbit4dUF6Y0FheFE5MWdtTFlR?=
 =?utf-8?B?WWpnWTYxa2E4Ym01RFRNSXdRVjFtUXFKZG45ZEVjNTQ2bWhZQmFTVVUvSzhU?=
 =?utf-8?B?SVYwZU9WR0lTenE4STczelZGbWlhZWJFT0VWWkUremFadFN2ajRaOTJEN2ww?=
 =?utf-8?B?MVpYWWY0Q2ppdWJOTEFwWDY3YTZZREFSUUQ5b1llVVVEd3B3ZW11WFJDT04x?=
 =?utf-8?B?RllDZDFRNnp6R0dZRmtlQ2tScldZMGNxVUFEa3JVVEM2ZDZKSVF1TktvT0pR?=
 =?utf-8?B?NDNFbjFFNmpWWTlpTU1XN0VOcW5tcm1Rd2U0NE9CMUEveExlSlpLQTA5TmtH?=
 =?utf-8?B?cnIyWmNoUTVCeXRMT2xRYW11cmFrRGZ3TnRRcE5xejhxQ3YwcmxYUncwZGpQ?=
 =?utf-8?B?RkRQYjl5akxPZ0c2MjQzZ21FRDJSdXB3UzdBdWtpSFNHWk9rb0dIUllMUGRT?=
 =?utf-8?B?MTFGY2xjWWZHZkRuNnBwTExoNjIyL2FNSTFsakNuWER6WS9sK2NZQ1g3QXM3?=
 =?utf-8?B?ZWtQMytlT3Z3clpYWERJVHJtdWFZaDhBdU1rTGRmaXRURm9hM2kraWY5OU1F?=
 =?utf-8?B?c01TU3dUeXNzUHJvcURNYzd2NVlvYkNQa0FCY2FSak5ka3BzYVVlVXZkbHpN?=
 =?utf-8?B?Q3VSdjdvV1lZekt2NzdhSjhxQmJ6ZkRRbVNLaEVDYkdla1lJcHJSUmRwZE9X?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38b216c2-c7c9-4d7d-97cf-08dda31ca097
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 04:02:30.6352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8N+fJR+hysppaxGHkil4nhPN8Df7C9FtdN9WNy++srbS++GR8tnKxXU/gc6Gzg8WxBUoacSC6Of5IE3dqooKWOkjfzCq4Z7OLf2OpfPIxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4515
X-OriginatorOrg: intel.com

Hi Tony,

shortlog has a duplicate "x86/resctrl"

On 5/21/25 3:50 PM, Tony Luck wrote:
> The resctrl file system passes requests to read event monitor files to
> the architecture resctrl_arch_rmid_read() to collect values
> from hardware counters.
> 
> Use the resctrl resource to differentiate between calls to read legacy
> L3 events from the new telemetry events (which are attached to
> RDT_RESOURCE_PERF_PKG).
> 
> There may be multiple aggregators tracking each package, so scan all of
> them and add up all counters.
> 
> At run time when a user reads an event file the file system code
> provides the enum resctrl_event_id for the event.
> 
> Create a lookup table indexed by event id to provide the telem_entry
> structure and the event index into MMIO space.

First time asking whether the lookup table is needed:
V3: https://lore.kernel.org/lkml/7bb97892-16fd-49c5-90f0-223526ebdf4c@intel.com/

Reminder in V4 that question about need for lookup table is still unanswered:
https://lore.kernel.org/lkml/54291845-a964-4d6a-948c-6d6b14a705dd@intel.com/

Here goes my third attempt:
I still feel that a new lookup table is unnecessary. Looking at the new
structure introduced it unnecessarily duplicates the idx value from
struct pmt_event. As I proposed before, what if struct mon_evt gets
a void *priv that the architecture can set during event enable? resctrl
fs can then provide this pointer back to arch code when user attempts
to read the event.

In this implementation it looks like this void *priv of an event could
point to the event's struct pmt_event entry. The only thing that is missing
is the struct event_group pointer. Looking at previous patch every struct
pmt_event has a sequential index that makes it possible to determine &evts[0]
from any of the struct pmt_event pointers, enabling the use of
container_of() to determine the struct event_group pointer. What do you think?

I surely may be missing something, when I do, please use it as a teaching moment
instead of ignoring me. I spend a lot of time studying your work with the
goal to provide useful feedback. For this feedback to just be ignored makes me
feel like I am wasting my time.

> Enable the events marked as readable from any CPU.
> 
> Resctrl now uses readq() so depends on X86_64. Update Kconfig.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |  1 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 53 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  6 +++
>  arch/x86/Kconfig                        |  2 +-
>  4 files changed, 61 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 2b2d4b5a4643..42da0a222c7c 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -169,5 +169,6 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val);
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index bf8e2a6126d2..be52c9302a80 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
> +#include <linux/io.h>
>  #include <linux/resctrl.h>
>  #include <linux/slab.h>
>  
> @@ -128,6 +129,16 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
>  	return false;
>  }
>  
> +/**
> + * struct evtinfo - lookup table from resctrl_event_id to useful information
> + * @event_group:	Pointer to the telem_entry structure for this event

My V4 question about "telem_entry structure" is still unanswered (note that changelog
also refers to "telem_entry structure):
https://lore.kernel.org/lkml/54291845-a964-4d6a-948c-6d6b14a705dd@intel.com/

After I apply this series I see:
$ git grep telem_entry
arch/x86/kernel/cpu/resctrl/intel_aet.c: * @event_group:        Pointer to the telem_entry structure for this event

This is thus the only reference to "telem_entry" and I thus still
have the same question.

> + * @idx:		Counter index within each per-RMID block of counters
> + */
> +static struct evtinfo {
> +	struct event_group	*event_group;
> +	int			idx;
> +} evtinfo[QOS_NUM_EVENTS];
> +
>  static void free_mmio_info(struct mmio_info **mmi)
>  {
>  	int num_pkgs = topology_max_packages();
> @@ -199,6 +210,15 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  	}
>  	e->pkginfo = no_free_ptr(pkginfo);
>  
> +	for (int i = 0; i < e->num_events; i++) {
> +		enum resctrl_event_id evt;
> +
> +		evt = e->evts[i].evtid;
> +		evtinfo[evt].event_group = e;
> +		evtinfo[evt].idx = e->evts[i].evt_idx;
> +		resctrl_enable_mon_event(evt, true, e->evts[i].bin_bits);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -266,3 +286,36 @@ void __exit intel_aet_exit(void)
>  		free_mmio_info((*peg)->pkginfo);
>  	}
>  }
> +
> +#define DATA_VALID	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain).
> + */
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid, u64 *val)
> +{
> +	struct evtinfo *info = &evtinfo[evtid];
> +	struct mmio_info *mmi;
> +	u64 evtcount;
> +	int idx;
> +
> +	idx = rmid * info->event_group->num_events;
> +	idx += info->idx;
> +	mmi = info->event_group->pkginfo[domid];
> +
> +	if (idx * sizeof(u64) + sizeof(u64) > info->event_group->mmio_size) {
> +		pr_warn_once("MMIO index %d out of range\n", idx);
> +		return -EIO;
> +	}
> +
> +	for (int i = 0; i < mmi->count; i++) {
> +		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
> +		if (!(evtcount & DATA_VALID))
> +			return -EINVAL;
> +		*val += evtcount & DATA_BITS;
> +	}
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 1f6dc253112f..c99aa9dacfd8 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -230,6 +230,12 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>  
>  	resctrl_arch_rmid_read_context_check();
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG)
> +		return intel_aet_read_event(d->hdr.id, rmid, eventid, val);
> +

This does not look right. As per the heading the function changed has the following signature:

int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d, 
			   u32 unused, u32 rmid, enum resctrl_event_id eventid, 
			   u64 *val, void *ignored) 

The domain provided to the function is a pointer to a struct rdt_l3_mon_domain
so seeing this "r->rid == RDT_RESOURCE_PERF_PKG" test is unexpected because a
domain with type struct rdt_l3_mon_domain should not belong to a PERF_PKG resource.

Looks like that whole stack starting from rdtgroup_mondata_show() needs a second
look. Review of this work has not been going well and the skeptic in me is now
starting to think that the answer to my earlier question about why only a
subset of L3 resource specific functions are renamed is: "because if all L3
specific functions are renamed then it will be easier for reviewer to notice
when L3 specific functions are (ab)used for the PERF_PKG resource."

This extends to the data structures, the new events rely
on rdtgroup_mondata_show() to query the data and in turn rdtgroup_mondata_show()
relies on struct rmid_read that only has one domain pointer and it is to
struct rdt_l3_mon_domain.

> +	if (r->rid != RDT_RESOURCE_L3)
> +		return -EIO;
> +
>  	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>  	ret = __rmid_read_phys(prmid, eventid, &msr_val);
>  	if (ret)
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 52cfb69c343f..24df3f04a115 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -506,7 +506,7 @@ config X86_MPPARSE
>  
>  config X86_CPU_RESCTRL
>  	bool "x86 CPU resource control support"
> -	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
> +	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
>  	depends on MISC_FILESYSTEMS
>  	select ARCH_HAS_CPU_RESCTRL
>  	select RESCTRL_FS

Reinette
