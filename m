Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDC527876E
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207464; cv=fail; b=tB8mNJYuZZ0sB2O3pikg3DY1cIqDc7/ttEVtOxNleoQKubSOXek49X8n42XfYyjya1l3BZwgABo3+MZlhTTyph9RJxK4ZI84zDmlYxk/O1l7v2FppRF9AJ2i3DzPwvjltuTyUDByxzwi31UpQbPruawp6TE6U9ZZmCFqmY/8qN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207464; c=relaxed/simple;
	bh=Mv10XX27ZO3ycs2+n4YFexvfPfDOIW1q3cGMUBifScQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PX2pXa9hxpIMGL9hRbTi3NisyZT5Hp8PP7REa5mxtSxynCL1Dymf7XTy/jwGXSCRx0dsOYGZ07RK3gXTNaonisPX5/Dh2Kyi7jdxrxgPoeUoxVmVUZg+WqgoWzG14J0TEbgvKCzU0hwOKuv56CTRAfAFwRHXD2rAFs7xlprlPb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tcnv9T5j; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tcnv9T5j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755207464; x=1786743464;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mv10XX27ZO3ycs2+n4YFexvfPfDOIW1q3cGMUBifScQ=;
  b=Tcnv9T5j0apWzRkLtRU3QOXhtdnNB+fMExj5B1aQxYFLI0KjnEzFc7v3
   ow0TvCHUpu/m6pzar9khPxvwDROqggvCPjWqtQquUzYR2To+9faLSB42+
   LHVtSCz0rC8IDsPQ7M6D45MpITrpjMnZvSXcZ9YaTWp6qbQSkDKpNJHql
   M/txkHrLaj+U2U4I4Vx609auPGmXtqzXg9XKttc9/8OBj/qPRqQPHwEdy
   RGBZfy3NTgEf0EFybjp7lDfxlBSOUrYvz6JTMHnRZcsdG8TDT/4tG1v9d
   VpBwujopTKxyI1HjglQJhcvchl54C91vEbOXD2sf1WkjAkxER2PLvIm1Q
   w==;
