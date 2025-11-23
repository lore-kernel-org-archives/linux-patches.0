Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED11EB193
	for <patches@lists.linux.dev>; Sun, 23 Nov 2025 08:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763884938; cv=fail; b=Br57fHW6wOj4Zj7ULgQA5b3gYjVicoUe9rRsmkROuqIbW/eXVbDXH6QLZwVHEiX3XSTn7+BclUZdr3SgSO9erGg+awEXk1Vff0iRt1/qHFAL2rlSu/aD9E6t7Pmln024YEbiEhmr1pcqh/121Lq08wVZ6lN78QskRcz0ybQTaCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763884938; c=relaxed/simple;
	bh=MAMFT7CN7RSpk+lulIjjhmNoEOvvptY+hKGBnZzCW9A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TTA6Pi93yjGTsAnGRKVjxJ7MX22QAZMf6NnyVrBMMeTeLO0A1TSFmCc3YsxMiov+wScaFEAgKTDHgQrsH6E1ma7CRu3sKM+igbwsC7mocz2XXgFLhXyJVtkECftuGAF/68A6TlFvsAPkb5gQ6D6vJKgEOIhxY0VeZxQKlMFc7bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KCk+A0Wn; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KCk+A0Wn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763884937; x=1795420937;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MAMFT7CN7RSpk+lulIjjhmNoEOvvptY+hKGBnZzCW9A=;
  b=KCk+A0WncAjU6kBPWrcGOak+a0kxZlrrPF6xfjJoy/PvyD6xslVa6Jgi
   2aK78bCxz3VSBl+IGinBzA4hiD8aetJgEZOnHhgSSj3pthIcoy9+x/hdQ
   02dn6D1BDQP+4htBELvdOW5uefNeOO2mAFTTMB7EJuAo9dSBQnuwAfkwX
   LWM6rOznJb5bnUF3Bgkz4ZHt3vtAYTjKxLLaTgW8LwfKyAa4thOtCV5Bd
   tqF40ZqxTKTA9HYefuHwrex4OnmEJqyRzful28QX0NUZuWaNB4ggxnCQr
   n92boMT/RjSSAkNMJ8GApcQ/dSknRKWPBihdhPtfRBDC2PCjj2QJzlXzK
   Q==;
X-CSE-ConnectionGUID: J5d2lJGGT9uUXX9yXc37vQ==
X-CSE-MsgGUID: wnAZXTpUQOC2tmJXXNcnvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11621"; a="83306173"
X-IronPort-AV: E=Sophos;i="6.20,220,1758610800"; 
   d="scan'208";a="83306173"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2025 00:02:17 -0800
X-CSE-ConnectionGUID: kIQQM4YFRrmCW9ohC8BsEg==
X-CSE-MsgGUID: rP5w+EAVSna8PCT+UJpK5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,220,1758610800"; 
   d="scan'208";a="196521634"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2025 00:02:16 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 23 Nov 2025 00:02:16 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 23 Nov 2025 00:02:16 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.14) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 23 Nov 2025 00:02:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=evmbnR7O/zaOVXrKnphRe6gcMSrJMOySnQ4zSzlqdUwTQfUCqdATzInk0sF1YUkdADdXdwThR98c0PL1KCQcHcZvQ1TLOHTiAOh+jhADrcMXMZY55nP/R45vy67x1m90HYXimKLQ9e04aDsxPLub/ysds3Lc/DFNVO6rrJU2ZhVDC5k5ogmWd26kWuPiZZPI2yW1b6lCafNaa5b9/ULKbM5yqLz6biLyPevWFc1g62u+zZjPXlgEm/XbJCcyaiDU7sdRYARM4qCjKXrgY/eqpM6MCnuRPLsF35EvkK3RRC6cG/p8gPABUskO72kBAQAPMK2j+p/264kTkvp0h/Yc/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYtnGMy0G7nEPGjZTN7BKNT58GJ+6uhPAAC/ibhjWig=;
 b=nylav4Q+L1BMmENrEzRdOtrguF+Lw/iflS5e/7A681a2B08DQbJwRlrUhnctMYmoq2vM2sD3AeefidEHOhCKkgN3aYg4TfZK8/3HwmHsSKpCMTicdajVZDnNDtzd7EqfaJXFLNXg4SYo+ZgqAdgn6C3PozxVvdTHviC4vNKosMxYWC2RpDvRqRKWRVu9jumG0WfBqxITlfdw9HXzNQZ6bAALVfJl5vgE7Z2BuZUKy3XH6sHcgE1QvMwB7ewuqhqAa2NQgd4Ug4snL7bbUasUQ9wY14m07glQY5VKqA/44Q3KvKNIthPDTmGtV13bXtJYBg5RIEgE6MQEMTwv9rZXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8683.namprd11.prod.outlook.com (2603:10b6:8:1ac::21)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Sun, 23 Nov
 2025 08:02:08 +0000
