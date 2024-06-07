Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8132C153517
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 21:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717794530; cv=fail; b=N56nZBejX0xH3DvhDTSZ63HNoWCaknNTPAYEaLgzmMGMMwe/G+HBMmzpC5laJ5RBGrXpmOYlFJ24KAZhSOcuncF/DHrH+Z6BAb7jndzoqZMGpAmFIpL1Q4RhJ+LUPw+VCzQsNkSeaKt+VVNnMrfIUrtPkYZz7BlMdOdvvE4gJIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717794530; c=relaxed/simple;
	bh=OCzADJfiSQIPxbpWLQXovvJ6nyKHeWY9VyokB9iydDI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b5rv+MVyVXdOi2ZAbptkUYMXNpIRhHMPROMd+IjB94q66QHfOFn2lMcUrYQUkpAupFUQo7aom5STLrzBSTG/XNjamKGOFtvol3KdH1mSxIUlqBNlcZ0PxGbH+7ybaeE2QFzSaZ59Xix/bmaYn2vB9wbGzrcMHt4wHGnEQeqmFpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LOX2ALN/; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LOX2ALN/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717794528; x=1749330528;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OCzADJfiSQIPxbpWLQXovvJ6nyKHeWY9VyokB9iydDI=;
  b=LOX2ALN/sIq1BvDRuOwb83IiKIg07dArxmv7RroowlwaQLva+2ai0wM+
   PCq3+UvrK3L84L+/xvmb9PJ4pTH3LQaeM7P+eUsHzcMPGMORCDCYTPEXn
   uujPGBjoLlkPhAKZ9AORndmO7fcw1fbW0bV/9rR7WUJfVyL9KaM4CdrGD
   rBKcB3WJ92+V4X61IGidozziv3YrZ8DFx80b3snHYEx73fpGmcGkHhYKV
   Al6mcSrgOpnMK5rflm5k4RkUGZtjptnTjYMRPIMYTb7AfIV35FXdNa4pe
   TwkyiL4RS9szjLGEoaguRPFulabHOao/RVgjWdnWEL8Qc1Itih9XxnfPH
   Q==;
X-CSE-ConnectionGUID: De5MUYAFTtub/XoALSZ1tg==
X-CSE-MsgGUID: AQFS4G0KTZaZWjwbLZ2YsA==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14768631"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14768631"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 14:08:47 -0700
X-CSE-ConnectionGUID: TpnPdRfRSJm2w7yX0icrkA==
X-CSE-MsgGUID: Oeh4z5HtS/mXtWkrFd75gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38439855"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 14:08:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 14:08:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 14:08:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 14:08:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 14:08:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJ+1paQ770wkUqmXkVEZqJzP5yp/9VgAEBzpPAn6hvYzBnmQtY/KNy8lhxJQclgCZXbCy0rpyLY2lrrD2s5Ssfr4CbcJsmRhy/+cSuArDw7tAEcgGsZvmW0hs7IkQGvoRnCwYMjO0xtHuek2OKR1eu0EuEaZ+wrRqZwXIk+n4tqMM57GxF9QGsFqJDL6T8+Om28PjsuonN0DoNSgMBPpDFqOFCdQ3RIZ4dYzv4fF7bOr6w5IVH4erPP1TlPHFWxBu4cjtbikRAZANsSvFN+knmad0o8q96qLZ+LFPUMP7iKqG+8z+YS98Qb7DKFCC4eVYZtf4/rukPGZOhY4MdB51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbdWrZwy9OvZKxdBeTXwJ/yYiEEgEOZMZcdeoIux6Ns=;
 b=bPGRhKUH3r5TDsi7dglVQhUCddVuX9AIl7szxs6bDJ+W1jw0Bhjp6Pl3DAm1lATuFaxodSUvyZaC0Uv8FEanPmAtr5qCftN3VaPkCBNqqCkON3NMygvuS8VRewwfpEAf7eev6BCmFtOoR4SRuJN7Uzoua09S9ASoPE7zY+r1PPkv+WLgiWDdOOahJWZL3tw3bb4NCWaTaJtf+1+ybvrpwHnzOJW4+LOci5ux8ELRlEHjBrGcBNRuqCLbyixOlffrWhWzXBVJRAB/JdygjzuzDdKRnM2zDVWIvR1foYUSyYpvqi15K1CjfkBWLtc5yTmrYfTiNyVV6whQ8k4s+uwr8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7608.namprd11.prod.outlook.com (2603:10b6:510:269::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 7 Jun
 2024 21:08:39 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Fri, 7 Jun 2024
 21:08:39 +0000
Message-ID: <0e6ab67e-bdff-440a-8772-8d462b71cb42@intel.com>
Date: Fri, 7 Jun 2024 14:08:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 16/20] x86/resctrl: Make resctrl_arch_rmid_read()
 handle sum over domains
