Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47E83ACA4C
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013375; cv=fail; b=SfpXBgMfTtauq7Co0N/EmX5KSdIJwflidOjJFdKTc9hrA2Z5KVegjBMNmAsDsXCPdOknXSiteOmYknyxmDZ7peM0+7CXQq4q6HhcvDYSktuH2b9/sJkrWfaHbcuPDJHhsBcYTEee2x9OWpJKBVkFcFFF84uxPfq2ML8s7eFsUd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013375; c=relaxed/simple;
	bh=Bd63E97WlHhdNKgPeVub0Sp4PV02pFesERA4x63o4XQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TSybVPo8h6XT5FODJQ2ueGh2m4TzVy+6BGTMjtoqlyx4O61Mv7Sx+OteuAfW8B2Ylkuwg/GP/JEOKSL+aHBaIhGYoF1MPHMrUFvpyMWLpgbDHNus6WmsYrd/3GrE50B7W+wNtohui/hnLWQL91Vb9xyYE0d4cmGSkY5XlDWv5YU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Aevki2Fx; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Aevki2Fx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013374; x=1820549374;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bd63E97WlHhdNKgPeVub0Sp4PV02pFesERA4x63o4XQ=;
  b=Aevki2FxQnN1fDqt9eXGifhsoHJOYD/5c6iOvmz2KZHjV7utuMO4BZbD
   +bOzBS/9AZt0cZBNWCmHra03Na9GQ3nRhbouhnASAJWEP0z5StoLpvftV
   GRai/ixXhIRU+gFx24ZipWxGpYUXhvuXyjE1iPOolXLEWd+AoMOu6vbxH
   I8CFauxDV4+UgINVAFmwtek/AQ7jvXqVzkWu62ewVEdSU3Z8nxGm0mHIL
   HOt+BnO0JOwH1rste1CINqgR6jcWbFUKQOdPA/IFmSpmr4NFjFhrLfKZi
   yaHHFiDR4IEMw+XtqxeXzWI/0JlpWtjh7FhmuIfSmq7I0yUxymOqhZEcN
   Q==;
