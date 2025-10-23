Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663E01547F2
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761193083; cv=fail; b=bsOQ6AiDR0p3s641Ozi9+rqFaJJVwfxvTKEQbwH3Ow5kbqjiFuxEfVs9Gb7ZeTHRsIoAkU7X2eywiYm7B95VVlF+MdsUBgVK8NL+BKg/lbL+B+t36qLqsaOetYRiaFU75PqjteADuB/S+lKfEGTbHfWTcmvR+Hr9unZTkGygf3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761193083; c=relaxed/simple;
	bh=ysf62tNnqrv5x9DolLdZOuWg/Sxgeu4wufyMWyDFINc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nlW2bVdkFOet50rJQeCb/qi8PbZ6rjO9k211x0q9wQpXfY3rvJKhySyN0vVGoNP7WsNHR1nHaG06K1CLva/rbkJtdxJvsfEwkmsNcF9KReoA26z4n9AGph31m05JqsJ7ag8LneFZs4moGaBFm4r0ToR4/K02CVRpMF8aM5Hcu94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kT5/KL14; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kT5/KL14"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761193081; x=1792729081;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ysf62tNnqrv5x9DolLdZOuWg/Sxgeu4wufyMWyDFINc=;
  b=kT5/KL14ir5636dLSWxjlweVaP6ThKvZ4hUjED/EJw1v4JuHJS311RZ/
   29DFJtxI9T5rqFbP4uQh5cM7IAh+S0eRsHZlfgpRcgvIOIIfASYnVHg5A
   7d3cvWJeEp4s378HfwXgV3fNJ8ouHMWrOMy9DA+8FowgkWzBUZoZsNfcC
   JhU0rx9GOruADwVIrXZwDxVQvWoT+izAbdeArwSNKCRuqL4p/DJMW7Ckc
   ljzi6pfW5r2tb0nlPO1HpgOYNcwmhHFUJkp1g8b/msQ2FWAqCNZ92dqR/
   ZN+7ZccxLBxaWa+Q0tZbIjrQsnxMuE4+9xMtTIwQewPJaHTaJgYsg4LkW
   Q==;
