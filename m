Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D882FF645
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 04:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755144421; cv=fail; b=MrvLaPF40tF5SCs70dTMF7VwZzwJrjBAXZ0lZbLLGNN44JB+VzTbirIxgW0y6uv9Ztnqi7MTw17qRi79FRtYb0AgwcID+DFmwOmDyygGmFEmJ3gek/kjTZ/wLj3CEAjx0PDdZBzDNcZA07TblPBhaj+2N1WV0ESPKCgJqpzYYy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755144421; c=relaxed/simple;
	bh=zKBKKn4rpz5Rv9Z5vKJWW4WLvAstEGymsyfBFo6+O6c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sXm2XjG1rxKO8OxjrfXa+O/CnaY5jMxPGXO2fXuZuGmf4wg7eKvvX9iZkokAtWuOoOT+J/M0znwSED1UKj7IjvqUTWbAyML6ryQqigb1p3fzAXqSaAKW21wfK9GbzrimM2GO8HbproCtTSogxpdlbOYR/btskK4TuOLphxcUtiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fpDG+ML6; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fpDG+ML6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755144420; x=1786680420;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zKBKKn4rpz5Rv9Z5vKJWW4WLvAstEGymsyfBFo6+O6c=;
  b=fpDG+ML68E/nu+y6ugZr4xMWC/pJ2JN+JE1UM6IqgTJJ9NuCWbtAnT0Y
   E8OjW3eti1TxlAc62Mihxm/YC/YNLARzJfiN2Sfzv5hNJhMpuwOOI4Og3
   bgK8jWWTbaoiY4NkOxSaIYkVvYTjB4BnZEKL9BOTczUVoAspZ3h+8yPRi
   ujBHzhkeicw/kbtzBe11ME9apRA+iZs1+CPZSTK/knnh5KrL/m82tJsDm
   IPLoim3PXM+pzhAlDe2QoijUuM+RGSBjzd64mb7kQmnf0eb8H46uLbNqL
   C4j7NdAb7QfQJbCHYCN+FQ+CDPUGvJSf4weK4V6O0kYRI6FUIOwQ6i8KL
   w==;
X-CSE-ConnectionGUID: 9PFF/jQeSsG2hnEDKQ0WVg==
X-CSE-MsgGUID: /iq2LFBrQcuntPOb0PwWSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57567468"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57567468"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:06:59 -0700
X-CSE-ConnectionGUID: 6R7xNEAVRySIpWzCVQXh+A==
X-CSE-MsgGUID: ozllrHNJQwKW2rpOz5G7hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="190361629"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:06:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 21:06:58 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 21:06:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.60)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 13 Aug 2025 21:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TjQ5NXJfeX+UNe+89sUjO16AB77gcq0Aj+VvrFQvwDgqA46cQDoQu8R7zo+jR6LTRI7wT/tJ9Mdf1npjDRa62MJkVTe2KHlXQWQy0scnobz+DtmQoo3IOcp5V0Eyhrgcnq2Vh//FHY8gkpIxYC6K5ZF+OJSjHa3A9KiCZQ32THWyD5wEM+cXYVCz69b97xeF7mjKnbB5H/Ncs+w71kAmwWq7sJm/Ol+GypUy7Si+BuJbzOqR48BSmFDH+CT3uG+EzvOo3uKM9A06C9GuRnzOARzz7WxG7X0jCuUnqwnsDOZ8zH7zhxcEnj8ai7L3uVQGHcv3RUEBHYlg1OpnNpFGJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjJIyRkbODwLsACR1BVnKTfOPve+29/KcMFZ2k8vRs0=;
 b=yDAV/gM9WYNTXtUgZohtLKUgvtX6L70/aGMHf3y1dDwMnotuFz0yZ0cgxjGH9J4AFAIGQg9+rk5YA2BliTMt6doCWNXtkBCoXfZQ30QAgJ61YP1dgTpqnnNb1TDjyMBnykcsWtdimPvny78Dra0uqbV3pEpBdYU5U2vAEf+/5U68aZuGD1MHDnRlUDP4+eeaK62LiIc5ntu+YSHcxWGp7V2Z3aGcdp993dMDPa0aQ+7FM9MnCUypchPmHNPsd3WhT07+uv2oP5Ubxdw/fZSIuozIKR/9eMzf0QFLpoJsQBzUyvbXGduePvp9fPrCCEh8pRnAe/DeGXlTw3uViuhlVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 04:06:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 04:06:56 +0000
