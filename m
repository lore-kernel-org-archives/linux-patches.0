Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E267919067C
	for <patches@lists.linux.dev>; Sun, 10 May 2026 13:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778421173; cv=fail; b=NWzFCDfDO9eDlRT2FP/SubPEJAKE+WJfPsnR9fyjjTtFconK607ZPnv1hEZXyfOcQKQO7L9UJWLCM22zYqXzP/xe6IdURFsXqlDkbPKapqX7JWdjArxkQRpPc/uDt5fk/DH/hWQ536ynZmW1lzzKtoNlIQITgN6fP/I2QxVSZcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778421173; c=relaxed/simple;
	bh=tfryA36gdZs8+YLIA93cmw/URDdoikhgbePRhoTrRwY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bIpcbGVEp4ABGGL0ZHnwNk+2rf3LyCdO23UihwLw1kcVSHrZXdOM7xo+jY0WCC0iLV+3wAzUQLxQDwtRjcyRYtkjAoyzb7GHvCX5zSPewVhLgrN74LcL4+8E2CHK4/MjPcwkPNvxn4iA2yE7B6Ur3oqOAq4H1aHDCGV9HW10Cx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aKpQb04P; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aKpQb04P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778421172; x=1809957172;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tfryA36gdZs8+YLIA93cmw/URDdoikhgbePRhoTrRwY=;
  b=aKpQb04P5GoiMzlUqerSzEFrBH94mxYecKXYhZ0NYPTvVMfcW6jSeVRD
   dsAaln05PvTXWPnOiKSYNSCJ0Jelue1lGbu6iW662LQTFD0ExB0awTuNz
   VAxwOwcdTDbdvn2y7tbkn8auc3G0n+CjNSOW990Q9fPJVfCVNJfNxDT04
   SbbVjDpQkX3kpFsXmH7bWQG5a0CATbztziaZ9I+uASKftRf0S09r+EOUt
   B7ylHcKwDTamyqzk70bZ6d17V+zFITUqgcB2j3h1RBfE2OcVs+OlyOYh3
   asHW1lwSWZKc0QJKx8fTFH+IVR3JzF6rdVfGHFl8SZey7HcNIl90+twNM
   w==;
