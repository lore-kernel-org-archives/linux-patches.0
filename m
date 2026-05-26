Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF0C4218A1
	for <patches@lists.linux.dev>; Tue, 26 May 2026 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779818056; cv=fail; b=N5IaEnnOiTnJ8+zzyzdA8xk0Z70oKOdjLhvOo9DmF4YQtJUXD2+P+iVa8ZNYwAS5i5CZ9mMbnBIOBXX2EIBdfFa86MrVF7EFpNYDeNXuveUjlKwORCazP6QMM6jDlbAnmcZKtpgxBh7PtFibiAeMpq1ahv0vGEM/XfA/BdC63Iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779818056; c=relaxed/simple;
	bh=Gq90CenSHBjs8PSoVYQTAcf0VezjsKNvvfod5BQLhNI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R9Tgwy7z1UQ/e83uw9wXFUEcPp2wv8YFpUpg3GZa69QZ4Dqg6KbpuW3zK7mzze/uPcsNnGTbnzeBaG3aWZ4qlC8X2kcU2c48u0PD6Dp3A8VSvFkywSHEVsAtsf57yGAQfyN7nfgL5O0dW7i8MfBqJkLHJGzSxGBJv9DnvudwA5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WnV09PE5; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WnV09PE5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779818055; x=1811354055;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gq90CenSHBjs8PSoVYQTAcf0VezjsKNvvfod5BQLhNI=;
  b=WnV09PE5MSJdIAuLVMdLxkxxCR/eGTpNJE4Mh+ZqCnn4LBqJkTnm8ap0
   zSEs4FPbVGsKDYEz5heSD5hsU6sILKKhxtfK+HIt3eqlBqEDLpePGRxtn
   UwmtO0VE1J5q7+I3e+sXz1KtO9lLUhMm46AS7pe4gIX35RiPvyInTxt1M
   Me8r9z0o22l00TkeIAR3E73dksF/g0rkaLnj7dZj+CenCSlp+VPyT9MwN
   Sz3btOChVuI1eiPryh8FlVJkvNH9uuK2Okw09X2tJ6U3252dbzuVbhEqx
   f+IACfJNALKptTlBlL9is4s72YBqjVzOixM8jsJrWVBNgQfPX7yXb2vT8
   A==;
