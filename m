Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E8C342517
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 18:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775587260; cv=fail; b=dmreu4NttpbdZdjAFfehdUUF+wIsTi9fPGPuf2/TXcbzsL3S4dPt/2UjxdaLWl/0JSTyBjlPJcp1ik55DQMAvA+VOoqbMrd5Li7vPV+2AM5RlCVhemgh3I/rW+wFULEyNcZc4ytRnPSU4GEl5LYNuR2urtzPzJaI/QkqZafrXvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775587260; c=relaxed/simple;
	bh=Q2QM1LMqRe1rQJF1y6cgXHcUoR7SOPLDaRu0doPOWwI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mqgr9GheAkuQLsSc7ZKOGCF5Uaab28OpIVAfvQ6tZQoQxlgTTMrek/fcIAP9qKtdvFmuyu3/AAvH6FyO1zImRZI8mNH0YxcHNH7R+2IQeyQgNJj8gsrHWu4GaTVVJoQeeq0gNp/wSYZgdyuBIpKNdSvtV7pJSFDw8zh2/ll6EHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WIv41A69; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WIv41A69"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775587259; x=1807123259;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q2QM1LMqRe1rQJF1y6cgXHcUoR7SOPLDaRu0doPOWwI=;
  b=WIv41A69VnWRIHdlUqtTbqYovU3Y4ZkybqD+3CoymTOM9XSI03vmkmqs
   76kaRPUX71w7oRm4iuDKJdbNksDGdpQPF5LwIKxH8tjM/Qlu/4QA2nCEF
   gQQ9lcUVyK8PFQy+vx296+36NnCYZAXxIwhejPCu1KyXggiYbkgNPu5yd
   N5kQG04paYzBOWF8TlovFS6U+K8zvhBHwZG9seBfFU401lYhAJHgqaLy+
   hrbhqx0lB3vtJh1FJ2a0HZPaA8i7eBLlQZeQyaC9Sq/Nd9JKnNR7gvw4Z
   Vwpq/Kn+l6VfoA2RA6xmNgEQqMWvmjESb06kcca7o0C7I69R7x++1Pe3d
   Q==;
X-CSE-ConnectionGUID: T5D542KcTlev1yAETDW9Dg==
X-CSE-MsgGUID: VbdcSY/rSAqd742xqeFa7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="87188494"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="87188494"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 11:40:56 -0700
X-CSE-ConnectionGUID: rdv65Iu7SQ+5Ntru6CVEdg==
X-CSE-MsgGUID: FO/ZwHIiRSCN96KlVdGeBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="225072948"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 11:40:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 11:40:55 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 11:40:55 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 11:40:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQEJVKqIBHo95tjAH1lK6szTEbDp9AGIB6O71ZO4DYtIUdRsz3XN/+96jcV5zUXfExn6mlZmFIwG7c0wh3HPkiwJ61GRBW9g/6/zFcsFvFkj93thG2PoMnTX0pFbqxPAfN/91olh1IPDKx+p69/eHDeubsTaUVnA4g9J0BO9h13l2F6fUuRlaVzk8bW8BYcqlkegeRKHEIGv3oxg736PbhRbiVBwkDf90RA7FyvbB2/KMIC0p4fDwDXcb9DDl1xSRS29uxtkGzUMYXAyxOkq22Rhqmr6jZ8g++rJsW0pKUuTCUAN6+hqb+udrBltd+q8f8MM4INrMGTfTSh9JysJfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1J2B/4ltkfDcNdYeD1nu/+GreVbNcVVnmMJ2ddiOyQ=;
 b=hXeGlkluIX+f6LogvG8Iwoom4GuRD1rfkjX3iktQw8/0W1c0uDe0xaBow3D9PDt/Eet7gHFKVa9yWpl/scsZWMP8kZYxRHH7W5+B934W924V1hXx463dCcJu5dT+07GCVHOqETn7i4i+H7gmI86Uk1s/CGSboxZtyZ7sR7MF5XDkQ5VHdXn+14cFtvsYMdx56pE9R2NwLc5aiCOISVp5dhVqx6DsytPixg3hQOm5ue0POmp0wQPuuJBRugBivakP60vweqDZLTYJo8TNb0OQ0jaLOwPdyWQEfDcOre7S8HTCAczzKl5MPRlrEc4FGxR588JyEwGjLFbkioNbYfJ3mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB8280.namprd11.prod.outlook.com (2603:10b6:806:25d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 7 Apr
 2026 18:40:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Tue, 7 Apr 2026
 18:40:51 +0000
Message-ID: <2d1cb9b7-2f75-48c3-88d3-3c2419298e5d@intel.com>
Date: Tue, 7 Apr 2026 11:40:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] x86/resctrl: Resolve PMT and TPMI symbols at
 runtime
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-6-tony.luck@intel.com>
 <435073c9-02c7-4816-ad07-fdec09610114@intel.com>
 <adVJUSFFypXYp4qT@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <adVJUSFFypXYp4qT@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:303:2a::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB8280:EE_
