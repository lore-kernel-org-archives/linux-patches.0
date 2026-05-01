Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C697126FDBF
	for <patches@lists.linux.dev>; Fri,  1 May 2026 23:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777677454; cv=fail; b=kXz+SvQBEp67hGSSTEQTg+IVnjqKnHGVcrG3jwk3IQKWwcbsbAkHnYusESexXcVBPkZ49sYYeuLsdLWyQeidw4AhWImFCNU0UC3q1tNL+c9kxbmcMsvhIVn2zgNsNVxDZGYnllC2ACVvXSBCGZy1UpEFOYRMFvIabmJmPDMpFWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777677454; c=relaxed/simple;
	bh=X5732ZeLD/quFu+qB9+NbuvET6lqVO9iqOmHSzRbkcM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qhA4MdRMPIseI/qqUCjQcnJNPHSCW/qNx+I0l91Ruxm++vKISAtsLBrQjOtrgKieeMdwhMhYW/JXFysjkeFgId5+1l5/DnooaKLBMp2Kon16jjcqRlQh6WOQdahe0tJpmgma9FmmYrmukNTaQffV8W1Q1bZejAIwlZBEbTIM+Uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Er+Vqgxs; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Er+Vqgxs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777677452; x=1809213452;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X5732ZeLD/quFu+qB9+NbuvET6lqVO9iqOmHSzRbkcM=;
  b=Er+VqgxsbaCBEeBdyzfhUaDlL1DWLZDyZAInwpTGyYq3IVxKKCaHh/su
   lCi5iNlXT9irwcfo1CZfMWpU6MsbIaaIgoToRaBf+HH/oddQjo6Uk5eet
   piQ7iMwlAjdXYOj9q6fwsRX/EueIkcv+J+tKeI8tL3QYqSGMiTKyRs/TO
   u+8jWkP83yU7skXh2lD++TPjDExVAGl8VA4850ZgjyhzJLDSRt6HrQrT8
   fS8yttjWAALxwXwQQFoYO1wt4wByTJ6dB3C0w074s/NJXhr7x5RPEkmby
   DkHMzMSjo7fCXkSxabkCoJLx5jG6A3jr+d807BbFm+DzKMnZ6AtWeK0ZZ
   w==;
X-CSE-ConnectionGUID: AeFAN25ZS8Ghw2D8iAZ1QQ==
X-CSE-MsgGUID: j70ByBkZTbOrzvB8tJ5FDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="77659589"
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="77659589"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 16:17:31 -0700
X-CSE-ConnectionGUID: y2lqVPU/SruvkM0wg+eEGQ==
X-CSE-MsgGUID: KxQHvtWCRo+LeB7YqTP6xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="228493092"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 16:17:31 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 16:17:30 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 1 May 2026 16:17:30 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.23) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 16:17:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SkOlBG2LKcTfe3pkPMB501i3ARe27jSlTDOrif8pT1kMFrcgzaRTb/4J37T0kMQFl6GNyo2eAcZCUWKO8XKJekhJEK4UHb3qP59oDNri2GCZJrQV92tWCBzU3UqxKQYKeRfcJUPuZrxTGTd7yg0t5oTPUKkMxMqcHStMHhVdNa5Uzrog+38nMpPdlzChlU/WkupdS5kSnr8jHUHB8ODxqK47KejE+wkmnQhxSsx+BEImRLVO+9qoVoxGuXQFZ0aDloMdw8sn+FEHAXn0KSqEspuOoiVcoTIpp/bqYB2d5OHgDbhF0XUVU+R3zTXsGejbOuzGkZKih/FtKIBgi59prw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTXOPoSa2TDMS8NqJlHMhgrDKwDRUUS+kABin3mq+oQ=;
 b=de7Rcf+W//V2fw7FJRLd+T1JCRvYiFaTHlKq+WHh+6LBwLagO9Bgl/n7nRm/rHbmnoTDrqUQKdpCMtgjObJ2EnOYaVtlugMvl6ufPBuT39HNb2A6ACVTmYZux8UZmZxzRAWo/L6IqaZF3h+YqUvtcGhn43SXyNNQxzkuESv+pTXMbneSY5UtZdWv5qSLBVf9q2MzEheZnPpD+h1XTohD3F3+3XUCbMq74zAF1EaXe6XQxa4iR+5VoHpA2oNvdE8ylDZiZ8aGYqtbDJTj6E2Hq9MPhUH+3v7kKrfxcflPriOLEUUWcpOvtJQxddP0beylLjR/uWStbcyEikjcDHIk1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7665.namprd11.prod.outlook.com (2603:10b6:806:340::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Fri, 1 May
 2026 23:17:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 23:17:21 +0000