X-CSE-ConnectionGUID: cZptutuBT4yN2gqbsG6Jlw==
X-CSE-MsgGUID: 6L6BrWQqRXaagopykrxIAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="92112149"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="92112149"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 10:54:08 -0700
X-CSE-ConnectionGUID: UfayrUXOQlW+osRk0d8aTg==
X-CSE-MsgGUID: ft94XEH5SfaNTZpF9VzxCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="237820333"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 10:54:07 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 10:54:06 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 26 May 2026 10:54:06 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.70) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 10:54:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ioBpkDU6+GEp3fr/PqmXxaD9sd8j/m+Cjvm7cQm+t8lFxVFYiuV5GKv/EwATcSWWd8RcTgpWYeiHHk/Ogu50VYnkCaYl/3qOcj6ablIwr7A8vYHGiX6mncTtQzOX/iKtB+H1Hhn8Ctzov0+Nh74/1+qE428op84Z5ySyzcM73bo+9HMUYXyu1MYNXeBmULyoxOWaqZIsMOzpyIqe9iB6FzEzR6wkIk0wDa8JlWaiIWlO0cdDbtWjMz5gu8afjQbX8O0l0PoM2PSZN2+b1u53TZypUQU/bEud15Hv7JcDcjOBOt1ZwQK2lQ/J6m/RTv4Z/Vo5RmOjEaQ+NYIbTZlHNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcPLZ6yikJYpK9C1PvPJU4VNUdLJ4WJ9WY2rajl3vVQ=;
 b=gnsoOR5dc/w/ibVc3YA9xUqoQq8Ibyw/371zc4mX5swxySXEWf06Sn3NihSs9hCuTmwzBC6PKKBU4WqJrqvZig4u5Yy1aawN+5BH/uZKQIEC+BJR4eLzOAZIrVJ4mSM/RGDogycIkWk3s1tyO6L19iXl6RXgmu0C4/QQpv2hAKgMTo7oTBLAOPFooyDdp7xenU6SxPOGUycE5jLtX3NO5JaDcX2MVahQsT+mEcMuT0/xqnnxDtsR3vL2cQJ264VpFnn/ouSGFgAwVG+J+mwGZlo1cB5xQln/5Kne8T7jQYT+DQb0iDd9JmPSptu6ttw3J9nVtRHm79++ROK6MCHbuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB7556.namprd11.prod.outlook.com (2603:10b6:806:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Tue, 26 May
 2026 17:54:02 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0048.019; Tue, 26 May 2026
 17:54:01 +0000
Message-ID: <da9ec0a6-8ea6-4b85-b4b2-6f4fbd32f687@intel.com>
Date: Tue, 26 May 2026 10:53:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] fs/resctrl: Fix UAF from worker threads when
 domains are removed
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
 <ahW9EJORpIqnvthk@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ahW9EJORpIqnvthk@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0192.namprd04.prod.outlook.com
 (2603:10b6:303:86::17) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: b01b5e49-63b0-4214-aca4-08debb4fc4e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|6133799003|11063799006|4143699003|5023799004|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info: sEeXcjKywwr3zo49r8Fof68W2YD3nXeRmQg7dAyXqiWxIn2AwWSuKICYjBjqYyTeNY/2tGOZVwcYxldT+ZjH2ScE/bc0Qfy0y6hPkis1OkiiHFYhhXNhTWu/C8BfnBHT+cNcSx5D2MoEUAcfrzwF/jSv/7ZyMNizDQ6C+VSBwjehTmNKGcuy8iH5lAM6TSV3jbhiSbT5HxTtQlF+jhLEmmiQT0WGZcqTZKBpTErdCm5LnvAZ3+5ZrOn1vLMLg7UXEBL5w2adzdv5i+05++idi5MXKetk4bOOoQTimUsodDciXScLn9UfC6E8MaUqGQ21T+lhEDsySElE+Q9dm51A/EIenSEuyyp6BpNiPJrahuBHbekB8qjmauJnDahxtvzlqNn8CDF30R9iT7z6BYeoPvcViSwdSfqG+/qVo3UKpFTmhbKTmeC+LOteREwReOXHfv7R85hgIerR1v7s9ZtlU5v13rWH4ZOPZ8IsmqA32KCc/pWs+LmMIzvflTgd51bMwb2S70aGL1H+2dk0j+oP//ibbK3Zf61ixQEAmrkQdbe0bAleBiD+/w2JioVAOZZuSQWCeHff4a+ZIPlRVubjllVI3hF72d5ZuIBNPrEbTQxA/RLB2zPSEK3y/kRByuoODw1xajXPHh1xaF4Scjv6SI5wPiHrTUJIWA3aH22tsLj5EtH9T8N4HOU/25ExXWoj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(6133799003)(11063799006)(4143699003)(5023799004)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MSt1dmJKUC9Wb2xrV09QNmU2Z2xWc3ZsY2dKaE5ZT2lWQ240UGM2VXMxTXZ2?=
 =?utf-8?B?SGl0bk4yZW15V0ZMd3VjT3RreGREaFVUTTNmcktvNmtaQTVXNmZSaXloQ0pK?=
 =?utf-8?B?VkU0UkpsTWdicS96QTBlWlR2cnF3aEgwMjZ1R2tXRkFPNllZS2JKSS9QaXRL?=
 =?utf-8?B?dDZSV29xNk5JcGlMbWVuVmhObnRwOXFsdks3OCthcytaLzNsSWk2aXZTQXov?=
 =?utf-8?B?NTFTajJRWlJrMC9QSU1USDdpbWprR25FZGNwUlYyUFA4T0VibG1zOWhTbzVS?=
 =?utf-8?B?QVIrVGppRE9DS0V6NHBGMEtBK3dlWndsTHhWWWE0VXdFZms3SlhvMFVqZjJW?=
 =?utf-8?B?eFRaNEwxTnhwU2NOdHRqbjdnMG51VHlOUWViaWhDZ2lvUkZuaERnTXpYKzh4?=
 =?utf-8?B?V3YyamNRaU03YUt4RXcyQW1kOElXbStyb1hXNC9NWjVHWjRWeEMyWklYTWdX?=
 =?utf-8?B?SkxydTIwK3RvdjhZdXBCa0Z0TXJpQUV4cXVPZXJFc0Z1UFZtVFZYWkhTdUJM?=
 =?utf-8?B?OWMwU0czU2ZpNXVUSjZpdWJwQmVac1Zpd1htOHpvQmtrM1FaLzh2VzhiKzBZ?=
 =?utf-8?B?REx5SHZsNFFkRENLek5KaWw2b29CdWlMTG0vYmpDMDZCYlpZbDFjaXp6QTha?=
 =?utf-8?B?SlkvRHZZTUFjNmR5WDdVMy9tQW5GTk5EL3cxSDFKREdtdTVZSHlyM1JtejBB?=
 =?utf-8?B?cXZBN3FjQlFNd3BGakQwMFcwMDByUktIaEN1OER2SjdoaEh3NjJuc2dXczY2?=
 =?utf-8?B?MFNwNldXS2dPWElGTkU3Ri9DMEx5U3MxQm41MllrNTRrZ3JkZWJ0b0Jnd043?=
 =?utf-8?B?QktZMWJZVWsxMVEzUUdLN0xVQThVTVBEdzBEbFY4U2tvTUlXeGZudk1Sblhj?=
 =?utf-8?B?NDZOeVBJbjRycXVqc013dUJrRGFxVzRLUHo5ZkR1MVRscGl0eXlBM3dUMUJ4?=
 =?utf-8?B?RXdBSDRlSU5VL2tmU3ZabUFnTzE2QWNsN09nRE50Wm9BYmw5YUg1eVpHbzI1?=
 =?utf-8?B?ZVlwcjRFVzdUVXlOMkZuL0xrS3A1TzFBNW1ySUlpZm1rUGQ4YWw0dlhRWnlq?=
 =?utf-8?B?L2szT0tDL1Q1bG5ZVm90RkRzdk1PMFdtMWtjUEZJY1IrOGQ1ejZuRW5jUUl4?=
 =?utf-8?B?QzRET1ZnRkJOZWdyVWpMaGtBNlkvVnFnMlMrR0hBeldZYWtQTytLVjBacjBp?=
 =?utf-8?B?d2FzeUdqYlRVN1Jjck9rSGxsYlA1Y2NqenM0UlJWaHF2YS8zY3BlZnF4bFNX?=
 =?utf-8?B?TzNxeWhOTTJRTmoxMDBMTkxsTDZuZHQrY0lkYkU1MmNqRnlnYXowcHBxZkhY?=
 =?utf-8?B?VmQvNk1ET3VZUHBlNkZVMmhTOUZycmF2RS9hcnhKMDBBR2xkc05abjJCdTJU?=
 =?utf-8?B?eWZxYkNlWWUrZVZoYWxUQUVrQjVuTnExK3pHem4vN2xaYVcvTGxVZGlnSThC?=
 =?utf-8?B?Z0d2T1FQU1hGbWx4L1hYazZ3U1BpMS96UXNFa1NTMG90UEM5ekRpQ3lnbmYv?=
 =?utf-8?B?T0Zxcmw0bURscDhXUS82VlZ4Ti8rWkRoQ2doVEFYeTNoMEdra1VDSEZHWkxo?=
 =?utf-8?B?UTM5L0N3eDk1NlhTUktyQXB5ZzVBOXQzNWlva3NxMmREWkJsbllqZDlTcFNz?=
 =?utf-8?B?SUJnREVLQW1oS3c1c1ZGWFVFSWZEYUhIdHgrMVhjYmFnZkluMFZScU90SHYv?=
 =?utf-8?B?YUZOcXZxbXByNlJUSmRYQkNXbzY4L1lRL0ViN0NnSndRUnF6K0tvbDhqVkJM?=
 =?utf-8?B?TlRFbFgwdWRmV3kxYXh2Rm9qTS9lSGxneUtxd1hEeDEvT1hHRERXdzEvT3Ez?=
 =?utf-8?B?VVJpVFg3dUxwTXlvaDlid1VDZ3p0Y21tVmlXSzBtd1NEdTZuMEFBaFArdlcy?=
 =?utf-8?B?TTBKSS9OS2R4T2ZKbWdjWnVDaEhwUDFSb01rMGhCMzhTUHVCcUN2OEU1Mmlm?=
 =?utf-8?B?Wkpka0g2R1EzV0phbjFYRkRiTnkxdDV6YU8xeDAvalh6ckRPMjA4V1VGR1ZJ?=
 =?utf-8?B?Ky9Oa2o0ZjNMM2hwU2hBeHJBZGthek1kVkdCcVg0SWVweVVxYmp2bnd1RGNq?=
 =?utf-8?B?TjNpSDZrZHZIYUphS2pycW1DczBETDYzSUVBMDl4b1dVM0QxdFlzQWR3NHZP?=
 =?utf-8?B?YmVGWStodU5lMEduenlJdnMwN01uNnNyc2FGZVRad3d2RnZkYXlPMmlTYVZX?=
 =?utf-8?B?cGNYVGpuc1lKYitNWVNBQkJpYitFWjVPYTE4QVZwWHJQVGw0UldNcEsyQWFM?=
 =?utf-8?B?SHhKbmlFM1drL2drWVhrV2dRc1UwdWo3bEZpeWo5ZC9DL3BmTE9vZ2FINE43?=
 =?utf-8?B?azQwTnc0M3RoN3VVSEJaYkhIbm1SMk1oMVh0ME5QYzd0NUtyeG9QVHVnSWQz?=
 =?utf-8?Q?0TAWAzh7+aRiKtUU=3D?=
