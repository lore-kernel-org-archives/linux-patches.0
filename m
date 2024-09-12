Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB5317DFF5;
	Thu, 12 Sep 2024 22:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726180400; cv=fail; b=I3/80FIf6o7qdWb5xuvzuzW0K/d1RD8a0cOfcGO9KNhJnKnGjH3PmKQkAAHfmcRBTZJsOQoVKKxfa0dZFVtbisrZ67YjvpIgtKI9wuW0wyn4DK2nxEz/trvVtDa3tAoMYUqNyxl+OMMLDlaFnhqkN1x+AJ3VzAGfHgxPVJjl8ug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726180400; c=relaxed/simple;
	bh=WpYyCFMVrOilhQ//efExa8eBtMaSE0BfaJ1HASIgMVM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RqKZDHH9509Mp3wj94dVglrsRJ49l2LUXen3HPjRk5Qei/2TR3T+UsVemQDlT+nI41LJv3/V48U7n85T2OIcgefewLwu4+PMV1MSRX0SUppaOb81HvlyNhLfCtVhpcKkPdHqs9PKwI1hKYewZt1OKpOAaz7vYV20rDqRdKhTxQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jsi7DTtT; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jsi7DTtT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726180398; x=1757716398;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WpYyCFMVrOilhQ//efExa8eBtMaSE0BfaJ1HASIgMVM=;
  b=Jsi7DTtTKTdesQTBBTwYXI6icJus3XO2HpxY6u4kVAFW+PoILr2g8Cg8
   2wxltxF4S7EiU5tKvLCWTR3JNuAJsUsM5Vb2+HXTJ2qimKf36eV1/02Oz
   YQbw0azgNf9YCZNQq1CGFzdATs6tFpjmiJN2/9Vut8HpXA48DjkkzG8LJ
   x7KB6e0e4NhoJybvbZ5CNvTUXcYj6tA5klGKFd3u1TQFe92Q48Z7jutQM
   lerV/Hi9CDk7Kv8F7rhditXO8HXSXyHewwM0xuRPKu+ju/GmHGBOOjH0S
   W16IZlQjbh4nYWhcMgGZj656P6BJdfucQi7eQBijrjtS+vWsAbUCN+jV5
   g==;
X-CSE-ConnectionGUID: ywAsCOI1S5+qYIZbtGKV1w==
X-CSE-MsgGUID: S2qMp01JRw2SGjhISV2VIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="27980883"
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="27980883"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 15:33:17 -0700
X-CSE-ConnectionGUID: NQkEBBsVTiaTqOQsijRujw==
X-CSE-MsgGUID: kMVJE2rNT66YG4zCPKSIzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="72651656"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 15:33:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 15:33:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 15:33:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 15:33:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pq6cg8YI5F+w/uo2XXnyZ8lxC8MsGtJXcLKbU1XGV+Cgy/2temn1FOUmBPcOnfSkjciWk+AkwhQerbJfqLKC/GVF0o2fnOFOLexsnM1NFoW57Hckjj0EWD1mSU1BTJjPeS8lkn0CXcqsNIVWhwc5X46JWIyqd7uBbn+yhN+03QiKmVGQLA80lLbmy/TXtk53LN/hkGvBFswwwsSqTg089zw2tFd38pMZkalCZ9HXXrUGF7cJ+iqzJIZ93fEUULi/E9Ma8n3iC513Gi+++RPOYTQrebR8YyJswnz+rM1vcxfQEpB8S8vFGb93zb0kD9CM5rYULxoQyyG2idZ0UT1Ucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1h8/x5hd1kh+IReKCK1090W5lUqEpcCSeeW5KF2CO5Q=;
 b=NoBvLh0sm3AlPeEy8CP3QYvDFoR6Sm1PoT/Zxc7Zmi+BZyn9otoGNvDBoVEE2nlbdElJQ26BZ6FglEsBmtjy2yM3W5Ziy84CJGW+DrxYKK7Vz+4wyWGxxYulOKIs0nVSYNnuFsyZASG/ic9SJGJaOxDcIQPwNVe9gCjxZuZQkmd3M5F6JcxtjOcLmWewXikHJDJE7X5X53i5YFoH0DVc+NEl6cPEj6z9ObHkad8v4tnEUBwAjs2ZRD/W/Xn4PXY4DYfbJIp4kwcT9GyHUJbUm/PJjfSQgfx4gelyUHafzdoVSo1s72MQvy6H+MHOI5AXiD//Era3/1Zina62lhR+fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Thu, 12 Sep
 2024 22:33:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7939.022; Thu, 12 Sep 2024
 22:33:12 +0000