Message-ID: <1cdef1e9-e484-4929-be2a-793e42a49cca@intel.com>
Date: Fri, 1 May 2026 16:17:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix deadlock for errors during mount
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260501185612.14442-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260501185612.14442-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0274.namprd03.prod.outlook.com
 (2603:10b6:303:b5::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: ac1801cf-88bb-4ea6-849b-08dea7d7cbe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: vt4hDLA9wafll/jt2eFStDBAGDe6jwkO8BEdLC3d2fYDH0cxWZRMsuCTfpme5inXl3OT7sPENDKulrw92UQ4TV12Ji1j0wQ2GpXsdbxRU96MB34F7ADlQ2IeZ4HZUDcop7RDgyrUDMRTzSHU4QndScKcbWcqfvgvvrDX7c0qRVeepzVdLjbATOJDhn/kx3HXd3SCyf0YvjJNsaCu3QTS6HtLtyGRllAB983yau0wfEK6rT3jSqa6tt80cwby7/azf/4Z30L+Bb9CGhgmsQXK/DPRxw4KO5smIUYy626ljYCTNVF2QP00yvaB6mAIGvlC5X4NPEXkV5CcI4jrHvI5iZlGeYEw3xnUy1ylrXN+QVtdGvHvIr56FRzDXIi7okHYpmQsRgCCLcjaMUIHllYDbzVs6IAAx7gOxG+KBvLXcISv4TtYfbrRD8t1K6tZpoJUIu8efqYDw4GkWCV8okFz6MkjHYvG+yY+VPqQVzge9MJWVkRtMZDMuzjS5DBjgtk0Tq0eOyvVdiklyrZpkZN6QjUo8Aoj6GajElrosUaWNIS9T7juc7lnBKEPnVLkXVuGc+Ky85tWc8NrQVhvUOjAXrbG+Ntvq3P/HKqP/+5vThYH4hXrJ2cH2hOghu3CUWiVHIlHy8Mcn0CLEeWdvl1jCAnJoF7jYDMc9Xd1TEou3GwjWEAKmfX9kEdlRI4k5YD5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajFSNkZNSHRqWlVuaTFySEdWeXk4bSs2bWp1OGZ6d2JucEdtVWpIZUUxMjk0?=
 =?utf-8?B?eTNYaFdHY3hpVGR4WXFWS0NjOTBtUHVBZ0hwWXhDRVVVZDFqRm51eW5ncVh1?=
 =?utf-8?B?dThqOUMxQnB4dTlHN1BvWkJoYytJVlNrZW1ZcGhhcFlMN2xSKzZaNlEyWWJD?=
 =?utf-8?B?RXEyRktKbTV3RnlKUHZTMGNuVEFxdWN4dEhjWHYzR3Fuc0dVaFhxRzFjNFha?=
 =?utf-8?B?bEFBc3F4Qm4vL3V2b3VnS3luK2tWc3hJaWFnQlFtT3hFODZBMytsYXJDalg4?=
 =?utf-8?B?R2tkcnpRVy9SZGZyTjNVSU80NUJtMjlkUUpCdk5uRUx4bjhwMDB4TXBPNmtV?=
 =?utf-8?B?MDNtMUhCRTBXWjNIS3N6N1hLNkhXa1hjY2pTOGlZRVRPZUt2RmM0a1F3YjBG?=
 =?utf-8?B?Ly9jOTJXaGNxYnluOUJXQ1JGZmxTTVY2cTYxWDkydXFnSTFjWlpHekFPT3Qz?=
 =?utf-8?B?ZGVycE56cTVobS9FNHlhZ3h5MFZmeHhYV0VNNWxxMGpqcUNZNkdPc1d5YWNu?=
 =?utf-8?B?UnZFMjMyNDA3SlVna1hMcUVpa3BsUTBMU2IvRGxNVkNDRUFLTnlsTnhpbHpu?=
 =?utf-8?B?MUI2cG14aVZGVzhlLzNQWEdwV3dFQ2tGS2p0VHFBbmxFeVBvNit5NldGOHYz?=
 =?utf-8?B?SWpXZVdUYTVPRG5KTkpYbzFtNFZSWW93ekhoSldVSjgrVVdyRktSZGF2ZmIy?=
 =?utf-8?B?MEFYMVFHakJnTmpyODRNWnZGYk5PWWxPdFhiSE5UWGE0azZKWE0rSUpVNnVD?=
 =?utf-8?B?OVN5czI5OVE1YlpMNWphbDVDa2VQNHFIMmRCbHhvSDEvZWVZRjlPbTZETkZq?=
 =?utf-8?B?eVI2YVlCeWRLN29sNWdYK0dxTDRrRVZBbnlydlhHVURxSXJTajU1SkR0WTg3?=
 =?utf-8?B?eWp2Tm5KeUx6S2dENHpOTTd1SHNaTzZFV2NKM0hPQVpTeGFXa3NleFFNb0pu?=
 =?utf-8?B?WnBjVlZjNjcxTUloS1RHQnhnclN4OW82ZGUySXB1L1dYeHB2Ry9ISGczaTd0?=
 =?utf-8?B?RnJUZVlLUlhhTlZhYTNGaEg3c0JXRVk5NklSSmd3NUlUUWNJVk9aT2hrdEFM?=
 =?utf-8?B?TTU0K0xyNG1Ua1lyWndaZmp6aGc2RUJKUlBOUnNUMUhRdUVWaGdWcmdKZk5R?=
 =?utf-8?B?QWo5Y3VmbWRwSzZUazRTOEp1WDE5SzllOU8vQ0xpN3BYSVgzQnZUVCszaE9k?=
 =?utf-8?B?QUpuTDFuTFZXVzEzVmQ3dVZqWXlQUndrZ2FubWNNVUF3bjNTcnp3UHNQaFlj?=
 =?utf-8?B?Ykg5aU0vbFAxNG5CZ3ZndWZId1NQNWprR1ZQL0N0ZXc2ekh0Z2VJNUc4VXpN?=
 =?utf-8?B?N1V0Qk9NWTd5ZVRhbnF5VWI0TXB4dGxHQ3FUcGZhaTRkWTlLM3I1Tmh2c29I?=
 =?utf-8?B?K2JFTXQra05hQzB0aU9YSHhIaUNkbEJDTEx1S0FUTWxhVjlER2taa0lxczdK?=
 =?utf-8?B?SEZUUzNVWWdsTUlhT1N6eHhaS0VwY1V6cmVBbWR3a1g4cTVOZjJ5c2NPQWhL?=
 =?utf-8?B?WTlyWXN0bGVqZ24wNlljcStRWFVxTGEvZ2JaVkJOQlR5cGdkUldWYk1ObktE?=
 =?utf-8?B?Y1dLVlJQZGhiWkpSVjJUNElKQTB0NVc1dkEvbURPNmp5VDFWZlRoRFpVL0Fs?=
 =?utf-8?B?a09MTFRHQnVYSUUvNHBUWk9LdFhIT1dLbFpRbTZhenl1cnJ3RStwbDM3aXNk?=
 =?utf-8?B?S0JhVXhUU3AyNmptYkVGd2o0eFZXNm9BaTRvamJlUVZQdThFaCt4NWhzS3VN?=
 =?utf-8?B?RUxRdFRQeVdhMDNGV0ZxTStxM3IzM1Q3aE96WDJZcEpIdDRWQVFMb0lrOEtr?=
 =?utf-8?B?TTZhSEF5MTlxS29qRnlLeTdHV2x6OWpCbE4xQmVCWEVPSlhkc0l2R0N2L3Nu?=
 =?utf-8?B?bzBxNGNBSEFCTkVlR09Eb2NWcDVHRXVTS1pWVWJNRHlqUGhhZjFxL0I0M3Rv?=
 =?utf-8?B?RlBOUlUwRDNxOG83UFRTaUJxMFhwbWYvbzE5ZWIzZUxUU3hWRCswWmhZVThQ?=
 =?utf-8?B?NVFBKzEwSUhWS0ZGTElSbENyejE0VE01YWYzSmx3d0VkVmc5ZUtVS2hXK3Av?=
 =?utf-8?B?N0hNYklwNEdpbDF4bFY5MVlPOFVFVjJrczUrNGxJSENQYWZjdVdrTHNqQy90?=
 =?utf-8?B?enMrc3R4cTBxY09nVGJFTDNKd1ozS1dCRXVvOTFuZGJicU0vVHVFWUdiNTQ2?=
 =?utf-8?B?dEZ6RWRQNENHSk9yTzNzQnJ0dmJYcHNQNTlobTY0eTlOcWJlMVdUdjI4WXVT?=
 =?utf-8?B?ZEJlbmxoYThjLzZWdjZTdHVFVUF6eGxQUlM5d1RZaFpCV3ZPYmdkd0tYT21X?=
 =?utf-8?B?bWJBZ3NYcytEc1o5MUEyTnZFczZlbkZoQjJZWTg3K0J0SVRsTFlnaGZhT0pC?=
 =?utf-8?Q?ILz8eppaL/ay/BTg=3D?=
X-Exchange-RoutingPolicyChecked: CC3Uq5av0Y8qc07zCELn/ZNQg7sGV98n+/NiJbp3wV3XvzQtVIMLUfFDZhfYK72YXqJ+uNVICUdTSFQZBX6WQxnFLaYb5H/DTGu0/WvLKmYQxQawtL3nvbx5dlJIdyEBJvMnUWwKj1luQvl8BSZFQR4FKcxOTs01SMSHGmbQCYbIsiaSJyQiRwfmC3J7OPZOG3gfigePQC3J9l1eWE9V3KWt6i2sh2oszvt8qUVbc1JHbZ7Mcy3APW8D4p/S9BLIa6X1yWauaJdj04uykyAsuRKNgqFgko6jjClfi0m0nsykBpODDG44PiFyuSPresCdD2HGqPEHKehhG2u+zrtpKA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1801cf-88bb-4ea6-849b-08dea7d7cbe2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 23:17:21.6636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzkbtx4MJyYFLzQQkNkxGIss2l4cPtvnySQcCAOfNmbrXOofunp+t28qXKvbEYuu7zsr5Wk8fqmlh1aEkyasG1JTRA5xXS3VPHFL1a4y1AA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7665
X-OriginatorOrg: intel.com

Hi Tony,

On 5/1/26 11:56 AM, Tony Luck wrote:
> Sashiko noticed[1] a deadlock in the resctrl mount code.
> 
> rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
> superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
> the same thread before the call returns.  rdt_kill_sb() unconditionally
> attempts to acquire rdtgroup_mutex and deadlock occurs.

Thank you for addressing this.

> 
> Add a boolean rdt_kill_sb_locked flag. Set it for the duration of
> kernfs_get_tree() and check in rdt_kill_sb() to determine if locks
> are already held.
> 

...

> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5dfdaa6f9d8f..8544020ef420 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2782,6 +2782,9 @@ static void schemata_list_destroy(void)
>  	}
>  }
>  
> +/* Protected by the serialized mount path (rdtgroup_mutex + resctrl_mounted). */

