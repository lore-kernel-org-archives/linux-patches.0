Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F94306D40
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309218; cv=fail; b=cOrnzyUWQ6Mw4dzLi6U6rWMj0fSdFOjwWocPOzoerzjw4Mbp7WLrc/luFIsCwCkSc4u5smViLotPD47kiQxGfDeS6q8Z4sBXlgwbRF4ugJL7irB8MoAU+JzqbGG+c3DwK1Vrjj65EomgifcManQ8mhNcDZHWJgGzGaiOPYc0w34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309218; c=relaxed/simple;
	bh=nRkwtKuFin3VhTUqpixBAWbGf1KRlYBEgqqqWxkGPI8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V3W6B2B4owywCcnOnSLhYHL51ZUWQMdjgynputjq6W29YPVL6c7XWmyHAvAY20ppbehnpOLpwbjCWQSZioYkoeo6WhSx55zZ2vw5KyqWb+BhhcyjcenZsjCF/Yuk2x3X38+iMKhKzmgFEhMhe548ae0FwhaFpqZQ86NpGepI02U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hFaw/ZCZ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hFaw/ZCZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309216; x=1796845216;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nRkwtKuFin3VhTUqpixBAWbGf1KRlYBEgqqqWxkGPI8=;
  b=hFaw/ZCZ9NBIh1q4AJGcGilvm1m/wXs1WQ0NgNgARnroHL5PNMwkN7Fw
   KMZfvGtuOQgYHnZ5GU/9FYPfMw5fii5RVCABNWexZsxSQafazDwyhy1Cb
   MVMtsM5h+2OfCH9+xRwiMqpEJKaRtdUVr+ozGer/74O1LgUlgco/AXG9T
   wkCPwVecohejZOOlxhoFwhD8FGyl1PzbTq95nzXVTC4BF5U6yxxJjFdVx
   pBRU8BqN5YTfx49D1Rp+bcipQJfs3CFaOaFMdIKL35Dootu0iu92OD/Sc
   4Sd+iiKKN891c2Qqjf08dVl4Cun85GSGuCWEvMUi0+CfxpsujbeBHk432
   w==;
X-CSE-ConnectionGUID: QCK3SlJqTH2AAAYCOWHpSg==
X-CSE-MsgGUID: 4z2NLGWtTOuHzl9F5vRsgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67326510"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67326510"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:40:16 -0800
X-CSE-ConnectionGUID: +FY8q0fDROac1Wsz9tRBuw==
X-CSE-MsgGUID: +OhaNWrJTVu1boqKQQ53+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196221761"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:40:16 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:40:15 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:40:15 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.61) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:40:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TVMAK7hyW2qbO9KCwiyZeX56w+K8FXFQZPAKuJJkqlr2WzX8F2C0odenAfm8XdJKouZ21RfY78bDLWFQvXduxzSxQ8oquKOF7sJqv87qa3VNYLkxDtzcB5vsYGJQAtppT3M63UikoVtOil4Lp4M5gIZRJBWATDl+v3ffXvr7M0GXnTpi6vx2mhR55dl2JkzaQl7xldT7fVZt6MpALwCy3qyiHelin7l3BScDPUCEUvjWeGN6kWOGrb5VK/WaDWbMY59kyG5xsLkxjAXa6JEeWp1eJHZA1D6JXtxG7FHSc1xaAze4qQvTcERyaoCQt7FuiAmSXVwIzkpf9vRowxW2Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSEPONACigfcmiZWYUaEpqQUQFLUDo4i3TuK+CzFFec=;
 b=DY95jj5QStZFkzP7TaHMESyc/UYszLuRV+BVPVQDzZGJ6uAlHULFFH8RynS9lFfjDCiAyP78uraeupMhgGinSWmpWEfARbEmcW42I2LjmSKo6jnkJWjPt3goj+Wt5I8Tc7Qe8MllrI+7Ixzu6jjxRmEs3lAwWbhOYMRmxgUMdrVGVLVi6qhjZg9qGmlI8ucl+tl9v8FJafYX9ppXURbcel5AfUvcQnK3RkmvJHiEMFKof5dnW8YTziAfso/V74cmJO5pEev2o+sorWvGaGOcK1Vsg1924xV4GnadGsVMe9UXYEx2Gch1xTJ9FJvXgXKDzITGZVucOx1zewogUG/iCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 19:40:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:40:08 +0000
