Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79294137C38
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717438039; cv=fail; b=oIl42NtiBq4Wp8rFIxlQHh/5obrHfjA0WdMHg9WKNekhz5Kwv2iQUr8VuGX0y9G11TF+Ur+jaCNsh8JYAQC7DFsX03oXifN5imxx9SB7Tk3uGnECQZFG3EU3sVw/TEwoWgMjUkZBXZ5lRHQ61dUv/Q17JrSvR0CGFqz+1lKbenI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717438039; c=relaxed/simple;
	bh=RPRO6rpjbQFLzfa8gjPWtMbjPCoBelxmdABjGzVNYa4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XvUQsW4MYki3EPL4eHJkSfUNhI38JGlpno555wAAgDa/MZJGfupZ5Igensqg5qTQFZLlGe144zGIARUWuEAr8rLOJhQZ+7X1odPIWtXKrmSOaoGs3kSjc1qqFLbZYEPDOOvkzqHch88M3k2110EPhpIWK8qP6QNKVoGP+Uup8AQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LwbBoMIC; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LwbBoMIC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717438038; x=1748974038;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RPRO6rpjbQFLzfa8gjPWtMbjPCoBelxmdABjGzVNYa4=;
  b=LwbBoMIC5Sj40VFhy4yjCvyqzNj96RUkRMJwXcHPRu0WWx+NUWFpBckQ
   i81OfbtxKZaH7zpzWWR+rXFMA08xEo6Tt3BTu7PVEB5qpqRyh4HT+r5ZC
   hmscLDAzKrxQB6PiF1qsKISRpvzL77ufg9pFjhpIW2jO2VcZYU2ez4lGF
   nTuI4p0zr59fgB/oazXShaB1wwlYD/29Q9RtImCI17beBChtv8KeykFzn
   YXbdRTSvpbzk1QPQXQhyNXVRs+tLHcp7hpRY82yP9x5DuiJpVl1r3f04D
   sx/gbJwEchPxLfeT8UcYwwsMUm8qpemEZ0wl0gmCV21jnS1Qx5aB0WjVx
   A==;
X-CSE-ConnectionGUID: 8x65CpjESXSJE8Q2PEhYiA==
X-CSE-MsgGUID: y2LOQ4wWQl+ID7So0pUVoA==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="13819991"
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="13819991"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 11:07:17 -0700
X-CSE-ConnectionGUID: 8rWc3SAaQOiYxjNG97SDNw==
X-CSE-MsgGUID: qzTGAgPcSKmyDZuePL63wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="37547827"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jun 2024 11:07:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 11:07:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 11:07:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 11:07:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlqAVCouO8QXazJMwZ5s6FDfuuPtqK1NeIuoaMYOj+35RsV6FiSuAKGOxlqDoAytkHNA4qB3yTZMlCw+c9qqhasco7b6cukpf4jFsgaDXxnkFlZoVU7J8nWmgZEtFdRzPiNmpCfVSvlz/+qbLsF82CxMzxTXevKR9Q7+a7VCWU9OfHw6cAzhPdDLPaOOZfFahAPpy1Wk1w0AX1blPRL+IvqCyUfCfCKPjqILjeX/zwIwcC/qpGRJAbBQPYx3oDdqODLWxKomAJpoubome4wsycmdxl+9K9Ihy3iSzclHCvsUHT/kiIxPjOAjkkoRjcmoqLr0RQyp/saa9DcOeEJuWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDjJFUdRpcEA+RO/Ahh4V+9MTy3bwo6YwXOU+wSvKow=;
 b=Sb8oZWbpiBd0PQ/p/eLUcBJbuodAYq7wLWjKDsi8qWZ4658P4L+c37HYpvEaPy1zcmq/UyqjyPUAMvo0XNNk/fb0S/yCQl4f/4IpUQO4VeBF1MbzcZ/WewSnwUhl3zSHs/EsSJdTT8CunWI+kZnbjfrPHBt3q+oJE/iYSQfmifILMIdtMCR8Q3iJ1ZRYGXm7OuQlY6lMjnmc4eXuCLSYlL6fd9ens7Vdy7G85pjQ1YRUgTHI/lQB0IER225laEQhSWP3KNGDIDqug0sn19Qht9uL0nYcHy39GCIpHzub+m47DDT1+z7uMJEiZZPuWGWuZjJ+n4AJgkKzUTn3+xeHcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7383.namprd11.prod.outlook.com (2603:10b6:8:133::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 18:07:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Mon, 3 Jun 2024
 18:07:13 +0000
Message-ID: <f4196f47-179e-454a-866c-1f4b6047ae31@intel.com>
Date: Mon, 3 Jun 2024 11:07:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] x86/resctrl: Replace open code cacheinfo search in
 pseudo_lock_region_init()