X-Exchange-RoutingPolicyChecked: aE18e8M9B+avkvp4j27PMDbIO3LJXi8Ub1vsqrHj0uHCbAMM1WcLEeyxShAPpEOqkyPT6tYZnqbwrtmZkFNd0vgk+OjqVX2PRrTbSIZMEgWydhb/8FCDJl4G6YGpd9K5UqJmdvyCDFByNRoXjx2iXpoimgkQRUHn8cL0UhVsiO69tiogBWSh9HX73v70n9aVudWmQnZsg2Qy4P6e2n1NmHvFOKp/BHNfeTGjWuWDPodn+v1/Nr4E3WvZBeWDxV2lzrh2whKmEZutbPmDuVV7ng2eStLgEBC+E+JO/2t7nzvy8FXbCE4BDvEiH3ynVbUcamvICmWefTtzk1u5BUIlrA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b01b5e49-63b0-4214-aca4-08debb4fc4e3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 17:54:01.6420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGvwLWn28KpaNNkt9i64EE2Cx+HIrxooauOIE45f6dCztKfB/oA/pro+uHuBtaCURZA6BW74KMOMGzSWN1itoxplkE5xoUa47lQu4RXGAtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7556
X-OriginatorOrg: intel.com

Hi Tony,

On 5/26/26 8:32 AM, Luck, Tony wrote:

