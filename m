Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0472239E97
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486492; cv=fail; b=saVegRRq1WPYTKre0GdhbMikqjCCvrRznXKWGQBussLVfaQ9Xt/RC6BX+t1NCxaKHiW4H+vWNNXP9aD9UzssxQl4wlByGsKI7DXGOVAF+nZVmXCIkjcIIDXHovGRpkNnto9PlniZgtePPa8/7e1T9Jz7kPQeZz68JEiL1WYmZUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486492; c=relaxed/simple;
	bh=n+TX/nRhNIo5QZpDJuQABwKMz0en4HQFHMWS2g10+6g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s0b9AAAlg6jNodMMG7959tYweVfT3Y6AfuNIMbhVHjlSY4Utc5+ilBk2HBlv4c+zbGVryo4FocskfALPwV7CFPPxS+lXXMhMayQI/3u7+lWVpsTY9AsEXqU7RlUNmWxLD6P/kSb/TY7VXHipgQWwU/MmW5iP2HSiwjbp+7/EyYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QrgvkQw0; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QrgvkQw0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486491; x=1785022491;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n+TX/nRhNIo5QZpDJuQABwKMz0en4HQFHMWS2g10+6g=;
  b=QrgvkQw0dTuaLLW4mn3A9avE7pRyQRYWks8QNpOmo4hs6kaZ7XcIQ268
   KrHsT+l5nxdbkWaIvKrdnCFr5SVCoqiOTqmpE4xiTfgaBxJSRiN4ulNG9
   COQhszqPBX6C0VmzV/IAnWwiXeL03thI/pT7+ykHIhL1XmvFukjMOqLUi
   qIChczwrhpymVd+FGneZg1clkmOE6kt5S46DuHFbsZD+5X1St1Yd2Vbwi
   HWlEdOU4zU//3V9/gqexRrzyXlOT9Gu1PXv3EEMXiqzTJzNjqDcQRIJ2a
   MgCw5HgX69seQdUtC4jcojXfDxEkHnAdBVwrADPC+Vi/lTPJIZxwY1azW
   Q==;
