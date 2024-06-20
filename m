Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1373F7406D
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919331; cv=fail; b=Om0qf95LW/0vKH+wFXxK07GCW+y+xK/LKNQK7uzhIl+uEhzHsFXwaWqGI27uPwXkUhrbc8dl5ERV+QZBeRdTMeRxyLsaVFa5GpTJodnvm+Epa+6J2bx0N+WnK0OL5QOvVNY43TEuEUS0DoYmaTUsiAp+xuzSGOZC7+7/1+P5P7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919331; c=relaxed/simple;
	bh=CrERs4YaiZ0LZ6ZQfAZSumeIuZk2o1+0IZEtAkyLgJY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kc7KFZ5pWc3az6ljwtv/iQXGBvQ/JmGJtqgp8y6CqtGzr2r6ASY88THjP/+Zxuwxav6oL1WfNSswyykl+sGYPhVrkVkwcIuifueGIRcjRBUPU04MpkUhJ9sIcrzACYa2dJ0qy4tNp/B7k4gBtEG5CblopFvNs2GviCTItONS71o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IaBTCdhq; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IaBTCdhq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718919330; x=1750455330;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CrERs4YaiZ0LZ6ZQfAZSumeIuZk2o1+0IZEtAkyLgJY=;
  b=IaBTCdhq4o8FVEG+sDnmmepdl3LrniOKOPL04y6pdLTs48vfAuc6XIDd
   i3iuzDaYOSgDOjFWEy88gk8vWuCU/g21IqkyqtZbPB4yAe9Uck95RCly8
   lLrkW0wcR6P/r7X6FL5MgHgbeALqwijtIthQJk3iOs+WR8ZIF6S0cQ4CX
   +vaepH0Z2h8KXSxiaeEBBcI4z/Js6KXbfxRUURKl9YlKk1TpTZPDSzXuG
   WeujmRG8nlSxiOqhcFiin74nDsZHC9U6KFUmK4MFYHqlVni5cM9QcS0Gz
   KA5DUjtR7Aler7TR7x2XdWLkDmpXF+KU+x7bkamd0VG+OTRlw7eXdGUYC
   w==;