Instead of deleting the patch without any comments, could you please provide some
insight to what problems it has and why your solution is better?

> On Fri, May 22, 2026 at 12:15:13PM -0700, Reinette Chatre wrote:
>>   - Adding a reference count to the domain structure to avoid the worker
>>     needing to take CPU hotplug lock. This ended up being very complicated
>>     with the architecture needing new APIs to manage the reference count
>>     which cannot cleanly integrate into MPAM since it uses a single
>>     architecture domain structure to contain both the control and monitoring
>>     domain structures. Managing the references across mount, unmount,
>>     online, offline, as well as worker self exit resulted in several
>>     asymmetrical and complicated paths that were error prone. Locking also
>>     proved to be complicated since architecture would need to initiate
>>     domain free that will need to call back into resctrl that will take
>>     rdtgroup_mutex which means that references need to be taken/released
>>     without locking.
> 
> I'd been working on a reference count approach too. The MPAM combined
> domain for control and monitoring doesn't seem insurmountable. Mostly

While technically possible I do not think it is a clean solution to have
the lifetime of the control domain be controlled with a reference in the
monitoring domain.

> because it seems unlikely that the problem with worker threads would
> ever apply to control domains. Maybe I missed something, but just adding
> an architecture *release() function that can be used by file system code
> to drop reference counts on the domain when worker threads exit seems
> enough.

