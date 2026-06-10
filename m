Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F0D391851
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 20:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781123695; cv=fail; b=DRJOOyDhL7sRvqQkGTSpSHU5gMxfux3f3UDX++33FPgvMpeJcI2J9WydAeEf9slAsmAl8G5oh4TToM17FmebVKtCBoOexM5XIhZyzwidoBiWh/95ohrNk6jIo5vHZWIqzvDpoOuBhi1+mIWLaE92KH+EHfGzJtwGB9ZyMXptUvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781123695; c=relaxed/simple;
	bh=Dq6QDu8VjQy0+24rVWX+xeetmR5AAZEtkPEkFyisf90=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=psQUep95V5hxmo6zPYnAN4eeMbFBEyAiNSMI35Zsj/2k64W1NaoC86KixXG+gWXZMiodhs0rN5aX4nCk1QalqHbbT5X4gQ3YzDXdDTza/tQvKshwxemBIY0Sf6+/JSHTVniFhN8gvlsxATlktPofZtK3Wg4AkovtGigIA1D7hMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Emky9JaR; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Emky9JaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781123694; x=1812659694;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Dq6QDu8VjQy0+24rVWX+xeetmR5AAZEtkPEkFyisf90=;
  b=Emky9JaRH2iiyd78hWznQd9bpofTptjzeagcyRDJVkGIjydF5srvbzEB
   NTEWeOT/TJEa2d43M54Rfnx9Sh995nJx3OUDtFhB6bTRwH7iPSHKgVzmb
   LZ3G6kJzxDXYw/mm1g8gSCVM1Jw7aQ2Nlq1PCrYueu4vs9wc7DmQ4G5cX
   wLVi2PZOeW/RPXdha6cINiyKmu/xYrwXBzglQOQF3BuT0UWaNZUJjigKT
   VH6oXJ15t/DYPNrmel55G7YYp4meiI2DKfR6l1uCsgNcFfbE0YH5bnvBt
   wvMmzrKhRlhbK85p02iCzhc47WnIsHJ3cILZ3yCRRuzRHZsrHC3sVBdIl
   A==;