X-CSE-ConnectionGUID: 1DZf/RQ6QsG67WKGhKqhmA==
X-CSE-MsgGUID: rnZnGymiTu+9aclkLew77g==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55922867"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55922867"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:34:48 -0700
X-CSE-ConnectionGUID: Gtwm8F+1SEWofLQXp/rhzA==
X-CSE-MsgGUID: h5u5rhWKTISz+FNKweT7Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="165298079"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:34:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:34:47 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:34:47 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.75)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 25 Jul 2025 16:34:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E49aIV8xSML7+baDg2RrvPYufxOTQ/l/uNCXb+tjyOYOAeMOjv15khwIF6JA5e4/1U6DUnhUFVUnqZLbdheVhB55iDfiN1t4ZvmhI5JRYZl81qEF5qz+rV4V65NCERJnWgudxMX++I4F324AkZK42Kvaj6JMH6iYT5OL2eGjin1HuwQ5nFhAEXthvvlXoHj/f19kBG7uTkPEIzItVEL/eS8KG07FIRvsjZQ/Yr9wcty9RV+TQinhwVYb5Rplg+2Hvwn1fWPDuJg6KcKzUDLuu3c1xXTqruK2xIE51SkwIYhLEWyGDtM3YhcO/B9Qp4eptMlRNLgsZj3lM3YuzGfy5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExCIHPzYxnVwFj+qUMPDTikfcVDXRZCVeEoOIlYCIFU=;
 b=AJyjMIb4rcoV0CuBx2K/a4ujZ546a57n74xwbPg6WzDfIcrVqQFImWoexQIXXOJKzk14rfVEjoIwJ7q2bZSdSHpZBuX7PGmZFWgHu6ZqfizmmvM+hxJhTlKXxjCUeuVp+9ejSDvE7j0OmPDFSixP8dnfsY2VMvOVihy7XvdLN8oxrsbMPpZusLWSK5TrNWPEGRLHJOELDUuA5/lbOtWC5abseWNiIltKFhhGMoHZqnttnv5XgB0vpPkfKcLUUoyxjtLNSwxRg1sm0PewUtOboZiafsv/HfNQbkJTkwwh4W6sNyxX51p2Hsm5ONhGTdW4FMd2Sj8oHfaWlgyzSwKYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN6PR11MB8193.namprd11.prod.outlook.com (2603:10b6:208:47a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Fri, 25 Jul
 2025 23:34:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:34:44 +0000
Message-ID: <5ab0a5c4-a79c-4bfc-84fd-3eeb0b9aeb53@intel.com>
Date: Fri, 25 Jul 2025 16:34:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 14/31] x86,fs/resctrl: Support binary fixed point event
 counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0305.namprd03.prod.outlook.com
 (2603:10b6:303:dd::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN6PR11MB8193:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b6fcbb2-5a4a-459f-a7ac-08ddcbd3d5eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N21kd2tZN1V3dFd6SXZ5SVFQMy85Q1lZSkFvM0k1WHMwWEhmcUpiS2Rxa1Br?=
 =?utf-8?B?NXVBRERwbXdRMjBwWWpZVUQyMmVtdzVXMFFGYUZVZytOTGZScTQwcDVhWk11?=
 =?utf-8?B?L0RlVmtrRFVEQ3JlNEJhSlM4T3VBZGpES2gzUDdFN0IzanZtOGROcHVrR3VZ?=
 =?utf-8?B?QVpVaTJ2dkJkVldnWkpzL2c1TFlhNXorYmMvQkd0c1VwbFV2WE1NSHVIYUpJ?=
 =?utf-8?B?ZytzYURmTDZpVlQvUjBtWDlhMXdBL1BtZ0s2WWxTbExsMU1YWVZnM1dWR2U0?=
 =?utf-8?B?U245ZDFtRG5YTU9uVStxazIyTW0zUGNkZFhDeHFBL3UvbER4MmQySWJXSGkx?=
 =?utf-8?B?ZzNOYi90WFZHcU1Za1ZhWjlmaW93cmVVS09paFAzekFJQkR3Vm9JTUhoOWVS?=
 =?utf-8?B?bnB3bDUxbmM4TklyUVBwUWhjU3RPeXVtOGlTVEhlekxWeGFBUERnd1ZKVWFK?=
 =?utf-8?B?TER0blBYME4zVkFMcStaOU5tU3lBMW5BUno5bUZET2ZKWkh3UDZhYmFnaWxY?=
 =?utf-8?B?MkV6dWEzYmJVVXVLeDZrRHpqUDUrVFZQLzhpV2VuYURQNTFtWHhwMTRYMHBN?=
 =?utf-8?B?WHFvOHYzN2I1UU5UcGNaNjhMN00yMXFjZ0pyRkFXVFBaWk82MGNaaXphd1ht?=
 =?utf-8?B?b014SFMwTlhtYUs2M2VOQ2pCNWtrUFhrRTRNK2lBYk1USnFBTVMvRWlYRVhM?=
 =?utf-8?B?aUhDZGo3RlgvcHN2aStHNUx4SnhpTG15YUg1cDBBTnNvQ216bXlEcFlzTEFV?=
 =?utf-8?B?UHhRc0dUMDlISDVVZnZmN1ZZUDBiYWJaQ0dyd1FLMG1xQUZFVEpRWTdzNXNl?=
 =?utf-8?B?Rlh0SVNEVHF4ZzFCU3NIUldoQkFmTDRnL01wM1lYcXBNQW1CNENIOEt5ZmQ4?=
 =?utf-8?B?RkV3eTlXSWhJaGo5K1BmZW9xcGV5K21NVE9nVHVZNnlPRDJNL09LT3FhcUFI?=
 =?utf-8?B?Z0I0MkJ5eGJoOUVXeDRWY1JlaExpRURxejFXb1M2Rk1VUmtrQ0xXYU9IamEw?=
 =?utf-8?B?cFIrNFBOR2crNmQ5VkEyUldBVXhpSzZSSXR1TFhtTkJOeHFZN0dNVzhXTmVw?=
 =?utf-8?B?eGphelMwT0VXb2s1TG9VdGVFbzFPRDBDUG1nbTlIakJ0Y3VscnVDWjAyRkdE?=
 =?utf-8?B?b2NhTGNyTXFvdmtZNks3clRTY1hGQTdEVkcvWkFYVXk3MTh5Y0NxcnZSZnlO?=
 =?utf-8?B?THozckdQUVI4dWJPWHlkcTBUbDNUK0RjemVDZ014ZzM0anZSNmppZEN4emYw?=
 =?utf-8?B?VHZSLzNkQlBJT3RzS3JmT1JENDBUcHRoVU15bXE0bzlIOHZma2s5MVp0ZEJK?=
 =?utf-8?B?OEZ2cDBubDZlNjhUN0krVlZvVkxOOVBWTUJHZUVXOVU4MlB0U0x6Y2lzdkhk?=
 =?utf-8?B?bWsrblB4WG1pcHgwaHJKUStKQi95UlBQdHhmRitGbENUWExRL29ENVBLdUtT?=
 =?utf-8?B?Q3FyS2ZzaWsyN3pOQjZWdnZ4aXl5MXhiK0tyUHF6YnlrcDJOUytodFNCenEx?=
 =?utf-8?B?MnlyMUlwSWNUS0xidnFwZ0Q5VkpEL3VobkFPNlpOWjBkR1FmaHZQTUZNK0lw?=
 =?utf-8?B?VG1JQW5iWkZXQU9QczlGV2dMWUdEMDNmc2hnSGFLb3BsR0ZyNUc4TVM0OUV3?=
 =?utf-8?B?U2ovb0tTUFF1WDVBYTJyYU10NUhIT0t5NWllMlhUR1pteVZsL2VMWGR0TnM4?=
 =?utf-8?B?RlZlV0dPdUYxNFdmWnAvdVhDS3dEdUxGSTZ3QjRaeHZjVTBWNjRwWFh4NTFU?=
 =?utf-8?B?Y3FSVFo4MFJCNDdsWHpuaEZYcTRkSG83RjdYWFNKYjV6N2RjbXFEOVlaR1do?=
 =?utf-8?B?NEY0OGxJeXZNbXUzeG1ZMWJCMkR0VDJCblBuVDRBcTJNOTlBc2FUeU1wT2FS?=
 =?utf-8?B?TUJ6dHFiVTB0R1lma0pncC8wY2FUdVQzUUNJdzVVcHROVUcyTUVGRmVFb0Zk?=
 =?utf-8?B?MDNDaG5lZ3VNQ0I3UC9WRVNBeEFwYlVxNmZwN0lvMlVTT2dCOFd5M1paVXUr?=
 =?utf-8?B?TVhCcVljVHVnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHRFcFF0aVJpRjBUSWs4T1p6dU5GUkxlTE1KSzRubTdHRVFyZmJuQnRwN0V5?=
 =?utf-8?B?SUZUT2dBOGZKQzdZdnBUeWJaT25lRnNpQmxmcWlQMEJ3UXNNemprSU56dFkr?=
 =?utf-8?B?RGZhS1ZJczVDQ2lWazQwTzhOemtHb3dBS0tqemhrVEJZTjZrbDRFMDVrUUtx?=
 =?utf-8?B?N2MwV2grb2tCMm8yWkg2b24rWWVuUmhEQ3NnZGljd0dQMHRvenorVzRqS2ts?=
 =?utf-8?B?OXdYYTlUR1ZyYVZPU1U5WUV3RWphVSt4YXR5TDJ0Z3BFRitXemxMYXFNZi9L?=
 =?utf-8?B?MklTL3hPNE5IcmJaZWJYR25qUmZJWUpKc0JkcWIvRUNPN0xrWlcvQnJ4SUlq?=
 =?utf-8?B?UllJdFNjc2tWUC9UOUF3QkVjS0hvbE16Z1EwT1E1MDAyblpPYnErdUI2MDFV?=
 =?utf-8?B?bDZkenFwMXMrSTNiYWFhcUlCRHEvQUZiWXVGMkNZMisyOVhqQlVJY2Nvb0ll?=
 =?utf-8?B?Znk2WGQ1c0JwcVlFZm1QZGdoRDVLZ25PNmlCRXQ5TGF6REk2ajVNSkJmS1FR?=
 =?utf-8?B?eEFRNXd2allhNVBxN1V6SElaN2FWUkM3RnRTQTRSQWx3eUhQNzB1RzBKL3U5?=
 =?utf-8?B?emJxelExdVgwY2s3bUsvRUxJc2xwRWZZYmwvNG5qTi9NWms5djBUVTQ0VHM2?=
 =?utf-8?B?WmhCQUZpaFpWNFo1bm1BLzdSWFNnb2QwZXFxWll5U25MRzZHZTl0OVZuRXNq?=
 =?utf-8?B?aTR4eFA1ZTFtNlJhdnVLZmRueS93bWV0MmdQOFpTSnd5bmhHZndVTjZTdTB2?=
 =?utf-8?B?d24va0xVYXN1dVFyZksrWnpPeFhXendZQjJabG5Rc2w0aHQxcm9LV1AyL0dL?=
 =?utf-8?B?RmliMG1pRDF5SVBPOGpMUGFoNXlvSWN5SW5RbUZHSFZ6aWZORURNWDZNWFlt?=
 =?utf-8?B?cVNtWElvVWptZGQzMEZmNE10Z25XWkg5Uy9yd3FOYjFiUEIwanFiL1czL1M3?=
 =?utf-8?B?eHo4Q3ZZK3BoWEdtVjYwNVpZb05hWnNEbUJ0cEg0UTBlRFVEOEYvamYvZmpk?=
 =?utf-8?B?Y0xWWFdoWFFmRDFxeW1SbTVDbG00NGZ1UUZvRC9Rc210WFFDNWxDNEd6ZThT?=
 =?utf-8?B?YWlrbjVvVVFuSzUyWEVKV05zMWYvNUFyWjdqU0NINnpXdVpwUzZZbERUWVl0?=
 =?utf-8?B?dFF1Y3JwaFVSQ0d2RDljWVFraU5MRHRtOS9jMGxwNXA0TU8xblFCQ25VSmxK?=
 =?utf-8?B?Q05RNjNnOVkwZGJBUzBXK3hkdmY1d1hvUGpKbllQb3ZXdElqZWgxNlZ1MEk5?=
 =?utf-8?B?S2lJSmpKbDNzUDNRT25JTCtBY2o4Y0Rwcmd0ckFoZVlGbU9zQjlGQ095aWlO?=
 =?utf-8?B?ZkxSWkFsV3RGZmtFQTgzcU1KWmdEaHphRFJDdVdEZnpWV2c4M0EwLzQwenRR?=
 =?utf-8?B?OTBxRlBQaFRtQW1GcUdzSVdsSDFMdHdmUWhKWlJvZlBuTit5MXM0c0kwYjVO?=
 =?utf-8?B?L21nQXE5ZkE5eVRDSnFhcklmNjhPYU5vRi9BOUV1cEpzbnhYK0t5ZFRJTUE1?=
 =?utf-8?B?T3g2b3hxSTFpaVFMa3pBTTE4L2VlS3h6YkFWU3dzYndPbHpPQmRURTZOaWhU?=
 =?utf-8?B?OXlyelN2ZW9VallVeE9rU3EyblBPSEUxbXM3c09KcEVHcENMZWVTbXhUK1gx?=
 =?utf-8?B?bk1UNHp6VDU3WERZUmZCSFBkMWMycklBaXp4bzcrUkJ6NGNJVE1TelVUR2xa?=
 =?utf-8?B?YlZ2YjVFWkNma0NTS2ZRelVHczh5NnVUZ0wwbDJIQWpDVHFWdE5iSFEwazc5?=
 =?utf-8?B?SEd3ZGpQMGNhU3l4TWxOS2tWWHptTk04WE9JUW1EdUVwTk44aGZsb2wyOHBi?=
 =?utf-8?B?LzlOQjhuOEwrKzY0VjM1NmxLVy9TOUJ4cjhxelI0bm5OYVZEV05wa1VKSnZx?=
 =?utf-8?B?ZWVmdEFMQ3VxdnBzVVNlZlJaeUVzR0Iya1pUM0F2WkpPYUZNVTB3ZTZXclYw?=
 =?utf-8?B?aDB5WVlNZlJhcG00b2RvUlhiTENQYTFxNnVEODhvemFLN3BFV3FLRTRDVDln?=
 =?utf-8?B?eWNvbFZ3ZkZNb0NOR2FCZ3NwZnhFWDlWMG9hMzdpSHJ6R0JrZFptdmRFV0xy?=
 =?utf-8?B?T09iMU1jZjlpU0NHZGtsYXlZUzhscUtGUm9TbFp0YXF0VEVEbytMUm1UbkxO?=
 =?utf-8?B?eU5nUzRWWCthQ09LR25TdUVBdGZwYmJHd2Y2cEJUWDJmT0ZFVGR3b1FHbWpp?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b6fcbb2-5a4a-459f-a7ac-08ddcbd3d5eb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:34:44.5180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmKF83F+C4Dkm7ipRpD80uW3VYiuCpqn4P+G/IvJaQUBFkyI0UrMZ5ywR111s2gSTOfTw4RImu6JinfDLZTON1fhgZaYpUAmJyMILcki3m8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8193
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Resctrl was written with the assumption that all monitor events can be
> displayed as unsigned decimal integers.

"resctrl assumes that ..."

> 
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
> 
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.  The file system will
> only allow architecture to use floating point format on events that it

"The file system will only allow ..." -> "Only allow ..."

> marked with mon_evt::is_floating_point.
> 
> Fixed point values are displayed with values rounded to an appropriate

"Display fixed point values ..."
(please review all changelogs to ensure tip requirements are met)

> number of decimal places for the precision of the number of binary places
> provided. In general one extra decimal place is added for every three

Needs imperative. For example:
"Add one extra decimal place for every three additional binary places,
 except for low precision binary values where exact representation is possible"?


> additional binary places. There are some exceptions for low precision
> binary values where exact representation is possible:
> 
>   1 binary place is 0.0 or 0.5.			=> 1 decimal place
>   2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
>   3 binary places is 0.0, 0.125, etc.		=> 3 decimal places
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  4 +-
>  fs/resctrl/internal.h              |  5 ++
>  arch/x86/kernel/cpu/resctrl/core.c |  6 +-
>  fs/resctrl/ctrlmondata.c           | 88 ++++++++++++++++++++++++++++++
>  fs/resctrl/monitor.c               | 10 +++-
>  5 files changed, 107 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 17a21f193a3d..e9a1cabfc724 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -379,7 +379,9 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
> +#define MAX_BINARY_BITS	27
> +
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, unsigned int binary_bits);

