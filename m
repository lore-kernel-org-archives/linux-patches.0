Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022A120468E
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008252; cv=fail; b=FyZyyUTr4fW2HyJV3Xy8qLruWp1fcHQOGHdbCOQs+ZSoc6UBNCwisSLUqLGTy93KrIfzqRK/oDy8syy8Nc30vGoogTB/3tmGSRC8zt8Z7MnHxYvBBH8+w/p95xSsHf/YXa+LYsfvkChRLzTA6mUOxI6mC7jS3gfuOc7nQ10ywVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008252; c=relaxed/simple;
	bh=tNYYF4QE91fI25QNx5KnyU4pEUf3ObGmEq9Hxy1y8S4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F8UfPqx/VgaryqSlSxHu+vFbo/Zp66w7EoMJ6jWTWM3I7yMe1GfcLNSAuVXdgnCk5ZX7DjvOi5laWBzQ0P+cIuoLPpBNBdeNF9f3+1IU7SIbvwQ8TNepLh4HfCGjqRrWqI48LT9uP1J5d4C54sUcxbCmvPaydYXydkCAnjD/ssw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XL1Eo1s0; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XL1Eo1s0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008251; x=1783544251;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tNYYF4QE91fI25QNx5KnyU4pEUf3ObGmEq9Hxy1y8S4=;
  b=XL1Eo1s0do0/u3qrvXwN92ddGeXeJSFfeUIjS16musmTI+ALCku7ex8e
   XGQwv6Aylx/5fKu76Hzae+pEj5srZWdGA/fUtmW7tIYxB186IKNIMCHvJ
   yZyI9/m0kSAPJYnTcRASbjyx1FehehRXchO7UPbzoku6YcuUh6e9wI6/j
   egtZEm8uOkdeboVeoXqufH4c2emNvWv5tEDjJoFodhu3dTWNDcORdITxK
   yg/G0dotrnEqAPcLwab7/z+hpg5+n8v1sCT1z8DXUZDXDVPOj9/kq/muJ
   9FALqsMZLSJAMwioRQc4qzLX4ILIVaIKK4/wVxLMy6rT6U+IVDCqD1Xph
   Q==;
