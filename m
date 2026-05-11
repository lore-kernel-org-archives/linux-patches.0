Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD51123EAA0
	for <patches@lists.linux.dev>; Mon, 11 May 2026 22:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778540026; cv=fail; b=HmkjaGOQQe2cVRH1D2Ndk+zGy/j/bemWJLI6pF9X3UTsaw3iLIbqfzrvRtwZsaqbTxCGWDQTfJtHeJa/DTVmSGlJpOYlw/E2Bh+pu46a1Xu5Dlkf2aiQuITXdJJUfh6NA06swxIwXMwhQYjXXgBbHjnTRypMIywtH1Fangogv7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778540026; c=relaxed/simple;
	bh=NT5yV6w9rE/ch+uI+xBBvcb0mYscfipMVEDHglC/464=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s2r6VBUxSz8+gr78bKMecUv7DU38DPfZ6xeq8PO+PvX/Qu9aDqeePVDizJ2w+0Lvi8kEH/40gElmFQ+mZKyAqovzxBao9hlhxlknTSAhMLaW6zobXlQDQMzO7QYV9s0G/Ixt/2QuDvMolcAIHp6U56zqzDVr8KEVdeGZqr01as4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RbDpF7dR; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RbDpF7dR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778540023; x=1810076023;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NT5yV6w9rE/ch+uI+xBBvcb0mYscfipMVEDHglC/464=;
  b=RbDpF7dRQ2p94smGObzvJCA5qZVEMCvdaWMURNa4xEfKZEPi4+ExEfpA
   UrDYWEk+b0xg+uXWk9JXErbrUY2llJ4Grfbf7oi7UKq5ZVywy7Xxlxg6/
   LOl4LMJ3NnmlGOfAIIeBNAY6s76kK157aEUJLxLuNZimAkQuZy0lad239
   P8/Z4CEneYi8JGwEIW2iqzzZeFPbtNsANzCO6GAXTURWLuRZIx3E/KgO8
   dfjTaFV9UQ6VEAt+yU1ODuOWUq+HWghfmwJgKLKcse0qZ/9vrL/je3ge5
   3wG0SFt9awLSTH2GY9rZ4UXhTQE9NoEkefN5odu4+xYuQB0FipYKh5iVE
   Q==;
X-CSE-ConnectionGUID: Vwn5r6wrT8WZGK3cSKBkew==
X-CSE-MsgGUID: CGTxpCocTl69NEKcsw8fmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="79337337"
X-IronPort-AV: E=Sophos;i="6.23,229,1770624000"; 
   d="scan'208";a="79337337"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 15:53:43 -0700
X-CSE-ConnectionGUID: hR7RvrPBSemtu5xYH910sQ==
X-CSE-MsgGUID: lEN8gE87RE6wFjYah823+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,229,1770624000"; 
   d="scan'208";a="261084699"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 15:53:43 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 15:53:42 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 11 May 2026 15:53:42 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.12) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 15:53:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iMCyRrohZNt/IR8jIma0DCIQHWz3CYp9quajms5thgNgr/G141hzG4ufikaXCz0tFj4eEX7auEeCC6FQ1pBWCfpUYQnjNtjdd9wetgmtuQ/KpsQ95yD0bOQ5qFvmQHsxaJqUHfZzdcpthr4l9gKRAZmB0mKYCeYiKheHz8vAPAMlo3MNueZdVRPdZ5Izz+C+EfDtPfbVFPFwvJq5W2cCte+1/0s/Eo/RJSe4ZnC4rRlpUatUd/65Vq5vPa2/3+3BBoecpDhvmvAbRfjU7HU29nofqCDAj87A7s8QCMonYctowA+zA+QDP/PQybBuDTNu3zo5mkPuXwQwt+E7lheGwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IvgBN7BPmo5t3ScbdujJGk33GZsanZZJV/o6+ecawY=;
 b=EEsga43171vcfuJULTN7syJwAyaFChng3m3D3xiMkGNKu76XqMQ7aBHMIrSxURRIyZYbmWsZ1Pwr91UBWVqCc1v2aloiOIPZpI7nh93z2q0xIVchGi0ZA+SlUcQVJaZOJnT2nA6lPZO0fNfHijdPHAxgqwZTBtW9G6S05ReOMsPGaY3ygS2GVBb8LVsSyC7lT3jc5vJ40l9qcUKdhX9DZMOBNB+QVNmzMmuyeYRqkhAp8aTSJnGkz4Ez3VOWUwbydgI+bJCP/s67o1VkLVm/pq/ZxHtVwGwu4BX2AGOazZmP3+UhtjfzlDarbY/tKi/Yi+Dk4fPormalJgUYqOTmlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by DS7PR11MB7952.namprd11.prod.outlook.com (2603:10b6:8:eb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.22; Mon, 11 May 2026 22:53:33 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989%3]) with mapi id 15.20.9891.021; Mon, 11 May 2026
 22:53:33 +0000
