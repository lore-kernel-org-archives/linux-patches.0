Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1283735E93E
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787264908; cv=fail; b=gppQpugNP6Tq2GV2veb/sf4uA28sgjqCKYml+OqrQw9qfIEaO6ben+7/l0rb2cVDD7Qwj9CyDifADK6FFhlCHurTdhbrAoqLHphujYgoF/CcV7kbWnuhVr5DaqouOSUzEncn/unnsEEWLIQDM49La4YHUCz9WzIdcaaSko8frX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787264908; c=relaxed/simple;
	bh=Ybck/xPh13whBdJ2FhDvQUrHFfck33LpkcP1pFyfzzg=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nHf+WGWbOjRgZXk0FwaNgr3jaKm2rqXh6uM/mvr2E3E0nhk6anfe+4NTS1zZIMmpkP8CCY93ju/a9O3507MeJbD42O8GulZsguaQD22mPmnlM9Meu0GBgKFeYBYPxxPIfY4SgbqWTF5NwrAwmVMQFfUO0N4C+4bvbC+f+DiObis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lIzzI73/; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lIzzI73/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787264905; x=1818800905;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ybck/xPh13whBdJ2FhDvQUrHFfck33LpkcP1pFyfzzg=;
  b=lIzzI73/cS/4V/+7Ikr54Ek87HvwndPzYZDil3XSPw7Ls1Zzp0Y9rFy1
   Aks29kWT20kY99CT2NTcdusIMcNW3kZrOZgH2oRU/s7eibIk22qOnosI3
   rFcvnPQkpGcWVEAUTHn26sFQaRvv61qA3kPrfyn8mOhv/ZqdcWrfa352I
   ULuUbWlB6j7Japt88m0x4kBbc08B4K6p43ZDvdpRA0gND3LetoBNoz2v+
   kytSgQi8drkK/mtzIeGKrhgqnUxh5RrcmHVu0pQGzgaC7m9wAkr6VejZP
   MlQe0372JEVnzOVqh/0EcQMBLKlNmp9UYLIOoeCE0Q1d0G/QUgWohA8Qz
   Q==;
X-CSE-ConnectionGUID: hudFXS2lQx2x9ibbRUDW0g==
X-CSE-MsgGUID: uTTj32DTS4SwOaFYgXpTyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="87578502"
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="87578502"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 15:28:25 -0700
X-CSE-ConnectionGUID: QS75FNSARu2EgJqNrkhPQA==
X-CSE-MsgGUID: SiDl0AODRNi6GoCG1SPLsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="262440924"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 15:28:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 15:28:23 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 15:28:23 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.27) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 15:28:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b7uIvUCEoUU87tAaty3HUNhmeRoMVtPOTcNWt9BgmIC3ZilR4NGdCpVNT29LSdvOhi/P/iJTWYJmOaKyfTQok7ilBwM6XAl8t3GvqEA60tbEI6gQY7o4cjnfe/DWLncX4qEhDV6Nr/fgxDcsGhcCDz6LA8aw/pCR4zJNcZxiCftlO9YXP6Gd6w8Mo0GCUjnOsiU8fE/so8akfsX8HWMPzOQ+RODPX0eJewf+p9ORbUP+hJbaZGyd7fMNpOVVZ5sQ48N5kIXVwyXdjyEzSjkogijZCFJVatfFethmzzXtVMiq6QI4lqBLvSl3Gcwpw5MbXEzlfxrhG3vJGclxNh2o4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzpW8J/oGAmyS9Zr8Y5hNBLzPJM7mTl8iDVym5bVCv8=;
 b=x5olPpZJu6BR3Fdh3seX+8uUe1FryC5h3GgszPQ9mbSUQ1FIFhZTvaeXXEmYpHpUWmPig1jw3zADKweh5bzs+1hCETvNO2CbPxzHWBE8DZijzlrUPDn8aBQ08FOi4+Xkur30Z+Aezs+suOS3+hnE3DFbbPloghEDc0ZZt5kaCmH6ljk/9hjaYUBzzwIU1/qt68RGJUkN9d5DKul3j/g9DExrbebmftURQGL0ynW8CWJ7wI9Z+tO87iGImacOQbo5hkQZorqDtfEKHnvZAs52fyynUILpO3rzsXKAjZ4pp8P8nm1RVPKnpggdYu8YsfEKKNPynVfSiK+PouCPbqE0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CH0PR11MB5281.namprd11.prod.outlook.com (2603:10b6:610:bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 20 Aug
 2026 22:28:21 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 22:28:21 +0000
Message-ID: <5ad0c32f-a734-4bae-b30b-791796e46009@intel.com>
Date: Thu, 20 Aug 2026 15:28:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/17] x86/resctrl: Enforce system RMID limit on AET
 event groups
