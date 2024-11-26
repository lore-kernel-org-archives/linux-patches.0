Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A85D26D
	for <patches@lists.linux.dev>; Tue, 26 Nov 2024 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732645867; cv=fail; b=H2X/zrg24Pe1fhmYI44bZsJIY4wbjQtqoeeF3+9wOgNEe/aSFzL1bPVWpcLurnG+jE+7g/xq/KS85vhU30QfNz50Tki30ba6cLlMMHIi+nlV0PD+Mt/IxjtcmK1Tc1LV3z8u3nzcUwogm+i7ytoxT6gSjNBMpi2UJzUkARann7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732645867; c=relaxed/simple;
	bh=0necX/R2t1Dy/Qsgc4aXM3RScJBbKLuRTXOdUbbBK24=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=edJSP5Qesoa0mFCXCsY44JCcN3AKcsScspP5p4DeyL3zW4zXetpW/+JQto/X2ytIobpjcCf/g+1ateyG+WvQnFClgTdzbrw83gprSAb+9MStE+O5dTtseEoqW2yZhqBuEpddSzuCScFcjG4EN1G8dYeqg0AVMBkHp6RRtYqp+Dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AnTI6jnw; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AnTI6jnw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732645865; x=1764181865;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0necX/R2t1Dy/Qsgc4aXM3RScJBbKLuRTXOdUbbBK24=;
  b=AnTI6jnwDFpYZIdy779yimL1TqK4jSY+hF94rgfCX9eCL6ns8/N+W2sy
   x3ko8rM/jNFhehPTYw3AcusXRO6/tXJ67WrTrCn56UF81dEFZHs7ssU6N
   PGG134THXJf8ClEJztUC3oGvkoUnBgpXpFZVW+K7LD6Xu4BR7cbt0hYwY
   QpL4bk4jiQeJAP+R5rx0Gp46L0rhoCGVwjoR4oq0Ni3jGJetXwJm+4T+Z
   c3zK1NHb/iSWP/1IeLfwWzkLu5NqsZC2TUTBHy8NqKq/Ubtt6/ejhlgsW
   Ea9yF2SqqEb4QRSWKCcOZBLqcOT+a6XC7FmwkeOLuQIuKrLVDYY517siG
   A==;
X-CSE-ConnectionGUID: Esm+qZJOTciMyN0whwMSNQ==
X-CSE-MsgGUID: zKZ8nLKtQ+S0P/ktobuQMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="36612450"
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="36612450"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 10:31:05 -0800
X-CSE-ConnectionGUID: JhipSYmFTDmonNhyRihSbw==
X-CSE-MsgGUID: 69BTFOm9Txyquy6VCVwMCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="96772611"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 10:31:04 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 10:31:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 10:31:04 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 10:31:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e7bBGiyuKGy0on7siRwlJ0JqFxUvCuDEOdipzumuXGpaOxnUA+B2sRDblN5axWcZs2oFVezfYerD5vV7kBruAU5DGrh1XALYkxzXsH2kzIJjZTzNh/exYTlafghaN5F6jpoRI7j4xHmPg4aA9DsnTM6hD2NP+id3lV71FTK2sDZn30tMc6Eo1vEwYsrU50ct0Tr/4uj52Yb/YOwehBCqQGiNBh00fSsfNmyB15XH+jXhTpQadvui1f1JUAj3/M+tU37yUeUsC1Pt8X8HtahZeU1k+tmVZvwA8u7Hh3prYH6RgAuAQrfHaD06atuK0JB18AIUsldF5QEfFA/UjqHk3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTAyGqfbhnSJRXwaGWAwKLZseTiFVI8XZhzXsE5x6wg=;
 b=Ij/YIJHiT21BMKLGssiVjaL98XO76qX6/isKFWaCEVbGNykDNLcO61v8QwMRfJjijTrvMGQ9clHwY1Us3+SK0JQpn3yA5KqVVn1VldUNmS6Hs9eFKOlO2bycX5FzauH7LQ4tXm/fLCjCivjayvpvD6MbORZ5PnlXVsHX4FfLsvS4+XFB7da1j+crACAdcMSbtt4/XQUwTBm11jVPOConCslsSNrvzt4f46sqPcNOwTMKW4VIyYc9FcPSlRaFY2S2CtxG6MfYAwQDxW4+OtoUi3eid9fDWp4zwSgouZmhJVttpk6sSmywWGqKyazkeyVu7wqRASLctJwV/dKneRXIOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8109.namprd11.prod.outlook.com (2603:10b6:806:2e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Tue, 26 Nov
 2024 18:30:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 18:30:59 +0000
Message-ID: <cd0f7219-4b4d-4297-aa02-5ad5efda4fa0@intel.com>
Date: Tue, 26 Nov 2024 10:30:57 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/8] x86/resctrl: Prepare for per-CTRL_MON group
 mba_MBps control
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241122235832.27498-1-tony.luck@intel.com>
 <20241122235832.27498-3-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241122235832.27498-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8109:EE_
