Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195D87BAF7
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716413130; cv=fail; b=tRK4TXTF/Sw0ka5njrVRW/TgA7uctxJnumr+TlqG5AgjcR0ah+2dKsqkurt9fu2ci4aAVyvU2DO98L+zODDLnM54zSz11JGFVkSbEPrG0HprRcz2mrbzXl1rWd/Hy6Ob6E3VrkHFnRla+tyYHWtQDKfIl/xTs6wwWPmZBZD0u7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716413130; c=relaxed/simple;
	bh=vWlNbIbbxZv46oT+qzGvVRlcPZ+uVzEufpk9CZffX9Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fsofUnXSzAsyDjdDbqZhmi6MdaPsoapvb3LSTgNX0attKrxA3BSa0Gby7U6KcsmnwDsWDpVIsAUu1ATI2SN+45Sh6YRxHfWU+AZud9freZoMWbWkavuPRcmvlDer5Qd/nACHe0rPlLGq2qSDDiGHFOhl/CRHnUajrAaXmVLsNbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MPqvS3ZR; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MPqvS3ZR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716413129; x=1747949129;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vWlNbIbbxZv46oT+qzGvVRlcPZ+uVzEufpk9CZffX9Q=;
  b=MPqvS3ZRcnlMocejLj9mTY+nmmsvzcN4WIK3zXxKup70L9Q5TF9Jvrs/
   QcI4zgB/UvvA9pN5IiOrTv0q6LQZH62tegj+j1qvSc3bb5g1mbDGYSN5k
   JMoY4mybEkc4t98E4zVfZUWUU2+K8EAgUYqiMaXsP5pKos06+xKhgjSID
   SLcIGBpcm5QoN1E1HtCQl7X2EYkTbS7/m4bXL+Ea4bmPK+wNUBGpbwhDM
   yEmS38CeVIsPtPMzyisp+1ZIt95slMcMUytKlINz31n19zCcYOxvsfSz0
   /xbY8qhswu0o0SkMjPh/HCV0g00dmoj+my3RFSuHT0ceNkguj8KkxOv2w
   Q==;
