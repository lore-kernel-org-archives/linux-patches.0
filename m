Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AD6253F07
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774653629; cv=fail; b=WvoUw5Z5fe8xTeKJfQVaXGxY+xAamxOo1Wk/Od3n65baz6rvNhekoBsnbI8ZmtQYEgseRnipjr9dfZzEn77/kNF50+AVKc2dVDrA4HaXZGfnPHqapYnXWvpkfQ0ADk5kg/ZtMQmbswWoXZZDfI1ZqTYsFCiAbYVzwSnnVN3nInw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774653629; c=relaxed/simple;
	bh=r3Yj2gzSBGnPS+r/P51vN0QaYYmA++wjpdPHRiPE0hw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HoB6TlRxXya9eilPVhJZo2cp5KKuqAj2Vk/BHoLiTv0lRkgVSyFDWdkK2xdva3+SoMThIirI9gtVyU4DmDM4pJbxJXbrcfHNC/uwICvuAe/lgucx2gglsnuyoMDWMeUisEK0w5UL6dGaa2jNAWazSM1KPxOaf2NZYfnZTaynjaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dOIMCHw6; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dOIMCHw6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774653628; x=1806189628;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r3Yj2gzSBGnPS+r/P51vN0QaYYmA++wjpdPHRiPE0hw=;
  b=dOIMCHw6F9PxnI18u7goNAE6Pal5a6jOha9mg4TL5ZtxszRM+2bgmvPl
   kW65ltmY0U9bi4mwRd4rmaf+l5FnjeGa+TWQGCQbW9/BS5hTqM5Ra/g1n
   bNJ/GqmrI5Mr7egrqB8ly8U6Jj6WFIwkOGAMpPf8uJOF7ZrgEFFVQ/4Xu
   7xVC9oYKS+q2aak6bDNAjoDAwwqU5NS63YAyv2u+wSzmH9aKdpufn0HEP
   9P5QsQr58EsLlhWw2ED/R+FIRwt0oqGOcI2+M45lCPhLez8KJkkU6WoGW
   uIucQnBdaBgnBkuvpuw+yCxBAXxaNi956vp+vuLx8vyarTpTrpbd1gyKN
   w==;
X-CSE-ConnectionGUID: 460/Fj8aRjyuJ52DfgVgzA==
X-CSE-MsgGUID: ljeIyZouRPa4uluLgCtGZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79638256"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="79638256"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:20:27 -0700
X-CSE-ConnectionGUID: Sk1/vRM9SCKDbwhkbAxy1Q==
X-CSE-MsgGUID: vuVE5BN8RfCqHG0xIsHMSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="230374601"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:20:26 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:20:25 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:20:25 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.10)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:20:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=buoTuastwh+6tja6NbGTmi4GvGJdGoGbZrDAWJu0/AD2q7HtbOChrDywDzpCltasEqe0XXzP4aicJYnv+m/r0Hcbfyk/peleBzh3dMlIV8H2/4TJ1KAYuSJlLe6VXgrC1c+LoALqmYZ6G2sf/YZ4o3u0ma3xjkcB3byuZl/hKvwEm287O0EplHQJSWWxeoUkHT7Zr+5i1Rm9HilImQZOqJLKyIS6lZqv94VK9erFkUNFkEMKqUESxQYM7Mv6Eh6X1Njd5eUvEvKO973MvRmeUoiI0tmzuczUA3yFclaY6RtYRkGuq5Zn724XQgB8BDmOMBMUdWXrC+XwzExjBqsQrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fkpm7tGr+hCJ8MFrWZqkab8C1vjxDrbZQO/JCRe+BU4=;
 b=YGjftjKDYE7H1waWys34gFJdyudlzrvnwrdjexLIwCO2MZPbBj6pUrTV+Jo1QBoAB6k+bNvBDr2m2KWkl9f6fHALh09ItTfBa4c93OwJAJvmpobrjheURZ/nCf3wTFH9orPGB6q0MzcHdxnIUEUhsm6kvFAaNAElT+dLk/wmTfKpiTr+QwsyRrJg9qMEZzKvqykD4U2npzqJcNQHJcYWIN60NDF/2/TBBe6+6E4gbz09kiDvc6ody2E/UHRhX47OA/TZTBihTF2auIwb7TXsqakKbAVyywQ1DC5mKTtpFag05UdPLQksZMaHth9CJQJRiHhioyUaTwQe/+io2I3fqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYXPR11MB8711.namprd11.prod.outlook.com (2603:10b6:930:d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:20:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 23:20:22 +0000
Message-ID: <a7c3c571-abf8-43bb-8ab9-a248f4594519@intel.com>
Date: Fri, 27 Mar 2026 16:19:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] selftests/resctrl: Raise threshold at which MBM
 and PMU values are compared
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<jason.zeng@intel.com>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1773432891.git.reinette.chatre@intel.com>
 <1bdca244a899a605c1ddd701a09d6a9d0c242856.1773432891.git.reinette.chatre@intel.com>
 <c5dd1a0f-ed9d-d5c0-8b7a-25992ae713ab@linux.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <c5dd1a0f-ed9d-d5c0-8b7a-25992ae713ab@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:303:dd::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYXPR11MB8711:EE_