X-MS-Office365-Filtering-Correlation-Id: aa0be10b-38e5-42da-c48d-08dd0e487999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0JjMHB4T1dCc1ZpYVVkb2FtUWg5M3JhSEVrUFdreHZENVlhV0ZNd3N6ejY4?=
 =?utf-8?B?amRWL1duNHVjL3AzZVcySzhqQ1hYK0k4U3JTbVd0V3hWOXN2WHpnVG9DNW1L?=
 =?utf-8?B?aHY5cnpHazhoOXQvdlQwMkJyUWtwckhsQ1VPWU5TUEcxdHdWK05RdWpVNDJU?=
 =?utf-8?B?ZmJDZTRZN3hST21KdUhGeGdvK0Q2RW51eFVpSGxOZklOTnk5Vnc1anlmNTFP?=
 =?utf-8?B?OUxJMGoxK3UweTdadkRZbE9YM1BYNFVjaXUrWldMK0NqUzBnNW5pWFhDaTJR?=
 =?utf-8?B?UmJVVDlPR0Q2Z3NBM2dTN3lyYTBNeWpaa1JWd1VYNDUyWDZuYkFRcmZWNThI?=
 =?utf-8?B?NUljdXU0cnlxVUxaYnl0TjkwNGhxZFNBdEJJVm5MUHBiZHFGSGlMYVk1V0RM?=
 =?utf-8?B?MktiUkZEZ29BOEw5VHNPbGYvS2xSMjdDcEZaRTlkOG1QQVAxS0RXVXVuRVpU?=
 =?utf-8?B?dlg0TXZ4WEVXbURyWS9NWFh5SFpaK3k1SnQyYzQzck1aWEEveVVtWjZQQUpp?=
 =?utf-8?B?dWltSW0xOXhrd1haSzViNWN3cDJMS2NtYzFEVHordnlhd3NuVGtmYThsUmtq?=
 =?utf-8?B?NTRSaHprc1htVlkxWFBlY2VYVXVUNkFpOFRqbXFyZ09qY3VkZC9IazdRYnYv?=
 =?utf-8?B?cjBTaFJuM25SeGkrREtvNFVVOU00QlZZWDJtOVh0ZlhPTlR4UG5hdEtyNUFR?=
 =?utf-8?B?TFZXbEU2RWc1WFFEcUZxb2k5cXYvOU5zeWd0K2JnTkJnK0JCazQ0MDZxZURO?=
 =?utf-8?B?NGJQT3pYQ3ZGMDhKWEVqeE05MzUvMnVSMFpIbzRQelpBNW5xSkZTZ3hnMEQ4?=
 =?utf-8?B?YlZJZ0d4Rk5halV6UXdpT0FVOUUxN2NtUFRDcTIza2FLeVdXYjZPUnNVU3Fp?=
 =?utf-8?B?UUQ0dlFBUVVNMWtYZjBRa0U1TXVPejQxVHgrZzN3aUpFeU1adzUvWjZPWTBt?=
 =?utf-8?B?ZUt2bnFyU0puNHdJWDBiVndEcFZ2SktCd0lwRll6L1J2MmtmWFN2ckNucTVV?=
 =?utf-8?B?S2JDWkVEQU5NNTBXMVo0R2d4Tm9uQS93K1U3RDdMTVNuVHZEYzBOa3BVaW5x?=
 =?utf-8?B?dnp5WUtxSTFpQWpMbEtIZWlnNnhXK21ldi9xQmh0U0lIZk1BbGhYR2NGcnp5?=
 =?utf-8?B?aHRMVkY4NGhrdnZoV0lBdnFqWkJpdzdIdlo4RFFhUGZlS2EvODdEWk50UUVC?=
 =?utf-8?B?QXZBYjZlYWJkb2pCRG51RFQ1TGp1ekFESUhRWTFyMlpYRGdPaVdSS0dheE1G?=
 =?utf-8?B?Mi9WMDc4RXByZnpRSjN4Tll2Nlgva0x1d2RQZGx6bDByeUtRR3JTN01iYzlz?=
 =?utf-8?B?MnBNQ0dHSmZTWEk0SlUzc1BvNFpKTXRhYlg0aGJwN25RMXVCcXFTR0RFUXZs?=
 =?utf-8?B?OU5rMkxidkNXOVdIUVE4NWlna3Q5bTlPZm5XUjYxRVcvYXhrNS9KYmR2RXln?=
 =?utf-8?B?MVlLUjY5Z1dJY3NJTUc4OHcxRTB1NGEzdkJ2eEJwby9ydVFxT2hSQkF0TFlY?=
 =?utf-8?B?WTlETUxkdVl6SlJZQmpXY21Ibk9Mcm1zejRHaGw4ckJzQWtQM1ljQTdsVTdM?=
 =?utf-8?B?OHFhNjFlbGF1cmg4aXp1WXJPeVZZUkh2WHpleGhRZWFZQmZzODdLVWxYVlgr?=
 =?utf-8?B?Zk8zYUpWV3pDcmJFenBGaDlHVnRnUkp1dTJZblZjdE9SeUtzdERZRzJ4Kzhv?=
 =?utf-8?B?QnRYQU9taHhxdDVvRU0veUVMTHo5Y3lqR2dnT2Ezb2RTaTlPdnhuWlNpK2xa?=
 =?utf-8?B?bkFJeUhxOExMUzlvRHZWZGYvYmxibmxObDVISlJhY2tDTnhEUktvMVcwOTJq?=
 =?utf-8?B?czlPc3lTL3NBd3BRcXlaUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzB2TGpSbDlVOXJ1c2RublYrWlFMZjh1NHh4L2U4THB2ZXhEcEJBSU9iOHdN?=
 =?utf-8?B?cTBhcE1DT0JwQ3VncjdiSS9YRGtqcGpwRnJrVmxOWHdKc3dObjhYY2FNYXkw?=
 =?utf-8?B?c09TODg1Y0F0eDFUNnh4L1lhak9DNnBxaE5wNGtRc2NETVRiM3N5K2NpMDNw?=
 =?utf-8?B?N3hmeGFNb0NjM3RITk8vM2pabWJnSHpMRUpJYm96dHUvUHRoRXNxc2g0a3Fr?=
 =?utf-8?B?RWo2MngxWU9DazNKRlI2eUFsSTA3T0ZOYnpIOXF2dmFjeWVEZ1JqMTJiSjM1?=
 =?utf-8?B?YmdOSlpDdGFYM01YYjRKT3YvZHhZRFZxT2dxaUhKczFIRTNQZnE4dExXcEow?=
 =?utf-8?B?dm5rN09wU0htZTQzcTRjbHdXNUgvR0JES1YvVzdaUW51NU9PZm1Za1NSaEtY?=
 =?utf-8?B?NkczNmYvVWRGZjlKUXY5cmJsbEdyZGJQMW1Rd05GY0s2T25WeDk1NDVGd1dJ?=
 =?utf-8?B?RVpwZCtvTURRbmdBV1E5VDErbjdOS0FxaFBzVVpLTGZTSFZTRDdrNWdnQk9Y?=
 =?utf-8?B?eUZqTzNNaGYvNStKcG9oWkFJSERINUhyRUZIUnNraGNnNWpVRmYzVUlTUVRW?=
 =?utf-8?B?bWlzakM2bUg5cU44dlZ5eGM1blgwQVdFcnIyS243cld4aGQrSlZYYUpqN0N2?=
 =?utf-8?B?N3NXZzl6anRpZE9KU2w5QVBvSnZxSUxzbzQ3TmY4V3N2WmVPSDMyQ2tuRXA4?=
 =?utf-8?B?RnZCZ3BtWFprNDRXK3FWZGFpYzJ2VmdEdGFPQUh2eU05akpjemw3NEtRWlkx?=
 =?utf-8?B?VVBNT2Z0aEQrYnQzM3hJVzVjOE9RcUlRMXFCWjFkbzVqSlFMY0JMKy9rZnNp?=
 =?utf-8?B?RVpQUW55dlhaemt6SkdMNTU0Y2E5NURGMFZqRTFIU3MvZXpPU3ZHUFZWYWxY?=
 =?utf-8?B?M0J4a2NEbkxESmtTb0wwenpvenVFbzNSdGJJb3E0MlFvSnF5M3VqMlJEdVZF?=
 =?utf-8?B?SkpFTUZXMXdhbGl0dDc5UFZhZENTNmltWlpLWTUxSUhjQkg2WEVWWDhLWFFl?=
 =?utf-8?B?Z21OKzVWOVlBL2dOODJrWHpmOVQrWUVvOVkxTUN4cUduNTFrVkxuNlBCMFNN?=
 =?utf-8?B?L0txZndmYVdmWnhua292d0RMa2pVZWk3T3N3M3VNMlR0NHZPd0lNcW1YZGhs?=
 =?utf-8?B?YkJwcXJZdG1CK0pKMkE5VE54eDkvRnRyWTVhT2prVGJadUdyL0RENnJVTEY5?=
 =?utf-8?B?MDJXOHhRVjlhM0VPTGpsc3dkWFB6cGN0SDdDampXWlNSNzM5UDZST2dSZ1RL?=
 =?utf-8?B?bDY5TUkyaTJGeWMxaFp1SVRaSUFuOHY1ZE5KOHlyWHJvWERWZmFwcVRuT3U3?=
 =?utf-8?B?ei9BanVBTmlES0pQVnpZOEYvRldoNS9FUStSODZXbWNJeVVtTmVWY25pK01I?=
 =?utf-8?B?dVZYK0Iva3hjbG5IUkxiczFMRVZNSlVXS1htSm5xcmhiczNkTmF4L1dxcXJI?=
 =?utf-8?B?WFVudG5wQm56WmdiQ0VxUFdEUCtDOE9MNTZTL0o1OHdKNmcrRzBaVTJhUFNk?=
 =?utf-8?B?NzBnQllxUlFFSEFOdHlTTGdzTEt2RmNWZW9BUkg3Uk5lbDlEVmM3cCtMMVE0?=
 =?utf-8?B?N0xic3FqajNnV0swOFFlc2s2RE9oNEZFUktSelBPOXBVRCtHU29WQkJsVWpj?=
 =?utf-8?B?V0c0WXh5cTZLdmdFREdJMTZmaXlPVlhJSUVOc1FhdGRvUER4SjRvMTFUVDVu?=
 =?utf-8?B?MWNxUVpQVERlMWgrRHdRZW8zUko4VmZQdHVKYUwwQnhpOWRXd0hHUFhjLzM5?=
 =?utf-8?B?UmQ3a1B0bmcxRnFLa2tMRVFVR2o2c1RSQUNkck9aeTFlY1FmUnZ1bWhDNkZI?=
 =?utf-8?B?OFg2OCt2Y2xTTmU1Y1dQQ1hnTTdqTG5XTUFTSmNZSWhlVEdqUzNCMWhtdUhS?=
 =?utf-8?B?ckVuMldiYmJVNmtLdHM5eU1WcHZRc1ZMSkI5NThQVStwQ3JoaTByMGt3Rkd0?=
 =?utf-8?B?ZkQ5aDdyRklTVjEzUGFrUU9SaUJrTWd5Nmo2UHhkU1pFNDlxRjNkRHRoQTEv?=
 =?utf-8?B?STZhWlQ5QUEyZG96MWJaZU0yOFRXdW9TQTlYaUcycnpTSlJuUVpLZUpVcXRj?=
 =?utf-8?B?aThwOThTTVFGMnlXUmIrTG9LYmhSUGdnKzlDRFZQN1pJQVcyVEFwd0JkWHlH?=
 =?utf-8?B?YnVTMXVwdFFud2VBUm1YYU5lejdyQm9qbnQ5R3dQckc1ckw3TW9uSEVuNjh4?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0be10b-38e5-42da-c48d-08dd0e487999
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 18:30:59.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrJLdpTSKeq86F1yYdfjm4Zn6D0tDzPmF6EUmuCUxpaJutYiyUNLlTohY3mwI67Qy3ibs+ElEgRoZooIqZbd02LOfXAPjcls2vhe96+Jbb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8109
X-OriginatorOrg: intel.com