To: "Luck, Tony" <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-17-tony.luck@intel.com>
 <9818c304-9056-4d79-acbe-2b35cb847ecd@intel.com>
 <Zl5OmVWFpBtA509j@agluck-desk3.sc.intel.com>
 <03ab405b-d7e4-4c35-8a3f-546ffd590954@intel.com>
 <SJ1PR11MB6083EE537A820BB7CD42D2BEFCFB2@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB6083EE537A820BB7CD42D2BEFCFB2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0287.namprd04.prod.outlook.com
 (2603:10b6:303:89::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: fb9b3bb4-453b-43ad-de95-08dc873600d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Kzk1UE9QMjlNVk5naHU2dmp6NjQrZWkwc0hNdEUzbU1lTW9FWHNwRThVdVBa?=
 =?utf-8?B?anU5VUhMK0RNR3FGZnB4TFdTZ2VuWU1sLzJ5TGl6aG04WXhWUXppMHArR29Z?=
 =?utf-8?B?ZFQ4NjlkaUtNREFFcTFYTGxSNmIxSHY2VmNyR0RURGF6YXF3bjJWcXVXSjFU?=
 =?utf-8?B?QWdzOUkwNU1FZmwzSGI5WUoyTHhUeUtxRHJvNmdsR0RoTk5uQXFaK2xVVVF0?=
 =?utf-8?B?RkRBWm9qMTA4cCtRWi9rZnI3Y21YNTQrL1lRYzQ4NUJmd3RhTWlyRyt0WWpT?=
 =?utf-8?B?TGI5b2t3bTJFdS9QdmRpMDMyajg2QUNlaCtCdUFZUCs5NFZPcy9pSktteFQ3?=
 =?utf-8?B?SUpFZTNMeDNDSnVROWFMTHZONm1PbGtWeU4vUjU2Zjh4dEhqaEdJOE1qK0hm?=
 =?utf-8?B?ZVMxNUViLzlkZXdYS3V3U0Rua3A5WVYwdFVadmRLaXZTUTA5UGFkWkRsbStN?=
 =?utf-8?B?UkgyQnZWZzhucVdjSE9ydCs3ZnVadzdMSjV0THFUL2hDQm1NenpTc3IwYzBv?=
 =?utf-8?B?RVBPQXhQV09UY0tzRUkzYzVoa2Jyd29PS2NrN2NWcjN1QlRMTGYxSVNnd1N2?=
 =?utf-8?B?azhpVHNFQVRoS01WL1FHK2R6MTZoMnNyT3pXdC9EY0lVTWJGUHk4T3RkWGJQ?=
 =?utf-8?B?OFhzR3NRSDVYVjIvUFQ4U3NGYWd0SzBQY0w3bmpjODA1Zm8zU1NHRllrb2sy?=
 =?utf-8?B?cHI5T3lPK0dtL3Z5Ymt6bnJOMDFQOGtlcXl1MzBTanVIbGtjRGo4VGpCck9y?=
 =?utf-8?B?d1FaWHc4aStaMUEwQUFSQTNEYit0WTFZTllIUy9RSmJsNEhwU2ZFMUlJSjZD?=
 =?utf-8?B?bEVwTTVRUGhlVEJuc2EzV0JDMWhpRmNBOXZ1MkRkaTNNQ1ROem9abVlJZWFj?=
 =?utf-8?B?R0NxMk9RRDVJOHp2UEVaVTVYUlVTa2VRRWNJSXVxZGp4N1dNRmJuRXF1U0sw?=
 =?utf-8?B?SkFBN2dBa0loeGhOSHIxSFB1UDRKZkdFZmlpRllkNzd2SkNJREppMTZ4eG04?=
 =?utf-8?B?cE5mMXlTM2hvaVVyeEp5azVadlUzWHhPUzc0azM0RGZZUXVCNlNGZGh1cEY5?=
 =?utf-8?B?S0tYdm5mM1UvSG9BTzk0S1cwbDhZY1FGOUJaNytyV0E1cGQyMHpoWDZPb0h5?=
 =?utf-8?B?ZTlubWMzWlAwWHVEUmMzdHd0bDc0eFErNTBNSTUxczVweVdVTU9sMWdlK01a?=
 =?utf-8?B?VlByeXgxUTQyNWtxK0FPcklWUHM4NzRhV3BRT3JoOWxDTjRFdHJHMDBVR3Y5?=
 =?utf-8?B?QjR0WndSbjJ3U0w4R2ZmYjFJR2RPL21qZkZTcnFxUHZxMGpwMnF0alhFcFZi?=
 =?utf-8?B?Z1ZxU0xoTTZwd3FsSFJxQUtYaVUzSnpaMEF1L3dRZjYyYjVyajRCb0xiVHov?=
 =?utf-8?B?dVBhYjJodnkvMklxeGVDQmxoSDcycmhCR2FhU01NVG03ODhXTEdFamIyNVVI?=
 =?utf-8?B?U3RYMXI3eXRPUmVaOXZnNldHYjdqdWs5aThYZ0tEd1Z5TjBOeCt4SHg5VUta?=
 =?utf-8?B?cGVrTDJ4RmFQS0Z1QmRtcGpDSDVJM3FMaTR6U2JwNnREc0FrYVkzR2R4SlA5?=
 =?utf-8?B?NWNBZDlYRFN5K2VyN2c3T3pGb2ZtS2dlYWJrSmI2c1JPM2R4TnpzQjZMWWsz?=
 =?utf-8?B?cFVxNnpIQWpLSFlNYVFBY0w1dWtVN25IdWt4T1lSVCtUaXJGdm5DUHRBNk9k?=
 =?utf-8?B?L1Q2cldYS1YvWEZvTUs1WkdWRWdtMi94cWZHTUNXQzN5c2JKVVZMbnY0cU9w?=
 =?utf-8?Q?foWZDUmCun+ZIWsZeGrFgTCDX4e5Go08dglaet1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWRKRUwwdTNPaUxZRHBjQ0VaQzBiblFsblp6OGlTdXNwR1hGUTdYUlZjYmxa?=
 =?utf-8?B?eGdZZTBlTUwyNURua2pwQlAydSthTml2cm9xYmRkcXV5QmlOOC9vdzJXMVF3?=
 =?utf-8?B?TTM1QW4ycXNmMzAzNzNtcmxxSzBuRFBuWjVPSnVFbGxtdnc4clZXUnlJdklw?=
 =?utf-8?B?NWl0Uy9jSzRIMExzUlowNURBSHNqTWlNY0M5RFQxOWpBdUFqOENrQmJWdi9i?=
 =?utf-8?B?VGJSMkdTdHRYMHl2bk5KK3BuV3RrZTV0YjNvTzJHd3h6OTNaSzQ1U3dLcy9S?=
 =?utf-8?B?S3lUK0JPZU0xbldHSldQMDRUWUZxRUpxQkhtVWtCVHIxVlN0TE5IS0kweWJT?=
 =?utf-8?B?N0hZcGdMMUEvdFlwM3o2Y2JwUW8wUTIxa3huZXY3WlZlbVFXWUY0bm5hQW5E?=
 =?utf-8?B?SnZWOHcreU9VQXB6WnNIZWhwSU9Fam5aclR1Q2g3c3RFSUtEbTJzb29rYmdn?=
 =?utf-8?B?UTVOYUhKVkRZWjIzTTQrVVJpYThFMkZpYTN2UkFuL242VkhyTGUvZElYMEwy?=
 =?utf-8?B?aS9UdHMreWQ3T3dRT0ptSFdGb1NOTWlaUEZQSy85YVNhUE96L0NkWjRGTjdV?=
 =?utf-8?B?b1Jmdk54Z3RkblZKM243RXVVMUQ3cE1PTTdDd3hhT3JlL3pabERmSU1uNy85?=
 =?utf-8?B?Um13aXVWdFY5V3ZSWUJLVGtESytyR2tzTXFDaEdRNk45S0IxM1ZrbjBmdC9n?=
 =?utf-8?B?ejJOcGFGK2ZzOTdBTWhlNXZVbnFMT2xFb2RWdU5LL2UvVm5teVlNLzZNQkY2?=
 =?utf-8?B?aFFsdm9yQWp5TDd4VEIvMXB2Y0xmK01pMWorTkRCdVNoRVRvZENNbWV5RE5a?=
 =?utf-8?B?VjhiT2tjM0tNazFrdm9CR3BocU50bXlVTU9iVXF4Sk1DNmMwaVo1WmVBbGZB?=
 =?utf-8?B?T0hlZEV1RklyU2JmYUFZWE51dDRiUThCbXpZV29iY2o1VFFjY08wUGJ0R09Y?=
 =?utf-8?B?NnRFb1JwMzVLOUVLNGw1S0pXUmFHMS9LMkQ0dDhkcFhJMTFSbCsrV2daOWln?=
 =?utf-8?B?T0hMei90VHpiak5YNGFxbHpZam9Xd04xVklLVVZDNEs1WWdNUit0SklKWklU?=
 =?utf-8?B?UHR5dzBNR3o0RG5uWFBUTzg0ekU2N2EwaUFONUlXVHhCQlo2SUpYSnc4VlUv?=
 =?utf-8?B?TGV2ZzVDVHBWd2dkWlJLNkxOK0RvWlltVFpqYUY1K3VJT3dxWmRkZnVqOHJ1?=
 =?utf-8?B?b1YxZjQ5dlAzQnZSUFBjU1dTRW13eDgvRHQ5TEVxWTVuN2xSZDZtNklNN0N2?=
 =?utf-8?B?ZGZJRjFCdlRMTkRHTHV0alA5UFRycm9iQThhQUN5MTBrV1BoOUZWYnE1WUh0?=
 =?utf-8?B?NFhrZjFpWno5ajlTQTdsYk5YZkV6ZHNnUkZZUVdkUVoxaDZQeW5aT0NXSlpo?=
 =?utf-8?B?UmM4VmxpOUdSaDNrR28raG1mbnJkbSs1d0xmQk9IOFN3dEJqRC9WL2tKOFd6?=
 =?utf-8?B?RFFMMGpwZU1KS0R1SjJETU9Ldjk2SVhTTU4rakJlWHBJNTU3OFJVSFdzMzBQ?=
 =?utf-8?B?emZxQVo2NDl3U0ppVWtLRTM1K3A0clJEVWxHVFFYSGNHdkgra3MvVHIxdWpJ?=
 =?utf-8?B?RmNMUUtMYVNVYWlQM2lrQnpIZHlPWlF1MlJEY0VRVVkrODRBckMxY0VieUJ6?=
 =?utf-8?B?OTlGSDBXQWw4SDFxUmtqRXA4eTJOYlJoVzJvUW1na2xUOVNKMEF3SjVqaWpH?=
 =?utf-8?B?RjlPSXQ3aVJtV255dXgrOWhib2xia25TOWVYWUNHdUtMbXFEbjNvNHMvMkov?=
 =?utf-8?B?VVNtMnF5Y0s5YTFmM0JNT2JYdlA3cTRCMXFrdVdiOHc3b3lRK0NiS0hyS3BX?=
 =?utf-8?B?MjIxYnZHU3oxME5mYUwrZ1kwdS9JQTJiajI5MFdNVUZZTSs5UXBkdGNJRGEy?=
 =?utf-8?B?SW9QZ25TdlhBUUQxQXVzUDJhdktiUTloOVJBbkc4WEcwNTQ5c1RuMm1tRTdT?=
 =?utf-8?B?RjdERU9zYzlNZmEyTzZCVVBDa0xuZnU1ZmI4U2JxMXAzclRkcDlpZE5WQ0V1?=
 =?utf-8?B?Zkw1RU54RmtubVhiTVM3bGwrU1gvL0tJL2RaVHJTNlNwdC9UdTlpZ2JYUzZz?=
 =?utf-8?B?MGdBNlNrc0NwWVhtYjM2V3h3N3VDRW56K2RZRlFNeEhoZTFCQktteEVCbTFU?=
 =?utf-8?B?Z0Nza3JNSjMxejEvRkErMldFS2FaOHJjZ3AzRGlMSkNzSUtYOE1ZcGZldG1L?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9b3bb4-453b-43ad-de95-08dc873600d5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 21:08:39.2806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17cLw3f56Xyc/arbt7QSa7yjtn8DvJviVWGEFmfv5FxxLny167rjpwzKEAEqG08brz6/GXJHU/AtzeFqGuAOn0561tFm17GkW3OITaGj+E8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7608
X-OriginatorOrg: intel.com

Hi Tony,

On 6/7/24 12:51 PM, Luck, Tony wrote:
>> Hi Tony,
>>
>> On 6/3/24 4:15 PM, Tony Luck wrote:
>>> On Thu, May 30, 2024 at 01:24:57PM -0700, Reinette Chatre wrote:
>>>> On 5/28/24 3:20 PM, Tony Luck wrote:
>> ...
>>
>>>>> +
>>>>> + return 0;
>>>>> +}
>>>>> +
>>>>> +int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>>>>> +                    u32 unused, u32 rmid, enum resctrl_event_id eventid,
>>>>> +                    u64 *val, bool sum, struct cacheinfo *ci, void *ignored)
>>>>
>>>> This is not architecture specific code.
>>>
>>> Can you explain further? I've dropped the "sum" argument. As you pointed
>>> out elsewhere this can be inferred from "d == NULL".  But I do need the
>>> cacheinfo information in resctrl_arch_rmid_read() to:
>>> 1) determine which domains to sum (those that match ci->id).
>>> 2) sanity check code is executing on a CPU in ci->shared_cpu_map.
>>>
>>
>> "resctrl_arch_*" is the prefix of functions needed to be implemented
>> by every architecture. As I understand there is nothing architecture
>> specific about what this function does and every architecture's function
>> would thus end up looking identical. I expected the cacheinfo
>> information to be available from all architectures. If this is not
>> the case then it does not belong in struct rdt_mon_domain but should
>> instead be moved to struct rdt_hw_mon_domain ... but since cacheinfo
>> has already made its way into the filesystem code it is not clear
>> to me how you envision the arch/fs split.
> 
> Hi Reinette,
> 
> Files in resctrl that sum over resources are going to be a necessary feature