Received: from DM3PR11MB8683.namprd11.prod.outlook.com
 ([fe80::2946:4b79:e608:58d3]) by DM3PR11MB8683.namprd11.prod.outlook.com
 ([fe80::2946:4b79:e608:58d3%5]) with mapi id 15.20.9343.009; Sun, 23 Nov 2025
 08:02:08 +0000
Message-ID: <c1d70e5b-bb73-46c0-91d7-8e32c34bbb7b@intel.com>
Date: Sun, 23 Nov 2025 10:02:03 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 277/529] accel/habanalabs/gaudi2: read preboot status
 after recovering from dirty state
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Koby Elbaz <koby.elbaz@intel.com>, Sasha Levin
	<sashal@kernel.org>
References: <20251121130230.985163914@linuxfoundation.org>
 <20251121130240.886306321@linuxfoundation.org>
Content-Language: en-US
From: "Sinyuk, Konstantin" <konstantin.sinyuk@intel.com>
In-Reply-To: <20251121130240.886306321@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::19) To DM3PR11MB8683.namprd11.prod.outlook.com
 (2603:10b6:8:1ac::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8683:EE_|CO1PR11MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: 90f8af1c-3007-4125-b9ea-08de2a66997b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Ynp1Ly9tYVAybDd5YmhtMktmYlRDZWVKNW93NWo4UzNubkw2YmovZCtKTVdu?=
 =?utf-8?B?WVFPY0d1Q1c4Z3F1bzJWV0thaVRaNFFDNmh4Q2hiZXhDWWpiR2JqQ1lmYTdB?=
 =?utf-8?B?SThzV2pTdkJDVGRnY293MmxHRWZqakkwY0dMbGlpK250Q0phaG0rNDlOcnBF?=
 =?utf-8?B?Z3NKV0NONGJ0Z1Y3T1hGUU9yM2tLekdNem9lU0JxbEx6RFlPRjBXdks0M1JW?=
 =?utf-8?B?UHZ1ckZuWTBHOGJkRWk0VUg3Y1ozd2phS05XRjQvNlhCdFo0TEdPK0FaMHh0?=
 =?utf-8?B?THV0cUlIMGVmUUdJYTJ1WXl4VjJ6dHNscGp4ZzlxZnUwUGFRcEhBMUsrZUdQ?=
 =?utf-8?B?RXltVzRmTTBoWmhyK0hxTlg4TEJuTVRVTjJuMEN1dE1HQWw1K3pXSTYvWkxB?=
 =?utf-8?B?WEZ1NGlHUXJ5M0ovc1N4bVUyQ3NGcmFuNllhUUhxdEV4SUNQWVNBTk1hb05l?=
 =?utf-8?B?QmlaSnVFWGRBa1RxOW5VQ3RjeU55ZStQeitzZUhnR1BHNDNoSEpRcGNMd3E5?=
 =?utf-8?B?R3RIdXdvNEZnWTdQVGtHb0trRGxkeTdmU0FmL2dTUk9XTGxFbnVRSXllaXVE?=
 =?utf-8?B?NEZJWmFFMHN4bXlZaHE4d0xGRVVQamZianZzeUU4MWM4SzlObmZsMzFwWHlY?=
 =?utf-8?B?NndKRGtZWWozTjVWZFJCK1UxS0hQYWUwZ2VZNTF3TVdRT3VaS0pWZSs4RFhm?=
 =?utf-8?B?bk51VlQ1dkpMcFJuRnRUdGlzeVptYkJGMmo4bnljOU1nK1daYk9uTEhwRXli?=
 =?utf-8?B?VHVGYyswT1dSZ0VjWjhQck1VdmFmWmE5ZlI4TjdvcVBYSnd3ckh6YVA1WXR5?=
 =?utf-8?B?R2xvM1pxTEN3L0o5OVNMWUFURC9vcmQ3VkVKV2xzZWVLcTJsWDI5b3p3Z3Np?=
 =?utf-8?B?QXNTbXpuenhoa0dMamNkS01FN2dFYkJZM3Z1THp5WmQybzkvOVJXV3UyNzk0?=
 =?utf-8?B?UnFTQXNRT05DN09idkZOSTdTeWZ3S0pwZDFWalhFalZCLzRUWlNVRjIwRVpU?=
 =?utf-8?B?TmN4UUdhSUtYSGNwVk9NQWV3Njhqb1p6RmZxUEVCN1hqZDdPMWU1Q29BU2Zm?=
 =?utf-8?B?WmpTdU5YUElaNkc4enVoSU9CT1ZKMDB6MGRNUnF5Y2JiZUkyOHRIbnJrRmhp?=
 =?utf-8?B?VC9aOEtVU3daNi9YdGNmc21tWmdIZWpmcjFKZ2pMMlZvT3ZVR21vYXlKUnB1?=
 =?utf-8?B?TC8zZkFHZDhIS2V3TnRBektmcTkzbjFRdVhFVnF3bnR3RSswemFSeW8xK2Qr?=
 =?utf-8?B?RmZldDNIWDVUdFhMMW8zbU11aGU2WmgvUHV6dTBNR2liNHhlaDl5d2ptbjFX?=
 =?utf-8?B?VytMbEhSUzh1ODhsa2NvVDNwUXljeWM5Z0x6SjdlOWRjMFhSQmlTS3Ywckxy?=
 =?utf-8?B?K2NKMjJ4U283RVNzY3Avb3krejNQOE5rT3ZGUnFVbmg1aVRIY0VTcFpGdEto?=
 =?utf-8?B?NFJpTy9sQlNOekhBTjcvaHY3VEExWW54bnVMS2hrNUU4SkVGdHZreDZBdGR0?=
 =?utf-8?B?bGVhSzgvZ1g0b3g1VnBBTkdTalByQi8xWU1lWjNmRlBvY1hvaHlKSVVUeGsx?=
 =?utf-8?B?K0VqQ3ZEdDVTeG5zNHVNdXhyUUpXKzhMdEU0QW9iYXhFZi85ZWRWMWttVzhk?=
 =?utf-8?B?Ymhkenc5a0tDNGozaFRXVGU3dWh4ZTNYRjNNMk9LYUFzclBsVi81S0x2dXNt?=
 =?utf-8?B?UFZSYXFJd3FpQ2tnVHlRaWMyK2Q1SlR2YXRJWHdjekphbFFkK3g3UUVKaXJJ?=
 =?utf-8?B?NTV4V0xYVWZlQnBaOFRGczZlZTBTUjJ2eDByNUp4U3FEOWFMS0k5V2tUclJx?=
 =?utf-8?B?cFNHV1pZdmtmSlBNMEVyWWZCNk54bGc5cnhnRjZkRk50azVKVkNNNlBVRm9B?=
 =?utf-8?B?Q1cyZmxkTnNjM1kzcUlQRHlwVWJVOCtoTmhxZTYzWi9wRWsxQVkzV2FxdExG?=
 =?utf-8?Q?W82aqvHwjNGy3NiGBJZnx6yp5X6oQRxm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8683.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NURwTDVhQ3NNOTNvR0JURld5dnNyUlBGS0hSaEhWR2pBVE5NTFVndzcxOGhi?=
 =?utf-8?B?QW9FYTBLUTNCNEdoTzQwTkxuZGVha2hjZEpSbmJON0psUHU1SHMzbmVQTFBD?=
 =?utf-8?B?RHQ5Q3UxdDZrQnRRRXpobWViMEpGRE01QVZKemRvR1pRR1Z3Sk9FZmZ5aFdE?=
 =?utf-8?B?alBIbnU2SWhjazg1THphdnJleXZkK1hLL0UzN2N4MkFpTUQvL284UmRzVk5E?=
 =?utf-8?B?QmlMcTBYQkM4YXJxYWRDRmkxRXJQOHpmNkREWUhjMmQ1TTFkekIydTE3amY3?=
 =?utf-8?B?RStwaHoza2FGVUo3QlduZUJKRnR5Znh5cHA1azMwcncxT21xZ3plWlV3S1gw?=
 =?utf-8?B?ajJWUFRlTHlwVkJOSWsvUHhFUStwdU5nam5LbU1OajZJR0RuRzFZdXNEWWVJ?=
 =?utf-8?B?V1ZyOWg4Z1BhdVQ0aGk1UFNUVUJ2RUx5UE1IaVFXaUg3b3RsY3dXVW5SMERN?=
 =?utf-8?B?WWpIVEE0UTdNTmdjcjQ4Q2pUaEJucXRQR0ZwRE01aytlVExrVVVpSEl0bUFN?=
 =?utf-8?B?RXVLZ3ZtYnA1REwyOWpUcTFGRlpXMFR5N0hhSFdMdmZ0Tit2RTY2eVozYWpI?=
 =?utf-8?B?aHM3RllPRnA0TWJwVzNRSThDakxhYXdzN3JEaFhJYzA1ZVZGb1FhSVd2VkQz?=
 =?utf-8?B?WU8weXFITi9IaU00QnorYWU3TEQ5OHZhbys0UWQ5ZUttWk1LUUZGOTl0dVZs?=
 =?utf-8?B?MU5SOThqb043TVFWUjhPZHZpM0MwSXFaQzN2dDJuU2NoZEN6YXU2N3crM013?=
 =?utf-8?B?NXkxbi9ZdG1hcTA0VWFGRjZYTGRJUkdIMlNHQzA5bWlNTGdYWlJJckxtN0tC?=
 =?utf-8?B?QWlKcU9lbTJLamlZdlR3MGZRM3A4T0RaKzZtMDNTVjlkQzFMTk5tSXRqYnZs?=
 =?utf-8?B?Vzd5MjEyQitHdzJsSXZRTzF1aHJ3bXlNYXdRZnlZbUYzOGhkQXBQMjE1VEhz?=
 =?utf-8?B?L2lpeE9tak02RG9ONnIrWlZleFdWUkFETTVibndHYlkyTW56akIwVVB6UW9M?=
 =?utf-8?B?V2dMQ1RDUmZzZUpRZ3RJTzN4RU9JL05BT2Fzc2FocDZ1U3FMU29IU0ozQXps?=
 =?utf-8?B?RjlYRExISEFTd3ZReHNoeWltb0g2cEF4UnFwUjNPOVM4NnplV1E3VmI5ZVdi?=
 =?utf-8?B?Tm45VGFFY1JXbFFUaXZZeVR3OFppVEZIRTR1eDkxcnBxSlY2YUw5NHordFpE?=
 =?utf-8?B?Z29xRWZUQ296ZFV3enlDdVJjeVZLaTRyeSt0eUFoRERGUUZtTGU1SFdDejZ5?=
 =?utf-8?B?cVBsc3NDQWQ5b3FHWTUzS0ZOUVVrYWtYNXE1cGhVTnBPTGZVMUg5WnE5WDNO?=
 =?utf-8?B?ZTNvYm92dFZtSEpyT2NnSUdhZHgrYXA1T3FSZFYwOTFBMmdzbEZpcnFpRkg2?=
 =?utf-8?B?MW54dDk1Y1VNSjYxdnVrNzIrbHlqbWNoa3hEWHpSRCtDdHRJTkcrMUg0Q2ZO?=
 =?utf-8?B?U1V6bmtsNmsrSzZVWEFWRTlKbk5qU0hWR21VT05NdzFCNDdjWjZCY09PT1Bq?=
 =?utf-8?B?eG9UaUxncm81QXRuVXRieVpaVDhEN2x1UjhPbWZwS0RINHNhVjVOK05rZ1Zy?=
 =?utf-8?B?ak9XUXhsM2tCb3RHSEtXZnE1Q0xNbVAvb3dBaFJncEpmOE8xaTU3VFFlenZ1?=
 =?utf-8?B?bk5KU2toajltbWNpYkRGVDEvcjBlTnNWN1V5L0t4cjlTTGF0dGl3UEtwRDF1?=
 =?utf-8?B?Snh3SE9FZVdCUEhqNkgzN0RvZzZpM1g4Y2l0Zy9SNnFFMkpLVDV5TVRVU1pi?=
 =?utf-8?B?WTZkWlpYUW9ITU4xNDVCWm1ZbTlUcEx0a2w5cVlNVFA2aFJVb3htMEV6WTB3?=
 =?utf-8?B?L3h1dVUrR2pybkhIZVRTZmZPRUhFRHVYRDdHYVNLSGU5cnlrTGdMR1hEQ2hW?=
 =?utf-8?B?V0xrOHljMk9qWjRsZ2o5Y0RnM0hXU0FKZHp2Qm40OUNUd010NWFMN0toSjR6?=
 =?utf-8?B?dGwxQVBhbExRNTA0ckltdmdZUXhlaUlYZEtJTC9BcnFGL0JuckVmcktsRnd5?=
 =?utf-8?B?b2p3QmNIdnRlc2VtR0dpVmN1U1NJVDhwRmFRclNXc3FMNitrYnY5S1d3dHd6?=
 =?utf-8?B?Z2ZXdjMzcnpNakFFNEVxWklJeXJ0SUNsMDFocjlWZkR6Qlg0a2ZTT2x3dkpm?=
 =?utf-8?B?MTkwSTRGNDAxRFRUeWRmOGFLUWdzZ3NZbXJFUmhKYXorL1hDU3hPaVZPaWpD?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f8af1c-3007-4125-b9ea-08de2a66997b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8683.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2025 08:02:08.5600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOBrGHmQxgvnt8vLmxRnxn3047ZmV3Yg3xKlE6/d9GGYdgO7QjZY6tAjUH3LRPKKkkNCXuNmOn548kaR4yElcn7ldnGgNJUaVxyYOKwKQRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com

On 11/21/2025 3:09 PM, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
> 
> [ Upstream commit a0d866bab184161ba155b352650083bf6695e50e ]
> 
> Dirty state can occur when the host VM undergoes a reset while the
> device does not. In such a case, the driver must reset the device before
> it can be used again. As part of this reset, the device capabilities
> are zeroed. Therefore, the driver must read the Preboot status again to
> learn the Preboot state, capabilities, and security configuration.
> 
> Signed-off-by: Konstantin Sinyuk <konstantin.sinyuk@intel.com>
> Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
> Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Looks good for 6.6-stable.
Thanks,
  Konstantin.


