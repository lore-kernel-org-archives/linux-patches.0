Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795794779E
	for <patches@lists.linux.dev>; Thu, 30 May 2024 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717091757; cv=fail; b=JuxvSI6SdTXqRWrYvaAmpHD9GTmYqJmNUsoyASwrM6EEddYPBkeetr9VScpG35BXvp+sPBmtbmZAkhqLn6/gKXsMf+2Djy1w8obBySB866V/D/X8zqqn25GA4U33/DAzKZ39/czWPH2fw8o1rr57NJQJtO9MbqrB1didVghCHU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717091757; c=relaxed/simple;
	bh=0EVYORCA3cyfK17VIYeKKE9Wu1ZlZ2UEVggMwUylvHY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=indfS8kalSORlPEwmSEELVJBNr8J0iUPrlUmiUFKXY35rCd5ylEXpFpFABIncmQUlf+P4LR7SpjdTC4+L/XNQqz3pMcl3q0HjRxt421MGFYvqJWxGwKCaaYq5SkPUGOuZGrmYmndVGAySGGDqLPV92RM9jfS6s178vPgXoyaJY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XhZYC7HU; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XhZYC7HU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717091755; x=1748627755;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0EVYORCA3cyfK17VIYeKKE9Wu1ZlZ2UEVggMwUylvHY=;
  b=XhZYC7HUy0ig8XVG8d10x0tYksZodl7lMlihdRm98trFQDbC24H7bEtj
   +JJeuXY5G7hqiwd4BH0wNHo1Y2c4rf/vqfWsF16Ll3QFLrBzmMlruQzHc
   5SnnYArrsfCeCA9B/Hcv1p+u4Ka75zH39R9RCbODElJUF9Pzt56eETnsm
   WpAVSWYuxyZNIALZ7+MUUvc9ee+/yruuQweA0917/YnNSbAayzQtIC4GB
   GLCGD88yyG0j5fnoeGvL5v+dtI/4JzXc8h0UgtTyTEuHGjKPTqgkc3i6Q
   BoC5l/ZEb+KMDmu2TTffbO2d1KkOaiVLhYMm2IrunCfa9GnClV9qTyPzZ
   A==;
X-CSE-ConnectionGUID: mJnOF/HKQE2IcL+Zun/VuA==
X-CSE-MsgGUID: IB6G1iCHTACiGH/cNkt3Bw==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="38991290"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="38991290"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 10:55:54 -0700
X-CSE-ConnectionGUID: QdI/DllcQlmyPDeiJdN1kA==
X-CSE-MsgGUID: MR8PWjcyROuzDykPfhm8hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="73394461"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 10:55:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 10:55:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 10:55:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 10:55:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 10:55:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4tpWMz/YRR6dTbehtVVV5fbQiVdmB3qfbeh/ocf8pZ2d1NSCm+8/MQvD1DV7g2I4WFj9AszG9JDvOPOTVL5N61mV33wLCYMYxVPsxLIw9ZSwRxDm/afhubcyHlAJtYAhTqSd6jclCmTRpo5tJ+Ig/YlHZPVRfb342pcvZ2MbboilixnxevcRvfcrTzlMmFV6gEBzvf7Fl4gZAWNSRg0FDeNoPyWFmnaXbt1vKVqKJWDdqTdKoDBzJulm1BspPsiNLNvme3xWxDHS2P8m+Gysqko2yzaDjlV7cosihn+hgNkVn9QtBhJy0kCOWmB6dZ9kpFqjM4HTmYy+v2bKRd0Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tYDNk+RDFOgyfi/28heCkzr/W271aBx04NfuNf1NRA=;
 b=V03xTZdaSslq2sulv+6VNKnibwvSwXQlJTYeL75sifRDRdyM5qbsvqZggQ3axqg6TapZVmJQlD8igJpNFmR+ki9XqeqWQamuuVr6XLd+2AA8q6z/XgoOd9dZBIFL/reIkR57EoktP1XW3aw5MeePXBZVH7Eb3rxHUkrqPbOJbD0T4tfN4kOcu6/R+4/vqjcq7mm9F/5TiaHO784fgM0MJrhP/Oj15gE+in9TPePLPNJpoA8DpcRWDkRs/HwzBlmn6Pnggh5SDmu1qMaoqnfEYEG/TVX7Ke7pB8i6ZGOavkZSTJnjr17DdkO0j5vnuUfIGTYDqW4NBQ2T2S2jrxhnhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA0PR11MB4592.namprd11.prod.outlook.com (2603:10b6:806:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Thu, 30 May
 2024 17:55:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 17:55:50 +0000
Message-ID: <2a761266-e934-4740-bf15-95dbfe4e4d5d@intel.com>
Date: Thu, 30 May 2024 10:55:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 00/20] Add support for Sub-NUMA cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <08ca8fe7-9da6-41da-aad2-0081b789326c@intel.com>
 <ZleODtL_6D-Q_OMX@agluck-desk3.sc.intel.com>
 <a4d37f57-328f-4456-92bc-5e6469d092c8@intel.com>
 <ZlirIUbLw8fLHe0j@agluck-desk3.sc.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ZlirIUbLw8fLHe0j@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:907:1::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA0PR11MB4592:EE_