Message-ID: <e0f70732-3ceb-4d4d-8ffd-4f2761922e3d@intel.com>
Date: Mon, 11 May 2026 15:53:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260508182143.14592-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:303:2a::13) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|DS7PR11MB7952:EE_
X-MS-Office365-Filtering-Correlation-Id: d2006247-a2bb-46f8-3a10-08deafb020cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003|11063799003;
X-Microsoft-Antispam-Message-Info: 6ZpyW9X8Dpb6Upa6rbhvUGouO3bejsDICn8PBhV11cuxktArY9hySXUGTiZo/WXZXc0azYk4MPLdTOBiFNBMtHyAuc3dZ2TI5rhtCFK/Ou1Inr3fh5GNfqVyF5hbTQS4CSM1Ko4+/3OQ+0aar2Wzg3kvg7anzO6xfBK9exou8++HewpOkguNc3EMR1Y2C9bE/F4Iq/dpYl15XFhsMF24YflUGc0c04tBtLy5zydGMgXsHRrOc2PZZwZdeMNx8f6VYpSitm7GbsvNKpOrmIWXDURqrRlnn46Amh+cUXLHS7GJj8xgjbjWllQGdY82yGaTePm/hwO2TA21tlyMqLcd4SyU/vCLrNaoNyvm5ZeWJ5JpF4DM/+ZL4EWdoOkjNn4bc9NTAyyeHPAHPtBzBPd6oPLNxPbGAmnfV+5aIFFzxu5l+dszedVLdDHfxt6DLADB454ucVXSpXrJCKbME30qvOPn3mJQ8b9gOH0ytDATl21iueESBE4tK9p+6aP8ec8irj7jw4qr3ej8QMEGSHX/5CR4g4H1kvohs4SR2kwEZhAvQdM2jt+Ruyl7mVsYXqLPeHA+M+n4iwv9dquTS2iq2YFlnbFHgOzeFmmw3eMXsLLTlXa77UMdLZWLKP8zCOLs1QapJcx3dEbeQBUXFSzpbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uy9mRjdqVXBtMVNCZmRCZlJwRDhnaHN1d215cTUzS00zNHh4Sm4wVlNVdzNV?=
 =?utf-8?B?RG5SQ2ttSlpyUkRwWWZWNWQwaEs3ZitOQ3l6NXV2a0xTN0JManIrck5aUjBT?=
 =?utf-8?B?eWdDZ1g2ZFNlMkdTUTMzK2xyVzRQM0NhWDMvQ1R5Z0ZOVG9RTURUdWdlZG1y?=
 =?utf-8?B?QlZOZkxkdkVKeTZoczlOQnNidVJMTklLNkR6UHl0cEVqejJvYjJ1TzFzb2Vo?=
 =?utf-8?B?L1RVeXpIS0lWOHN1THRwSFg1QWFrTDVoblg1TEFkMGJpK1lEUTlIazlYTFUy?=
 =?utf-8?B?TjczVGZsT2RFQUppTXNPbElQUkVEN3ZXVy9SNEJsb0lHYnhKTldOMWFteTh4?=
 =?utf-8?B?dlQrc2h6ZFp5WHpXdTlway9EclFhekMxNW9ZVEQ5RmNTMkFtRFI4OG93S3dF?=
 =?utf-8?B?ZlRUajNYaGlzN3pBb1NnRU5jdWwzUjZ2MmxiWk5vcjUyWmNlRE01eW5xb0JN?=
 =?utf-8?B?ZjJ1UXBTWVFGNkdRcE03MXo5L3FzSkdzOHZQYUQwTkY3R2xXVTVhcmtDRUs3?=
 =?utf-8?B?ZE9SY01KQXpHVVJOb25ZK3EvSVRoMlF4RFlEWWNBYnhMNVJpOCtmaC82YWVE?=
 =?utf-8?B?dW5peWFtdDJlbnFSWldsakFtRm5mcmxTMVhzR2YvQllVR3BZSklma2ZGaFhr?=
 =?utf-8?B?SU9RSVZHMVBBaHFzZHJoeXFYRVFlZ2xRc3R4a3FvcHY3TjFZRWs5Ryt5L2d2?=
 =?utf-8?B?d0Exa3k1U2hDKzByZHdaMGJWRUlYdXZ1V0pOQkFZYXArcExEUkNGNE1LeWlz?=
 =?utf-8?B?THdncW5rbEtSZ3p4d1p6UU8zdUNLdjR5MjMzYVJVY0VmSU45VXBraCtWUDFD?=
 =?utf-8?B?Rjdmd3VmUGV2cTBxMHl1UXJOY05ObmpDc21BZlQxaHVYdWpyaW1QeTBJc3ZL?=
 =?utf-8?B?bDZ3elhCdFhVZWVMUDVxTXQ1d0NhcWQwbWhrdC9aeEVBdWpBUkJTUWF4VU1q?=
 =?utf-8?B?anNGam80cGpzZEJKWk0rRjM3VzNhRzZFeXVmcktSa2pCRngzbFliWFBrOXhC?=
 =?utf-8?B?WHlNbmxwakdRelQ5VkxDeHlQRGNEQTBJaWMveHpvRGVLeEFycHJRQmpCcmw4?=
 =?utf-8?B?TUtQK0VOZEVOUTMrK211VzhGeDZlbFBTUmgyUnFkWUxycmpKMUtDWjM4emhi?=
 =?utf-8?B?R1M5M1BqcFRSbmlqdTNoQlJJdVFzOU9td1YxZVMxaCtHcDMydndRYjVFQitL?=
 =?utf-8?B?SEJXRHRRcWVGK3JIdnU3V0dqbWRnWlN3QkRST2sxejRmSGExWTRyaTRwbFRj?=
 =?utf-8?B?SVdhZ2MwMlZEdXpCNlRtR1JGRkxxc0JwMVhKTlBUdURKdGV4TSt6TkxrTElL?=
 =?utf-8?B?UWVNWThkRW4xUzVyOXRkNmlMN05JbzB4a3hSZUJjamg1bjVMM3kyc3BlOTNJ?=
 =?utf-8?B?UW9Qb2N3QlZjemdTUjFWRWpJSzNSSHhzOEhqc0xGVEUyV3U2dlIwL0MyQ09L?=
 =?utf-8?B?TkoxRFQ3OStZMU1KRkptbXVKUllaOUQ1S2RvSVM2Qk5XSytCRElrV2hQWXF4?=
 =?utf-8?B?em5tTEVzNlVsSWNzdkF5TnA4c0tHTkNZNHdlL0o4WGl6L0dvOUQ0cjJNNDFB?=
 =?utf-8?B?L1VoVXVzNEd3WEVTYXJkYUdQUlNLWGhrWUlHd3BhRk84UmdKaWNPU3V0VXdk?=
 =?utf-8?B?QmpTU0RXUmh1a3JVemVUQzYrM3pkM3ZiOURuanVhZ29LWEo4V2NibnR6cldN?=
 =?utf-8?B?WEdsN3AwN3liR0xTbWhPMlFycTZUUFU2a1g4UWRXeTcwZGM5RlNVS0Nnc1g1?=
 =?utf-8?B?dlFlR1JIT3J4S3FNdGY5VWthQ2lxMjBydXYzSm9BWldqT1ZEVjl6Y0xTZE5m?=
 =?utf-8?B?dzJrYVJxM0RvZmpvQ1ZPbEFXV2RtRDcrc1YrWmlKYTJvMW14SEpPa2ZCQXpK?=
 =?utf-8?B?VnBpNEU1S3hQWm9FTVFuNVZCMkhOanAyUGtLbjNtblhsWGxiWFRhdjhRbWJx?=
 =?utf-8?B?cjJwdFhNWHRwakJNSzIrZHQ0d1FBaGZ1bEhRSDFhYTJsNXQweEo3cDgvR2JG?=
 =?utf-8?B?ZlNodzEvTVJlc3RoN1BJYTRXbWlJbGhreEV6US9wZEYyaDF0Q2U1TVFNbEdr?=
 =?utf-8?B?Z3c4OWQvNmhkUEFwMjBCdUVrMFZJNzdXQzhnZmJZYjVrQ1pMMG9ucWJkTUV6?=
 =?utf-8?B?YjVYK0ZpQUNYNDZ0YlJRRDJiQVBXckJxU09yS1N3Tnk3eGZSbjdWQmQyd3RL?=
 =?utf-8?B?V1NIVGFUTlpmalM0K05PL0lxSU9WNTlxbzVCQklES1BYTk5RREJhT2tua01G?=
 =?utf-8?B?WUxqL3haS3pPNmlka2J1WFBtMXZCQnE0dWpjcTRJYngzcTNrd2M2dk1ZVi9s?=
 =?utf-8?B?bXJDcjVLNHNqTWVvZVdIZGhsbFZYWFdBc3dVUkltdXJvcldLVTRwN1hYR2JJ?=
 =?utf-8?Q?x5v0ceFCcRqhgjfA=3D?=
