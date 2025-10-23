Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0D420B7E1
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241617; cv=fail; b=d6YB4m8BGmZE33ZVkaYGUasi4WOGS3U1TFXb48mY5RAR8FyUN/YqWs5frM3/rxg5nipumNNnd/+KsxCvtJFn262fmGZXMXn2J2qi64LTL/yjpZojz2RZjSZsq8Papes+I5e7EIq3xxZdgpye0RpTnn0Rybz5COczy4BRqOTs2Uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241617; c=relaxed/simple;
	bh=jAOwlRwOUii4mvsx6iczriIFXxVMXNo5sC63ywjdSnQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ebqK72VaJEDCdQM3C/RGje1WgQiXN5NXC0WsvLpfHvbWYB6NBxXDQDngY6gasSV/OcsfzLb1LLrK7KRYY4TG4PXOQkNZvJLeXE3OX1SNuUUSnDz4EmLJg+aN2coNBypu4onmLcfT3xNRCAuubdHIe2xlZ5i44q4mWelXvczVMcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iVlKTmZh; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iVlKTmZh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241616; x=1792777616;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jAOwlRwOUii4mvsx6iczriIFXxVMXNo5sC63ywjdSnQ=;
  b=iVlKTmZhGHCJCuLH58VtzrAZyIrSHdrE+7rcdyV/DcfDHWy0o/kvhcNE
   8fYS1NN3vGqIQ0wDR2WSuUZdzSxjkqg01kujMwGhKT/8gXkPAvbkvv7Hi
   DaBsTwjdxYS+sJr4RyUedz7W3WaUyM7+amg1AmloploOxfc1NjIQ9IMZq
   xEs17aVTyBrBg8ngBH+QGBns5gQU//aKMFGPphN9d+vT69YdZQG9kCpIL
   WSSb6RMFgaT1IQ652a4FlVBBH7fs7/s/7WSTIt0PZkxRSxOpLcWyQb9K4
   FzBoGcT09DxkWo0zrNkjy3oBP6lf9LwCsRgCLjcAW+3DfCC1Km6atLYFh
   Q==;
