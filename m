Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013271F869E
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745011053; cv=fail; b=Tl44fmEta0GLr6shhwQsACMZp+QmOmQtaif09j4zIATyh+tWz5TPW7GSOGxeiaS1+G7ReOJH7IPY69QCqfkhOUdJTojsgs+AbF5mCTd5B0qcLbyA0R689no4ml6CSk3xUN1z6+tc+6AFT1bT1vWAQvUzr8A0OtYhEVNeMp95Tvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745011053; c=relaxed/simple;
	bh=MUo6lVf8UDCLiOg5ZpkB6HI4LC/nh7CGdEsJYPvieXQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HqMPfWe7nDrDz/Vug7SBH5JmqupKzverTh7N5O4saerc4f96uGut4z9HIdA5qeVjsiQmEDu/CJKwfK4gWK/qgBcAPaSz70ZkmGfxY4S73A6E8lwQ2U+G9voUcaE8pOyf/AQAdp0G9j+vPoEO3byEQtjxbY+CKpCK1vwVF8dG3lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BHWmQt5B; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BHWmQt5B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745011051; x=1776547051;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MUo6lVf8UDCLiOg5ZpkB6HI4LC/nh7CGdEsJYPvieXQ=;
  b=BHWmQt5BQuRb0AIFEziNCd1BAC0ZPs3WULkrprcOcZqSCxukfSGoJUjr
   R8RvHpKf4psTm7zGzaKpvY9G/WFPlqL9sy5M+dUjjAMfqUAzeTDH0AUXE
   bq/PLA6NG7GGk/duqJFV80j7dnuxOKBcJFXbPJ31M3kBJARZsUfh7L4Aj
   GzRKSzjalWKQEGNA3S9riKDpYh8r9oiwOBJylj16TD3I6MjSn2F27GeLb
   8mgxny6mrXgrmWLfaP/CoQBf1vCe8aSgQsyWXHbfxy/BxOcI29cnIuTZS
   /v7DMB2/41JSYWcwXq32UtjJpFW4laBgGrHDm8jCqRI2w7DCJEhL2Ahz6
   w==;
X-CSE-ConnectionGUID: Y7mO89ztSAq4IdvZSMeUsA==
X-CSE-MsgGUID: kxbEBicxS/Whendpjhx/KQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="56823504"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="56823504"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:17:27 -0700
X-CSE-ConnectionGUID: kP5hYuBOTjmb+Zuy3OZEtQ==
X-CSE-MsgGUID: P/sV0q7kQwGZ9nwdvPZqug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131746344"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:17:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:17:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:17:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:17:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuEdxJc5MzwpI8VA6PIHw15uMszsr7XFxRkfKQ3SQQB+hVvA3avwuYs1O/c8YRAEx988JebbfDkR2gxHw91QKlUWRvbOGGb8no+6WhD/cDnOPJjb8dyBMlXrQ7UOrJA+CVZIx+UtqrAzCiHw4E1WdKZYtFku2pAY2C49EN0F8oQoUFAN/bxEEuNM//hS+XpCMykFkGGIRTLrApL687hyeU74HilMDZ3s0Puu9Y7wbLwcXEFC3oYx8J2IqE0vYQ/J+mILekgVpiti6OTeE94whJq4Fi/GvUmqouotvNpYUQWGS0xSlCtjkUks2VO1QugdQPPFGtEQ7veVO4+jm4nb8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JqU2CiJdcP1Iq8lCRF7vzY3pxoT+VSho7kSZnW1MHY=;
 b=umvIFy3Lv7zPM/k9wQgiLDgyx+k7a7udoXrgxVeNz16tylNiNM+cAhdhk2CF1qj7J334fJ6SBpQ1rxQF8axoganKM/ZeHD45SFrY7c65rxehRRYQbKF1Iy/j7/1PwsSPk7AbwjaAm0P2IbMeNSa8h2i02DqewI5VRgexwxp3HrI2oYORxXwBpHJ/4v/59UVDkoqDc3F+a2Ix1EOw9Mhz94mKTKsLWowNkW1kDWY5uGqTSPW0e7bsJvcCAvpyR9//SkfrzX9qklnidEbVbw6JCgaQCgdG8oOWuczyLXoLrBT8yXrI+xcpPA+FJmTsZ383GHc4nrD7VMhefkrrg0dNzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6531.namprd11.prod.outlook.com (2603:10b6:208:38e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Fri, 18 Apr
 2025 21:17:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:17:22 +0000