X-Exchange-RoutingPolicyChecked: QYuOCLt3ItS5A8rctMU3g2o8Q2YCP4ANamuUb/+DqMmzYeBDdyLGrNBO6XvAKy2fhVPrLAXvLNjgGNOZyLSx3PP1hLVdPAwNsrGaRW5ITDDxZabnqQLjd25kneQhyMypsDKwgoMWskvtqmM21LIVMNFuFk9QRv3TVnGXKhkwrRWyEV3PFfsdJ5jRqy+jabRdJWfFXKBPA2n0Smxtx/xpcAiI8RDdcgvyd1Su4xaajrIoqTsHguLoFu+U2s+Q7ndduHBn8ZVRnYIOy7N//yBP1UBqKPzrDjUpsyAkOpCGgKgZdKYoDNSY5hdkfLOUApgDxJMJTkwHmzOrm7Ms0Tf9OQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d2006247-a2bb-46f8-3a10-08deafb020cc
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 22:53:33.4299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7I+EO0Acb5TZN4CORoQ3KnJxOIh7nkX0pxItHOaGJtdiGfvNoyp3RlI1aNeKbbKWxTEHaI7hgErirYoEUHB3Q8ey9UPT59/crq0uQP3mfXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7952
X-OriginatorOrg: intel.com

