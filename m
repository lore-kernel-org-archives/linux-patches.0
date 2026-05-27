Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C1C2E414
	for <patches@lists.linux.dev>; Wed, 27 May 2026 01:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779846557; cv=fail; b=BBWxrGif0aEh+4Q4zzqw87Wfmgw+H2NotBpDDK9CQhOLV4t7SIrID0SNGNxT0aI8kcDupj7tzaBqOTiYgFadvvnUxCj+n94gUhONHOQl4HPCE76o7Ql/Znh2ml+QYjRIlytSH0+xN3bO+R8EAvykj3r5vpx++5JkNg3GvaNF2ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779846557; c=relaxed/simple;
	bh=DdidQ5sgIAKU3Pe/8tlOu2IhH1wI3dEtaWA+5PLaolA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j46bgYWmP2DRdOimerjhoeTmVv9WhG4xnvHUChDtpNhpUd4ZeI80+4An1ZBYlrkzc/AlQi2hvcbrufwD0PoTZ9QwhFt7Q5j5T16/qSBRaEiPrVYoL9NPd4pXMketgEN8Un6MpfSEEvlj7acFJXa0wFFLiKp6NHD6DCtWnyfebxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KDbdh0VZ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KDbdh0VZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779846556; x=1811382556;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DdidQ5sgIAKU3Pe/8tlOu2IhH1wI3dEtaWA+5PLaolA=;
  b=KDbdh0VZAMHHGoJxejsPCF4PtEAgIdURSDZcalJjAFh0ijnMPrsg49cU
   FZZVOts4fPZeCIXZ1cm0HFX6iiBQ2EKHTzgoE12sslBOIqeJy4/F+Ego4
   slo/TWZ9SHaFvTpVrQaAsHg9fiEHhPnpDqolB73N5a9vbs5oWizkfUgaP
   4gHqxxhbXtS9joBwe0Dv+baqJSTI/BA6tzNResHs0lY/ra/QrD7f47fRg
   xrRKS2Ehi3gM1ahun/gH8AqabQMkNaEEtbs3iszpcKGNAV/5Mf8j26is7
   CXl22q7E1ym4r1BUhRRuMcDxwvXNGq2u/HR7gs3rJpH3/Vd3msVnqyGCj
   g==;
X-CSE-ConnectionGUID: S4Idtf9kQ6W5kVVsRsHsig==
X-CSE-MsgGUID: F8kVggOYS3Kwdjd7ETdOTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="79819523"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="79819523"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 18:49:15 -0700
X-CSE-ConnectionGUID: fStct6asQUSB/J+Y8Bawcg==
X-CSE-MsgGUID: hUd2JdnQRB2yaWQWHzwGCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="242254621"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 18:49:15 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 18:49:14 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 26 May 2026 18:49:14 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.12) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 18:49:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XklFHHI4zMpQomIF4BjVpymN3c/ZYV8OwdT8CZNkWmDYUVA6HCAH2AgNqzkvcsOFrh5KW3ci1F3E1RicFoak6SKSq4ShngIByRGKkdlqFqEPRXAVxWXE3/0UDhmjKeQqzDbpDd7f365j5YzO2OgBBzT9KRLl5XcwSYJtpoQVoWwguHWi9ZoocLjm8i6IykLaqmabtfD3fvrGmiL9zGdF29+4hVy0EBvieltqtfyao4e8DEnAng9DcIdabJqSZKyd2ahZJ8A9g/L9NdvdtyrfPaLpAo2BrHsS5FFMDkhO+FpRHh1PKhB07zRbJt2DjVPGCujtEBiFGpvrt1/NvTVryA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljSYBR0eGVXGCJtr3hvgFPj4aO6TO3EmgZIfROcMb7I=;
 b=SM0lbpAqOjvLbp63O6OH5oVsBrlexKNUkt016za/NgJ9qNnSEJcUcvd9QvmrtimcXTGBA1mgtiDJU6EdiOqSwgkuiuGMYUkJmne5Rybdg+VIFuQV5ceNa0QbbCIZ0BlYghwwL7+mZSOhpNNe8wPZHYfJ8yD5g5DCBVCI+s8HwwmZm9QF+B6K5ArQzl8vT+1I8QEDQXv/XqO0FtgxtP+wX4r3ZRRFjui1qlzYnUyi93vF+jg2AnTJklm+FKbGgo9cIxs4Xm+YSahMjOEJbtSr6ywsrUJLjJBNBSqE/WsxsFaNfJ9E2HqDGrsL3KAknHqAWDAlfd+wa2y0Ob5DylYvuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ5PPFC15A51B16.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::851) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 27 May
 2026 01:49:10 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0048.019; Wed, 27 May 2026
 01:49:09 +0000
