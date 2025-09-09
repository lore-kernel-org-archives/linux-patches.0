Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A42221F15
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 21:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453037; cv=fail; b=NnizfKdJfaAQd0MFjdu3rMX7oA7pg0ITGKoIf+sx2Yj9Sbx+i2iXWjhsp1tXL+fDuX7kUlS8AMQ6TaatyYrIkXjGD3XHlMsgLMzbTxzQSWMW571iA2jkIMSBpZxlfVH/XkGfihw7kz2p3jiXMOkPCqyXGrCcn3MfpgaSGsjKlpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453037; c=relaxed/simple;
	bh=mfhcTPguna/OgTqEV3IJv1afzOUqjcWjROa4/qAzH7Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GYw0v6FmhC8c+IDfBk/ceossR4ktSJp691SzLuIjTPD2SodHrJ0Yh3B2f5yCZtx5SzVE3zxnhzsc+Cw7NOVSRegWUNiocQUjCbVNaA4MlD4cnXocI2c4EEkezndUV1Qb6oueuRtH6H7w5wOaZb/wbGLSqBGIaiDsIoJsFva2TzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WMGyhMJu; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WMGyhMJu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757453036; x=1788989036;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mfhcTPguna/OgTqEV3IJv1afzOUqjcWjROa4/qAzH7Q=;
  b=WMGyhMJuA/lzlVs0sot8yobp3Azepjilb9Ot/44SSwkRhLIKXVaJ2eug
   rinST/JEwYrP7ezyk7LwiN9X/iEy9EkijVCvCK4pL5dButwS1MCf2AOn9
   WJL6t4ETlx+m/hqn/AixDvaRcJzOj5IMTSmgz1osfKLim4AE3w02u5WQQ
   vvohhT2XOVfxNHybJl+BDtgJtAhOKExXTEQqaiESa0FhbS5g8x+e4jlwe
   6GqiaHbbKrhFITCc8OZrv7Fj81h3emj9JpVdl/H80k1H/fU9IjXz/BFAr
   OaB/xNnP1V2wUFcI1N12pu2roz1n7fvD9sAU+nBZWdL/sPASf8xxD1116
   Q==;