Message-ID: <626be12b-1bd9-4e7d-86e9-596e5c02a039@intel.com>
Date: Wed, 13 Aug 2025 21:06:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/32] x86,fs/resctrl: Use struct rdt_domain_hdr
 instead of struct rdt_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: e7ab3862-5b91-47f7-bef0-08dddae80231
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?REdobmMwbXI5bWZ2RzV2MTFkN29TODNYVDYxandVL09SVE9xZExXRTBRYTE3?=
 =?utf-8?B?WW9rQm5qaTBpYmVtOEplbng5MDNKM2hqM0s3QUMyNnhlSFFqcXJaK29ZM3RX?=
 =?utf-8?B?alVsVk1pMlp5SUNkZDMyV0FHbTdpekwvejRBcHVRNGZrQURaNWFteXQweU1G?=
 =?utf-8?B?bXQvVkpxUDdvb056UmVucXk5MzIyM2UyY3NpVkFIRjVVNW9VOEpYWHhhNEYv?=
 =?utf-8?B?VzZEQ3l4Um1TdjdGb0l1bWJCR3NML2FRajJwbmVmUXJSanIyUE5NaHFYLzlF?=
 =?utf-8?B?SjdOWnRIWHI1VmJ5bjdWaU5vRWNaSmR6UW01V2pnYldDRXVzNVdWQ28xWmNn?=
 =?utf-8?B?ZG8vVkVUaVgvZ0lxVUVpWmV0UjZ5N2lvZHlRL0dYTzRhNlBLdk9YS25tS01T?=
 =?utf-8?B?YXMzVjkzRFc4U082TC92eE0rTnhwMENhNlV3TmNoS0lRMTROdlo2WUlRbk5O?=
 =?utf-8?B?bjI0M2g5WEZrRVZ6dkJCUlJ1M1JEai94WEpoanYwb1VRTmhNUUwrclFzQU00?=
 =?utf-8?B?MTlQN01mb3lZSmw5Rm9wRDhXUk9zbVlwanFPQmptNEhCTXVJU2FJZFRxS3g5?=
 =?utf-8?B?MklDQWQzZDRsVUZka1NwMFBsUGUwcWxQNWFBelBXaVJDVHhVYU9mY2FyLzZD?=
 =?utf-8?B?MGk3V01nb1g4dHZ6ZzFsQzVmRjAxWHh0d0FocTd3UFlFamtBdFBrS3cvZEV4?=
 =?utf-8?B?WUE4T1Nkazd0aXN4WGNzU2lBUEx6L2Ivc0J3MkVuSkhjS2FIZkgyekF6N0t0?=
 =?utf-8?B?WVI1MHA5amg4Q29Dbnl0U0JQaXM5VXlGRzRyVW11blBSQWFtd0hEUFZ4bTBZ?=
 =?utf-8?B?UUtyR09UT0FWdW90Y3dtWnA5cXFxVmFncVBYVDJjN1dZallpN0NhVjhNZCs3?=
 =?utf-8?B?ZnNYWmhkdVNoSjhtTlpJTlVTVnNLb1V0UVBQWnpoSjFhU3dLNlVlaHRTYks1?=
 =?utf-8?B?R2tyWVRTYi85SlRyRHF6dVo3RVdEdkJqOUtraUhpaWZQVjVTVWF3RDkzdmtw?=
 =?utf-8?B?a1hoYlFpWDMvWWFaK0xKUVB5d05md2kwMHBFWkR1UVVzVWFxNFFxd0lMYzIy?=
 =?utf-8?B?ZGRzN2Z0bG5GRGFwbHROeXUvdWJFaTFEVjU5NEpWVThOYzJJOFQrdU9oWlhU?=
 =?utf-8?B?amMyaVFsek5JVndGMzlPM3c1c3hWT1J2UnMzWDN5Zys1NUY5WHl4MkNEWHVL?=
 =?utf-8?B?S2kwWkpJRFFiL25kRWMzZ2kwc2dqdExScE9hSFNrOWR3dEp4c2RnQTlLUlRN?=
 =?utf-8?B?djhOc3AzTDFtQXRvQlhCcEpNdkZoREpmeXpsbC9QOGduNnNXcGxLWE5NN21M?=
 =?utf-8?B?eWlaaytpRGRyNlRIUzdBbm5WaFczNG1qMEJ5Zm9tc2ZyMU8yMTVvU044d3g0?=
 =?utf-8?B?Z08yV2pZeW1rRlVMY0ZrcFczSGw2dml6RGJmK3RMUkFRb01FMFF2ZjVjVDd4?=
 =?utf-8?B?UGRJMkJ5eXFMclRTWGpMK3Arb1RQclBIbEZSNWFmVmEzYUdhblJmeFZ0NVZT?=
 =?utf-8?B?dG9wTWo3dHN3Y29jeDdjS25ObnE0OXlTd1JDdE9XUEFwMWo0MFJkbVZualUr?=
 =?utf-8?B?V1Z5Y0wza3ZZNHEvTWRORXhSR1NwRVI4bWQ0TDZVdWlxZlAzNnhzUlg5NytJ?=
 =?utf-8?B?MGtOQXUydDF5bGxpUXZxaVBFUU00NXZYUmQ2Nmg5Q29MYW04dENJUy9ERVZG?=
 =?utf-8?B?SUFiWUVwYWY5ZnVwRXh0SmVKTHpBU29FVzBheVI0NzFhcVJYd295WnBydThy?=
 =?utf-8?B?bDlHaEtwSnY2TEgrN2czYVVWemxkK09UOEhRdy95bG5XNU96VndPVnpkL1Fv?=
 =?utf-8?B?aDFza05MSlJBYlJQRmYxczJPUnNkRWVWZHdRNHVxRVBGSW8reW1rQXE5M2Vi?=
 =?utf-8?B?aHp1MCtrUzBjT2FrNzZ5NW1oMExDRVppenlMMEVoZUt2V3M2aG1Pd3JkWXdj?=
 =?utf-8?B?WTVJN0ZSWGpvZENUbWpnd2xQOW9BUVpjYTVjeUxrblE0Wll6ZjU2OUJ3dVRO?=
 =?utf-8?B?OVRBZDlkb1ZBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1VzMjdUYkVrbkVpT3k5RkZKeENEQkpJMzVwdlIxNy8zZkJzbDR2bkNRWDVn?=
 =?utf-8?B?YlBFMWY3S0Q1Zlh6ZWo4SWkzZ1g1VWVYVkM2UWpIaE1sY2N1eXUzZE9tcUNw?=
 =?utf-8?B?aUpoYXNia240WWtHa29hQnVFbVhiYXVTN3JBdEU1SlVJeTREMlQvV09rSHVG?=
 =?utf-8?B?bXJYRjBCTUczNjhqMEtHVG5jZGVqcGNNZ20rNE52N2d2dUZwci9MaVYzUWFM?=
 =?utf-8?B?Sk43QlJDOU9WNlRoZWFlSS8zbnFLUng5N1dJSXA2dE5zbFE5T2M0b29LL2dG?=
 =?utf-8?B?S2NrbS94TWFPSC9GZmwyY3kvTWNrNEpNTzVjcHA0c2oxYjVET1J2SlArVFlQ?=
 =?utf-8?B?WHBoTzVLd3piMTRxdDNHMEtKOFJQWjNtTk0zWmh3RjBtSnpHSmpPWkg1M3c1?=
 =?utf-8?B?QVo5akM4d3NVa0h5TVBYN1lWU3YvMHl0Z0RyTXVRNjMxdjBQc3krb1A2NWRE?=
 =?utf-8?B?WHFHUFd2Q2VTQ0t1Wmswc0k0VzYwTGo4TWNsWWtJVFppaFlQcnNGV0VBb0pS?=
 =?utf-8?B?c1l2K2VUaVBneW9TQ2VCcEd4NEFXMllqRUpGSFRSWEFvOThtbFFuSFBjdEh2?=
 =?utf-8?B?UlMrT3hXVXhlRXF1TG9YY2RMbVRsUXE0cU4rWHVKL1ErYVdUSVY3K21PZWc2?=
 =?utf-8?B?UTIrTmRDVVJBa0YzcTVIRytwTVMwamYrM0Vxb2thK2lnMUlzVXFpSHhFSUNy?=
 =?utf-8?B?cENYc1U3azM1b1dkbk5sT2RGSDNva2RJeVA4MWtCMk4zbVc1M0dSejQyQlpK?=
 =?utf-8?B?V1h0cy9VT1h6QTdJTGgxcllickhGVHhEaTBwYXgyNzhtSEg4MDZJMm9VSW5p?=
 =?utf-8?B?Smx5UDBoMzBuRnY5MXNGbGtJSTdLWnExTFd5SGR2SVZkWklUU1JqYzI3M3BY?=
 =?utf-8?B?bHg5N2ozZjV2cFhFMkErTlB5VUJtTzRuYXIybGZtb1VmWitlZUhtenJBMGFG?=
 =?utf-8?B?Qk9kMmNKQ3pvRSt0ejVYMTRrMXFENzZvT1Z6cHFOREg1UE05UnFzSjZrK0g1?=
 =?utf-8?B?a3NtN2RSVGk0cjRJakxNWVhIc29QTkNuMm9ISVJ4dS9oanZ4bUlXOGszZU1p?=
 =?utf-8?B?TzQ3ZkVCU2VNOGpHQWtjSHR3YlJoL3pWVWpVcmJyRDJSZjRXVUpnSU9UaVNU?=
 =?utf-8?B?M2cycjQ5UEVSZEIzZGxBVEtwVk9HNDBIZFdkemJMUXdobWNRR0RhRFp6ZG4x?=
 =?utf-8?B?dlpISGFYU0ZGd2p6MUh0NTNQT3M3UWo2dHdKdDU2V1dyNDVxcjFJRXJMbGl5?=
 =?utf-8?B?ZE13c2JSM3p1Qy9pR2czZEpzZWJoM3hqUm9ZODB2c3lhQWtyUnY4Vk9qUUUz?=
 =?utf-8?B?Z1RXMVJDQkhZVWpNcHY3dkJvK3dsbEFheWlQbGlpSXdoTmNzdm9Ld1VGSzU2?=
 =?utf-8?B?amJhSVJNV1ppQUFaMWcyM1I5Vjg4MlhkU0p2Z0F1OVhMYzBmRzBYbi9TeVlR?=
 =?utf-8?B?Skh5SjcvenFBQmtWMFozVmRXcWVxMzBlQkg3em5DNm5IWUY2dzRkdkNzU0wy?=
 =?utf-8?B?VkNXRE1mYjJNblo4YlBVZ0UyUDRJV0M0VmQ1Um1QNHFnbExLZHpaM1BoRFZq?=
 =?utf-8?B?Qk90bzlRczk4dHJCTUdFV0RJMHluYXNERStPbWxtWFdWRjJDd1JVM1ZHQ1VR?=
 =?utf-8?B?dTU0OVJJazNMbmVIc1JmTExkaW5qYlNlMWQwdm1idUlXQ09rUTRGZHR1OHBK?=
 =?utf-8?B?YVhKQTlzV1ZRbWZreHZqTXJQaGFqVU9mc3RnbWEwS0NkaE84Y041NHdmQ3M5?=
 =?utf-8?B?cEQ1VVhDNVc1bVc1REo4SVh2ZmpYNHZVaUZYano4MVN2WWtZZ2VWUEtlR3dZ?=
 =?utf-8?B?VG05aGg3TS9vaTlDZ0F1UXJkRmlEbDRLMXdPdmV3UTZ6MGdtSGk2MklzZGRC?=
 =?utf-8?B?UE9UVU9CYUpvdFhjQWNWSnJxY1k5MkI0MWxvWURpU3A1Q1p5N3ByTmZraGdp?=
 =?utf-8?B?YVRGVG9JdjJLNzZ0SXpScHFDWlBOTUxZZHgxLzhEelRZSWtnMmxRb3pZcVd0?=
 =?utf-8?B?Ym5YUVgyWGZuOTZibHdtRWhoWCtEVDVaQzR5RFhabVY0T0FoWnoweXNCQ0tZ?=
 =?utf-8?B?Z05vS3NvTG1FeGpxa2pscWg3N1AveEc2WkNBVTQvTmNVVmxGSHN5M0VFbTFN?=
 =?utf-8?B?aTJqMDBJTll4SmI5Wmw2QVRzSkk2QUp2Z3o0cmc5ampCbVBIOWs1ampkZHlu?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ab3862-5b91-47f7-bef0-08dddae80231
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 04:06:56.1712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrIqaw9E8Vh5M3IW/qSKROeL8+aelGC4pvXJK6Tc2B1gkMn2ZGtNf0C8YMLYZW1/yhY7M+1BQIFCcYzH0lwNcGisojleV5MFS9g/sswbqAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> All monitoring events are associated with the L3 resource and it made
> sense to use the L3 specific "struct rdt_mon_domain *" arguments to
> functions manipulating domains.
> 
> But the addition of monitor events tied to other resources changes
> this assumption.