X-MS-Office365-Filtering-Correlation-Id: b2b16163-88d3-451e-2307-08de8c576afd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Is5j6+HnAGYFCMybvX9txIHi32N3+/CQ8bNIOR9/DBVAXuk8KPAxd2UkGL7THTqEGrSllcSK88jtDX5AAllT5gplMnVa/1bJA5O9solOPqNxZF9jFl/VxPZLL3p8Z7owwpO6O3mbezUMx1T2WIvqdCGpEBJSuCSyLnLdMWJljUyTAav7lGD6wz+a3/nzJtDNjIRCAJNEnehgOuUHg+rzvJK9aUOT7kEk3YW3M5SPgILkYi5ZNdiGqRrN2GoHuW4rr8L29L3fwT2iW9mIQgz/qypn9gBZTWVsKTEYzTp5P7Hxg87wa6L396pSo7tUad+vconwJqfyUh4k5eQ3JCSJnlMeB8nP82W/Xi1Lh6NAdwrzaR0o0AZ20QGVoabnYbkOp3QsdBtwHHVrWi29MXb3XIkrdZEc4RUhTReRVaGH01kO3G2usEQHVuZwUVzBTW7xvy5wU7vJkBnCwU6/Y1URzCnl/Umm+YpCKcwUWEhEtSHT9mhgJZlOtbapdByo+wyEjVTslCUTbXDiJDJT0L1wZNJH/ztWCaxTnViTCVnNM7dhLMmHGoE9q8A+B5WiNhWprR+OC+Cm2jyhZcG7tOv2E7kWD+ef2atE/jWS52jKA8YFXckvDycPBHFpzKvIs17SB3bqat+V/lbnY5DVPMoYe8bbMRTDJHqkYFqg7LC4Do+4zHOeAx5FoSYFKqQE0FEHiWqj5Q/YCiIWQEwdCsxm8xlalI9jmZgBYR98Gxg18Z4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTV3UWtuQ0lEWmNoMUk5WjVBT2VEYWRxc0NEM2szbERuT3hOSStVUHRUcVpX?=
 =?utf-8?B?anBzdGpTUVRaN3FScFBHNHhxcng3UkdiR051TTBnbGtBOFRNeGpHbTZ2blRZ?=
 =?utf-8?B?QlNQcG5Oc2tsdVVIemJ4R1huNlFjQ25DVnY4eE9hbEtmaDZlVEIzZzk1VklE?=
 =?utf-8?B?YkpPY2xQU0VMUFZsMW1iYjh6T0xnZjJGWG1vaVJZTWNHSk5rVzlOUFFrVFZK?=
 =?utf-8?B?eGNsUmwrTWlXQXdxaW1qNWsxOGRMdGw1ZmZLRVVkMHhhZkovR0lBL0VzZlNo?=
 =?utf-8?B?ZFpGbzRvNkp6ZVZqb0ZLdGovYkNYLzFkWVBGV1ZLM0xmOHNrS1Y5MnRmVTA2?=
 =?utf-8?B?ekoxOUR6T3hSbDUzb1N2VmY1ai9SU29rLzdPMmI3ajczVlJ6VitONXE0RDZ3?=
 =?utf-8?B?ZS9zVUNwL3BGSTdGbWVhSXdzd3VmbW9OcUZYVW5SM3JJSFh3dnF2OUNRRDNr?=
 =?utf-8?B?dXRTdlB6cmJidzRsaExHbnNwRml2eTc0TkpLT0pVTjE3eHlQOW92b0h5MG45?=
 =?utf-8?B?WXZseU9LVEh0cm1aUmo3QnJmWG9SN0h0VEExcGNnNjMwV2ZUVGUwcUhKVUtX?=
 =?utf-8?B?T05hL0FCS2RZZXd6dTBjVXIzVk1NT0hKZWVhT1RPOVRONFhlYmtFM3dvUEN1?=
 =?utf-8?B?TU4zWm5jN2dhV3EwdHVwbnhuVUxVdzF5YkxMVE10dFU0Z2NYY2ViY0hYN3FV?=
 =?utf-8?B?T1pyOFRVazNWU05sZkcrTCtHajRUbzBGTHo0d2pLalY4dmtMWmc4c2ZrQzFJ?=
 =?utf-8?B?eVphR0dDR1dsRkR2akdLc0NOVExudDF0cVhTUDYwWkRPcXRZd3cwbmFiUXlu?=
 =?utf-8?B?Vkx2dHNHVVBSb1NTeWJEZWNxZVNEKzJOZk94V3dINzdkVFNHMkhpVHg2dUV2?=
 =?utf-8?B?bDVObkJUM2xFK1YrMG5Vcnc1VTZQNjEyRWxoeiszSzRaSWxFVUxlR0NsSUJS?=
 =?utf-8?B?czcyaFZ1endOVXd2NU9Ickhua3JPNFkrZ0FObk9JMW5ESllNWmZmc0xnenNF?=
 =?utf-8?B?VVpST3g4a1hVenh1SVppbjZRR250dExPWkNXekZRWVBLai9Xdlo0RGZTTW9G?=
 =?utf-8?B?UEJjbHhYNHIyK0pGWjVmcXhWMmdjMWVwQXcwN0tEL21OeU01Y0tNc3BZdE5I?=
 =?utf-8?B?WmZ2Ni9PaGh2eldXVXdrNlpHbXBDSVdTR2FuQWVIWkRNWmdaaUlKbTV1bFhy?=
 =?utf-8?B?eU9wVXovTkRUbWROSWtPb3hwazVNRDM4L0gxdWgxaHdGMjhpVUlGdzc0WmpY?=
 =?utf-8?B?ampwaEV0Z2YyRS9Uak54Sy9NMTUrbzkvd2ZSVS9MU2xpZ1ZBQmZTbTlncmF2?=
 =?utf-8?B?d1VaOGgyVHAydGhQVHpEZXNNRTd6V2l1WHZWSGVKR1NCaHlNTlEwNy9Cb2hR?=
 =?utf-8?B?ckF4LzE1UDhyZnVGZnJGUHpSQUpwTWJvQ2dEdmdMQ2tuWHcreHZjdTVWWWph?=
 =?utf-8?B?a1FLVm9xSklXVHVCMFJEc3JNTjhQcUlqYkNGVHJyYWJNQ1M1NnlGTXhCUEps?=
 =?utf-8?B?eVNNVGxBTkE5aVZrSGJiUVJoNkJ2aWRURUo1S3RlU2hzZVVhdERiRFFwSjFo?=
 =?utf-8?B?aXB4NlZob3pMNFZDR0YzREVaenRuNnUra1MzaXFBT3pTR2dzSmF3VXN1ZlRu?=
 =?utf-8?B?N3pwM2NOeXpVRlZjL092MkZsdGFrcXBHSGE1Vm90QXNHWVBIV0lsUTV5dVNj?=
 =?utf-8?B?enEwTEVFb2lLcmZtYUR6SWplVGo4a1ZDWFhjVzFCQkQzVHBpT2laNlZKNVhi?=
 =?utf-8?B?di85OCtVL2FHSFpoV2tXVVBQbjJMUmdpdW5hRGtoOUoyeTBqQWNucWxRV0VF?=
 =?utf-8?B?MWZ6SFM1RXE4YTJhSms5ODhqUXdMN0lJWnZ6ZGZRRGhTMENNNVNWM05TMmNU?=
 =?utf-8?B?V3B2THN2VWlwNjJGL210Q2VhUXlTQWNuYitqM01rUHU4Rjk1RFlPcEFHTHlI?=
 =?utf-8?B?KzAxZEFwOTBaVEo0dXZ3cThRNnQ2cHRaQ0hkQk9mMWFWaUJEWXJmQUVDcmhr?=
 =?utf-8?B?MWlzQ2lRSDNkZk5QNENaWFBTQlhueXBUblFQZjVNQ3hYTHQ0UXFRSEtLTjFo?=
 =?utf-8?B?MWtaVlNOUkdWbHJZcE82S3lPLzQwSVRZam5jeFNVdWQ4RHNXck5IZVI2bGN4?=
 =?utf-8?B?QmtnSmZZVFduWjY4M2pVckZtVC9KYlZ6Z1hCNTlrcTZFdDBrQ3AvaUExbkgv?=
 =?utf-8?B?K0ExdXhYRGhDTU9pUmFrSmNicnlqQ0JIaDZ5Y1p5VUFRMnprRnRGdWVNUGpZ?=
 =?utf-8?B?ODhaWXFNTlhBMm5YVFU4ZGtZNFBkbjh3NEZ2aVd4UnV2b2tIMUZaYWkvMmpN?=
 =?utf-8?B?a0k5VTZnUDc4TzFRbmdTTlNBRjh2VHlhNnMrZXBhMFpCV2dZYU51YjJwUm9E?=
 =?utf-8?Q?fcnvE8C1GZsjdfUw=3D?=