X-CSE-ConnectionGUID: 6DaLT2ooT/eEFrUuTdJaAQ==
X-CSE-MsgGUID: xaYA24hqRrefvWO41f8a4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16076620"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16076620"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:35:30 -0700
X-CSE-ConnectionGUID: eJLeTjhfTyOS9eYfXPz9Gw==
X-CSE-MsgGUID: oO8Sqw9ORFan/3yh5kfRcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42336973"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:35:29 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:35:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:35:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:35:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QggPmyWzgQGil0/cFeo4gCLDRZMRQQO7s1bW72NAeLYSJe4FV6d+2Gn8Gyy9GqsTbh9afLpBVFS3JQxnj2W9tVO+ySdM4KxQHSjmBLNVvKPFqS0wstiMh4ttg1ulSyt6wvqeMdlM8gLj2c7upb3gNKhzcUAxAKZOJU/8SeyHsdsS2rZENrm6HToK9uozYgmZMxCk9+RUu2gswqrO4SDb5rsm3hlM/lLw4beYqikrQGuIc3Ki4bwD2yG4v7Pd1uGFGMphBN/075oBfuJkebBoPJLiMQohqwqutVQ7827CmBOywOgVnqY81M7wVFqlI1CUUXyxbr0M71vNyE7uJrOeaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kI1Cg69cwA7j8L0f8yjb85nlWxWVHbEGF53jtlGgSXU=;
 b=hGJidLBD55GXyEL0odwIlwSOk2jXcYuyv4dSrbGELF4P91eiYZrru/GOalpk55Xj8QNC52iXiMJaEyZ8R2x4nCeaawIR+bBf5CylblHeePx7M9E4hqBliNCI1W/x/MEfEnaMQmLU7sYfEPWsuFUQaveEvEIrDJo2BjGnWsFPip8txXav7lmmRvT2177mA/hwwaOOPiayYQVEE+zhI9JfvYXF4K7ZdCR4zfSGDfWcoQqsApeTBJPstia/HLOp5YCUyK+jayGes80IA+SPMgHupIAxjEQjbMQI6k7wraXe78czeJEn7WrOatI2gMZdElrjM6nLjti02eNV4pU5AGiXyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7714.namprd11.prod.outlook.com (2603:10b6:a03:4fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 21:35:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:35:27 +0000
Message-ID: <694c09c2-c0f8-4583-bf82-873c40a307e4@intel.com>
Date: Thu, 20 Jun 2024 14:35:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 18/18] x86/resctrl: Update documentation with Sub-NUMA
 cluster changes
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-19-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240610183528.349198-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0090.namprd04.prod.outlook.com
 (2603:10b6:303:6b::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7714:EE_
X-MS-Office365-Filtering-Correlation-Id: f7482ce7-9804-4968-16e7-08dc9170e6be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZDEremtXRkE2dFZ0dWxlcHovaG9YUzFxNmJkRE5BYU1RdlJ0U3R6VG9xYVQv?=
 =?utf-8?B?bm5PUmVBcUZTbU5zbVVDNFpYWVlYdklJMHptNElVMHl0WUxIYXVOMDkzSjF5?=
 =?utf-8?B?NlpQSUd0SmZMdVZXVnFISytjaGI3NEVZcDBYc1BRVEo5UEE1c0ZXdGRIemNQ?=
 =?utf-8?B?QWp3dEdsbS9NNDdZbDFGRU0vVmZwbGJuYTg0bUpJcWhGcHBPRStyQmFvNGkx?=
 =?utf-8?B?bys1MC9JYlFsV1NTdXp3Um5pSDFOekZ0QWxLRjQzSjh1Nnl5K3NDZVNPWnBS?=
 =?utf-8?B?blMrUi95VFNIV1ZjNnV6U1R5U1AwalRGc1JaVlA1UTliL1c4MFBINDNkckt4?=
 =?utf-8?B?Unc0QWlLODMzTXhLUjkyRkU3UXRVSUgyYXFPeTlRbEJ6enBydVVYQXY1Q1Vl?=
 =?utf-8?B?YnpFUmJ1SHllbTFjdjBkcTNja1c0Z2hsSG9QYkNsa3Y3cW40azVGRi9qcG50?=
 =?utf-8?B?dEtZbG85aWY4NGEySU1nY3FDN3ZzbWlQZVVva0ppUHU2dVE5TWhkZkdvR0hV?=
 =?utf-8?B?VTQ3aHpZUkxxRk4vdUxHWGQ2d1piWU53ZjNwQ0x6U1pzUXF1NnJ3TzhLa1J3?=
 =?utf-8?B?T212Mis3NFdBbkpqdmZXYm8xclNNUlA5TkMwcy9wSHZ4Y3d1VzcwdkY4ZnRE?=
 =?utf-8?B?bWZMbk5KczhtRVJCbXlaWmJWWHl4UUllV1MvZWZxVzJDZVdMQk4yMklXQ0pI?=
 =?utf-8?B?UGp1TkJ2S1RSbTNVamU1ZmRBVmUzcG43NWRGaTdwWndWeFhkVTR0KzZDVjBU?=
 =?utf-8?B?TTZ0VzFGalB5L01Oc1FxcEw3ZmM0ZHNQTUhCQllDcGtWYVZuV2dQQ2t6Q0F4?=
 =?utf-8?B?WEpFQ3YzYW1LYWdCOWkxcFFUUDZkWUtreEEzb2FhRDQ0am94WkJ6ZWdoOU54?=
 =?utf-8?B?cmw3VzNOSmF3S01UeUJDV1hXaVN2dnF3Q1RsQ3lxM05TYWkyNEdoemVYVmxr?=
 =?utf-8?B?UWU4ME15ZzdxZk9ZQnBMclg2eEdpYjdsMDBicVoxZW9keUliSkRTZGordUNq?=
 =?utf-8?B?VlhwTzRZakNOQVJVQVo3c0d2ZERaWng1YzF6REFlTytRSkpWRWd3SUlETVQx?=
 =?utf-8?B?SjIyYjVEMElGYWlWbTcvZHVJTXJHSm83ckhaVzlVSlRBbXNHMnRWQ2QzWnh2?=
 =?utf-8?B?UmJXWnpibmRicU1PaFNKWWI2SU9FMDhSVnhxWmNjQThqSVRITjRPSlRQSlpi?=
 =?utf-8?B?YXhoSXh2TFNHemtIekpybjVsVGY4SzY3RGtmaUROOVNJTnVqTDdzUTlXMUFR?=
 =?utf-8?B?MnZpd3Z0eVJPZllKS3BWZVhuSnNFa0NsWDJtc0N1K3RseGtNcU14a1VYY1d2?=
 =?utf-8?B?SGUwc21pcHRPMnRmb29HSWFNaUJNWE1JVm5CcmxYSGJDSWJxb0tjUENQUGY5?=
 =?utf-8?B?Szg1YUVJL1dBc0ExMGhjaTJJOTQweUhTU2hrVFFDYVZlWmlXeGZ3aVRLem9r?=
 =?utf-8?B?cFY2YlpzZTJQczhkaDB5Y1hmNVhDYzFybk5JcjNDdjVSZUNYeW5Kd1g4OVJZ?=
 =?utf-8?B?NnN2VWZNV08vQjNqSjFpbDdoN2gzbFRCcURaaFZTQ0Y1Zlp2ZjNRb0htQ2dr?=
 =?utf-8?B?WW40NUIxV1hreDIramgvZ2E2d1VicXZXUVBaYnpmdlpYWGp1aGpqSU1NcUNj?=
 =?utf-8?B?RE9aa0N4aHliTmxhT3F0SDlvaVMyK2xDeXh3SUUwa1RYbDVNZzhQZys0OXVT?=
 =?utf-8?B?bUtvQ2N1aGdnbWVYdm0wZ0FiTjI2aCtUd2o3UFAwdFAraDVHaitLSi9FSTM0?=
 =?utf-8?Q?E7k5Phf9GajkoW1Q9HO29SRRSRCACoE5+CB05MV?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXJEeE1rUHhzUENjMmIrTEdKZk4zOW8rVEE5Q3d2cGcxbDNPNlhWaGpzVmJE?=
 =?utf-8?B?M1RQeEJjZkNvM0luY1ZYZXBPVlhzOTY0aTlWWkhFOUhyV3Q0UmtZUGdFai85?=
 =?utf-8?B?ZFdjS3hjZ3Z0WFNCOEdqM3pvT2xkVFl0RmlmNDRyT0FSNW1IR051ampkQjdt?=
 =?utf-8?B?THlRTjFPekxjdGdZRTAvTE44djExZWZ4MHhoMWsxYTY5OEpWeFBKR2VObHlt?=
 =?utf-8?B?Z1Y1cHZFYVRQSXU1TFlUYUdWNUNsVVdXaEJVdldVWTAzL1duOFBhY3YwUU5F?=
 =?utf-8?B?cTJIc2ZFMHpCbWFPZ2gxS3BCcFZXcFVNUFJVaEpZVnM4TWlTMTByVFhRSFRx?=
 =?utf-8?B?ZkpieDdFNVdJblZqWG1UNWROQXpsendLZUl5OHJ5MXI4eVNXOWxzUjFUUnBC?=
 =?utf-8?B?YnQydGplQXc0Q2RCV3dwMWo0dTZWcldxWDRrdFQ5SDh3YWpjbHBmOUIvQktk?=
 =?utf-8?B?OFlPTHVEZWlHNjJUcm9jV0wwWWVRUnZTSmZTUlY2OHlhUHl6ck5wK3hvbDEy?=
 =?utf-8?B?aDd1ek5Sekxmdms1KzFFZjZlS0FucE0xZDNEQjZvcDNySFRhNXZOSGdGaEwv?=
 =?utf-8?B?cldFQklwZ3JBWXJIbGUveDZZdTNqeDg1V05LbENNU0VKSUgxWHdOMC81QjY5?=
 =?utf-8?B?elVYNUtsRFF2cDdTUDhxdFVrazlSaC9pYmMxS3Rqd05ydzRzUFJ5RDd4TVd2?=
 =?utf-8?B?RURJRytxUjV4SzM1dWVmUTl1d2F4UnpBZlZtaDJSZ0h1bGJ6U2QyaUVtS1U4?=
 =?utf-8?B?K09mZnpiWDdOMW5lUklHK1NLOXMzM2xUSnhIVkZDMzNGM3cxZXBRdXRoaDFq?=
 =?utf-8?B?dUEvaDVjRURNSHUvM1pmeEswMmI1ZG5uQmEyb2VacVZ6TEtmcFlTNm5jd2dw?=
 =?utf-8?B?amRwejRjeXJGdVl0M3hQd2JHNytqSGlGb3RqYy81dHR3NkZwckIwNCtKaFNh?=
 =?utf-8?B?WnhyOXVmQ3N6eXhQRHpSZnphMS83UHhjUndYY2RhUGhVTjZ1RTlPSnZhUDhW?=
 =?utf-8?B?cUI3RkVDTDMxczE1SGdTOUM5RjBPWE9pczZFYndETXg0SVdxbEwzNjlnZWda?=
 =?utf-8?B?MjM1eFVzZTVIRUFBeVdSVVlGK3gzZDcvaE02OHJMUWdidUZPMFJLU2ExWndu?=
 =?utf-8?B?eUZnMTBoWjB2MW1vUVZiTUtyTEI0NDZCUTFRTGNvQXFSRXM4YjcyOStyK2pR?=
 =?utf-8?B?T3RacUR1ZnlPbmtmd3lvcXF1SGd5NG5zd3RKSFVJbU5rUm05dXBUM3RYMXZq?=
 =?utf-8?B?ckdIKzdqSThrbVZIMzJJVEdreXpYZFJUOVcxdkJPNU1tSDRSM2F6TlZBeUZH?=
 =?utf-8?B?cCtiaFVqVDlDZ0ZEdG9yaXR2bGFGd1BVbWRBWkVSN1ZwalYzUTBNM0E3WFpN?=
 =?utf-8?B?a005M1FyeGwvaVlWZkNmRjc4Nm9MT3FIOE44clFvY2hMYW5kY0pVaDg4a015?=
 =?utf-8?B?eDNERjArQWNYOWRmNGxrZ2tRcVJUbjdGUnN4aU9PWDlpSTJJd3RmV0tsaDlG?=
 =?utf-8?B?eFJ4aVRjZzhCV1pKRXRvUXhpUmRzTjdSeVZjNjl0V2FvZnFPYWF2L2dRVWVl?=
 =?utf-8?B?OXJrbUVyd2pVbTlHNWREVWtXbWxIbU5mWXU2dWlhT3pDWTFIcmpjQ296NXQz?=
 =?utf-8?B?M2F2SXNtbEJwclRpTjVpazN1a0ZxdmpsNDlkaFc1ZkxQekYrU0NlajNqM2JQ?=
 =?utf-8?B?SmxxbDdjT3RjalVNYTVqN0RUL25tT2NUZTg4dTdrSDdoV0MxNEpmd1dPMTBs?=
 =?utf-8?B?NUZPOCtyZHQrUDR3QmNOcmtuQk5hcWVPTUNFMFc4cXpVZ1d3Z0FFM0EySUtw?=
 =?utf-8?B?Qjllcm92YVJRdk1oeU13YWFxNXhBcDNZVW95ZlY1dG5vRC9VZnQ2eEFhQTRP?=
 =?utf-8?B?VTlULzV2bWhIQmRIY3IvT3E1V2VnVnpaWENMZnJ4V3paQnAyZzBINkFpOWxN?=
 =?utf-8?B?SFZkYTFhUVJPdi9yR2lSN0xVUHhZV1Fra2huRG5IbS9ubVpTYnh1TFJYVjdI?=
 =?utf-8?B?emJzQStRZEQ1NDVSeFUwSU5aV3lzVCtzaW1UeHh0V0lzTDIxSUlWVU8rako1?=
 =?utf-8?B?S1BSbHpaOWZ4WW1UTUk2UXAza0lVbDBnK1JrQnV1ODJXT2ozM2Z1dkVueTRL?=
 =?utf-8?B?c0NZS1plWnFJOXRBQWtKM3JkVlVpUys4UjdYdVhPRVYyb0JmU0dPRStwdytW?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7482ce7-9804-4968-16e7-08dc9170e6be
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:35:27.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWlwEH7uJYNNfv3NXsXzpfakUpAj/+4PX/q6VOxZnf5RRWQ5gyiaorvFv9vpsHxq1QMuCo5g1XZjpyZgtXlNtMSnt+pSiTXZkpqLfwBYWZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7714
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> With Sub-NUMA Cluster (SNC) mode enabled the scope of monitoring resources
> is per-NODE instead of per-L3 cache. Backwards compatibility is mainatined

mainatined -> maintained

> by providing files in the mon_L3_XX directories that sum event counts
> for all SNC nodes sharing an L3 cache.
> 
> New files provide per-SNC node event counts.
> 
> Users should be aware that SNC mode also affects the amount of L3 cache
> available for allocation within each SNC node.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   Documentation/arch/x86/resctrl.rst | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
> index 627e23869bca..6695b7bc698d 100644
> --- a/Documentation/arch/x86/resctrl.rst
> +++ b/Documentation/arch/x86/resctrl.rst
> @@ -375,6 +375,10 @@ When monitoring is enabled all MON groups will also contain:
>   	all tasks in the group. In CTRL_MON groups these files provide
>   	the sum for all tasks in the CTRL_MON group and all tasks in
>   	MON groups. Please see example section for more details on usage.
> +	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
> +	directories for each node (located within the "mon_L3_XX" directory
> +	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
> +	where "YY" is the node number.
>   
>   "mon_hw_id":
>   	Available only with debug option. The identifier used by hardware
> @@ -484,6 +488,29 @@ if non-contiguous 1s value is supported. On a system with a 20-bit mask
>   each bit represents 5% of the capacity of the cache. You could partition
>   the cache into four equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
>   
> +Notes on Sub-NUMA Cluster mode
> +==============================
> +When SNC mode is enabled, Linux may load balance tasks between Sub-NUMA
> +nodes much more readily than between regular NUMA nodes since the CPUs
> +on Sub-NUMA nodes share the same L3 cache and the system may report
> +the NUMA distance between Sub-NUMA nodes with a lower value than used
> +for regular NUMA nodes.
> +
> +The top-level monitoring files in each "mon_L3_XX" directory provide
> +the sum of data across all SNC nodes sharing an L3 cache instance.
> +Users who bind tasks to the CPUs of a specific Sub-NUMA node can read
> +the "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes" in the
> +"mon_sub_L3_YY" directories to get node local data.
> +
> +Memory bandwidth allocation is still performed at the L3 cache
> +level. I.e. throttling controls are applied to all SNC nodes.
> +
> +L3 cache allocation bitmaps also apply to all SNC nodes. But note that
> +the amount of L3 cache represented by each bit is divided by the number
> +of SNC nodes per L3 cache. E.g. with a 100MB cache on a system with 10-bit
> +allocation masks each bit normally represents 10MB. With SNC mode enabled
> +with two SNC nodes per L3 cache, each bit would only represent 5MB.

"each bit would only represent 5MB" -> "each bit represents 5MB" or
"each bit only represents 5MB" or "each bit represents only 5MB"?

> +
>   Memory bandwidth Allocation and monitoring
>   ==========================================
>   

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
