Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAA670838
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008984; cv=fail; b=nrM7j8f+Y9k23EYEl+MC9g+2jdHfNBRVI8muTRBQDwUachBED+rZIE75xp3Yf/8XByc1WhmfAf2CWwfAJfglZuRjdmH8Uw9OzLBRl2akiLpM8ErKLk1zuFViBCk7fpqIRMa3WXX/ih51yaUq/SudLmcDNuoXC4tLduqDlf6HKb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008984; c=relaxed/simple;
	bh=F+rQ18OxJ0xCRgIIjO2+hx//geNVlabPOMB+UVLBeHY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WPfKjgpqILJzi1Ly3QkG8fdv309rYsnKnJAN7ETzEluKd07/OJV9NST484QjB04/pRN5po0sLUN748f3i1TlnSTHACc0qaGSB3UQea1hnzZ294m4iLbDUejCIGeleDVwVcfen/mAO9oh4RjQAk2HhyksBzR0lDz5l8fQsR/KTPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JNpIsdlY; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JNpIsdlY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749008982; x=1780544982;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F+rQ18OxJ0xCRgIIjO2+hx//geNVlabPOMB+UVLBeHY=;
  b=JNpIsdlYpDPCcVU3nl8sl/X5HoX2yxI9Hi8lfTGOAcf5DHm0mSTA2BMg
   lfBgM6GeqDCBYkUQuMxqZ+BV07ilT9nA9ukPmIOVNemg31Ew0j7/G9vzr
   EeMz2v8c0EOOJki7sTilDfqx08lQdELugrEx33HB2MJtLzajfVv3xNRh7
   yhIQfK3vgsUnQirtHVXqXL/2a6Jigi9VbBzdWFUfmdWGT9fvoNmQZdhDE
   BEETgutILEVMTAhNn1/IxjYxmmlwnXkPdYiw2eWorL0aUChGKAOXwv+FD
   9XW3RNPjQ1iMpVdZo9FBHiiB3noMtv/eNEXtVUAIzl1VT4AZ+JK7NkOu6
   g==;