Sum over resources? That is something entirely different from SNC, no?

> for backwards compatibility. I'm doing it for the first time here for SNC, but
> I know of another platform topology change on the horizon that could also
> benefit from this.
> 
> Looking at the end-point of the James Morse/Dave Martin patch series to
> split out the arch independent layer to fs/resctrl/ I see that fs/monitor.c
> makes calls to resctrl_arch_rmid_read(). The x86 version of this remains
> in arch/x86/kernel/cpu/resctrl/monitor.c (I don't see an MPAM version).
> 
> James already added two arguments that MPAM needs and x86 doesn't
> (hence "u32 unused" and "void *ignored" in the argument list). I confess
> that my thought had been "If he can pad out the argument list for MPAM,
> then I can do it too for x86". But that leads to madness, so time to reconsider.
> 
> I can see a couple of paths.
> 
> 1) MPAM/others will also want to have files that sum things, so maybe they want
> an extra argument that shows what to add up. Though even if they do, their
> requirement may not be met by a "cacheinfo" pointer.
> 
> 2) Only x86 (Intel) will use this. Maybe in this case the answer is to do some
> renaming so the "void *unused" argument can be used to pass architecture
> specific information.

By creating the new "sub" monitor files the sum of data has become a feature
of resctrl fs.

By including a pointer to struct cacheinfo in struct rdt_mon_domain as well as
struct rmid_read it surely is not just for Intel. If you want to make this just for
Intel then the whole solution needs to be changed.