X-CSE-ConnectionGUID: NF74vZs9T9qsBvLX7qwVNA==
X-CSE-MsgGUID: 6pCj3PMHRYWMpioOSwOWRg==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="30226496"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="30226496"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:25:29 -0700
X-CSE-ConnectionGUID: BPMefT7KT3K+sffEmVgPaQ==
X-CSE-MsgGUID: AqgQUys3R4mksuGmArRVww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33401596"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:25:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:25:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:25:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:25:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:25:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biwl2cLPdBZzoUTvhfjqVQrh0/lsurIjXFAZVY8Oq7zPPTW+LzxZhnereyyGsUeFyjM1JSqCZ0aANTEIHTa8yhFKbzD8/WEriHa7NCwufbuKY333rdSjpJX1KrCb9z235Mzlx1dh8oxhQeIovs6Ex7GKfO49/RDUU99FChX6eqmvKMZxmTA0WTs6qRYs5WgXWN1sF1dsvS/3LqXoAkpMksuvMvaabY0umFq0Aj6eWSapGdnSWldnPYBsyj5CAJnYEQfT2ZRftg66gABzisgHkT/0KMCVh+KlLC68illUfDI8aK9LDwY1HmOiPoFDnXUVEIzzksdv7EEkM3QvuBwoew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SR5DpvilhV7gBGKwOYdzsk42HHfh3p4zv48GWrykbzg=;
 b=FxdWFxupfUkWTMgYBhIcfHF9980XJYE1XasAqnLlJ03fWaKOxE7roDfTreTbeL00OdT56k6LnS5WXvdGLtvZbYU86KK+rJkjmANojjo0SHKy1fY0eHx+5E+eDustkA8/Py/0JLFIAg7t68vrd+4MHUATOe0ItMCxdhRt8I5/Z74D5pgV8iZEbxMPq1o8J3uDYfJSmVGg+9dxPIsMgeN/GMiPkYdmycOA4Mrbauddss9TEaAQvg/fDKBcp4J/HeZsWs2/xZtivn823Qz62kkv7eiUrqFKagJW4Mvxu1yR03bsKoHYZfWO255MvQlJvEeN2KJtUKz1fURhRcmaOQBYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB7056.namprd11.prod.outlook.com (2603:10b6:303:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 21:25:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:25:25 +0000
Message-ID: <61e89a48-d1f4-49f2-8893-950e7e6ba7fe@intel.com>
Date: Wed, 22 May 2024 14:25:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 15/17] x86/resctrl: Fix RMID reading sanity check for
 Sub-NUMA (SNC) mode
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-16-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:303:6b::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB7056:EE_
X-MS-Office365-Filtering-Correlation-Id: 80bf74d3-8fe3-4e4d-fa4f-08dc7aa5b200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d1dGclcvaEVZU2VPWlpORVE0VnZCekNQTHRqTDVzelJJc2ZBZGJvcmZoZmRj?=
 =?utf-8?B?eFZTUE44MCs1MDFzUk8zTGpqdUY1M2hPTVhPdTFBZWkrZ2NrQithbmdWUmtk?=
 =?utf-8?B?Y2xYaGNKWWdMeTNoNlIyVUMvRzZMYzlUK1N2NzVZNXBQMUZXNVZSU2d6aUdV?=
 =?utf-8?B?MDhZZGFUZW5LcWd6c1NMK0QrWTQ5MGVBYTl1UXpXZXdOMUIzVWIzOE82bVVt?=
 =?utf-8?B?VXpsaExYNzQwUWU0WUM0Q3hrM3RLZVpEcS9uZWlMUVc5RDhtaENOUkl0aHdy?=
 =?utf-8?B?NFF3d0ZVZ2RwK1p2aDVYZkoyNjZSbmJaYmNNc25MY3JQSks1QmFwSEcwQ0M2?=
 =?utf-8?B?T1JmaTRRa29XUnRKRk5vTkxZZHI0U2lSV3B1eGl3dFBRVDRMOGErUFNGWFVG?=
 =?utf-8?B?cUtacXVIc3B4bUNWcUNPdTNDTCtLYkJ3MnRIaVdYUUhHLy8za01qMGc2UVFI?=
 =?utf-8?B?ZUljV3hsUThpMlp1eGt1T2liRjZJZzFCcG81Qms2dytUTFE4Tmd2YjA0VEdH?=
 =?utf-8?B?UUQ4eUdkaUJUd1k2TDI2MG9qOThwN2ExUVRMWnZzT3lYYmtMUzY0QjZabjgr?=
 =?utf-8?B?Q09VVGZ5MFVLV0hPMk9oUUpKNFF2ZWtDeEJIbUx4TEZjVVVMVkQ1WUp1Mjhl?=
 =?utf-8?B?WlZJWVZtN3N0eGFMY3pYemNJWitxOEZCeUUwWmxIalViaHkyTVd3ZWkrb2N5?=
 =?utf-8?B?RU54VHZlL0JHbmZTQVZaN0xDZmo1a00rTGlML3I3Vkc4YWlUUTlHdWQ4OGVH?=
 =?utf-8?B?UjJ6YmtscHdOZkpwRnV2ckZPSlNvRkl5dTIrV2cxY2F1RWtSODRTQlU1RjR0?=
 =?utf-8?B?MkY0VUNTRUJORzVNdExnaXZUdjhJNDJjYlhBMmE2aVZxbGxCelF3Q2VnK1ph?=
 =?utf-8?B?SUxMZXViVDd6RTNhQ3FKQmJNQUxkQTU5M2dIWEQ3UWpTbnpSa2ZoTE9Ga2pz?=
 =?utf-8?B?RFRxR2FhajJhQkplbDJSc1c1T0dJR3plR21EOVZzZnZDWjNQbXlzeCtMU0Q5?=
 =?utf-8?B?bS9UNmhMTjVUd0g5ajkwak9IK000TEg2VUwrQ3AxNEFOSEFwRERhQUxySEpV?=
 =?utf-8?B?b2pyMitrelFkUGZTdW1FMTdPcGUycWt5NHlGWmQ3S2x1QmFCVDJjRmVBT2VS?=
 =?utf-8?B?UllET013Q1NlLzJTTWx0NHdiUzBOUk42SXBuL3NyMlE3ZGp0UWVnZEZtaWY1?=
 =?utf-8?B?STRsUE1xRVkvOE1pV2puMVp2dGVhejZFUkdZQ2t0VE1BRkIxdk5VTWhaa0Vp?=
 =?utf-8?B?MVgxRjQwS3E5czA1Q1JUTWJqQU14QlJIcDlUTmxtTkNxTVFDZE5jZVphdFJ0?=
 =?utf-8?B?b1Z2dCtzR3VhUmpjU2wwMkxVYlZBOEtuWlc3SldOQVczQml0emlXS08zb0kz?=
 =?utf-8?B?V1MybC9sWUdDNllNemRrd3BVWjVBVTdEKzRJcGF3eG5TejFCTFJjeTZ4bEll?=
 =?utf-8?B?SFY4SGVnd1ZhWXMzRHVrOHNGVXVLaS9yYjJvZGVtQko0WVJXSFJYVFZLNzd5?=
 =?utf-8?B?VDlTaXNNSUJld1ozZVNjUWx4ZjQ2R1JuSGMyejlCSmNhQVA2WitndGpySktQ?=
 =?utf-8?B?U05Ja1FzK0VUajFoaVByOGRUaE8vcExyeGQ4NGhNRDdaaDlXNkNZWFVQQi95?=
 =?utf-8?B?MU84QkF1OXpxQW1XdC9FcTREdDBRSU5vUEVHQTBBdmYrMUJmQ1ZLdkliOWhr?=
 =?utf-8?B?a3lUQlltSytYMllnYTNmNWpEMnUrRndRdjZLYUhxNVlpMHkzS0FRQWJRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a21TVHZ6QmYyTklXQmpERGlpYXAvOVZjcVNLUnJHVlF6d0JZeUMzWHFjaTUv?=
 =?utf-8?B?YkJ5cjFRWmxXOHd3S2FudnllQVIzMlNUN3hLdnkrZXd4WUJTeG9WdmgzTTBS?=
 =?utf-8?B?VkZnOWd2YnVIWFNKc2tzL215M0JlUytiaDhMYlpxTk9ZYzdSbTY0bEYweXFM?=
 =?utf-8?B?dGkvcW0ycFJQb0lJQVlZNFFwNUJTdXBDOHNjT3BKYlJ1OTJtK29FTG5rczJV?=
 =?utf-8?B?REltNFJZMml4NXdYczBkRU1nMTNHMmdPTjdDNERpZEhRSmRlbXpMdm5zbTFG?=
 =?utf-8?B?aUpiL29jRUpQaEFVTGtOaG0xNWxTUEZUdnhnZzJCN0dGUCtwYzhLTE1KM1Y0?=
 =?utf-8?B?MWFhc0V5SFFhYUFQZnl5K3J3YW1lZjlzNG85ek93ZjdPc1NHeHZHa0RnUlVV?=
 =?utf-8?B?eS9LVDFNdS80dndjWXFmVnJBd3c3RnZSdFJnMkhnYTlRRVE5SEFBTkFUMWhE?=
 =?utf-8?B?RzY0WFE3dXZwQ2ZrbmFlbHUxb1h5bVF6cDA0byt6SEJwTXNVMVdpZE9WcEFr?=
 =?utf-8?B?dk9kdUZBdG1NdXVaZFBQY0hVbUl2T0d1cEZBWjQ2UGNpd0NxN2JIK2IwQVhN?=
 =?utf-8?B?aWFlMlVsMXltN3B1VWw4WURHSGhNUWM2R0kwK0pHdWJGM2RyVkZuSy90ZE9E?=
 =?utf-8?B?T3Zoc2svOC9ZTEhWY3NXamUzZjFzdGNtQ015ZXJYVHFCWmVJUjlGeWFjTWdY?=
 =?utf-8?B?NHZVUXFWUkNwUFJQRDVSWENTS0R5RUZPSmpZVUlPS0xHK0w0MC95MXEzdG0v?=
 =?utf-8?B?OCt3c3J6S2drc2xjNHVTemFiQWMxK3ZHWExEZU4vdFYrTCtoN0hlYVB3UTVi?=
 =?utf-8?B?eWVLYjZ6b1VVbDIxc2w4R1YxUUYyTlVLTm9VMm5HWVZXWG9adWhMMHFoZEh1?=
 =?utf-8?B?QW42c3ZrMXdrZkNCSDNBRzlxWnlzeWdJdmtoZ0tsMGdvMGVIUFh2VHM5TXVL?=
 =?utf-8?B?RjVwMVpQY3pOdzQ4ai8xdWVVUjJ6aWZldEl6NHZwenU0Y3dhNVlBcHRUelZS?=
 =?utf-8?B?N3hkaUs1b3JiQ1o5U3BveGtJSDhiMFpydXVrV0RRMVc4aHFncUdTTEIyVmVk?=
 =?utf-8?B?eEJNTkJ3aWxJRmpnSWs5Z2N2ZWRsTi9LWlVES0JDbkY0K0dVazF0dEgrbWJQ?=
 =?utf-8?B?WnUyZzZmeThLdzVGN1ZQTHJTVUVtdWVXcmhrYzI3MU1kZHIva1ZUdE1QdE5s?=
 =?utf-8?B?RXF5UFlmc05qQWtmTjZGWHJ1K2IwOFRDOXU0VWNORWo2V01xZkpyVnNhSDVJ?=
 =?utf-8?B?M1Rrc3dZM1U0SzNzUW12VWR3WklmZm9GQTJpaCtsYjErQ2JOS1Rnc3FhMzV3?=
 =?utf-8?B?MUhXUCs0UE1HWHJtVTZGUEY4TDg0NnVDZVl4SjdRa2toUkx4eFZ2bmNpalRF?=
 =?utf-8?B?QTJ4eWw3UXNjZGhDS25QOWpCSFh6cW5RVmZqK3dRV0dNaFNRRFZsdG5hdTV5?=
 =?utf-8?B?bVlDenorUEdjSlo2eTRTK0NiaVlpc2l2Wi96NkNsOHdjdUpXZEd4V0xHMGdx?=
 =?utf-8?B?RTA5ajRIUzEzYlRSU2dqdHg0K0IvcGN3QW9SeTZpRmlCMGFiVGVkNGtyWFc4?=
 =?utf-8?B?T3JPRDJHa3VzRXpYcnBxQm9PbFBTNy9rbTlVYXBVUFRlbTREaEF0dnpmTmZq?=
 =?utf-8?B?OWhzNVI0QjJPRi9MbjR2bG9Ob0xCU2FoMkRhQkVwSUN2K2lEU1hSa05iYTRH?=
 =?utf-8?B?QVQxN3ppSUhLaXF6VVY5cU9HQldsek55YWw4dVh5YnRLZVNPc3liVXBDcm5Y?=
 =?utf-8?B?UGkvQ3Y3UEZRSnRUZWFNaFpjSEFwR05LQjVaVkxCV0hIZFgzUlA0d21rOEQ2?=
 =?utf-8?B?MkdseEZPbHZINlhJVlNkRVQzTjBPZmt0Rjl0bklBNHFQMi9pdmptS3ZjN2VE?=
 =?utf-8?B?Ym5qVm9BaDQ2cHlyaHJOakFONEM1YXZKZlgzMU1pNUxvN3hNdUpNL1N4a2ln?=
 =?utf-8?B?MHN6clBnNE1BaUUzb2I3bEdjTCtyUUdtMmpBYmZUZ0krV2RwSHNnUlFpaWQv?=
 =?utf-8?B?WTBZelVZRENpNTVMM3FxbmhXaEM5L2ROTS9rT1NORVFsbHlTcWwwT1VkNEpU?=
 =?utf-8?B?eXdtZ0VqVjY1VnB5ZDN0OWd3TS8zd1B0amlySHYrbjJzb2lseEM1ZGlNTlFL?=
 =?utf-8?B?S0NMbWpoejd4aXpHeUEyMjUwRlpTZjdNM1EzN3BlWlJaZ2JFL3J4ZDhhaUNU?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80bf74d3-8fe3-4e4d-fa4f-08dc7aa5b200
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:25:25.5377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3h80vvWsAPiYOmVhucpHdojLQnQNDBWYALdztNwY/hjLYJoBa60ao/0G67E045MptFt/FMwp0y/IoZhuRHzcNM+R/VURcfP6PElpgeGcgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7056
X-OriginatorOrg: intel.com

