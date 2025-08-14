Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155651FE444
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 23:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215874; cv=fail; b=k383xMqm5NZliZ8HUNulS+LyB8q1xmwO83yvNeWKp/0FF+KDeKbEJG+G2wRWOg1BhGg43scSjKnYTALt5FFTJpgxzb8+IeONXpTf/T593Fb2099Go7vl7Ua8K4jlQ3PNZFJmaE/1+YrEjvdTPipDN0Jj9oQ+gAi6mCFZuOcQXP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215874; c=relaxed/simple;
	bh=HXxGH+Eh5nZqgAoqqh/DhRy27tlAyLl4mux6z8eATjI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QI0dAOfQOeGFg51ywx1P2eUVA6pp71m+A5bN3k54f4k8o4HsW93NTRx1xVcmQpVYOvM7vySBAc0mzVNHBEawVRKaMjDmHuZmc2JVq2+LawrNzk+m3CpYAwclEnNegYSbn+NG0Gzl9+8nuZwkyAx6kKGCpG1U4yOAc3V/RpjM/uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g8L0dUGl; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g8L0dUGl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755215873; x=1786751873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HXxGH+Eh5nZqgAoqqh/DhRy27tlAyLl4mux6z8eATjI=;
  b=g8L0dUGl4prb8ahIpOC6PWK7mqp+DgCAGbAssMHKpZUSmPSipoAfDzXI
   6nX44zZiX7hjlDzFjh7wQA1kbr92hTNsyER5KwkEkysYynuBLSqvRDVPH
   LCXmoOQX13GcnCUJxPy/By/tkCqHZDomJIa2UddfTO/gR1j4NkUsw2vpw
   QdK/13Umw+C7A1uugZfCK728Pm5QEdCCOHCgm/D0fVdkFYjqa+KdCGR6A
   bj8GfZDmlsNErTzsrfrFSE24Hr5B0jWZS1kHnZsNCIS+HG9VGY/srtvHB
   s4Ik4nGRUt6FXiBFq5Y/zdn0FA510Sqou89N+9glI/okgtp5keR8pUJXR
   w==;
