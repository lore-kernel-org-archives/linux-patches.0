Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22552C3260
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 22:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767823787; cv=fail; b=NPkYtGl/OEfUSIuWxS5cfylhzvZpMWL5n9d1eTwVm9FEaxq1djp1pjbqf54XaMe8t6AONq/psXFxDXnPWlkWhJm/WoPAGA1fNF5e7xOXrGGI5CRbKHSFeOzGo/d0K6m8+PuzoyiIyvxs61MCLozDWImXn02EiskayKGp3gyCyOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767823787; c=relaxed/simple;
	bh=iXyopA6l96nlj2/W4ZlqMWpKleKZOtUwZ/b8Oj4osDg=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UM1Ci6Y5OHumUq3vh3Ug0JslN+5pOGF7i4SR3IyhjtrFPt0cOXn6RKup5jNe2Z0/HbZ4k6KID3zieUFk4HgqVTI3Pal4JXZsgj6JVu4teG1C5JP/qvn/FPFbu4AoYK0Gmdg7b8S2KBycuhHKWUh3kmQzjnQL7VnI2ywYswLxCzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHFh4NTf; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHFh4NTf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767823785; x=1799359785;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iXyopA6l96nlj2/W4ZlqMWpKleKZOtUwZ/b8Oj4osDg=;
  b=FHFh4NTfniKtWxSbIDJytEKZdckVnCV8hD7PlTv1JjFb4p4U8uMZQHNH
   T8US9fYCb7QQlyISlwC8s4s3yEkfMmvFxBX+qEKRL3ZCdu3FpspF+gmH8
   8CdzXFUWG3gdP7PMK9QfrxpaagdQvL+uzB3hPsAFQ0AC4gytGMCxQgH4v
   ho3wozRfbYV7oqpC7/y657D9x68aaBEOU9Jda81xHzFBk+AsJ2EN1+aEn
   9oP3fC2ZINKs+Cmcs4D+O2lvIBI55fwJRNHIaoSI2F3DgXdVqc3i1MFUI
   x/2EtKvKJHRmipAoRvOQlDtELMEgYdlDkN4yJclE9p07uHHr5tQsw+QvL
   g==;