Message-ID: <fc49e252-6283-4a37-b4e8-bd329f326e68@intel.com>
Date: Thu, 12 Sep 2024 15:33:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/resctrl: Annotate __get_mem_config_intel() as __init
To: Nathan Chancellor <nathan@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
	<x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<patches@lists.linux.dev>
References: <20240822-x86-restctrl-get_mem_config_intel-init-v1-1-8b0a68a8731a@kernel.org>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240822-x86-restctrl-get_mem_config_intel-init-v1-1-8b0a68a8731a@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0273.namprd04.prod.outlook.com
 (2603:10b6:303:89::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: aa8e5236-d691-4bf4-8f3c-08dcd37ae276
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUxXQzdlUmdOV3gxdUpweGtjY2l0UldYUFFQQkJEcEFjdkY0ZklZR0hZdWpi?=
 =?utf-8?B?Q2dqWFdiWHJYV3JIcytQTEdybVVJYmpMV282QmdVZWF4S1ZjUVZZQzJPT3Vn?=
 =?utf-8?B?eE1rZ2VKenVNajNQZDNsMFQzSmhSbkdxVnVYdDBBeW12R0NVcStmNDRsZjNM?=
 =?utf-8?B?c0hwMFVuWEswa3duMWFWUkRVMEErZCt1ZHBhajJwRXY5TFlWYWxZU3lnYVVq?=
 =?utf-8?B?MEs4UEp1RWk5S3JURFlWa1dORnh4TTY0bEljSlVSZTdOS0xSYktKQzZadVNs?=
 =?utf-8?B?MnhjeGxLYWYvZ3NCZmJnSWI2Q0RCUjROTWF2OFRmWGkxckY0WlRabWFxaEpG?=
 =?utf-8?B?VjBCR2ZUYjRFdXZSNjhyOGFGZDE4NDZySk8wRVZUNi9tME04QW9lZURMVmla?=
 =?utf-8?B?OGhPUENiQ2cyR0pVSy83T2FIVmFPc2ZSZ0dsdDkzU0dzZ0RSSFFRYitjcTBw?=
 =?utf-8?B?c2ZhYlVPNU12QTBIMU9aemxsQlUzQUROa2t6MWFhMHQrU2lvZklhZEs3UFlZ?=
 =?utf-8?B?dUZ2Q1hwWmF1TGlDSWhzNDBoblQxMGF4ZTZpaU1TeDR5dUhtU2U3VmtZYlVx?=
 =?utf-8?B?eHErak1yd003KzkyWmVqcHVsN0svcFFJMUppY2RoRm9uVWNTOUNtcERQczZB?=
 =?utf-8?B?S3JkODkxQUtCTkRrQTdYbVJCTDZUV0NORHQ4L29ybHl2cUI5eXZSNHA1a3Ji?=
 =?utf-8?B?UlBQbHhoWUUzNmY5alBFdm5MVTF3amlqSEJrb0pPTzBUMTVuUGx6b0NSUm9x?=
 =?utf-8?B?Ny9LY3NLOTlhaGJ4c1k5dHU4VUVYSzhOdU4rRkVPMUQwVzNOU29PUW9SQjhq?=
 =?utf-8?B?Sk83RkxmaFJsckpBOFRBM3ZJQTlPT0QwaDlWWmFtd0NRb3dScWVhT0Z2Z1Zk?=
 =?utf-8?B?eXF3Z094cmZ5UVVCZUplVmxMVjkzOUg2Kyt1NXFsRlFHYTllMGdkMGRRSDVV?=
 =?utf-8?B?OEd1cEVPM1c0TFNoV2F4dEpiVWl1VE9pLzRxd204cFRZRjVDMTh0RTFFaUZj?=
 =?utf-8?B?akoxcVZkcHZXOWRjN1dJS2U4eW1WK0M5RVV3N0t6RTU3OGhwaXgyOWtFa1Bu?=
 =?utf-8?B?enlycWxMY2MxdFd5eTU1bi9rSDgybGdDQkJPSlpjR3R4YWVicWFIb2cyMjJG?=
 =?utf-8?B?L1AxYXdHeDlBUGdwNzJ2K2Z4UDhSeGhFOHBoWHpnTUhxcy9NZXhzeFgySURC?=
 =?utf-8?B?QjFyMkpyTFVoQmN6S1ZSRG1CMGtOSUs4LytNZXUzWkxsdy9NZ1hjd29wQUFU?=
 =?utf-8?B?QWNudVNYL0lYci9FbWhNdGt0aU9WRXhxVDd6MnpER29hS2FvWURsTVorL2hs?=
 =?utf-8?B?VWRDYks1VVgrdkdGSmlaUmR6YkxydkVrZWlOeTFpYU45ZVRMWCtQcXAwV0VL?=
 =?utf-8?B?enY4QzdWQ3F1TXJ2WVU2TUJRTm91eGNiYjJHR1FjaC9BSFlLWFY0c3poQStl?=
 =?utf-8?B?UFVCTVg5SEhoWmpNU24veDMxVy8wQzVMMk43eGhFT1hKMVdTbUxaYmZVbTF2?=
 =?utf-8?B?SFMzajRncGNoM2x5WEQ1VXpaRGt4N3p4R25jc1laV0dKQk5CZmFyTkFvbEpH?=
 =?utf-8?B?SUI3Ymg2S0wxK3I1R256Qlg2WlhqbWFiOVNEbnpqdjRCbTlJY1BJbzBiNXJw?=
 =?utf-8?B?c3Z3L2NneXJEQUI1SzJGTlh5aEwxUjVrSXVUalhQelU2K0tmZVZYUHdndVNm?=
 =?utf-8?B?Nkw5VThLc3hIV1NJd2orVkxURjcxaVNucTUvYitBbTMxSnNMUW12S2w2Tk1h?=
 =?utf-8?B?MmMvdEVtNy9LalNTMzcveDZqdEVTZ25CcDdZK0xYMERJbUVNWlRYUjlxNDAw?=
 =?utf-8?Q?Jw6hKKjkoPiohn4+fcwW/sFUnCOm+5cttq8AA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2RwQ3lXczUxYllCeFlVZXZzQXdzUHh6R0oxQ1RYQnhYQzJ2Qm43NkpFMGJk?=
 =?utf-8?B?VGdpSnYwSXdUcVVLYzJxTEJoNlMxTy8xcjczakhERFdHT0s2VlhRNU9TdFhC?=
 =?utf-8?B?VjkrN3lJWmlVWjNGQloyaUFLTWRYS051cUsyeTRiM0VsS3pXRC91ZGkvbjBW?=
 =?utf-8?B?ZCtGYlhDb0IyNE5LOG1FVUVXUG9Ed0FQYytnUUxtZ0NtU1VuMXRoMStqTUdE?=
 =?utf-8?B?QTVhMEJMeFFOUWtlUGsrVVpoZkpFRmV2aW02RXdqT3U1aVJueVQrSGp6cXFq?=
 =?utf-8?B?L3I0bndQcHRSTEwzNm5FQnFJT0JHSnFRZnFsSlVWdlBxVFhYZ01MelpGeUp1?=
 =?utf-8?B?N1ZqSDB5R0kyTnFqcVZkcVh6bkxFNG13Y0tiRUZ1K1ZZNE9mS1M5RXNlN1JD?=
 =?utf-8?B?RkYva21xS25kWkFQQkoralVDMkx4UVdmRi9mNHNsOHI5THcrbEg1d2hsUjgv?=
 =?utf-8?B?U21HQ0FqWHhOUEVrcFd5SWkyTklTSEJiRHduL1ZBVnIwZFJZczNTeDhldlVP?=
 =?utf-8?B?cGQrbmRiS281ZFNpdFpUeS9GRTIvdW85YU1KQlNBQ2N2cHowUWYwTkc2K3Nr?=
 =?utf-8?B?UFZENDRxcWliUkNHQ00rTjZlMk5jbDFqWExrVlhPWTAzUTZjVDZNYnhmZU5Y?=
 =?utf-8?B?MDg1REdGejJ3WUIzLy9uSXpmOE5LZjNIa1BaVTVRY0s0UDF5bXJHU3p3SU9D?=
 =?utf-8?B?YkRnckFkL255OFZGVm53SXlLbm1LY1lhcVVDbUpSUGE5eEJGYkVuMW5PaEda?=
 =?utf-8?B?SVhCTTRBQXFQT2ZWWW5XeTFla0pLOVBzVG5XbHFHaUJhc3VwZnJkWmVkL2ZU?=
 =?utf-8?B?M2xPRGJGTmxhRzRnckROVnpHZThUQytJeTg1ZnhJT3VLTk5WclY0UlBsMXFN?=
 =?utf-8?B?alVtaDF0QXFkZ05zYUE4ZS83Qkp5WXpydVpUcEgxNFAybkhjdWtzeXlDcjRu?=
 =?utf-8?B?WVBpVDU3RmE4Y3pGTTF6enJjZzRSZWVuVjV6S0dKVlRtVnJFRzRrTVdlNEtI?=
 =?utf-8?B?alplNmdLbXNjcmJZbnFRVlhnSHR1ZXpJVUtud0krY3FNSW1SMWoxeXFUNU80?=
 =?utf-8?B?OENWSTlEYlBuSVp5TStOYlkwWVZweXBlQ1YzTWNpNFhOMkd5R01WM2RLaHlu?=
 =?utf-8?B?dm9Xb1FXSmZKZ0tETG01U25zY2x2RkhadWx6dzRzTXk0bVp4NnVDTVdrNkFP?=
 =?utf-8?B?djVISzRqbmVHUlhIZTFKbERiMy95aGw1K1grSWtwMzM3VEQ1QmxRY3pIWTlv?=
 =?utf-8?B?bktWd3k5MnM0eGwzWHdKdkt3eURQTkhyQXh0alZ5UUpmMll1bXVLNFZPN091?=
 =?utf-8?B?d3Z3YjdFZzdJOUNiZ0thRkhVQ1Z1TUJIdWRtK0FwU3I0NnFmVURFeDZHcFg0?=
 =?utf-8?B?RWtrOU1TaW50Vk9GbUJsa1JUWGpVTHZ0cFpwZWhBK2dONDcrbUZXSHBiSjc5?=
 =?utf-8?B?RUdpSGlPME1mYzVqbG9vZTUrbzhCN3E3ajRYdmFNNkYvbHZRTlpEVDVyaFh1?=
 =?utf-8?B?V3p0eDlTaG5NTGw5S0JRS3ZnVmw0R25VNVZ1VVZiU095SVpKVmFuVEJ2L08r?=
 =?utf-8?B?QmZHSlpvUWpZQTQ5YnRJQ0FETHJ5SnA4WCtCdXhtd3BocUN6U3R4aVpqdWVE?=
 =?utf-8?B?VTZtUlFvbTdGbi91RVdBTUdrZDd6SE1SVittRU9oSGlYeG04Uk1ueThCR0lp?=
 =?utf-8?B?WUVrSVo0T1Q3RWdVeHdnczJLMEQxanVNdm45SkErMlQrY2NZdDM5bUdSZ2ZU?=
 =?utf-8?B?M1phcGpUL2hzd25nNGhmNXYzY3JzT05YQ0J3NkdEVi96YkdjVHJTQ3NWeEF2?=
 =?utf-8?B?emNtcXNGaCt5SWxIaTNqNVkxVUFwTUxSL3VUc1JQdFl3Wnpna25ldXNiUFRw?=
 =?utf-8?B?SDRjWGVLYmt2ZjlBQXJTWWd2MXlITTMzd3hnNWhzRm5BVFVmRGlIUkRFNlNk?=
 =?utf-8?B?TDUzZFdTYndJKzI1eEE1VkZNZjFoblNVK2hLVXBCQ2RYUkVmUHJxYXVCRzY2?=
 =?utf-8?B?V213S0gwM3ZaZDlWM3BUcm5JYjNlaTJzSXo3bUxqajArY1FtV2pLL2t3MXBl?=
 =?utf-8?B?RnVnbUdSNjBhdy9aOUJOOGhWZFNIenAwZGpBbXJvaXRRUU03YlR4ZGw4aXRN?=
 =?utf-8?B?aEJCSDEyZ05vMVBkVmNJUUV3TGx5VElIVU9TeElhRmRMRmZzS213NjNpQ3Nh?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8e5236-d691-4bf4-8f3c-08dcd37ae276
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 22:33:11.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnC1qBqj1nfb3gwII/PcP/5UE4Cge5C689k5DMnJrHXuYAuI0II7E5GIqhsD6holi5HQmesh4CBNLbck0COsEz5A0ZSq9/DMZbgIzHTnid8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com

Hi Nathan,

Apologies for the delay.

On 8/22/24 5:12 PM, Nathan Chancellor wrote:
> After a recent LLVM change [1] that deduces __cold on functions that
> only call cold code (such as __init functions), there is a section
> mismatch warning from __get_mem_config_intel(), which got moved to
> .text.unlikely. as a result of that optimization:
> 
>    WARNING: modpost: vmlinux: section mismatch in reference: __get_mem_config_intel+0x77 (section: .text.unlikely.) -> thread_throttle_mode_init (section: .init.text)
> 
> Mark __get_mem_config_intel() as __init as well since it is only called
> from __init code, which clears up the warning.

It looks to me as though __rdt_get_mem_config_amd() may need the same __init
treatment and it is not clear to me why __get_mem_config_intel() would trigger
such warning, but not __rdt_get_mem_config_amd()?

> 
> Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   arch/x86/kernel/cpu/resctrl/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 1930fce9dfe9..b28646f1d9d6 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -199,7 +199,7 @@ static inline bool rdt_get_mb_table(struct rdt_resource *r)
>   	return false;
>   }
>   
> -static bool __get_mem_config_intel(struct rdt_resource *r)
> +static bool __init __get_mem_config_intel(struct rdt_resource *r)

Surely resctrl is not consistent in this regard but I understand from the coding style
doc that storage class should precede the return type, so perhaps:
	static __init bool __get_mem_config_intel(struct rdt_resource *r)

We may need to follow this recommended style for this to be included.

>   {
>   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
>   	union cpuid_0x10_3_eax eax;
> 
> ---
> base-commit: 7424fc6b86c8980a87169e005f5cd4438d18efe6
> change-id: 20240822-x86-restctrl-get_mem_config_intel-init-3af02a5130ba
> 
> Best regards,

Thank you very much.

Reinette