To: Tony Luck <tony.luck@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240531195720.232561-1-tony.luck@intel.com>
 <20240531195720.232561-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240531195720.232561-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0376.namprd04.prod.outlook.com
 (2603:10b6:303:81::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: a542f8ef-3518-450a-9fad-08dc83f7fe78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RFQ0ckE0akgrUEp0UEcvU1pqUEZPdHZCSVZHZi9nZnRFWjljVzNqMTFEQzB5?=
 =?utf-8?B?Q1M4OTB2Qm82S1lYWTJWK3RmSE15Vm5TME5OUlJPckluaFgvYlpBZXYxQ0NC?=
 =?utf-8?B?OUtoTzExK2tvMU1nZVFPeFZCYXlWZXl3SGN4QzdYSE9OQXlyRUVoT0wwWkZk?=
 =?utf-8?B?cGFLaXlOMGhKMUQwT0Nwc0pyaEFIMFdSZktudFNTUDJtTVNtWWJnN1Z3cHhn?=
 =?utf-8?B?a0VKOTBlVHNtTjE0Sm1CVzBxOHhNb0FzaVN5dzhxbFFEUnUyMnZoT3V1WERD?=
 =?utf-8?B?bHY0aDVQa01JeVgrdFV6Y1R4emNrTlMxU3pTem9iUUFicURUb0xRMFkzVVFq?=
 =?utf-8?B?QldGK0xuemVDYVJpVnNCMUMvQnF6bjJXSnRQOHFRenI1eEhJTDN6MXp0UHVF?=
 =?utf-8?B?N2toVkQ4b0xhcTJMaldvRldRdGViY09SMGFYbm5DS2dyUzFXYWtyRnJGam9W?=
 =?utf-8?B?REFhTzE3S1d0cDg0b3J4WUFhdWppQmcwZm1mNGdqdlVaUWZJWEZ2SFQvUDRF?=
 =?utf-8?B?L0JNVXBmVUFmaGx0L1dPNWpxZnNtbHNaSlhmRlh0emh1TTdjeElnaVNscUtD?=
 =?utf-8?B?bVZqTjcvRzhWa0Y1NlM3eDFTM0p2bGc2RDBqbkUyOGlXOWx5WGxmS1B4Zmxs?=
 =?utf-8?B?SlBPSFB4bnZVM3BxSXI5dmxlanF6U0JPMm84blBibko2VndaazVhTmo0bzRF?=
 =?utf-8?B?UXgzYW05akpLTGtJM0V2eVZ1RFNQRlA3RnAxQ29OUmhzbnZINUx5c3BZTWxH?=
 =?utf-8?B?cVlTRkhOcVB0cndyb2N0dWpPYlNzNC9LRnI2dVlzQWdKV1pqMS9tR0dYZSsy?=
 =?utf-8?B?bTVNUzRyTTdueHY5VVYybE5KT2o5M21LZGZkYUttZG9NMGFJVmhmRGY2dmQ5?=
 =?utf-8?B?N3ExaXdjbnNqbVppanJDVk1Cc280VzBadnZFM3Q4RGt2d0pCRkpWUEtoYzJv?=
 =?utf-8?B?OGpEWS90R3RBaVJ0SzRKbWNxY0loSmgvMjVlM2ZsYVpFVER2NndOdm9LSjIw?=
 =?utf-8?B?K1M2WVF1VFUwYlI0T2tNZ3A4TzNpSFlDWnlFOHoyTm5wTWM2TFZSd1NpUTFD?=
 =?utf-8?B?eFVNaVNQODUyY2EvU1RpZU5BTmNOa2dtMGNwNEJLd0lWR2xpQ1RqZGpMcllN?=
 =?utf-8?B?SC9WT2NIRGhYZU8xNE1tTU5HOERsSmZ5NHp1QnBCdlFwVE0wRndUbnN3Lzli?=
 =?utf-8?B?UXM1T0l2TnNXTVhKZndzT2RPc1BPTmpWZ1BadzZkaGxJc3ZST1JSNVh0RnJK?=
 =?utf-8?B?bjFSQWdIa0ZkeVREbEtBclQ2Wkl4cE0rSXBDYTZKTHl5citSWVEwaU5DOHdM?=
 =?utf-8?B?S0NnRnU1UU44ajZrZE5kL0Q2OTZSM1pKTDMya2tyQVd2QjhreUxaTzdJdnhC?=
 =?utf-8?B?NW8xRVdtbU9XUWdjNkZiYzFsWUU0SzVrRFZidVZYeEdlaGlXaXdpMlc4R1A5?=
 =?utf-8?B?TXIvYXJJR3lvU0N3cnk5eUVpakg2dXJMdzFzTkhVV0hjckpoNUhJN1h3R09x?=
 =?utf-8?B?aktuUmtuWVNMSGNmRGY5QzR4TWhUakNvOWtHY1NQV2RwOVJ5QzZMMm1JUXdk?=
 =?utf-8?B?RDZ4TG9ZbHQ4QktTQ0Y1VHZreG1lL3JNeENhNzRWUWpyeFlGM3llcUxsRkpu?=
 =?utf-8?B?RFNaeUFyajREdmtTaXBHTkd1Q0cxWjhJSXNtN1RhZ0JUY2ZFMVplaFpTOHNi?=
 =?utf-8?B?UlNGN29oZStHVlBqV1J6UnhWMmY3ZHVoTm1FVWJHTC9CQnFidFEyR2FRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFRJMFZpQnQzSFpIRWc0YndCUUt5RHh5VEt6SXpzWEw1Mkh2dmNqYW5qeXBw?=
 =?utf-8?B?all3VnZwMlovTWVlTk5iSmh2MktDcGM1YU4rcnIrd09JclJ6V3E3a2JRZys0?=
 =?utf-8?B?TGF6a1VjR2MvSkhEK3U1SDVvd1VZb211Z2pzeUFpckFRd09LVlNEWitjZWlL?=
 =?utf-8?B?OGt6SnZFODdDU1NLdFM1NlZ2S1Brcnd1T0lBZStIbDVYNVhhWmRVVnFLTWZu?=
 =?utf-8?B?VXdIeHgzZWV3V1IyakxUS2xOUzgvU25xN3BHWWtwSmpVOXp1Ylord214T1ZI?=
 =?utf-8?B?TFRLZmwrcGJRUzhncUVmN3J4TlJSREl3Q05BekdWVGs5L1VLUEVlODlDUDNu?=
 =?utf-8?B?Rnk0N0JnTi80ZUtxVnNIdnVlM01zb3ltdkh3ZmJ3dERDcFA5cHV6NnJXaTJ1?=
 =?utf-8?B?cVBLUlI2N3FJMjF4SVJQZ0VKeVJEOFJkYWZJRHdsZ28wbmtCWE5lTVM4TVFE?=
 =?utf-8?B?VFRRM3A2UjBzSzhDaWlZNytxZWFsQzVvOHJyVGRmS04ralFJN015STRULzRv?=
 =?utf-8?B?R0FRTHFBY3c3aHdmLzVLMkgzeWE0NmFxTE5JNmMxYS9nVVJWMDByek15ZnN6?=
 =?utf-8?B?ZkwvTTVQS2pWdzBhWHFrRWlKaEgwSEtMVWM4NTFYdGZsTkZYSTdCcEd5ZjF2?=
 =?utf-8?B?Qkd6WXkwbHlra3JMVVJVWGVwMUorWlUxcXVpNDNpbnNsZHlPY3hMNnJ1WllT?=
 =?utf-8?B?bUNRTXpFa3ZFekcweXRQaTJ2UFBEQnRYRGlkSVRwTTJ5NjloU2J0bjhkWTI1?=
 =?utf-8?B?VmZJNGpVYm1xaHRXc3ZZbXdnWFZiZWo0QlArZWpkTTIvUmtsMFR5cVllRmRk?=
 =?utf-8?B?VGgwNFdRUGNvUW9RNWE1M2lDck9YOVhzMGRZeFhQWERXNzA0Z0NwZHZ6YkNt?=
 =?utf-8?B?Q0dlc2Q1aFZSaldib04zQ1AwVVhPbklVbVFyelJqcHN3YVdHZnNVRFpvcC85?=
 =?utf-8?B?MGt1WnZxTHJxa1hkLzhKL2dCMXNPb1dlcXAxbDZPSnpsWDlma3J4WXhCdE9S?=
 =?utf-8?B?VGxYS0dsTHBJRzcvV0pWVkJNbVFnWkVqOFJzbHBIc3VHRnJ2czdKVEFpaTg2?=
 =?utf-8?B?b3c0OVVZMWFJS0VoeUk2aG44VDlyZlNsZE1sbFl5YWRaRnZPWEljUXlXWkZR?=
 =?utf-8?B?dVhScTdBbHA4N2xEaDNwZy83RFdqL1V1ME5FK3k3bzRpbDhxcWZ0eTdwVDBq?=
 =?utf-8?B?OVRRSWJCSFhPMFF3QWpIdVpvaTUxUXRPVmZ5YlNCQkU3RlBKWjA1V083T3M0?=
 =?utf-8?B?RiszbVp6bElGN2pBSW1QZ3JuQVdneUUxZkROSTRYSFc2U2dwR2ZPUkZxZk91?=
 =?utf-8?B?dWlkZmozTEJ2OThWejhOZHFIa2ZXY2FwYytuUVBtYUxJTGFhMWZScG10ZUFT?=
 =?utf-8?B?WXRKRk5QdUZmQnl3VEVKc3puRDRlZ3FOV2xCeWlTMDlWOFYybG96cjNGTG41?=
 =?utf-8?B?a05OL3IxMm55dnNOeXRidzl1ZnBMMzRDTmNmTE5BVVFYRndlN0FFQ3c2emln?=
 =?utf-8?B?OFFPY3hSaU04RnU0SkZvb3RoZ3ZrQ090cm5NbDdCOVVVZy91MXVSUmJHL0tT?=
 =?utf-8?B?Vkk3V2x4b3JxdTBrUVdUNVdqV2d6YTVLUkpsMUxOdi80Smlvd2ZXVlczVys4?=
 =?utf-8?B?RThsYUVWTGxTQ1p3cElqNGd6NWMrRHNxTjdhS3dDOU5TNG1VbW5qNGFROXMy?=
 =?utf-8?B?Z3hiMHFyWHNiUXVHekZQU1lEZWN3MG1FVFVGMk8vODBrRkJ4ODVQR1piWlhI?=
 =?utf-8?B?cFZFcXc4UDNacXQ2MVVSSXlOSHhvQWtNREZFN2dNS1BaOUhuSks0L1QzUmNa?=
 =?utf-8?B?SVo2RkpWaFFYTUJOMUFBMk5XcllCRmdBMUM0NmdqOE1HQjNPMHZGR3I5d0V1?=
 =?utf-8?B?VDZwWmxKZS9WRXJWOUVDOVRMZzlTWHN1Zng3eFJMSGdLajZNL25yN1NEU1h3?=
 =?utf-8?B?ckcvQ3MwaUlnZkxaMHp3dFNKRkpteU5kOExUc1ZRWVdNZXZ1OUFWMkxYQS90?=
 =?utf-8?B?bzRuME9jdDZoVDBLNml0Y3ZmV2lDMW9UUGliak5lam1KWUg5a3lKNmcwNTdD?=
 =?utf-8?B?Q1RIVmYrVU1TS216NzJYYW1WWjAzeWVVaWdwbENCRXFlQ0N0ZzNTcVpzTlRx?=
 =?utf-8?B?MjFac1l5Ujc1VG16akV3UmoyaGFwOEs2ZGxqbjdIWEYwalRRZTlGeEFmdHpO?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a542f8ef-3518-450a-9fad-08dc83f7fe78
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 18:07:13.0885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7nx0MW/Fz0F+4shFdKJF4lAbz/F9e4nsiOGADbvKoZRThkSkXxYgNNwnXi6VSRGPK3QRZ7qWXSz8fQLSUr9+ptnReW3VgqzJfPszSaqi0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7383
X-OriginatorOrg: intel.com



On 5/31/24 12:57 PM, Tony Luck wrote:
> Use get_cpu_cacheinfo_level() instead of open coded search.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