X-CSE-ConnectionGUID: 9jsMixZ6R9CF7Jh/Q0IW9w==
X-CSE-MsgGUID: ccf5jVSXRmqQPzFgkniSbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63583979"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63583979"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:23:55 -0700
X-CSE-ConnectionGUID: u0lXMiGcSsOmP4vnu8niCQ==
X-CSE-MsgGUID: zH8W41oNRRWjLgiEesV5BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172773731"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:23:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:23:54 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 14:23:54 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.71)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:23:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=po4cH8nWDIcI7hiVxqizB+5jxCWP8svJoMAFQ6U5Jdk6K/fbZuKA40A1+o1768xWvhKduZtxh2cVabtF4EmidmbR4yLiBw+vTWJb87TSlIH8aMx+NLSZ6V6zDb07UGs1GJCi6vPzIDL5Pq33iibMzTPhqr3L0SEIIBxqvfBLMLpFOh3DwlhF/5xKLwX7rKb9xT4ldC3wDcxSPRUVyaKd0eNSfJVL2AWZ2InVMSZ5+4VZSVkWckP+NlDIWWvcpMCNUTVfNvZdJXEl67skeZR/41UgPpxfoteM4stc4YMqLpmlIrePlUygByYjNld8qtXzXhgFXx7R53JpulEX+xbvmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ty+OoIhkM3zLHbPRibrlIEDuZhdsR1gVy6agrga7zU=;
 b=QyJNuZdHXdW/h1Wm+Fao9QCCpGf84MqrhTSLTN51Pb6be8X6TGMGCSt4Z/5S739FEHN3QPcoiCb9pfnOSEB/bNGtpON2yIRAosz0cU+6A54aSmo5uhgmUjwlkfdGVdmbNVp6oRVLVw8C1y6YwWqmO/WBVd2IoUZGWzvErhNMq3YwUApzDTFmHwOsqbGW+p7H2bDAPg7yXKwceV+zeIDza3rn4K6OxyFSTB7Nx6OVPkqHuSi5KPAZ8Q4gsCYaW4ILLXpviw01SCNN/mCDBQ9BHR2RQZ8tV5ODOzuTEZSJgd33HZWWRmn6N4oJOSWjy918DLKyLH65ShQqg/FVi3pyJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB9136.namprd11.prod.outlook.com (2603:10b6:208:574::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.33; Tue, 9 Sep
 2025 21:23:52 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:23:52 +0000
Message-ID: <40461810-95e8-4efa-bff4-540ef01051f4@intel.com>
Date: Tue, 9 Sep 2025 14:23:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/31] x86,fs/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:303:b4::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB9136:EE_
X-MS-Office365-Filtering-Correlation-Id: de8de257-b4e1-48f5-c98c-08ddefe72c96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZDFPTDMrQkF3Vm02bnQySVE1c2F3OS9CNGE4WDlJRE4xbzBvaVZTOUx4V0JZ?=
 =?utf-8?B?ZzVXVXpudTVtQXkyR3BWNjJsM0JtWVlPSkkwTm5ySmRYclpzYkEzMEliS1lE?=
 =?utf-8?B?dDdsN0xtek15d1p2TDN2OWpIRDNkaFFoclc4TUJnSXpLaHFkU29oK094RGg5?=
 =?utf-8?B?RkpmZTh6K2dEY0J1ejRmMHp0U2xKb0F4MnphMXdkMXVnUXVzcnpGb3k0OFZO?=
 =?utf-8?B?YW5oV09vc1hrc01FTnVldmsza2cxTXdSQ1dCSXdWaCtiWldoZ0Z3TTBLeG56?=
 =?utf-8?B?V00vRjFBSmx1Vkx2dEVrTkRESk5qMU9vbnJpMkJYaHlYNEpMVUhoSVY1amF5?=
 =?utf-8?B?Vm9vQ1JpUnNYbk52THNyS1BJOU9MKzhHcldZODdqVXB1V29hQnJVbjJKZ3Rj?=
 =?utf-8?B?YXM2KzlMZ0diSGRtZ0lQZ3k2KytxaDRPL1BWcWtNNHNGa0IzTW5Mdk5jYllD?=
 =?utf-8?B?djBlR3BKclFUYmEyNSsrUVVWMDRuUktQQjZ0UDY3OXl1M2xMR2U3ak1BMVF0?=
 =?utf-8?B?a0xpZTdDMEZWNmY4ZjZ1SmNwVHRxTElpUW1Dd0IwamNHa2pVSUVweG5rcW9t?=
 =?utf-8?B?R3R5a3BGS1JTRXZ4RkhkYjU1NlJodFRWSE1JYTJGT0YxWjhHd1RxWE9nZ3Rz?=
 =?utf-8?B?UzR1Y0NVSk9SMEU5Zm43c2ZEQk1oVjJRZUJmLzRiN2pIMXBHU09acVJZY3VD?=
 =?utf-8?B?SVlwSXY1djhxYmRVZCtCZG04N0VpV0lFaGNKZFF6eHRwbCs1bXVNaGxaMXE3?=
 =?utf-8?B?N24yQjJqZ05mRElUTWg0MEMyYytkbzQxazNqUFRvN3ZrcDF3MlFsdUVOalla?=
 =?utf-8?B?T1lzdTFjUTlST29LRFFsNy9YTTBrd2JCZ0lxZGFYL1NFOHZKU05FYmFHUjFG?=
 =?utf-8?B?QmlCemVFcHlqU25UQ2xQV1NlbWhjTnVMamp5R095Q3F3WEQxWFAyZHhWeDls?=
 =?utf-8?B?a09lLzgwNkF2eUE4V2U3bWp6aTVoUkEvblNMdTkvU3AyVWRKSEVLL0tTVElt?=
 =?utf-8?B?Y0JPTWpzL085OEd6dEhJVzhSOVNNNHNKVytxN2N3R3VBYmJsRmMzTVVranVW?=
 =?utf-8?B?MkxieFRna2VFVlZGRlNVTURTZmkzaHlnOXlLLzZJM3JnNXJrU2Y1a09rK3Qr?=
 =?utf-8?B?eTJXVTFFT1lRWmJhb2NvT3JiWDFmM1ZZamUwQjFYdEh2aU84T1QxR2N3eThn?=
 =?utf-8?B?cktOamJ6UE9SRHN3a0tRQWE1OC9nd0laZ3N1Tm5TdWN4WEFRUXRMRUVzaURS?=
 =?utf-8?B?ZVdGYy9HVWRrU2txenAyL0lLODRDMlZmQ0JDN1hzQXlUWjcyNGlNZUdPWVh1?=
 =?utf-8?B?d0RScjFVbjlZdS9IeEtWcWFWT1k0VFR1MkhaSnlCd2R2NXh0L2JUajJZK0w5?=
 =?utf-8?B?VGJPSC80TEQ1aVdKVWk3L2JKekI4Tk1Jby9yVzZwNktibXdFU0p4OVNhQkdM?=
 =?utf-8?B?VVpDREFTQnVzSjU0aVBiU2h3bEFOdHRZZTIva05UZFV1bEVVMFovQTNYV1lE?=
 =?utf-8?B?aS83eGdORFdURDRRbTJkcFJFN0lYeUQvYmx1RjFIWjFWUVNJYXc5TGFkQ3B5?=
 =?utf-8?B?dm5tTi9Ob2NKTEIvd1R2ekN0Njd5eDJqcTFxaEJPRFByNjlvOU9UejlkM1c4?=
 =?utf-8?B?S2JjN2ZvSURneHBUc1VwWldYMmN1cWhlME95U2dRZWdDeThBbEpzRE9SdFQx?=
 =?utf-8?B?Sm1yT0NNWUlyaWU5MVVTNk9WclZmVmhnbkxYTDRwVzJ6b2tyWERHOGxPTE9U?=
 =?utf-8?B?eEV6bkQzZ1E1RS90Q1A2QnNGRmVsa05Ib3NQKzdMUEwvdUo1UVFXNHhmZDV4?=
 =?utf-8?B?ZDkwN1VySER6MXJYT3A1NElaZ2hBVmtTS1FjRjNPVW5ETmVncHovTHpjVUR6?=
 =?utf-8?B?NXc1UjdGQTVsaDEvbGV3T3ZrOWpJeEh0N0NQMTVtUDBTSnBWRGlZd0QrM3Ns?=
 =?utf-8?Q?WdXbQsqIi6U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUtDcEFsT2hIenhsOVUweElVWEJxS0ozRUM4dlNtME5NYVBlNWFPRzgyOVJs?=
 =?utf-8?B?RTVkQURDY0VSR1RFT1hzSTB5b1JNakJ2ZUFtdldqakFidjRGSmZ0alZRVVpj?=
 =?utf-8?B?TWdGcHZLZ0ZFSFB0djRaSFNzS3lvZHpKSHUyMTM4bGRtYnIza2lDMG5SMkp2?=
 =?utf-8?B?RVRkR1htSHEvRHV0bEV3QVlRMlpkb2d6ZGpML3Rmdlp5UUFGaldhVERRQzJz?=
 =?utf-8?B?TVdza2Z5STVCLzlTaWI1eUl1U1VVdkxjeXVvNWZOaXZxemJUV3hlZDFBSnFV?=
 =?utf-8?B?dER6UVdaWEJ5cmJQaGp5SDM2cEt4NndObExiY00wbnZGR1BGUkh5UHhZcXNN?=
 =?utf-8?B?TUZ5OGxodGZsM09kQXlhUG5hWVhFdjg5VURHYlIwbGRKbzJkanh0QXh0YmVE?=
 =?utf-8?B?MUUwMWhObW0vVVhtWmlSWEVNRnEwRjc5Nmw3UU5pSFpPa244eXVOWXBKV1R2?=
 =?utf-8?B?RUxWR3BCa09hY09RTFVPWmJDSmVQRHp4N0hTekNEZkpwaHk1YkVrMnJGVkVL?=
 =?utf-8?B?Q2d3UXIveGhNUzVQNDM2YjZ4aFlHTDRHT2E5K3ZWREY3QlVmUXg4eFQ4NVQx?=
 =?utf-8?B?K2pSdzlVYUUyaHZsdlBNalhtN2E1VmpwVUwvaEt1NzBjZTlhUkF1cHB6MVRn?=
 =?utf-8?B?ZkVVajV2Z0NUSUk2YjRvTGtOekhUeEptMWpRc2xBNG5SQWxJMDY5U2xVclRF?=
 =?utf-8?B?ckNPbldnNDlNdVU2TmFiTjQ0bTNtTnVUR2pnVk05b0VERlRvNkVBU0t1blpN?=
 =?utf-8?B?SHMySWVQZzBsNWRvcnd6L0NWSEw2UGVvMU85VWF1QXkwaWRqMGw0Q1g5TGZI?=
 =?utf-8?B?eklzY0VtVDZVenhMOVJrYy82OE8vSlFubzN3bmFhRGZKVTF3cHNsMXVGWWxG?=
 =?utf-8?B?MkhnZENKMC9ZL09aNUp6Wit1S1dGL2JsWXNyeFB0YkhKQUw5WUF0aUd4Rlhv?=
 =?utf-8?B?cmp2aTFJUGZLc2l1OCtrWGpJZ1U2TldXTWFBMGFIT1FOdGlMSmd2TlA1L05p?=
 =?utf-8?B?VExOMjZER05GOTFMSlNlR2toak9YTEdFZkJiMDdWSzJQVkxiaHA2YnJsc2tv?=
 =?utf-8?B?TGcyMG5vekliWkJESlpDenVDU1o3KzdSRjJaRnlDVW1JRDJLS05aQjAzZXFr?=
 =?utf-8?B?OHkyME1IY1Yvc2E0dTJPaFpIZWhMN1FSY1BzV0JnbW82bjc5d2h2blloSmVF?=
 =?utf-8?B?S0hEQyt2OTVuUzV1NkEwejFnTllKbTZtN3lZZEZTUGxWc3Q5NGpYeWwzOG1Y?=
 =?utf-8?B?eVJDVXlkRFFyTStyRjdYZ1BCZkNUTHZKdjUxVlFxWlR6MU9WeXFwWmlWb1da?=
 =?utf-8?B?WjBiNitOMGxnc08xVmJZNzFuWGJaSmNnV1BaUGFzeG9sSWtMWFNCOVlHNjlZ?=
 =?utf-8?B?YnlqdnVETjV1ODIrbjhBR0hLY0hEcWFPVWJzV29rMXpwQ056Y0hwdFE0SEhS?=
 =?utf-8?B?cXF4ZmpxZmJRQm1KNHExVlY2Y1J2ejdkdHEwdWJuSWwraGVFN3prQTR4UmZq?=
 =?utf-8?B?R0JvNDZIWnVmYmJiY2lNc2tkeEFXS1hKRUlUa0toYlQ3SFRUWFQvQ2p2YXpP?=
 =?utf-8?B?eUpJVDBYaVdEK243eHVXTmtKODl4RHRjVTJKcTlrZmVlN01jYkRtR293YTU0?=
 =?utf-8?B?YzByckx5cmY5TkMxUENWUWJlQzU5di9DSGRCV0hkdng2cGNlVTJXT0hiVlZz?=
 =?utf-8?B?VUdCZStnSUk4dTA3dkZHY09lVjBzUUpXdjVNT0VIVFhtV3JWa0o1OG9LMzJ5?=
 =?utf-8?B?U1l5RWZ1a20xWWpCc25mMHE0K2V1YzlOQTVDcklPTTNKUEgwbVZzRlJCN3BC?=
 =?utf-8?B?VW0wSnlXMmg5Sy8xb0l1Z0N3ckV0bW4vZEZ0WFJaMW10dUR3UkJsdG0vSThZ?=
 =?utf-8?B?ZU9mWVNMNFEyNi9Va3gxb3dZbGlHc3dKbHBUOVV2NFhBYzNDeGRPdExrblIr?=
 =?utf-8?B?SVBaajlNZzBiWGtnSCszYTZwQysyZFhJUlk4R0hhYVFWcDA5b0JpN3hEN3NF?=
 =?utf-8?B?MEEvLy9YWWUyTGhTUHAyT1orb2hLR2JNR0JEelp3TURvakhhRGJTYkw3VkRh?=
 =?utf-8?B?SUU2VDlaY0d6ZS9EYzRhd0REcVNzNTFIMWlIYVdYalN2ODhoRy9GRUlVMVpO?=
 =?utf-8?B?cUVZTnl2Nkd3TVBmRHpUVFpNQWlCL0dSZ0EycVgxeXpSQ2Y1RlF0c0ZWZUJ2?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de8de257-b4e1-48f5-c98c-08ddefe72c96
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:23:52.2962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUXuL5WgC4MHInrJL4CKYZ1MMLYH8EkVk158gU3vIjBLPvBPIZbYOhswC3/xp3AkeZvO9CWFS1fmyGtGE9xlmdITkZvfvZ+0JLsrdHOpXNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9136
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> All monitoring events are associated with the L3 resource.
> 
> The RDT_RESOURCE_L3 resource carries a lot of state in the domain
> structures which needs to be dealt with when a domain is taken offline
> by removing the last CPU in the domain.
> 
> New telemetry events will be associated with a new package scoped
> resource with new domain structures.
> 
> Refactor domain_remove_cpu_mon() so all the L3 processing is separate
> from general actions of clearing the CPU bit in the mask and removing
> sub-directories from the mon_data directory.
> 
> resctrl_offline_mon_domain() continues to remove domain specific
> directories and files from the "mon_data" directories, but skips the
> L3 resource specific cleanup when called for other resource types.

This part does not seem to be related to this change since up to here
this is all about refactoring L3 support while the final part starts to
add support for a new resource under the guise of "L3 refactoring".

The resctrl_offline_mon_domain() change looks more appropriate for
patch #9 "x86,fs/resctrl: Use struct rdt_domain_hdr instead of struct
rdt_mon_domain" where the change makes clear to which code only a
RDT_RESOURCE_L3 domain can belong and matches the change to
resctrl_online_mon_domain() in same patch. This is not ideal though
since even in patch #9 this seems to be PERF_PKG enabling code (in both
resctrl_online_mon_domain() and resctrl_offline_mon_domain()) added
under another guise of refactoring.

I think it could also be argued that the related changes (code flow changes to
support only files for PERF_PKG) to resctrl_online_mon_domain()
and resctrl_offline_mon_domain() belongs in patch 22 since only then is
support for PERF_PKG added and indeed is when it is explicit that
"Support the PERF_PKG resource in the CPU online/offline handlers."

Doing so will keep refactoring as-is ... it is just refactoring existing flow,
and then code flow changes come later when actual enabling is done.

Reinette

