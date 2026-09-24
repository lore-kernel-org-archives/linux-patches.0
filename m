Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A2447DFA9
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790262944; cv=fail; b=FCS7vNlFgSpgxgK1i5mhOB+CN+4DETU2DU1a7f6nL7JBc9d2hN56fy4pNJTtkYBQXyp3nwh8czb1rTT7AWd5SoS8WCpcPTgiMXa80Uw3VaICakPw5qEdA1mNUmfmKvqfE4mfEWY3yaZSEkq2H1ahOIHx3ln9iWyWaD8zS33HeX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790262944; c=relaxed/simple;
	bh=n1HabAUb55U5fvXrb7A5R1IAOIcYapCcRsvTumAbk3g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CRoD4Ns6G0xM7cyKtdupNzRxFnNo9Fy1fSp+9iazIk1ryog3HmDlk/Nj4wXS2Mx8OUMTdCh8es7I0vTYg1xgD/Ev6uIj/7T18fLq0E8hFLWjsieovapj+GZlhYdBLiXZIeKvyqSA0ZOZ18KRddXZSRFP4nJI4Ghk1Vn37y6UcyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wux0ZCA5; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wux0ZCA5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790262943; x=1821798943;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n1HabAUb55U5fvXrb7A5R1IAOIcYapCcRsvTumAbk3g=;
  b=Wux0ZCA5DYykbDrQUcvFrlXuJswZw/CIT0oHJPAmK0nJN6l7tz8gi9za
   uB0o60urYNWNh8KsPWElTRK9RhUf9+QXLdeGEgDQivGPM6cdWdcYDLPXD
   jSvtwcEQzcIXRCpTdn8KnW8s2Bp5cxcCstPK9LtzqUsjj8LMwx1SMtm4b
   TQQdsx+RDa8szzB+7S/sGz+afVMZkcqFwhvyseNyh3tMcSPBlCEMhiUc6
   02aBh5ayuwbhptkAc3iHXMadoQ1NoIAq/pTcU/6cVFux/FCLBk1kX87Xz
   iY81UEO1n7S/qI14MvL9Czx2oh2cuHxqBqLDpRkf55jQUh5BKDG2Gs/uz
   Q==;
X-CSE-ConnectionGUID: fxKVawYMRgaC3U/3EPybBg==
X-CSE-MsgGUID: vRSmbpgCRDWmrbxP3AkdkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="89898919"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="89898919"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:15:43 -0700
X-CSE-ConnectionGUID: 4rKud0paSGCHx93WR3KCUw==
X-CSE-MsgGUID: dhUk5TPiQx24prJxEfCCdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="273171492"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:15:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:15:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:15:42 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.38) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:15:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QpK7QHIZV3GtSt/ltSBeNfujZF5m2ZoY6DdUgieoRJ+C5bL+ybUvcNqp3eC7kQjnEZWtPck2b59+Y0xvXLSnLdI9OtryKw7BVoi1kTaVtVd3EYFMpJeAE1QnbBnKAfRqojh86PrTyt9M2j7CJdTltc5CqzyfF9pq5vBceg3/g/G2RaSZCL4PAHvAFUX07OR7vjp/SKoCB6lztSxEnAAzOdmram7kdTSgTOwbMoSMYd1zpu7hnBJo3CIM7u82Nv4rxQDNJI7Fkz0W4DVKQ09yMkOvjtsZhN+YhT9LlXavPAukMtG30t6UaghcVM9Fvsf1n6BE/gJCKuuJ0QiYogAmSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=walJM89ymXmLUnlrTHseSyjV+Ol6sw4XyhcmPMfoNSU=;
 b=jloMLYGpnO7Iic4unnIl+cbQDZUenJVkQayvkUahtzNljt6m9A09YSuYYy4UJ4wqxBzAGp8wqdE1qfw7c7R2nZ5ZAcxAu2Eho4IoV49C+luYwfn51DOCFdDE9tjTwTeQLa17JyyJe8w788B0G8ZBvLdEtfKItPHiBNBxheCU/oK8oJX24PVV9Inbt2G21R20taxsKUURiQlp31Z+MhI2PN943ev8suITv4bBF00Z2xsZ/iIPEqhMRCBI860ewq5ZvB9hK0GGXzVsnDVVMqQHqHHm5MR4/TTs9zsvYrZ3CJ1lDtz8vbc71mefVr4kjZb0ua51rKEBaArRDRy01tkraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS4PR11MB383999.namprd11.prod.outlook.com (2603:10b6:8:509::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:15:40 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:15:39 +0000
Message-ID: <91df5867-d90f-4bb0-a326-3ab80af0c0b4@intel.com>
Date: Thu, 24 Sep 2026 08:15:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 03/25] x86/resctrl: Enumerate monitor features in
 rdt_get_l3_mon_config()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-4-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0232.namprd04.prod.outlook.com
 (2603:10b6:303:87::27) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS4PR11MB383999:EE_