X-CSE-ConnectionGUID: sqRlwnNiQI6hv/zJlJC5ZA==
X-CSE-MsgGUID: jKiDLL9vS6WZ0O+cA+agcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="91968903"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="91968903"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:09:33 -0700
X-CSE-ConnectionGUID: l85K81IeT5O99BG5dGGY2g==
X-CSE-MsgGUID: DCRFOdqLQTeCUoWXjawxnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="296473522"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:09:32 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:09:32 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:09:31 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.53) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:09:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NYzBnZBckNWXk3ONQrlDK4rSe1lyp2i1tD+jyQCimje3C4iuZHhqD+kmDhElVPQYdYxXP8EAmHXszhoDs1Q3HlOLSTl4RQaLjVDO7qBmzuTkWyClmAuSQSmhouuiIqY7T1KEfHB2J7PaWuxNwpBkmQgaJSMZ74oEca+fhXJGNPgkRW6KM0Rcsl4z8a8iz2S2iA/kQjFIye6Daw3pGItR2qfJRfWWg+QB4R7HOgC+1Ip7bOn71mUi5sBqkG6SsGolNWValZ8ygCfjG8c9zk6ob6AE0NxQ2h0TyTXtJlKBWnHm3MrJ+XBbroo4eJQsrrHwh6ybmTSrr8TlbW4W2mJSdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q70/q3kZeea1CsWA5mHJHp8pMybCF0YGoR9INptoRIo=;
 b=rZ51S1HLfTD8mQqztP+XZmRnBy5dJakaKN5EGH3/NFOYrC+QTwQM6wlf3zbu4YiOBPjeux4myZdw9RPuHuYo0mwL7gtN8t8aZrbDTcFsnJpYkpD29BmXdt7aLZBYolL0cQQhQ708groNsOzRD+t5BZVHU0pOYB25oGvZmWIdEHSpc0WXOcq0I8H39+mz1Xdy4x9mBlIjSoPZ5ssvAWSknkpWAjSXi/HWcv5REJrdVBpHfIS8r1iCG5W0es+mPdS/r/8n/KbB17t5t0SSqNtrPs4cYW0GvLraK+/DM/935RFOGRg0EwAOGMTbteasMgNiaMCsS0TTvB+iKEILeLSsnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSWPR11MB9583.namprd11.prod.outlook.com (2603:10b6:8:36e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 04:09:24 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:09:24 +0000
Message-ID: <3ec6828d-c1ec-4462-bf9a-7afb0431c2e0@intel.com>
Date: Wed, 9 Sep 2026 21:09:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 20/23] platform/x86/intel/pmt: Inform resctrl when
 MMIO maps are being removed
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0216.namprd03.prod.outlook.com
 (2603:10b6:303:b9::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSWPR11MB9583:EE_
X-MS-Office365-Filtering-Correlation-Id: 1737384c-cd5d-47a2-7bb3-08df0ef14cb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|4143699003|10067099003|22082099003|11063799006|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info: rMjlg+7CTwcpRo1URiUeqJ+OG5o+Ne0B8zzEhT5GDszsJ266PvALhknN3yXYoVVYIzFBKNB8Ut7HXUHPzn+LsvGxnUI8AaxufxYk7val1Bb1rqS+FXtVyovJOzWAChDB0D1/7vGumchCtTr8XWrwY1XWKXBecMCpq2gk34njdgaCWHQ3O6JKsfnUs1+1Oh12ZNG2s4ZR9fSrwqIPBMeXfAcZrNM4VZPBYPCFT8GB1lFSaO+tJ0A2xN95MGXknM0gQft3Gf3w8unuGesx8l9oYbRhGsfKfC2yVmuufs82GTtIxHfg/jHDsYZSSrvvYLVhqp5m5f+4pO4odaL6tiEWzlWRmk30+bDIAz4bzPr8aZyiCQgOlPBchyeceT3/xtGgeS/DetVx1Ild2eWBGKthgZjYoY/CG94t57b+fhjUY42k7wPv+4bAeB+a9YzsK9JgW45oXRA60V1ggv2v3lndLNKSVtKTUeb4cDrNBbGimFgBbEy0V1wVsyggXbhSX7cgJ7leziX2nGeT8Qif3SJkqUjhzKqjCxqnMOT6GHdA0fZfC+LmTVu2ZDf8gV8I+6RAenvpXctqDcfEUmdeT/+eKuMJIXkYtBn6sgC+Fsjz+h4Lm/uBYxSqS1vkaOAsPJ6j6790ifzSXAuPEp7UehBkXLMH0S9xfWDtE/P4acZNpu4utiWktzRpX+jQClIoNyUr0+VTevA3FQg+3jBgMgJNwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(4143699003)(10067099003)(22082099003)(11063799006)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUNFd3ZBbktqRVJPVVpxQ2RIUkdlNnV4a1hZak1NblVSenprWENWaFFYbS8y?=
 =?utf-8?B?UktHcmZ2UWU0R1gwanBBb01oWE9rZVExZFhKVkhyRVFyaXBrQlZIeEJBWStW?=
 =?utf-8?B?NkNDRmE3bmh1OHlKdEdsQkZ4cFEzK3FXc3ZzbENaUEpkZ2FFWW1Za0RsRWQz?=
 =?utf-8?B?d3NzSnpLTUpxNjN6cFlsdzM1N0pPY09tTWJsT0FCaEE0Vlh0M1Y2MGdYSTQy?=
 =?utf-8?B?bWlYNSt4Q0Nmb3ZwcG1Ea1RydDU2VHE5OTBsU3owMnNDTU5TdThwMTQ1RUFY?=
 =?utf-8?B?WEQrM3ZVbzAxTC9OTUpiZjlPb3hZWU5tWnkycit1L2JHK1RDZkJLdzF0SjBB?=
 =?utf-8?B?SEx1dmdnU2psaDZiUCs2eG5FZ3c0OHIwOWtvbGRmeUdOVWdvKzZ0UUJHaFVY?=
 =?utf-8?B?SFNDL2d6WlhJYXE1MzBSdk1XdjhtOG1wWjRPTEMwSkdSdldjSjVoeDNBUTlK?=
 =?utf-8?B?eHRuSkZTa1RiclJ1ZTB5QXNrZVlTbEszNnF0OU03R2xDMWlKakJUYjBlNEV0?=
 =?utf-8?B?SUZJa0w0d1JsWFo0ZXRjVmdTMXNJeVN4YmVIbjVOYWY3cHlCamxwd1dDc1RD?=
 =?utf-8?B?R29yS3RJN05SZnJhNVBPLzJSM1Z1Unl0c0Y0QWxUMWR5WWJtMkdySDIyOWVx?=
 =?utf-8?B?aURLQytDc3cxSGFQOUhzZUVpS1BpaGZVRDZVTVFHd3l5TTZMeFdYaXdqNGlt?=
 =?utf-8?B?U2kwNWhOVlVQT05pRWJmUkdwT25lUm1lOUpKUXpGdnN4NElGaG5hcWg3clhS?=
 =?utf-8?B?a0lmY2V1RFliN2FKbTQyeWNod1IydHVHb3B5eVRqLzk0TmUzNTJXUVdzUDhJ?=
 =?utf-8?B?T0Ric1RvSnVyWS9VWUhEVHhkb3BWUWV3WHBlL2FXY09uc0ttRHpGUlRRdndo?=
 =?utf-8?B?L0xxNlIvQlZJelR5NnI0NzNBODJTazVvek1tckVid3VYQlBwUExQRnF0Zi9C?=
 =?utf-8?B?akkrd1NkRFMxcjBQVnRsSVcyQ2RlK3pvZzk0WWFNSDdGWHBRblloOGVrbzZ1?=
 =?utf-8?B?dTJUOUI3dFBWVHYvbm4zQk9VUlZ0M2QyWno4aWx0dTNEOHBwc3d2Q3dqSUUz?=
 =?utf-8?B?Yld0Tm1nWStaUVRVYmhxdWhBNU45a1orcDVIZjhicVBIbjB0Ti96Y2Y0RGhi?=
 =?utf-8?B?UVpsUHBab3EzVjVjRityVVJvOWlNV2tISWtvMTNiaFJobkxCcEI1dnRIcURp?=
 =?utf-8?B?V0tlSUxRdnd3SFRReFNXMUI1Z3lRdEl6c1dITzE1azlQUldyNFpkemlJY2ND?=
 =?utf-8?B?cFdPMk95UHBRdHBCbDhSbzlVY2RSUURSd20vajhOaDdGT2E2L2p2Z09tcHlT?=
 =?utf-8?B?cDB1WGhtbkRGUExiYldDR044VGx4dWhSRVN3L2RCdFRpSTI4ZkI0bE11R0Zu?=
 =?utf-8?B?ZTRwNUl4VExYSk1QUFB5T0ZieElLZHJGcXI5UWluYW5nc1JNdWtwdDhsUXAw?=
 =?utf-8?B?WnRCN0lSSDJ2akdoOVhOQU9VWWdpNnJHUkpkNXF5NUs0QXY4Z2swdDBzWHJz?=
 =?utf-8?B?TzZ3UTFhT2djK1FXR29HUk9GWjZUTTNPNGw0SXhXZzl4TXkxcys5bTNFZGtQ?=
 =?utf-8?B?blRzWFJMbmZYZEtHazhhTURLTytuZzdHaDdWWXdFZTRzSC9Iazhac2NrQ2ZQ?=
 =?utf-8?B?OGhBMm1UWTc4bmJGdXAwcmg3UExGUFNyWlB3R2lTVitaaDBiejBDdUFZckVh?=
 =?utf-8?B?eXcxNGErdm5abjhqalZkL0dlQ1N5RFlSZ0ljR0pSMWNOeTQvTE1KbENPOUVl?=
 =?utf-8?B?M2dsZS9VRXVoZWtpdXdrbC9RMjNBekdaTlNUTXJ0a2UrbktkNEFDZ1RsNkRW?=
 =?utf-8?B?NmQvSkZ2RkN6WjdhQXduK1NzOHlhTStGSGlrWFgxTTloTHhORjFKc2RWWVIy?=
 =?utf-8?B?WkRlbW95d0lXaG8rd1hDNkxtNVBHSXlONHpsQkE3cGQyb3h6OURKVEdqdHhm?=
 =?utf-8?B?ZVM4TStoU0NvYjhxRUp3b0NPNVV4ZTFyS05FVlpuUEUyTHRBaHZLK1dPQjAw?=
 =?utf-8?B?bjlTVXFGZzJia2xWMDZzZktudFhUTjJJcS9jckE3emxSYUhjb2JPTGtKMnFQ?=
 =?utf-8?B?ZlJ1ZHFtS2ZSbHFrampzeUE3Ukg4SW5ndWJHd21kNzA5VTFaYlVVemhBY3NQ?=
 =?utf-8?B?VVp4S2t2TENsMFZSNEg4VnZmK3N3TnduL1VRcThybTI0SkE4TTNjdWJQckV6?=
 =?utf-8?B?QUVYUjIyS2tuRnhJZnMwbTRLQjZpK2o2K1ZUUGF5L09JdklxZVpSZUdmbWZD?=
 =?utf-8?B?ZGl3bmNPUmM5eXlXYTBpN25Damc2bHZ0b0VwZGlDUU1aM2o5dXBJYjNWSytL?=
 =?utf-8?B?eHg4QmJvTmFnZWxQd3l4U2lRK1NYeURTWUdBazc5Ky9QYnEvVmZPMHlqdUJm?=
 =?utf-8?Q?eLYQLM7+lZcIGPms=3D?=
X-Exchange-RoutingPolicyChecked: tcKUoMze6CeZqZreNqTvNBffuwCOE8zdxCvhEBsvgaYJxJRzsjDACRlVmyFGRTmLt+yVta3agdpxsxWQ/w3zvGLSyaT94GCDoEvmSjvLDohxIWl2Qh8kfPybNrFaCha0ygqodvl6ty2CBS3OnHH9zgyDGok7PUyWzqaI7VGN4ILaCXmM50fq9H8h1RckyfZQsBiCAk4DhaHYzALUPsR2axXpW8DA9HW9QSYH3gL/GW35wP/2B+5LeldnyqZuemAI3SsvK0HjwThEigEEA/atvbbIhvMLWfQMLMaPrSUMP5leoRRk6otbb/wvHPVCFwDU6d1wSdw/HUqT5A9eUkHvuQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1737384c-cd5d-47a2-7bb3-08df0ef14cb4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:09:24.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVro02kSK4C9y4GBMhwV2PosOhKzQqpKBnsAVE/u1M0gMVUDeql8rv8OMFO+84YQcE1dfu+IGFw+Aep1aOhw4tBOfZvNBS6b8TrH5+G18k0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9583
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> Before destroying devices, tell resctrl that the virtual addresses
> supplied by an earlier call to intel_pmt_get_regions_by_feature()
> are about to be invalidated and should not be used again.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v11:
> 	Unbind/remove operations can't cross package boundaries.
> 	Psss package_id instead of bitmap of package IDs.
> 	Use dev_warn() to report failure to find package_id.
> 
>  drivers/platform/x86/intel/pmt/telemetry.c | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
> index 2d2282c636b2..92871ce51c57 100644
> --- a/drivers/platform/x86/intel/pmt/telemetry.c
> +++ b/drivers/platform/x86/intel/pmt/telemetry.c
> @@ -366,11 +366,43 @@ pmt_telem_find_and_register_endpoint(struct device *dev, u32 guid, u16 pos)
>  }
>  EXPORT_SYMBOL_NS_GPL(pmt_telem_find_and_register_endpoint, "INTEL_PMT_TELEMETRY");
>  
> +static int pmt_telem_get_package_id(struct pmt_telem_priv *priv)
> +{
> +	u32 ret = -1;

Should this be int? 

> +	int i;
> +
> +	mutex_lock(&ep_lock);
> +	for (i = 0; i < priv->num_entries; i++) {
> +		struct intel_pmt_entry *entry = &priv->entry[i];
> +		struct pci_dev *pdev = to_pci_dev(entry->ep->dev);
> +		struct oobmsm_plat_info *plat_info;
> +
> +		plat_info = intel_vsec_get_mapping(pdev);
> +		if (!IS_ERR(plat_info)) {
> +			ret = plat_info->package_id;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&ep_lock);
> +
> +	return ret;
> +}
> +
>  static void pmt_telem_remove(struct auxiliary_device *auxdev)
>  {
>  	struct pmt_telem_priv *priv = auxiliary_get_drvdata(auxdev);
> +	int package_id = pmt_telem_get_package_id(priv);
>  	int i;
>  
> +	/*
> +	 * Tell resctrl/AET that virtual mappings for MMIO space in a CPU
> +	 * packages are about to be torn down.

"a CPU packages" -> "a CPU package"

I think a comment here about the lock dependencies will help folks trying to work
with this code understand why ep_lock needs to be dropped and re-acquired.

> +	 */
> +	if (package_id != -1)
> +		intel_aet_invalidate(package_id);
> +	else
> +		dev_warn(&auxdev->dev, "Unable to determine package ID for removed device\n");
> +
>  	mutex_lock(&ep_lock);
>  	for (i = 0; i < priv->num_entries; i++) {
>  		struct intel_pmt_entry *entry = &priv->entry[i];

Reinette