Hi Tony,

On 11/22/24 3:58 PM, Tony Luck wrote:
> Resctrl uses local memory bandwidth event as input to the feedback
> loop when the mba_MBps mount option is used. This means that this
> mount option cannot be used on systems that only support monitoring
> of total bandwidth.
> 
> Prepare to allow users to choose the input event independently for
> each CTRL_MON group by adding a global variable "mba_mbps_default_event"
> used to set the default event for each CTRL_MON group, and a new
> field "mba_mbps_event" in struct rdtgroup to track which event is
> used for each CTRL_MON group.
> 
> Notes:
> 1) Both of these are only used when the user mounts the filesystm with

filesystm -> filesystem

> the "mba_MBps" option.
> 2) Only check for support of local bandwidth event when initializing
> mba_mbps_default_event. Support for total bandwidth event can be added
> after other routines in resctrl have been updated to handle total
> bandwidth event.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 2b198ef95e1e..2d42d69ddbe5 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -65,6 +65,17 @@ static void rdtgroup_destroy_root(void);
>  
>  struct dentry *debugfs_resctrl;
>  
> +/*
> + * Memory bandwidth monitoring event to use for the
> + * default CTRL_MON group and each new CTRL_MON
> + * group created by the user.
> + * Only relevant when the filesystem is mounted
> + * with the "mba_MBps" option so it does not matter
> + * that it remains uninitialized on systems that do
> + * not support the "mba_MBps" option.
> + */

These lines are trimmed unnecessarily. Could you please make use of the 80 columns available?

With typo and style change:
| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