X-MS-Office365-Filtering-Correlation-Id: b395cda5-a8b5-4701-490f-08df1a4eb174
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10067099003|22082099003|18002099003|3023799007|921020|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info: T6sO3jTs8uS6xmaGrUtozp4LhYXm/KlZxyY8yE95F4QX6KGnJF+Jz82n2EWtzwpa3FAKGe2z27Y8npxGiUH8xHwMfmYKcctP5CTsQKPGJ6ya1/eA3OfTE+njsNOn5LwMziy6RguOBxkw9h2Lgg0neifCzTBMpR45OrZXtSrdSPTpBezd4FQWz1dsZSG7VjWAbl5R9U7XREz6lTYiFfy8OmaLErF9DiV+pv8dA6ynED/Pi/pWbAdIpdDYJCaTpL4TIX7Wrw2Sxy74drv5VvFbuZGkItopddhzD5ymJX5KrNp7uUxZf/LqsNb8oX/9N4olfEJkoHkGNG2Y4pcZjQLgWh8g1RBoT0eYVA2BJxU3/aDjLOIEY5SYl1+74yycyuapt8F5E7E8hXP2vl2cj/e2SMeDPm/WatVbanEhgN/I5zd7ucroSBAPGY38Xp44xOLy2+Wmwv9Kmfdi+IPrS17IN5IEPX94T7J3tRKmc3Qc54J89joKgk7/7cZuqTCC0ZMm2wb0aleNPUB9Om7gAprQyiHZ61iIrZPMaaYjPDN968+RT0wCtimt+KGDQZSYwMZeCPwhDVA93nd7Hg2+pljPc4dkWH+VszUTSi7OWOh36RVrrHYx9T7Q3hnNL4pjnN+aX+q7+USVY6MNqT0tRDgsnno+zmfxM2lA4js3Ggb9nb80yE0GwgE+B0QQMu3o5SBLDzU4cjF0H1dE+TiMTB9uDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10067099003)(22082099003)(18002099003)(3023799007)(921020)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmRnSGhVbjFsU1FmNzUvOUxiaWhzWW1oU1JUQTVtM3pjRzNxdm4zVWtyNktT?=
 =?utf-8?B?V1NJV2NPWm1UVUxISmFmVnNnQnpnZUVWTzhob3RTbmdQTVAwcWd1dHB0ZDJp?=
 =?utf-8?B?MEZDMzNlVDVzbDNURDZ1R2EzZWF1UkVpTW1tU3o4WFdCb3JqKzQzZFo3SU8x?=
 =?utf-8?B?VUNlaE9aQkxVcmdRYXE0UDhuTlpCSjFpTi9LSzlyZjJNYnI5b2lqOGFlNDcx?=
 =?utf-8?B?SUxFTHJPeFd4clRzZ2pXRyt0aWpKcklwNVNSeWhzSnNja3Z5Z095REE4a3lV?=
 =?utf-8?B?WGZlZHRlMzExeDBEalUra0ZZbWdiZEZ2cXU0K1JHdktKWkFzOFVTaUI1TUlH?=
 =?utf-8?B?RjlvcE5ZTDNocmtEWnB2aFhBNGk5KzBEcHlSYjZqdHNZN2VLdG5XcllWOXJn?=
 =?utf-8?B?L3dSV1NHSWVSblZ6TWFuNS9UZWNkNmZQYjlZUFpTVkpsdThZZ3NCN0wrNklr?=
 =?utf-8?B?b2NJU3UxQ1EvKzdUZkdrSDNxOE5GMjVxN05zcCs1cWhCNERZSGRMWS9vWjVE?=
 =?utf-8?B?M2llRDNOeW5iYUhJVUg3V2gvd3JVTXBVNmZUODU2d0tPKzlyMmorM0RONnBN?=
 =?utf-8?B?UGxTTmgzMHg0ajFHbUZobjJKcXcyM1htVDJOYmNPVnRuQVE2ZG9oV1Mzb2hq?=
 =?utf-8?B?eVRZdHRYUEtsLzZSbzRxSGd6dnZXZ2UzVUFlbFVvODlyZHNrM1JoY1NJQm1x?=
 =?utf-8?B?M3VEKzYzNzhtbXUxMzlWWWpCdXkwSUV2UFBIYngxWFdyZGFpWUJIVlZYRXB6?=
 =?utf-8?B?dm5XZGEvT3BDTGlTUHpRM01RVTFabTRQSVVhR2kyRGp0MUtnMmhwVDdURnJ1?=
 =?utf-8?B?cG4xamhHUWZmUHp0UFQ2UXNYZ041Lzh1QmM0VTJSWCtTWng5WHR4WUlUZlpQ?=
 =?utf-8?B?dWNWMnFqS0ZhU1FCS2ZtYWMzd2R4Wkw2WjdodlRzNWs3NWFrQWw3c1ZNNEJv?=
 =?utf-8?B?TVlhSnNaeURQbnlYNDhBNlMxWWJOSXc0eVRXVzJybklzUWsrajI0TDFVaUxT?=
 =?utf-8?B?ckRtRmhDOVU2K1l4MGFlOWJDZUtlbldJU0VBZ0lMTnlQYkJuN1AySDhDR212?=
 =?utf-8?B?MGl3Y1pYZjZ1WWdKWjZXWmlrZWw5dTcySHBEbEVXRk5mTnU5ZGpxcjVLM3k4?=
 =?utf-8?B?aHBteGgrUGt2QVh2cXExckdWNnJuVitnNGsxNC9ZZ0JoTElWVFlRZk5aNGk0?=
 =?utf-8?B?TDd0ZzFIMEJnRnBIU0liM0wzdnpyTytGRFJseFRvdWdoRlZzbktWWUl4WHJs?=
 =?utf-8?B?WXJHbEFFK3Rna3A1T2NDRlJqdndSVVFkdnVNazNjVzZ2bGpDbytJVDkzZHBv?=
 =?utf-8?B?V09PeHBNUC82eEhGZ0lJNzJQWkw0WVdJOFdZVEl1SnA3dUxXTmxHaTMvam1y?=
 =?utf-8?B?dU9Fc0wxcFZjNW55bzFSaXZGT1N4TE1mOFNwa3RVaGhqTXF2SGhITDd2L28z?=
 =?utf-8?B?QTI2SUU3Wk9QNlpjWGF2MzdhY2JFaHUzUWlYMmE3SDBpY2ZnUHdBWnIxOVBP?=
 =?utf-8?B?aU5tb1lMaTNmUGQ3aElhaTNWZytUVHBQS1ZCUVAvYnVyQ1Ivd2o3MWxNWWF3?=
 =?utf-8?B?QmhTWHNqZ3V0V1lxQjVrRWhaV05HbmlDcGRFSjJRVWNNcklZVGtnOE11ZDdQ?=
 =?utf-8?B?U0N5azZaMGI1dmw3bU1nNVZrRC9sdC9GTEVhTnFuUmIxN3l6Z3FuR3lielVM?=
 =?utf-8?B?K1ZuNVU0dXNMVEFnemhCdGF0LzMrQm1wYWZjVFZPMlM4N3lWSXRIUG4xVnVG?=
 =?utf-8?B?dDhZUi9wbmxHTmpPSGtTeFZPckpwMi8wK3B6S3ptRC9Fa3FGKzBnRWxvK0kw?=
 =?utf-8?B?cWJDaUJuMkl6TWlsZHhDWEhTM1hmaTB3ZVY4VGRlVkx5U2gxaC9pQThlOFhi?=
 =?utf-8?B?SEFKUkVTZ0xRdVlkVUQrRHg1akgvdU9LK3lzR20xU2x4bndnWTdmYisxcWN4?=
 =?utf-8?B?UERPMGpLQldYcmFYckpNVTBTSzFPMVhhcndQOXNlTnhBMEU2cWZWaUcwQUVC?=
 =?utf-8?B?Z215cDR2Z2hoWUtUbVk4TkhuRkZuajR4WHBPWHY1WENzSTdOeWVlZ1RaV2k2?=
 =?utf-8?B?MGg5OG03aTR1UjJuL2hDMkR3ZFUxdzk0TlRkMTRMTDRVOW1jdnR6YjEwUHBi?=
 =?utf-8?B?aVAxTXRtOE5ucWkxUS93dFV4ZklGZStWUm9keU1jOFErT3hZcVdpTm9VdEFn?=
 =?utf-8?B?Q0h1enpyYlk3UlJFUHpHR29qeDhaMHMyMXphQ0hNYjBIazNSaUZ4UUlWeHlh?=
 =?utf-8?B?M2pvYy91ZHFnSGphaVZsMEp0T1MwQjcrM2RXblhVS1k0UWNBVWVOY3ZHR0dX?=
 =?utf-8?B?QUdkaFk1RUNYTFlCRFB4VVpiSUFidEpSUURGelRGaXNCcUFNQVZZNkNFa2k4?=
 =?utf-8?Q?CkVc7Z1m/ogc6oDY=3D?=