Hi Tony,

On 5/8/26 11:21 AM, Tony Luck wrote:
> @@ -3173,26 +3200,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
>  
>  static void rdt_kill_sb(struct super_block *sb)
>  {
> -	struct rdt_resource *r;
> -
> -	cpus_read_lock();
> -	mutex_lock(&rdtgroup_mutex);
> -
> -	rdt_disable_ctx();
> -
> -	/* Put everything back to default values. */
> -	for_each_alloc_capable_rdt_resource(r)
> -		resctrl_arch_reset_all_ctrls(r);
> -
> -	resctrl_fs_teardown();
> -	if (resctrl_arch_alloc_capable())
> -		resctrl_arch_disable_alloc();
> -	if (resctrl_arch_mon_capable())
> -		resctrl_arch_disable_mon();
> -	resctrl_mounted = false;
> +	resctrl_unmount();
>  	kernfs_kill_sb(sb);
> -	mutex_unlock(&rdtgroup_mutex);
> -	cpus_read_unlock();
>  }
>  
>  static struct file_system_type rdt_fs_type = {

sashiko reports [1] that this fix unmasks a use-after-free. This new issue looks to be
legitimate. I am not comfortable with sashiko's proposed fix since it flips the current
teardown ordering that is based on kernfs guidance per kernfs_kill_sb() function comments:
	* This can be used directly for file_system_type->kill_sb().  If a kernfs      
	* user needs extra cleanup, it can implement its own kill_sb() and call        
	* this function at the end.
	
Something else to also consider is how interference from resctrl_exit() may occur now
that its caller has been merged. What do you instead think of something like below? The
main idea is that it takes an extra reference to the root kn before calling 
kernfs_get_tree(), which it releases upon return. I find such a symmetric solution
relying on reference counts instead of code ordering easier to reason about and by
taking the extra reference with rdtgroup_mutex held it can handle interference from
resctrl_exit(). What do you think?

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 1ec7ff0389d2..4c4f98ebf4a9 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3035,6 +3035,7 @@ static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 	unsigned long flags = RFTYPE_CTRL_BASE;
+	struct kernfs_node *rdt_root_kn;
 	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
 	int ret;
@@ -3119,6 +3120,19 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
+	rdt_root_kn = rdtgroup_default.kn;
+	/*
+	 * Keep root kn alive across kernfs_get_tree(). If kernfs_get_tree()
+	 * fails after superblock is created (ctx->kfc.new_sb_created is true)
+	 * kernfs_get_tree() will call rdt_kill_sb() itself.
+	 * rdt_kill_sb()->resctrl_unmount()->kernfs_destroy_root() is followed
+	 * by kernfs_kill_sb() that still needs to dereference root kn
+	 * after kernfs_destroy_root().
+	 *
+	 * Obtain reference with locks held to protect against interference
+	 * from resctrl_exit().
+	*/
+	kernfs_get(rdt_root_kn);
 	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
@@ -3130,6 +3144,7 @@ static int rdt_get_tree(struct fs_context *fc)
 	 */
 	if (!ctx->kfc.new_sb_created)
 		resctrl_unmount();
+	kernfs_put(rdt_root_kn);
 	return ret;
 
 out_mondata:

Reinette

[1] https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=3