X-CSE-ConnectionGUID: le2TD0EbTmWJne430EN7Rg==
X-CSE-MsgGUID: A+98B9L5QdeSzap+vWbUsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91859937"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91859937"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 14:09:45 -0800
X-CSE-ConnectionGUID: m8DDJc2ORbqmeeoS1wAoxw==
X-CSE-MsgGUID: mhybDQJAT1+Xcisvy+J0MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202939712"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 14:09:45 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 14:09:44 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 14:09:44 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.21) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 14:09:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJiIa3gc/vTnMHn6YJ7wqZwhbcs9ZBYKynqco0MUJ58AFBNEwdVmSjj4h6HvxNqK8WpCX8NtPEmqt/vChdAqpDqg+y41RdtTkiOLIral/V6jwxePjyqH3MxcvZ5hZjZrYT8g7SVRkGqaPILFcSQ2orvIHsAGTGGZEZNMgJC6oDV56GRA2j+y0l5OMVm6g1AkkWHa9w5MZrHkROQ6XFkgsTVwluqjIMkJiH6VXrh5Sc+ZmBp1HAuKz8jXPyEtE30pDZZmaKfI9Kb7Jgrd9LFPl4n//N3uLsfgogBld5aWyzqmOig/5dPPcTxOkjw9Md3/0PLPrmiEpH3OLirgWafldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZT5pz/SlD2X3tH5VyOJg2YYykd26VDh+gUc8/lKdkU8=;
 b=aXzT7+nDD/Hs5g6vPs/E7fXwcEgvhBSVVSBcdRjTTDrKGvRlmxXZrizuJI7caD13z6Hjluj/52qJK/2S7y/qZ4HxF5MAOXdtV48QYiJ9wUVgohRtfdU0+nfXULLNptwSoL20hikBam8BquPGl8/ZfcPa5Hm2oFrb0j5nFxIq9jOBlqLPEHTHXR17AFBvL/YvOJJP09byCgOKh1d+rIiOvyKhqrKhpITh232w2+jzkuJZJFX5LxP/h6QPXNskPTFoI8Ypkt+LON3rrxrLDT2A4Z8wfTWkp4B+tVQabDqK83vCEaRsnrHaQDz8212qj3swGJyG1PtnGcnq453mjj9IBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4742.namprd11.prod.outlook.com (2603:10b6:208:26b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 22:09:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 22:09:37 +0000
Message-ID: <cb41f4bf-7eb4-4a59-b46e-8bc4ae18e6c6@intel.com>
Date: Wed, 7 Jan 2026 14:09:35 -0800
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
 <aV6gU-lKrSjA2hDs@agluck-desk3>
 <4525e857-c52a-4e5d-bd74-120f66a707e3@intel.com>
 <aV7BIWu7cSSgCv1v@agluck-desk3>
Content-Language: en-US
In-Reply-To: <aV7BIWu7cSSgCv1v@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:303:8f::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4742:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a1b4473-b48b-44e2-16e7-08de4e397265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q0tJVXZxeEJuRmRaYW95TGw2bFNqTlNuVzBhNndDYzFoZVZIK09mMWFXdVFT?=
 =?utf-8?B?S2lpVHF1UFBjLzI5QktPYVltN0hsTlpCNDdmS1diQldUcERBRUR4MkdSTnpr?=
 =?utf-8?B?eFcwQmE4U2srYXVGcEZPMTVaSnRHWDRWbzFseHZhWHFOVTZPYnEyTytubE5m?=
 =?utf-8?B?QldrZGJKcndBRlhjY1ZhY1hNa3BhZ0wzTVVOdWtyangzcWVXMUptS0ZVUitV?=
 =?utf-8?B?YVJyZTNBdG8xaXRub3kzU0cwWHYrWWtyR1ZhVm9LQWVhcU80dDBaT1h0T0Na?=
 =?utf-8?B?Tm9YMmRTaWl1ZlNCNHRERk5xNktVOXhDWlNjc2FJVFZwUkFRVklWS3BTcUsv?=
 =?utf-8?B?TnA3eExzcStjdXVRdUJXK1VvVHpJNjRJbDUxUU9HZjZ0UGU4UFVwZU5WWUpM?=
 =?utf-8?B?b0R6clYrVGp5czVNQnpMaWVISzMvZWxab2RkZ3owTElsVG5jOGhsblBHeTdj?=
 =?utf-8?B?dTdwT1EvZjFURkRBNk5yN0tHbEtNdm95RjdwK01hWE5vM0FkUDdQVURBbFp6?=
 =?utf-8?B?VzUvTko3Ti91OGdoU1UvbEJ4MWNHcHB1NWZpMjlaK0dFa05OTGdTYWExY1pB?=
 =?utf-8?B?VEY0Mk5RU0s4ZTc4c1dHYi9YRVQzaFhTa2lkR1p6WFdISS9UV21sZ0dVeWVB?=
 =?utf-8?B?VS9VT2lIQWV4NEcyUGwzQ1A1VnlUaWd6ODFqaW8vNlI1YTRKMlFaeXMwbDBF?=
 =?utf-8?B?RG00THdaU1R1UXNUSFBTU09yYTdjS1BPMWE4dXl6QktFWHdpVkREa0lBOHZr?=
 =?utf-8?B?K2Y2YjZpYXhzWjdMbms5VEFUeWN2cXZycHltWk14c3NFT3BZcForZk13SEpj?=
 =?utf-8?B?TDIzbEQzMWRhWEFjNi91THJNY3B0Nm5XU1V2NjA4R0xESEhVRnovTU95Qi9J?=
 =?utf-8?B?ZmRTdVNFNlVrbHdkbS90M1VVVDdWd1hSN08yS3BxUXA1c1E5dUd1NENBWStv?=
 =?utf-8?B?U0sxMlRtWklJWkY0R01EbUovcE8xR3k0MmFCVnNWNTc2RnRROWVVZ2FPUEVL?=
 =?utf-8?B?VXIyMDFGNTRmelhPcHhEWlY1SS9XR1AraFVmUkd4NXZjdG9yU0FuRldEeS9p?=
 =?utf-8?B?L3hQTlFZYWI5b2VaYXlpQUZmTW4yS2lvdG5tcmFBTkxVSTZRaEdMUkZDdUZ0?=
 =?utf-8?B?WGdTVWVHSUgzcWZpM0JkOFl0RGVXSHFFaFFCQVZwc3p1bDFnRVdGellzbU9t?=
 =?utf-8?B?UXlEajI4WGUrQjFJaE9JeVNzVExxblU1MlNSam0wbzNMZnBxZDVGOW9ESDI5?=
 =?utf-8?B?emx4Z0tzczRiQXZyS29kdnkwTDI0Y1RxZ1VaVVR2YWhFUDA0YVBIZGxFRzN2?=
 =?utf-8?B?SUh5T1N0VHRvRGljTWhtbGk1bUhvMTNZTDVva24rSEVhUXlwVjdhSWlLcmlF?=
 =?utf-8?B?dmlBQnhCWCtFVmhhV3ZCZGFGV1lSWXE0a3IzMEFIbnA2d1VPVmx0OTN3WnlE?=
 =?utf-8?B?c2RQMDNlNVRBQlNoVTE4czNlQ1BSWjdzL0Z1K2ZhNGhNRXRza2ZqTXJ2QkZq?=
 =?utf-8?B?OGNtaGViMXptRDR0dFFlNytBUmhaWVNkMlNIa2E4UmMzY29vcC8xMU90dUVL?=
 =?utf-8?B?YnVQTisxZ0NrSmJKZ3ZpTkUzTnJsS3BuT1dsaTMzYXh1bjliN1EyNEJRMW5n?=
 =?utf-8?B?RkZuVjZxTWI5NHZUejVjcmt0OFhBRXkvSnhiTjE4VUdoZGw3cmxPQnZPZ0lw?=
 =?utf-8?B?Ty9GYWxxb2J1R05rZVB1Y0ZnWkNVbTNhL3kzc0wrR1RibTd5c2xnZmRLMGo0?=
 =?utf-8?B?enJvS2t5NXgvWi9EK0FYUVQxRkFNRWw1K0xpSGNCeEhpeVYzbGZzQ3lLNDhp?=
 =?utf-8?B?TUZ4WU9RM28zbVZIVlBtbG02ck4ycUYydDJmVTJyNllKSzExQ0hwNjdHWE1N?=
 =?utf-8?B?eDlYbVNQTzNHb2FKREpOQVBQSkhBNUJWRkFzWHFncnpRd3JydFpjeDVUL2sr?=
 =?utf-8?Q?frgMTPQWzMTf3B8O8mxVj6vhl7f11ch3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnU3TmhRQW5yTUQ3TXA1QlppNXpyWmo0anJNVTZvKzlac2dtTEwyZHAwc01B?=
 =?utf-8?B?bGxXcDAzV0RrU0MrS0FnMFNXaHY2ak44WTJMUk1ENmZiSXpSNWx1SHFDQm9n?=
 =?utf-8?B?OUdqMEJJalgxcTRTbE9MVjl3Z0VKcFhDVGVHZks5ZGtWZ2ZkOTZnekhEbVFE?=
 =?utf-8?B?WERvR1NLY1RDMHN2SmJpMWxWYWhhdVYwSGZlRlR0MVFLYm1rZTg2UUZGRGl2?=
 =?utf-8?B?amhtQWttV1k2SGxRWEJWNmtJRnkrRXNpSmtkZXdEaG53L3RIT0hsTDBaQnRj?=
 =?utf-8?B?azBhdVluMFJBem5ZcldrMnRIL3p2eHRXMHpKTERMbmVZL0ZCMUtoSnJLYVh2?=
 =?utf-8?B?OVVXVDE1bEtyaTRISHI0YlZQS01reWFQTzc3TGg5eWhMVXpGSnVwTmJtZ0xG?=
 =?utf-8?B?WG1XMWF4djhvMTNoTnR2OWJpSll3V3d5a01pMmk1U3Uwa2hwNVZlZHFydHdh?=
 =?utf-8?B?VWhtSUdzOElsVGNTSGZBTDZpN2hDdm1TOERyNWZCcHpwc1o4MEo1c05Xck01?=
 =?utf-8?B?YWdESW0rRHJLYzZrSjFadTFBd0EvQzdKQmVWeUx3WVhJNXBhcEVzajBoYWo5?=
 =?utf-8?B?UU81MXc5YnhCM3NlRnJheXUySWtISGNsMDhKUlVLNTJnOFpkWEhTaGlQSnpD?=
 =?utf-8?B?ZHJIN2tkd3NJcG5nV2k1ZFlBTitaQ2RGWlBUQnNtOFlCc2VPWHlhN0ZRVlVT?=
 =?utf-8?B?RkN1VHlTUEZsS0pZUzRNZXc1YmtxcC9xMnh2ZEJUaXg4OXRKZFYvczduTWdN?=
 =?utf-8?B?ZGVJVG5hcC9rM1MrdWlxUUhxUEQxUi9nb254cnp3QS9jbkN1cGpqeVVpNjhL?=
 =?utf-8?B?WVc2S0pBNVJDaDBvWFlETGg2M1ovNmNQSlExblAzWVM0ZjJubVNiN0VvRzA4?=
 =?utf-8?B?VVpodkljb1EvZGdzbjVzZ0VjS3NMcUNSQWh3U2JzNVpYVWR6TkVkTkU0cGVY?=
 =?utf-8?B?VW5sd0xmREVzUmo4WE5JYWYrb3FLWExPMEdaMkZQUUVGOHA2M21wYldsWXcx?=
 =?utf-8?B?OWRYVjlvMS9vY1ZnV1BxWmdjK1FUYVQrRWFNY0Z3b01YZlZGRFpEaWNvQjh0?=
 =?utf-8?B?NFh3bFF2OUJPamdWN0pCY0dZTVl0NmR3SjdEQlNhS0Uxc2ZPd2NlWTk1bVhq?=
 =?utf-8?B?RGNtQlk1NklKbnpvQXlMazRJUG5QalJZOGJEclVGa3BoYjA4d0N5WXlZbldv?=
 =?utf-8?B?N0hBNVZpUWg3eStkR1FEcDYwMXNpODVJTnRjM1Q5cFkwaTFXNmxqb0FsSGh1?=
 =?utf-8?B?WVFtbTQrKzlwWDJsOUtJZzNReFpYZTMzUGVFYlp4TU0zYlh1SXhtNkgrb3ox?=
 =?utf-8?B?ekx5L1dBTUJ4bzN1bWlQbmsxeGovcEdFb0dLbUlmajVVWlRRaHIveDJSditz?=
 =?utf-8?B?dUd0bEkzb3N2YXVaRUZNWWx1Z1JIWk1oM1FKbHZZMXdBZ1dOQTE4bGgvdkh2?=
 =?utf-8?B?cXR3OCt1VFc5d2hzbFZadHNEMDZkYm1hTzFRekJIOGJZbkNmZnZQU1Vjd0t5?=
 =?utf-8?B?c0xzWWtnNTEwcVpXZ1U3VVg1Y0VBM2tOUFVVRmEzWU5MYnppcVpmK2VBazNi?=
 =?utf-8?B?Zkw1UEMzenVDV09Iam54UGlpTnZabG80RDgvK25MY3dMVlVaTkNMVXo2M1VB?=
 =?utf-8?B?VDJBRDJSaHVPTjBRMWpGVThYa0g4NU9MZzFtY0t1OWF2dVJXd01uV3JtSHpz?=
 =?utf-8?B?RmQySjl1YytBdHp2UkpOSkFSMDN3andTV0x0VHhzM1NJdURKRmhMVGs0RkFT?=
 =?utf-8?B?dHlRQkRCQTJMT2RVWUdMbFd1QmxpRXpFVTZHQThvMThTZmhCZTRnUUlodjc3?=
 =?utf-8?B?cjE0T1gyWjBEL0ZQVGpUY1BScXFWTlR6bTRSRjFMcHRaQTFHQXNETnp5WmNh?=
 =?utf-8?B?Mmgxa08vQXlCaCt0Qjh4WVYvSGNwU2FSSU5UNG9xaCttYkZFTVBreDdnZ2pB?=
 =?utf-8?B?aUhqV1pOVmphNTNOVlMrZTlXa1hYZjE4RjdCTkpGS05ZUlUvYXp1Vmc5R21L?=
 =?utf-8?B?NnlOYmVBd1RNbEhOQjFobkxsZmRPWU9kY1Z0ano0b0JkT1pzd01lUnk3bVdO?=
 =?utf-8?B?aDlRTU43d01OUzNWN21IUmtnay9XdWxyKy9GSEIrc0lpbTBwMTVGWFg3anBz?=
 =?utf-8?B?WHJXQ1AyYlVEazZKc0M5dng0bDRrdSsyOE5WYmcyd3RlL3FpKzgzbnFDQStO?=
 =?utf-8?B?ODNCWWYwR3VqbXFWRnR2eDJDTWx3RWpMeGwwQVQxM1dqZ28xd3hqSkpIbW5K?=
 =?utf-8?B?a1VUak5taHVpS2VvWnRjK3lHNHVYZTQ1WkxCb2pEME1yWWhFb1NpQS9WdE8w?=
 =?utf-8?B?SnBGZDFZVlgxS1VJSzM5U0NJVkhOMWJ6cE05WmJoNzhUckFiUGdHc2dzditi?=
 =?utf-8?Q?uKBTTYNd8vYlJzM0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1b4473-b48b-44e2-16e7-08de4e397265
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 22:09:37.4473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haqVQmAz0JwBmKUhoO06GQvmSfA0Dp9FwDqqQm7zPEWbCz3W3+kU+cUour7osgtkn799YRpRUCLLX5a9mb+6iqhKZgpl6var96shqRh0VA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4742
X-OriginatorOrg: intel.com

Hi Tony,

On 1/7/26 12:25 PM, Luck, Tony wrote:
> On Wed, Jan 07, 2026 at 11:33:26AM -0800, Reinette Chatre wrote:
>>> A better summary of the change is that the "only once" logic is being
>>> moved from open-coded using atomic operations in resctrl_arch_pre_mount()
>>> to using DO_ONCE_SLEEPABLE() in rdt_get_tree().
>>
>> One thing about DO_ONCE_SLEEPABLE() that is unexpected to me is that it disables the static
>> key in a workqueue that seems unnecessary. Original motivation for the workqueue on which DO_ONCE()
>> is based (per commit a48e42920ff3 ("net: introduce new macro net_get_random_once")) was to support
>> calling code from atomic sections. Looks like DO_ONCE_SLEEPABLE() copied this implementation. It switched
>> the spinlock to mutex but the changelog (62c07983bef9 ("once: add DO_ONCE_SLOW() for sleepable contexts")) does
>> not mention revisiting the workqueue. Looks like deferring it to workqueue does make it easier to not have
>> to worry whether helper is called with hotplug lock held or not though.
>>
>> Do you see any issue with deferring the disable of the static key in the resctrl usage? Since
>> resctrl_arch_pre_mount() is called without any locks in resctrl control it now relies on fs code
>> to not have rdt_get_tree() called concurrently and thus risk resctrl_arch_pre_mount() called before
>> static key is disabled? I just want to make sure here since from what I can tell this makes resctrl the
>> first user of this helper apart from code for which this helper was created and there may be implicit
>> assumptions that resctrl does not adhere to.
> 
> Reinette,
> 
> The deferred reset of the static key does seem unnecessary.
> 
> But it looks like DO_ONCE_SLEEPABLE() is still correct. If there are
> multiple parallel calls before the static key is reset, then the 2nd and
> subsequent instance will block on mutex_lock(&once_mutex) in
> __do_once_sleepable_start(). When it is their turn, they will find that
> "*done" is true, so resctrl_arch_pre_mount() will not be called again.

Ah - I see. Thank you. So in addition to the static key there is the "done"
variable that is protected with the mutex and protects against a second call
before static key can be disabled.

> 
> Side note: This global "once_mutex" means that any other subsystem using
> DO_ONCE_SLEEPABLE() would be blocked waiting for resctrl_arch_pre_mount()
> to complete. Same is true for DO_ONCE() where parallel calls from
> different subsystems would be serialized by the "once_lock" spinlock.

oh, good catch.

> 
> If these DO_ONCE macros are ever used heavily in run-time code, it might
> be better for once_lock and once_mutex to be statically defined in each
> invocation of the DO_ONCE() and DO_ONCE_SLEEPABLE() macros. But the fact
> that the static key protects the spinlock/mutex from being called may
> mean that it is practically hard to hit problems.

Which problems do you have in mind? One problem I see is that since these "once"
functions are globally forced to be serialized this may cause unnecessary delays,
for example during initialization. I do not think this impacts the resctrl intended
usage since resctrl_arch_pre_mount() is not called during initialization and is
already ok with delays (it is on a "slow" path).

Reinette


