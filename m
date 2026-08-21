Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23602E06E6
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 22:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350341; cv=fail; b=tyjEodM+T+n5p/efBGi1O98/vj0xqvoDN76uHHOthLeXo8gUkNka4kaRG4bg6y48sRUAbaCKNBzFNTZeRa6reN0qWEaoaDqdaUkrGN1jy3iEzm9aR/h3DGpCxcmlf7VFjaSDp8BjUE5UMXTaDVGSof1anxwu+OlV3QWpwCl2ebg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350341; c=relaxed/simple;
	bh=9SsZSlOMfgiZmPlkB3/uc6AG0iAnVQfA4aE2urBJTOg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GPZus9DLbKVU47a7C1b0n9fmMEKXXosCklgIYErM+1Yme6H+h+EzzpvHvuQr9uaXehCaWRJlNC+kaeBWk1WIqCr7tzOmNaS/ska5ORfJxQfMQjJ2dScEdMfc0bIP87d05vUXicJ2g/coYku9WnHueiWjXE9WjHso9ADAOF3VNmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMUaOYYO; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMUaOYYO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787350339; x=1818886339;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=9SsZSlOMfgiZmPlkB3/uc6AG0iAnVQfA4aE2urBJTOg=;
  b=gMUaOYYORiUqDiLiQU66I3uiUanc8fbQ4GbPtnlIqdbRHuzA9p/3fcjf
   4IBTKOikKMRNQmYln7aHwx8WUrA5WF5uNXgj6ytcNE/w/Vceuca/FyJx5
   VsBsc3V8wyCL7XsVp/v0mTvk15APc460RlA9qmTCcZ2sJb3d059Otg/d6
   mLXiE1GQTPLi4wA14/6krTMFZBeY8YNdmnT703XdavzwAA8QM8QvVP8C6
   tg1wV7EvdMx7b9QCp2RfPEvOWKgg0SSBMIT7HWm+A7K4+9CEPULJkCG1Q
   51l0geOKsLoiSdxsgenXNrwht0KFOCa2k+Mbfrzu7Vd0Q0cQmr5QnT3l1
   Q==;
