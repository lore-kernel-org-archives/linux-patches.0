Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5A91B9830;
	Tue, 17 Sep 2024 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726586064; cv=fail; b=CvlxTfyqHMUrA+f+qpfw8jc+nG9D/jFV9x9hvIRjPTjblFqmLViCgwDL+eTrLDVvdV0ekxDSRuAcbWxpAXZxSYLO9O/33AJZce+tVGgmRvk6y/+sXbUwK54ajDOeQKid5sTadbFqifxhOgMejxhMpg9WP5V6fOHdR9HdYAbQC/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726586064; c=relaxed/simple;
	bh=TgkNmw0aPjvNoWP0DQPtgc1xFDdpVl+2+LI+RhuH9t4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WHrs50uRG1l81XLFHgDbdrez/mQCsD0rWepI9qXuP3mhq4Gpg84mKWBaXp1GbtChH4tkd8RWBpqk9igz0bh4Ovd7f52T8vlAvezpBncH4RGFPrWycScFtGiVq59ej6QEU2uuwBkp2Fsa8rqlCEtdqPdto82FGOkpKnZ4QxS5sco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bK10Tu7S; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bK10Tu7S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726586063; x=1758122063;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TgkNmw0aPjvNoWP0DQPtgc1xFDdpVl+2+LI+RhuH9t4=;
  b=bK10Tu7ShqeOWveVhuiJWTglbDXOTUQtaKkaHHUnZ3WR3S2SQoVL7AlZ
   YRy1furm7zzy4hH00x7tH1XZKDF+KkCmu5M1e8HPZGTp4WYwZJXYpPqXJ
   o7xmAzVXfDj/WDTWLLXlfrCp8lYrVQdKt60NZgv/RMeqa9trWPXOZK15F
   i6Wtk70ntnJnxN3KpSYS5kdNy6+QaOwcWJpzJIqdZgHAPwZRKJEG7dFIZ
   MB+ByM8QRC/Fs9vBYocSdS0jCvvDBmrutKTZqqJTXS1ZtrWz8Kx4vWWbU
   TleP5ADKtBFSSVsyOPY0/Ghl/zXs+WpIKfbpZ5sr3uSfWxZldeOUUZCdg
   w==;
X-CSE-ConnectionGUID: rimMQBNFQIWsBi/QivCHfQ==
X-CSE-MsgGUID: fl6pLDu/RBOXcoEHT0OrPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11198"; a="47958142"
X-IronPort-AV: E=Sophos;i="6.10,235,1719903600"; 
   d="scan'208";a="47958142"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2024 08:14:23 -0700