This declartion is now over 100 columns and will anyway be split across two lines
in patch #21. That split can be done here to eliminate one checkpatch.pl complaint.

>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
>  

...

> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 2e65fddc3408..71d61c96c2b8 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -17,6 +17,7 @@
>  
>  #include <linux/cpu.h>
>  #include <linux/kernfs.h>
> +#include <linux/math.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include <linux/tick.h>
> @@ -590,6 +591,91 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
>  }
>  
> +/*
> + * Decimal place precision to use for each number of fixed-point
> + * binary bits.
> + */
> +static unsigned int decplaces[MAX_BINARY_BITS + 1] = {
> +	[1]  =  1,
> +	[2]  =  2,
> +	[3]  =  3,
> +	[4]  =  3,
> +	[5]  =  3,
> +	[6]  =  3,
> +	[7]  =  3,
> +	[8]  =  3,
> +	[9]  =  3,
> +	[10] =  4,
> +	[11] =  4,
> +	[12] =  4,
> +	[13] =  5,
> +	[14] =  5,
> +	[15] =  5,
> +	[16] =  6,
> +	[17] =  6,
> +	[18] =  6,
> +	[19] =  7,
> +	[20] =  7,
> +	[21] =  7,
> +	[22] =  8,
> +	[23] =  8,
> +	[24] =  8,
> +	[25] =  9,
> +	[26] =  9,
> +	[27] =  9
> +};
> +
> +static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
> +{
> +	unsigned long long frac;
> +	char buf[10];
> +
> +	if (!binary_bits) {
> +		seq_printf(m, "%llu.0\n", val);
> +		return;
> +	}
> +
> +	/* Mask off the integer part of the fixed-point value. */
> +	frac = val & GENMASK_ULL(binary_bits, 0);
> +
> +	/*
> +	 * Multiply by 10^{desired decimal places}. The
> +	 * integer part of the fixed point value is now
> +	 * almost what is needed.

Please expand comments to 80 columns.

> +	 */
> +	frac *= int_pow(10ull, decplaces[binary_bits]);
> +
> +	/*
> +	 * Round to nearest by adding a value that
> +	 * would be a "1" in the binary_bit + 1 place.

"binary_bit" -> "binary_bits"?

> +	 * Integer part of fixed point value is now
> +	 * the needed value.
> +	 */
> +	frac += 1ull << (binary_bits - 1);
> +
> +	/*
> +	 * Extract the integer part of the value. This
> +	 * is the decimal representation of the original
> +	 * fixed-point fractional value.
> +	 */
> +	frac >>= binary_bits;
> +
> +	/*
> +	 * "frac" is now in the range [0 .. 10^decplaces).
> +	 * I.e. string representation will fit into
> +	 * chosemn number of decimal places.

chosemn -> chosen

> +	 */
> +	snprintf(buf, sizeof(buf), "%0*llu", decplaces[binary_bits], frac);
> +
> +	/* Trim trailing zeroes */
> +	for (int i = decplaces[binary_bits] - 1; i > 0; i--) {
> +		if (buf[i] != '0')
> +			break;
> +		buf[i] = '\0';
> +	}
> +	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
> +}
> +
>  int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  {
>  	struct kernfs_open_file *of = m->private;
> @@ -666,6 +752,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  		seq_puts(m, "Error\n");
>  	else if (rr.err == -EINVAL)
>  		seq_puts(m, "Unavailable\n");
> +	else if (evt->is_floating_point)
> +		print_event_value(m, evt->binary_bits, rr.val);
>  	else
>  		seq_printf(m, "%llu\n", rr.val);
>  
Reinette