X-CSE-ConnectionGUID: BGm90M74QPK9q1NR82PJJQ==
X-CSE-MsgGUID: AwNn900OQ6GXe8x1Tsr5AQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11882"; a="87919663"
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="87919663"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 15:12:19 -0700
X-CSE-ConnectionGUID: Kv1rHIFRRGKJG4I/zn/eMw==
X-CSE-MsgGUID: Wx+nZMSAQOCeg99QKYqIIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="289990560"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 15:12:19 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 15:12:18 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 21 Aug 2026 15:12:18 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.53) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 15:12:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fX5ix/fINUm+kxDDObsv0WA8mJR4LJKAG0W0B+GqtGueqKIbxsB6y/WobMjsVhUG1lzJV3x9H+gjcRvUbB7FOEXxwFiY7lpvaEfD0fTwRnKv0PvhZB6Xa1+VS1faDJu9LCTY6AI9BsPPUUljfNZK402cnZV2XXeVrGazPd3O8gi096sq0n9gmtu8YT/bhN9lrgx2VxfUXzoIr6USM4rlV1Nyi/ZbwyQIBuWkFs1wmq+fbpzHh/REM9WwOBJJCR85iTpaEMiIiTdlc3lbGfRkhbfyUMGZoI94O8yFZBAqivpvzJSWsZBGoGNSgqFsp3PTmv6Qbf95A1ukfJauKeaqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfVntMZ4lR75b0uOJMJfmBScD+bzrU2nZPwAg4Y5Veo=;
 b=B+jwSUto5eYwwoCpvrlmrxNMv2E2dSFovO/sICAhYGLhHOjo5y7KoKIy+hgaMeJYqHUgqyrCoPTvdH2wziSoYKKeqpGYR7nnX8mWsH1VSkGyw85z3bmmJPB4p7hLbFZ8rkU8eGwW4kgWyj0HrdeHaIMQQTLQWfILrk6/Zj2h77Imss+1tRcW+0GoyuI2gudJ4U3b41TKLQcHU9zWbXht5EmDnBEm/VGrrZSgauImi3+njUzEy/FUY/VClcwTng7IgWrpjdkl8nIB2CCVom1+i4QAK6KaFlyirX6cosGcc7B+89oin85pG+VxO86MBWWkBl6Hfroia3+Hmu+4kOzDig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CYYPR11MB8358.namprd11.prod.outlook.com (2603:10b6:930:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Fri, 21 Aug
 2026 22:12:13 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 22:12:13 +0000
Date: Fri, 21 Aug 2026 15:12:11 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [RFC PATCH 1/4] x86/resctrl: Check if monitoring features are
 enabled
Message-ID: <aojNO9aBBOUcTwX5@agluck-desk3>
References: <20260819161323.11587-1-tony.luck@intel.com>
 <20260819161323.11587-2-tony.luck@intel.com>
 <9787f9de-c72d-4c0d-b9a9-867b0f4377f5@intel.com>
 <aoiqiAEFJfCxhLVk@agluck-desk3>
 <c3cd54b2-8752-47b9-8864-8444254e8be8@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3cd54b2-8752-47b9-8864-8444254e8be8@intel.com>
X-ClientProxiedBy: SJ0PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CYYPR11MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aa34805-ddd8-4430-c7fe-08deffd1407e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|56012099006|10067099003|3023799007|6133799003|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: 16+mpqHMx/hMce6CCS3lpvwUCSROOp7dxoegHXaQtL0C9Aam575d9H2LN4zg7SqAs6KvYKXnLdJkPS/LHQPjfGTDbvLROw2VukEk7qJnZXBObEkuXjtAV/1GiOKELsdmIFmbJKZaN66VBQyEfCGjtYfsZRjRpdMRbc1IS7DqOYg/mj5P69xmaLLCHZt1u7vMALXVuVLSfHCaD7502pp/copI0/e0aU3KbI/NVewcu0M4K72j8UvwU7js/kjxIJkqr8LxCPpCIYhFY3taRS8LwPRClTaR0Rcw4+kd6V0L0P5T8Qqg43bmfEiDg5mC9S5RJ1XLLs0NRTYE5t/iYKSoz7ykkdnzj2AJwofpkMl/qcEpjcPT/sxelKr+hTk27XYZCqX4WnnKNZ7Wo86G+eizk18JW0XZlCdVGWYm7nYt+YIKxF5i9tp9S4vrPbn5CR6sXKPfO6bfp64fijUatVFa9Nr4t7plIfpfiR3fhSz7dfhquQyDpCrSfOfwu0vjw2An/BPhKwd3XdLpCe5+2htYPeeK68PXI8RPtEW7JeXI5HvmWlZUpfQe/wYr7X8DHQyWNpWsnl1S9mUL5uaUozlG17qFLNGVNJ6tgT6deKXP7U0Gs255ehkBxdwOrqNCEjy2MVzEat0pFbWsNOiVtA8Q/JhHbkNoKXnY0uZ0qM0y5Ro=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(56012099006)(10067099003)(3023799007)(6133799003)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U01yYXJUNjZMenNCWWlGZkxBcHlSYVk5b2FwaUNOelo5Z2hPb2w4U0JQeGVu?=
 =?utf-8?B?bm83dlMrM0lMMjdhRUJLUWJSMXJMbjZTVVhMeXl6K3ZGUFZobENXL2NFUTI1?=
 =?utf-8?B?TUI2YnVxKyt5dFM2WllNc1dFY3NHQkpDRXRPMytQSTRiZWNhTGVPRWI4a2pj?=
 =?utf-8?B?QkRKTlo3WE9CTldzMVA2ZEY0SmlFbzcxd3lvWE0wZnphTXl0dUVrcDFwT2xp?=
 =?utf-8?B?Q3ZaRUhRMzJ1bjZQY1I0MEZCRkt2OHc0Z3N4aWJjNFM3QkxPaTJZTHE5d0Jj?=
 =?utf-8?B?ODgyeCtUUDFBWmVaVGdHY3F1ZTZUUnNtL1IvekYwS09RT25pSVc1VElxT0xq?=
 =?utf-8?B?aUpSSFY3WXBSSkJvanJMY29SV21EYzNaejJjSVFFSE9waiszK1pyZDk0c01S?=
 =?utf-8?B?b0xkVlRGaS9aQVhyNjQwZlo0ZERrZXYrbVpmU0JVRlhpamdHbjc0ZWRHZWtG?=
 =?utf-8?B?bm5LUzBVTkcxRXFJbjhPNGorMzB6NW0zT1JNcmJDa2t6bUJLT3NmNDFhSm05?=
 =?utf-8?B?eUNCSkM5L2ZnRDJad1N5Szh1T0N3Y2QxdGs5bG00MWMzUkkrRjBDQWdSS0lm?=
 =?utf-8?B?TStoaitueXJIdzYrZXllVGRmZlp2TEVVcVZVMkowWUUxUURHSlY0MHBLbmpX?=
 =?utf-8?B?b0ZlY1Uxek9Nc2Z2emhWOHAybGM4SlpIME5JOEV4ZnNYZWZtemlXblhkTVNa?=
 =?utf-8?B?bisxYndhR09WcHRuS2NSb0lPSld3WkY0SjlzeG1qYldMejJrMjNaYU5TYUFW?=
 =?utf-8?B?RW1SMTRGS29ycjIxWlR6OWdxWWliTXJGOEJ4dWdmMkFybGcyQ2hhNGd5WWhh?=
 =?utf-8?B?RGxmRXRYc3BCRE1rVmZBT3YweW51aGEvamtYZjlqWUpBSXVYMml5SnhUenBQ?=
 =?utf-8?B?ZCtKN3dzVVJ2bm9jQkVlV0traFRNY3hOYTdPZW1nQWRvbmJQUFpFOGN0VjZo?=
 =?utf-8?B?R1pqRkNtMXJzTGNmZFVvQmQ5MlRlb2cxTThpbThzS1k1d1dUaEwzdmd0bTE5?=
 =?utf-8?B?MnRXOFMyV1dmSkVqRVRES2pkSTZjbThlNVZ0S1d1QWIwQzR3OGVSSm00a3gx?=
 =?utf-8?B?UlhjUTFZSFZ6cGlFcUtRaTRRSS8xNVptTUJOak9PN1hyeFlTTEthTFY4bC9I?=
 =?utf-8?B?eGg0Wk1ITitWb1RQWWhxTU5xbGJJVm1kNEVYVzl0aWtwbzQyNlRvVC9oYk9u?=
 =?utf-8?B?T2tsQzhmTzJQWnJKLyszRVdKVWtseDlQQnh0THZVR2FEQ0Y1RU1INVBpZVpt?=
 =?utf-8?B?UDB2MGpiSnBPdktHREZDajNSTVhleVJNNDhQRlVkVlU1Z0lVUnRpMmZkNXRn?=
 =?utf-8?B?MU9DbndRTFNYLzU5QWV0Z0VwRyttY1RFeU5PRC8wYm1wRlUxSm00YmpUWDFD?=
 =?utf-8?B?OEtCUDVDbFNjTmxDNElvdzhjNC9mM1BrWThsZTZ1bnNZczVuYmZMTG5DTG5F?=
 =?utf-8?B?L0ZmRE1EbGUwT3FJUmV2RzJNb0ZlMFFKRVBVVXVuajczUUIxNUVQb2svMklw?=
 =?utf-8?B?WDkxRzFhbUpVMTVzSjJ5d085QzRjekl4anU0WVV0eVJxVmZTQW4rc1ZNRTM0?=
 =?utf-8?B?cmpyaXdVS0ZKeEVqaGpteU9EM3hMK0Z5ZEIwdTNXUWVndE5Xa1FiTHUwNXVx?=
 =?utf-8?B?NHJpcmNhYi9TZHRsenJkQzF2RlIyeElDSVpvVHNGckdvSGJBL2NkZS9obE9n?=
 =?utf-8?B?WWVZRjdKeHRIZkR1YmFZSm1aeUcvaDV4Nlh2TTAyYVhLRzQ0Smd3YjkyUnd0?=
 =?utf-8?B?clI2ZkpLalZhMkZhU3phTG82VDZ6QUVEclIxVW1ZL3MybU5kOTl2TDZVaVVu?=
 =?utf-8?B?ZmlpTGdaTWFSWHdHVWIzL3dwVk15TUVXcFQrOHJtRkJPMnRWZFVFOUlKRzlP?=
 =?utf-8?B?QURtVHZaeUptN0pGMXYrM2NDbERRRGlqZWlSUkV6VzYycFhLQk9Mc0RWbk0w?=
 =?utf-8?B?eXp6UkNiaTZIMGdPbmZxUkJSUXNXN0IvL29seWFjZjN2RWg5RE1TUlRuQXZy?=
 =?utf-8?B?NVRtWXUvbGxBL1BrU0JwbWtuZkRLY0t1UDlIVmtnaHd0Z2djZTZMQVVSOEVy?=
 =?utf-8?B?UmZlTGs2YmZ6aHV1UFBIUmc5UGFSVWZseHgyY1Q3Ymo5Mm5UOE5HKzE2TUYv?=
 =?utf-8?B?S3p3TFNjTEJBcVp1L3RhTlJwK0ttbzFaS25ySDBWbnh2VjdYSkhCQm9SVkE3?=
 =?utf-8?B?eFZJNEk2OHZqc3B0dUh1OUo4bXA5ck5lSUdIM1pXODhYUTA0OVkwb3k0Ly9s?=
 =?utf-8?B?TEpRdjFFVGpSRTZJWXNFRTB6OU8zd0Q4QmlzQmJ3WGs4eVUwT21FTHRDV0RS?=
 =?utf-8?B?dlBLVXNjNHdBMWxFbXdaNEJXM1Q2Vm9iYXpwbThaaXFTcmtvZCtnZz09?=
X-Exchange-RoutingPolicyChecked: ozWrX6z700Ji9gkbknDGVi4vougVeCX4CMzhv/X6p1OgmlZtKYwqfEWag1r52613atGmCaBsH3DRzJRN2PiIwp8kNbMB8IvzZoG8rLBjTDnIZI2ALD3ttc2uMeEniZ/IQmeMAir+kGsJeFNB42uDK+DeFHX6h+ZkWEI7gbYEyzAfvXD1MZrdL0czN2N5uvEFoW62+uEJfD/Oz6xvz9DRMicD7g63kGA65J+ZFF/UADQmyKp/hbil1zqWOTLx0XEEAaTLx3e+rWe/b0TcritNeGJ4eU6nm9mBWx+sCF4tbZRkcn6K0RMJKL+X8wiR9GKMKr9kNTY5kX2XnH2SiXOlNg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa34805-ddd8-4430-c7fe-08deffd1407e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 22:12:13.1105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ib3Y1EIMq3YcY/EFJ8PIIbkr0cDvlPDeQhQFcjcB0bA+LzVjsONCQtV7HTYSqeE0uo5tDDso+35RizSYFps0Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8358
X-OriginatorOrg: intel.com

On Fri, Aug 21, 2026 at 02:00:41PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 8/21/26 12:44 PM, Luck, Tony wrote:
> > On Fri, Aug 21, 2026 at 11:18:51AM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> Thank you for doing this.
> >>
> >> On 8/19/26 9:13 AM, Tony Luck wrote:
> >>> Both Intel and AMD manuals say that software must first check
> >>> CPUID(0x7,0x0).EBX[12] to see if any monitoring features are enabled
> >>> before checking for specific features enabled in subleaves.
> >>>
> >>> Add the check for X86_FEATURE_CQM.
> >>>
> >>> Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> >>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>> ---
> >>>  arch/x86/kernel/cpu/resctrl/core.c | 3 +++
> >>>  1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> >>> index 55214d6fdc49..2677b8a6c15b 100644
> >>> --- a/arch/x86/kernel/cpu/resctrl/core.c
> >>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> >>> @@ -968,6 +968,9 @@ static __init bool get_rdt_mon_resources(void)
> >>>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> >>>  	bool ret = false;
> >>>  
> >>> +	if (!cpu_feature_enabled(X86_FEATURE_CQM))
> >>> +		return false;
> >>
> >> Is this missing a check of X86_FEATURE_CQM_LLC also?
> >>
> >> As I understand resctrl learns from X86_FEATURE_CQM whether the system supports
> >> resource monitoring in general. Contrary to what the feature name suggests, there is
> >> another step needed to determine which resource(s) support monitoring via
> >> CPUID(0xF,0x0).EDX where bit 1 indicates LLC monitoring that needs to be set before
> >> the LLC resource-specific monitoring properties can/should be determined.
> > 
> > Yes. Missing that check. I agree that the feature define names are bad.
> > 
> > To avoid continued confusion I should rename the #defines to match the
> > bit names in the Intel SDM (but leaving the /proc/cpuinfo visible
> > strings at "cqm" and "cqm_llc" as those are user ABI now).
> 
> Naming is as always complicated and here I do not see why the name should be
> picked from Intel SDM instead of AMD's spec. Renaming may be secondary goal. It may even
> add to confusion to have feature name mismatch what is exposed to user space? A change
> like this could perhaps be punted to when/if monitoring of a new resource needs to be
> supported?

Two reasons to pick the Intel SDM name:
1) Intel was here first
   commit cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
