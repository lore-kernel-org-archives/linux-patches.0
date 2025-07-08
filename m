Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47938488
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 21:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008812; cv=fail; b=qRFC5ly5+WKfEOUfhvT8F2mbG3XZZaG9ghdsmIhCHeQCF7jS5fwGbGwFUtDAq9T+9XzK1y3OhflWJFCb8KtXoNCsRoDwVhWSCCRNmq8/6FSB23t6IpNW0de4soBfSiRph7Gyb5u1/YfbCxraMO/6itgQdehJqZHBHgEc6l3bEzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008812; c=relaxed/simple;
	bh=gu1G82Kj7LWpnPdrUBpg6hAJ7R0WX7UtWRePtsHaRFk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XUNn1ysjXGzhi7/gfLvwjff9zlzcV4D672sTS3wTjuvE4acBkmbpvbc7xqpdGAoVvq014qBupMs+haDdxl9dWEjskA/TsYN7IrJ+qazSyZk17W0gxBFK9ArtNBQ6bOtC2Pr2ossyqlyrWgVYf3oampKy2wZ2qxFF6tql2B03ddw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C7mRFPzw; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C7mRFPzw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008811; x=1783544811;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gu1G82Kj7LWpnPdrUBpg6hAJ7R0WX7UtWRePtsHaRFk=;
  b=C7mRFPzwLefKcmxeqg8RxtD1kWKlAkwMS+OPbcLJakHPSIOGYsE384wz
   js0GczVN/og8KXivO5ogi8sHCSJewR5iamhEHhK+5DRcNXvJJz0PEZc5k
   YG42YVrGHaidV2GvE+PyPHdtr+fktuZeS3rr43B07c9Bxp22/fwVYd1xX
   c9984k6uzw7rw9HaS3eF+sJZXrSROn71JAa1rWIaj+KtM5GEnU8kdsZkM
   fRsY4pNQGSJy+5FRc42zfo4rgqYluIk2eZ+7LMqk0J8t4SoKS5ha0JAJT
   JOQQhXqurhlYiYMf+H0xtdsjsJaG4XTpQbkzHMxMvTM0/k/WYqBABZy+F
   w==;