X-CSE-ConnectionGUID: 4ecvggeXSKSBmFMWL+GTTw==
X-CSE-MsgGUID: Q5wUKvwUTzWN3TgS8bSgeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,235,1719903600"; 
   d="scan'208";a="68853420"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Sep 2024 08:14:22 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 17 Sep 2024 08:14:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 17 Sep 2024 08:14:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 17 Sep 2024 08:14:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E7op7hcdZlqqoq6JtN8e1pKsepVUz8E359wPIXmBJoxXuYJnNJC4YFpQrooeAYBkQeGmd4V3Vx3ayy4urf2yDpbNc/joqL1dn4bSxAjwg7bF4B/65CNTm86KO0wRp4X7+U4xTfG1DMNxM3R1SyM9jfeCKUXzg0rP9Oua9eV0EZCTZ4WyLKW1wpkLK8S0JYr1RJKO1KV18+AndrFZfvXHCT+IOaMm+zzixRyUiR9Jt5/Kiii/e/GJBFq9CgTCcmMn1m4+qO+VsG8X+kk5S8lbc521p9HGOb6YBofRW8VaEqJv2RpZ84LE6aLExWN4Qt1RtPcSJHpZaE4vp8GWt6b2Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYj1RmQ9jgOg0wwUhZi8cHgqM9Mp3iXe+YKLfKM/yA0=;
 b=c2MNTs4Dp3LVChBqArQ7A4yvUJS9ZRphhNhKHUEDXWW+aGOzAx+/Q4up3fg/gQOoSeOUJitusLGNWhFJVFW5deMMewsxrzFCjqFjO0Jds8fwrefc4he/NCq3YVyy2SUrtdeL1z8nCD5T4wdKUwOY6s8KCDkrZrT4gzkOQEeg4nlPJw3vcp67b9lhJ/xb7FdeI5PyptzobYyW7VlJ0c8FScQBqMckpDciKJ9bBaXwONa85Nr6s/nZxuuYHZz0GW5GRjBFlepK3og/2uRhmuYqZLqb6Hf7iQ2Oqmgv+qQ2MuoMB7gmdw+Nx1QHkykftb8fB02a3YdDQ59pq8HALcpW5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6344.namprd11.prod.outlook.com (2603:10b6:930:3b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Tue, 17 Sep
 2024 15:14:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7982.012; Tue, 17 Sep 2024
 15:14:18 +0000
Message-ID: <c4175ca2-6551-4255-ab5c-0840f2b43008@intel.com>
Date: Tue, 17 Sep 2024 08:14:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/resctrl: Annotate get_mem_config functions as
 __init
To: Nathan Chancellor <nathan@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, <x86@kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
	<patches@lists.linux.dev>
References: <20240913-x86-restctrl-get_mem_config_intel-init-v2-1-bf4b645f0246@kernel.org>
 <8e34346b-9703-48e5-8923-15800fa78899@intel.com>
 <20240917133520.GA2360164@thelio-3990X>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240917133520.GA2360164@thelio-3990X>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0361.namprd04.prod.outlook.com
 (2603:10b6:303:81::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: e73c098c-4ccd-4f78-ca84-08dcd72b66bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dzVFWDkzQXhJaW5CZW1GcmxUZlpyaHRzczNxQ3h4a0FHMnNhQ1pPUjBsNFlX?=
 =?utf-8?B?UWhhOUFxVEQzcFhCYnV6dHJueWx6OUV2cG42TVphLzdRRGZkVUNYbE9vMmNZ?=
 =?utf-8?B?WTd1YmlBcG5wZXZlTE9lWWEvcGIxTk11WXJOR3pPQklrMGs4N1ZjQVdUVWhx?=
 =?utf-8?B?QTh6dnN0STNnbzd3dmQyaUJZZ2lhVmdBQTJUaXMvUHBDeTZJc3IxOTV6blFB?=
 =?utf-8?B?ZFV4MWcxMlBMM3Vnd1lyZmxyY01rNU1sRU5hOUVjM3dmaEhSTjNtRXJ1eSts?=
 =?utf-8?B?VU0xcVI3Mk1NWEdNd3JHTFBwWXFlL1pmMTYyNjBPRDU1ZzZ2UWFpSTRYZXVn?=
 =?utf-8?B?ZjN1VXhQM0hhOUFtM3RzMGI2WHVZM0hjUzRVTUFodEcxN2VTZy9nSTh0c1Rr?=
 =?utf-8?B?Y0ZVNy95RjlvV1JncVZUYmJuMzFQcWRUL0p1MW52cGZmNWJpSkhONWt2amRp?=
 =?utf-8?B?OGFZaWRxV0JNMjJiMnVHeFdXeFBmdEZVaGpBVGJIY3J4Tk10dzA2QmdBa3Br?=
 =?utf-8?B?dm5XTVNWM2pLZEJxRTFvZVFtUmtZU2crWkRwbFp3YUJXZW5tMmdPTVVycS81?=
 =?utf-8?B?eFJxeFltaUpJVFZpZTNhUC8wVGdXdDhkUUdRWHptcThydDlHandLVGxndWdK?=
 =?utf-8?B?U2JmWGRqZzlOU0F6eFdmU0FRdVNCZzJWNnhMcDVrY0tFd3lRQTQ4bWpzSG5L?=
 =?utf-8?B?cVBINXpkQlhkcEIrTThRSFArN0xGYkhydFhsYjVZaFhDRStXY011Zyt2RDJm?=
 =?utf-8?B?Szl6VG9UUTUzUFB1VDgrMjlzMEt3bEE5V2RiRmgzRis4cG9ZU0d0djc4TmxH?=
 =?utf-8?B?RUh0aVlLejNYU3gxbmtxS0Nrdk9odzVYdHp2WU1iTjc2MzV2WkNFditHQkZl?=
 =?utf-8?B?VGwybjk0K3Q4dGFUMEhhMXRoekc4T0p3QUxIYWZMa1VOb0d3akFKVVI0WGFH?=
 =?utf-8?B?dkpOMUMrYVp5dGtWZXRRcXIvdU0yV3c5RnpQallUQUFBdU5CT0tBd3V3cHhI?=
 =?utf-8?B?dzJ2dmEvUXNlUFdSSnh6S0xKMWJEM3JKQXFvS1hyUHJ2WEx3SHJDbFB6Zmlz?=
 =?utf-8?B?T2tlWjQyWWNYa0RzZEl1dnMrVzd4dU9CcGxXUTZHeEIzeERGWEpXd2NZMWdK?=
 =?utf-8?B?d1dYekErbEcvdVQzWmR2Q2w1S2pvV3NhQm04QWJwOEQ3NDh0VWFiRURhVkVO?=
 =?utf-8?B?WCtRY3JHQ0hWVzZtd1hUUzBDYXlCbVZ6ZFdyNGZoRGhJN0UzNkpWVVE1TE5j?=
 =?utf-8?B?Yi9kS2lsWWR5NC96N1k1MXJoSW1DNE1nTnJtUXMyV1J5dFZVdHZ0LzJnTWFh?=
 =?utf-8?B?MUloVUoweHdoN1QxWW9IM0d0SytOT2hwRElDdFdvZlBTQTY2NmJzbTl5eTZu?=
 =?utf-8?B?eHo4bm0xVHd2aXJGTVVia2xoaEMxVzNqSVF3dVA5SWlhVlE1SldqOUxmbFlj?=
 =?utf-8?B?Wk1lRUJvRVVWYml4WG9QaElkaWhDazJDcFJXUEFYNVJwNzhEaExFNzdJQng4?=
 =?utf-8?B?bThpQVpNeE5oRjAyNHRpbmtuUXpKYlFVQ3pHRWdqTVBwby9hTi9oNEVwcDRY?=
 =?utf-8?B?K1F0dDUwdE1oNHBMVitiTkF2eFYxR1dZSEhCbk95am9qdnhrcHl6azQ0WGNv?=
 =?utf-8?B?eGhsM0lLOGU0S0ZycVZEVHlsOVcvN1ArMTd4b3VBTUJvSjY2ZFJqekhxSzZI?=
 =?utf-8?B?ZXFZZmZFbmppaFIxVGtqTjk5eC82K3lRT2pINlFYSVVMRnpPR2hYaXUvUWxK?=
 =?utf-8?B?SzI5bUlvMDhmdnF1RFFyUWp3a1hCZk1SUTcyTzRWM3BacUJ0Skh0U0xTcHhJ?=
 =?utf-8?B?a0VDcU9tUWRsakV4b0w2Zz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmdvcTZzNUhOc3RqaVFKVGlNS0xVSnMyRk5LQmNJZ3N1enRmYVprZ2NMU2hH?=
 =?utf-8?B?NFdmdm43cHAyc3NabEpwWHJwY3EzM0dhN3J4R0hUeXhjdG8yRG0xcUN1NTFv?=
 =?utf-8?B?WEo3QXI0anllRHBZWFg4YXVVYlVLeWNLNmwzQmRZUGRJdyt1OTZHbGNQeWRp?=
 =?utf-8?B?bDZNYXozNTRBYXFzVHkyVEVjaURZeWE5dVlVQjhsdjYzdWNaMGRHSGZvMzdF?=
 =?utf-8?B?bW1GaUVISGpHbE1ZRDdDWFRpVVcydGRyOEZrTWhsdFcvcHdad3hDODZFaWlj?=
 =?utf-8?B?NTNyVFgvb0RRWWJNamd0elhwajZjcFFqbVp1TlFPNWR6TW83ZDM3eDVXbXBq?=
 =?utf-8?B?WDVYdnpjeWtSSmcwS2dIR0lEU01ULzF3ajNERFZPNTdZeml6RldhOWQwTUZS?=
 =?utf-8?B?MDZ2eXN3dTlDekVtWENycm85cnNMTU9rUkRSRi82N01DNEdEUWVtRlZZSVV1?=
 =?utf-8?B?SGRQWnNoYmRkajJmVmYwV3pUbmpoVWdXd1VtVUU5SFhhMXlnaXRNRDArMk5a?=
 =?utf-8?B?OUVjZVpzcWFLQ0ZJYUozTklobFkwdFRrMy9xNGlQQXlxWWVlcFdpUW9IVUM2?=
 =?utf-8?B?UG5QZVFNaWs5ZkwzVjFHMU5ZNEZEQ1dmUjgyVHhQaE4yUmlvSGk5YUFjUlUr?=
 =?utf-8?B?cmxrdEtEdXVtTHkwWVFlSFFsSTBsOGFtaUFHKzN5c3VwRmRVc3Q4OEE4Q0pS?=
 =?utf-8?B?Z2oweVRuUWtyOU5sVXFEKzliUGlxdW5NZzdiOWJ3NkVhQW85R0VOSVJ4QlZX?=
 =?utf-8?B?bnd3R2ZZKzVKcTBWc3F4ZWgxTEgvS1JuNndxWVduL1VlNE9HMDNFVUxRd1RM?=
 =?utf-8?B?eGNxcTl0eWdoUlI3dEd0Y2ZMby9wNEMwV2gyQ0dPVDBBQnVrNVBzamF0M1RM?=
 =?utf-8?B?dUhOdjh5MzdmMkN4RWVEY1pubGRqK3hmbFI4cUVLeStnQWRVNGFQdkJKSjZB?=
 =?utf-8?B?a2dLczJOdG9zbS9ET3oxZStWRzZ4eEM4VldHVzJuZkhDNXduMU1TdldIUENw?=
 =?utf-8?B?MWVaenFiMk56WU1jN1JzUit4Y2Z4a3FZN2owMlZSTitlVkhmNjcydjF6V3Zr?=
 =?utf-8?B?ZmM5ZjRObnJXTzZQVk9DdzdWY01XRlJNdVVia2dGTXhuVzZyc2FxWEZaYzBa?=
 =?utf-8?B?S21BQVBHekk1aFA2VlpJWk4rcGh1Rld2aTU5M2VCR0J4OXUrV0NhTnpzMThP?=
 =?utf-8?B?eVJUbEJiZCtuV05EY3JYUDR6Y2NSY3dmWGJSb3VOdlFlcEZYSUNyQXl6dXhn?=
 =?utf-8?B?U0tDLzBZdTNqZU1qcUR5RWFEWjh3eWtDYU1BMllDcEIzbkc4TDZ0ZjIreWNw?=
 =?utf-8?B?SnV1RDNxZm8rVXd5ZFMyYmRUQXFpYVBmRUg5dTlTYW5OZm8xZ1VqNWFwK1ZK?=
 =?utf-8?B?cUNqQm0zNWFBTWtKakZ3anJVMHMrZUdUNDQxSEQyY3ByR3ZOdDZ6MThwSE1Z?=
 =?utf-8?B?YjlZQlRWMWVPWWlYSFB0SHBJZmFOQzJ3TGZLQ25sZ250b1BUMmExUTVyTHNW?=
 =?utf-8?B?MVZyYWd5Zlp0dGZZV1d1ZlJ3cEdYU3FEd2hqSEl6K05ZaXBIUmdXQmVLVDN2?=
 =?utf-8?B?a29mQ3pJcDVOK0xpaHFlbWl6akNCUGowT3FrQTF3S0ZHdkhwanBrMHVGcjc1?=
 =?utf-8?B?Zmt6QkNTVWxYanJEQ3VCY3htSXBJNE5Va2ZQQUtUdkJOZ3k5N29YMG5sRjZi?=
 =?utf-8?B?aUp4b0Y2L1k5ZXQwOGZLNjJVNkJaWGQ4MzdYSkVEMEpKMUYwd09zNGFDRm1l?=
 =?utf-8?B?dGxNanZTWDJEMjMzZ21CUVJYT2kyNmtYUVgxc0FKUFBkVkNKbmdLWmJrcmtt?=
 =?utf-8?B?MmdGRGJCOWgrY1MzZVNNUWlwODFWRjk0K0tPTmRHU3J5Tk5ZNnBXZ3N1YjRO?=
 =?utf-8?B?ZFl2Y2lxM3ZoeTR2Q1U5L043cVp5ZFZWaXZIcHVFdTdEZCs1Qjh5WnZNN3kw?=
 =?utf-8?B?dGNSN0kyYmJET2tleTZ1aEtKTldoTmV4UHUvWHVOMFJ5bjA1ck9UcFJUNmZx?=
 =?utf-8?B?MytQby9JOXlYYnlmc2ZYdWg2d3FwM2dmd0ZjNy84NXllYStBcUZFWEduYVJL?=
 =?utf-8?B?T1drWjlaMXVtVTAwemVuaVorRlc2cExLNjY4T09BRElQdW8zRVpCRnhBWW1O?=
 =?utf-8?B?T3RJZytVSFQ5UTdxZ3YvVHcyZUpSbW50RmdYZExZTm9LeW5Od3hrOUFJaDJD?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e73c098c-4ccd-4f78-ca84-08dcd72b66bc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 15:14:18.8341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJhiDnx5KSXUOi0JwYwjTGoocdSx+eLAhCvHv7phycaZUfCDjrIlR5SQ/i8dL5W5iDCLnoKUwWV49wc2Xspzvc8+aGZtLV6Z3ZDGkRmlImQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6344
X-OriginatorOrg: intel.com

Hi Nathan,

On 9/17/24 6:35 AM, Nathan Chancellor wrote:
> Hi Reinette,
> 
> On Mon, Sep 16, 2024 at 02:42:09PM -0700, Reinette Chatre wrote:
>> Just one nit in the subject ... this area has the custom to use "()" to
>> highlight that the name refers to a function, so rather:
>>
>> 	x86/resctrl: Annotate get_mem_config() functions as __init
> 
> Thanks, I am aware of this custom since I do it in the commit message
> but since get_mem_config() is a function in this file and it is not
> exactly touched by this change, it did not really feel appropriate to
> add the parentheses there.

hmmm ... I understand that () is used to highlight that the text is
referring to a function independent from how the function is impacted
by the change.

> 
> I can send a v3 with this fixed if so desired or perhaps whoever is
> going to apply this can just do it then?

Could you please send v3? That will make its inclusion smoother (pending
any other feedback from next level maintainers).

Thank you very much.

Reinette

