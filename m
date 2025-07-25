Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B40612DDA1
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487026; cv=fail; b=Cl3xr3BViBpAm1Zo4EA40NYRZpHB8j1Rg0A8/oxTq1vNL9x9hHET9R2pz3an3qrA77O8cU+dK/yG/BovfpDxnNay3bmifl12G+NjkKb/9ayf2WXXI7+SSQ2aXgB1SnPCHLKqNgUWKjUThIUz1PpPPKrmRlff1NsVwQBk2TuwO8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487026; c=relaxed/simple;
	bh=WN09ByGadYCNhsYGIuWc8TQHSesjKQcI1RYOmpi5PY4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r/TmB3dbHe1LwpgIKCEpqaj9fJuYRwVcQaIDCi6eV2qDwWkxn1PoBUFQj/mTvPUxy1yDZLkjlAmt4b9h5wn1rbaldt3jlHPXXnruYJKVlM7Vajo+ZwRxDIv/1KK6svSdPQ/L2ervDVqCg9K1NMSevXWRzll5j7L8+QPjNyEzBaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dbMhZt4g; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dbMhZt4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487025; x=1785023025;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WN09ByGadYCNhsYGIuWc8TQHSesjKQcI1RYOmpi5PY4=;
  b=dbMhZt4gtHWEJDqgWYoGUk7NwGrsSMYnI9zv7w5Q6iwwFfTgXTjFM8Fg
   Vu3HC0vqRGJEy68LhIyGeW5vyG9XIhkXlrdQB6JV5oUmgBSN+nK69MBKW
   yGuZ+rGLWm21E5N6jEYs2Hn28ZXmanzzRYlSOF9eoa3YtC1QXDUXsu8j4
   gns4Hpe+kNZH+xcaN/72IdBxJFoi5aWydFxzomOdJEqlsOBGujo9lywVP
   eE/nCux69jg2bUJoZiHSo3fb3wxF3neY8cinkM4ZS2MQODO5fjWtnUEW5
   rUq1k21BGCOT/nGQloaibs7tlEt6YpnjlXRbRBcPm1jaylx+sitMeCHqm
   g==;
X-CSE-ConnectionGUID: Kwr/MAALQzmQJJI2XabPGg==
X-CSE-MsgGUID: pu4kxpPjRQeVi95T00tQRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="66395086"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="66395086"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:43:44 -0700
X-CSE-ConnectionGUID: pgLkcn7kRGy0qPHYrdmAeA==
X-CSE-MsgGUID: SlLOgIYXSgug807KTToRaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160804496"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:43:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:43:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:43:43 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.72)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:43:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=idQuSFhVmzYjyCEw8aTy7fOP58JlRYU+cbYPzHMbB1ea7Xy2Vgrc01ZnpThsiJtIUbJ+FKXIZzS1rLcCWJxnFXSMAqMtN60gbN8QrMo0aDokVGAXuqXoIKStYNJPjzuaTSwXS3/b3O8q5UD+EJNAQp5ZKGLqeXGFm857t1OQEobQ/7xNhTFbk3n1ky7gSRJZ1WQvmBEyPOiEgWGsqw6RghuQ9E5mWyuUUbeVVwCzD6npa+SyuqKLke+rEirrj8VLVrHlmIG0L3+4uyIMOzxbriwpDOlQ3S6W5bYF1GczRSBjsQpGNqtnoHWihzVpiCfXBngTe3OjbVIP8uzOKke+UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zz28iMUY6gn3GmslF5ibX+oIPtPRKKctXmrhGMuEB/c=;
 b=dVKzabhh9TUYzFdhRJ2D8AwJc+v1EVD/6Tu5Bup4NCUqA+NDBisb9DH71OMwDwlT4sKl7M3teVwzWPMSGsYFmKt+luzaqOjLQ5WgsCEWPxWGDmZ6LR5L7EW5HKZXgKLjDueOdWTQnLxg9Pk4lmZN1KEvNTvyGnju4mvlbPaHSQ5ndIpHCokFYezyPPyjtQ4kRS5/PyMyT38Syg4KG0vP1gEE9BkY//cCqjF9UZhu/JjTfqI5ulPoydagGOMRH1i3KfJTwaKTHcEaZCAIMW7EhSBfMAdTbHynPwQuRji+RvOhPkv2mol4CENVIm8rC1xB+IiwkL2+HVTG6E8deWUP0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 23:43:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:43:41 +0000