X-MS-Office365-Filtering-Correlation-Id: 38f3ff24-636c-4d75-727b-08de94d531bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: gCo8MmeKXnlmIve2hjpTaSEQ2cCJaApKZS6q9qRSmVpPBOdKKFo0B43Hkn+85lRbZPgIAbUyBSVlLao3jqBFUYBojaUvyzbspnnCerN+nlU8X3ExFHO3a3M2NUyIjygCblq+W1yjC/SNZEfvUYNLzzZxJUofWQ1UrtfHUwMnb5/U3VK6uy3jmd8CjGeofso3lxBhxckyNMxnmoWNGK7uNTrYtcsNET1YsD4QTAcv4xGxSWsNRjR69nEE+KfBEsgMM2kAXbb1sPLHOVcvUuCzrwkh3JgrK6s/YsKYMatw798MyW7nou5A1rPva+jVLhfg2i3akI4Bvw2atDBATW0NnDIpXreybThVhaclggr8vw5sSR7nAwLGlDdQw4yjc/UVq8YC62cLPdFj+vS0B3fOtILj/sBtLN0y0agCWWz3YOqOSE/27KYg/etxkH898MgWifETgFHTXnrJKW/AdJrEf9z4MTaaIzdhDvznCwEUnPlCwZ2baEWXURBK77D+nOAv2DJ63iL/AV/lYvUShoOvivvLHU+7Bw/QOGUVBXgVCgskeYwSWJeaw90NKWkwQSWeSerjZYO2iFJWN03bZUH9fXh/Doz1TavDFIL1t9wYwdhSYQSQhioEooFJVszng6dt40Z5Y4b1iyBuQ5Zu8pkD6+pXL1xWJQNHr2lrAzx8H8HR3rrCgOS2llDk8q2W0i7S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTltcWQ5OVJGWDdTcFRibnhXUG5TVDVDYkxqSzNQN3FBWnpsRS9JK0NBMHEv?=
 =?utf-8?B?NXRQa1I4QThLVExZWU40N2NTc3ppVld2c2dDMW9VNmd1dmVnZzN6VXBwVWdS?=
 =?utf-8?B?NDZZQUpCYjFDMzFwbnhVOXlBUlBWTTBRVUZjS2pDcldKbGV6c29hZ0Q0ZE40?=
 =?utf-8?B?SCtHeVRhcWY4YyttaW5kQy9EdE1CbW9zek9VTy91ZmJVYmlzYUhyMC9nSlFG?=
 =?utf-8?B?aU04cFJSL3pUbXlGNXgvV1ZEMjdaazdyaTR2Ni8rNldVTkx6VUFFT1VtVnFy?=
 =?utf-8?B?bzdiTVhqUTA4NTVFbTdueVBDUVc2cG5ycFBQSjFyQ0cvbjFteTR5WmV2eUJG?=
 =?utf-8?B?Vy93S0xmdjNpeFFZTm5ySE5HdWw3aW92ZWZSSFhZZm9rZnc3ZmthRVVoQnZM?=
 =?utf-8?B?RFhhbGZoMEt6cFBhbXAva1VwTElQSXVsa3VLdllVSit1cHBNTjNDRHR6a2ht?=
 =?utf-8?B?NFFJdXcvVmdtdFNjcjRuR2QxY24zUGFNL1pVS2pROUdFWVc1bVdJRmE0cGZK?=
 =?utf-8?B?UUJCWm03RjFrdXJjWVhIazlGcVlTRnJ0NDBhS0s2THdMaXgzMWZ2VTRJQVJO?=
 =?utf-8?B?MC9TT0Fjd1pWb01qN1RoRHNmUXVIOEY0U3NnZTJVYm05UWRRbGYwb0ZJZUhr?=
 =?utf-8?B?MkNiMWJQZUVUWWNSTEpHZHdFaFZ6NUl1Zll4UFJCN1FYQTJ4WmFZOTk2dFd6?=
 =?utf-8?B?bEtySzl5ZFhVWDVlWVFNTFZMN3FpYkplUFI1dHB3dm42VTJReVpoY1FpemZy?=
 =?utf-8?B?WWliK3lPaW1RbGxXOU5lNmVDWUxvZjlZazVvUHIwdDdGeCtlbHJnMVNkWHVa?=
 =?utf-8?B?OEtzRFFvcDFwRUQyMnludkVRVDNwMnZFM2RxUEY1YWs3aTdoS2N0RldRZ2Ny?=
 =?utf-8?B?WGFvZzVLWXpCMkxicG5rOS9XeXNWOU9iVktNV1BtTmhvTGRDUzllRnZCc3Zx?=
 =?utf-8?B?cHhxY0hhbE9sYnNlQVc1dllyRjRMWGl2ZWpEYlFrekU1THdkSWxYMW9xUFZz?=
 =?utf-8?B?VGNNY2xpMk5wRDFhYnJvN2U3VXVkSWdCYUtTTXpBTGNNRjZjTStob3h5RjB4?=
 =?utf-8?B?bGx3TmNWaFYzd1ByOGNVZzhBc2xlU1ZpYlJ2RktzMFhuVi9wUVVBMm1zOFUv?=
 =?utf-8?B?YUlOdGx5NjhMVGxVWjU5TzlwWnUrU1h5WmpSWnY5NWR4V29wallSQlgzYUdn?=
 =?utf-8?B?bURkcFg2VWdiSURVY0ZUUE9LZ2ZqZjZVUEU2RGhkZk9UdnFybXhaNFlRMmxh?=
 =?utf-8?B?WTVoVEt6TFk5NU1JVDc0VmZSZFJXTTZUZTVWbXlCcmVPYU53dlpKNFBJU2Zh?=
 =?utf-8?B?VWxpOFM5NDBEVG1qeDVpbWpPNnRtNkFwbkRpdzRnbjBWbmg3L2Y5bEN4TEdZ?=
 =?utf-8?B?dGVzdmZuTDZlTGh6ZERBSnVVeHNFK3FNa0NsQlovWDJkdDIzNkxjL2lwYWdB?=
 =?utf-8?B?cHFhUjRLa0JuM09CRWI4RjF2VWZIWFg1Tkl2cjQrK1Y4Y3lwYnFucjA2ZmpR?=
 =?utf-8?B?aEY0TnViaUJKK0lWNmRPajM2TnM2eGN5OC9acmxHcldUcCtIaU51RmxxSHpJ?=
 =?utf-8?B?WjNndHM3eGJaMUxOSnFjVFpxZnVqWUpOWDM3cklkb3hQa3R5c00xZDVvYkxK?=
 =?utf-8?B?SzlRdE15aTZYU2pVU1lMQVhDd2RlbGxhUXJKdDNNM3d2Q3V1Ukx2VmRsL1dD?=
 =?utf-8?B?Z0kxSjAxa1FQc0E2eUdCTWtBTDYySi90dlpJYWlMRmp0eXp0czJKWXpMN3NS?=
 =?utf-8?B?WTFwU2lPQTZTRjBZUVgvVElDQ0F1NTd0WjRSYUFlSlFPandOYXZFaENBdk1R?=
 =?utf-8?B?MUFIS284eXJkRnd1TC9BczZmVEtjTzYrVnBIM2RweEhGTzB2ME5LanBHUita?=
 =?utf-8?B?ZlJNLzJxRDVaMDlqeEl5ck9pWkdmNWJEQ3BZdGU0VnprczBoVkU4eUE2R2Ey?=
 =?utf-8?B?YWZMNDEvZ0ZpSzJzb28wbVNQODZGVHdUU2lMODh4a2QraHZvV1JhazhJRURH?=
 =?utf-8?B?ZjlYUzdGMUlQUjd0dVo1b2wrQ1QyY2J2SCs5dVVYaVYwNFFJdzVHVk9LTGtJ?=
 =?utf-8?B?L2VpenBSVzJnTGZtakx1MVNxQnBCaHdZQTFFaGk2OTlnVldDMHlXUFE2YmNX?=
 =?utf-8?B?aVhCMGVtNEovaGdJK1NKVGdtdEViSzl6ZmxNZlQ0clE3ZmZBbWV3MWlpS3Zo?=
 =?utf-8?B?Q2ZiVzJuby84VEFNeTZlekY1MjkwcVJCZERtdWFqNFhQWktoL05yclkydkFY?=
 =?utf-8?B?WHh6UVp1emJCY0NZblhZTjMwbi9vc0ZjL1dvWHhFR2NJWncrVVg4dXlQKzhS?=
 =?utf-8?B?SVljWFE5VWlxZ1ZkeWpidXQ2eW5FVVFuVGxPSW1tNEN5OHRRWk5XczBuSWw0?=
 =?utf-8?Q?v29ISlmEnCcfJadk=3D?=