I interpret above to mean that every access to rdt_kill_sb_locked can be expected to
be done with rdtgroup_mutex held ...

> +static bool rdt_kill_sb_locked;
> +
>  static int rdt_get_tree(struct fs_context *fc)
>  {
>  	struct rdt_fs_context *ctx = rdt_fc2context(fc);
> @@ -2855,7 +2858,9 @@ static int rdt_get_tree(struct fs_context *fc)
>  	if (ret)
>  		goto out_mondata;
>  
> +	rdt_kill_sb_locked = true;
>  	ret = kernfs_get_tree(fc);
> +	rdt_kill_sb_locked = false;
>  	if (ret < 0)
>  		goto out_psl;
>  
> @@ -3173,8 +3178,10 @@ static void rdt_kill_sb(struct super_block *sb)
>  {
>  	struct rdt_resource *r;
>  
> -	cpus_read_lock();
> -	mutex_lock(&rdtgroup_mutex);
> +	if (!rdt_kill_sb_locked) {
> +		cpus_read_lock();
> +		mutex_lock(&rdtgroup_mutex);

... but here clearly rdt_kill_sb_locked can be accessed without rdtgroup_mutex held.

It appears that while this change claims that rdt_kill_sb_locked is protected the
implementation instead seems to actually be "this works for the scenarios cared
about here" which I understand to be based on considerations of how the filesystem
code interacts with resctrl callbacks _today_.

> +	}
>  
>  	rdt_disable_ctx();
>  
> @@ -3189,8 +3196,10 @@ static void rdt_kill_sb(struct super_block *sb)
>  		resctrl_arch_disable_mon();
>  	resctrl_mounted = false;
>  	kernfs_kill_sb(sb);
> -	mutex_unlock(&rdtgroup_mutex);
> -	cpus_read_unlock();
> +	if (!rdt_kill_sb_locked) {
> +		mutex_unlock(&rdtgroup_mutex);
> +		cpus_read_unlock();
> +	}
>  }
>  
>  static struct file_system_type rdt_fs_type = {

Did you or your AI assistant consider running kernfs_get_tree() without rdtgroup_mutex
and CPU hotplug lock held? Consider, for example:

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 36d21652616e..9ee6295d6521 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2892,10 +2892,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	ret = kernfs_get_tree(fc);
-	if (ret < 0)
-		goto out_psl;
-
 	if (resctrl_arch_alloc_capable())
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
@@ -2911,10 +2907,10 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
-	goto out;
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+	return kernfs_get_tree(fc);
 
-out_psl:
-	rdt_pseudo_lock_release();
 out_mondata:
 	if (resctrl_arch_mon_capable())
 		kernfs_remove(kn_mondata);


This seems simpler by:
* avoiding introduction of additional state (rdt_kill_sb_locked) with unclear protection,
* avoiding double-cleanup on failure (rdt_kill_sb() called and then all rdt_get_tree()'s
  failure path),
* maintaining symmetry with rdt_kill_sb() by providing it the state it is
  expected to be called with (i.e resctrl_mounted = true).

From what I can tell it is safe to call kernfs_kill_sb() on failure of kernfs_get_tree(),
but this needs to have been be considered as part of this submission anyway.

Oh, maybe there is a new lock ordering issue with this that I am missing?

Reinette