Message-ID: <c1fa0502-974d-4bca-b595-274cf8467458@intel.com>
Date: Tue, 26 May 2026 18:49:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] fs/resctrl: Fix UAF from worker threads when
 domains are removed
To: "Luck, Tony" <tony.luck@intel.com>
CC: "james.morse@arm.com" <james.morse@arm.com>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "babu.moger@amd.com" <babu.moger@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "ben.horgan@arm.com"
	<ben.horgan@arm.com>, "fustini@kernel.org" <fustini@kernel.org>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "peternewman@google.com"
	<peternewman@google.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
 <ahW9EJORpIqnvthk@agluck-desk3>
 <da9ec0a6-8ea6-4b85-b4b2-6f4fbd32f687@intel.com>
 <ahXl_UF66yiPiEPB@agluck-desk3>
 <d5ead3e9-f878-41ce-98d0-ad7fbcd778c6@intel.com>
 <SJ1PR11MB60835670CAD544BCFF856022FC0B2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB60835670CAD544BCFF856022FC0B2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0242.namprd04.prod.outlook.com
 (2603:10b6:303:88::7) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ5PPFC15A51B16:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e336de-1d7c-4086-3e86-08debb92251f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: UKirdsa8/NbNYKesKM7SVwmQh84ONXfAgNuvh9+qkoMXwllTtuXlZrCMruuMH60jTBG5Iq+Du2Wnze5QkyA28o9h5167ds27IuXMDYJjJCHJyZ15NhxCFijfDY182PpiGqnac596eejxoX0wAYbcEZhYqbxsGNtuJ52SfZR2J1xw9YjzOMq0PSWL49Cr2fJ8MR2J8Bof3m1r0EBpBO6Hso2OM4H+YH1Q3oYac93V6WTPwW7dUh59cR0XKIsgwIDVroshH1XLyLUBXacvKa94c4hYL4oL2E8lWN32NqjDZ8mfQZaH9R9GVOLK0x+IRLiNp13cUqZ8EGZ6wz+D/NooN2hYqExHrWMI8yf5KzoL1Uihxj7TUNCe1e3ckL91/cNzaZbnDAAhxLCa0zIo7FJK1CYn+Hq003C9NR053WgS4QB1shvvIi3tu5YsPQdjiKQORIqaHHRxbA8MqnGXvo+GaWJQAzAOeV1PYIuPlCYE1To0WtHx32ehpgY8Veb52W6HCWsS48MyCZiiF/xBdZipziYZ2ggcBFCpubp9/s61sUOhUhLtR8BuUCAmggGqfeFbKuk7rgthMSMktfy2gvDOvgehIgtcNCY4c3Oj5a70RqyCze3TRPcqPyndTmSReoSxuCc5xNQCVg58Nxds+fAQMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blBMaWhjeWpmMWZBK2RpTXNxVnpCZlMyT0Z6aCtFeGd2MG5JWndVNVNLcDZ3?=
 =?utf-8?B?QzBlR3BMQkVZTm5KZ3o3OERIR3Z6T1FSU1dtVnZGWlVNWGdORFErVVVzZG5o?=
 =?utf-8?B?NHI2Uzd6MGVnSmpxRDV0QzZJaytPQVAvR3R6K3RtZ3R4RGtVS2QvL1FFZzd5?=
 =?utf-8?B?OCtoS3RiTnpDeVJiYjM5cHlEQTBYNUt4RU9GaGR2QzR2RnlKL2piTlZ4TzJj?=
 =?utf-8?B?ei9kcnRTZ2pLazdHcmFzdTVndXVXdnR5YjV5ZmFNWXp5M255NEtFN2Zlc1Iz?=
 =?utf-8?B?Z25KSlB6T1hsZTlMYjcwOXl1QlAyL3NtWC8rWmMvcmw0RXBlQURhZFhvMGNi?=
 =?utf-8?B?bGZjRVRIOHhFbkZQUm1ENzFlSDJwcVVFdzRvUE5MSDB1MWZjTmV1TzdzR0lH?=
 =?utf-8?B?bE9EeHRwV0hEcElVei9NdWdSa2VzSXoxR1RnZEJ3aHMyR2NhSDdxdnBqMm5G?=
 =?utf-8?B?Z2Y1WEJaNS9yRWU4dDU2NnNsNzQvYlkycEVDT2owOU9yWlkvM2xONVBVYW5k?=
 =?utf-8?B?VitKSTZMeGZSSUFIRVNmZ0MvM3pEM3lpZStkL2dCYlo1cy9vYWI2cG9ldlcz?=
 =?utf-8?B?TnczamlIWkNQd0lPMUVlaTVaNnRTckdUYW1tSG5IWnB0bW9Eb1lhZEwvUXVI?=
 =?utf-8?B?RHB0VkJjMTBpU3pxaXZFc2pRYVI5VUZWZUFxZTlZRUZoZ0NzaS9LY0tKaFVx?=
 =?utf-8?B?RElTTDRGVHJ1ZithcFVJTnBqSzFRMW5RaHEvVXJLMWFwclEyWkpEaTVhVmJl?=
 =?utf-8?B?ZWh6Q25oUmQ0WG9ZZnAzaW92a05VTitMVVc4NjJBR0I3cms1MC9ZazQzSjlE?=
 =?utf-8?B?bU5ZRkJacXVrdzVUVnpQSjl3VGIyd0l3U3BvUStuZmFFeDhuWlZSN2dGY2JN?=
 =?utf-8?B?TXM0MFJITEtsMUdpQnlpWnlROUs0SmZHMnRmYUREbDVCTGV5cFJFcGg1RnNr?=
 =?utf-8?B?YWUzNk5JWVhVOWhWOW5SMmFxaC9mNTI2NHV1R3l0ZTlFYUFnYmRrM05rRUo0?=
 =?utf-8?B?R0ZGeGVKalB2bUNHTXh2TGRBbmtzanplVmdZc3JVQlJpTEJZeTVtQm9NbTdD?=
 =?utf-8?B?SWhvVEVmOXU0U2tpNHYvTzZiV3BWZ1QvQkFLa3NkZzdiNnh2SzNaYnc4eFRS?=
 =?utf-8?B?REdyYWZscjYvSzU4WFcycTF6ZndiOC9HdDBTQTRJL24vdTBsZTZjZE5wNVJl?=
 =?utf-8?B?Qml5dTJIc3hybUkxSCttUkJuYTJMR3dCd3dOc3hWQmxEek9DNGVqUGYwMUpa?=
 =?utf-8?B?RWpUeGkvbDNDSkgyWGlMd0JlL1h1VEM1NDN3UzJZMnNBakZpOXVhaGl3QkZL?=
 =?utf-8?B?VEJkM21MZFhNOHJPdlZkNFc2SFd6RlV3NkpuZG4xMWJ0djhNTjRsL2tnejhv?=
 =?utf-8?B?RU9VZW04VTVkZnVKOThUVHdQSkJZbkpPMXRGcGgzemZ2Qk1XOVAxeVFWNGs4?=
 =?utf-8?B?UUwrdWt0d2E2UXV4UTA1UUtYdkI1UUxSRGtqYnIxOVVhb0ZwM3M3dWZOanJ2?=
 =?utf-8?B?d1lhMUE4WmlEU0xjMDFhd0crYktOczVmUmN2bmQ1TFA3TjUxRVVlM1FUa01N?=
 =?utf-8?B?eC9WRXhxZnhvK3pMTkZtaW5IZFE3UzIzTnFxYURkRjVvd04xeHErZ05MdHFm?=
 =?utf-8?B?UDU1NW5TTmFRMG5rc2JMSWpUL1hLN0VhVGQ5Z3pJRXZxckt6L2x5Mkx5YmIx?=
 =?utf-8?B?a3ZDdHc1SWNBRGFXN2dxcFZXQU9JUWxyZmpBUnk0bnkvOVBrNHZmdGNyL3NP?=
 =?utf-8?B?WHRIVDFUREwxVEtjcjAzNk8vRjBwVjhMMEgwcm5vOVY1K25pcnNVbnV6SXN1?=
 =?utf-8?B?U3N2TDhHc2xJSlJsNjJnT2VRZHk3bUlyZENJVlNCTnQ0OTVacG8zRDNhN2FN?=
 =?utf-8?B?TmhMMjVDbmxYR1JqeEFJUHovbWxZeDVUTm1qVDVWcktjVzZodlZzWEVScFp0?=
 =?utf-8?B?RnpzU1dpVEh6UkROVDU5SXhMTXFsRXpZVXNZZmNyWUxsZUZBNll4bTlBK2Nh?=
 =?utf-8?B?bGVqL3l6ajJTUFhnN1ZWdHR6OXNTMUIxbjhkTG5tWkVmM1RaVEFRZEJxVVZa?=
 =?utf-8?B?MGlQQ252L2FHRHhreFlwdDVpb2N0dFlvVVl6V0ZPa3NjcmJhenhYbTRkcUQr?=
 =?utf-8?B?VHd5dHpKSG44YXhFQW5TYVpSNUF4amEvMDQ4S0pEWTlOSHh1RklVeTlCaGVL?=
 =?utf-8?B?K1dZb3VYeEgyVWRXS1BESzR0MnVKN2VINTBudGxCVnpFalJzOTUwTng3alR3?=
 =?utf-8?B?cmdHMnpwNjd4Wko1Q0lxNGpKanorY1lJK0EvRzFWWVhEU1pQbmwxZ3p3Q2sy?=
 =?utf-8?B?VWpTSnZvTklIK0E0aDRBNEJrdjZXSGZlSGdGZysxbmhuWkFTRXJBb3NZUjVZ?=
 =?utf-8?Q?tvksRAee7Qq9pW0M=3D?=