X-CSE-ConnectionGUID: fpy6ki6XRHaKqnNxqqrWyg==
X-CSE-MsgGUID: WXsoBMP4Q/Knoru7sSjgIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74699243"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="74699243"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:17:59 -0700
X-CSE-ConnectionGUID: oUwc0ljyTMi/sJikLdNTtg==
X-CSE-MsgGUID: 7LZiJoH0Qx6KOwjOV626ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="207710531"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:17:59 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:17:59 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:17:59 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.12) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:17:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D6AEefRZXfr7L2m7QlXlTHEte5t2AAJzxMADlTFB3Be+bG+f6VnbdDwITK2vN0HddphKbEYkN7sB9Ercjbou0KFaakOhFVdHKAi4niwfzMkUHiaOhuP7bFd5/tHjjROIZ1V1+gx0QNuayP+wJHq2G+YKrZYw38AMjh5enxl+iBH+RiZ/G4sLyJTMdaYWkyYtg8DDHRd90SeR353xZoWjWiqzOZaL0DULhzS8Vc5lQ0QvI61+d0Gs0mMIHCtkRsUe3mFvLjkXNiCvd4+0jRt25cGk2VwEAazmBZSN7GAlHPjtXfs4UmRp9DDH4VeohPexMHAz6LVsVx9KQiljoDDmNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJnowjCIEqivcmLR+y9UUWwd08Z1cdGDpVEwPq/js/o=;
 b=rkLfMkllM4B2kYaAlzXxrMC+/ScyIZPT2GrfDPo5nwJ8WpX1mUGPvBygaxOckdJr+LjGuE8Q4Z+7Cc5C4TWySA1Ju4RNd8i44iBmrWEpkXE0tK9A11LwodGs2lxxBXzylqUQT65iTbyQYi4EhqKxBJfj9XTUDhW1iCElnbKzPjW0hhXJfKu/OjllhMCzHta4PhOXgXv0NKc0gjd5eKarOEU5LJmhFQXR2p6lBi5cERtnf2PYgs/GVmKePVWpn1FOvqmXUqV+MGX84mjbwIJ0ZLc3WJB9KbJPtsIfxf6f/+s9lK1EkrxGuhQYq4Zv+E+V56n5R95rNCeZj/clntVVkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB5965.namprd11.prod.outlook.com (2603:10b6:8:70::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:17:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:17:56 +0000
Message-ID: <8f97f875-f032-4a87-9b37-9dbae2537b6a@intel.com>
Date: Wed, 22 Oct 2025 21:17:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/31] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0358.namprd03.prod.outlook.com
 (2603:10b6:303:dc::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b35595d-6990-48b4-4eb2-08de11eb2482
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0dIaFI3bG8ySUtaVGU2TmdDZzNEd1NlQVpaNkZScVBZdGJaeTNpYUdTWlBR?=
 =?utf-8?B?UVRhdVpmaHhBeTdDdDF1eWo5NXJXcExxWmJvZFNVcE1UOS9lLysvOUFJYmg0?=
 =?utf-8?B?WHUvcTRvdXh4NEF0UVdSc2NqazlGcVZIakhOTUkwZEk5d2tYaGFwUE0wd1VH?=
 =?utf-8?B?YjZYSU9nQ2FCTXdEdnhKdWhkalZpck13dk1kSEdaQ055NTZvaVd2eTREczlS?=
 =?utf-8?B?eTArS1VQK01VQzBSMXJtb21wMkNNSW4reFo0aC9GdnovTXY2dFh2UTZ1K1E4?=
 =?utf-8?B?QTgvSzBqZVlSR2hpUUZSYkxOdnVXSG5TckhTRmowT0YxaUtFTjVVK3VVRGtF?=
 =?utf-8?B?SXhxM1ppU3ExYlpiWFJRMXlKcW5DTnA0aWptN2o0RUNxNDljVDNiYlZ2YUl0?=
 =?utf-8?B?MmdFa0EzVVlCS242MlNjZyt6OVh6T0FRT0FMUjZaMG1TRGdTR2pDMkZtWDlt?=
 =?utf-8?B?VXZPRkFsSXNLM0IzVmpheFFwdnZaYkZ4TldFQThpSG43emRvanU2YTBaSEdr?=
 =?utf-8?B?MHY1TXJERHp2blJYZjFMTjJZdmxFYWx4OEpMWEtrRCtQNkhiTklqMWhtQW4r?=
 =?utf-8?B?SWl1U3U1Tm9FZk5vYUs3QWFwNGlmVzljbzZlUDlKaXBpS05yRlFvSzcrazhD?=
 =?utf-8?B?MWpnSmxhaWdKQ3oxUWo4c3NpeVNLY0JtTjVWK0xnMWNHT1k2TVdadWt6bWJh?=
 =?utf-8?B?cnhhOFB2N1hDRDBwS1JlSnZnMnVOdGFQd0RiSHBoRXV1VFpHaUQ0akJTUXhu?=
 =?utf-8?B?SmJ3UFl2dnRDaTlCN1JZaEpnaktCNGhwbm42VmRHOEhHOVNpTVpGdUJVbHBP?=
 =?utf-8?B?cDZCVWJZY2xxa0pSYkJJbTFQQjlXcmJOcVI1eUZBQTlLT3Y3NzRCRlgzbWxa?=
 =?utf-8?B?S0NtS0dPc3hvUmhhbHB0K042MnBOcjh2enZNZE9WZTBYeHZWcjFjWjI2YjhV?=
 =?utf-8?B?aHd6TnhHYzEvamZBM0JUYWY4MmQzZUJ5amdIVUV0aG8rQ1VrRm92RCtJTWR2?=
 =?utf-8?B?bWFUU0tqbEF0V2F4YTRLNVdHVERSYzNRMFkzL0pWTzVaTzY4NS9hRDNwUTFv?=
 =?utf-8?B?djVTZnNReE5lOC9GT1phUmtUQjBjQXV1OU9yYzJ6UDZqdHRjMkxlOENrZzh3?=
 =?utf-8?B?cnEvc1ZwMXBlOWcvSVJuSGcvdk9uRUFDN3p2ZFBYeG5BTFBGSldrVDE5bldn?=
 =?utf-8?B?Yy9hdks5YmRrUmNiTGUzdk1TUWhtczhXakYzSGxmQzVIeGJGZVE3YndyUUw1?=
 =?utf-8?B?VDRNbGZONHZ4aWpLbTd6b0RIWU5IM25XQlFMZ1JvTURSd0lVWlQ4Q3ptWlJT?=
 =?utf-8?B?VVA5a3FhRjBJWmtMbmFPQXpLT3ZrMzJ3L2F6MGY3SG9kR0VDRk5GT0ZZU1ZU?=
 =?utf-8?B?Ymo3bU9JVVVOeitidW9oMkNxajZsR2pUVFc1d29WbFBRaVEwR0kyM2l5S0tR?=
 =?utf-8?B?bjVIZ3RDTVdYdEhJRkN6aDJJT3hkeXE5akIwRGhNNGhVSHhxc0RwVkRrVVpG?=
 =?utf-8?B?dWYvV243bFM5MEx6WkxVQW5TVHozQlZ4dzlkaE5MSUE2QzJ2NGY3ckU0b0hU?=
 =?utf-8?B?YVVNSnZLcUFpNUltU1lnblBHc0pDWk5wZHdYZVdackFITWI4T2d1VjZNZXY4?=
 =?utf-8?B?YndNYldLTHNXVGVaRFhLdCtyQnlsWFkwUzJ2SHkwNEFvQkZmS3lKU1F5MHZI?=
 =?utf-8?B?aFM2aHNnVFBzQUdTWEdUaEtwQWdxUi9JcFlweitCL3djVDlsQzJxYmw4RzRK?=
 =?utf-8?B?U3gyU0J1YXhrdTlMM2xSY04xWXB6QVZrUXo2VDNyMzYxQ1B0TndNVFlCRGpi?=
 =?utf-8?B?dGxsMHN3eUQrK2JrOWpDM0VVNFFiNm0wSzMrbVdSWERQb3hQaEY3WVlwWk50?=
 =?utf-8?B?ck84TjRYV1N4NlR0dHgzeWZUYUV0cHo1UTFYQ2V6RERWSTk0bWpJMHpWU28y?=
 =?utf-8?Q?4WL74w3d4Of5wToHZnh/Gt6iqxUcgTBE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2FXVFRsTFhYZ1QvVzk4N1ZhRzJVUEpjbythUk1zTHFQYjR3a2p6T3pQMTBu?=
 =?utf-8?B?MmtyaDJsbnlRMmNBTHZ0VUwrV0ZHRzAvcVRiKzgzakE1TzhFd0Z4Zm1ZTXl2?=
 =?utf-8?B?MXhsTGc1ZFRVRmtOSVNXSDRDS3JBZlFIVndocnYxU0NYSEh1bXF4eE12Q1FP?=
 =?utf-8?B?QzJYWEdmcTFjeC9TVEpnbFZVRXk5QythNk0zcW9USWo0aXQ2NU9mWFNXeTNO?=
 =?utf-8?B?T2EreVdScVZGQkFVUmhMVWVuQWF6ZHB3dStHa3VhYmVSK21YM1hlQXh4cHJW?=
 =?utf-8?B?MXFQaG1qci9qNHlFRFkvek5KTzY2UGkyRFNnK1poMElnU3R5enZRZFZWUzcw?=
 =?utf-8?B?eUdCUS9Fa2RyRUhvM1dPakU0ZHp6NktZaDA2SXlKa0pRb1hWK3FDdVlBbG5L?=
 =?utf-8?B?YzdvRVlJVjcxWTVUcHBvNFRBZFpSdFdjbDNNczdRcWZOVUlTaU9kTVpEN0Z2?=
 =?utf-8?B?V1htRm1acEJZcXpWaHA5ZTdyZS9rNTErNGlDRVhiWTEvelNEbVY3ZEdKUFds?=
 =?utf-8?B?VEk3REpESkdlNm11RGo0NVRLYVgwemd5cWRpbGY5RjdsdUtneGx0WHoyREZt?=
 =?utf-8?B?RjBMQ3VQNWRWK0dyUnNnaXY3QndSbzE2WEJ0c2J1YnQrZ2lhakJQRjNlVUVN?=
 =?utf-8?B?QkNNRDVVMmhnbzFENk9OQjk5c2NSNDg4K215cnZ2K1duakVOSVhCS2RMN0Zm?=
 =?utf-8?B?OE81OVYrY0tudTNaTnUrSlhlNHNpYlpLL0NUNjJCdnRGWTQ0ODVySUlOSWlY?=
 =?utf-8?B?Um1wMmpRVjh5QzZUQ2ZXa09IVkR0YVBVZzRiQkxNQ3JtaGIrekNWM0l2Zlpu?=
 =?utf-8?B?YlpUYmpKOFgxRzZBOXk2dWcxaDF4STN3dmRTOGNkNlNFd29xcVprZHlDNnVQ?=
 =?utf-8?B?NDhpcFhZdUZ2VENSQ0VlMk90T2J0bVBrSEtua1FlemtVVFcxRzBUR2kxM3lY?=
 =?utf-8?B?KzQxZ2czTXo3eEhHZVZ3anpxWDhtY000RmhTTVQyLzczWHBlL2xBSWVNTGt0?=
 =?utf-8?B?UXFCMVB0V1pMTmdib3NrQmx0VXNwUmhWMVUwUGU4SVZKQlcyaHcxaDBHY2ph?=
 =?utf-8?B?ZElTN1doZlUrYmx3aXNuMytubzFoODc1Q2tLamNTL01zaWJBN2FyZWFVUTBO?=
 =?utf-8?B?aXFDa0h0UGpUOHNNekxTR0ZTL3FpTEZzUXRaVFVySHNpSDBmeWZteUJGY0wv?=
 =?utf-8?B?bmxwS3BoMXRqY0lORTVqVWxnMk9yZldlOHBSZkgxSFNTalpTcGZqUWtlRTNP?=
 =?utf-8?B?RUxxT2F3a3ViRytZWU5DZU8wUE5Vb0o5SmZUbXU5RC9mS0RQZlNzeGEzQ1ZS?=
 =?utf-8?B?Nk5ZNWh0MFJrcjBrTEo1ZHZPemswdU4zV2tJQ2k0SzdVYXl4MDJyZ3F3Z3d4?=
 =?utf-8?B?U1VETDg5MVV0NmdNaHlsdTI1VVNpb0FpSjQvM1dqTWZvbDVKK3d4cFM2S0Vh?=
 =?utf-8?B?UnlBVEwxeEpDUVlvTFE2RytnZjNFNEthVTMvb0xqbjZvSkFhK2NsV2JrbkR5?=
 =?utf-8?B?Q3U5TVE5TVNqNlhUUVgzeVVFdEs3Y3MzYzI5NW1LdHYycDc5K0oxNUNFZGhS?=
 =?utf-8?B?TEhkb0QxS25taitEMnhUbjFCc3Y3cDVQdHBRcU83U0ZJQWxzMDFhWGZ0RFpO?=
 =?utf-8?B?YWxlTWdIYm81dHk4WWIrblB2MDhDN2VNWFZmOUFLblFTVmJpbCtBWnhMNHJu?=
 =?utf-8?B?NUUzRjZpSEVVOVZCS3J6RVZKT1NWSkFTZVp0VFVKdzJPWjhBK2xYT2RoOWV1?=
 =?utf-8?B?Q0Myajk3eFVYNXlCRkRJZlI2M1ZPMnlZV01OOGw1REJ4dHJML0NSSE5Xd2NI?=
 =?utf-8?B?aW9sQmFVK3ROSFdjWGxwT3RTMXp6SlE0YUppQ3lGQXBWZERoR2JoMVVCSDVk?=
 =?utf-8?B?TEdZeVcrMTF2a0duRXZUdlI1RE5nS0hNOXpvNjF4OE1EdlRBTzRlSXBRaEpn?=
 =?utf-8?B?ckZVekRvSEExRk9zOWRMSWNMcjJXZU9Nblk2eFlQMVN5TnVYV1VEaUZNRUxY?=
 =?utf-8?B?MmpBWnU4WUVuek5HaFBncHhJcE5GcHpEVGEwVDVyU2JlUnkvNWU0cnYyUWhG?=
 =?utf-8?B?eFlWc2FkTTRpZ2I3dDlUakpuU0RVd2o0a1A0OWZ6N2F5eTBSR1FhNlJ6UTM3?=
 =?utf-8?B?aVo0RURmMFY1R3ZUQUN0S3FMRXJ6aVpZbjRPSFhHZlFGK3VoTlVjRkNmditZ?=
 =?utf-8?B?N0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b35595d-6990-48b4-4eb2-08de11eb2482
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:17:56.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6UmTuJrjes+T+opwFfTkH28leP0yOhG7CJiEFsi3ZqZNycFI7EnTZaRVKbEA1fSD3iCcTVvPo/VLt33Yektvz4vRi9K1RNilctTBgmWymU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5965
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> struct rmid_read contains data passed around to read event counts. Use the
> generic domain header struct rdt_domain_hdr in struct rmid_read in order to
> support other telemetry events' domains besides an L3 one. Adjust the code

"telemetry events" -> "monitoring events"?

> interacting with it to the new struct layout.

How does this justify the changes to resctrl_arch_rmid_read() and 
resctrl_arch_cntr_read()? If these functions really needed to be changed in
support of the change to struct rmid_read then resctrl_arch_reset_cntr()
and resctrl_arch_reset_rmid() would need to be changed also, no? All four of
these functions are called in the same way before this change but this patch
inconsistently changes the calling convention of only two of them without any motivation.

Seems like the resctrl_arch_rmid_read() change is sneaked in to support later
reading of telemetry events while the change to resctrl_arch_cntr_read() is a
remnant of a previous version of code in support of telemetry events?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h               |  8 +++---
>  fs/resctrl/internal.h                 | 18 +++++++------
>  arch/x86/kernel/cpu/resctrl/monitor.c | 20 +++++++++++---
>  fs/resctrl/ctrlmondata.c              |  9 +------
>  fs/resctrl/monitor.c                  | 38 ++++++++++++++++++---------
>  5 files changed, 56 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 0b55809af5d7..0fef3045cac3 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -514,7 +514,7 @@ void resctrl_offline_cpu(unsigned int cpu);
>   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>   *			      for this resource and domain.
>   * @r:			resource that the counter should be read from.
> - * @d:			domain that the counter should be read from.
> + * @hdr:		Header of domain that the counter should be read from.
>   * @closid:		closid that matches the rmid. Depending on the architecture, the
>   *			counter may match traffic of both @closid and @rmid, or @rmid
>   *			only.
> @@ -535,7 +535,7 @@ void resctrl_offline_cpu(unsigned int cpu);
>   * Return:
>   * 0 on success, or -EIO, -EINVAL etc on error.
>   */
> -int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> +int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
>  			   u64 *val, void *arch_mon_ctx);
>  