Message-ID: <a77c6173-69d2-493c-b566-5ab447f019ef@intel.com>
Date: Fri, 25 Jul 2025 16:43:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 21/31] x86,fs/resctrl: Add architectural event pointer
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-22-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0016.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 888ea880-1d83-44b5-2f7f-08ddcbd5162b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R3NnaytXWEdtS0NhUUZNcGFEQ2R4emRkeWZCM0pDQkVoVVVzQWF6VDc1TTFa?=
 =?utf-8?B?djRHWDhJM0JMOEJ5SGxyUFM2MS9nMngxcytzQzQ1NjN4eHZxOEVuckZNTWYy?=
 =?utf-8?B?UVBJeFBsRk4rNkRzZlVXcFp6WWJUS0oxOHpySlFzZ2VKcE1oblBnVzNhMmg0?=
 =?utf-8?B?Rnl6MmR0YXhDRVBpVUQ4aHRRV2FTUGVJYVhaa0dwR0FTeEN6VWFlTEJNN0ow?=
 =?utf-8?B?cFg5U1JXYjlkR01OcjhLdXZxLzdGWkNYNkpHTUVTd2xqUVN0MVZqekgrYXY0?=
 =?utf-8?B?clE5NnI1ZThlbUdvRnpLTU9pR2V4TFBiRFNaWjFBd21zK21rWDl3c3VUODhP?=
 =?utf-8?B?dDRQM1lGdG94RGJRZ1I0Z0l4WHVTeEFxOGI2eWp1RFV5RmNsYVplUGRwc1NM?=
 =?utf-8?B?c0k2Sk1yTC9ldU9qK1VjbTRoREhDV28rdDFRZjBYT0tSczVINTduRlZRU3pw?=
 =?utf-8?B?TkRQaW1Cakc4M25FcTlxZCtEWVZKSkZGenBGVHFEeWNNeUM3QkVJNmhFZmYw?=
 =?utf-8?B?V0dLQnJFM091OWZEV3dyZjR4U0ZXMFRpemhrRDE1MUQ2NEx1a0JJVllycWkv?=
 =?utf-8?B?aTNmQ2o1cFFFY1BiaU9mVjI2OVBFS0tNb2xLUG1hb2J5M05aRzZqV3MxMU8v?=
 =?utf-8?B?dUROdXg0MCtQNGM4VllRY1VhWjNiYUdxWlBNV29qNHZxR0Rqd1FLVmw5T0t5?=
 =?utf-8?B?TzRsa3RrNWlzNkQySm5hU2RrZldEbGtXU2pQMysxSDZOTlZJdE9zbHBVMHIv?=
 =?utf-8?B?UlFUREdSemJoanhNL1FNNXB0OEdKRG8wdzhwUkhlc0dKdVRUUFVDWXVLUENi?=
 =?utf-8?B?TGhhalNZMEhlbFBZRTVvR0luOGFMamdtQUJzdWtZT0thbThaWFROeVl0UFZr?=
 =?utf-8?B?SFQzR2tXMDlWTzlTbU5GelExdTRDeGtVYlBuR0llRnBPUG0rczhQUVpIV0Vu?=
 =?utf-8?B?MWtmanJaR2N0S1k0MzVIVzh3anNrd3phVVBVWDVGTFZPbWhUNmp2aGp4dDQv?=
 =?utf-8?B?Rkt0aGZvZHdVWmEzTTR3Ry9QWmFER2pqZ1FzM3hyam8rNEh4UThxaFhRd2Nl?=
 =?utf-8?B?TjdUZUtFUkRueTgyWGxOL2VNVDZzZGRhcWlNb0dyUXU3RzA1OVlrMDNHb3Bw?=
 =?utf-8?B?Q0FzNEVTMExaZU83SllPRzRvd0NNdFFVbGZBSjFzYS9LWUkxRlFWVm1xT2VV?=
 =?utf-8?B?VFNYZXJLQ0VoOGRzSW5pUmcvQkwxRXdhV2xpbkwrNTVPM3lMVW1DNU9IdUdz?=
 =?utf-8?B?Q1NCZkE2TU1yR1pTRG9JS3FUdlg3bHU4T1NhcGw0d3dvdkd4eldiald6NEUv?=
 =?utf-8?B?Lzh5S0xBYWtuNnZoSzBCbHhiYWh0TTVBQ1grd3IydDFBM05SNHNmUER1Rkha?=
 =?utf-8?B?aFR5ZDlndFIyRVpiZmtGb2FqTGpodWp6akFHZC9CTlZjc1RmS1VVWU0rbjZZ?=
 =?utf-8?B?ZWQ1blZ5endkczNZc1A4QkVnbWR6U3JrUjM3cVQyTmE1Y20vSGZRUTBLTlBI?=
 =?utf-8?B?bGN1MG9BWkhDdVpqNUlBMjdVcnRjck8zU1ZuQzcvaStiWTFzNzVTU2NFUk01?=
 =?utf-8?B?SFRKYTFMZDBQUitQRUUxclZaNS9BcDdsUmNUUlFoeURvWDlXWHJTTDB0SWVG?=
 =?utf-8?B?SXBMUE42SGhiUjQ2WGQ3cGRjQ3Q1Qno5aFpwbE1wbS9JcXdDb3VUTzdHTlha?=
 =?utf-8?B?MDV5cTZHTXdxOS9QUmZKaE1PRUpOcERhK1ZqazJaNjY1ZWZKV09IN3hpQ1Fn?=
 =?utf-8?B?MW50aHJaT1ZUK3FGdFdYNTR3T0twVVpsOWlKUlZjZU9zNk9rcFVtUFlBNkI5?=
 =?utf-8?B?d3ZXNXV5allxTTFpT1ZQODFWc09yL0twbndVSzJudlJER3BhbTBac1dBRXAr?=
 =?utf-8?B?d1l3S3NQN1hPcFZ6ekRQZldLM09uWUtEdGYzNTAvOW1lbVdWUDgvOW9qUVNT?=
 =?utf-8?Q?oZWWZBKSvYc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1NqZ21qWUUvaUxxOTFIRWdIL2R6TDBnVHpieEJjZ2tJblV4R2FEZWNZbXAx?=
 =?utf-8?B?b3VmLzBoY0VnejJEK3Q2OXNHNkNBbCtWV0RGMEc0WlBQUks3dmk3QU05Ky90?=
 =?utf-8?B?YkZXWFhtZ1Z4aG5NQ2p3SkRLZFFLd0hZSUwreGRUb3lQbzcrQTlBUnNoOW1k?=
 =?utf-8?B?Z3FsaXlUYmRYaWZkd2ZnTFNDc002L2F5TXJObC9Pb2MrbEkwaFIyRXlYUjM3?=
 =?utf-8?B?Y2owZyt5Wml3T1pISFpLSEpMd1N1TEFMYjhJd3NLeklkSERyYzdhaDdIQmVL?=
 =?utf-8?B?TnhhbXZNbkx3UE5nUmVoaUZsYStIbUNaS0ZpaHhXMzUwekJTSUtoVDVDL093?=
 =?utf-8?B?UldhN2ZTbFptT3JmQ2tvOWpTcnZ2Q01ZbCtTcnYvYkM2YWtXN01mcXl1SWhq?=
 =?utf-8?B?TDFnallwNDFxRy9qRlROdFlpM2dBdjFWS0NlMk5kNVN0Y0Q4MUh4N1dSWEtU?=
 =?utf-8?B?UVhPbkJGdUdReC9kR2VHUDl3Ym53cjNNd1hlMVdCdUlhV1V5b0FvQS9JVm92?=
 =?utf-8?B?SFRPWG12a1JDNlZOVVZNeEVxNjU4UmZrWUxPTGppb2NZOEdldGVqQzJPQVp2?=
 =?utf-8?B?SDUxeEV4RHpHaDExbkowTXVERC80S1hkQmNwSlVHOTF3cGJNa090L3E1YXNz?=
 =?utf-8?B?RTJxQlhuQ29nZ0MxTzBLdCtlUkxlMDBPQ2JzM1BpQzRISkpFTmdBUGNKYVk0?=
 =?utf-8?B?UkVnd3piMW1LR2ZFOFREc1hELzJqdncrNmRCK2RxQWVhWXdtSHd1bERaOWZJ?=
 =?utf-8?B?d2hGMkxRSUd0elEzZUl4cjlGNERvZU5JbCtGNkdYMW1oUXltYkhjYklYaXkz?=
 =?utf-8?B?UFpRb290eHdjV1ZWZzdkanIvS0RkZHQrUDJibFhtZzlrTFovZjhQMzlPREFi?=
 =?utf-8?B?S1NxVUQxanRXSENUWjNHbWk3K2N0bXRWS1VnZVA0dktNVTg2aG1DUUNBTVJj?=
 =?utf-8?B?ZGVDSjhoZ2xkK0pXU2U0QlNmRXQ4UWhyeFcwZlVPMFJHZWZ3YWVjTzZGRU1D?=
 =?utf-8?B?RC9pd1J3MTVyTnNkZElrbzN2MERnTDU4cDNaWHFJNFIrSUFaV3BwREhSay9I?=
 =?utf-8?B?emQrTHBuMENLeDRPa2J6b2NxSm85Tm1Pc3R5UnczOGlSVHZFR1g2NW11MHdP?=
 =?utf-8?B?dnB4V0xJQStxTDQyTHIrdmdhZys0MEhGK1ovZitweFJsVXBqbHBTQnIrSk9L?=
 =?utf-8?B?M0FiRU9tYzJJQWMzeTFpenZvcWlrbElIaTRJQ1o4UUtWYTFVb3RDenA4Z3Qz?=
 =?utf-8?B?MjdDZTMwa1A1NXJ2WTFEWElhUytCdURxdGxkeGgzTTRWVHlFYjhOVWljajFx?=
 =?utf-8?B?ajFMTVlUTGwrOStJY0ZBMjJaSk9LQWtMR2Y2UTJYZThxTHN3TC9hV295REV0?=
 =?utf-8?B?QWhLS3pkVlMydko1S1V0V3U5cDNpRVowUXorWVp6RXUwclN2NURzMEZGZisz?=
 =?utf-8?B?aDFXOUZHNHBzMThrZVhwMW9vM2tRVHdiVW1yb0Z0MzJHL2dHM0FraUZGN0hL?=
 =?utf-8?B?NGFQL3NZUmc3Z0lzOEhBaG5sVW9tRW1VdkdiT0xqOGlXRW9CZVJnZlUxZnhF?=
 =?utf-8?B?cWZwckUyUU1nSTFYVVdzVVVDbDNxQnFEd2wxNWJOT0F0bFdWQUVsTUQzUG5i?=
 =?utf-8?B?NmVXQUw1QmNBaWF6MWxtdXkyVE84U3phdWdPMXNMMzNmRHZPbWxiWDFCR2F4?=
 =?utf-8?B?Rm16YXl5TmJiOGx0bElIQVA5RXhYWUdyNVV3UlNKaXVaS0c4VXBCVnEweXJ5?=
 =?utf-8?B?UUVmVjhIUTFOT2g5VWEvR2lseXVHTjlaVHFVR3ArTTgwNllGZ1h6Yk5TTzlY?=
 =?utf-8?B?THpHQ2k0LzdWcVp0QUxIS3Jna1dxRFVTRzRpTTlKdSt4blNzOFdHaTYvQmpY?=
 =?utf-8?B?OERabGdGV2VxRXBUN1pDRFBiK3NkeVlUREMrTEFHRWhrdENYbE56cGJzbkhj?=
 =?utf-8?B?MnFYMElBdzNZZ3o1cFpXdVRKenp3TEUvdG95enFWdFNPd21pRnJJeTRmTTJW?=
 =?utf-8?B?RkJLL0V6QVU1OXFXR1plWlZvd3VkUHZCWmU1OUh4N2QzMDRKSDZNUFFUMmxx?=
 =?utf-8?B?M3FmdzVlc3hZdGhObnFqb0VMUFRCRWU3MzRnb2p6YmhTL1RTQ3RnTmJyZ1JC?=
 =?utf-8?B?V3FPMFJ2WCs3ejFOa3ZJZ2lydm05Y3UwTy93SFhCVlF4UG4zMW5WVVRqT3l3?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 888ea880-1d83-44b5-2f7f-08ddcbd5162b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:43:41.7963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RLymCgNOqeiUTPuMM/3v3+kJtBfCEM6Yul1YXukrD028qKN3HV9Tmr0D6KYCAa4REDcnIF78aJc62KbmmN5bbgh4Yo/Eg+duNzEQ/YfomI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> The resctrl file system layer passed the domain, rmid, and event id to

passed -> passes
rmid -> RMID

> resctrl_arch_rmid_read() to fetch an event counter.
> 
> For some resources this may not be enough information to efficiently

"For some resources this may" this is vague and speculative. This can be
made definitive because there is a clear problem solved by this, for example, 
"Fetching a telemetry event counter requires additional information that is
private to the architecture, for example, the offset into MMIO space from where
counter should be read."

> access the counter.
> 
> Add mon_evt::arch_priv void pointer. Architecture code can initialize
> this when marking each event enabled.
> 
> File system code passes this pointer to resctrl_arch_rmid_read().
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