X-Exchange-RoutingPolicyChecked: d2eam62xbXN/kNqrzKJmQMMv8UxZn4K705eusbteaNqWrKuzSJimDXEtRuUE8FvQusJSUJJpS8u7sZiMEtkJI9fX25br/7dfJ+ZAvrFTPF/d9IeUyLxPBQSYw3mnSH5TDq9Aq4g8B9idY/uBMurx3ZSZ5mfaUMy/d17d/i6vMBuD0EBoE3nT7pNPNX5tLGWztxRR+0L8dl1OWZAn2t0vcPoGKSQWvisbi8SlWWp1zlF6BgIiYXgpGgwukwyrzM3xZXk5wYLY3834wlzsBRitcb5hB2Gp4xRdK6sOvl8eX5LkeFcJDHlO/0H4mb5aqdY298ayyFuXuGHPkHEQibm81w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e336de-1d7c-4086-3e86-08debb92251f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 01:49:09.7856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3HB0AipkFdEtN/MncDMaxNgZNYSEw936V2H8IdFZOfRKDY67SZ5HN70Olvk9di2vIqNNd2W0FMgkSW/dPX5MnSBo25KXrWOfbyB+YYbYwBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC15A51B16
X-OriginatorOrg: intel.com



On 5/26/26 2:26 PM, Luck, Tony wrote:
>>> Can you repost just part 9 (or maybe parts 7-9) on top of latest -rc to
>>> see if sashiko is happy at last?
>>
>> ... and then will you take a look?
> 
> Yes.

https://sashiko.dev/#/patchset/cover.1779834897.git.reinette.chatre%40intel.com

Reinette