Message-ID: <5aebfa53-00d1-4343-906b-b97f6f83837e@intel.com>
Date: Tue, 9 Dec 2025 11:40:06 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/32] x86,fs/resctrl: Add and initialize a resource
 for package scope monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0138.namprd04.prod.outlook.com
 (2603:10b6:303:84::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 74e25948-66df-45ff-47af-08de375ac267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OHZLZTZXQjF6TEQ1RFlYYzBzR245Tkg3cUpTZEpLbkZIYlZ4clBhbldFaUZR?=
 =?utf-8?B?V1Q5enZrRmxYbzY0TFNoakpBRjQwWExwMkJLNzVsbDFHeWVPZXpKN0EvQXVB?=
 =?utf-8?B?K0hjS01tZVNqMW1OcVdxdjlkOENtdDZlVXJsVHM0YURVNVU4NDFIeU51YXdj?=
 =?utf-8?B?MnhlRHBYSHdRQ1FraGZPbWFsVzVRZVJNVklMcFVKVSttNURiRlVlb2FiRUYv?=
 =?utf-8?B?cldHZWJOYmlMYXVCRmdLZStGN05HeGZQUVorTjJwWmF4SHoySWhWeHZBS2JE?=
 =?utf-8?B?NjdTVEdtb2IvY0xOS2FMampNbnkxVCtsVkpZOTJJSmhLMlpRUktPTjJLZzZx?=
 =?utf-8?B?MFhRZHNCbVVyZmx4RUlxZVlNQUpMOSt6ai8vbE5sWjZpS1ZERllhZmFIc2Js?=
 =?utf-8?B?a1FRQzVzdjRYOXplN2kyMUg0Z1BibjBGQy9QYzFKTU5ZQ0E1YytoZFh1c3J6?=
 =?utf-8?B?SWMwZnMxU3BHeStlUk4yRUtFcXorSEJ5OXVpaHdYVUh3cjhhNU9iT1pDUFRo?=
 =?utf-8?B?aFNUTUdzc0dhK1AxNzNLaFU2dDY0cWtreEFPcFl3WVRxR3dOS2FCamE2alU0?=
 =?utf-8?B?WWpNSmxHOUw4cFJmSjlLUUo3R3lreXpwL1JKekxmUmZ2cDk4TlhXRXJJZzRZ?=
 =?utf-8?B?WEVMWG40a3FtalN0bGdUTnJSeEJ3UFo1OEFrcnF5VHo2WlhLTm1UVklIV2Zm?=
 =?utf-8?B?WXhRcy9LQm12YlRqWTBoRVZjZ04vSDYrb01mMG5Na0pvQjFuL1ZjbHVQTDlH?=
 =?utf-8?B?alR5bVZlV1FnSzF3UnA2SllKcXVCWjE1VnRJWnpSZlM5YS9WSVhJZHpweFBq?=
 =?utf-8?B?NXZPT1MyZlN1endOVnEwQnQ5NGdjdHBvc0h2M1Nwb1NxeW9pQTR6OE9GY3Vx?=
 =?utf-8?B?YkVCVVlycGsvb2R5bjMxdDZQUXBSU3gwbTdialRnZ0pPZmZCMVV6b3JPZ0FV?=
 =?utf-8?B?aWJrZ2pXYk42UXdMVXJ5K1ZtSnRRM1NrclZtNUR5K3dFZyttZE5yeGthMXQ3?=
 =?utf-8?B?UWU2YldxTWdQVjF2ZWs3NUJjUGlybzVONEVVSGIvdWdDaFZ0WDhBUG1SeHBt?=
 =?utf-8?B?NzNTNDZES3FvYkNMQU95UE5IcWN4R3didWtRdDFPdXYvZllpRlZpSWdQSzM0?=
 =?utf-8?B?bEJ6N1VxZG95QnJMRU5Xai83OUpPUDR6UXpZZFFVSTZLU0J0ZTl0cDR3Zkwy?=
 =?utf-8?B?dDkzRUhSWUx2dkJQRm42RWpzdit6Qk85VGo3WnZ2S0FSUlVtNmZPN21JSWpP?=
 =?utf-8?B?REpRWEZKNWk4dXdGdVNJOC9XMnVXN2R0cmtFM1E1aHBZbGhpNnhwOHlwUmV3?=
 =?utf-8?B?U1AwKzlOWU5iUmY1STdvUWVnTXI4SWI2Sk9Zb09GU01tYmk0dWtkZ1QyaG4y?=
 =?utf-8?B?T2g5bjhZYmdabFNDU2NDRU83UWdWeHVHTVpKK1Rzd2ZXU29mamRPQWtaSHJt?=
 =?utf-8?B?cXBaR2srRm5tSjQ3U3J3WDh3M3ZPL05tNzdaL01YVEZjTld2eVpyVkZPRmlm?=
 =?utf-8?B?dnlwZUJ6ODF4NTJYT1lmbTdhKzFLeFhBR05aVGZTZ0NSQ2luQm9UeDlFVk5Y?=
 =?utf-8?B?NFlBYmZvWENNM3lyK0NXNkRsYS8xaVFXTk5PbHV1OXpTQ3ZJSFVxT1ZDdk1m?=
 =?utf-8?B?OXcyK09tcDAzZmpJc0h2OFRGcnhnQWJraTRrYTlMd1BhMU5PMEJPY05MV0wy?=
 =?utf-8?B?ay8xSGh5dGJURWkyUHI0UFhBMVJBZ082aTRvNEczSkRNZzJhcE5XK3hFZjdp?=
 =?utf-8?B?R2laSkxzcm52bDQ3ckJKd05BVWRGQmVWdXQ0YXVWaDlyVG1iQVozRkxBWGdi?=
 =?utf-8?B?S0g1a2ZkWUgyS1o4T3UrWm1veTUxY3JDYnVjVG5TWTByNlhBL1VnSGxTaytE?=
 =?utf-8?B?aE5ybmdxMkFSQnlPSXc1azJEM0FLeWs3WTZ4VEt6aWdjVmhnRUpDN0M5Q0Fx?=
 =?utf-8?Q?KGoCgD3B71/0y5GAv7fM6QK9uxZ4ybRN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ky9ERlFuR1JZYzM3REhPYWlXTUxBSUY1N01YR1l0ZXM2UW1TWWZNM0l5T0Zi?=
 =?utf-8?B?WERpYTNSdjVMU2JjVXh5R0tZbjhoS1Y4dkVxeTZRdGRmbXd3aDlLUy9lUjFs?=
 =?utf-8?B?WHYrZC9kbHd5bHJJMDZwS0Z6ckFwNEdYaDU4WmpHS3lyRzdpcGZITkVpSXc4?=
 =?utf-8?B?UzlYN3orckpGYUQwU3lGVGphejZvT2UxQTFiYm5Ybi82emJ1TW1DRldtRGpG?=
 =?utf-8?B?dW10eVNXOEtkcmQwVmlsTnloNVNJbmVWci9CS1gxeWErTWx5Z29JYUcwT3Fv?=
 =?utf-8?B?UlJMM2xYWndjQVAyems0N0ROdFl0NlViM2FWelVkRCtYQS9lTTV0Wnl6Z0xn?=
 =?utf-8?B?NmZnZ2VGTGRzWnRMbklMUmY2Zk5mc0RqQUw5T2NEeEdxWUUybi82RjRtenIr?=
 =?utf-8?B?WEdpajh2YTRrcXpES1BpaVRvQlJITGlrZkozeVl0Uzc4bmhRV2RvM282c1Bi?=
 =?utf-8?B?QWEwUGRhQWxKTldaTTIrWGg3UXFPSEwxQi9kV1hDOHh5U0diaEtEcS9zK1FB?=
 =?utf-8?B?a1dZd1poa0JrMnN4OEQvU0VBZU13T01JLytMeGNoNkZzMWovYllMM2JTYlQ0?=
 =?utf-8?B?YmdwR1Y3S0JXZTdPM2gvanNJenhzQURtaDFxK1lhSVQya0o2TUNGUWdCZ2NF?=
 =?utf-8?B?cmVVWmc0NUQya0xEMUFVVnBXUzM0YU51NFBicGNtR0h2RXR3S3Jobld6aW1j?=
 =?utf-8?B?b1Y5cktPc0lES0twamw0dzlVbXVpcmo3V3A4Nmxkd21EdjFCcm5veDJITDlP?=
 =?utf-8?B?OWlVQmRTa21ERFZKQ1dUMkZXL1lueG9mSWRRV1F0UnRyS2djRTBudnowTzd3?=
 =?utf-8?B?S1hDK0RJd1l4YllaNk1aSHc1QzRQMlJJMEpzcTRSRUllQVFrM2M5VVlsMHBB?=
 =?utf-8?B?YUlLMmsxVHZ1b2EyMk5vZ3dLeTNqejVFSXQ2bm1rd0ZjNTBUT3VJVG9iL3Az?=
 =?utf-8?B?UG1kcmtlQVUxSkY1WDVYejZOUFdpOTY4RUtQeUJleU5aZXhrWHVjOFFxazlm?=
 =?utf-8?B?T1p5eHB5cjVXdGYremFSSm9yd0FlclQvYWFCZHlwV3IxRDdNTkJFakV0WDFy?=
 =?utf-8?B?VVJxa1FmNXRGMWc3cTBPWkdRYkFDUUJaUmN5L3l6U3RVRktPSXk4NFR6NlBv?=
 =?utf-8?B?TnRyUG9LUE9YbUpUcU9jcEJEaTZ6UEs2VXpJZnlDTEhFcUxGeVVtNzJpeWdX?=
 =?utf-8?B?d0FsYm9RVitucnZnVGt2SDRGTkJCcnNXVW8zUkNxcXFuUDdISml0ZGcvWGMz?=
 =?utf-8?B?VGJUcFdsV0hMdk5YN2daT2Q1ZVJFWkFsNnVtajl4Uk1Iaks5WnB4bzdlYklQ?=
 =?utf-8?B?dXY4UUpLVEVLSTh1MHRVTVlaYmZFSlh5eVgzM2xTdHdaOUdOeitCWWN2K1RP?=
 =?utf-8?B?OVZ5NkI2YUJ3RjgzK1NMbTJoN2Z2cUJ5WFZWbkkzSnRpeG5XbVlGOTB0WkNz?=
 =?utf-8?B?SkhHS2c3WVJlNWlkTGxJQkt3YzJkelVYTmx2S21hS0FxcGFmbVJYVGpHMjBL?=
 =?utf-8?B?c3pJVGxEMnpZeldnMjFhOTA5UTB0Wi84ck9Gc0wwMU9BMWRqbXZJakU4YmFU?=
 =?utf-8?B?a016TUJWQTlmVE5hUVFqODdmTGtjRUthTzA5NWRONnlBeDNnV2pxcldqcVdT?=
 =?utf-8?B?MDg4Q0xRK25IRnhOUlNYa2duUDdpZER4WTEySThzQjV3NjdDN2RYUVBXTGRy?=
 =?utf-8?B?SDNBbm9IQklHRGxxdDRNWEFUbkpEVkFlaTRpOThSZWhRSVEzempqUEM2dnRP?=
 =?utf-8?B?V1ZzVXVYTjkrMUV0ZzRWU1M2WVN3VlRKVjdxeStBbEdRU2YzQ3F2TnRzb3BI?=
 =?utf-8?B?TjlXcGdxa0NGT3Nick9FMzZvSStZL3Q0aWN3RlU5ZkdKUS83b3F1U0RaNmps?=
 =?utf-8?B?b0REL0dhU3FhUlBYcTg2QjNXK1dEcUIrYkQ5K2ZCSi9YcGt4Y1o1VFp1a3pF?=
 =?utf-8?B?dFcyRHRmQ0lvd29kSnU2U0pqN3J0STNTelhrWEpuWnFoR0MwZEhURUhrcUtU?=
 =?utf-8?B?YnEwb0FMY0NhRXRiSWwzU2wvTklxbko4cTdvd09GS2xqeWRJUUdJb0ZmRlJU?=
 =?utf-8?B?UE1pL28rUm1hazBGVFVLeHBNaGVBanZSMkZLanFoMzJrNXdaZDZHb0V2aUtG?=
 =?utf-8?B?MlhmaldreStUY1ZwSm1pNUdPdVBtOEZJMUdVZTlLUTR4S0N2T1ZtMlRpc3Mr?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e25948-66df-45ff-47af-08de375ac267
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:40:08.2621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKRUC2Y/nnTX0ApfRbMokGDSWj4Typsj0fxIb3qG3nVOFz/r2OXrK/ZO8CQshBxFd0b1kgq/n7O0N1gcvbj528ZwLXBpR1BCYvs20HxfA2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> Add a new PERF_PKG resource and introduce package level scope for monitoring
> telemetry events so that CPU hot plug notifiers can build domains at the
> package granularity.
> 
> Use the physical package ID available via topology_physical_package_id()
> to identify the monitoring domains with package level scope. This enables
> user space to use:
>  /sys/devices/system/cpu/cpuX/topology/physical_package_id
> to identify the monitoring domain a CPU is associated with.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