X-CSE-ConnectionGUID: iEdP4mhbQxSNI9bbdU4vnA==
X-CSE-MsgGUID: vseqAUtwRxWRlTv6Dzz6KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="65321486"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="65321486"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:57:30 -0700
X-CSE-ConnectionGUID: 7Jkj4MuHR/Wnocg3Ka4OAw==
X-CSE-MsgGUID: iENswAhaTOWuviyNqMUAKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155921587"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:57:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:57:29 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 13:57:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.55)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:57:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjJSQVVR95TSTvRqujbxZELyo++lO1bX1G6Delo5+95NMoEof5xQKL6+DgmiOPxZf8WIQKkw7KRDvuC8k56TwNkYlfSuEQeDov495ezx+8lAmKzw7dpTW/CPeBZIvSCcHk5uifxNn/Q4lw8PItAaiUwKQZlA2E1k6bcrSKkhXOUjMPmEQncHSR2PCMJYyJZFDM/DS87B0nS8dy/6jTkPb1mX4sYn+8tbXjFg1kjiuunisVb5tbCRjtiUsYHpUPdPwM7vSX0ZLLjUSifs8hedWiC3jNwcFMrpSBvRIH2pwOdm/l0pfUhbFdwJuiRQ7ATQ/Z9AkwA87l2FQxbi53Lh4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwgiSnkRhtMtlWUUF4lZGPzIa1v4INe9PHevv8Swm3o=;
 b=LUlSsrhl7wgNdVEDgcQ+h+C7t+isGEBp5qjUiB1RtsQ0wW+F5907OY479oO7FnD/+PeXxa+OIdilVlPhPBMDcDU5c6KR94rd1GgFTnhrowig2OBv75piqynhxcBsYqK+yVFEiqRX/QF6SdkhWhF4i3ZoL/9+wt7BW04xu2FK8k2adwGefHh/ZiW4BiipliTV3PaDNgM4wHyY9VcNzv5lx2J7TKBKty05GVFOclpgc/FAys0ZQXHe/pYdDENXW92sFsFkP+WorF4tGJDZ0gA7gpIjUpIdzEnCv6puMfM6RFlWdxlZnsjAx8mpl0p3mxqddCOMccNEZiWIlGeXg42Zjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7505.namprd11.prod.outlook.com (2603:10b6:8:153::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Tue, 8 Jul
 2025 20:57:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 20:57:26 +0000
Message-ID: <f93f68fd-8dd7-415a-98b6-a95c031fb986@intel.com>
Date: Tue, 8 Jul 2025 13:57:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/30] x86,fs/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0390.namprd04.prod.outlook.com
 (2603:10b6:303:81::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b36cf78-c06e-4e78-df5e-08ddbe620b31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NjRHc2J6VHZ3ZUhQdnNmZ1FlY2lrNVdUOXlkYTh2aWIyaG4xcmUvNndlaVJV?=
 =?utf-8?B?K2d6aE1uN0dURnFOYlFJTU00ejBjTmYrZnZsRSs2QW9hYlB5L0VMRDhhZFky?=
 =?utf-8?B?bll6dUUvZUNIK2U5MGtGM2JlU3dsRjZGbm1oY0FwWCtheUh1WHI1akVjVGJL?=
 =?utf-8?B?ZGQwS3B5TWludGdHTFZFM2RrdmJVS1NDSmJyNzZwOU5CRUVxL0hFTHI1d2pS?=
 =?utf-8?B?L1ZIZ2pSWkYzUVI5R1VaYWNuV3A1VUwwaFBsMlJtcnQzTEtuL1Y5YWgrZmtO?=
 =?utf-8?B?TkJtbm9VblBFdmFoT1MrQlRBeG1FSTlaQllyeFY1eDJtejdxei9PMDRjakdJ?=
 =?utf-8?B?Q2ZvTzhwZUVEdG9nTEloeStyc1pMc1RHbVhqZnRYRWtrSkVWTkljRGxRUUVY?=
 =?utf-8?B?dkE4TklHZXNTL2pXTldJYlBkVmRXYjlDU01XdVVHWjE4UVFVem1RZTkxWlRw?=
 =?utf-8?B?Q2cvQ05qWWQxMk5RUFR5MG9GaVlMT1ZpRUdxdW80ejhJV1lsQmd3Nlk2SVRM?=
 =?utf-8?B?RW9PYTlBWkxhYVFQK3g5WmVuVm9mK0xtZHZFUWtybWNmZW50TlJxeW1VNCtn?=
 =?utf-8?B?alAyYWZ5SGxSUElrUXoraEFNMm02czdDNHRscVpkL0JBdm5rbU13NzdUa3ZZ?=
 =?utf-8?B?MmJ0T2ErdTErRmNBbUFCR0dVS0Jub2pUWUQ2RS9WOUgrcVJvK1VBRkJwcjBQ?=
 =?utf-8?B?emhPQjRFcnA2ejB2dnl0OXJ2dVY4THFtN1o2ZVRFVmQ3TjlvV0VlRjlPclNz?=
 =?utf-8?B?aWhva1Nsam8vTEZvMEVPUmNvMkhmUWp4L3hEc01OdUdEOWNwaitDb3JzSDhI?=
 =?utf-8?B?cEJCV0pDblFOclhLZ1Q0a25kUDZYM2dFMDVBNGZLOXJoelN5WFY3MkVYTm9W?=
 =?utf-8?B?RW1FQzJhQTZuYjFhM0JCV1dMalJmYTRoM2dKVGhsT05CNWZ4R3VFOUc4NVlm?=
 =?utf-8?B?WklSWE90Slp5SlQvcWlkbmROcE15Nlp5ZDVZNFRJemc5L1BNMUluTDVsZjFm?=
 =?utf-8?B?ZjIyWlIvYXhpSUpHcFNOQkZFVWx5aG9nTUo5TDc1d2JaKzA0bkZxSTVJeTIz?=
 =?utf-8?B?RzFseENIeDRPU3ViSWhNSDV1M0RudkZmRzFYOTZvRWhJWVYzbkxUZ2U5L0RM?=
 =?utf-8?B?TjMyVnQ4a1pjWE5Fd1U3dnVmTHExdlhQY1FJR1RTeFk1eHgyQTBId3NmcDMy?=
 =?utf-8?B?Q0NqR0h5dTE1ejBQLzNCcDZlUml3ZDN0Q0tqU1d2eUhjZWs4SlE2NG0xZ3ds?=
 =?utf-8?B?djhsMm5TRjRDYlBndGRrU1Vpc1U4Zit0RDVHTG9QWDEzZkZNblRNOUszdTk0?=
 =?utf-8?B?SFUxcmRtaFZ1TDJyR0pINW1sajNoUURoUHVNQy80bWx5RjFJUjBiZ09TbjFC?=
 =?utf-8?B?NjZTY1BYYTVWQjc1QXczQkxoKzBpcEc1TFVKbm1TMThndlBKK2V6MkFuclZx?=
 =?utf-8?B?aDFrQkpEbkUwaEkxcENPZWxDcDVmcE14bktyNHZJZVRDZWcveWxWWlNuYU5r?=
 =?utf-8?B?MXNjdUlBNDE1a1gxWU1PaHp3QkxuZndQTFpjYTVWZHorRjh0RFQ3QnNNNUw3?=
 =?utf-8?B?UGk4QkNLd3RqbHhoVE9EZnNLeXBIWUJhZ0ZlZmZ5NHk2a01hZnAwdnU3WFVr?=
 =?utf-8?B?TG1YcWg3VEliSlluaDlVL1Myam1zbXlwdmV6V3grZHdLRmhiZ0paNkdPM2tl?=
 =?utf-8?B?QVRiaUtrRldEdzFkcnNldnE1eWt4MXJ6MFc5UllSNlNjWWJ3Y3pKTC8xdGZK?=
 =?utf-8?B?OU5CeXN0K2hXNFlIdEJZeHlGbDZ1R0JaOXN2bzRpVng0ZXpQUTlTRWF2R0V3?=
 =?utf-8?B?dkRrK2xEYkc0cWJFQUxJSkJqQjBHUisxQjVGOXlYUlM2Vng5ejBIVkYvV1pa?=
 =?utf-8?B?MmdleFBUWHhoL05GczZ2UE5qTmM5UEM3dEE1T1Nya2VCK2s0RVFPMEJta2w0?=
 =?utf-8?B?eFkwVEN2eFVSQmlObm91N2tMeWxHdW5zU05QVVRneXFWbDJuU1h6NHJkVVI1?=
 =?utf-8?B?aFphUVdQT3pnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHpHUWRKM0RZc2w1MXlJb0NSVTlhR0UvL1JPYlkycW05L1lJU2RNc3M5aUhY?=
 =?utf-8?B?Qnkwa1BTZVZxUEdSU3pYZ2thdXlSalY3TEUzcXRSaFhDTjZiNGJLN2xSTDhn?=
 =?utf-8?B?Vm15Tk9RUmVJdVB1VXhpdzBWNUZhYzhyT3orbm15Z3dvOWhaNHVpWGV4UDI0?=
 =?utf-8?B?NnA1aFFsbnBGbWVWOHMxTlJEczZyVUdIbXpsRXJFK1dEa3BYMmJta1VrSTFv?=
 =?utf-8?B?TUJuWWx1ZmdObWpMOG5kSXo4by9wbnd0R2NZZWNSQ2ZDSTZXU1Fvc05RWHFa?=
 =?utf-8?B?TkpwUnEvVnRVRkZMQVJOcHpJNUJCT3VNQVF5ODY3ZS9UaVhEQW9tQnpSMnE1?=
 =?utf-8?B?QTdhRm5IVDJCM2pSYlFZaFRKUjYweWI3SERxR2RQci9UMUx1WDIvS0EreEs3?=
 =?utf-8?B?REF1M3ZCaVYwUnRsZWRKUWg1TVFMdFV5RCtyamExUkZYaGdNalpOZnFKZ2Jk?=
 =?utf-8?B?ODFhV3hZM04zVTkrQVJaZFVTekdDcGpqZ0cvRis0eTZQUlJZVyt3Z1JPRXg0?=
 =?utf-8?B?MG1mOEJua2dDcGpwWml6QUg2bCtSNjdNVEx2eUJocUhvbFBlYmZkYlM1eDR6?=
 =?utf-8?B?bWt4RW56dWQ0RGtONS9aRlhrMU1UemJ5ZjYwMDdlZWxacHFLR1RBVVlMS2RT?=
 =?utf-8?B?UE5DV1prYmJPbUN0SmFKOTZmQlBvUjNjNTZJMkt0UHE4RkkzbExaSUlSU0xQ?=
 =?utf-8?B?RENOL1NmTTBvS1Z3aVRENzhQR2c4M2hVdXNkK0RMWm5uZHN0OElETlFUanBR?=
 =?utf-8?B?ZUhNYVFpNGZNQkNaT1NmTEdSVUZrdWJaYXRNMm9FZFF3d1BOR1lWc0Y4bWlT?=
 =?utf-8?B?RGlueWRvUXc1eGMrSWJRZVBaR0VhSmFYOG1ZRWQyV2ExNlR1MndnNHFOckx2?=
 =?utf-8?B?OCttcXBLMzhRUktNUmhKdkFSVm12c0xjSnV5M2xvZ3RaQ0gxTWU5K0hvUHdN?=
 =?utf-8?B?YnJXaVYyMTcyV3hlQjlhRmc2Y0hLOTZjRVV3U3hmQjFoT2pjVEp2cFJBdTBP?=
 =?utf-8?B?QWhla1hicFY1TUI5SWVnalQ0L0FJNGNBbUZ0Vzh2a29jRkE0QllGT054WEdF?=
 =?utf-8?B?NGl2bDRzZFJtL3R0VlhXQTZ4Y0F0NEdodTBSOVRjZ2h6c3N1NVJwSTl5OWIw?=
 =?utf-8?B?RTA3SXEvTm9lSHhvOUpPSG01RWNTSXNDRUM1RUNTeHBLL250aWhkd25xbi9O?=
 =?utf-8?B?TXFxWnNDM1BEUWtpbjZkKzFVaVFOekhJNk9RVkxDVzBYM2tueHZvWmt4bm80?=
 =?utf-8?B?WmRRSXBwdHlaVFF0czgwVGQ3MDNLdVc4WmpVU2ZCZlFHYzk4clcxRGw3TmFa?=
 =?utf-8?B?SXN2dmlLcGdVUlJPMXh5TWo0WHlvZEc5d0RYTUVGZjFnRjlZM2VEd0x3eXhu?=
 =?utf-8?B?blYxRlR1c1JWc3MxSjdab3FmY2s3dG1Vak15OXBqUHRJeWQrQmJ4M0FHWnVC?=
 =?utf-8?B?ZFVkcXdXVmFNZE1LQm5SMXNhYlU3MnZSYjk5Z0I1QTExNk5rZnFMbmRNSlQz?=
 =?utf-8?B?clJla3p4VjVuak9yaGJiVlNOQjBhN29pT2pEcGliNk4vaHRveENCUnF0ZEto?=
 =?utf-8?B?SzhrQ1VkbVc5R01NVDdoa3l2dENNR0FYakJacStRRVg4aHFiTWRpZXBySXNI?=
 =?utf-8?B?TmY2Nk5xSURrcVZ3UEZwaDdyTkY5alV3RktrenNUQ3lQMmtDSjNidDBJK3Bi?=
 =?utf-8?B?MU9lLy9jbEk3Q2xZb3g3cFlkM2VNaDdpbTlhcjdLbk1rbU1MSDRnelhvY0h3?=
 =?utf-8?B?dGxEVkMvWmlML1VpMVJiZFNQRm9xVFl4Kzg3alErQ2RhWVpEMkhvYjRSY3J0?=
 =?utf-8?B?KytNMEhwVHE2SG1HaFpyU1V2Z05Va1JoVUpDNHFVd3A3cTJIbVI5T0R4S2gy?=
 =?utf-8?B?NTJxQnhZRWhvVFVSRG9zUDNhNjFSR2JVVGtTQjdxamVWWGhUckZDK1dWNllt?=
 =?utf-8?B?aWxWcHV6NFNnZ3Z2aURhb1lCVDl6aEtESlkrMytCU3doSGRHd0hUejZ1ekQ3?=
 =?utf-8?B?dGczYjNUWFRCNEdXSEVOUTdSaHR5a1AvQ2ErOFZPWUZYTm1aTjFvUkJxMmtw?=
 =?utf-8?B?UFMyYXdLendvbFdmK2ZlNXg1eGgraWhrMmFCZC9CUllLWGVEUTZSeTM3MkRC?=
 =?utf-8?B?R3BlbHRLUFVwdnJnWkJnU0lQNGFWUWpER1JYUEF1Z2oyQ0duYUZnU3ZCMXNq?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b36cf78-c06e-4e78-df5e-08ddbe620b31
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:57:26.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWYoF8AbLttgQ/Al7Hk+CM4Lxvr0EpvDoSqso5z2VLCuNdHeZZRJ/5VF92MlnBns8WnH4r8P4bKAmPTJnu59a4HMkmoyOsK/5wnSh5pgqZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7505
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource. This will change when support for telemetry events is added.
> 
> The RDT_RESOURCE_L3 resource carries a lot of state in the domain
> structures which needs to be dealt with when a domain is taken offline
> by removing the last CPU in the domain.
> 
> Refactor domain_remove_cpu_mon() so all the L3 processing is separated
> from general actions of clearing the CPU bit in the mask and removing
> directories from mon_data.
> 
> resctrl_offline_mon_domain() will still need to remove domain specific

"resctrl_offline_mon_domain() will still need to" -> "resctrl_offline_mon_domain()
needs to"?

> directories and files from the "mon_data" directories, but can skip the
> L3 resource specific cleanup when called for other resource types.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Assuming [1] is applied, this patch looks good to me.

Reinette

[1] https://lore.kernel.org/lkml/aF3lRKURweT4mhAj@agluck-desk3/