X-CSE-ConnectionGUID: 92kPrW8KSGezsxEiQwXUOw==
X-CSE-MsgGUID: xQEx/rpcTxu+SqyZtR/HfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="68244003"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="68244003"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 16:57:52 -0700
X-CSE-ConnectionGUID: sohpTPEkTdSBQCLYlqK+vg==
X-CSE-MsgGUID: M0mGLkCxTc68R7dl65JFVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166518853"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 16:57:52 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 16:57:51 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 16:57:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.61)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 16:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjfBDj8xtcLH9573q8WLrbodoslOgC6SlYLyxZDU0BjmJLK2xcnem08gaxyDDcDKHUTQc3NhIkIiZed9IQhZJn2S00o/WZM45LoKMEbeltA3f3XcuoETFDq/3Z+deFLqvCFbcyC4ydyM7d78lHKoNWf4VO5TtIQecuV7xuqTcAPMjC7y/NrVppdX3m/7iBQtpq8b33CJuX2fRzZQsAdcaSC23kkbzpK2c3nqzWqhSMBArHXV3f19ti8/4BEk8AU/Owgsetv+iTR8yH9HsYltX5qslRXYzdg9QG3TMv/kbQm85gYRm8OFlpM5Vv8jFYdcCB9Whp84S6c6gGkvitAPGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dyMXCzycofZxj0rmQ7APwUHN78+1hcuwsnRRf4V6uE=;
 b=C6Jsq/wdpT7ozm77VOj0INYA4OsFb3sS5VtO1k6swzlI9A/tv73VClpo5jy3zlXabJ/uBY6SeXSBoLH387pbdSm2j9HAtNfxZKBPDxW2FS8jSxRQCBkJlwVoF8KXTD4BRdmHv1iLiLrugK/aKhTwJiahAwnwLMqQLzsxdslIK792Hv4N6xqajHnvEQOfqXyzAl4un03/pDlG2vQZtGsqz/pqRB+RF06q6hepiRBb1zzVvkPFxsMN6iy+VUvsRQGFEW48m/wsTersTn1YEAWZnzr/8V6qh98CJMojMRBUe/0IsinZEq89Dd4mXjEkT4btHxZYcNQ0qE/Dm66f8FMVew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB9349.namprd11.prod.outlook.com (2603:10b6:208:571::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 23:57:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 23:57:49 +0000
Message-ID: <c1d03d2c-9f5d-4fcf-91ba-dfe2c5907292@intel.com>
Date: Thu, 14 Aug 2025 16:57:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0317.namprd04.prod.outlook.com
 (2603:10b6:303:82::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB9349:EE_
X-MS-Office365-Filtering-Correlation-Id: 02983510-4faf-40d1-bbbe-08dddb8e5fd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cXZqMS91dWcrMStxc1FOREt4ZUwzc1ZhQm9FSDNabGlvRTByS0o3MGRYeUpG?=
 =?utf-8?B?dW5Xa01FN3FxK3h5MjQwOGROeWR5Vkg4SGFxYjRnNHl4Sys5aGJHa2hvNWFi?=
 =?utf-8?B?Qk4za2VLTURyczdFS2x4NURsRmcvT2NoNDVrd2EzcTdVVktSN0xQZ1pESFhi?=
 =?utf-8?B?dW1ZOG9iRUxleitoMHFuK3NKdUdvbGpLSktIeXFsRysra0Y2NjhYZ2ZaMWVL?=
 =?utf-8?B?Ulo4MDlNRVZJbHRHVFJtRVFIZEJ3Mk9YM2RsK2tEalROMXlNcTBvaU5iR3Uw?=
 =?utf-8?B?Z2h6NzM5YWJGY2dlVlRpaVd5eXkxWUhTYVdvc1dNR2VBZk91VkNhcWlFMDJs?=
 =?utf-8?B?NmhVRHRxaEVYQk0wNjJKbS9oRFFhS1VZQkFwd2JtQ01KUFlMN2RESG5ISWlr?=
 =?utf-8?B?SzdxU3dtTXpXU2V2dEh3MTJ4VUI1cnQrWXNlRmExd3haUHVTSTZXbms4ZTJQ?=
 =?utf-8?B?eldJTWgzY3F3SWs4V1Rycml6cTZYT21tY2kydkhJRnh3U2NGZEVseXZ0b3Ux?=
 =?utf-8?B?aGN4MTJDWnpqbFBVMWRNY2ZrRzc0LzlNbXJBK29sNTRTeEpZWTI0Szlha0ZJ?=
 =?utf-8?B?WUlacjBvYXFRTjQ1LzJrUmNOcUw1REpTTE9WbHFMd0c3L3Z3THFpZEp2UkVG?=
 =?utf-8?B?L2JLQ0FHY25aY2NBczRjV0lNN2xFL3FIMFNVclI0Mk1XYlVTUVdOZlA0STRu?=
 =?utf-8?B?NWxMMUpUczc2cHl6cG16allDSGEwZ2dGejNWT05LS0hOQXdITWxOT0RSZnpS?=
 =?utf-8?B?Q2ZXcHo5OVZZTmh4RllvRWtHdS9McVY3SkliSDM5cjVrU2Q3NGJEWmdTVEpX?=
 =?utf-8?B?bXNDY2NjdDZ2Z1A3dDZWZFovK1dKWVZRZnZNUlVBV3BmK3NIaGIremdHWkVh?=
 =?utf-8?B?bVU2UjBlZ1dMRmZzVldmKzhrc0VvMzdIb1hmQmtpVHhmd01hQ29PaDBZRkI1?=
 =?utf-8?B?QU1tUldQUWVEcGIzL0ZXcXVQRnZFVnBYd25ZWUorQjJNRUU4Q2wrNm1salhu?=
 =?utf-8?B?VkVYSnV3OWt5MnFJa3hhdGdYZWV2bVpWakNJVEloQ3k2bTZ6VHRYTHB6cy9r?=
 =?utf-8?B?YlpWUC9qaGQ2eUpVQmJiU3E4VDI1b2loUXlXME5VVDYrSWxhY3F5K2FxY3E4?=
 =?utf-8?B?Wm43bStSVEs4WlYzc3lBUUVLOGtoYkMrTVFxWDJsOGFnSGRFZkZ1WlkzZzRl?=
 =?utf-8?B?VEVsdHhJUS9qYmE2RmlYYW42M0s0QS8yME14cXdZTjJVS3MvczA3NU80OXNz?=
 =?utf-8?B?RGdZSEo3QWlZeWhJcUIxbnkzVnJJUGRrK1RyNFBFWmNzZVUra2VhSUVyekRh?=
 =?utf-8?B?TFVnbDBPOUtJaExVaG04Mk9ucS9ZVXo1ZzVOSmwwSjNzSTUwUzgzNVhOb29J?=
 =?utf-8?B?VFVqVTAxNEdaa3krRGhBMm5aMDFPa3pTV0xDRW5lVGpCM3BXdVMrbC9yZ3lM?=
 =?utf-8?B?MU5taWxobWM4MlBwZis2VjZldXhlWDdaT1lqb0RRNCtiVHU1MVpZSmxvc205?=
 =?utf-8?B?V3ZMa0lNQVdDc1JmVVBWcyszeVAxbzVsVU5HTW5idGF1TnZUMk1lMVdrZzg5?=
 =?utf-8?B?S3ZsYVA1eFBCam82dU9JR0VSWXVaQVBwTWVJdkVvTW50R3JBN2VpdTNheVNx?=
 =?utf-8?B?SUJkTldlelFOaFZKTTZxaXV0MiszaS9lUERvRDhVS0xHSGhpV1d4QnJXZThN?=
 =?utf-8?B?dlJHcENCS2ZBTzFnb0pXWjhoK1JOODhlaDF2bk5FcHRhU3lMbkY4dFJ5NjQ4?=
 =?utf-8?B?SXU2U014ZEUwSzJ1MkhuVUJOWS9RcStlak9MbzBhOTZwdWhzSnBheEthSmoz?=
 =?utf-8?B?akMvMGFpWmFFeXArYnh2U0tXMkRiN0FSb2U5eGh6UVR3WW1yTEViSTZFU0ZO?=
 =?utf-8?B?dExRUmt1MmRIbUpIUkdCdzVPMGhpUkhjTnJtRWt4aEhCanFuN1RwWFFYNUVz?=
 =?utf-8?Q?wrmGaRTOuWY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHpWUDlndWIycWVhTEJvaTkvRmE3Wk5VeEVxWUJWRS9ySTRQU1lKWjgyUUNR?=
 =?utf-8?B?T3pCY3BSREVOakpyQTc3RXRqM2FJb25WNmVmc1cvb1FFNU9rNGxPWWM3QlJY?=
 =?utf-8?B?OVBldGxRYlMxQ0l3cDlpWEg4czBtSzJJdWRCWkFsUWV6S1BkOEFzWmVNaDdP?=
 =?utf-8?B?dm5WZkJza3ExMjB6VlV1aXBUUFlNNjV2OGhRbitwSUkvYUhOcDdoaDA2MFNk?=
 =?utf-8?B?K3lSME03NGdHT0ljeW84SnZXNWtjZ1pQT2wwMi9LNWVvNmZIZVkzOEM3WXNV?=
 =?utf-8?B?M1VMRnVMTHVMSzRYdFU1NTk3czR0QjlFTkZMMVVDUElGOTdYNmQ4RmJaV1kr?=
 =?utf-8?B?S0MraEZsUTl5WkJOeUludXgrbmcrYWFmZytGM3dhaHBCSWVzK3RrYXRjZmFR?=
 =?utf-8?B?ck1oZ0NEU09GWEJDT0ZXVXlMVFllaGpkc1daTXkrZ1UySDlMaFBYaWpER1VY?=
 =?utf-8?B?Y296V3BoU3JGNkZmMVptcjFOdCt2aDlzZ0xZaHc2R1hyYncwQy94dTUvL2hn?=
 =?utf-8?B?ak9TSG9Md3RUdmdzMUVuQzMzUXdBNllaWFJtOXREZHR5TUd6ZnVjd2V4RkVQ?=
 =?utf-8?B?V3JVUU9xYTFsczN2SXR5MlI4eUJreERzUVo4NXovMXN6VTFsWEJsQ3FGOTNG?=
 =?utf-8?B?UVBqSjNqczlxbVEyMEZJYzd4bEtBaGxxRTVya3l6bFExNTBkcWZLc0d3NHk0?=
 =?utf-8?B?THhjUFlGSlQ5Q0hyNEFyc2N3NVBrTW9XSEY1UTU2Zk5lY1NXSmZVanR2NDdZ?=
 =?utf-8?B?UzBHcVU4RXJFNndaRjZOb2RyN2p6aHlWY1pPSmE0Y0k4cmdjWTd2UmNBUjkr?=
 =?utf-8?B?Vy9sdTdPajJoeGlYeGppZ0FKeHB3WmdJOXAxcHRpa3FKMXJza3pKUW8rZW5J?=
 =?utf-8?B?c2J2b3R6dlY3a2lSNkZNVG52QytxNE9TUHFQZ0o4NTY1S0FhNUIwd2Y4WWl2?=
 =?utf-8?B?b3FkRHBMaVJjS1gvaWNEYXN3QXRscWNLcTFQTW1DTS9TR1hZZ2FCSHd4cXFa?=
 =?utf-8?B?VjczR2tjaTFKM1hXM1lISUJDeUUydXRlTEYyRTNZSk5XTE5NbmhpNXFYOWpw?=
 =?utf-8?B?U2VxeHF6Sm5kZGk1eG43UGtWM0NSOG1aSjhVM1o0MW05NmNFeWg5MGZCbDR5?=
 =?utf-8?B?NkhSRFBIOHZIWVVBTmJYTmJ3akR5VXBRL0cwMURTTUhNdGpJRjlqSHlKMjZB?=
 =?utf-8?B?b3VZSkhQZWQ0dnVxbGxQbVNtS3pMWjNoUXNzcFdIUy9ITUlQZUI0YjFLcVVp?=
 =?utf-8?B?RWwzUzNGL3gzaWNBaXNjZ2FyemN3SmdKbnorbXU3UWFhNXVEWDlMTHVrNzY3?=
 =?utf-8?B?UHlaV1lpQUF0SnQwTGl0cFF4blBlS1V4S1JHWTVuNVdKUWVpWEdaaEEza2Ru?=
 =?utf-8?B?cVB0UXZld003UzVGRjZGSTBWOGhHd3NPUVBqbG9LdUhFMFBDc05YNkFUbyti?=
 =?utf-8?B?WHBBanNUZGdtYU5FY092ZDYxdmE2VGc0RlgyOTY0MVh2OXJMRi9KWTZEc2cy?=
 =?utf-8?B?UlZpM2pxaE5nczB5WVl0dlN4eS9PRXJJS1BJTWxaY1dFa3FJRUY0dUVxUUoy?=
 =?utf-8?B?MDFKaUpYRUp5b3pKTUlpRXFXam5XYTdaZUNoT09TWlBKTXoyQWw0TGNoREhG?=
 =?utf-8?B?bHo3cWFhdWFSbEdlTHRncS93T1lXaGhKS0NhZURFUFloNy9tdG9JdVdycXVF?=
 =?utf-8?B?RzhLMXFtYWFYTGU2S1NyMjVLSkVCME5PK00zNlcyKzdDeCtzL0hRaENDdUps?=
 =?utf-8?B?eGtLWUxrTWhWRVpWZUtTeWFNckpEZnlUSFFsMjYvUjMwOUF5d2pUeUtRVFhp?=
 =?utf-8?B?WkUrQXVuYXhaQU11d3I1OEovRTJjeFFQMFBzM09NVEdzSnh3YTQ1NXV2YUYy?=
 =?utf-8?B?MkRieFVFT0RjQnlYRk1ncEVEeklqeTJFSi95dER1TWExY0JxVEovc3FkQVlX?=
 =?utf-8?B?T3RzYUI2Y1V5WGRqQVlUbVZzV2xWUXJZNjE2dGVpcVB2dWNFUjZHNVhMOGds?=
 =?utf-8?B?dHNWMVlwVlduMFpqZFZyRUlZR3hSZ1NnNnppc0Y5VnVXTnJLdW5WSEM5em1S?=
 =?utf-8?B?TEhNYlcyQ0dGb1JEZWk0UzBXckZFWnhQRnE4bzZIL29LaE5zcFp2dm5SaGUz?=
 =?utf-8?B?NWVJZFhwb2hqWUxFaUFnUDdibVNDcnozeWNmNUczb0NOZDJ2M1pNZmNQTUwr?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02983510-4faf-40d1-bbbe-08dddb8e5fd2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 23:57:49.7244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0SORD4MnEPlerLRhcjcMIbDwToeIlL91E0qkIy8CobW8BzpeFUGobh05UUL5JvqrCp6LV0c79Zf0GgccQAxfR+YiuCktnjizVdTCL7gZ80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9349
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> Background
> ----------
> On Intel systems that support per-RMID telemetry monitoring each logical
> processor keeps a local count for various events. When the
> IA32_PQR_ASSOC.RMID value for the logical processor changes (or when a
> two millisecond counter expires) these event counts are transmitted to
> an event aggregator on the same package as the processor together with
> the current RMID value. The event counters are reset to zero to begin
> counting again.
> 
> Each aggregator takes the incoming event counts and adds them to
> cumulative counts for each event for each RMID. Note that there can be
> multiple aggregators on each package with no architectural association
> between logical processors and an aggregator.
> 
> All of these aggregated counters can be read by an operating system from
> the MMIO space of the Out Of Band Management Service Module (OOBMSM)
> device(s) on a system. Any counter can be read from any logical processor.
> 
> Intel publishes details for each processor generation showing which
> events are counted by each logical processor and the offsets for each
> accumulated counter value within the MMIO space in XML files here:
> https://github.com/intel/Intel-PMT.
> 
> For example there are two energy related telemetry events for the
> Clearwater Forest family of processors and the MMIO space looks like this:
> 
> Offset  RMID    Event
> ------  ----    -----
> 0x0000  0       core_energy
> 0x0008  0       activity
> 0x0010  1       core_energy
> 0x0018  1       activity
> ...
> 0x23F0  575     core_energy
> 0x23F8  575     activity
> 
> In addition the XML file provides the units (Joules for core_energy,
> Farads for activity) and the type of data (fixed-point binary with
> bit 63 used to indicate the data is valid, and the low 18 bits as a
> binary fraction).
> 
> Finally, each XML file provides a 32-bit unique id (or guid) that is
> used as an index to find the correct XML description file for each
> telemetry implementation.
> 
> The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()
> to enumerate the aggregator instances (also referred to as "telemetry
> regions" in this series) on a platform. It provides:
> 
> 1) guid  - so resctrl can determine which events are supported
> 2) MMIO base address of counters
> 3) package id
> 
> Resctrl accumulates counts from all aggregators on a package in order
> to provide a consistent user interface across processor generations.
> 
> Directory structure for the telemetry events looks like this:
> 
> $ tree /sys/fs/resctrl/mon_data/
> /sys/fs/resctrl/mon_data/
> mon_data
> ├── mon_PERF_PKG_00
> │   ├── activity
> │   └── core_energy
> └── mon_PERF_PKG_01
>     ├── activity
>     └── core_energy
> 
> Reading the "core_energy" file from some resctrl mon_data directory shows
> the cumulative energy (in Joules) used by all tasks that ran with the RMID
> associated with that directory on a given package. Note that "core_energy"
> reports only energy consumed by CPU cores (data processing units,
> L1/L2 caches, etc.). It does not include energy used in the "uncore"
> (L3 cache, on package devices, etc.), or used by memory or I/O devices.
> 
> 

I think this series is close to being ready to pass to the x86 maintainers.
To that end I focused a lot on the changelogs with the goal to meet the
tip requirements that mostly involved switching to imperative tone. I do not
expect that I found all the cases though (and I may also have made some mistakes
in my suggested text!) so please ensure the changelogs are in imperative tone
and uses consistent terms throughout the series.

If you disagree with any feedback or if any of the feedback is unclear please
let us discuss before you spin a new version. Of course it is not required
that you follow all feedback but if you don't I would like to learn why.

Please note that I will be offline next week.

Reinette