2) Symmetry with the feature bit for allocation:
   #define X86_FEATURE_RDT_A            ( 9*32+15) /* "rdt_a" Resource Director Technology Allocation */

Confusion between the string in /proc/cpuinfo and the X86_FEATURE define
is already rampant. Just a few examples:

#define X86_FEATURE_XMM                 ( 0*32+25) /* "sse" */
#define X86_FEATURE_XSTORE              ( 5*32+ 2) /* "rng" RNG present (xstore) */
#define X86_FEATURE_SVML                (15*32+ 2) /* "svm_lock" SVM locking MSR */
#define X86_FEATURE_TSCRATEMSR          (15*32+ 4) /* "tsc_scale" TSC scaling support */

So anyone wanting to find the #define that goes with a feature name in
/proc/cpuinfo would be advised to just grep for the string in
<asm/cpufeatures.h>

> 
> > 
> > X86_FEATURE_CQM -> X86_FEATURE_RDT_M
> > X86_FEATURE_CQM_LLC -> X86_FEATURE_L3_MON
> > 
> >>
> >> Apart from the checks here I see that cpuid_deps[] accurately reflects the relationship
> >> between X86_FEATURE_CQM_LLC and the different LLC monitoring features checked for below.
> >> I do not see cpuid_deps[] capturing the relationship between X86_FEATURE_CQM and
> >> X86_FEATURE_CQM_LLC though. Could adding it complete the handling of relationships between
> >> these leaves?
> > 
> > Yes.
> >>
> >> Similarly I think cpuid_deps[] may be missing X86_FEATURE_ABMC's dependency on 
> >> X86_FEATURE_CQM_LLC. 
> > 
> > Maybe no? X86_FEATURE_ABMC isn't enumerated in CPUID(0xF,*). It comes
> > from the AMD CPUID(0x80000020,0)EBX{5}
> > 
> > Babu: The AMD architecture programmer's manual just says:
> > 
> >   "Support for ABMC is identified by CPUID Fn8000_0020_EBX_x0[ABMC] (bit 5)
> >    being set. If ABMC is supported, the feature’s attributes and capabilities
> >    are enumerated by CPUID Fn8000_0020_x5 as detailed in Appendix E of APM volume 3"
> > 
> > It isn't explicitly stated whether this depends on CPUID Fn0000_000F_x0
> > EDX{1}, which AMD names: "L3CacheMon - L3 monitoring capability"
> 
> Even if the spec does not explicitly state this, the implementation requires this.
> 
> I believe patch 2/4 makes this clear since it demonstrates how resctrl obtains the general
> L3 monitoring properties from CPUID(0xF, 0x1) before moving to the ABMC feature specific
> properties.

Agreed.

> How these general L3 monitoring properties are required by ABMC can also be seen
> in the ABMC counter reading code:  resctrl_arch_cntr_read() calls get_corrected_val()
> that uses the general L3 monitoring properties hw_res->mbm_width and hw_res->mon_scale.
> ABMC feature properties also do not expose its own number of RMID supported, this is
> learned from general L3 monitoring properties.
> 
> One item of note here is just that ABMC (as I understand) does _not_ depend on any of
> the individual L3 monitoring features (X86_FEATURE_CQM_OCCUP_LLC, X86_FEATURE_CQM_MBM_TOTAL,
> and X86_FEATURE_CQM_MBM_LOCAL) since it defines its own transactions that can be counted.
> 
> Reinette

-Tony