X-Exchange-RoutingPolicyChecked: hS8E6gphR58upx3USndY1vBGMeI21PriQJz52+1LZIlocOBE/o+qH1VMiQH9PeqQqyvdIuZ3nGkuN8kwGoXkoKWz4lIPcuSgPfy+hDgXDwWCagdJaMuH9MySIfJ6ngpKIsEUabFxH/64VZ+fXYZoBV2Vns+rQ2gNhF3RTBZTxwQzNQw75JCA7Se2/3W/ffs/XhpRE4iv+RiUm8hu8s//eRS93c1rWavGk401uf4L58dPysYBs13XUMWIEJWhp7l6x3r9KR9aZI6FUrV2DX5m15OfHWic1bLgBGUBQklZNATWcSbF2EcAgCWsXXibQwza7+HrFxVTTCLpEtCQu4konA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b395cda5-a8b5-4701-490f-08df1a4eb174
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:15:39.8414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MeqHOxZaM4c4PTcrwv6ZUPnKoms2K+ZKTiqWk2EyLhd2xQL8vgoQh7sbBnHab5FRmeXkIIWuMgVV5UfS1fhKd85mVmX/uk3yiUuL69GXMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR11MB383999
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:12 PM, Tony Luck wrote:
> The original implementation of Intel Cache QoS Monitoring (CQM) planned
> to integrate with the "perf" and "cgroup" subsystems. With that plan it
> made sense for parameters from CPUID to be stored in fields of the
> cpuinfo_x86 structure. But that plan was abandoned and the resctrl file
> system user interface replaced it.
> 
> Change rdt_get_l3_mon_config() to make an explicit cpuid_count() call to

Above is obvious from the patch self. The changelogs of this series often
contain verbatim descriptions of code. Please replace these with descriptions
of _why_ the change is made.

Boris should not need to remind us again of his archeology test 
	https://lore.kernel.org/lkml/20250911165433.GBaML-yTUZHkywuJIe@fat_crate.local/

> enumerate L3 monitoring features in preparation for the removal of
> resctrl fields from cpuinfo_x86.

Considering above comment, could last paragraph be something like:
	Centralize all L3 monitoring enumeration within resctrl in
	preparation for removal of resctrl fields from struct cpuinfo_x86.

Using function names in the subject and changelog may expect folks to be familiar
with the code and in this case it is confusing since folks that are familiar
know that rdt_get_l3_mon_config() already enumerates monitoring features.

Could subject be something like:
	x86/resctrl: Centralize monitoring feature enumeration

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
The patch looks good.

Reinette