Did you consider the locking implications that I mention in the description
you quoted? More below ...

> 
> My patch below.

heh 

> 
> -Tony
> 
> 
> From 611fd8ad816abd37ef9a65b39175ce05907a1d41 Mon Sep 17 00:00:00 2001
> From: Tony Luck <tony.luck@intel.com>
> Date: Thu, 21 May 2026 15:14:27 -0700
> Subject: [PATCH] fs,mpam,x86/resctrl: Track reference count for L3 monitor
>  domains
> 
> There are race conditions[1] when the last CPU of a domain is taken offline
> and a worker thread may access the domain structure after it is freed.
> 
> Add a rdt_l3_mon_domain::kref to track users of the domain. Don't try
> to cancel worker threads when CPUs are taken offline. Just set the
> target CPU for the thread to nr_cpu_ids to indicate the worker needs
> to take action next time it runs.

One test I have found to be useful when digging into this is to offline all CPUs
of a domain starting with lowest number. Since overflow worker runs on lowest number
and then is moved to next CPU when it goes offline this stresses this new mechanics.
Have you tried something similar or could you try this test with this solution? 

...

> @@ -680,18 +692,16 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  
>  	switch (r->rid) {
>  	case RDT_RESOURCE_L3: {
> -		struct rdt_hw_l3_mon_domain *hw_dom;
>  		struct rdt_l3_mon_domain *d;
>  
>  		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
>  			return;
>  
>  		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> -		hw_dom = resctrl_to_arch_mon_dom(d);
>  		resctrl_offline_mon_domain(r, hdr);
>  		list_del_rcu(&hdr->list);
>  		synchronize_rcu();
> -		l3_mon_domain_free(hw_dom);
> +		kref_put(&d->kref, resctrl_arch_l3_mon_domain_release);
>  		break;
>  	}

To me the idea behind a "domain reference count" is to provide guarantee to any holder of
a reference that the domain *and* its data remains accessible while it holds the reference.
There is the domain structure itself and then the architecture specific, for example,
rdt_hw_l3_mon_domain::arch_mbm_states, and the fs state, for example rdt_l3_mon_domain::mbm_states.

Above snippet moves the freeing of the *architecture* state to be called on kref_put()
while *always* freeing the fs state (resctrl_offline_mon_domain()->domain_destroy_l3_mon_state()).

A worker may thus have a reference to the domain but when it runs it runs without 
fs state which is just a new use-after-free.

As I mentioned in the description the release managed by architecture implies that
reference needs to be dropped without rdtgroup_mutex held since the architecture
should also call resctrl_offline_mon_domain() as part of release. Locking needs
to be reworked and needs to adhere to kref rules on kref_get()/kref_put() without
locking.

Reinette