X-Exchange-RoutingPolicyChecked: lJqb4Hpz51ClzNFZyX9gNxeO6df9K3EKiiOKyl/3i/97OUayUG0+qRLlSRrW8JFcdrxyB3Q+TL3686B/KOLgfXaZN/klx1qDUcq4Pz1DjgftegfeM03awZJOrwFa810jXg4fpMsPs6jQzFM0wrLDT7LNaOgvWQ+JFspHfXymqBNKWeIxQzY9YnucDn63vylg1W/FRIgKoexKiUBm5oF5QrhVh1tT3UfvgsnG64H2tfQBiZplco7Hpc5AgnusOK/gq5DG/jxuU39mEOoTJIu4+C+EwzZru3RQaYNVdT9pnWB8s7M4hQGw+4tCbFRxCLKEJTAt6wz+djRvAuNp989ijA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b16163-88d3-451e-2307-08de8c576afd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:20:21.9689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0sBkMWyOVlfOubEpwRK0joYLe7u5tTZeqo6Jr76f7BkoNAZkpisNoh16kB2UQljBJMPUk8DFkZktElOECCNGs/N+tkbpttPa9jwlqXhtYJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8711
X-OriginatorOrg: intel.com

Hi Ilpo,

On 3/27/26 10:34 AM, Ilpo Järvinen wrote:
> On Fri, 13 Mar 2026, Reinette Chatre wrote:
> 
>> commit 501cfdba0a40 ("selftests/resctrl: Do not compare performance
> 
> Should start with a capital letter.

Will do.

>>
> 
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 

Thank you very much.

Reinette