X-CSE-ConnectionGUID: QbD2kfcVSNu6f5gIhPaEiw==
X-CSE-MsgGUID: tSMxj/6nRHywCkKM3Kl19g==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="80116639"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="80116639"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:37:43 -0700
X-CSE-ConnectionGUID: CG2XsGY/QXq62O652eBpKA==
X-CSE-MsgGUID: 73WzR3vUStWofQ0tDqORdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166079515"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:37:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:37:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:37:42 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:37:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jFNUzseog376dap+y6Zr1PTRqDfdUsc25sErkhPqilcQkO/lsIN6o6yZSzrlfE52laNbKbWSFY59Yqv0a4EWyfAge0GJ2foRdPJyDquu6YWpUB0SrRmkocy31w159zS5JZKMFx59iQ8CvR9bv/EK20PWzmvVyAE+ovWfiquBkvtNHwRrhLlEJXwEMSzqgZLZzHtAYSdCwggqyHgx+tV9On8ZjcRd9a0YNhDfBdB3gUzUg6itSbnkQfVVd4YE4R7Ei7dW5O9bgIKNbFpeQBt75MDiSI4tdZaPY00/4HI6+j9sZYUeDCpf2u9+bf4dU2EVWQ+tcqQQGimToRcVSo5kiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZ79/DnsYdFr7Pm6hwfq3nhcllyoM8baYknGHCE0SvI=;
 b=wdWUfygzwLiiteyTQwEjNe5qvKulN/gMyrYm6NUZRVaf8a+ra5d/Ho4xf48joRmWhB8PYdYit7Ne8lMXPIFB66u59nzXa4kmCoS0Kw96eG78vEqnnsVV2O/Zb7+YaOTivAaUwNRmtiHtDJL32UyurmOItuotmwHvSNFzt3BHQhiBsBTIwsfFaC7ldpT78zSm3x6V5tHI6r0F0rAMZywZAGVcRtBnC8z+LNyJNYjLeJpE6lL/j3OgRYIKKGOhCSl6Qb0Kyu9EcnYLtDyadoB6r5odbgJcAxBOM32BGoQoUHG99qzVvL4k5ltB6sfnN2xgRJQdI1ly6QZLgvETOHbakg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6552.namprd11.prod.outlook.com (2603:10b6:8:8f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Thu, 14 Aug 2025 21:37:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:37:38 +0000
Message-ID: <4c587070-5f27-4a7c-9dd0-ff702fc9c6cb@intel.com>
Date: Thu, 14 Aug 2025 14:37:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/32] x86,fs/resctrl: Add an architectural hook called
 for each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:303:86::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6552:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f03a9ee-eef3-4af8-42d9-08dddb7aca05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZnpkWVZadG40YVJJZi9ZVjhiNExxbEdFVlZFT1YvVUFZdEp2bld3RC9hamNj?=
 =?utf-8?B?UFlZcGQrTFRtZ1JTeFo3a3NJTmlwZE9Ua2dCWm9LbjUvUC8zYWZRYnQ0QlhS?=
 =?utf-8?B?ZGZrbkZNY1pyQzFxemhmcVNpeUZqdGNqTmhCS3M1b0dtb2VxSlQ5NUtBK21Q?=
 =?utf-8?B?Z3hFNTBaSmxrenhlVUFWRjYwNXIwdlZYV0xsemV2YXlGZ3NZc0h5MGlBTTZM?=
 =?utf-8?B?SmJxbjJiOEVRN3luYWJBUXpMUzFOUTY2dm01ZHo5M3NLdkNDanhmc3F0WVdp?=
 =?utf-8?B?SGgyeW9wRDMxbWtQZTk2dXczelRXV0tVbjE3NkR4dndMdzIyMWlGRVhyZWlr?=
 =?utf-8?B?d09IR0lVb2FIYUsyaWlwaFhaQ0tBcjIxUnFoTVBtc0VuUUxxd2tNMVRzUDJR?=
 =?utf-8?B?ZHpncDBjQzRtSDNRci9UOHBEcEpLN0lDWDEzVm9YY2k0N1U4QVRPYXhUVzNC?=
 =?utf-8?B?Z0ZTV2VYU3BUS0tCZllIQ3MwRDNHNnN2UHJpN2VuQkV3RUQrQ25tdFNma3VH?=
 =?utf-8?B?L0d2cXRzaUh0eEpTcGZwUjNXSXVldEJCQjgyTzMzWGVwTTNPdklUT1M4R25O?=
 =?utf-8?B?R0p2cWpVRkF0azNlMlRUL3hQNTJvcEJEV0JtRTFENm52UXo5OG5qV0ZTK2Fv?=
 =?utf-8?B?NGtmNzlpZ3dGaEFXbHFTdGtkWlZwc2tCL3dmdW4rcGpiTnhHZSsxcE55OEFR?=
 =?utf-8?B?ZWZScGdLTytxSHBteVByY3FYVUJGalA3UzVvSzcvM2RIWENpRjh6anlsOFoz?=
 =?utf-8?B?ZEMyUWZnZytKdDNGZ0Q5aFBoQTRwSVdwNWZYUzFDVWxDTHU5M1hzY0taakpX?=
 =?utf-8?B?dTJpODdPa29FKzdSUG5WZC9Cb0lhVU5CT0toNFc1T2J5Qk45ZXk2SzdKd1RR?=
 =?utf-8?B?ZzFjY004SHJUL0doL2ZEVDdnVDhodXB0YWJFWTViZVZTWmF0cXRYc2NVUmNF?=
 =?utf-8?B?dXJHK2M5MXhOUXY5eUxtUUdxOGtHcmh4Z0dLRmhpemNtUXdPZlUvQ0d6VmJm?=
 =?utf-8?B?aG9qM25CS2EvVWNPb1hYTWdQSG81ZCtIT1YvSTdUbUZ4MXhndUV5dk5jMFdE?=
 =?utf-8?B?M0w5aTV4eSt5RjcrbXd1OWVwRTBBRDhqL092RzFnbVpON21neC9IdkpBWlpK?=
 =?utf-8?B?OUFldXVnRzAxdWVOcno0U0t5aGZSSlA4ODk3UTZqcEU2RGRrQVMxOFhXeVk2?=
 =?utf-8?B?UHNEeFZQcUFIOTlBZTZ2RTI4Qk9yUy9OT0JNUi85d0Vxc1BkeE56VDdJMk4x?=
 =?utf-8?B?dUt1N0FRNXorc2paYkhTV2xXYksxdis4c3dDRHpsSzJDNHhRZy9TSkYrWmJ0?=
 =?utf-8?B?SFplZk95RU5qMkZib0R5aUV1QlBVclh3TGZpandHY05kZDN6OG9mVXRqRG4v?=
 =?utf-8?B?cFJqcXFDSjAwbXh3N3JKM3dqTFlhdDN6VHNxc3NwcXVObTdEZHBpblZZMW9p?=
 =?utf-8?B?RW9aRWg4YzR4bWsyVytLYTRPeUw3dG16bVdRSjh0UmVZRUlCT2pXRGtseENO?=
 =?utf-8?B?TjhFL3paUmk4Z0lmUmh4SE93a2tTcHEwY2p2aEk1dXN3VCtqcnIrc0RNWkQ2?=
 =?utf-8?B?c2l0UlYvV2E1TzBPNmtvUndmbE1GQkZyVXA0OU14aDFSNmVYR2o5UStjb0ky?=
 =?utf-8?B?LzZ0VldLSCsvODJhNjdBN3hLVzdpZEl2RlM3RkVDNmxVSUZjRmovcWRoY1ZR?=
 =?utf-8?B?SGJIcEI2MnROZzg0MHhCUXR0ZnBMVnpNQmNWKzlpS2ltUnNFL1I2bjBhTkFv?=
 =?utf-8?B?d1lCQlJqSjBsc0w0NWp6STlJMkh0UW9zWSsybGJUYWU5SnlOQVFXUG5nQUJ5?=
 =?utf-8?B?Y0lwcVZFY2lwYTBIdTBqM0o0V1loZXhJT0hDdnFnejNvcTgrdW9oZm1mOEFi?=
 =?utf-8?B?a3hmaHI0QTNnajdxWmhTai9PMjlHSW9KS29XM2tWWGZHT2ZzMUpTZmFOdUFY?=
 =?utf-8?Q?KBV3KDSlT0I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VS9mdEsvbWZuenRPai9WVzduYTJucnh5VEpPV1U3UWpHQTR6d3dLS054VE1E?=
 =?utf-8?B?WVZIM0dtNitiNlViODNJc25jMGdscnVBYTM4UjhjeWxpbFBFS0ZtTG04SnBS?=
 =?utf-8?B?Q0VFbXgrQldZaGEzRlRBblVsSFlnUm96KytsQzVha2xjY09FSXcxMGV1Y0JC?=
 =?utf-8?B?T1gwdDhPZGNSRzczVG1iUXNVeGNYdU5zRms0d2tGYWFmNzJKYlVCSERpVGdB?=
 =?utf-8?B?Rm93TGRldEZhTE1vSXpsbkhkWnhqZ1ltUUhaU1QrSGczU1lEM2xUaGxUMnh2?=
 =?utf-8?B?Nk9jcGIxWHJPVkVWYlhMUmVWYjRHSGxKbmFWWEJHdUcvSWxEQ3FoV2J0dkVa?=
 =?utf-8?B?Q2VWTVpIMWxKQUMxSFFyMkdBdHVxMzVxcjlUbm5jMC8zVDk1VHlndEVZdnI4?=
 =?utf-8?B?NmFJNUcvbXNtdFpDR3dhSks0amVITFBVTHJNOHo2NFVvWmIwZDh0Q1hFelE3?=
 =?utf-8?B?WGE0YUFVaExYMUVtaW1WRXJ4blp0M1d0T2Q0Q1dxeE9adkNTY0xybUJlKytt?=
 =?utf-8?B?ejlvKzE3UisvTzVkb0dTWlpKNFR2bExrYWE3a0NTT3JDNVpjVXRrM3BsUEVQ?=
 =?utf-8?B?VlErT0Y1SHppVnNqK3BTYnRpT1BtTWRZWGFiRHFteHFBM29McVdPL21RRWly?=
 =?utf-8?B?MVk1Z3ZMb01leUZ6NWVCenQ2RThIYm5QSzI0azNjZmpBbGNvRnpRV01zWUY5?=
 =?utf-8?B?RmIzWlpUTUtoQ1pnbGEwdTNyakQ0ZTF6WC80RXFLN1NqSnlZY004dGZhRWN3?=
 =?utf-8?B?WE1jcDVnNzlmbnN6bDlEQU9ZekFzZVk3MHluVm83ZjlLaXVPU2FXL1hMUmhm?=
 =?utf-8?B?U0p6TjZ0cVJXL3hheGR1WFFIVi9PMXdYZUhtT1d2VDhzU1ZwdU5iZmJBd1p1?=
 =?utf-8?B?cUQ2UkVkOHc0N1hpZi9rUThjSTI5bnVMdjFOb0JMQzV1SFBtU3Z4enpQRFlP?=
 =?utf-8?B?R2E0WnFrV2FyaUV5UHhMK0l5VUI2R08rOGdOY3RRMFZjMjBMQkxRRUpVQUN5?=
 =?utf-8?B?VnNPVkVTNlQ0WHlYcEM4OUhCblZRSS9tbWJadTFiNVQzcWJUZGh4N0cyUC9u?=
 =?utf-8?B?ZEwydlNWU3JyS1pIMlhYUy9vc3JweExwd0diK0phWkRvSUhMV1lwclc3SkV6?=
 =?utf-8?B?Sk1TUWs3c01rMnA0bnBvL2N2d0l6SVFSa0d1Z2k4UHUxQU5NWWxzbUc0VXhm?=
 =?utf-8?B?VXZ2M1hCOEF1MVp5L2gvV0xEM2doU2hEYmRkaDlWMXVmeXhqTUI2U09xVWRI?=
 =?utf-8?B?RXk4b3VkV0VycTJ2WHE0bG9tMHRQei90UW82TGhuSFJld0VweUFaME1RQXhR?=
 =?utf-8?B?YXFhTXAxRWFxMUFmd3hEWStNMkt5aUtEa0FrQ1hLY2h1TEovWkhocmptR1hp?=
 =?utf-8?B?TUtEUXUvN3F5QXJsQlF6NnNYanJaUTlHREEzbDhaY2R1bGVuNC9JaG4yVWov?=
 =?utf-8?B?alJRQ0tFUjY2OU81UHBiY2RUckNuaUVaN21VYk11UmJqYldONGFxMjNZMzdM?=
 =?utf-8?B?bjl4QkgvbGJTVlJ5UEcxM245MUdONmJRR2YwTnlqakI4S0I3bjIxMTIvZFVx?=
 =?utf-8?B?U1dibkF6bGFsWXJvd2NBSURHNTFaeGVUOW01cXpLdkV4R3kwY3RwamNiTmZB?=
 =?utf-8?B?aXRVVnJGOUNoRU96MjJaenoza0dnSVhpUXNLTGJFdEV2b0c5YTdSYVJoWDc1?=
 =?utf-8?B?VHRkK3hvdEtyTmJoT0RyQVdzcktrOFE1Nm82YjJOcFJqUnpncEw1aHJITFUx?=
 =?utf-8?B?cHhVejhYT0xKaCtLTUp2RWZ5bUdKRlJDY2ZuQnZXYXB6RWdYTGh3N3FCc0lR?=
 =?utf-8?B?d01Ia2ZiUkkxamVrUExZQ1cyK3ozV3B2RUJKcFJwMGhnSTNyOXpNWFNoTlpJ?=
 =?utf-8?B?WC9aMk8vS29KTUZtbUN4VmkyTkxleEJkVW9tZG9nRU96NVhUUUdDaUlLeTJS?=
 =?utf-8?B?bzhhdjhpU05TMElua2wzUVB4UWZUR3dqLy9OWFd4UW5uWXBLNXdKU0xXSkF2?=
 =?utf-8?B?T1R1YnZPSE9lQ0JLOTRyNjZLc0tqV3p2K0hLKzN3cVdKSU1CVE5KN3VLazkv?=
 =?utf-8?B?K3IvWmpva29IbkFDWkE4WThtSXJYbE5JdWFUSHpyVzdadEp1ZW8xS2hGUkVM?=
 =?utf-8?B?M05tVFBVVEdvTVZneGh6Tk9Nd1VDaHM5YjNKazAreGlpWVFsN1RNajQwVXd1?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f03a9ee-eef3-4af8-42d9-08dddb7aca05
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:37:37.9489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIMolCkiEMECsO9DAC93kwsc5ABSiIV0/180cDWHDwpM4ujQuK4tbyQVrupiUkBemERm3BEtUCQt3Eq9JRPO80uVXOPI+OxCRCbl8aaFLc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6552
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> Enumeration of Intel telemetry events is an asyncronnous process involving

"asyncronnous" -> "asynchronous"

> several mutually dependent drivers added as auxiliary devices during
> the device_initcall() phase of Linux boot. The process completes after
> the probe functions for these drivers are called. But this happens after

"for these drivers" -> "of these drivers"?

"are called" -> "completes" or "are run"?
(i.e the probe functions should not just be called but need to finish their
work?)

> resctrl_arch_late_init() is executed.
> 
> Tracing the enumeration process shows that it does complete a full seven
> seconds before the earliest possible mount of the resctrl file system
> (when included in /etc/fstab for automatic mount by systemd).
> 
> Add a hook at the beginning of the mount code that will be used
> to check for telemetry events and initialize if any are found.
> 
> Call the hook on every attempted mount. But expectations are that

"But expectations" -> "Expectations"

> most actions (like enumeration) will only need to be performed
> on the first call.
> 
> The call is made with no locks held. Architecture code is responsible

"The call is made with no locks held." -> "resctrl filesystem calls the
hook with no locks held."
(imperative)

> for any required locking.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette


