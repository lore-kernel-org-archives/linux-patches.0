Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB164239099
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921573; cv=fail; b=Yt5dwjv+fWxtW6Ht3UfLbzDgFZFkog2uyJb3/XEcSmV6RqgJAP7jcs9cfE+KOFLXoGsJD0k/vGGIlvYBJhuO++qKF0fg1BmJPH3/Sm2ORZOSA9+7mlVFK5xILAT1U/WQAYaEhC2o3WPR+7bUup3OvtOgtN/Bu4eEgTXAkedRHxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921573; c=relaxed/simple;
	bh=QcjiICjeno29cbSBB4DjgvK0LY1TXCkJJFPk8p+OcgQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VxA6K3CUEbFmizeUhnwf9qSF6SMsuC6of+8daL/VCBLkUIjKlbWsUiDFepCucD37kez9FyC4wus96ZHw0Ir8xV8tT9SBYyE9NwaZC63vFMbXd4L+VmPsZzuY+uqW03LWkD4Z4QzpCYhr60uKhB+VZMVAkF5pczAQbPr8//lD/+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AqIxqXen; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AqIxqXen"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765921569; x=1797457569;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QcjiICjeno29cbSBB4DjgvK0LY1TXCkJJFPk8p+OcgQ=;
  b=AqIxqXenMuGtbW0KGonaQKOaEorldb/x+zkrjTXDTrts0CEM9a6LHN+Y
   n2FoMb0GkpKLqG+1mLfvfH7AujlfCxJorlV3+Hr8vAh+JDhb65mdqjx/2
   pvrEc19yfn4hfrfipvt2LDQzNkCM53viSlnkhV03pyzMmXNT1fgqaBlpg
   jvqzss+JFm3N2lE3WjkXlsy9L+eiq6aCCXlqBJMFkCg1FmZpzGWs5g2M9
   4luYbul2hfi3ZA1wIsx8EGCF/MWGCXxgtqvjPM7WlonY7oSo9eA0Zo3Kp
   d0iSJaChJac9VxNp+YkTHQDUCy1hD3TRD2XdN2dDqCB9JiRljl4anZYKA
   g==;
X-CSE-ConnectionGUID: kU/DMQvWQP6C/0KPmNjfpQ==
X-CSE-MsgGUID: ebuL+VWQRqiRVPmjQwl34A==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="70428658"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="70428658"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:46:08 -0800
X-CSE-ConnectionGUID: Ecz+ZeW4Q46ujmfnQ89Jmg==
X-CSE-MsgGUID: oX0n2M/+SJqDbDw0IftQ8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="203241488"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:46:07 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:46:07 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 13:46:07 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:46:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ufarl+Oefh6qRdL2qA3BU/27PdicMCrRCN7Otm+SjdGi9QB2ye8TGu0RSPUSc8ayD/l2i6lpChGlmbLNNAD2Qq7gSgZAeiSrorwzE2jm9zHQB4n/6ACx82wk7JWK1m275SqTjZ0Oo5qFuRQmKqaIR8NfKcfLhbt4eYrGnZiY5cjbnIPTnPCkxc1QKrShmV9N65IDOBa+193tUvd9Dpgf5R7Prr3Y/GWHYp/ddWVtPcOBZ6v+cc2zYxFVqnHVyuG/hB0qvAgRmu7i2tGcfC3jM9qIFvjaE34RihhT0NQOBM19/cM12BiUCwhRalKIMtdBjiDbgObGyeAnMfHT4rGlOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k44ecrSYkBT+zm6PbG6FDPd4RRW/QH63U5IyjkADpFE=;
 b=LwCrGM04dNTXNuD21kRPaoTAbnCI6LITgnUGxUR8bstMoLIHxZ+c1xJmRlVhLCvoFJYbbpKRviVqSz9x0utoPBMxjQvDOghHiRaNSZC8h9s/DR368GXcaBQoECbQCwD1mXIciupvYNtNpME2j8ALEgm/bRjwouAPMG5yZtkj3e6AmkIysBI6vTb4Md5pbF2+4z58BYtRfl6eCzF/9cdkX1ZU9agGJEg7/cfpvLhzF80q01nZVX5Zeavhu/XCJilJqeTCbblSTs3rD2rpRVC9bvc2M8oJRAl0xBH1p0oAYIPomxivmHgN/xlqyoFAa2fGBVdfV42ue3ooNmIFmfpoDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7389.namprd11.prod.outlook.com (2603:10b6:610:14d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 21:46:05 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9434.001; Tue, 16 Dec 2025
 21:46:05 +0000
Message-ID: <45876597-85cf-4613-ac37-22a01a42adca@intel.com>
Date: Tue, 16 Dec 2025 13:46:02 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/32] x86,fs/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251210231413.59102-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0191.namprd03.prod.outlook.com
 (2603:10b6:303:b8::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7389:EE_
X-MS-Office365-Filtering-Correlation-Id: df9340f4-8d18-4671-687c-08de3cec836b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eFZSUEVUdDNOWHFwMDE2MjlpV1VCTDluM2lxSE9yblB5K2Y0SGtFT1FMRVVU?=
 =?utf-8?B?Y2k5enpFdjRTZUQwUk5waUFnUVp3MnRaT0FKUjZmRjRKTjFDdXIyTEFueHpG?=
 =?utf-8?B?ZlVsd2w4eXY5czBSVHJCK0s4VVlhMUZsU05xMXdITFdIdjgzNTkwVFBFMEt3?=
 =?utf-8?B?ajdUdUxmWFZMRkdaYjB1aC84b1lNU0ZmdXNiWFkzTC9NUThlcyt4UWY2NzFx?=
 =?utf-8?B?a3BaVDJHc1BqZjNMSVlKT2xDNDVSdHY4N0tZYUpzSHFUQlNVdmE3MXpNOW9t?=
 =?utf-8?B?U21oRkRLdFFMZVpDRDJ6OUlRY2NaR2ErOElwemxZcGRYai9jTlJsTkdnL0hD?=
 =?utf-8?B?UUU4TVcvSktTTlBNNW1rbzFYQlhkQnpyTEVjbUs5VFdjZlcxVkFhTk9YY2Jk?=
 =?utf-8?B?OGxWVmxWMVRqci9rdTVYVWErK1ZPOStLby95MVdEL011YUxRa1VHU0czRTNM?=
 =?utf-8?B?N1JkbUQ4ejIreldpNVgwMTZiOEF0T2dPSjJCa0tJY1VCRlZ3S3U5VjNSU3JB?=
 =?utf-8?B?N1pIalE0OUpMRnpGbUxDRjFENnI0VE5SdGYvUjlPMFk1eEpvZXc3STVKUlk1?=
 =?utf-8?B?RVhlSWprOFU1VU5lR0o1OS9MTG1qV1NzdEdFa0dEMURkZDV6bE1hd1Q1MnV2?=
 =?utf-8?B?V2doK3VPL21WM0dxbkFGWU5kTngzcjhCMHRzbDNBSVcyNXUvOThpYm96b21B?=
 =?utf-8?B?cmdLUHJySVkwMFk5NTJsRkVGeEprSEVBRGZYYzhNSUNZeG9QM2lyMWRGdnlV?=
 =?utf-8?B?UjlNSW5ud05EYSs0dGwyeUg1WXJZRDhRN2VqN3Q1S2t3aGxSdDZJeWlNSks1?=
 =?utf-8?B?RDVCMVoydzB3KzRURlFXbXJMM09YNlB1OXZwa21mNlYxdk1OaUZqK254U0pW?=
 =?utf-8?B?OE1SWFMzZFU2Nk9uY29tTXg1RDNGRnBOcXlESVoyNi9XUG9wTUZUakdNNkNo?=
 =?utf-8?B?UHhUUFFpZDBQMWh4dVE5YnAyMFprWFhJc0Y5RmRpTTZpdWdqQXVtT2tSdW0z?=
 =?utf-8?B?WUVIVzMvSEFEZlF0bnc3bnVwV3dTNEZkMmJEQWJMZGZxWGJTRUtRS2M1Nzgx?=
 =?utf-8?B?OTJKenU1NUxQSk9kbk9nSjdlQWNXTXE2bkxGU2k0ZWhCKytJMWxoTnhTMWts?=
 =?utf-8?B?RHhmSHMwQURXdWV1cHlRZ3hHREhmcFN4TTFyK09mQ09yL2hhVGdMdzFwU2JI?=
 =?utf-8?B?b0EybVVGYmFFWTVXOFpwOGMycE5MdE9ZNnh0ZGc0VDN0ZmtBZks0RDZOR1hv?=
 =?utf-8?B?aWRsL0ZyeXFVYm1XaEVVUmN1ZEcxNmNMdjZKL2NQaERVN1ExTng1aWFJWE93?=
 =?utf-8?B?WjRwcStXcnVtb3VuaG5SMExkMXg2Si9MY050d0tWOE4rKzFMS2lnR2tXOTZY?=
 =?utf-8?B?alAya2hOQVVIWDZRUnJQQXZ5UUFFaUs1QjA1Q1ZCU2NFdEgzQVpRV0p0dG05?=
 =?utf-8?B?bTArdXZRZWN1Q1lzdjFhZEUwVDZPUVo0STFXN3BwMmxpVXBoWTVFNFJPK21E?=
 =?utf-8?B?UEZQTE5VRm1xWDFCdS8xYjJkd2JXc2l1MW53cjhaY3JPTHdaeUJEMXJEV1VR?=
 =?utf-8?B?VFAyRmV6Qk1ORTBXd0RaSmRHNHkreElEcXNhWTVNQytwWTE4cjVaNm5IVUFD?=
 =?utf-8?B?M2tQTElVTHBuU1FUcmZuMEZyT3FLbHkrVE05TUM2VUZMM3pBa2tEbXRvV3dO?=
 =?utf-8?B?cWlydnZOcDNFZmVueDlsNzVtbnEvVEtjbXIrdjN4UStWZ1pNSDlLbHhBVENk?=
 =?utf-8?B?aVp5OWlUaDgyMW5vT1ppT3RFdDlrTGlXM3M3clY5MVFBWmNlbnY1V0kxZ2JG?=
 =?utf-8?B?Q0RPRlN3Q0RNdUJUamVGK3pHMzhoT2crSmZ6Q1pqa2JHWDJrU0k5R1RiNnNP?=
 =?utf-8?B?dU81Uk9rZGRIay9yVDZXMzhQUG9qQis5bnNFOHJRRGpjNWV5T3Z3d3IrWS9N?=
 =?utf-8?B?NVQ0OVB2UEJ5dkI4ZE85WWZuS3R2UW11ZnZQcEY4aC9qK2Z1S21YUkdzT1Uy?=
 =?utf-8?B?cERZbW9qN0xRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWJpb3VWemRGRGlKRERTV21ucXMyTno3ZXF4eHFkaGRrMFhmcTcrT2xsOTg5?=
 =?utf-8?B?cFBlcEtVNFhkNWd0cDIvNStoeTUvVzFmZlVpYVRrZFlxaWdxN3JlanlPbGhK?=
 =?utf-8?B?RXVVS0lpOWRHWjZvd2ZwYzBvYW1uajFjZklMZkozR1l0djJsZ2JxbHJXTlc2?=
 =?utf-8?B?d3NVQVVGbUhVWGd6eWxUWmh6Y3RyMi9KVXQwcEdaZlphWUY2SENvOHJtUjlp?=
 =?utf-8?B?QVYrbDh1a3NHbXlJdFgvYWcwT0dNcTI2UlgrYzc3elV1akxaY1JYNkt2VXc0?=
 =?utf-8?B?L25BTXNOMVg5Wkx6ckV1VXJhREhUOHhhNHN6ZW5WM0w5bEJEcHQ1Q3BOa3U4?=
 =?utf-8?B?eDhqb251bVlIbkJwcTV5aUNURDN2MkJHaHRINEh4VkMyd0hSVVFQdGdHUkpz?=
 =?utf-8?B?SzN2NjZzUjd0dXJBUENKYUxHRkxvaG1BT0ZVRk9JeVRHYmZqRkxMZk9IaENH?=
 =?utf-8?B?SU9jUklzRjZOL3Fka3dkNlBNbm5QMlpGRXdWUEtQb2ZYd3VlQ1QwVTh2NnVl?=
 =?utf-8?B?em1ZVS9wenR3Zit4MnNVOWordnhnSWl1MDFVWFU2SWcyc2NER0swVTlHWHpC?=
 =?utf-8?B?QnNjZ1ZGZ0VXeDhXM1FXZlg0bG9hWHIrMTl0a0x1SlZNSEpMWXBTd0lCY1J6?=
 =?utf-8?B?Wjl5eHE3T0o5cWcyZ2JGWmZaWm1ZZ3VqeWFab1dCNmk4SWNFamdtMVJDenpT?=
 =?utf-8?B?Y3F6RW9Fc1dYUkNXOVRJMGQ4T0YzdnhZYkpEbE1YRGtnS21rdmNJeGltT1dW?=
 =?utf-8?B?d29Xa2RtYWxKNVp5b0VQWVJUaGxVdU1WWTZFRVVOK2lzbzNFR0lZZmF5YmVC?=
 =?utf-8?B?YjlOWXFWRG5ub1U2OThFYll1TVI1Mkt2cnJRendKNW9aL3FHVmdoUHZCUHZ4?=
 =?utf-8?B?QmJGNE5kWVh5bnRFVGNhTFBVQ09MTXNPQitIRkZEa0tqSXhlOVBhSjA5RjJw?=
 =?utf-8?B?M0tVMzJ4UGR6S2VOR1V0R0YxSzlPaDc3NmVpWUNVclJ5YkxlbE1OUHdNVE5m?=
 =?utf-8?B?MHBqN0ZFQ3hOUlNObmhDUHNhcnFOQ29Cazd2N3dZenNwVGwvNUpkQVRQMkFI?=
 =?utf-8?B?Smxtak5VdjU4TWpPN3hqYi9GQVFVa1F5Y2ZZRjZDMEYyM0orREc1VHJDcFlK?=
 =?utf-8?B?UFZZcDllbHZ6bk5XOVZlQTlKT0R0UXJNdHpRRFR6Rk1jOUUwSm1TWG9Cb3BB?=
 =?utf-8?B?MVlTWWNJRnRyL0pNYklxdm4rTmwrY3A2dmR6SmZ3VHZOanhsTVpiWFk1aXBm?=
 =?utf-8?B?YXkwYUdyOUdiZS81cTRSK3ZHeUZHLzJ2NU1paDk2MmZ4RjJNbDdYcUh4YXRv?=
 =?utf-8?B?bkVkdFZCbEN6MnNiVnZaUFNaOFluUnJwNzR1VlJqRy81YW4zNTB2THhzdElI?=
 =?utf-8?B?MHFESlNFWFpRSlVKWFdXNmM5ZnpxY2QxUHpSMXJkV3RNNGd6bnFUbHV1N0dj?=
 =?utf-8?B?VnNEYlZidWJQeVRsNjRvSDdsRk85ZWl1ejhuWUh5V2tZbFVXUTVXcTRvV2pk?=
 =?utf-8?B?RUlEcUNVUEphQzBPOTF5R3g1VFg5VTBtZXZEaGRvSXFJZi83bTBZMzVlS01x?=
 =?utf-8?B?V29aSjdVMUdVMDB0d1Q0T2dqaHVxMXRXT3dIdi9lU3pTRE0vNm9CcUEzYUgy?=
 =?utf-8?B?WXloT3l3eWhRZWlWcHI5QXFwU1MzMWpnOERXU1NVcklhT2hFSHF5V3pXclho?=
 =?utf-8?B?RFVLOGxaRFd2emdLL2I4MVUxOStvSUVoclVpUkRQT3QxQzl4MUF6blcvVHlT?=
 =?utf-8?B?R3VSZ0ZzbTVWUDVWQ3h2RXlyNk5TdjVQbkhZeUhRWWxOWUxOZUQ5aEhiTmxr?=
 =?utf-8?B?UHc4L2V1OFN5VFI4MXkrbUQyVU15bDZlZUZpMThOR2tIZFJaeDZTWFdKQmZC?=
 =?utf-8?B?N052TWYrNHpOM1ZsR3cvZzFsaTBKOWxxdlNZUjNQazZvdWszaG1MSmlvak92?=
 =?utf-8?B?OUVndFVEcURKa1kxTThoaXQvWDZOdkVtbHRodFJBNEZVdmJrOU1udEptUU9y?=
 =?utf-8?B?ZndnZGJtZ0FQU0FhV1V0cWF1RVVadlRHT0kyLzh0ZlVReVV0bUozaTg3Zk5n?=
 =?utf-8?B?Y3JNMTdHdU9NZ3V2cVUzTWFmT3ExOEVnL21paUNVMFY0YW9rN01Cd1BpWWxM?=
 =?utf-8?B?d2o3UlUrR3pKdU5YcVRxNVl1ZlplTm9KVEpBUlZJUWNGL1Z4MkdmV2xqRjhG?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df9340f4-8d18-4671-687c-08de3cec836b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 21:46:04.9671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIhSEKdPLduB1md2Tx/wxhzYEVK6LneQETQF4GfhQ0fVJMkQeUdfF0XPZetJ5whoXjdy5q8Noimq7bq8+Qo36y6Lsr8DFUeRfzr7QLR5TJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7389
X-OriginatorOrg: intel.com

Hi Tony,

On 12/10/25 3:13 PM, Tony Luck wrote:

...

> Background
> ----------
> On Intel systems that support per-RMID telemetry monitoring each logical
> processor keeps a local count for various events. When the
> MSR_IA32_PQR_ASSOC.RMID value for the logical processor changes (or when a
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
> The INTEL_PMT_TELEMETRY driver provides intel_pmt_get_regions_by_feature()
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
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 

From what I can tell the changes referred to in [1] are not present. Looking
at the cover letter it has one title "Background". How about a new section
that separates description of the implementation from the background and includes
the additions Babu requested in [2]? I believe resctrl.rst already covers the new files (and did
so at the time of the request) so I do not think any more additions to resctrl.rst
are needed to address that feedback.

Reinette

[1] https://lore.kernel.org/lkml/SJ1PR11MB6083CFADE3EF56796BA43097FCC5A@SJ1PR11MB6083.namprd11.prod.outlook.com/
[2] https://lore.kernel.org/lkml/9b0d336b-dd12-4e4a-b324-75734dbe6002@amd.com/
