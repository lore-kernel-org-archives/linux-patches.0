Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C241757F6
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917994; cv=fail; b=obKO2SFQrk7WWq9fnp0RF+gosAYZk6Gr7HDdqHd3Sc7zHiiqaYAN3IxdL0pY2bPJEJ6ZcAwWbyPXlFukUW+ZH4c/bgd4JFr5mehXE6Zm+TRTsIneDMHGx3Xg8qnCCAdJqZmikNK3JFZNy5AAAwjgKbl8FE4+A0UZlGKESlvMnjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917994; c=relaxed/simple;
	bh=4RnukGiOk6sEte02sTL0nEP/FoM8BUXnjNYtLBC0DRk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aSBydbEZ9QYyqzODuB5SfIjXJnqdJd9gTBzuuYP4xvQ3OqcQxdboFtYZyFlguIm8Gp+SxGTg2kC1+ukuggMfPEIfbFeveMKm7kSpIHFB+jFF3cJBSPMh84LjCqMP6Fem2/fgndHF9iw2b8T3jfBbbAn6ikqdGn0m3HA8CvyeaSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMaae/BZ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMaae/BZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718917991; x=1750453991;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4RnukGiOk6sEte02sTL0nEP/FoM8BUXnjNYtLBC0DRk=;
  b=gMaae/BZ/3DDoAHuNT0YZjPjw6ppkOkFU6gocEgyz2jn1B3x2aLSXFRa
   Ika5pG8Zsk7UruM9F2ypVeEqqhSSQIQhngONFci5Kaw7JueMpdgoDwKBW
   liQKY3IeppC1CN6jR19WUKWrDxsPFcAtYiIJcE4c4ui8vze1svkSQlBYc
   9qeSm2Bi5+aL+pMT0KfuByfTwcyEQvg5VaiL6E6LB/w6dUx8q62vNQwfG
   w5VSOpjIdZMKxXlgNdyqtppO3DzflWZP83MoZPey2mngoqQfMmwr+ypMc
   3bln4ZkcDuLmfF1BJZqVzsXw8oR7FVM13XesmFhIWTtFg+paxddp31bdR
   A==;