What assumption?

How about:

"Telemetry events will be tied to another resource. This requires the
 functions that manipulate domains to not be L3 specific."

> 
> Change the calling sequence to use the generic struct rdt_domain_hdr for
> domain addition and deletion to preserve as much common code as possible.
> This will simplify enabling of enumeration of domains for events in
> other resources.
> 
> Make the same change to allow reading events in other resources. In
> this case the code flow passes from mon_event_read() via smp_call*()
> eventually to __mon_event_count() so the rmid_read::d field is replaced

"so the rmid_read::d field is replaced" -> "so replace the L3 specific domain
pointer rmid_read::d with rmid_read::hdr that points to the generic domain
header"
(switch to imperative and remove unnecessary "field" term)

> with the new rmid_read::hdr field.
> 
> The mon_data structure is unchanged, but documentation is updated
> to note that mon_data::sum is only used for RDT_RESOURCE_L3.

wait ... this looks familiar ... (looks at v7 feedback) ... same feedback
here as in v7 :(

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 911100994fcd..7fd6cd7348fb 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -529,7 +529,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>  
>  	list_add_tail_rcu(&d->hdr.list, add_pos);
>  
> -	err = resctrl_online_mon_domain(r, d);
> +	err = resctrl_online_mon_domain(r, &d->hdr);
>  	if (err) {
>  		list_del_rcu(&d->hdr.list);
>  		synchronize_rcu();
> @@ -611,7 +611,7 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	hw_dom = resctrl_to_arch_ctrl_dom(d);
>  
>  	resctrl_offline_ctrl_domain(r, d);
> -	list_del_rcu(&d->hdr.list);
> +	list_del_rcu(&hdr->list);
>  	synchronize_rcu();
>  

Looks like the change intended for patch #8 landed here instead.

>  	/*


Reinette