X-CSE-ConnectionGUID: jX/zhX5SQc2dmfiwC32blw==
X-CSE-MsgGUID: ohCSzpKMQbOPQW8PiHEyYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74765587"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="74765587"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:46:55 -0700
X-CSE-ConnectionGUID: X7NzdioRSI+Qt367hiWKEg==
X-CSE-MsgGUID: QtX1lwS4RUCz/KsaA+SM6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="215141010"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:46:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:46:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:46:54 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.68) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:46:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RwvvoYcB0ZpJ9mHgYDj+nsajT6y6T4XNyuSi6I5COOZSOWztwC8sSZ9w34OlofOs98kApteYBONtfgcnOvJu5+Kqe4clN0ulZwuVrpk4md4USs1BR5pbwVzy/3XAHmso242RVFuiE1hat68rTu0GKU+YqlIBYDJQWBphoOg97x2v2wspNIBVWz4odKRtab/AZnKpA5EoUs8CjFUgQTTOYtR3tx7sAMSMzPG7vNkGCF4kb6eMBMCV8EjQWYRMxhg8I9E+WrOMm2iImI2FkQg/mTIkYxCOZxzUDrwz5hOP5fAEglf605cWVdnlD9VUSTP1eDAcjzFrUD4nMJFnszCodQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsLM92WyurhgLlXf+LV0bebEWOPp38NWOjFpJ8jGYg4=;
 b=Aep1gN5/A2zfcLUUgAgnumWGl1qCmCo00oQFlysgX7mNVbPjuQmKXQUckjt/xWn3LZ0R2BgfKnkM2EhjISOczJazRqPFi0VUDbFUsRgPtqpm5O02dRS+MZnfD7QDFYU9gWcQkB6/f3LEL/AwriZIrHALN4RvFBSfWLJpb5fl6odWiZR7+g0nA9rev4AHNmM/76VzD7hfXCmLHQmbDv/ehJj5eAMPgr6kgvMLqLDUG0d63gmyCbiZASYje5px/vbFDf+SS5buxH0a1YcaLNpDmqza2joKPKDcN3FsbZjRfehiA6RhlUhd47m0KKgzs3EcQqMr80zqPvdlIabgAGruzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7323.namprd11.prod.outlook.com (2603:10b6:610:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 17:46:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:46:52 +0000
Message-ID: <6869d7ee-d9b2-4460-8433-4473be566e95@intel.com>
Date: Thu, 23 Oct 2025 10:46:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 22/31] x86,fs/resctrl: Handle domain creation/deletion
 for RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: 786247d0-2c39-46c8-e288-08de125c26a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NHVBT0NmQTN0bis0akh4RGpocXA1M0g2cXphcms5Y2JCVEpweEhKMm5zWUN1?=
 =?utf-8?B?M0J6MFFNRVpCVCtIQXBMS3ZmNVlWMlpVTEtTMlFpUmNIOFJkOFFlMmpqR3pN?=
 =?utf-8?B?bHdYYjRVSWI3c0dGWkl2NXhwd1p2b21ic25iWnFiVGxjUEtvbUorYXlWVlBQ?=
 =?utf-8?B?TGd5YmpNcXVRanZlQ21pR0UwS2JIYjRhMEdzZ200Q3ZIeHZkRTJqSitnbjQy?=
 =?utf-8?B?NFJFdHk4STZweU1lRUxDd0NoVFA5cTdVTzlialN5NEhtbFpRakFaNXdlSW5P?=
 =?utf-8?B?UzRsV1liV09XL1dNUWw3ZnZGcGwxbUxDOXhvd0hDdm9mVldHMkxkK0xGVFBS?=
 =?utf-8?B?ZTljOFNkQlVsSVpLODdQVUNFamcwRDFJRjlHbVJ6eGxGZ0VnTVpxZk1za1NU?=
 =?utf-8?B?Y21lR2hhckFwWkQ2ZHBmWDFYNnZEekJoRURFNlJvTDBFWWI3NXliVThiNXli?=
 =?utf-8?B?bWZRR0ZGSk10VytUdzdLN1MvOE1uZkNYYkJNU0FLMjhKeFMrL2puZkl1a2Fy?=
 =?utf-8?B?LzhkbmRtSmREeVNScTlGTHN5Q094THpYSmRMYnBiUXB2ZHo2S05CS1BFRlND?=
 =?utf-8?B?SWdaYUxPQ00rVUtRRDRtNUJCUVF4QmJPWXZ1dlFHV3BqZHRmbDhreStBSURw?=
 =?utf-8?B?TmI0R2JMdTZ0Vnc1bVQwM1draGoyb3FxR0dVTXk2dEoxM1kwV1NwWDlKRGdV?=
 =?utf-8?B?TU42WkVXLzNsNWxmUkpleXdHTGdpWWRXSUZ4eTJLWjFEZE5DK0Vjc3B3bVVT?=
 =?utf-8?B?TEtyWno3ZW4rcnE1WXBCQmNXUFZpS1c5VkJVeXFNM3RCV1F1QUgvdUR5R0hl?=
 =?utf-8?B?U0lodmd2ZnpYLzRkU2dSWFA1OUtScWFaRjdVQTh0ZjFHeGZ1a2U5UW82MEZv?=
 =?utf-8?B?b3MvdDJNbVBTcU1VaGFNdXhWd1R1TUJ1U3B5QWRLTWh2L3l4SUk1MzNVWmxG?=
 =?utf-8?B?a1NWQ1U5MUJMR0pJdUdSN3VkbExweWlYTFhxZkcvZytEaW1ITHo1SDNyTldQ?=
 =?utf-8?B?ZXp2cHNLK3FIeGphRkxwNm8vaDUyZTRHeDV2OEdzZEtlYy9KT2tQR1ROcVVx?=
 =?utf-8?B?NUNHNWdDMG9NdEhmTDdIVnlJYVYva3NhMHpUSjlBNG15cEQ4QXdhRUNaNTRR?=
 =?utf-8?B?TStKWjJ0czVybEJ3eEYyRHlONzYvV0puNm93bzJzQUl4N1NoMEY1ek94ZDZW?=
 =?utf-8?B?T0lSaTZON0ZaWWQwdjBNaDlmbnlVWHhTZUlSVEdmYkl0dStTRjhwQ1lTR3Rj?=
 =?utf-8?B?em1zTWxpSkNXaktJSG91bFJibmo0WDQyMys2L29QTGJWZnNaNmdHUW42TUcv?=
 =?utf-8?B?aXY4YjZKNDRRd1UwNmNDOHBBOEpIcDc4TFdvOGY4a2Q5bXhySTFkRWhyUDNk?=
 =?utf-8?B?eGdBN1BaTGpwV3dNT0l4YXVUMUpUM0xmODRCN2RZTi9iRnB6Z0lpKzMyaUNr?=
 =?utf-8?B?aFZaWjRtQlJuYU1QbzBJVFVjNCtEbFlLWE5xNGU3R0pHYldZZWtXNko0Q0tE?=
 =?utf-8?B?cTlIc0lLM3J2dnBvS0Q1VHdrRjEyN0NlL2Q2UjlNT09lWFI3eWR5aVl3ZVNn?=
 =?utf-8?B?a01lcmFINlJRNVorNURDYmQ2NXNad3dic2FhRDVPNHIrcExKZnpxSkhwWEFO?=
 =?utf-8?B?WEEwNHZta0wwdU9wbzAwVWMxSHVsMGQ3NmlVem5lc01kOU9HUmlCYWdIcTN1?=
 =?utf-8?B?d1lxbThNYVdrMkF3UXRPdm5SSUw4eU0zVDVITVVwdnl5S3BkL0JqMHdBZXRn?=
 =?utf-8?B?ZElKMHRjVUo0bnZQRkhOdSs5ckJJbUIvWC9LZSsvWnJmVVJKS1hqK1FISUR2?=
 =?utf-8?B?ZDFIcmZZVkhrMHZWRUNtSEhYbEw3WDAxb0tYQythRzJtR3dmVEFlRWlOYUNB?=
 =?utf-8?B?NEltalFrZnR0RmNsekdKYnF4dzJPMEwxamQ4d3dad3hKYlFBcVZMWDFIZnh3?=
 =?utf-8?Q?8bVpifnDXDyH+496h6QkOzqe0KEnwSjZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nkc3UGV1M3BiQmlqczd2bjlBdjdMRGllemR2d24vOVVsZFNpOEplS3F3Z3Nz?=
 =?utf-8?B?SFFWRmxWbk5WOEdUT3RZMVl2MEtBNHJBcTRXUmhmT3FpaDZsUzZDU2R0VXhx?=
 =?utf-8?B?QkRnbkdBUXZ3N0drR09TRWwxaG1uR0ptaEQ3MkhRNmJxWHZObXJtbm91OG1z?=
 =?utf-8?B?aXRDY0ttQkVKUTlvYlFaV2FJekFxSzIyRWhML1pqZEtTT0VOZ2dYb1V1aThj?=
 =?utf-8?B?a2hZSlp0bnBRYmttR1NCZEtYUEU4enllZWZIYmJobFJkTWV2N3dvQVhKZEIx?=
 =?utf-8?B?VlhEc2hMS1FaeXpCVEYxamFKR2tyMmVaV1JjUkxKOTFjMW1mODVraVVMY2dR?=
 =?utf-8?B?a0pnekZiM3BjajZrdWpRZGkrbVRKa090eG83dkh6cFV1bnZGM3k2S3NzYW00?=
 =?utf-8?B?R2ZhMGRtM2Y0Y1RDeVdydTVCeGx6T0pITFVVWVo2Y3o4bHU2REdpVXFXUkYy?=
 =?utf-8?B?emlxWFFucU9qYXAxSmVtd1RTRnRaL0JIRWFIWVhQRzF5VDRjNUJuU1gzSHBi?=
 =?utf-8?B?ZlRRbDlTZ3d4TWdGQ01FbUxPMy9pbmxqaDBYUVp2Z250N3NiMVZDWWxjVEtq?=
 =?utf-8?B?RERCdUg5S0hkbW5LVlpYdDA4NGpGYkM1ZkFlT1AxUTVmWDlkU1UxdGJPekJo?=
 =?utf-8?B?VFYwSy9LNC8yemhkYjhoSHV5ODIzcGJLOStMN1Q0ZyszM1JjckFyVUVFVkpQ?=
 =?utf-8?B?QjMrR0lXMVVSaGFFU3FEMXRCWVJQVkdvdVRGcXZ2bUl5TUlXSGcyaWFIeHZn?=
 =?utf-8?B?UGRSbEMrNGFlNkoyUFc2Z2o5SWcvazFjVWxyY2pERE1mQ1JPUHlwZlBNNndO?=
 =?utf-8?B?Zk0wQ0RZdkFPMFhGbWRDbStON0EySjBNWjJMMkFOaU93ei9DOGlRRFgxbVNk?=
 =?utf-8?B?ZnByUk80QjNGTlFEbWdTSjFtN2g5Q1BtQTBjUEpNME4vejgyWXJFUkVuRFds?=
 =?utf-8?B?TTVSOU9KU0JuSjlzVkZSSFFFV240ejhHbkVPTjFpd3IxaUdGdkNLbW53RFNm?=
 =?utf-8?B?Zk9rK0RtTUpiYzFWa2FSNUlxUHNrWWI0ZlF4TW53U1RRYWo4dXBsTzdHczRV?=
 =?utf-8?B?elBuWTlMckxjZGQ4K2J1M1ZkUGlXRUVNWnRrR21sYXZRV2JlYWdQcHVZclRM?=
 =?utf-8?B?L0t3Z1Q2RkVYdlFHNk5pNEYwZGluMmJFSG9BdDlneGN3MndlamR6TDM3ZHRp?=
 =?utf-8?B?UGpsVHRSTlZaa2p5ZXdtRGYzaHBaTGplT2Fma1d4Nkx4d3hwRCt4SW50Syto?=
 =?utf-8?B?SXdJMFA4L0pDWnRLYUpGSXl5T3hMTGtMN0NTdmY4WkdhMUtLWkdZaDkxODFM?=
 =?utf-8?B?RzdVSHlxZjh4SFRhaVAxMXN0WllNVkNpR3RBU2FjdFdGNjVoTUVSa1llcW9U?=
 =?utf-8?B?SEgvempEekQzZm1lM2p4ZU5xTmp6ckJFbTAwU1VNdU9ubDQ3dVFWQWVobVUy?=
 =?utf-8?B?enFSbER4V2FMaWdoMDAzQzBrTlR2eTd4THFtMktOZmRtZzZIaVpaWlV5d091?=
 =?utf-8?B?dW5wY1NydWIyZllsZXZXUEFjQXJoT2tGRytPeDNuVVNBNXJMeCtHbXlkOHEr?=
 =?utf-8?B?NEZVTkU3SmxMcGVlVFYyejMzZVpEaHNYdVBsbWVJRVducHpTTnVWdjNXNTNo?=
 =?utf-8?B?c3hEVmtseGovMG5FdVdBbm80RGZNRWQxQVBmQUJicFZzcUtTMUZkdi9ETjdG?=
 =?utf-8?B?cWFCSUMvaks2bWJZSlpoR0cwVkNZQ2xZODVlaHhEL25TSlhVOUJNekVIY1g0?=
 =?utf-8?B?TUFKVkNJcWQyTWFWTmgyUFRBc2xwQ2d0VkxxdTBmZDZ1VVdsQmhuM3k0amJw?=
 =?utf-8?B?YUJxck1ualh5M2ZjTStkdXViY0VpWjhoMTk2Qk9DeXlQRU14UEZ2ekhTcHh5?=
 =?utf-8?B?U3NrN1BzbEJWZ2dPcENaV21lR3dGeUVkM0p6ZFM2SUJJc3JtaGdVMzZOMUxW?=
 =?utf-8?B?ckc4cDBTVUJOVjZGQ2JmcWU3Q0ZMVUI3MWFvc3lvOHh4ZnBFb1lIMnVKOTZO?=
 =?utf-8?B?cG9zYVFoeCtTcDVFSFF2RWdaR0s4dG85K3NydnN0cG1JT1ppL3VVRFlGcVdo?=
 =?utf-8?B?VFRuSUllVlpaN1lZMEs3Y2R4RXFkZDNQVXZsL0R3Ly9HZ0tUd0prWWxYSXVx?=
 =?utf-8?B?T3VhRVFLblFKbXpTWnpCd3VWR29pT3JjU3M1bnI2SnRLTS9JQm5tQS9JZFN2?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 786247d0-2c39-46c8-e288-08de125c26a2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:46:52.8946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xYsGf1X1MNYSTsi/H08w2jSKq5+eGMvwW4BVR7yuutUya5cGVTzN6UMfNd8dn+j1lxQ6zzlYw3+lxymoHv81BWGPftgKmsIQR1LTYv6AnpY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7323
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> The L3 resource has several requirements for domains. There are per-domain
> structures that hold the 64-bit values of counters, and elements to keep
> track of the overflow and limbo threads.
> 
> None of these are needed for the PERF_PKG resource. The hardware counters
> are wide enough that they do not wrap around for decades.
> 
> Define a new rdt_perf_pkg_mon_domain structure which just consists of the
> standard rdt_domain_hdr to keep track of domain id and CPU mask.
> 
> Update resctrl_online_mon_domain() for RDT_RESOURCE_PERF_PKG. The only action
> needed for this resource is to create and populate domain directories if a
> domain is added while resctrl is mounted.
> 
> Similarly resctrl_offline_mon_domain() only needs to remove domain
> directories.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