Message-ID: <7018b196-cfd6-4e4f-8ada-d91f43d6ce2e@intel.com>
Date: Fri, 18 Apr 2025 14:17:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/26] fs-x86/resctrl: Prepare for more monitor events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0255.namprd03.prod.outlook.com
 (2603:10b6:303:b4::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c67086-8c27-4437-4138-08dd7ebe68d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UnRqRWhkOUdXN01iNWpKdEhxYmVSNVE2c2ltM2tHVVRoM0ZFcys0R2NHUHN3?=
 =?utf-8?B?ZVphbHY3a2w0YjhoTGx5TDYwRFIvYVJYb2RtUnJLUWRoSVY3aXlOd2VDOFN6?=
 =?utf-8?B?TDk3NHFCTFducEtrYlRyUmxMbXZBc0F2azQvaE16a3VvWUcrZ0VGWGY5aUhN?=
 =?utf-8?B?eWRDS2k4V0tnM0hXcnJ2OVJncDl6ejhNTzNaeUpMTVdUY0Zib050dnlVcm5J?=
 =?utf-8?B?SVF6QytnOWR0VFBRLzZyY01CZG0rUHMraThSWVlHVi85QnVpYlZpZEk1am90?=
 =?utf-8?B?ZC9qN1BZUGsvR0hnQWVPQmVYY2dYWVQyRmw5Uk9XLzUxQmpCQmNrc0ZvcXRF?=
 =?utf-8?B?N21Rd2pFWFV6cmUvdHRCcXhRajVkM2JERFM3L3MvTVl2ckVCY3JDWCs4OGJs?=
 =?utf-8?B?ZWt1UmxsVENJdVB2K0F3cEE3elBubFhtVVdQUks3WUdpcjAvOFVxWGpXaXBl?=
 =?utf-8?B?aC9RWDk3Y2xEeFdxcW1vTFdvL0pKV0VTQVJOLyt6c0Z0cC95cWNIeGRTN0Ji?=
 =?utf-8?B?dHFrZDdVbWswY3JySWMyZy9nZUF6d2VrUzd0QURIbTh3QUN4M0EvcmY4Rmd0?=
 =?utf-8?B?M0Y3b0thNThLMkdtQzBSeWhWTXEzb3J4VkZjV1laMDJ6elgxWnp5NjBjRVZ4?=
 =?utf-8?B?UTMyUHFpMEpWQTgybk5QcjBOSGhmeEltT0JKTUp3TURKbkNoTkdzZ054RmFh?=
 =?utf-8?B?RExEMWZtaGk2eE9jVEtTUkh6S0JCSklsSzhLekU3UFUyWGkzUU41SWNNdmRQ?=
 =?utf-8?B?d3MzdzBUWVhlc2MrZ3VZR2RiVWJBcXVmUkp6Vi9scEZWRlRlcEFnUkxxMUpw?=
 =?utf-8?B?NEpnYUoraG1aT1EwOGdNOGFEblY3RUI2L3JnQTBlZVZpaCt6VjN6ZXc4Y0s1?=
 =?utf-8?B?b0JKNjFhQmhWdnpWWUpzRG1BLzByb0tTNit0dFBUdlpZMTNkNDR0YXlVU0tj?=
 =?utf-8?B?RisyODh2c0oxTm45YlMvaDlrczhQWWJrd0RTb0ZFTVpuTXRaS20zUllEdklF?=
 =?utf-8?B?MUh0eTEyeEV3SjBGMFNaRmNNOE1RZzVRL2ZrUHY5eDYyWXkyMGR3RGFZWTFN?=
 =?utf-8?B?N1lpek1RUGkrdmRBMGFzTDJuMUNoc2IrT0t2aGZoSmVXQWdTU0FiR1hjemRZ?=
 =?utf-8?B?UFEvWTdrVkhMY0FFZkNvR2tHbHJ0dTJ2TTdCRmQweEpVdy81NDlwSHlYR0tz?=
 =?utf-8?B?VVhuTkI0SXJ3ZGtyeC8vR3lLeGJMVy8xekRmc0tYUkowUFRuQy9QQWNueG1T?=
 =?utf-8?B?bmtiQlErQWFoOTRrcTFQNzFrUDBLcUtmbDNId1F5MExjY2xxOGxQZ3RuZ0p4?=
 =?utf-8?B?NHJ5aHB1L0hoWkVkNFRjWkxpMGxLVVVkSTUrNWRCQ0haWmdzakFnSmlFSkJn?=
 =?utf-8?B?TCtiZHNkSkxTblhicnlwUlYwQ3BSbWJmSnE4QVlHZGs3RFZSc1JvdzIyVHNT?=
 =?utf-8?B?b1ZYOXlsSnJuK3RNSTI1Nnl5QXpWKytjOFIxUnFQREhpUlRoZUVNYzNJdWw0?=
 =?utf-8?B?cXJCWEFHZEhwdlloTFAwNSs1SUFDTVBNNjVJV0orQklucVQ2NTBCT0R3RXps?=
 =?utf-8?B?cW9oS01NNEFPTXlld1hIbGVWcndXaEtwMmxJUUtzVkJtdkZHakpacWhabnhr?=
 =?utf-8?B?QURLWmFONzJKVUQzK3VsRFNMbExMcU01Sy9lemRXNlF6Y05RN2VkZXRJdjFp?=
 =?utf-8?B?RVIwdGNuMkV0KzFGOWlXMElMalJ6KzdCKzFnQzB6Z0Evdld0L3lXZ2QzTlRK?=
 =?utf-8?B?MlNKS0l1UFdKN3ZqODBtTUk1djJDdTF3SnVPVGNha3lHcndibzROeE1VMWt1?=
 =?utf-8?B?VlRTZ25mbXNWS0ViNnBQeUQraXE0YjRyVm9BMHZ0OUZESFUyUjhEWUFOWXJB?=
 =?utf-8?B?cktGSEk0VnNLY3l0TXN1UDJEQ3pETUhiNmZtRXdXekNKNlRHQ0xJcktzUUpE?=
 =?utf-8?Q?kMI65t8b8ZE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVBJNStVd3diRHF4Y3c2b3NrclEwcFFEWDZoRjNCVi9PSUVmZHpudFBRWnFw?=
 =?utf-8?B?ZFdBWVkyaEhETzdtNTJGWTBKTnk5SlEzSGhObmR4OHRkMk5ucE5uOXpNRkIz?=
 =?utf-8?B?amN2aXh4SEdqUUxJZFZOOTFzeDZ6alhVSVR2V3NiZXFtZjJodU8xK2YyRVgr?=
 =?utf-8?B?UWxTSHAzQWZFMXF6TFhBRXFJcDBid0RaNTZPd1I3ZnI3OTd0anFGaWJKRmNR?=
 =?utf-8?B?MmU2cGJIeENaM0RWeHVzVlRlajJDYUhFdWRKMU5aczJ4cUhLSGtOY1pzMjBO?=
 =?utf-8?B?dWhRalk2UzBWQ1MxUjkxZ0s3SFVoOHdXR0Q5VVo3dU9ZZlBRNGlRMTE4Ukpv?=
 =?utf-8?B?V05nL28wOC9TY0FQVGRxbzk4N0NjWUMyU1Z5ckoxUU9WMEQvSVVKRUJSTmEx?=
 =?utf-8?B?YVNYZUZXWC9taUlaU0IrKy9HU2xSVHYrbURFSGEwRm5SWHhTMDBhYnlJSU1j?=
 =?utf-8?B?cnFCOEdTdVdDeTV6Tmh6MzV1YWhFZXVDUnJaRzVZdDFzcGx2NnJVN2VsRVRI?=
 =?utf-8?B?cjdScXVMT3FJTXA2N0dla2diLzFtZGNpMXp3VnJiandITlpnZFE0bWV5SzVm?=
 =?utf-8?B?OW1VeWNmNkxEUVRDdnRlSWNFME9UUHljNEpjRy9mUTYvOGZxMHg0eStlNjEz?=
 =?utf-8?B?UGdHZUY0TFVFOHd5U0VZM2lVRFNENGd5eUhSaGM1bG84S1JZeXN4dDFLeXpS?=
 =?utf-8?B?a1d4eG1sakFhODhQSlRRL3ZMSmVxQm5DL3lVRG1McHlDV0J2MFZsMGVQMmNo?=
 =?utf-8?B?dFZ6eFUxN3lxc3Nhb0xPcVZ2ankvQittU2g1SEc4SHZyZkpvREJsVGZtR3NU?=
 =?utf-8?B?SFoxUnA5K2ZjTjdDekV5d2NZMHQyM1Z6bDRyOHNNQnQrRzlwWSs3TDhDRXNU?=
 =?utf-8?B?aW40cldpdlBDSVdqL3J1c3VtcEU4b0F1RGVxbUF0alByOVoxUjFpcVVBVlRS?=
 =?utf-8?B?MXpEODRNUkVwekNEbzIzcDlma1h2Um9tRWQwdDdEeXg3Q2pJTS8raU5JWFYx?=
 =?utf-8?B?d3lsdW9mcFpTRFVHdGxFVkNRai9YRnJzRnhUblZ0QktlRFFncGg0ZHFOdStG?=
 =?utf-8?B?aUF1TEZUWWs4ZVljU0owRWRWVVhKdE9BUW9MN3RMZE91UXR6U0RtVjBmY2do?=
 =?utf-8?B?S1NoYWdtVUJpNFZrdlFobHZoTlB2K0hsRmwyUHoxVDV4VnFzeElSNWkvdlVV?=
 =?utf-8?B?bGZzb2dEUk9pcjUyeTAyV1BJUVRMREM1TjhkdDU4cHdIb3VUZ3FHN0tvREpY?=
 =?utf-8?B?N2lSYkZsUGhLbG05TVBkbVRtM1Nva1JVbmNhK21CYkd4MmhvbmFJM3NQdHpT?=
 =?utf-8?B?T2MycGZTZlpPUEtOdXpQNzR6OTBWay9KNkNsSUtnU0o2QzlhUHQrbEN2Zjgy?=
 =?utf-8?B?QzBCV3J6MUp4b2Y0TGdnWXNQRFB1M1Vub1grb2dsRGRHYXdHRUdybktpRnkw?=
 =?utf-8?B?TSttdzJhNllhaGNYcEF4aTBoV2lNLzY4bE5OWC9jL2F1YXhKM0tyYlpTOFA1?=
 =?utf-8?B?c3pyZXFOQ1hFUGNPeUVEeER6Y1Y3WE0rSnhOU3pOTEl1WEtKOU54MDdaaXFv?=
 =?utf-8?B?amltaGlqbEoycFdQbXBtcUU2dmM2UWVCcXRaMzJOM1hXSU8zUFc5Z2tZcWxV?=
 =?utf-8?B?bFBDaUxxd0lCaXROOHBsQVovVjU2WkNOSjlqc2htMUxrSUFEMGIxa0hNZ3ZC?=
 =?utf-8?B?a1F6RitwcFVCaDJvbDdHSGp5U00wNUYxMlRNUXl3ZkM2NWxyclRwdEtnTjFN?=
 =?utf-8?B?Yjg1U2hQSkhHL0RTV3dBeW8xUkxQdEdSQWgveXczOE42dkZXZ2gzZEtLaUlF?=
 =?utf-8?B?N2ljaXZjVmZ5SE5MbDZGR0J5RUwwV2Rzcm41U0paV0ZEa0thQmtxTlFSY2to?=
 =?utf-8?B?NElxYjRrT1RNWUVsOXo0dXpEa2hqUG5UV1hsbXhycnhhYlhURlNrbCtOTVRZ?=
 =?utf-8?B?ZHN6eXUvcVd6eTVPdHRYRHREanJBc1RaT2IxQXhaSURFUCtMQXA4ek9BSkpY?=
 =?utf-8?B?alBBaEtyNVFTMnJFOUtiUTBWWng3T0tGdWwyWnQ1VVR2VkVPQzMxSy9FSGZU?=
 =?utf-8?B?ZnM2U3VwZW1ZWmhySWdCdUVrRElwY3dNQk15cHhiOWsvd3U2TVFRZU9YTmh0?=
 =?utf-8?B?TGdaZUxBcU5DRDdNSnIxaW1kM1FMY2FnMGFEbDZSRkdOMjZoMDBqczRjZEla?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c67086-8c27-4437-4138-08dd7ebe68d9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:17:22.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: paNjJo9m9kKipXcutuumjGf6jOklr6sl9YxlNLo7f+88OzG9bVlHEWLxUzy1bVFw0ZgSpJ1JB1mnHER3FdcEEwdAtk2CheVUieZOREwzQYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6531
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> There's a rule in computer programming that objects appear zero,
> once, or many times. So code accordingly.
> 
> There are two MBM events and resctrl is coded with a lot of
> 
> 	if (local)
> 		do one thing
> 	if (total)
> 		do a different thing
> 

first change:
> Simplify the code by coding for many events using loops on
> which are enabled.

Please elaborate on how the primary change is the change in data
structure and that is what enables loops to be used.

second change:
> 
> Make rdt_mon_features a bitmap to allow for expansion.

... and then a third change: Introduce rdt_lookup_evtid_by_name()
and rdt_event_name().

I recognize three logical changes. Could you please split this patch?

> 
> Move resctrl_is_mbm_event() to <asm/resctrl.h> as it gets used by core.c

What the patch actually does is move resctrl_is_mbm_event() to
include/linux/resctrl_types.h that is in itself unexpected
considering what resctrl_types.h is intended to be used for. See
details in changelog of commit

f16adbaf9272 ("x86/resctrl: Move resctrl types to a separate header")

for details on how resctrl_types.h is intended to be used.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                |  6 +--
>  include/linux/resctrl_types.h          |  8 +++
>  arch/x86/include/asm/resctrl.h         |  8 +--
>  arch/x86/kernel/cpu/resctrl/internal.h |  6 +--
>  fs/resctrl/internal.h                  |  4 ++
>  arch/x86/kernel/cpu/resctrl/core.c     | 45 +++++++++--------
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 33 ++++++------
>  fs/resctrl/ctrlmondata.c               | 41 ++++-----------
>  fs/resctrl/monitor.c                   | 70 ++++++++++++++++----------
>  fs/resctrl/rdtgroup.c                  | 47 ++++++++---------
>  10 files changed, 133 insertions(+), 135 deletions(-)
> 

...

> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index a7faf2cd5406..898068a99ef7 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -55,5 +55,13 @@ enum resctrl_event_id {
>  };
>  
>  #define QOS_NUM_EVENTS		(QOS_L3_MBM_LOCAL_EVENT_ID + 1)
> +#define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)
> +#define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
> +
> +static inline bool resctrl_is_mbm_event(int e)
> +{
> +	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
> +		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
> +}

include/linux/resctrl.h should be a better fit.

>  
>  #endif /* __LINUX_RESCTRL_TYPES_H */

...
>  
>  static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
> @@ -864,13 +865,13 @@ static __init bool get_rdt_mon_resources(void)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>  
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
> -		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
> +		__set_bit(QOS_L3_OCCUP_EVENT_ID, rdt_mon_features);
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL))
> -		rdt_mon_features |= (1 << QOS_L3_MBM_TOTAL_EVENT_ID);
> +		__set_bit(QOS_L3_MBM_TOTAL_EVENT_ID, rdt_mon_features);
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
> -		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
> +		__set_bit(QOS_L3_MBM_LOCAL_EVENT_ID, rdt_mon_features);
>  
> -	if (!rdt_mon_features)
> +	if (find_first_bit(rdt_mon_features, QOS_NUM_EVENTS) == QOS_NUM_EVENTS)
>  		return false;