X-CSE-ConnectionGUID: AtwKm/isS/+OvDtrP4ZNgA==
X-CSE-MsgGUID: nPaKo9IuQdqMn6fGBe2uZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="99349819"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="99349819"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 13:34:54 -0700
X-CSE-ConnectionGUID: qjC0xzF8Sk+y4/3EevG1qQ==
X-CSE-MsgGUID: YmmrmO4TR8WAJxaMpmwVEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="251376044"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 13:34:53 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 13:34:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 13:34:53 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 13:34:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n8X+O1ingobHq2U1Dr53LXjSw2KMtzWITYvejbvcLOkR3SW1i3M1w38UGjg5Q3l/KIDTd5e9hJO9Fck2JQkWlxmb0r9LqrdqEabeqJ8okeZqvUKVyoz+1oEozNRC/DsMzdCKqlTjCmHNUVrdAWPxM6bn2B3qBTz9EqBEOh8hbBgJphC/LTleglcbSJ7EDjCVlpB8RUirrTGc6L+owUI92+JNa9vT6LDuYe5ZmUjxhL3BibOmmF6o5kIEKZZJiYrs35qtkdY8LtAYhN7+Am57HQxwwRljdBrwIk6X5fP+ySqN1hGrtAjvcdpXwSde3PmBZGq0xCuaRpHaLytD4/e2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paIwTF7mURWrejwq4caeRb2uOnI4IamlF2vQcl2ut6I=;
 b=c7f5WAFgpyAx9cL4w3ntuVTgMm9PMX6E1CBLXYu84Cn/ffyRDc5R2idmCODE+tj+6hRNsEbDanUrTUkNH1IKPVuD4AIfFuX3By3w3353KeAYKNMxKu/xnqc7flpy2B704Gm6jSEat5zoC2x03QvJK39nVCnTeMmU4HhDHVi3XIKUJXB7nD1qzOEgQMQ8KgmaLJXutpLxNGR0cQHJqiGqntX8Bbam7XcikR+67OlTu2AS4bN/esbsNGrOdpQ7mzroutlPgd2s+9MyofOZiWXUHE8VIo9rf7LQxEspHQcHQ7PcZcZKCP+il8xzYWlEd/TU8w6nVu7UTxQid9J524OWnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MW3PR11MB4682.namprd11.prod.outlook.com (2603:10b6:303:2e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 20:34:45 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 20:34:45 +0000
Message-ID: <5295a4a6-6652-4f9b-82a9-8310523636b9@intel.com>
Date: Wed, 10 Jun 2026 13:34:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0153.namprd04.prod.outlook.com
 (2603:10b6:303:85::8) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MW3PR11MB4682:EE_
X-MS-Office365-Filtering-Correlation-Id: a735d81f-881c-4709-2cc4-08dec72fb543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: a/8hOJIEBhiYpnJGluM+LzAg40xgcnH2yb1s9GMJ20Pt4VPcPQcPUNhLSY4JW1TmyYzIbG+z/MoW7/6C6xUBetMuXJWIMUFf5pQO54TgNOH8+zGTlBMvHG5Ve8tcewcBl2s7PXMBo0QApzFZAYOmO/58W5Giwkwe1k8ucMEarYNGVk+ubcbZuOTfrDeDAySEs8zIGfHpCymHpwRa+oEnU7/RE6H8hHLD1Lg7c5FpBQV50ExYN2yw4CB43Hl6J/N3dmX3StlpmCVK/H1fXoOgZ0eEZDwYslnQdU4ar10I4QN+FT8E5eE4Q8cG1K1KA2C6NSvKs3AGR3C0VlNXvZu5M5uNMAdEN86o0GuNiih7KWlbPyIX++cOIEr9Z82SdovNBFDFHVqGXJWDtIvWOm8Q5L9b1qO0OR4Vjox92Dvzz1+xSDDqsT0hzMOPE5cydbPgschtACQw7kTFHy2rvIQgYxDfcfvF97Enna0sYkSii+ebiORRmXYABLZqY5R5J0WxRjvwgGky7VOZYo9w09puRJqKiLRW5RwEdFsYvbWRHQhHk3+nkEHrsPBpOBoRB1vozYFLW9I4sq2YdIDgp74z3nJTNdYeLMw8iDO+HrTf2+iAId0ipGxG2CGvze9wpY+bmbh61f6S8IcAUyjWhjmMg768VqgNxA/V0+yl2E1Iyaq1omhTHCIeboXALKLJs0Qq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0xnSGY5eXV3MjF1ZHJHZnp2bWY4U2x5cWhRcjNUYjY3cWdJS1VTMXhQQk5Y?=
 =?utf-8?B?eWlXYitMVzBpWmp3OG1pTmlOZ2w1MVlQUUVDVU92d3NWNzFQWEJvN3FoUVBs?=
 =?utf-8?B?aGJzcENnSDRoT0g4UU8ycVlicUxQNXpLK0gvdjRVNFYvWmdsaHc4clhrQUox?=
 =?utf-8?B?VGxvaHlOMmVJSHUyUDB0TkZlbjhIYzZMendqemQ5SHB4OWhyNk1HbldnMmhy?=
 =?utf-8?B?SGl4QjJ4aFJzMENSaVY4ZjFSU1QzR0p6QXF5SE5tMFo5OVBOQ1RpQ1hEbVZh?=
 =?utf-8?B?ZVI1TnNNNFFXTkZaUmdtOEphVUpEZzVPU1hrVWNNRExqNS9aZ1U4eUNSR3Z2?=
 =?utf-8?B?QlJUVU9sS1I4RE96TTk0LzBrcU1za2JndU1IdWlFMkJwckVlMmczNE0yWXNI?=
 =?utf-8?B?WFNGZmJ5eTFzV2RIUkxOckw3c1p0ZDE2QllPdkIvQ09Ub3hJRTJobm1LN2Jq?=
 =?utf-8?B?Z2JqY2pIbldRckl5SHFqd1ZCeGhOUlkyRHoxckRWTHdPaEJ6cU9iaC9hVlZh?=
 =?utf-8?B?QmZaM0lvUWMvekFoai9CZyswNFhCaSsva25wUmNGZDY4Z0ZDV084b0I1OTVk?=
 =?utf-8?B?QmtLa2tldFNVb3MzcGo3YmJYMTVFekVJSkxkdEcvNUgrbXZvdzBjV1U3NG8z?=
 =?utf-8?B?UCtVLzJTNUhMbzh2blZTUEEvZXUwWnh6NFZBclVUb3l0U3YrRFhmSVJnK3FS?=
 =?utf-8?B?VGJvVzRvbUhPeXA1TWNTOUNlM3NHQjUrQXc4K3dRRGJHeWd4R3NMdVBTZENn?=
 =?utf-8?B?MmNSVG5CN0I5Tm1FS1l6dzF4Q0lkb1c5clROckJJcUpjL0lubXQ5MzA1QlFy?=
 =?utf-8?B?ZkdGdlI1SEdoVExySlp4dHZBTzloVStrdTBhUEJQakp0UWhYNUxQaWpTOG9v?=
 =?utf-8?B?UHJNZWJMQVl1Y0lMTHkrQ0o3cFdYUm51RlBETUZNSU5PbFFuSjJRY1dYZHU1?=
 =?utf-8?B?YXJDVWEzcFVwTXZ6RHRYSk51WXBNRE1vcmNqSzByYTEwdFJjRWk3bEJXYzIr?=
 =?utf-8?B?cUx3UndmbmNUNVFncm5KZVJXYjRFTjNXNTJscmpSM1JFRmllQlB1QjlGb1dx?=
 =?utf-8?B?T1NJNFY0VHFnOXg4Y3lWaWZqQTJab0hlMHJrb2NmYm9ubkx4Vmd1ZmRZSW0w?=
 =?utf-8?B?NFVHSGZxeU1iSXprR0NIY1BWZVJqOCtWN253MFpJZWZGL1dteElGbURLTkk4?=
 =?utf-8?B?MHZ1QStJT0tRT0htU1h6VU8weDJpdUF5NzRlNXBUT1Q1ZEV0OEMyQmE0eUI0?=
 =?utf-8?B?SWJhVytYRHZuUUpuMkFvekRJTDdLNkx2QXMzb2J0c1FJSHpLU01kcXo5YWQ0?=
 =?utf-8?B?MFB4c1dpYUZja0VWSGJ5azN3VEYyeUg2M3NDVFBWZzZqN3VpOUhtYThzSVNj?=
 =?utf-8?B?TEhlR25qL3RZTDJmSEoyeEhEK3RyQWp2NHdvc2hBRjgvOWFVNGNEN2JZL1B6?=
 =?utf-8?B?OWt2bElTaTUySjZIQUxnL1l3Z2tkdy9SellzdjJ5K0FuSVRQVEg1VUpnV0tv?=
 =?utf-8?B?aWFra0dJdHl5WG9vQ3Rwc2l2QXhCSEt3YllDeExZVENKNG92U0tpb2orZGxj?=
 =?utf-8?B?TmZxVEhidUtsMTBQS3p2TnpsY3JZZkxDYktNZmhydlNsb3hJb3RidzRrVlBr?=
 =?utf-8?B?NTk4d25Zak8vWnlwY1QwZnFzM2EyeXZIQ3A4M3N4aEJjczNtWVp6N0tTcWJh?=
 =?utf-8?B?ZGkzd2lCQVNyY2N0czI4Rnp4Z3NFMm1WQ25BTnVVdlN3MVpCZDl2REY3WUVp?=
 =?utf-8?B?T013Uit4bmRJa2I3Ri9BcVFDbTlEc2lKYzhjTjJUdU4rdlE4dGthbFJOcThu?=
 =?utf-8?B?b0xMeWtEVUROblZiTE8wTFJ6YzY3bHBJQ0ZmbVkxeTM1eU5BT3BxZ0NYNTRj?=
 =?utf-8?B?c3dPNUVWTTJNeU9NZW9yTlFJOG5OWXg5eGVZWTZIYmViam9Rby9mcFJ1K1Bj?=
 =?utf-8?B?Y0FJMFg5cG0ydkFIUnJEczNjV3lGekQrSTJqaVl4YVRndFVna1NFZHlLN1hk?=
 =?utf-8?B?MFZMRjdBRVFaeVI1dzVic2tNWTRZYzNkekgxWVovMUd6QkVLYnN0QjFsZHo0?=
 =?utf-8?B?M2dDRi8vdEFaSEJzRE1GYkR0Z3hqaTBvbmdueVl2ZmtSSUQ2amkwekgxd0o5?=
 =?utf-8?B?M1hjakd1OVAweG9aS2xYb1RvOUM0LzI4T2FWSFZSOGRyK0ZGbDVLeGV2Tm5W?=
 =?utf-8?B?bFVaVzByMjZ0cFprRjVIemtLc3h2R3BsSWlvNTJTRFh3QU94QmJuempTbm9I?=
 =?utf-8?B?SmxVRGtBVnlabGFnV1RtMGNORHpVMVhpc1c3WXNZMnFhRWNDcUNkQ1pWemdW?=
 =?utf-8?B?WWkyejRwSXRBV2ppc2ZXeFZMakdESDQwUlNOSjQ0NWR4K1BTM1RuYTlXaitw?=
 =?utf-8?Q?gZCVBn3XuMsmQcxc=3D?=
X-Exchange-RoutingPolicyChecked: fTIn9aKbjSL8ZeLKSKPaCZSXe0bMh+vjTu8mUt2FW1Sa5g0sLHWD+x2XSGq3q1Prwcboh3C6xBGhdPXnsaJLxJzue34mNl/ZblAbCjJrhWytHIMOdn9wwCQnW/0s6p6ROD+xZTyxzwJanJEnSOngbabzDB/5qHy2qO0SzO74CUkJWzPI+GoD4mS9xEV4yFUAqAA6Wyfe3pnXEgP8OhVJmW6DU+EXithY0q+uELi8bWLHhhyvaBj/62Kp68zSAebWYrUfc1Vj4pUFkywh4V39sz+AVsDPBUqO+vYQyRJ/Am8OnJF1Pko6sP/pgSnLAhXp5vjAoqEyN69Ef/eziTB4cw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a735d81f-881c-4709-2cc4-08dec72fb543
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 20:34:45.3727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqFX7y/zVFvwrK7d19BddLfXTzaeiT/nNXEQdBJCzCtr0q5QqNcPnP1i+brjRXCExlQRM2EC+ZLelYkAJhUIr+i2yCY9KKXP3GvYScHuuZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4682
X-OriginatorOrg: intel.com



On 6/10/26 12:21 PM, Borislav Petkov wrote:
> On Wed, Jun 10, 2026 at 10:48:06AM -0700, Reinette Chatre wrote:
>> After considering the latest Sashiko feedback and deciding to stop adding
>> new fixes to this series, I do think this series can now be considered as
>> "settled".  If there are no concerns with this series self then I would like
>> to proceed for it to be considered for inclusion.
> 
> Ping me after the merge window pls. They'll have to catch the "next train" as
> it is too late now.

Thank you very much Boris. Apologies if I implied so but I really did not expect
nor want this to make it into the upcoming merge window. Especially after learning
about Linus's comment [1] about fixes for long-standing issues not being appropriate
late in the cycle (with v5 already considered late).

Considering the changes in locking I do instead hope that this work could percolate
on x86/cache for a while before moving further. To support this I hope to get few
more acks by the time x86/cache can accept new changes. I should have made this clear.

Reinette

[1] https://lore.kernel.org/lkml/CAHk-=wjt1NiKOdyAMz_DT7NmZ++SizPOhRSi492ukdTnpDzHQw@mail.gmail.com/
