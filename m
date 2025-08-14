Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C955B27702D
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208324; cv=fail; b=brHYjU5LcW92ViQpnwne8tLrLYwJqQz0RFkAJtW9ds+7qQrqkT+rzRAgG3MLN3kmQXp+qBIwcgCJ+M/BXvrdopSVAMiRmVujKqJtScZHBgz99mzeUPG5owC92scAs65ohKlmUIq7ux+FO5ngIveujiB1ewSm5qf8AhMSJrzxSI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208324; c=relaxed/simple;
	bh=KlebOjaKh7P8ACXe75Wu0abfjqUF+91rcAZXwq2mgRQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DcEr0IjX4ytEr7pKnD1oZH1NBDs4wh7KNkNidGORXet2F5n3XOqlntbTjJAvZC+DVTCClyQVPI+m65HwJaQ1yR9AzFN/X/hf5Es+3erfuhkDcVN8Wf9EmbFDNrTHZCKRcrehC0ZVdi/fCjDSND1Az1PJge6RYXOBkrDiOGO1wrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kkitf4G2; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kkitf4G2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208323; x=1786744323;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KlebOjaKh7P8ACXe75Wu0abfjqUF+91rcAZXwq2mgRQ=;
  b=kkitf4G2cla3ssOAdWY82aVP7cY/yIhpcKijKAwv3ByRYLEWYLGnRKzu
   3iTwVv5/RNyolBin6CJFIyZ3t3MGggJbMloKPwdr/bILmGux0549N9OfY
   axulGqPYerTeYY4aD5Rq4uuIlspqhovnvZGrdykil9HWI9gdD4hpDaNhP
   q2JoRpRwoAqC0F/WK1dQtSVAD0CIC789T0FduWsJYct0HcZZLaNiPTMiW
   5QYzC4pzQpdQeQk70Bwb92p1rrKvDFHV/54fTdN17t6fazsvbpZx7DiFm
   C5kwD/zsg57PExqv//VKvRb64ALJ+eEMUjBDoSaG8vbuTuN2sQc+1oRc0
   Q==;