From: Reinette Chatre <reinette.chatre@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-9-tony.luck@intel.com>
 <cda8483e-8c83-45b9-b52b-0e465e49b698@intel.com>
 <aodKsOMxcdasi0U6@agluck-desk3>
 <779e9ca5-9785-4cfd-b6c8-42efa1b2f560@intel.com>
Content-Language: en-US
In-Reply-To: <779e9ca5-9785-4cfd-b6c8-42efa1b2f560@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:303:16d::13) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CH0PR11MB5281:EE_
X-MS-Office365-Filtering-Correlation-Id: 1098ddfd-6d87-4c0b-90d9-08deff0a56f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|10067099003|56012099006|6133799003|11063799006|5023799004|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: b9Gaca257wTdycMK/+VeG/4yTzxgC3kmOVOEDggrqDKfHMDx74Yx6YdidYa0bzO7+El9ZpVTYJYgAMFgKS0opfYftKfe4pDWWUV8LkCWwltI2jqWK9ggo34SiaGn2bd0YvvqWWwQizzZ+bhHk9IrHj1Po9ogh6FbazljUyqruy6LsgWroH3ZwSXWpSDGOSTfAfHup1raJTwosK1xsTBFs7v3i4OZoQYIBn/QxIyFqsnrnpedAbJhBjY5GMsrUejUm1BlsBf4LOmoaVoFf00DbRQlBmP1CKrEdExd7nt3CHO6rpmCNVArZJNsOy6ekBH6x9KAiia6t5GfbEBR2GfN2Xhr45aDQZ/IWxpMOQPRPssW3xvnZIFK8EMDtalV9VxxLBGu4I8iS8mmXwzKZg2PFiYru2F+x0q85Xx+lcKuMYOXXEAwyleV4SVnoKbI1/1LhDdQvXy3Mnrom4/cjT6idmd47cIJWGI6qQmO7la9494olehAnkwUk3KIr+wqYE/rfoD/qI8rLX+vtu3RxRAVxHmFf1tVslHKvNXBQRriU9p1gacxE4ouEbecSbcXA5NQ8RYdcJuxeDu4DlOgnfm7aH5teU+wEMWWjn+KnmN9im4Uls5BxVYj4lL9jQep85zrwVpK7N/UvHlOAqtUJqTr9E/nU2ZuWUZLHOi3C3eRujQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(10067099003)(56012099006)(6133799003)(11063799006)(5023799004)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVl2TE1pYkt0TEUvRytqZFdTWVc5cStoVHJZZnZaUEVORGZzUVFQbjNkNExi?=
 =?utf-8?B?WElWdGVSZVRpU3FsM3o2b2JRN0pvU1FlMUlOQ2YvcVBMOUJ1ejNDblI2ak4w?=
 =?utf-8?B?M0VPZHpkN0gyOE00ZE42N0JTcVZvUDZVajRsekFWNWFFYlZmWVNkSmViZjBU?=
 =?utf-8?B?bHRXL2twTU5pVkdxUmgrVUZtb3RRN1k0MXQ2YzZsTGs5bElDVjVKL0JVeTlS?=
 =?utf-8?B?NmZuK01lNGJlSytOM2RFMEUrL0FzSitsWDBMdE4xZlNYWXJIR0oyNzhGbHU1?=
 =?utf-8?B?VHRUNjUvRmtiZUQ1N2lEcHI4VGpaY1ZtektZeEhBMFVsZ0EyRzB0SERCSkNl?=
 =?utf-8?B?YmU4cE5QRFR4TmExeXFzWDFXaFNoMDR2ZGZIbEdGbjE1TkFhMFRRTFY2RDZl?=
 =?utf-8?B?ZzJkQjNaQkQ3WkNFNUJUOGxVZjhYUG1BdW1WTDZ5OWExNjZRU2wxT2xMSEVO?=
 =?utf-8?B?dmY5MEZvRGZKODQ4emVRWENoallsM3JtbzlZWUU1RGRXRlFEbzVCUGhZeFVJ?=
 =?utf-8?B?MjUyVVFvcVE0TlUxUnREcUhhMkVLUERuclJDeUkrNURVSVUrcUkvYVBpOWc1?=
 =?utf-8?B?dk9USS9adVdlVVFHQnNFTk1XSmE0ZDVmTG9uN0Y5aWRzcG41MDBVbHBFREJi?=
 =?utf-8?B?aWJSNFNiZENjcVF5RXd3R0Y1ZHMyT3k1Y1FsTnlYRThuQlZ1UmMxcGlKeHht?=
 =?utf-8?B?SE8vNm9ndkxwbzkwZ1d6RktSOXYrbUpVd00yeVRuVFUzU3ZLU2xoYTVnbHhK?=
 =?utf-8?B?L1Jab0d5NHAzOTBaVlhvbDdYQXA3c0xjZ1V4Q1JHNDBiWVd3clNpT3JlOERm?=
 =?utf-8?B?RmVLdURRQk00WElCaHp0bVJydnRnc2dJenk3TUN0OXVTZDBneXdwZXNEMHZK?=
 =?utf-8?B?UzkvN0RKUjJPTXhmbFJRWGt5NlkwR2hvaFNFallUV08rSjZTVURTTUdtZ2tq?=
 =?utf-8?B?NExoT1dKbjZlZUxVQ25oNiswdERCUGk4UGJYMXA5aGF4Y0U3WlJtQmtTam5I?=
 =?utf-8?B?REJqeGs4bVZ0Vlg0TW4wZ0QzK0h2ZG94TlFmV1Nid0IxRTFHUGJjaVdIWUkz?=
 =?utf-8?B?MVUvZVNuTXAxUkZnQ0lucHQrQ3k4VmsvWU14bnlLOXBJTlczWU5vVFpLMTVO?=
 =?utf-8?B?THhKUTc2MGRZNWRqcDFibm1TdjhSUVBkalQ1dnAxWjlod3J5OE5BbmY1a2pk?=
 =?utf-8?B?Ly9GVk1abm4zMFlmWHlURlUrVDhXVnFTMUFSenVLeW41RGUyYTROUTQ5SjUv?=
 =?utf-8?B?N3BpNmZxWE9xWlY1TmhiVzBaQkpZTVdhd3BkUWNFT0pNQW5wbWNhVkJtZGRu?=
 =?utf-8?B?dnFncU50NG0vK21XTTdDdThmbGZUdXk3U2JjYVhUQ3NGeUM2Z20wN0JJeTAv?=
 =?utf-8?B?SGVRbzdRc0hBR1pOYkdJVWEyK1pIS0xpUldIL24vZUxXQTZ6Z0F2M0dQVGVI?=
 =?utf-8?B?Q2o2NTJiclZmNW95RTJFU0o4YW14VXNVSFl1Q29ieWFJNlVCK0RhQ0IzRWp2?=
 =?utf-8?B?MTF0cXY1ZDRMZHdFSXdrcUsrNDRTeDN1bWlpRW5INWNmWE9ySWd5WW9sc0R2?=
 =?utf-8?B?NVIrdVRGUUZWZ3g5RDZxS3VVL3dNVlNrbTAxNjNEZ0NWUlRuTWFtaExSUUdE?=
 =?utf-8?B?N2pDV1NMaTBENGVpQTE5a2ZiWUcvTTZNUXo0SGhva3V2ZDdUNmsvSmpNVmtt?=
 =?utf-8?B?MVBLVzM0NTM1YStoaFFQNkliTU5WampwaFJlZmtjYkgvVURRS2NTMHdrZG1R?=
 =?utf-8?B?R1U0ZUJsRjBwUU5ZRGJTMzU4TFdPV2ZmeDNJN21DQ0t4RVYrYmlFVWNOYkNS?=
 =?utf-8?B?UzlMTFBOUmg3cko4WlA5dE1iQlNjU1dIeG9jV1M4ejdWTVJrTTN4MWNSbDV5?=
 =?utf-8?B?ckhtdlhEa2JneklLRTVydEUrNTQxTC9RTS9xWkV4VXFlVFdReWljcDQ2K3c4?=
 =?utf-8?B?UzVSWTlMSjVnME9rcTgxY2ZUTWEzanpvMGU3empLSVRoWGRxbmJQNW9WaHJ6?=
 =?utf-8?B?emlGamIzSlgwWmpENHJJR0hnTnNudmVMSlM2NG5OSzl2czFwd0pQSXA3NWta?=
 =?utf-8?B?ZUNqYzlLOSt3TEhPdWRJa01wMFVDcDYxL3hYOGg0NGxVbVN1WTZuREVIZ2U4?=
 =?utf-8?B?cFdjQmQ5WEwxdE1wcmxPK0ZlRGhvNmpsYUk5RTFaTjVlZWdraU9vYVI2WkNX?=
 =?utf-8?B?bWF3U3pCQkthVEZXeW9mSldKRllON2JnTHBYcGFOLzBndWpsSmZlcXNFZlVv?=
 =?utf-8?B?a0poa1hJKzZXUi9TZDBlU0svQzhvM0JFZ2NlQnFEd1RkVGJ5RE5Md0tpUW9S?=
 =?utf-8?B?SGRiNWFRcGNIc0tLc3pYcEFvNHZNdmI1K2tINXZWS0JNRFlaMW4vdzh5aDNG?=
 =?utf-8?Q?G1xgHrXth6MopkpY=3D?=