X-Exchange-RoutingPolicyChecked: UFJs8bMQwqUZ1ly5cQJy5cJnWpKx/rIjHnh2IVzVCQpnxmw/arwSWXoFUjPIo6uHuQW4rmOx2RMejEa6VMA+m5jG+hCOvMCCCpwa4y7aRhhCLIE6pOAyymehAn6tQT89IW4CMOn3kJGrP9OIefWRKwSuV8O2p0J1WPufZgDk6+9WQbrJH0qgmb1R5JjDRLzeEYp12myGb9oTuyZAcm6zjmakqUuvy1MOR+IX0ETQ60R8KY5dGEljmPAfuszAqyrehK7cVYtFGQHRNeFoVoav5g1HkvzVRpSSqBXlV06JU+VgLsmLvsQDKfe/bB/YtcDZMBUBz4+bRE8OB4uWGpkWdw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f3ff24-636c-4d75-727b-08de94d531bc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 18:40:51.7609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6lmGL5zALlTSfMMwQd9pFu29qDE/OCK9CxA7adj1+vnJMUvoOXim0C2Ze1geAqcj5/X8IQtwA+5S93/RlLEJ0tHHCjxcQ5O+yb+Wwf0go64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8280
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/26 11:13 AM, Luck, Tony wrote:
...
> Adding a "resctrl" line to /etc/fstab attempts the mount at 39.667. Three
> seconds too early. No PMT events are found, and code in this V4 version
> of the patch series marks the system as AET_NOT_PRESENT and will never
> look again :-(
> 
> I can drop the AET_NOT_PRESENT state so that a retry will succeed. I don't
> see another fix other than to document this limitation.
> 
> Workarounds are:
> 1) Change the CONFIG to build pmt_telemetry into the kernel (where we
>    are today, but haven't heard from Linux distros like Red Hat, SUSE etc.
>    on whether this is acceptable.)
> 2) Delay mounting the resctrl file system.

As I mentioned in https://lore.kernel.org/lkml/e85cd466-2202-4b40-82ed-91e421d8e073@intel.com/
I find (2) to be a poor user interface since it (a) requires user space to
somehow know that the system supports AET and then (b) either delay for some
indeterminate time or repetitively (for some indeterminate count) remount resctrl
to obtain needed features. 

Considering all the complications, could you please provide the motivation
for this series? I should have checked for this first. The cover letter does not
contain this information.

Reinette