X-CSE-ConnectionGUID: zuKihAwyRXyZCJN3Dta4cg==
X-CSE-MsgGUID: 4XScW/g+TkaLhiWWXM8JAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50986424"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="50986424"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:49:35 -0700
X-CSE-ConnectionGUID: 7A1gACBWThmHnF+ldE3PVQ==
X-CSE-MsgGUID: Ui+iSBOGT/i6gLy+4zR7Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="150340874"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:49:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:49:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:49:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.73)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:49:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sr5vsTANwx1KMnwmGtkDq9cvJz2yr3LNCO/kMXOMHwBprbZPwwRFNh3PmvvHTXsGFnD5GiE4tZi4ONfp8zhg2UCih0thBcz5DEdpQkqCHMrPV0CKDKclQw77nJ4Vn6Wu25wZR+e+s1taZjQM55DPr+8AZ9U29DMx8TA0y+E2LLEW9kv1OUYmj2ugN58S6Lv/SL9Eu60WbAhE0xKuoNMVwqjeVl3t1ydjFPaVpagmZ+RwQI6t1Cki1MPKSR2oqvwqLYeVBBB4yS3TTSncO54dLkm1cQS8d4ruAC9lYyuvMJYahv8joEEUuXy2yUXCLMbrZR8N9ycnRBF/MU5cpCSgDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FejUa2yePYJpOGvBF+OYG1kHjDyqLQgvhnJirWdGyCs=;
 b=j/AmOKjLsej6NoNeMH6rSejitHgWJ7SENZx2m1f1O7lvyUfUzwzPfkAeDZQ7iA6q5iYlcFcHWAU+wZ5DNTxJp6gPlw1wynSKHeltVqeTVjjT+VkoorT2bdT4OCy4/fLW0z0MgOMAIihb2qvFE/dSj1mnTz4A5hEO404qHM8riLxBVzIOn9jHHdPrcG6r12V7o8gX9geG7NrKAOZHqfAH8wbltj1DuUSTARHhBh3VXsL25OWyG6gCut2OZGSBgp2FqLWK5hTMH1ZB3lYjRiyU0GAjW0zQY9TenqyP+oLEQGx47TG/BCCMZIWDSKTrwh9UYdDx92Q/d96FbKt5ED/7cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7599.namprd11.prod.outlook.com (2603:10b6:a03:4c6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Wed, 4 Jun
 2025 03:49:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:49:27 +0000
Message-ID: <60fc7751-d26e-4e6b-99ee-58e99f1e3783@intel.com>
Date: Tue, 3 Jun 2025 20:49:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/29] fs/resctrl: Add an architectural hook called for
 each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-16-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250521225049.132551-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:a03:331::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7599:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c4949a0-748f-4ab3-a254-08dda31acdb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Si81THk4WHZJS0JRbUxWSFlZODhCdTdIRkwxMUpyMnY1QWNBV25aWGVrT3Qx?=
 =?utf-8?B?eUVYNHEzSjkzTGIzRjN2ZklodjhWcENlQkczUzdEdENjcFZvVEN5OWxRNzc2?=
 =?utf-8?B?MWFEZldvajh1b2ZVRXNGNFROLzVZUHRoOVlwTFZVb0Q4WWUyNWk0d1FkMGgx?=
 =?utf-8?B?YUQzY1BDcnpDMkl1QmZPNExPZnRTNkh2T2hUL0pvdHJYTy9RNzVBeW5OT0c0?=
 =?utf-8?B?R2FLVFU0SGg2S2s0WElqUjhQT2laQkNqR3Y3Rzd6blAxSzhzRFhtRlNiOVYw?=
 =?utf-8?B?alBQYm9EOU9oQ3p4bStKMGtWdjlFYTk0ck9YYXo0T0wxU3Y5QVY2YUFsV3VX?=
 =?utf-8?B?cjJwbFlnZUp2QndhVUt3VVJOUGZ5eGwxdkhGVUZ4Zy9xaEdrU0o1TkVsREFl?=
 =?utf-8?B?UC91bEwzZGI2THZvcm54encxQ0lFNmZFczFnMzBDOFNjait2WlkvdXc0TnRO?=
 =?utf-8?B?dkYyc2JDSUxEYVpnRTd6ZTVrYjh2dTRDbjcwQVZNYUYyY01MbUttZHp0cnQy?=
 =?utf-8?B?aHlYTitiNWdPYWZqNlBReWVnd0NJWlBYYWF0UjZLVzNRVElDQytOT0tNN3Bl?=
 =?utf-8?B?bWZvZDVDeEMwUldxSWp4NGptcjhkL1diQi8zUzd3RTNxd052anZ2OUdkSVpm?=
 =?utf-8?B?MWJJK1hmR3JRQ0hoTVNVWmFXNGF2ZW1WcDI2LytBNFJab1BiZHFtNEdnUmR5?=
 =?utf-8?B?WjltSHRVVU1PRjI5VGc5ZXZIRmw3dXkzMk43bnpXUzJWYklnV1lTOS85TnpP?=
 =?utf-8?B?R1VGdktzWWI1MDhndDhmdnhUN0xERHN1UXJKb1B6Mkw0dXNaY2pQVDIwejZK?=
 =?utf-8?B?SnpKZ1VWeDdJVVRDaEZ4dmh1QjlsZUtVMkRranp5ZlkzOG9Eb1g0R21QQnQ4?=
 =?utf-8?B?MkUyS1N0US9rVFRnQWJmVkVOK2g0M1ZjcWREalV4UFFMb0o3K2hXY1VxTVBT?=
 =?utf-8?B?UEp3SERPR3ViUi9IcW10bHZ2T3NzdGFtVjE2YmovcERpNXdaZ2RGcDQ0ZmZD?=
 =?utf-8?B?TGtOa2hPY25JRlFhc1c3WE5MY1A4LzFFaXRuMzdlYUs0RDd5TE5EU1IxTXM0?=
 =?utf-8?B?SllsRHdmMmVGclo4clducGptOWtSYTdPRU9IZWRRYWI2cGtOVU44Y0c3eWRS?=
 =?utf-8?B?MU5JcWU5MmF4RHBUZEtod1BCTkxIRy9rWDFpWlFCdytQdDI5YWVhdk5KdVpR?=
 =?utf-8?B?c0l2V25LMFpSbm1UU1JROWdqQ2xRNFluUnhMZStpRkQrUVhIWlYxNThHY3NO?=
 =?utf-8?B?NFk2WG92RjVEd1pVNFZFcjVpSnh4L0lVSytXbExEUXY0ZlBkM3NQVWJFZ3Nn?=
 =?utf-8?B?cTAwWXNYWVkvbGRDaWlsK2tKWEE0OWl6eGFycndPWjMrMVVadE1raTFZazFN?=
 =?utf-8?B?czN5Rmw1ZDNudmZNbGs3a1BDTENDSFg5SUcrMnFUVFVNMFcxLzlRZVo4TDBm?=
 =?utf-8?B?b2M0bCtoYjFkSG1WZHhvcU1zZ21qMjQ1SzhGRFcyZnM3YWpySzVrN3IxM1pB?=
 =?utf-8?B?YWQzcThUdUZESzB5MVZZdS9mdy81akhwRDQ3b01peDhIaGFtRnRxRGlUeVF4?=
 =?utf-8?B?dm1VQWw5cEJSRUxocnB1dHJXcGdyYjhJbndZUnhTeDdxR1YveGVLYnpGc1FR?=
 =?utf-8?B?dDYwZ2NobzBpelpCZFp6YUxqODArN2JGeUNkVFl0bkFULzlwaWFVaHFzRlp1?=
 =?utf-8?B?OW1RbitQcVYrckdoRkhUeGlHODd5empqVmZxV0c0dnRvdmt0L2FqU00zTG5S?=
 =?utf-8?B?U1laY0RwRGtxZklUY09DYkVGY0hWZS96dFdSYXFjamVJTlhKbmYxSVVYQUhq?=
 =?utf-8?B?QThJZ1FkSk9yUjF6M2piNkwxYy9IeHF4Z1RKZi94OFFiRi8wY0F1djVwUVF1?=
 =?utf-8?B?NkxUWnFqcVJKenFsTC96T1htQ2dKOUF5ZUdmU3dFYXA0Q09FSEN4eGFnNUM2?=
 =?utf-8?B?M0lpclhLYkQ4alJXU0R0OXBmb2dKUUQ1U1NSeXhXSWRMSjNDVmpqMUJxcmZt?=
 =?utf-8?B?RCtJa0pUZzJnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHNCZDNoUVI0SEtTTThlOUI4bndYNnBzd3dDVzJIR2ZGc1BLamtVdFo3aG5k?=
 =?utf-8?B?allBNDJiRmJQMENCNXRrLzRRMlVJSW1nZVZGalRDU1VJVndwTXR5TXF5V1pT?=
 =?utf-8?B?N2oyajE5T29QenlqV1hFT2dDaFovYU9Xeks4N0NtTGNxTWxuQ1hvUEFIZUZ3?=
 =?utf-8?B?RXc0bFE4WjUvRnZiREowWDdzZEp5MnVQMEY3blBYTm9xdmNUc1BsRHJ2dVdZ?=
 =?utf-8?B?SXFwQ3AxNVdxb1FyWlFOUk8xdmxxb3pzVmUwL3lSNlhFZzBEVDNUMDdTNFlz?=
 =?utf-8?B?Nmd4WUZMWW9jZk5YZEVHaXFjc2czYzByV0loTkdOczVKd0lGK0p5U0dYYS83?=
 =?utf-8?B?U2gzT09jMHlibk93c1pFQjBJYmtFR0g3UUU3aUpzTnJNbnpjaXdxUFJGclFR?=
 =?utf-8?B?TEJpcC8rem01TVVlT1VZbTFBU3BnMDJPZk51bllJQjhnSlJ0VysxNERnQTJq?=
 =?utf-8?B?bno2RHhHb3N5bHZJZEhwUmNaSm9QeU1yaFBrQWp5NGwzS1B5bmVjUklHSkNk?=
 =?utf-8?B?cDZWVmtLY0tIZ2pLcFoxZnpiSnR4cnBEYk1Ya3k4Q2pTZUdOSnhEeDE2K0hl?=
 =?utf-8?B?ZS9ZQzFjOGxtTWprL2JVVzZZQUtCbUNpQXNobktsYlQzbURTNENMb0JKUFRP?=
 =?utf-8?B?bUZnRitLYndzY2RJbWdpT2NLREFGeGdtNGczVmNQT3ByMHh5enpNbGhodFdl?=
 =?utf-8?B?Z2V2cjBXK2dYUk5raUo1TTFqUjgwbHZ2TnZKRCtDQlJISks5dkp1eWY4QjBh?=
 =?utf-8?B?V2c1bUtpMTJYSjRZd2xqOThGdEpiU05lUHBnbWhWUnFNMHFlQWZkcmQ5WEor?=
 =?utf-8?B?alBlMnd3Q0xTV3NyM0toZS9WdTMzT0dISnh5OFFiVUYrdXpTTUVyQ29RUWxj?=
 =?utf-8?B?bStOQlpPUXNaY1JybCtXUWM5WEFyWG5CZzh1VkFtRnhIY0NIL3Qyd1c0Y1Ru?=
 =?utf-8?B?YTh2Ti9LUk42N0xjSUx5ekozTEdpNVdvaWNMV1ZJRFpKLzBYTzRXbnl1OGh5?=
 =?utf-8?B?V0RVbVZEcXVzNnRPVkUrc1NJSEZMcFYwMjhBSE91ZnVYSlNjT09qdFppSHZn?=
 =?utf-8?B?YkhvcUhtYWlCbmRkYnBIcGtlUkVZcUZrTGJ3akRRdXdnZEdXL2xWVWJYTzBR?=
 =?utf-8?B?U2VGdWVVTGUzVmdVNCtKZUpKZGV5MHBGQU9wSmp6VFR5QlM3bmFCeURNdGgw?=
 =?utf-8?B?VVYyb2swaklqTUZBSW5Xbk9XNURYVWZTclhMT1ZxMnAzay9lcXo0RUR6UThZ?=
 =?utf-8?B?aEp3NUVNVi85VkNjNmNwdWIxSlZCdFlXOWFWZzNyWjNLTmVBNGJMbXgrNmpD?=
 =?utf-8?B?c3doVHZFcDN0UEt2WHNVdnVzemorVVFMQ3BQMWo3ZmdxYjFSNnlBWVM5YTZm?=
 =?utf-8?B?K1RWUlcvdWcrK2ZyUUdIdlhSeHZxd2dZTUk1V1QzVkdzNmV2dU56UkJULy9B?=
 =?utf-8?B?Tk1pLzRDbCtTVUNKYmF1MWh6QVdHeFVlNTZ5YWtCT3hvSm5EMWM1QldKdTVC?=
 =?utf-8?B?NmFrMjJVZHZMYlJ6ZnBhYjBEZGhBNGl1NmR6d3pzM21scU1hMXEwNmRiOWZO?=
 =?utf-8?B?cFhjcm5PQkRQaGpEWnlMZjBCUS9MVlo2M0tiaXlFUnBuRmZkeTloV3o4UHpJ?=
 =?utf-8?B?TjFwYTJxV3dQak0wRStZMmFDcTBhbEdEdmZRUmgvbEF1aUV5Ymx3Qmo2cEZv?=
 =?utf-8?B?RTNuWXpPVTR6MC9CUjRPMnRlNUR1eFZsSVNGTVZTZk1ZbEk1REVsWU8vVEx5?=
 =?utf-8?B?K2hpb2E4UHFIU2lxbnNtZ0lEVEZqVitKcURBRVZtRXlwbzNiUmhKNVVxM3lQ?=
 =?utf-8?B?WDN1ckx1WnRGOTJBOWlCalZwenJ5anNjUVR1OUpuaTRyS3JiR0hLRTVrdE50?=
 =?utf-8?B?R2xadWhtSWxwaENXU0hzcFFES1pUS09haSsyT0ozVFdtWXVwWk0xVzB5WFBp?=
 =?utf-8?B?ZlI3RUI3Uk9oTXdVQTlkT1hnNWtnN0ZJRUZrUU4zaHVDNC8wR0NzTzd1a2ZI?=
 =?utf-8?B?SW1qNnYxbUJoMjJ5bElVeG9JVnRGa2gxTTdHV0djQXF1d1BYSi9GSkJ3MGNL?=
 =?utf-8?B?R0tETGJOSlhTeXRJVTdIenhXbEFTY2NWRU9KR1JueFN3YVRmc2cyeEZyUnVZ?=
 =?utf-8?B?WnUraG1aa1pYTnBoQmx5UDNPOXkrOXB0ZkdsMTBnTUI5OG5GeGRXODlXemVP?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4949a0-748f-4ab3-a254-08dda31acdb0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:49:27.3871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0z+yzSd7Jhxd4TRzmF6uWZdbAfCK9qpm58SVAUvcn2yey2joo2J8k5Eq2xvUT0hfBiMS2q+w05CaZgAnM47NbvD59fr3J4wwOdV5Lxhw9Dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7599
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 306afb50fd37..f8c9840ce7dc 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -710,6 +710,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> +void resctrl_arch_pre_mount(void)
> +{
> +	static atomic_t only_once;

Looks like the custom is to initialize with ATOMIC_INIT(0).

Reinette