X-CSE-ConnectionGUID: 62UlC3flTBKqAu3eMyHgRA==
X-CSE-MsgGUID: TY1XWKLVRSGKHUeLeewEiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11781"; a="79512124"
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="79512124"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 06:52:52 -0700
X-CSE-ConnectionGUID: 59wa4QksSlulH9P8NK6hCA==
X-CSE-MsgGUID: 24i6XjDqT3Gvt4WzrwwoDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="234159893"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 06:52:51 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 10 May 2026 06:52:51 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 10 May 2026 06:52:51 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.57)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 10 May 2026 06:52:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bVEVL0I7VD1tR/lY+8G7jyIXVEVSvOGF//fog2pzt8cPjHW8WNBqGhMpe/KZUjQAuW5bIXuTN/lXLcSjhDH6p5kiOP5Q/VE+vcmvMaUc76xcD/V9evz/gUSy6nBjqxUi/9HeEFBnGd7OkTzS4YI1ypFyrV0NMUFunSLQzCJqOvzk7PuS0ndNlbEiXgC/LDlxulI9GyLqxAMBSdkgLRPqlWPSVXF3qChfDENz6i63Q5wQ7RWX4e2xW/BI1NCYmuEcjltQda51DMhzPOdKZKmtXdxtWzBQHe/mr5y2jJpEhcLYverORJ69v0C7ONWX9NDxBOOuAnh/iF8kBSyDjcVF/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0uV8zmQw/dk+lRTNw6wnwswIhar3W0n+R5cK178Vwc=;
 b=Dg7E9mSpBxii+ipq1OGtsVRuqxItUkz2ikCvyOsqyGICtwzgbcK9+zWBpdqxAOPqPZDdV8xNjLCWMJ5bPI0osHG3QHIKJEPPsqBYUBTslykrQE6aqOu0p4fpv9dEiz2J9t7NXyP0bdy7dJxjolaYA0Bt5dRwMjP3UJF7VafYO4mRbYYRkVkdyzrKk5XwmwfwMU2Ab1W+9PlcTn6WHOgZTQ7BHUQRT4VAYrwQMa0Z/63MQLk7h7S/f6BtAJ4ytulObOxnEBhpB743rQdA6iihtCuFKkChxt5gYv70A5s2mphR1AdJCg7dIN8CdNeniospAdl7HEfGunCCOo1LWgIfwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 DM6PR11MB4547.namprd11.prod.outlook.com (2603:10b6:5:2a1::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.22; Sun, 10 May 2026 13:52:44 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9891.021; Sun, 10 May 2026
 13:52:44 +0000
Message-ID: <33c84abd-c29a-4706-9135-84c83aa6a172@intel.com>
Date: Sun, 10 May 2026 21:52:34 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
To: Tony Luck <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, James Morse <james.morse@arm.com>, "Peter
 Newman" <peternewman@google.com>, Babu Moger <babu.moger@amd.com>, Dave
 Martin <Dave.Martin@arm.com>, Fenghua Yu <fenghuay@nvidia.com>, Drew Fustini
	<dfustini@baylibre.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-4-tony.luck@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20260508182143.14592-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0049.apcprd01.prod.exchangelabs.com
 (2603:1096:820:5::13) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|DM6PR11MB4547:EE_
X-MS-Office365-Filtering-Correlation-Id: f0ca0f69-001a-4696-583a-08deae9b696c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 0Q2f6+HjIGbRdQY2ooFSEYhzXPC3ktGoISAUA+UVe0HAGpMsbC8B1bzr6NGd7R4hE7Y2gG2yOaexnleFv3B8tFQuqxMpo0KD2Kz1OTlKqsl8IeWl8qdjHbFXt30vPHPyuqFOcofEcy4QNcIQSlnO8OKSFI6mseaHeMxpENkXu9bdXm0Zcl+hgPBWU8ODdPJQd3VZulKoBNM7rd+ClfGgExA4D4TALwuP4uCiS7fDQ2rZBf+dieCCxKlc3nBip2Vy+8cC4KYudeWEJmGPMhvsIYX7ieaNYQxbOJyVpotRHg5pAUVMRXfW75ttJueO/O0+MmIlzTuK7r8NNoy/YtLt3kU1TIczUt0JNaQi3CEEwT4r8Y10ZJJ2L9OB/GMFX9ZgHNip6QyXyG6DQxadIpB7U230z0wYOOYd1Mso+Y7S2Hx3drBhIiBUwZ8YWrZqE7x67M1LVejJWi+dJueULEPVOTrDqZorUr5gBnyId0smvuBPCRsTv+QWt8D3XepeLSoXNuafIUX1jrpnG/UcNwY61Cx97EeWMw7UiPuVhgjEsvAL7E0vhPunDnWu1vO738pkT1UTdoYZJ215ROsMNvi6T2uqi9HFYjInipmGit765sFPvu7tzIlQKVNvEwZ5pYyXeY1rxDjuNn5bkNl9qs87pVlD+/bAXqaPemPnJyrxsfJUEFz5QXL/YDUJFwB7p0QJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkI5NFE1U1kzdGNJbC9ockRwSW5EMzFodVozdzB2bkFVcGMzelBQOXhPQkNU?=
 =?utf-8?B?MkhZalFWN3ZQYWhCWllKRklObzMya0tRZUMxbUNQeHprQWUrUGs2L0xRVDI0?=
 =?utf-8?B?b0pjdVpnYUx1d2VBTXhPMUJwODNlVC9uOGZRaG5JRTdTZEwvWjRZL3ErMlgw?=
 =?utf-8?B?Rmp3MytEM3Q1WEg1WTA2TXFYbXp5dG5FMS90RHc1TXpxTGJRVjRGaWFlRkFQ?=
 =?utf-8?B?T1dXekwvdndiVkgxWi9sN3MrK0hsVlg2N3hHOVBHek4vVjJpcE1iQUU2dS9q?=
 =?utf-8?B?NEYyWlQ4bFh4bEMwK2ZKcW5uU3k2NGllZ2NkQkVJK3Y2eTlIazZhV2J6Z3lp?=
 =?utf-8?B?a0paRWNpZjZqbHBsR2VvRnFTbXVEVlVoRTBRc21ITFpjTmd2RHROWjZNTytu?=
 =?utf-8?B?QVM2RE9teS8wZGJHMkRlRGRnUlNBc25uR0JwdjNzc2IzS2ZCc2pkY3VhdXo3?=
 =?utf-8?B?Ym51MlM0djArL2xLeHBnU2hzd0RoYUhjYmlyN3N2N3d6UmJRd0dmRGZMTWQr?=
 =?utf-8?B?SnMweUhqMGlxVUs5M2tSRkpOUkpDc2pndmdubEEwY2M1U012YjZaVklZOVEz?=
 =?utf-8?B?VWJ6MUt3MVJwSDBNV3FaNFNFQ0lFSWQ4WStLTWMwTUp2SjVJSGVnL0ZUWTFK?=
 =?utf-8?B?ZkpRVmlVUUUxTHBIUkdFMEJ2dmExZzltdnFDVGNSRzYvUGpKSEtKcXBPK0Qv?=
 =?utf-8?B?ZVhsem9Oa3BnZDVoK01DVk02Qm9Dd3ZPQTBtM0JPbEh2bTdPUXhyUnFST01o?=
 =?utf-8?B?WS9ubjNrRSt0R3pMVjBzR0ZUODdWeUpXZW51S3J3T1ZFSm9IZDdhWlJ4ZmZs?=
 =?utf-8?B?L09oL1dmUFlyenpxek00ejM5czZacjNLTTF0M1hMbFd5c1hDVDhEclpFM296?=
 =?utf-8?B?STJmbmwzTjBwSnRLTUJUVGxMU1NUMldLVkJyTms5ekZ1ODVGSW5KSmpsOHBG?=
 =?utf-8?B?REJBT0dEc25XUWN6b0F2TlVZZ1Q1bWY1MVB2L0V4U09WMlN5VWFsTUdTcHZY?=
 =?utf-8?B?VDRUUnQ0ejNlKzVxM0pVU0IrYm9Wd1FNSnNZTFoweThwQmhvNVk2RmxWYlIx?=
 =?utf-8?B?Uzh4MFc0QTFGcG1kVjBMUzZRRHlqc2ZEVXVSa0ZpSlI1UzVxbXdjZms3K2VV?=
 =?utf-8?B?WnA4TTZYSU9rdVA4M0hCWitzdWpzbFBsQU1rWFpQNmRmK0p5M0pUNFl4MW0z?=
 =?utf-8?B?enpQd2pXREpHc21Mc29vc2cxdUtIVDE1R1JsalRYS1RwQUxoRU5BeGs1Nll4?=
 =?utf-8?B?bmY4UDNBbjB1NWNiT1Vqa3ZLdU1SeU9XdU5WZHlZOFVBNGJDTHBXNDBLZmZQ?=
 =?utf-8?B?alZ2R1ppLzBuTlFuQ2Q5NXZXdWw2bi9TMjdmK1JLeXM0YlpqbXIzdjc3RHpl?=
 =?utf-8?B?Y2pMdUZMb2I1M0lLZXhUd1FwU3JMTDFpNTg5QkE0Mk5qVUJPZ3V2ME1GOVZw?=
 =?utf-8?B?RTR1UU52NTkvRTRteGE0VGJLZjN0TkhCRml0YTNTYnNqd01VSU9YWC9YTE1X?=
 =?utf-8?B?dTFmRjh5RWt3aXoreDVWTzY5dFF5MXhYM2I3aklVRzVidjhpdUdzVkFSMW5v?=
 =?utf-8?B?L0ZDdFpsM2lQWnFiYjlvbkRhY2FLVCtYRUxBYUtoYTlyS2w0UGJjTEFXTDBY?=
 =?utf-8?B?alFWbEozdUZQbjhmcEdGM1d6MnFFcXFBWWNOZ1dZYUdTVEZWQzUvTlN3S2pO?=
 =?utf-8?B?NUphMk5XMDVaa0YrUW93QWJITGU5MHA0bmJOMm5YZXlWUFZiWUZtb0YweW10?=
 =?utf-8?B?SE5YciszaExyTUp3ZU52cjdOYU1IUnNHL0lxQ3JYWmk5RFZrbU1HTnFCdFJq?=
 =?utf-8?B?TUduSHFUZ3l2T0NtL1dkUi82ckh0OHR3ZGowYVNWV2lXdVMxOHN6RUdrTlI1?=
 =?utf-8?B?cHAzeWNUZGhiQVhuUFlhYjF2ZFowcWtialdnUDFUanphQ1pSRzRrY1VqMjU1?=
 =?utf-8?B?b3h3Qlk1c0NPKzRHTUZROFk3R2hVN3dLbTVDUzlZc2FTTFFVS1dzTlhDcms2?=
 =?utf-8?B?YVBjaXBRU3hlQ296ckRoOHRYL3diUVJaNkoza2l6ejVSdGxOTVRFZVZwOWkx?=
 =?utf-8?B?MGtmRTJiMnRBcTJJRjVMa1dSb3M0dW8rb09vOUwrREtWQ0R5S2lsTlNOUCtS?=
 =?utf-8?B?N0M3MGpoT3ZicVJNUHQ1TVJGY2FVeXR4cFR3R0RWenJJbnJDVFJuOWw0WTFU?=
 =?utf-8?B?YVhDT0k5THlvemxlYTNldVFMaTJVdEllZVo1UEt4dFBUbXBDZGZHN1E5OEMr?=
 =?utf-8?B?ZysvWGN2cDZmYjZaODlDcTExVEVSTFdueXBjQ0VEY1kwSnNUVGxKWjRQOFpp?=
 =?utf-8?B?aUM5akRyODNyRDJmVG51SWVjcWE2MmFDY0VycE5STVZRRTVWQ2ZRdz09?=
X-Exchange-RoutingPolicyChecked: qfSTfHNKU9Omev2YD0UGA9azIrIlMO/+sbpv/KApHNpUoMQ6AebBBCoVXll+C9eN+eoalaKkrEzjleCNwlCSieJFFCbWVfql6GCpqyZW4HT8cv+w0BZIhkKZT5OrQbAHnV1VnJehxu8QANt5VQhUZaCjx+Th2BEje0b2a0mVEV0rUaOt7UWLgT59hB1O4SupZB3sDW9XkyTZk4bhesfAgl/WUOHf+T+bKbzQnEOg2kDFMIbVfUhQVl4UztIn+EIIGs6cdswFuaGYHjrolPEJTBUFAl2jkbVLu28XFPvsN2MpN168w5ZgYSQ0HSBkej7DuLOMcV7ePh+aXCvXWzt62w==
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ca0f69-001a-4696-583a-08deae9b696c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2026 13:52:44.6703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6ZH8qrADKtliTNAvdzcAgRi2W7JeyHJ7S/J7TxGws4BuS1mdJfcKo6v7v7NWvLqpMszmDDeOHux/5AhR4u0Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4547
X-OriginatorOrg: intel.com

Hi Tony,

On 5/9/2026 2:21 AM, Tony Luck wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> Sashiko noticed[1] a deadlock in the resctrl mount code.
> 
> rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
> superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
> the same thread before the call returns.  rdt_kill_sb() unconditionally
> attempts to acquire rdtgroup_mutex and deadlock occurs.
> 
> Move the call to kernfs_get_tree() outside of locks.
> 
> Add resctrl_unmount() helper to keep code consistent between the
> rdt_get_tree() failure path and a normal unmount.
> 
> If kernfs_get_tree() fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb()
> has already been called and no further cleanup is needed.
> 

[ ... ]

> +
>   static int rdt_get_tree(struct fs_context *fc)
>   {
>   	struct rdt_fs_context *ctx = rdt_fc2context(fc);
> @@ -3043,10 +3066,6 @@ static int rdt_get_tree(struct fs_context *fc)
>   	if (ret)
>   		goto out_mondata;
>   
> -	ret = kernfs_get_tree(fc);
> -	if (ret < 0)
> -		goto out_psl;
> -
>   	if (resctrl_arch_alloc_capable())
>   		resctrl_arch_enable_alloc();
>   	if (resctrl_arch_mon_capable())
> @@ -3062,10 +3081,19 @@ static int rdt_get_tree(struct fs_context *fc)
>   						   RESCTRL_PICK_ANY_CPU);
>   	}
>   
> -	goto out;
> +	rdt_last_cmd_clear();
> +	mutex_unlock(&rdtgroup_mutex);
> +	cpus_read_unlock();
> +
> +	ret = kernfs_get_tree(fc);
> +	/*
> +	 * resctrl can only be mounted once, new superblock only expected
> +	 * to be created once.
> +	 */

I gradually came to understand the purpose of new_sb_created,
and how it indicates whether the resctrl state should be released
or has already been released. Initially, I thought that if 
ctx->kfc.new_sb_created
is false, this could happen either due to a failure to create a 
superblock or
a reference to an existing superblock. In the latter case, the code tears
down all resctrl state via resctrl_unmount() while still returning success.
As a result, VFS might complete the mount with an invalid resctrl state.
I later realized this scenario cannot occur, as mounting resctrl twice is
impossible - kernfs_get_tree() will not return 0 in such cases.  It might
be worthwhile adding a comment here to clarify the rationale/scenario 
behind this
for future reference IMO : )

thanks,
Chenyu

> +	if (!ctx->kfc.new_sb_created)
> +		resctrl_unmount();
> +	return ret;
>   