X-CSE-ConnectionGUID: f71MCOUlToGvqNaTcGOnQA==
X-CSE-MsgGUID: QQkgX7NjQcufJMCNAxY8vA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="33473903"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="33473903"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:13:10 -0700
X-CSE-ConnectionGUID: adCeT6g6SnKPx1vu0757Vg==
X-CSE-MsgGUID: wr9KiNpQTN6LVXk747mZAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="46719027"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:13:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:13:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:13:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:13:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:13:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WE3HapJKJZh+OE6OgnIRi0lY/QoecZK3F9i4vLAk+wy70aH0U3MKaS2cBMbvrSNPaRYrJSJsikjw0x4+7z5BcgqtlMg2O7/pnE5E3uDAcTqhTXcngsEXmaYBMmoYiGUaeSKbVi8Qqc81gY1acfF7Jv8xQe9laapQA1WzvO9D7fclHVbsSP0e5c6bC/f+Fpyolc/Sx4C7GEvoKhV+5F6JnyXDpGChZFbP1dW9++iSOV9mPcmFYgVFUJvR4JlvKOSStpBi9MjvsAxP2AsRo9eevPs2XPQr4MtqtwXp8HNRIkmkpgI8fueOG8ceWy5FW/YaYk2lTVE80ykT6DgN8Sf9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KdHGYyCfoinDCd2QoHy3mEuAuxNfF2mENWlWAPKUVNE=;
 b=SKfe3pFrQqkn8mAAS54pRLGYdOMuJhK1jUyeJjO57/0MFn6Ca1Q5PF8nxmqsl+8oVrWU20kDRDTtkSQCoZqppmgfWEvbcnjYojTdTFrKpHSlnXm44plNtZ255StTsHp7auIgJArYrZy6kwECBILz44TsLbL2BSuSv7ejil9/MZU+M9yKrPxBm2O64+nd50EfjGY2NRPy1DaUohrrn36qEHly0A2036H4UUScwEUqWL6wNLu94zPp+b0hrm+uwt+nS8zlBgFdc14hZjBIiIQtBerV9k37fT8oTSlj9PLvHWg6+6Bnipkb878ONCq84SNf1JxQ9HnBFjyGRoMs799tiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6930.namprd11.prod.outlook.com (2603:10b6:510:205::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Thu, 20 Jun
 2024 21:13:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:13:01 +0000
Message-ID: <f82f26ef-39b8-44b8-b866-aaeb0f520e1e@intel.com>
Date: Thu, 20 Jun 2024 14:12:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 01/18] x86/resctrl: Prepare for new domain scope
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:303:8c::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6930:EE_
X-MS-Office365-Filtering-Correlation-Id: aaadccd2-13c4-4462-feb4-08dc916dc481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d1lNUG5LWE12Uk1mS29JSWZzNUV6anBnYytmaTRUVXZIVUZxczJ2TGorbUNP?=
 =?utf-8?B?N29laGI3MDh5N3dmUE5DeVlFT0NMYTlhQkpWNVBTUFpZVkMrYkZvUnFKRHpR?=
 =?utf-8?B?VWxkTFpaOWd6SDZ2WFhFUStXeU1lZUpUSHdHMWtlOG1md3RmOVJiYi9YWDVa?=
 =?utf-8?B?Y29tMEd2d0t4MHlxVW1zakxZT2ZvWWhmR2t0cWxqRFAzRTBNTFZ5NUh6QnMz?=
 =?utf-8?B?dndpSmFQd2JwZDc1cG9kbGNhM1UzV0FqbVcyY05FMVJEbTBVUFRaRVVYS0xo?=
 =?utf-8?B?ODQ0S2xYYkVkQk5pRGM5MGhqV2VBT2x3U1EyTXRraG1adUpRNE5WYUVTMDhj?=
 =?utf-8?B?MUFNVzNrS3lnS2RqODBXYnNQWUZZbkZ3U0FWZ3JlREVraXNwNHplM29zOEFS?=
 =?utf-8?B?S3E5cXk3cWNBL2lCaGlDUStwVGlhS1RKcGUyOFpJSklVajI5ekNGSUYwcEtr?=
 =?utf-8?B?YXNzd2lucXRSTzQ0SzJIWXNiRXRjRUgxODFmRUFrWE4zak8zQ2gva1I0WXph?=
 =?utf-8?B?NlNFL0JzM3UzZDZyTGszUk5QbnRGWk1sdDUzUEd2ck9wZW5GU3ZtRE85S21I?=
 =?utf-8?B?VnhIOUdMOTNYMWxaV2xwVXN2NkNoQy91WHo5OXR6WnhMbVhmVU04UENscGVY?=
 =?utf-8?B?NG5hM00vQjlPR0g1Mi9UVHBhSldiUnZjQ0d3T1RsUHdWSi9NNnhTaUJ1VXdD?=
 =?utf-8?B?VHRJbTJJTHh3RmxMSlIrMHlDWkVya3hiY090SGR2K0tvd2FoWU5pSUt3ZVhD?=
 =?utf-8?B?TGtVS2h5QStKRlk3SXphR2R3NU9iOUt0Qm1zNWppLzhGVnBoeDBFWGtjR2RI?=
 =?utf-8?B?NjQ4aXVYZHhFNjIxcWJrNnF4bTZLSGVSdWd5WDZGS3lWdUhZT2NLbWdzOUxl?=
 =?utf-8?B?bVBHc1hteGhqeFN2bDJkVW40TWhDNXBiaEErUFVrbXdsRkVFZ0ZaNmFVQ0JL?=
 =?utf-8?B?enJRMkVPdTJDOXpVcUdLYTBGU281aFlsQ0JBcEQrNUV5STl5VzRvNGxxanpo?=
 =?utf-8?B?Q3ZXWmNuenJxWmlKQWlNWHU2MVlRdW5ycC8xK0o5MUZhc2dNTExLaWQxaFRl?=
 =?utf-8?B?TUxzUEZiK1Z6Y1FnaHJFSnhZNWhiajNpazZuSFVtWHlhQ2NRYUkzdDN6RXZ3?=
 =?utf-8?B?aTI3Q3RjeUNRMFVHSWNwaGcyMFRCdkw3UnplRDhKNks0Ym9ZQVc0NHZKRVQ0?=
 =?utf-8?B?dkZ2b0RrbVdwRy9uamRRZHE5UUhsR0VySG4zV2taclp5MmRBRDA3Z2FvNmpX?=
 =?utf-8?B?MVFNT2ZqL3BIMDREK3NMRXFiZTI3UExycXpJbDYyaCswWTV2Mm12Q0JjdThm?=
 =?utf-8?B?NEMzVXc2a2JhZmp5MThYQjRxdUNJQWNERWRXZDJnRjFzS21QTlhmdkZNL0Vr?=
 =?utf-8?B?VXE1MGRiZEJKeHVxUWxCcTNlS20rV2I3Q2xmb0kxeW5kK2lFQkwwa09Wa09y?=
 =?utf-8?B?b1dJZTNHUFpJeHFEVHVjTGllZVQzVFU1OTlrbEJ0SlFFdVZzRXpZZ2Ntd2R6?=
 =?utf-8?B?SE1zVnhWNEZlQ05Ha0grK3h5eTVYeHMrTGV3T3pibFJ5dGk2WVd0cXB0cGla?=
 =?utf-8?B?R0hEWDhzUTduL0ZxdFhJeFZteEZ0bG1OWW1qczNDTk9LR1ZhbjJzWXkvUUxH?=
 =?utf-8?B?UXpKajFGRHpibGk5REs1VlN6M3hPYVkzSzdFaXE3K3pFQ1VlVjFlQnNTeS9O?=
 =?utf-8?B?YjBTQVliVXFIb2QvdzlIVzhhb1Y3OVB3SHpxS0FKaGlCTVRMdU5waGVuVGV2?=
 =?utf-8?Q?91ZvpLpr0QPY1+PXy74Op1YklHW8WOW6VSzQMXn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2JQSm5CL2l3Q2JDa25Lb21ISGZKcytHa2tOd2dmZGVWcGtXVUNVTWRIY3RK?=
 =?utf-8?B?R0MrR1A1bWg0TWVVcUFCWElxYkQ2bXg2ckZmTTBNWWxoYTFkaWFXajA1QnR5?=
 =?utf-8?B?ZmwzdENqSGNZOHp6OWJTSjZWbjczTXJ4ZmlsWUpUcUluemNPUWxKeURTQ0Jn?=
 =?utf-8?B?d2VSMGM0eHlmQTd4bFRqNGEveEtESDc4cXIzSjFUQnN0SnFjRU1lZFBrcFA5?=
 =?utf-8?B?QVFkejVHcEpJTGZYOGlCRDJZbk4zS21RdG1rM0hkbSsrdzAvbzhXZGZYYmhS?=
 =?utf-8?B?VDRUUm5CSFhucmpBRHhqRjdrS1ZpYWYrRzh1YzN2c1dxazA1dFhSOVIyb3VK?=
 =?utf-8?B?SWg4VDNQa05WeHVuclIvQlBCc25mbkg5Lzl4TmVaWVhwQTJScUZ1NmU1ZFI0?=
 =?utf-8?B?Y1lHN1RmR3ExTVduazdyVW1tYUVqSXhJeW4vMENhTnVLV1ZJVndscTJjUE12?=
 =?utf-8?B?RkhwMzRNaG5VUXZxVUkwY1hFRFNsaFZNeVI5QVVSRjk2bm5UWDVEUUlxL2h2?=
 =?utf-8?B?d0RVSjI0RXZxMHRYSmJVeTdpNlBGMGdGSENFdGxGTUtMQm1yYXNvQ1F3aytQ?=
 =?utf-8?B?NUpxOU14cjZHb1gxcnZ0YVFTZEtycHA5SjlnSFFTMnRFMVlsRWdNY01GVXdu?=
 =?utf-8?B?enVyMzhkcjZUTDZieUVoSjg4NFI0NlVNeTVadWlRWkxGTzJOYmQ4NElXSk1X?=
 =?utf-8?B?OGRpeVBCUkZlNkhTKzFHZ1l6T29PZC96akkxNnlVZE1QdnVzdyt0dHZkQ0xR?=
 =?utf-8?B?Wi9GSVM0NmE0Zzlhc2ZWMzhhWVVmV0hhYThnRFNpdlVVZTdPNnp3WGl0TmRq?=
 =?utf-8?B?UjNpSkY5d1dyODE4ZmMzVzNjTisvUWJXNm9ENFovT1VHMW5OK1V1QVdhUDFv?=
 =?utf-8?B?M2VDUCtmaFM1QXRjM3J5OTlkVnJZdUcyRG12ZlFMUVBIcHlqcTlTTnVmei9N?=
 =?utf-8?B?SW5Mb2RPUkF4eUtvQ3pBTVhwa09UODAyQmM3VHh5L3RxcWNDSVBpN0VZVkNj?=
 =?utf-8?B?VHlMcnA0MGt4YnIvSmFabzBwMTd5V01zdG1NWXRQeVNlSXBmQ0ZFWjZLSlFr?=
 =?utf-8?B?V2srV3FaNXdxOHJwTFUvWWoxL0RDNmVqNTFEcnNUaDRmQ015MXJxMFoyS2kw?=
 =?utf-8?B?QmpJaUVyWWRLVkVFR3NSbG9BcWdkTis1QXBNL04xbGx5OFc5WWhtcmRJTi82?=
 =?utf-8?B?VnVKdkpFS0tqcGhMQnpkaTRtcWhhOWhoeGs2ak42aHJacTBaWldNRFN5c1I4?=
 =?utf-8?B?Q0tsdTZvNTBqMGs1WTgwRHhZUmVLck4vZndYeUJiaFFpaDlOWEdPd0E3TFBV?=
 =?utf-8?B?cVJCV2lSQXZiS3Vzb2taalRPbG9hYU9MbVRBb21oeDYrd0hnWG9hVUk1OHdi?=
 =?utf-8?B?b3MyTUlZRU9BVGpzT3Y0ZU9NQ0FrTVFUZ09QdFFtTlQvTmYrbE9GRStqVDUx?=
 =?utf-8?B?YW92VXJBZlQ3aitIbGpUT051ZFFoTEpBdElLUW1mdzhnWDd2dERMbmpFUGRZ?=
 =?utf-8?B?clVCZTdyRjhiMzZXcEE3Znc0RkJ4M2VTSkpOcGRHdDZncThoeWdGU3pRQmIx?=
 =?utf-8?B?Nmg0SU9CYWxHSTZ4dTdhbHRkU05lTG5ZYjZxeHpQeXRjdDNSZWlwbnk1WTdL?=
 =?utf-8?B?S0xCbitOOFVwcDlaeXdGRHV6NjhCdkxZMS9qZzJEMDVSVDdiaStPM3pRN3pV?=
 =?utf-8?B?aFFyckxKYjZWbEhJTm5FVU9MQm9MRFhKblByOWs5SVF2WVBaNUdJdEN6TmxN?=
 =?utf-8?B?c3ZXWjBhSi9ieWpVeS8rWVlNaW5YQUw0c0kvTUxpbEd5OFB6bGFFNXhkdE1R?=
 =?utf-8?B?NWRWNDY1TGJ4N1I5aWRmVkpwbm1mdGNWV3A3N3hKK2E1ZHFsS1JNYUtsTGtI?=
 =?utf-8?B?L013Sjd5WWFhZGdoNHhWdmpuRTZRZXUxVG04ZmRDRDRad2JGS2NJOWUrb0sz?=
 =?utf-8?B?bkNPaGM3UWxQaXpUNVhMU2FqclBXQ2p5UGJmZGJLSHQ2aWt3MXlpOEdVL0pF?=
 =?utf-8?B?NkVmRzRYbERxVGVSU0xpZFNpbnMzcEttRVVsQ3JrYURrRG8rQW5GOFVYYSt0?=
 =?utf-8?B?QnpESUZURUlZV1dWdy9pK0FiZjhoRUlHSEd3bHV6L05qMzJYWXhhRFRTMnVL?=
 =?utf-8?B?WkhXNDlMMjVtZVVBbUFBbm1GTy92NEFqMVRsOHNidldldFlXVWs4OFZ1ZDRB?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aaadccd2-13c4-4462-feb4-08dc916dc481
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:13:01.5580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w86bVBzCdQhG42TNBxG7NimZyo++07IrCQwI3fX1ACwYAz7H3UG6ziez7ETzK9EHu/jhvVsi3Lpf8kO/85a1goU/ttaNrDbNHo3yUa7TOLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6930
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> Resctrl resources operate on subsets of CPUs in the system with the
> defining attribute of each subset being an instance of a particular
> level of cache. E.g. all CPUs sharing an L3 cache would be part of the
> same domain.
> 
> In preparation for features that are scoped at the NUMA node level
> change the code from explicit references to "cache_level" to a more
> generic scope. At this point the only options for this scope are groups
> of CPUs that share an L2 cache or L3 cache.
> 
> Clean up the error handling when looking up domains. Report invalid id's
> before calling rdt_find_domain() in preparation for better messages when
> scope can be other than cache scope. This means that rdt_find_domain()
> will never return an error. So remove checks for error from the callsites.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