> 
> Sketch for option #2. Currently the code does:
> ---------------------
> 
> That void *argument is currently supplied by a call. E.g.
> 
> 	void *arch_mon_ctx;
> 
> 	arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, QOS_L3_OCCUP_EVENT_ID);
> 
> 
> 	resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
> 				QOS_L3_OCCUP_EVENT_ID, &val,
> 				arch_mon_ctx);
> 
> 	resctrl_arch_mon_ctx_free(r, QOS_L3_OCCUP_EVENT_ID, arch_mon_ctx);
> 
> The x86 version of resctrl_arch_mon_ctx_alloc() just does "might_sleep(); return NULL;"
> and resctrl_arch_mon_ctx_free() does nothing.
> 
> New version makes these changes:
> ---------------------
> 
> Add rdt_mon_domain * as a new argument to resctrl_arch_mon_ctx_alloc() (which MPAM can
> ignore).
> 
> x86 alloc function becomes:
> 
> void *resctrl_arch_mon_ctx_alloc(struct rdt_resource *r, struct rdt_mon_domain *d, int evtid)
> {
> 	might_sleep();
> 
> 	return d->ci;
> }
> 
> resctrl_arch_mon_ctx_free() remains an empty stub.
> 
> 
> Is this a reasonable way to split the independent fs layer code from the architecture specific?

Why is this necessary at all? The new variant of resctrl_arch_rmid_read() introduced in this
patch does not contain anything that is architecture specific and thus it is filesystem code.
It is this code that uses the information in struct cacheinfo to set the correct domain, if
needed. In this patch you rewrite resctrl_arch_rmid_read() as something architecture specific
but I cannot see what is architecture specific about it at all. Why not just call this new
function resctrl_rmid_read() that stays in filesystem code and then what you have in this
patch as resctrl_arch_rmid_read_one() should be what is already known as the architecture
specific resctrl_arch_rmid_read(). It is the architecture specific RMID read function that
does not need struct cacheinfo.

Reinette