X-CSE-ConnectionGUID: osvKIFRNTK6ZT4Bs1ZALPQ==
X-CSE-MsgGUID: OF8AdKokTEWMy4ZwwKkoIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="61168168"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="61168168"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:52:02 -0700
X-CSE-ConnectionGUID: t197Im4DQra9Fkv7pDb5iQ==
X-CSE-MsgGUID: OHDDnG8nSaGdoRW14DV8Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166498560"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:52:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:52:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:52:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.76)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:52:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U1Iz/tuVf5dxcydhbDTcq+OtqIRci7g4cYHdat68/u5g0hxIwkwxwxW4Adn4HY8R1hgGJkdHuDL1KQqYQqCU5bl5DYVeDmyvS97ajN+N3mlX/eCQXCCZPQ2FqZdUaABT/Z8d9uPpAfviAkZj0LGmVr0Fah27hUKpj3aUdlVPsnnj7sZe/g7WPHkxOZ9narYdB7MZ7Rt78VZHeZlj7zd0gpIWhKhr9y14v73Y164G7wD78ArhF6T5diTiiFlWqQ+yyIr0V3iyCbWqe++Z0lmySZBqOnTcjH7enZ+6tmY1yDJn2/Rpt+mMmGMiGpv+B9ZlFRFCWsupRzG7cnI/sieXaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nF5yt6h0rZeufOHR5abIu1ig2M/FE+gsTAx8oKrOzR4=;
 b=VQBEPCxBzGFevEmDCEBfpDwKyIalaqMvnGUB7Prdfd1tXADzoUzdYrK/9WONe1R536HNW/kBsOWR8H+ij0DXMJN0ro6dMDlJJp1ga1RzU3o+VHH0sQcs6psj/fulcJADGQdkfXQL7OeFl8njhHNR32MxmWqzkeWjDRTVFnWGXeUEPZm9bgUSpNBq6yQk9RCtizMC7P1Jei0rrxvy+14mouDAb+x0XgUS3gXqJ4VRruUa1wydVA6BhrnUXQ7ctte5CTjysF8TquQPzxQ7GDotSPEsbOs+V8n0yh+YVzqLOX9k9EuW6O+yHnIg7/gdER/N+8xpJS0I3I4LBNJFXki/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF5A636EDE4.namprd11.prod.outlook.com (2603:10b6:518:1::d21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 21:52:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:52:00 +0000
Message-ID: <bb85b3e9-d10c-4b6a-a02e-e67a439b5a29@intel.com>
Date: Thu, 14 Aug 2025 14:51:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 24/32] x86/resctrl: Add energy/perf choices to rdt boot
 option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF5A636EDE4:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c195760-7123-493c-f1d3-08dddb7ccbd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y244RVg4RVRWWFVtaW5TelozTTFJcHJJTmlFSjY2dVB6Qm5IYXE5czljQmkr?=
 =?utf-8?B?c2lOZzNVWU5YZVZrcGlVVTRrZGczeFZJelFiNnZ3cFRBZ2xsVExvdUVtQmZj?=
 =?utf-8?B?VWdTREwzTUp4M29HZzFYUDdKVEs0QlhmVW9IN3hYNDF6MC9CZjZXNm1LOGRH?=
 =?utf-8?B?VVdHK0IzZWFTeExiUTljM3NaS0pBNzBvMHI5YTJjTlc1TTN1b3FDYkFBcEg2?=
 =?utf-8?B?aGc5ZUhMWEpUblBSRkJjOVRqYzNNL2x3TDc4TGxoQ3ZNMi8xcHhJbE1sajZM?=
 =?utf-8?B?RENscmdWdFUwaVBONkgvb0x6b3RPRE4yeGFFWXdIRjNLRlowVFBpQVlES29L?=
 =?utf-8?B?R0NyVm5VKzFBbnp0NGh4N2tFNlBxUFRld0pMcC8ySkxORC9VNmE4UWxPWWZN?=
 =?utf-8?B?MTFucU1md1FqT3ZMQzdYcWNTbE9JcVJNN1pqTkh6cTRTWWpoME96amVUUjd1?=
 =?utf-8?B?U2wwTUZwSUtCdDM1cVZ3dFhBTTZVTnJaZUpxY255Qm5oUXFJSURucys2TVdJ?=
 =?utf-8?B?QUpPSUErQ1dtMjRiK09lOElaTGJtM0NCU3B0a09mQXFmamYyMnhPWFQ0Vm5x?=
 =?utf-8?B?RGM5U3N6WHdLVWgyRkR2QytSYS9BL2FiVWo0ZWtzTWVrYkR6NDczdDJuZ0d4?=
 =?utf-8?B?YWxidDBIdExrbWFHZ0w1NXNTU24yeTNKWGFoVjc5REV1emtOWVZ3cnM0b1pM?=
 =?utf-8?B?V2xaLzJubUxMSHNkckNPZ2dOTTEvRWo4b1cvbUtHUzdyYUl1UzA2b2c0U1ph?=
 =?utf-8?B?MjRqaDh6SUt3L0Q1d3JJL240bUs2eVhUVXdRc05HWjFaaENHV0lmbWphZnIw?=
 =?utf-8?B?Y1RxZ1ZFdG9SWTkzK3VNbmg3aG9haktnNGFkcWRreURsWE14eFpCRGcweXUr?=
 =?utf-8?B?NHBRd05GUHlVZjRWUkpoQ0pBTzVvd2liNndHVWI3cjBTNmhDcFE1aXgra1B3?=
 =?utf-8?B?K3JlL0FZblJsM1lLclRIM3NqUHJiUVZoL3NwZlZLNk1GeTc3TmdMUDl4VGl1?=
 =?utf-8?B?clcrK3BZc3pYN0dLTkFVdElERnh4VE5vd2grMFdicXBEaTgwOHV6cjlyVDhl?=
 =?utf-8?B?UTlXdE0zQmNqdkNlYmU0MWxhNytRVzZlYTdTTy84RFRGTjNFaWZJaGYzaDZ4?=
 =?utf-8?B?WXEvUFRyUjNiTHR1TVg3SWFSQzBBWEpoWTZEREJHSXp2SkJ3VnNRMFIrR3pF?=
 =?utf-8?B?dlpLR05BRy9PVGpuQkkwY1VCbENZaml1ZUFCWGc5SDA3VmNhd25zT0RXcjRF?=
 =?utf-8?B?YTl3Q0QwWm90QWFKbVBFMEIzcWZXcmRacnpzVm8rdjZBUkVlQTM2Z1JlWkp6?=
 =?utf-8?B?UDYrZXhxcFhzamhWOTdSR3NCd25jVmVZTEpTUGtQeFRFSlJGSEt5SHlyRGk0?=
 =?utf-8?B?Z3Q0bEMzQzJuTkJFeFlyL281TEY4VnFrSCt4Yk9NemJiSGZ1U0hIdzF2eENI?=
 =?utf-8?B?b2tCTU1NSEtYUEUrYVZ6dkwvZWgvS3VITTB0REM2Y3BNcksxU1NLYzVzTDRY?=
 =?utf-8?B?cXhnNGxyZ2RlMmRld1dhOGVnbU4wSFpKQnVvemxzRm0rWG9aVkNJUmM4ZTNB?=
 =?utf-8?B?OHZYZWZKVHlnMlI4cnhTMkw2ak5ReENvVE5icDdqSkZDUVc3T281QWIyN1dT?=
 =?utf-8?B?cEdRcTNEZjExSXB1MkQwWE9GRUVYanF0STl2N0xlTmNWcUFSZVphSldkaDl3?=
 =?utf-8?B?cXBhSmIzandGRWcyT0hkcTdYZFV5Z0hvcVV6SEpkQXcxbTV6SnNvRHY1Vlh0?=
 =?utf-8?B?RVJjOU5GeW16U1Vzb1Vwbmt5TmlJNzFRODVNbHhiL1I5Zk9ENEpmQjVJTGU4?=
 =?utf-8?B?THRXaDNsSTl5M2Q3TVZXM3l1a09FMU9iay9aTTdhVkREMXd2UWsyQ1ByYlZw?=
 =?utf-8?B?UWdLYmVMSTl6Z0cya21SYnBLaUxpZjVyM0VEclNRTWg2NzlQQXNTREJNcGcw?=
 =?utf-8?Q?8sk8TYPeh9s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmJtU3VUMVIwZ1A4M3NQVExTTGdzY0l3RnVUUzkvTVo5YTlKb1ZUSURkWUNw?=
 =?utf-8?B?d3hCcjI1NjlDUlR3cEJMcUFBUW92cWl4NjJ1TndwbG8wL1hXanRodkNjZVlP?=
 =?utf-8?B?ZXMvNlhsdTRuZTlsbDB1REJLVHlrNW5aMHlyUWs4a2FKWGVhSFRvRStIOVoz?=
 =?utf-8?B?NjdpellMZTdnUFNON09pREYwZk1wZ1VWNjU0WTNQNnFKREgzL08ydjZDRE12?=
 =?utf-8?B?ZnB4S3oybGxLTEZCc3lyRVVqVHAybks2VUhENmxZcldGS3lBRlBMcE1GNHNo?=
 =?utf-8?B?Q3FxbFdBQ1RUa29nbnBoQVJGOWJHdU1DbTJETTVNY0x3OWRXUEpxaE9FTWs0?=
 =?utf-8?B?Q3FVMUp2NUZpNEdYdUxWa1FXR25VUUdKemtyNVF4dWtta1RxZ0pEMDlvamdy?=
 =?utf-8?B?Ym1QVkNwcXpOMXpmVE1qWnl4SVBHbEF0SzZPV2lLNGo4cUFBb3Urb1dIbHJZ?=
 =?utf-8?B?cmhvY0doeE5rcytJN0VpNEJXaXNrRFZRemxJNlZVNW9JQlc3QXZlU0hDTldr?=
 =?utf-8?B?YUdoTjdqT2Z5ejBvck41ZlBzYW1tbktEcFVBREhveVlXQUhTd0VEWHo2YkpY?=
 =?utf-8?B?N0JacTRPcTJhTS9EdkV6N3FCM01lakJEb3Z0UE54bjNrdGlGTGJ0SDhuOU4y?=
 =?utf-8?B?OUR0ZHRmOVdXRGlHaWEvOEUwRDF4ODF1VlNqMUwrM2l1b3BzRExsZ3hnL1dI?=
 =?utf-8?B?NWZUcmhCTkZiUDRubVZPVkI1Q3M0UE9sdXZjY2REWkxCd3JMNHVlcEEwazZF?=
 =?utf-8?B?dC9LQVdmN2NaQUxwVWNGajRMbWxaL1BGMWI3Vko0SWgxejdEV2k2Vk1CamM4?=
 =?utf-8?B?ejVRWTJPOGR0SjV6RUdSb1ljbjlKWnJGaVRGY203UnhaRnBpVmh3Tk9PcFYr?=
 =?utf-8?B?K3VhZzl1SzJJcGhKS2ZPL0VRa0Z3VXNIN2RpR2NDNXc3U0pRWENZc1ZETFA1?=
 =?utf-8?B?NEdVdEhIZXBmZVV2RXR0eTJmaHZkdXVuSy9IdUpLTnQ4R3dQN1orRkFGZVN2?=
 =?utf-8?B?eVZkYnl3L053VzZNVm9keUJpcnhDMGF5TkdQU3FNWThrVk5OZ2o3dm11YnhR?=
 =?utf-8?B?UTZGb0E4UUpWemZBUys0bGFuaWIwUlVpVlJqYlBEemp0ZFNxNUMyNFBCYkxv?=
 =?utf-8?B?UnUxUUg3bFFFMXVMdnJNQUNKc3ZRWlg1Y3BwdkYwdHBhUTBQaGZROEcySEZC?=
 =?utf-8?B?MGowNGV4RG9nWnpwTm52c0s1SGUwVGtWdVZveEMxT0hoTmswNDl0MEhIL3lm?=
 =?utf-8?B?bzJvMjJJcVo3VldhdWdlMDdIb09PUjlKc1ZvSElpaXpHNHkwUklpaUpsQ29o?=
 =?utf-8?B?VkRTbkVXd1JoU2E3UCtzdDRKZDRjUDMzYmszM05lWHQ2U1h5U2tha3VyTjBo?=
 =?utf-8?B?QVcxMXJmTW9FSGUrMzJWdkxFUUpYdmxuMklsYitUVGQ2VnB4a1RWN2VUUTEv?=
 =?utf-8?B?cXE3Y3R6SHJLbTAzNGJvVGdqM0NZRnU0NUM1T21Pdy91Ymp6MXd5aWE2SmNz?=
 =?utf-8?B?YjRCSG9GanhsUVhjeURsRTVGaWlCdldsZW93aVdBNXA3dWpHbTdnTlNEUklu?=
 =?utf-8?B?bCt3OXdPY3puYnZ3YTMrMWhSTVFZZDIwS3VnRDhYOXhRSUJ4TDVwbVBLVXln?=
 =?utf-8?B?Q3JDdU04SFB6UmdwcjhKL29SaTBzblNYZFFxRlVZSktuNG9mNEpxMUY5cURU?=
 =?utf-8?B?ZmJHcklFRnFpTnVZSEhSTDNNOTVMMTZqb3FPZi9Ed0QrRnp6VG5HSlBqT1o1?=
 =?utf-8?B?Nkd3d1hiVi9wbUl6Lzc0NitPZlhJREhtMU4zUzROQWwvbU5NQmpmT1Noc25s?=
 =?utf-8?B?bGtXT0ZQRENIWnpZaVdOSTNrR3BSRDU1d1Z1MVR4L290ZUVsQUZiY013VVBM?=
 =?utf-8?B?SERCT1VtUkZadlltMzBVNXhaM1hiK1pQNFUydHhsTGFKeHo1Mnc1ME9JRU8v?=
 =?utf-8?B?N2UrK1liVkNxZXY3dHM4UUVza3lOMlZLQVlLVWZScWo0RlMzZEZCZzBBdG4x?=
 =?utf-8?B?dE43QVR6bUtYWmJ6Z2ZYZDYrN0dYR3hVSXozbEpEUlF4TmUxd3A3TzU1WlVM?=
 =?utf-8?B?anpXUFZRaHpPbW5KM0lvSjExbC9CckF6N0xWaWExdXNlbllHdzNjYUNYaDFE?=
 =?utf-8?B?b3AvTDNRY1h0ZHBVU3VkcEM1ZURtQ1V0aVlqZVBWaDRhdERVOGhxSzNmZW8z?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c195760-7123-493c-f1d3-08dddb7ccbd3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:51:59.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ROqFDtYHKwL11B15BcQ0F1lsYRZ2fHq7jPVR1qaSttQzTqzw0wOnjffvAKQqk0U/kD44skXX3Ap5q0+jLsP3pnXv9JQok/TgG/DCXyGR1zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5A636EDE4
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> Legacy resctrl features are enumerated by X86_FEATURE_* flags. These
> may be overridden by quirks to disable features in the case of errata.
> 
> Users can use kernel command line options to either disable a feature,
> or to force enable a feature that was disabled by a quirk.
> 
> Provide similar functionality for hardware features that do not have an
> X86_FEATURE_* flag.
> 
> Unlike other features that are tied to X86_FEATURE_* flags, these must be
> queried by name. Add rdt_is_feature_enabled() to check whether quirks
> or kernel command line have disabled a feature. Just like the legacy
> features the command line enable overrides quirk disable.

I am not able to parse the last sentence.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