Could you please use bitmap_empty() instead? It does the same, but makes it obvious what
is being tested for.

>  
>  	return !rdt_get_mon_l3_config(r);
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 163174cc0d3e..06623d51d006 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -36,7 +36,7 @@ bool rdt_mon_capable;
>  /*
>   * Global to indicate which monitoring events are enabled.
>   */
> -unsigned int rdt_mon_features;
> +DECLARE_BITMAP(rdt_mon_features, QOS_NUM_EVENTS);
>  
>  #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>  
> @@ -168,19 +168,14 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
>  						 u32 rmid,
>  						 enum resctrl_event_id eventid)
>  {
> -	switch (eventid) {
> -	case QOS_L3_OCCUP_EVENT_ID:
> +	struct arch_mbm_state *state;
> +
> +	if (!resctrl_is_mbm_event(eventid))
>  		return NULL;
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_total[rmid];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_local[rmid];
> -	}
>  
> -	/* Never expect to get here */
> -	WARN_ON_ONCE(1);
> +	state = hw_dom->arch_mbm_states[MBM_EVENT_IDX(eventid)];
>  
> -	return NULL;
> +	return state ? &state[rmid] : NULL;
>  }
>  
>  void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
> @@ -209,14 +204,16 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>  void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
>  {
>  	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
> +	int evt, idx;
> +
> +	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {
> +		idx = MBM_EVENT_IDX(evt);
> +		if (!hw_dom->arch_mbm_states[idx])
> +			continue;

This does not look safe. Missing a resctrl_is_mbm_event() check?

> +		memset(hw_dom->arch_mbm_states[idx], 0,
> +		       sizeof(struct arch_mbm_state) * r->num_rmid);
> +	}
>  
> -	if (resctrl_arch_is_mbm_total_enabled())
> -		memset(hw_dom->arch_mbm_total, 0,
> -		       sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
> -
> -	if (resctrl_arch_is_mbm_local_enabled())
> -		memset(hw_dom->arch_mbm_local, 0,
> -		       sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
>  }
>  

...

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 3fe21dcf0fde..66e613906f3e 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -347,15 +347,14 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>  				       u32 rmid, enum resctrl_event_id evtid)
>  {
>  	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> +	struct mbm_state *states;
>  
> -	switch (evtid) {
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &d->mbm_total[idx];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &d->mbm_local[idx];
> -	default:
> +	if (!resctrl_is_mbm_event(evtid))
>  		return NULL;
> -	}
> +
> +	states = d->mbm_states[MBM_EVENT_IDX(evtid)];
> +
> +	return states ? &states[idx] : NULL;
>  }
>  
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> @@ -843,20 +842,40 @@ static void dom_data_exit(struct rdt_resource *r)
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> -static struct mon_evt llc_occupancy_event = {
> -	.name		= "llc_occupancy",
> -	.evtid		= QOS_L3_OCCUP_EVENT_ID,
> +static struct mon_evt all_events[QOS_NUM_EVENTS] = {

"all_events" is very generic for a global. How about "mon_event_all" 
(placing the "_all" at end to match, for example, resctrl_schema_all).

> +	[QOS_L3_OCCUP_EVENT_ID] = {
> +		.name	= "llc_occupancy",
> +		.evtid	= QOS_L3_OCCUP_EVENT_ID,
> +	},
> +	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
> +		.name	= "mbm_total_bytes",
> +		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
> +	},
> +	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
> +		.name	= "mbm_local_bytes",
> +		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
> +	},
>  };
>  
> -static struct mon_evt mbm_total_event = {
> -	.name		= "mbm_total_bytes",
> -	.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
> -};
> +int rdt_lookup_evtid_by_name(char *name)
> +{
> +	int evt;

Since this is resctrl fs code, please replace "rdt" with
"resctrl".

>  
> -static struct mon_evt mbm_local_event = {
> -	.name		= "mbm_local_bytes",
> -	.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
> -};
> +	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {
> +		if (!strcmp(name, all_events[evt].name))
> +			return evt;
> +	}

* This is resctrl fs code. rdt_mon_features should be private to
  x86 so resctrl fs should not be accessing it directly. Perhaps
  there can be a new arch helper that can be used by resctrl to
  query if event is enabled? Similar to resctrl_arch_is_llc_occupancy_enabled()
  and friend but where the event ID is parameter and arch code can
  use rdt_mon_features.
* While the function name is "lookup_evtid_by_name" this function
  does not just look up the event id by name but also ensures that the
  event is enabled. The caller then uses "lookup_evtid_by_name" as
  a proxy for "is this event enabled". I think the code will be easier
  to understand if the functions do not have such hidden "features".
  resctrl fs could first use new arch helper to determine if
  event is enabled and then use a fs helper that reads name
  directly from the event array.
* For a function returning event id the return type is expected to
  be enum resctrl_event_id.

> +
> +	return -EINVAL;
> +}
> +
> +char *rdt_event_name(enum resctrl_event_id evt)
> +{
> +	if (!test_bit(evt, rdt_mon_features))
> +		return "unknown";
> +
> +	return all_events[evt].name;
> +}

Same comments as rdt_lookup_evtid_by_name()

Also please watch for rdt_mon_features in rest of resctrl fs changes.

Reinette