This change is not related to a change to struct rmid_read.

> @@ -630,7 +630,7 @@ void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
>   *			      assigned to the RMID, event pair for this resource
>   *			      and domain.
>   * @r:		Resource that the counter should be read from.
> - * @d:		Domain that the counter should be read from.
> + * @hdr:	Header of domain that the counter should be read from.
>   * @closid:	CLOSID that matches the RMID.
>   * @rmid:	The RMID to which @cntr_id is assigned.
>   * @cntr_id:	The counter to read.
> @@ -644,7 +644,7 @@ void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
>   * Return:
>   * 0 on success, or -EIO, -EINVAL etc on error.
>   */
> -int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> +int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  			   u32 closid, u32 rmid, int cntr_id,
>  			   enum resctrl_event_id eventid, u64 *val);
>  

Same with this change.



...

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 4076336fbba6..521f78f42f07 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -159,7 +159,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
>  			break;
>  
>  		entry = __rmid_entry(idx);
> -		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
> +		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
>  					   QOS_L3_OCCUP_EVENT_ID, &val,
>  					   arch_mon_ctx)) {
>  			rmid_dirty = true;
> @@ -425,7 +425,11 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	u64 tval = 0;
>  
>  	if (rr->is_mbm_cntr) {
> -		cntr_id = mbm_cntr_get(rr->r, rr->d, rdtgrp, rr->evtid);
> +		if (!rr->hdr || !domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return -EINVAL;

I do not think returning an error directly is a pattern that should continue. This
error is dropped by caller while rmid_read::err is what continues on. This can be
something like:
			rr->err = -EIO;
			return -EINVAL;

> +		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +
> +		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
>  		if (cntr_id < 0) {
>  			rr->err = -ENOENT;
>  			return -EINVAL;
> @@ -433,25 +437,29 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	}
>  
>  	if (rr->first) {
> +		if (!rr->hdr || !domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return -EINVAL;

Same here .

> +		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +
>  		if (rr->is_mbm_cntr)
> -			resctrl_arch_reset_cntr(rr->r, rr->d, closid, rmid, cntr_id, rr->evtid);
> +			resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evtid);
>  		else
> -			resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
> -		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +			resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
> +		m = get_mbm_state(d, closid, rmid, rr->evtid);
>  		if (m)
>  			memset(m, 0, sizeof(struct mbm_state));
>  		return 0;
>  	}
>  
> -	if (rr->d) {
> +	if (rr->hdr) {
>  		/* Reading a single domain, must be on a CPU in that domain. */
> -		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> +		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
>  			return -EINVAL;
>  		if (rr->is_mbm_cntr)
> -			rr->err = resctrl_arch_cntr_read(rr->r, rr->d, closid, rmid, cntr_id,
> +			rr->err = resctrl_arch_cntr_read(rr->r, rr->hdr, closid, rmid, cntr_id,
>  							 rr->evtid, &tval);
>  		else
> -			rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
> +			rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
>  							 rr->evtid, &tval, rr->arch_mon_ctx);
>  		if (rr->err)
>  			return rr->err;
> @@ -477,10 +485,10 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  		if (d->ci_id != rr->ci->id)
>  			continue;
>  		if (rr->is_mbm_cntr)
> -			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
> +			err = resctrl_arch_cntr_read(rr->r, &d->hdr, closid, rmid, cntr_id,
>  						     rr->evtid, &tval);
>  		else
> -			err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
> +			err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
>  						     rr->evtid, &tval, rr->arch_mon_ctx);
>  		if (!err) {
>  			rr->val += tval;
> @@ -511,9 +519,13 @@ static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	u64 cur_bw, bytes, cur_bytes;
>  	u32 closid = rdtgrp->closid;
>  	u32 rmid = rdtgrp->mon.rmid;
> +	struct rdt_mon_domain *d;
>  	struct mbm_state *m;
>  
> -	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		return;
> +	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +	m = get_mbm_state(d, closid, rmid, rr->evtid);
>  	if (WARN_ON_ONCE(!m))
>  		return;
>  
> @@ -686,7 +698,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
>  	struct rmid_read rr = {0};
>  
>  	rr.r = r;
> -	rr.d = d;
> +	rr.hdr = &d->hdr;
>  	rr.evtid = evtid;
>  	if (resctrl_arch_mbm_cntr_assign_enabled(r)) {
>  		rr.is_mbm_cntr = true;

Reinette