X-MS-Office365-Filtering-Correlation-Id: d4b09e06-5e13-4b0d-5f34-08dc80d1be29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aTNKaVR5blFDcXhXTVFvZWpGbE5FL0FaaEd5cE5wck1ac0wwbEdGYUpCTzZ4?=
 =?utf-8?B?dDF3ZmRvU2k0b1M2a0tqZG1mZ2RsSzBCZ0FQejNFcThQbk5VQlFGUnFqNUM0?=
 =?utf-8?B?SkVFZ2VTcnJGLzhCcVhYRkdldVdZQkpOQmpSQUZ1VEtuQm1leE5QS05DYWZ0?=
 =?utf-8?B?aTc1QS8zbmZpY3RrRTFMa2E5Um9kV0FvZjZVTXQ2ZlVwUE9uVk1JMFZPMmxT?=
 =?utf-8?B?WEY3YStieDFCRDdpVVpabnNCdGdYR1ZidlpjS0c4MzhpNHU4SWhBRElLZndM?=
 =?utf-8?B?c0lhRktEZDdHeW9XWFJ0QVk1NXRuZzR4NDJXNFBrSExNR0RTRjQ3Ym50QWo2?=
 =?utf-8?B?WVc5NTNaN2QyZU53VGRxYk9KM2dPNEVENFdZOS96MGlCcDdZMGs5dllLRC9B?=
 =?utf-8?B?eCtrNVZkU3FMemZHT1VyOUUvZXlyaGhHOXJWOXpteVh1TFpBQkZIaEFBbFBK?=
 =?utf-8?B?NmRNWmxNRzFJQW1UZzRHVVk3TTJSc1BJRmlRM0hnSzJEYzF1a1NjYmY1d05J?=
 =?utf-8?B?TkpvOGtQNE5kNWprVjRYUmNES1VOOGIyLzd2MHdXbVVsVXB6OUxtT1FLbnBl?=
 =?utf-8?B?cTZsMVZrMGRZaFU3WE9Lc1VXbHNWclhmemtsRkJzSlpEWlh3OUpyQTQzQzdX?=
 =?utf-8?B?SlozbmlEZmxsQ3NMNXE0RXhKczVlL2FLeWhaWk1MdXM5ak4wcFQ1ZTZWV1lM?=
 =?utf-8?B?WExteWVIRnpFL2V2MWtoTzhNNDV2amR0ajk4bzZiempJa21QcTMzUmVHSncy?=
 =?utf-8?B?anB1aUJMWE9ZcUZJZnp2UE8xMUFNeEpDOUdOREdaOUZiVUdKVG5PQlZxVitH?=
 =?utf-8?B?emZsVHArZUxIZERxYWxqZndoZEdORVZnQzFNR2hGNjRoTUlPcnRSdnRpWDRu?=
 =?utf-8?B?VGVDVzFtdWlVR29HeHluWGZzSWxWQURsRGNXRWFGRnZUZGk1Z2MrVUVDNnBw?=
 =?utf-8?B?N3F2MzM0TXY3d09Kem5Sc1NoNkJzU055NmNsRHpqZ1l1ZE91Yzk4Y0VKV25m?=
 =?utf-8?B?SGVoQTZtZGpsMXpRZkgxN0ZBUUFDWFV5d0Rnd2twbC95SG1yT01tb2RoTklO?=
 =?utf-8?B?c1UyMUVWNDk4cmpkbFRuUy9YY3NXa3JWQ25DNWdFcDNEU3Z2ODFzU1hISmlp?=
 =?utf-8?B?SFJ0NmxnQXBvdDBiRjRJOUJYM0NzNFk1MlpUaWJib3FobXpBRkZiSDdMcHp1?=
 =?utf-8?B?c3lHdzdlUlRsRFJKLzFQYTcvSUZmVmE0NkRidmZOL2h1N1FnRkpQL21xZHdx?=
 =?utf-8?B?Zkh5d0dJV1k4cjZZZFFLeDErSWgyb1JoYUZZdFZja1hFMmhoVmRJSXo4Qk9p?=
 =?utf-8?B?SThBTjdpRHZxMGsvK1A2V1lVNHRlbU5yQVhpeWhmUkJycjhVL0M0TGVTczcy?=
 =?utf-8?B?djEvQUhWdnV6NEhlSnFsWEJqbkp1bVY1VWxTbEZvSUlQd2l5Y0dqbDVBZzhw?=
 =?utf-8?B?aytzRXZnS1dDT28vSWs2NXJwK3pkU09MbHM5aW4wTVlzV1JmZC9uQmdaQitO?=
 =?utf-8?B?ejBJL1RicWFqdTNRWWRZYlFsVWc4UUpjN014K3V6alFuT1JHc1FObjRtNVlX?=
 =?utf-8?B?QXpwbTFERzd1OXpaYThpZHgyR2J6ajJxUVQvR0xaMFhQWVhFc1R3SUdmcGpL?=
 =?utf-8?B?MDlCYlJKMmRkRHB5cW43b3NxYVh1V05FSWFtZVBjaDdaTnJVdFdjSXFwY3VL?=
 =?utf-8?B?QmVEbjVmR2lDVnhvWWd2alF5QTg2VWMxRTdIWC8wRm42WEc1SGx6dmFnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZCtja1V1Si90ODBJUXRKMktBS2RVcFJ3QmZyUnJURXVtL2w2WXZxM2JYM1ZS?=
 =?utf-8?B?Z0YvQThURVZaQkFYeUZwTTRVWmI0SXIzRWxkT1VBQkZSbkNMT3R3QlZaTGRr?=
 =?utf-8?B?S0kzQzhiY1M5c3I5TzNqWVlFTUQvZ0NLanA4VmdBMVJUQ3JOdUh3eVBxaEJx?=
 =?utf-8?B?SjVkU0tXZ3A2V0pDR201Yjl3MWc1dnYvTkt6bWxhZklMcnlEMlk3QzBBbWNn?=
 =?utf-8?B?aldXVjB5UWFMQjFrREt3ZTVnTjdTTzdOLzVwTERLRStLaG9hS016MDN6cUNm?=
 =?utf-8?B?b1M1QzMxYm5oNmlsUldYODR5SU1Tb2J5eEVLc050SmJDTEgyUm5HdWhaQ2F5?=
 =?utf-8?B?Q2kwQXJISmVoQXd1bVd1ODd0enRWNHZIdWhkejlvYU1QZFZab0liUk9ZZUtn?=
 =?utf-8?B?VjR6RFAwY1c4WTNNQ25uaS9ydlY0a2VLQmFzdzgvbFdkSmtUd2dkY0pvbWNx?=
 =?utf-8?B?TDBjRUgzb1lGdkNWVjM3eXVaV090d0x6alo1VE94RmtPRldYTkJIb1hzeFFE?=
 =?utf-8?B?OTVKZ3ZDMVRTQndnSkZtNVhSRmJwaEpJc1RISVR0aTFIRElSYTV3bW9rSmNY?=
 =?utf-8?B?cmxmRW11dlZ6YStlTWVCSlhPZVhPRlNIQVhWWFpjUkUxS2lvc2N0Y2YyeTQ3?=
 =?utf-8?B?ZHpiWCtrOWd5YWo1TklncFBWaVVScHZ2NitKVkJROVkzYklEM1lRalNmN3Jl?=
 =?utf-8?B?cU5FaDBXOG14Ym9VaVZrNGQ2YU1Zbjlra1FrMHA4WHZJbnRKVVlYdXlFZEVS?=
 =?utf-8?B?SEpTNEl2enFNa2hXUG5MMzY2cjZJMUJHbzFQRkgrUTRNaTVBdkhWVEVwRTlK?=
 =?utf-8?B?U3RZeDBFbE9VZ04yUmpPbWUxWWtzdWpQRkF1bStNSmxLcXkrN29JRnpNVWJq?=
 =?utf-8?B?QkthWjRENzduUmRPcnpra1paeHVJeFBnT3BUS3RQZVVuTzNDVVNDeDZ2bDZC?=
 =?utf-8?B?RGk4bmFHT2w2eXNOWGF5YmMyZUxrbVJSS1RySVNzMFZ5L1hkY0FybWVFRVNp?=
 =?utf-8?B?OUlPdXRTR2xObkVUV091Q2hCK1RjY0RmelN0SDFhQVU3UDdBNGdJeUJGWnBL?=
 =?utf-8?B?dmRzNTBiUGFObU03eGVLb09xKzREQTlPNk4rWm1tK0ZvaVArNldwbEJtRHds?=
 =?utf-8?B?bTdNOE1NbHBaMWhvR2kvaGNMMEpVZ3ZLTXkzWEMrajBGMW9pN1NiRUJWVTVD?=
 =?utf-8?B?ZkxyVjNLZ3pjMkxYS2pVQ3hURnhVYVVCY001bnVVQnBYSUVPTW9GTW8ySVow?=
 =?utf-8?B?MnNSOHdOOXNXRXYzQmc5OG1zbGt6by9QbHVFOXhDcENiNU5pN1djUVhpTVA4?=
 =?utf-8?B?WDRXNThQdndYSGN3MDk3eU16NjRsQ3lJVHMvdWNHQm1uM3UwNXpTVkw3ckVj?=
 =?utf-8?B?akM0MUE0OFQxUFhGU1BWUW40alZ0d2ExN0FjbEdtS2F1a2NGL0Y5YWpwdC94?=
 =?utf-8?B?YXJSQU5mdC9ZaVIxWjhXSTQ4SHR3NHR2ZzVydndDY1FJTzFiTmlsVHA4MFdT?=
 =?utf-8?B?LzRka1JtQ3dzSkYzNEpUMy90a2xtc3BlSlJZYkJxM1FnYVg0dkk2WmM2Qmox?=
 =?utf-8?B?a1ZyRk1ITGxmQnNtQytCd0RZV2xzUDMvR3E3aHVUQ2ZhSFFMOWhPZWVSMnVO?=
 =?utf-8?B?bmdsbjZCOHNKVmpEMmpKaHh3bXczc1ZyWnpnM3JSYjk0ZG5ja1pXQ2xDaklk?=
 =?utf-8?B?TmNkeUlwZEpWVzNRNUo4K25LUzNWeW9nN0JMaE1EaUtlN05FZHRuVUkyM1FK?=
 =?utf-8?B?b1VWeXp0YWNqcU03R2pQRFVTNXo2UXh2eDl2eTVhWnhNYnRmTEhENGFuenFq?=
 =?utf-8?B?Uys5aVd2NWduaTVyNmVScmhlbXFjaUdrSmNCZi82RUlsdlBadEM1OTgxMnJX?=
 =?utf-8?B?emxzZERTd25oZlA4TmQxS2h6OWRWcS9uaEVsS2p3SVkzei9NYWkzaVRmQi9E?=
 =?utf-8?B?ZXI3bUpmSkJ5cmZHNVlEV1htNGhLc3N6UnFhVDhYbUZ5eUR4bXc4ZzNROVhX?=
 =?utf-8?B?ZjZvVnd3bUNSVjIwbWorVjVHMGRwQU5POGJBengxSTVDQjF0aWxqekJQdVBN?=
 =?utf-8?B?cWVRMWJJa1RxbnJrak9GNDVrV3hEYVN0TlFCQnduemlSSnd2alFsYTVVSXor?=
 =?utf-8?B?OWtHK2xET2JHYkh5ZFRmM2NOTEUyOUU2c241MGUzVmlJMjJPTlFlRklqVmFT?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4b09e06-5e13-4b0d-5f34-08dc80d1be29
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 17:55:50.7853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LGnRuR6SIUB3nxMhaOKqpCJHa8K74WF32xBwcVFbBdKkkOEzZbhFjif9uekOuRJHnngSmpYX+3ZqzTWgCdbfefd1XsyD2q2QQeuD3poyiJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4592
X-OriginatorOrg: intel.com