X-Exchange-RoutingPolicyChecked: prrruPv61bZssuuPdK4PUhOViYusgvDVEMqesq0z6AGbwbPtd/KvSaElXcUlIn0N5n86bvAVXuKMmCacDreq8FBQ8aNqbTzloKZI6D+UBPmVEUJGs/wQYo4E3GtAFdwjgmBUh3+ixKWONRcPrYBRzt2GtPSfhIHE2Eg6Yt89aOj6+cCMTR5BUqyOibDePNITJGJ2xkj27/qul2HYqZOKKd3JJXJm4VSH43H/Es3RTqtCdr6b49Ug7zN9/+yi3aLvrCr4JQo7Sy40bWZcvIsjpo1KFQAC61YRxCVDJKZtwTZkUH0hlbErXePpuqwuj2GI6Mrw5FeLXoLk+nlrwKH8Qw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1098ddfd-6d87-4c0b-90d9-08deff0a56f6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 22:28:20.9938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWfy0FHTUWvZ3hWowwCGKJ7kC0JLZXbbZ96nIbCUUg/9CVHdKy30xv2TcDw4UGU09Uq2KXVbTXW7Z6h2zH19of3yXEKGY7W2Yhvc3tVrxZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5281
X-OriginatorOrg: intel.com

Hi Tony,