X-CSE-ConnectionGUID: b6UWiul8TWOq5MQPTJnTNw==
X-CSE-MsgGUID: 0txtdaHvR3OYSzx+zGNBsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54144668"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54144668"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:06:48 -0700
X-CSE-ConnectionGUID: nz2HaxmqRWOrYg5E9Kc2hA==
X-CSE-MsgGUID: LZjaOyjzS7asRtb403xlPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="161151207"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:06:47 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:06:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 14:06:46 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.40)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:06:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L852GmkbX4hTw5u6i64AxDthwYKkDpXVjKH98m2t1i93xq6DX/BhrHSRKExvAeEcWD1t28XBBWeJNi6ybpsGLa+uoFOXnyaDb/NVaR1bsoB0sFGwtVoY7hMg1DKdSkPLHdVTgvjGS3qSBHPrgsLaDWiClyTAIyG1ZwXh5Nc46vELNvehenn3MBtnyPSIyvg0M3LzE5GjH5ZJDab0Z6UkodRH9/UjMP5vpr0NbqxuIL5gfcNWOQRYmYT2C5M7PGkZSr0Eb2SsFPXK3bJfK75NjJV3yOIt7gJf72le8JA4/oGep+FJ9yB9/9ZJttMlr4JsM/ACIkBPReIwIKnxLKAl4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xUlm+D+T8GQlPhi1151+AdAD5hw4RyUYu8wZWXC3eEA=;
 b=Twl6EMbdPwLIveglkhpHbz/xe0F6pmS0BfVkiC6cOH6e0k1MW6OZE5kjj3mcWNMtbiawxBZbiX/T3y9tnt09wOpi1bEdnvc/qgq25RXBtKmaKJIMe3C1XTIZS5Rr6riPexja11LCOJq4OwV/xmrefwMKHffLobYZQO4LArpICY15vdMvpiH8Kz7pQDPfao7dBiZgqF5ofd/fA04dgxtQ4iCg90NxRJYoZl0cvdwb7aslWqV6GDIZtaYoiCyFoV3fwlg4/eECLVbxnXtY9gdfTucC7uGIQaGMzfbrdarlorl1ZdPxaIpXx9lofPrGzIMG5c6uV1ng9PeYwcSBuQfKOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8786.namprd11.prod.outlook.com (2603:10b6:208:59b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Tue, 8 Jul
 2025 21:06:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 21:06:44 +0000
Message-ID: <a6f15631-81a0-4c03-a088-67543b569e96@intel.com>
Date: Tue, 8 Jul 2025 14:06:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/30] x86,fs/resctrl: Rename struct rdt_mon_domain and
 rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0017.namprd06.prod.outlook.com
 (2603:10b6:303:2a::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8786:EE_
X-MS-Office365-Filtering-Correlation-Id: aec467fd-4c3f-4814-a1ba-08ddbe6357c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V29iNHVNckkxTXFvMGdDZUxQSXExQ3BEcHRkZjJ3YTI0TXcwdHFtWVE5OGhN?=
 =?utf-8?B?cHZoZ3RXekMzV241cmtFbHF1L1FvSXNSZHduMStGemVydEcyWFAxdk5qYm05?=
 =?utf-8?B?ME9jalRrMEJqRHdDWDhnQ1I5V255eUlFODVSN3NLTDBub2VSeWU4ZGdZMmRq?=
 =?utf-8?B?UDV1Zm5odlkzOTUyUFJ4RUoza1VEUmxsc0w5UGRwTTFnWllsTmFvU2p6WXpx?=
 =?utf-8?B?NmN6MzhaTURLZ21YSUI0b2R3TFBaOFZqZkFQdlBMbWdtVkZjS0JoVGd2d3F5?=
 =?utf-8?B?cUo1Y2VZY21hYWc0Q1lIU2wxeEZ1VytaeHVWdXFlcWZVVjRPTlk2OWtwN1Y5?=
 =?utf-8?B?RWhlanNiZ2pOQ1RCS2l1V005OGMzQm9QS054a2V2djA2MFYzSmNCQ0VScVVJ?=
 =?utf-8?B?Vm5WNDZuQ0cvanJjVFA2bUlORjI1bmNMTFNKSnZXbjdHM0VLYjU1NDMwa2dT?=
 =?utf-8?B?RWRQeTVlQTRWVnk3S0FvMHhCR3V2ODh1RmVYeWtPcjBVQzRSa0dEQ01pbUhM?=
 =?utf-8?B?SnNpdythL1hRV0QvNy8xRWY1NVJnK3lEcUFrM29jM0FVeGhOSXZEUTkvODcw?=
 =?utf-8?B?MUNYczN2ZjdtdzRUYTJXU0xXaEdCL2xJbnZrR0dtcTFjc2tUR0ZRRnBickZB?=
 =?utf-8?B?eE9ubmd3QWZobG9yNzg4c01uZnZJeXRzcU5WSlpoTlIwUGo2aVRtRWZwS3ZJ?=
 =?utf-8?B?QkJOK1EvcWVZVVgydlRXckdpa09jeTlSYUZIdEpXSWZPYTIxcWhuWkVFelAv?=
 =?utf-8?B?SVZNeXdmVUp0N3RvejJBZng3aThFTVd2SkVlUkZTck5GRTBuUHZXVi92Wllk?=
 =?utf-8?B?ancyRDdrNnVudUNGQ1ROTDFFaFNVTXNzVUdtL0lielpmSzNTQjJyV0dINXJT?=
 =?utf-8?B?dXhxREtQdFFCZnBGSGlFT2ZOMkFrWnFLbWpiNWZ5eUdtKzJSVFJLVW5BekhX?=
 =?utf-8?B?K2V3NDAxL1lnWEJmN0NOby95eE9qeFlybVlrblZRaXhYcnQzR0JHNFB4cjFE?=
 =?utf-8?B?c3d6Und6NkZ0aitPZHZXUjRTNWt4RXhOWDIyNGlpQXdmR3dMRkxQdytTR2JP?=
 =?utf-8?B?WDVNcmhpQU9kWXZjT09PSk9ad05kbkJ1U1ljRDR6dmpSaW5ZM0hFZCtnVkhx?=
 =?utf-8?B?eEp0R3RQRjErOFhTc0xrcXRNdFhnZ3ZvSEhQVUs5UnJ3OXRsM2hhdFpFK1RY?=
 =?utf-8?B?dGl5NVFDbWV6ZTBaVHhyd0xMOGl3SStmRk9RUDZOOHdTQW9NSG5RSDk5L0lj?=
 =?utf-8?B?ay9TY25aNXNYdmFhajE0dzlzZDJaZThTT2tEdjJxREFiUG5ENGM1MUwrNU9m?=
 =?utf-8?B?S1dqRXFPVEZnTzBCMHNDcDk1cnhoZ3h6WlAvM3hERXJ1Zm82OTVHU0NaWnNP?=
 =?utf-8?B?NUJ0Q0t4QTdCOEtmaGpxaVlYbTIyZ21OaXZUMFNCMUM1WE1PbnY4b1RuV2ZJ?=
 =?utf-8?B?eUM4NlpPMGlVNnQ0UXlkcjFkOHNSbTBkVTFQSVJ6cHA5enBTczJ2MDE1Q3lW?=
 =?utf-8?B?YjJyaHFjOGJxbkgwbkpMYmlrSEJUdHZCcStvbmNSQTB0WGJBTW9QWDRmZFd2?=
 =?utf-8?B?VWFRK1prbHNZaE5hc3h2bWVJSWEzWGJaamJVTlpaUjQxOUE3ZnZMWnYzajFH?=
 =?utf-8?B?T1VQK3VNa2dVSGg5VWN2QnFMREN6YlR1SitpdVN6L2JWMTlCU1NaSTRVSHpr?=
 =?utf-8?B?eWN6VTBMQzNaYkVwSXB1YVVXbnVJRTRwbjQ0K0p2MUE4UjhlYmxBSWxBQktT?=
 =?utf-8?B?RkxiWi9DQVZGd2U0dEtKQUZtZmVyZW95bW1SaHdUdkc3RkM3WW5qdExUVmNV?=
 =?utf-8?B?VGMxNWxnT2xvaEEycmlHTnBGeXlHTUNKaFpvSGpXTGVzYlh5RlZhTEErL3FJ?=
 =?utf-8?B?cWl2T1hWNVdEOTRUa1h3R0hmTVJ6Z0N4YWJyMi85Y0xVcUh4bnZ3Y0FYOWxx?=
 =?utf-8?B?UjZLYTY5SnMvOHlZdTlVS053dVNESkpqVGJLYW8yOGJZZDNBMi9HVHZyVFpC?=
 =?utf-8?B?MHdGaDJkWkF3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODNJZGVXdTljcEZvSXc1ZElOaVJYTktnK3RvNkpSd0pyVUtjZW8wdmZQaUpI?=
 =?utf-8?B?NStOY0NFQmNLY0RQK0J4V2xFQ2kwbTI1NWNmNDlKT21KUmFHeTFYQi9vMEpl?=
 =?utf-8?B?WHYxMW1lcjF5MWNYeVl1L3hCK09VWnNPcDFMaitGWWx0VEdWalNvaWR4VGhV?=
 =?utf-8?B?b1czdnV3TE9mUzRJNFRQYWhkUE9XUU5FTHZKR25rbXVQaHdNWVF0VXpqV0U0?=
 =?utf-8?B?bFo3clQ3T2pCQ2I0R01leDBFNmtFM1BMeENzWFJBc0RoYXRFY1paYUl3b25y?=
 =?utf-8?B?aFNlS1l5a3ZNVFhZWTNPOFppTXNlalJtTnVkcUF0Y2ZEN2NleU02WUp4UHBv?=
 =?utf-8?B?cEJWNktVS1premg4cUdOK2RPZ1dnQlhET2hHWlROek0wZ0NvdDRJUWsrckJY?=
 =?utf-8?B?YTFyN1hPNHp1Ylh6NnJ5WVIzNGFoUERzWFo5WkZnZXpHQWgxOXlscUNiMzVi?=
 =?utf-8?B?ekQydWoxSFoxVzJCdW8yUVU3eTk4ZFMzaWNIbFUrVkhobXA5V1hTVmZpWVdl?=
 =?utf-8?B?czBEUmdTZDVuQ2x3VjY4amVWSkIrbEFMQlhnYlRYMDdXbzhpeUhpZXcxTFBL?=
 =?utf-8?B?bVRoUlpnTTNVc2ZQOWtuTk1WU2JENWZVdEFHc1hnd0U0T20xdVprQ2JNTTRO?=
 =?utf-8?B?SUVrYW1DVk5kNWpmellNVlVmVXRVeFJVbjBqdkpDTkxVVlJIMmZRMmVGbk8x?=
 =?utf-8?B?S0M2cER2RGJYY2pQM0Qrb3FSWThPVFE2WDl0M240SUViZmhmcUc5V2NCeXEx?=
 =?utf-8?B?NTk4b1JIU3E1K3RRNG5pQXNGMzgySjdIU0Z1WmFHNE53aE9mNHpTV3plSDkz?=
 =?utf-8?B?RzcwWWVQNFhDK2hzYjlzL0dncW1mZm1FVk9Uc1REOWFpaVdHZjBlUTh2czBx?=
 =?utf-8?B?U2NRR1hVN05LeGxjQUlTTGw1T2NmWGtTRU45VGY1d0Jzb3BCZ25WV0hQSFJM?=
 =?utf-8?B?UmxnMmJkMS9sNjZCL1haMW1jbjNUMEZlTEg2MmZhTnhFQ1UwVkNpQWRKWUtF?=
 =?utf-8?B?OUI2SDhnZkpxam9Zano3cWxhbjkxVVJ5S3k5eWN3QXBYcjNCc2xmNDN6TUdr?=
 =?utf-8?B?L2k0Y3MzWkpWYzQ3RDMwWURYNWJDcWJtcXNjczZOTXYzTUVlYWtCaFpjbTBu?=
 =?utf-8?B?WHJKT01hMk9JWDduNGJ3L2ZUN094enUycW1sZzFUem1LZWRWTUtwMkozaTlr?=
 =?utf-8?B?dVJza3czWExUZ2g1dERzWDNFUkNpeThGV2dmUWljRW5LSDhucUpzZExFbWNV?=
 =?utf-8?B?M3ZncnlUdUJvVXdKS0ZRSmtWMCs0cWlZOGg0RDA2dDN2ZnVtOWlhRDJ5eFZ3?=
 =?utf-8?B?OHBkc2R3bzI4Q3JuM09nOFg2cFY3RXpsTGJ5WENjYzY2QjB5RFRTSUVzREgv?=
 =?utf-8?B?bnV2Zkk0N0V2WFNURElxUnpwc0ZzUWg1ZWZVTEMzbXp3WkNZQ2Npb3NsU3BJ?=
 =?utf-8?B?Q2RKU0ZqTG9OUDdSR1BDdFhLVVluSnJxWGZvSHlydHVwQzFZZFFvdXZhSlhJ?=
 =?utf-8?B?cUVuOUdNeW55RG9XMkRjTFZ4b043VHV6b0xtK1lyNHlyWjJDZmFYUFU2TTlB?=
 =?utf-8?B?alVlVWx4ZHAvcXFDTTdLTnVkdFlrUnBseG00dmFDblZTaHE3eFU1UGx1Nk8x?=
 =?utf-8?B?Z01jNW8wTmN5ZUxqaFV3eFcvYStlNlRnYTl6WXd0TU5BTkR4MnhWS3hqcE5z?=
 =?utf-8?B?THVZbGp2UHFzS0RTVVdVTDlBUDZnTklMZTduUFowSUZ0T3F5RUlVTzd5K1Y0?=
 =?utf-8?B?NGcwdkVMY3VtS0RBWUZRSVVocWVXTXlVSnNZenZ3SGRpTzRDY25EUkpRNkZp?=
 =?utf-8?B?azgxM2hrZ0h6bklhallQdkNTOXhZdGdHUzh2eGpMby9PcTQremF4bTVsU3NI?=
 =?utf-8?B?clNFKzBObnVMU0lCOTZhV01UWUlyY0dCeWJlckRBTTQ1T1Z1R2FQOUNmelQ2?=
 =?utf-8?B?Z0R0bHk1YndtVlMxUWZpOXRyUFhldjE3RmF6TG9tQWFwRFJaeHdTbWlUN3lS?=
 =?utf-8?B?cmE2L0w5a2RSLzVFRnFqa0djMWk1UGVDY1EvZEhRK1RQQnliODlUYmhWZjRj?=
 =?utf-8?B?MkQrYjRDYzJCbGhTRC95YnpOQTJ5Q0s5bHBuaC9lWkZuTWVwWWJyeWkzVmhl?=
 =?utf-8?B?ZXpxRTdJWjRQTlF1TkFaK0tUYTJweFVyLzhEdmdNa25OOFpwZFVFaDkvbFFU?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aec467fd-4c3f-4814-a1ba-08ddbe6357c3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 21:06:44.1831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zinyZ+3avJ50H+eHIzX0MRvAONoAhdRcDUpsp/TGaXNrwveJkEkCc3OWshP3qI23XXD60DxHkFXjw5K7ILY8i4gAqlxKiHckJ179AGYlu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8786
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource. This will change when support for telemetry events is added.
> 
> The structures to track monitor domains at both the file system and

"The structures to track monitor domains" -> "The structures to track
monitor domains of the L3 resource"?
(goal is to connect the context that is about the resource jumping to
problem description that is about domains)

> architecture level have generic names. This may cause confusion when
> support for monitoring events in other resources is added.
> 
> Rename by adding "l3_" into the names:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                | 16 ++++++------
>  arch/x86/kernel/cpu/resctrl/internal.h | 12 ++++-----
>  fs/resctrl/internal.h                  |  8 +++---
>  arch/x86/kernel/cpu/resctrl/core.c     | 14 +++++-----
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 18 ++++++-------
>  fs/resctrl/ctrlmondata.c               |  2 +-
>  fs/resctrl/monitor.c                   | 34 ++++++++++++------------
>  fs/resctrl/rdtgroup.c                  | 36 +++++++++++++-------------
>  8 files changed, 70 insertions(+), 70 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index b332466312e1..01740acebcd1 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -166,7 +166,7 @@ struct rdt_ctrl_domain {
>  };
>  
>  /**
> - * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
> + * struct rdt_l3_mon_domain - group of CPUs sharing a resctrl monitor resource
>   * @hdr:		common header for different domain types
>   * @ci_id:		cache info id for this domain
>   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> @@ -178,7 +178,7 @@ struct rdt_ctrl_domain {
>   * @mbm_work_cpu:	worker CPU for MBM h/w counters
>   * @cqm_work_cpu:	worker CPU for CQM h/w counters
>   */
> -struct rdt_mon_domain {
> +struct rdt_l3_mon_domain {
>  	struct rdt_domain_hdr		hdr;
>  	unsigned int			ci_id;
>  	unsigned long			*rmid_busy_llc;
> @@ -334,10 +334,10 @@ struct resctrl_cpu_defaults {
>  };
>  
>  struct resctrl_mon_config_info {
> -	struct rdt_resource	*r;
> -	struct rdt_mon_domain	*d;
> -	u32			evtid;
> -	u32			mon_config;
> +	struct rdt_resource		*r;
> +	struct rdt_l3_mon_domain	*d;
> +	u32				evtid;
> +	u32				mon_config;
>  };
>  
>  /**
> @@ -530,7 +530,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
>   *
>   * This can be called from any CPU.
>   */
> -void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
> +void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>  			     u32 closid, u32 rmid,
>  			     enum resctrl_event_id eventid);
>  
> @@ -543,7 +543,7 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>   *
>   * This can be called from any CPU.
>   */
> -void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d);
> +void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
>  
>  /**
>   * resctrl_arch_reset_all_ctrls() - Reset the control for each CLOSID to its
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 58dca892a5df..224b71730cc3 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -51,7 +51,7 @@ struct rdt_hw_ctrl_domain {
>  };
>  
>  /**
> - * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
> + * struct rdt_hw_l3_mon_domain - Arch private attributes of a set of CPUs that share
>   *			      a resource for a monitor function

Could you please fix this alignment?

>   * @d_resctrl:	Properties exposed to the resctrl file system
>   * @arch_mbm_states:	Per-event pointer to the MBM event's saved state.
> @@ -60,8 +60,8 @@ struct rdt_hw_ctrl_domain {
>   *
>   * Members of this structure are accessed via helpers that provide abstraction.
>   */
> -struct rdt_hw_mon_domain {
> -	struct rdt_mon_domain		d_resctrl;
> +struct rdt_hw_l3_mon_domain {
> +	struct rdt_l3_mon_domain		d_resctrl;
>  	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_L3_MBM_EVENTS];

Also here, please align struct member names.

>  };
>  
Reinette