Hi Tony,

A "Fix" in a shortlog of a kernel commit has quite a specific meaning
that I do not believe applies here. It fixes something introduced by this
patch series so "Fix" is surely suspect.

On 5/15/2024 3:23 PM, Tony Luck wrote:
> The sanity check that RMIDs are being read from a CPU listed in the
> the cpu_mask for the domain is incorrect when summing across multiple
> SNC domains. It is safe to read the RMID from any CPU that shares the
> same L3 cache instance.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/monitor.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 668d2fdf58cd..e4b92c7af71d 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -15,6 +15,7 @@
>   * Software Developer Manual June 2016, volume 3, section 17.17.
>   */
>  
> +#include <linux/cacheinfo.h>
>  #include <linux/cpu.h>
>  #include <linux/module.h>
>  #include <linux/sizes.h>
> @@ -281,8 +282,18 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>  
>  	resctrl_arch_rmid_read_context_check();
>  
> -	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> -		return -EINVAL;
> +	if (r->mon_scope == r->mon_display_scope) {
> +		if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> +			return -EINVAL;
> +	} else {
> +		/*
> +		 * SNC: OK to read events on any CPU sharing same L3
> +		 * cache instance.
> +		 */
> +		if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(),
> +							  r->mon_display_scope))

By hardcoding that mon_display_scope is a cache instead of using get_domain_id_from_scope()
it seems that all pretending about being generic has just been abandoned at this point.

> +			return -EINVAL;
> +	}
>  
>  	ret = __rmid_read(rmid, eventid, &msr_val);
>  	if (ret)

Reinette