On 8/20/26 2:55 PM, Reinette Chatre wrote:
> Hi Tony,
> 
> On 8/20/26 11:42 AM, Luck, Tony wrote:
>> On Mon, Aug 17, 2026 at 05:58:13PM -0700, Reinette Chatre wrote:
>>> Hi Tony,
>>>
>>> On 7/29/26 10:27 AM, Tony Luck wrote:
>>>> AET (Application Energy Telemetry) event groups each support a specific
>>>> number of RMIDs. But that number may be lower than the number supported
>>>> by the system. Especially true on systems with SNC (Sub-NUMA Cluster)
>>>> enabled as that reduces the number of supported RMIDs.
>>>>
>>>> Fix get_rdt_mon_resources() to return true when any monitor resource is
>>>
>>> hmmm ... "Fix" makes one look for the accompanying "Fixes:" tag. What is
>>> the fix here? What is wrong with existing implementation that needs fixing?
>>> To me this does not look like a fix though (more below).
>>>
>>>> possibly enabled. Call intel_aet_init() to adjust the event_group::num_rmid
>>>> values to not exceed the system supported maximum.
>>>
>>> Last sentence just documents the code. Please describe why this is needed.
>>> Is this a separate logical change?
>>>
>>>>
>>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>>> ---
>>>
>>> ...
>>>
>>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>>> index 092764cf693f..2c938b97b147 100644
>>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>>> @@ -1019,10 +1019,10 @@ static __init bool get_rdt_mon_resources(void)
>>>>  	if (rdt_cpu_has(X86_FEATURE_ABMC))
>>>>  		ret = true;
>>>>  
>>>> -	if (!ret)
>>>> -		return false;
>>>> +	if (ret)
>>>> +		rdt_get_l3_mon_config(r);
>>>>  
>>>> -	return !rdt_get_l3_mon_config(r);
>>>> +	return boot_cpu_data.x86_cache_max_rmid > 0;
>>>>  }
>>>
>>> >From what I can tell this will return true when the system supports monitoring,
>>> but no resource may actually have monitoring enabled at this point. Specifically,
>>> no resource has rdt_resource::mon_capable set. 
>>>
>>> The resctrl initialization now proceeds where it used to stop. resctrl_arch_late_init()
>>> will proceed and initialize the resctrl filesystem, which in turn would allow user space
>>> to mount it.
>>>
>>> rdt_get_tree() handling the user mount request could thus be run on a system that does
>>> not have a monitoring or allocation capable resource and then we see in rdt_get_tree():
>>> 	if (resctrl_arch_alloc_capable() || resctrl_arch_mon_capable())
>>> 		resctrl_mounted = true;
>>
>> Should the inverse of that check really be an error condition and result
>> in failing the mount? There seems no point in a mount with no monitor or
>> alloc features.
> 
> I agree that there is no point in a mount with no monitor or alloc features.
> That is indeed how resctrl behaved until this misrepresentation of a fix changed
> this behavior.
> 
>>
>> This code appeared as part of James' separating the x86 specific static
>> branch code out of the filesystem generic mount path in commit
>> 13e5769debf0 ("x86/resctrl: Make resctrl_mounted checks explicit")
> 
> This change would have had same consequence even without that patch, no? Only
> difference is that before the patch you point out rdt_enable_key was used to
> check if resctrl fs was mounted and rdt_enable_key would not be set if there
> are no monitor or alloc features resulting in the same problem of resctrl
> allowing a remount after it is already mounted.
> 
>>
>> My plan is to move this inverted check earlier (right after the call
>> to resctrl_arch_pre_mount() which could be the decision point on if
>> any monitor resources are enabled.
>>
>>
>> rdt_get_tree()
>> {
>> 	mutex_lock(&resctrl_mount_lock); // NEW (revived from v4 of series)
>>
>> 	check for nested mount -> -EBUSY
>>
>> 	resctrl_arch_pre_mount();
>>
>> 	if (!resctrl_arch_alloc_capable() && !resctrl_arch_mon_capable()) {
> 
> A test like this looks to be needed after this patch, yes. Even so, why does this
> need to be outside of the main function protected by rdtgroup_mutex? I do not think
> that it is ideal to have this information accessed by resctrl fs with different mutex
> inconsistently held. Or does this actually reflect the larger "always return the same
> data from mount to unmount" implicit contract with architecture?
> 
> There clearly needs to be a contract between fs and arch on what the fs expects these
> two functions to return. Patch 6/17 is beginning to create this contract. 

Thinking about this more ... does resctrl really need these to be arch helpers? With
the mon_capable/alloc_capable available, resctrl fs does not need any help from architecture
to learn whether a resource is monitor or alloc capable, no?

> 
>> 		ret = -EINVAL;
>> 		goto out_mount_unlock;
>> 	}
>>
>> 	...
>>
>> 	resctrl_mounted = true;
>>
>> Choice of error code is still open. I tried -ENODEV, but that results in
>> an error message to the user saying the resctrl filesystem is not
>> supported.
>>
>>>
>>> The above flow change would cause resctrl to think the system supports monitoring
>>> but resctrl_arch_mon_capable() returns false. If there are no allocation features
>>> then this will result in resctrl fs mounted ... but resctrl_mounted is not set to
>>> true and thus allow a remount that is not supported.
> Reinette

Reinette