Hi Tony,

On 5/30/24 9:36 AM, Tony Luck wrote:
> On Wed, May 29, 2024 at 07:46:27PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/29/24 1:20 PM, Tony Luck wrote:
>>> On Tue, May 28, 2024 at 03:55:29PM -0700, Reinette Chatre wrote:
>>>> Hi Tony,
>>>>> 13:	Wordsmith commit into imperative.
>>>>> 	I looked at using kobject_has_children() to check for empty
>>>>> 	directory, but it needs a "struct kobject *" and all I have
>>>>> 	is "struct kernfs_node *". I'm now checking how many CPUs
>>>>
>>>> Consider how kobject_has_children() uses that struct kobject *.
>>>> Specifically:
>>>> 	return kobj->sd && kobj->sd->dir.subdirs
>>>>
>>>> It operates on kobj->sd, which is exactly what you have: struct kernfs_node.
>>>
>>> So right. My turn to grumble about other peoples choice of names. If
>>> that field was named "kn" instead of "sd" I would have spotted this
>>> too.
>>>
>>>>> 	remain in ci->shared_cpu_map to detect whether this is the
>>>>> 	last SNC node.
>>>>
>>>> hmmm, ok, will take a look ... but please finalize discussion of a patch series
>>>> before submitting a new series that rejects feedback without discussion and
>>>> does something completely different in new version.
>>>
>>> Reinette,
>>>
>>> So here's what rmdir_mondata_subdir_allrdtgrp() looks like using the
>>> subdirs check. It might need an update/better header comment.
>>>
>>> -Tony
>>>
>>> ---
>>>
>>> /*
>>>    * Remove all subdirectories of mon_data of ctrl_mon groups
>>>    * and monitor groups with given domain id.
>>
>> (note comment still considers that domain id is parameter)
> 
> Will fix.
> 
>>>    */
>>> static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>>> 					   struct rdt_mon_domain *d)
>>> {
>>> 	struct rdtgroup *prgrp, *crgrp;
>>> 	struct kernfs_node *kn;
>>> 	char subname[32];
>>
>> I wonder if static checkers will know that this cannot be used
>> uninitialized?
> 
> I wondered that too. There are no complaints from gcc. How do people
> deal with false positives from static checkers? Simplest would be to
> provide an initializer:
> 
> 	char subname[32] = "";
> 
> While that might shut up the static check, it would be more confusing
> for human readers.

or	char subname[32] = {};

Please elaborate how this will be confusing to human readers? A comment
may help to address that.

I took the time to run a static checker on this series and it did
not complain about this issue. I did not run it with this fixup though, with
just original submission that seem to have similar pattern. I do still think
it would be good to initialize the arrays.

btw ... the static checker I ran did have four other complaints, three about
uninitialized data and one about divide by zero. Most problems appear to be
in mbm_update() that does not initialize rr.sumdomains nor rr.ci before
calling __mon_event_count().

Please use available tools to check code before posting.

> 
>>> 	char name[32];
>>>
>>> 	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
>>> 	if (r->mon_scope != RESCTRL_L3_CACHE) {
>>> 		/*
>>> 		 * SNC mode: Unless the last domain is being removed must
>>> 		 * just remove the SNC subdomain.
>>> 		 */
>>> 		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
>>> 	}
>>>
>>> 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>>> 		kn = kernfs_find_and_get(prgrp->mon.mon_data_kn, name);
>>> 		if (!kn)
>>> 			continue;
>>>
>>> 		if (kn->dir.subdirs <= 1)
>>> 			kernfs_remove(kn);
>>> 		else
>>> 			kernfs_remove_by_name(kn, subname);
>>>
>>> 		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
>>> 			kn = kernfs_find_and_get(crgrp->mon.mon_data_kn, name);
>>> 			if (!kn)
>>> 				continue;
>>>
>>> 			if (kn->dir.subdirs <= 1)
>>> 				kernfs_remove(kn);
>>> 			else
>>> 				kernfs_remove_by_name(kn, subname);
>>> 		}
>>> 	}
>>> }
>>
>> This solution looks more intuitive to me. I do think that it may be
>> missing some kernfs_put()'s?
> 
> There aren't any kernfs_put()'s in the existing code.

Why should it? Existing code does not have the kernfs_put()'s because
the extra reference is only obtained in this new code.

Reinette
