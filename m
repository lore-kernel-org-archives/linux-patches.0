Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298F8DDC5
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 01:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760058884; cv=fail; b=d6nCsMWK8EoL3+tHXulCKpb/N7B1sK5vwoICRUTyA8PBajipoByYQ47izSwiwX2R7LoOkR6ZG0YhsJA+ry0R5kVYnaQUahUo6FHqpZEjzbthncDTCIcz/ksRveOw8X+1XExK2O8uLi9Da0eqnqf39VKWoNRqv4AL4NTXkKHXffs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760058884; c=relaxed/simple;
	bh=sKw4QOXRUw8fm9v4JaeTlbNGOmgwBReOgwlUJGehSAg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pcRB/aaMjWKbL7Q+f4ZiEQa/oxMy7P3djNf7PQ2Bco96d3DhOxA7pz9DGxDEYR/PrS0XbGJCsA5/whEb2BJaNHU+TBZbp54aEp3gManth/p8iBP2tYLKGRboOORP4AZN0duvVcUbjN9f9usja6z22DdEtA2uChc8eGD9QgyMXqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=etZ0K7wM; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="etZ0K7wM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760058882; x=1791594882;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sKw4QOXRUw8fm9v4JaeTlbNGOmgwBReOgwlUJGehSAg=;
  b=etZ0K7wMy1dXgZjkLn/mCGzyWcQZ040cGAFqGEIgyiOxdDJZIARDduoe
   1JD757HHY0LALdiM5Ed/xcDo2hgGKxifh9wshlPADcRcbO9c8tg6mV/rv
   D2Hw4J41Sp+0Y7Xw9YthTgNv+NRdolEL6s2VdgPUQJaThh9gD5jJMH/Xa
   /SkOke1e2gkjyRGC+aDyxhaGCnWacPakgfaFXB8mVoqJuYXAfAY8qGgMJ
   9Ubhln5tiACU3fWtbwSMpKv7rkKZu4kDpQHS9WCVTvORftxJYz9q0+eHw
   b0A+hbH6SDCDzI+eNRnOmCT1CDLg3SrJIij9hVvy8L4WY9DMFEkmpqKHd
   w==;
X-CSE-ConnectionGUID: RW+/lPxZQZq+esNpekgzuw==
X-CSE-MsgGUID: VYEG+rjySnynAX/Jwo6nqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="49841149"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="49841149"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 18:14:41 -0700
X-CSE-ConnectionGUID: cXUBvJEUSNaP38aPuJqzBQ==
X-CSE-MsgGUID: XpgZ+4NLQYypY5KUd8W72w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="185975221"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 18:14:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 18:14:40 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 18:14:40 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.33) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 18:14:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O0urFu3rbwwlS0wf/tVAVqSG5CUx5Vhwy1Wp7W5fPM0kbRpTNEcRdJp44vtlrubzThYuv30KzRSIFJWIaiCUf/Vzb4UChg50yaDQjg2bCmbXshbJShHAdkcXgs6zzMXiNbNHvbFABfiWCy14rQEX8hpGKr/tJy7TGF34htDeNyJ7kqBod/n3fOTQ9QFiQvMUflOlg+7YThPUPTkEqXJCgoCfEXiERumlOyVFPwwqqC/bIKmbD27ILonmtcuZiJr2aA8mfE5Vm0E7py93zGVnFW+xZQgk3ObGAk2LAyNO3IlARH5XN7Mgb9+sXv/QrqU2lk9/9AC/WR14EemX+3C/2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaUvaxhhy32UzB+WhEho8F4sndGslN1QJLPmhawvDSM=;
 b=SXK6jlsnzDPWRs9kLCesrnqwLoyqHz7ZIqUWBlxmGhB25UypBYPrM7qgbxqqYWVQtsT1BYylMvYe+HhAEEckQ0A2UycpxueIcgRZoRMFrotUEEZ/+lysT90AL+4wbllUJNvWiqtL2EqHF/shAPid2LmNkzr9xlRAWSIq3mi1u8YHLW0juGo5T4EuwFCLV04+Wfp6HGxWPXNC1h3Zy1kYj0fuk4Dclj13cl7PRWdz4NNB/bWNIqEEma9fKR/YgmKkCQI+huMaCwTGIcKImPk9I5EKpuWsshSY/eA2/ibgujlfRwp+4qGyDyqd9tc3rIKG1Pa03vkmtwkSt/4F3u1rZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB7512.namprd11.prod.outlook.com (2603:10b6:806:345::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 01:14:37 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Fri, 10 Oct 2025
 01:14:37 +0000
Date: Thu, 9 Oct 2025 18:14:36 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
Message-ID: <aOhd_A5L8PV0OYba@agluck-desk3>
References: <aObUZU8rnWIDR_tH@agluck-desk3>
 <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
 <DS7PR11MB6077A0323678A68DF5878C0CFCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
 <e536ea0b-c466-4381-b92b-993be92fe65e@intel.com>
 <aOf0yA1AWlzJLf8H@agluck-desk3>
 <6778a8af-5312-419e-a064-bcb6a495a207@intel.com>
 <SJ1PR11MB608328747C28F736C6DD5FCFFCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <1ea9cff4-e93d-4be8-bbe2-308fc05eb3d1@intel.com>
 <SJ1PR11MB608302F7FFA34D93EBD77640FCEEA@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <21cd6535-a51c-4a8a-9e82-328b03a8fc40@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <21cd6535-a51c-4a8a-9e82-328b03a8fc40@intel.com>
X-ClientProxiedBy: SJ0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::30) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SN7PR11MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bdeda4b-78f2-429f-25bd-08de079a6189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LtHIkfRt5ONscagZNs/GKwZMOHxlvSnLztVDrRr8T9NPK7D8uyySTzfVTVFf?=
 =?us-ascii?Q?viT1uqZqxMLRM4EUSKtkKIp1R6iTYNGwa9Y+Nx96oCGCNbnKBkq+W9PobKdw?=
 =?us-ascii?Q?wHhAByQEVhanVpuKQrDnnWroHYbwLKKDlgLgeSEWFKxjYApJda1YVB6srBUy?=
 =?us-ascii?Q?3WS2h8DbW3vhyiReS1Fu1SNuYZUkqzVHPey/mEFEUdRXMIumghRXP8eY6K4k?=
 =?us-ascii?Q?QZ35cCwr02rdLOpbssJgeO/VnAZ2Z4SyC6xhVBzBv9/eDyawF042i4Gq5DJp?=
 =?us-ascii?Q?qFz3LMj03dcgSWwimnrWtio8Xei/zRB+my0Am2hP7JVI3og3wucxLPwLWLf0?=
 =?us-ascii?Q?R2qLB8VGPro6WGJxxguET2OgPSTQQX7YgAt3e+DTjw0TQKGpRPb0Thgny7EI?=
 =?us-ascii?Q?ViPrL8pQSyk4I4m48HT8srbJEi3Batt+FFChdFiQD6adBbTyDdGoGeZkIXaL?=
 =?us-ascii?Q?TnrbmFTbGZ8wLLrO3EXKBDKaUtjdjqULJPd6hvffuU3qaV2Z88DqM3U152/o?=
 =?us-ascii?Q?SqzBP6F64exUAAN6gi8u1T0SYhaLNJUVO+mqe6S1aefLgNWh2RLICTPBcsu+?=
 =?us-ascii?Q?rkud2S/wIvoawtN2c9x0sBHj3XDjYfic9PC43Y3Yd32Jf9UvrXsNXOuEdbre?=
 =?us-ascii?Q?MsUGpsPTj8O7dE4hjIOMe5tBG1mAhUJKYKKdegZL/0thfXd+iw5XKfv7eBSk?=
 =?us-ascii?Q?J6YFTlF307ecjkaSOQdYjwLqrL41qDQRAB+QSaIFPrfgb1QpNj04/KZKIpbz?=
 =?us-ascii?Q?lEUIjoFqONP+gJl2US/Uh5atsmKPSuCaq0tg956zIKufprKTchIPGkyvI7ex?=
 =?us-ascii?Q?xPPtoQfM2szBghpUf3fXtmT/OQwott1G1DiVniQjw9hHOr3Fd7jX4BVp6AG2?=
 =?us-ascii?Q?dj+kEoG3dnhu0ok5hQ4YIr6e3YFPmHdFXADldWVy7CwJ+G7izRuYPNlHUzxD?=
 =?us-ascii?Q?rh5ugRBOPWOOHlSdDU2P7db2fD8z/+goijtULSwUew25LjbP+5Gi3ExO/SVk?=
 =?us-ascii?Q?wq+UWlOBULv0EsW+1K4RVpeH8Wl/Eu0Iiz5cRfyXvQk95g9smRmaAepWXn6s?=
 =?us-ascii?Q?LxrN0pl7OoIrYRKpB3mwXuQojAS86dG9VPu6GjL4HEM2Ati/vJ6cummZik17?=
 =?us-ascii?Q?0+yphw7PkfQmTtQ7cq5by4TTrOvDf6EYgmmLzEea7onXwEQDd5Hob91PSDaY?=
 =?us-ascii?Q?DW29s0NYu97pLh2giQgKWLOrYQgbWXiT8aOr6XWfzbzmishBc414Te4dniH6?=
 =?us-ascii?Q?yHATX2sJKjkYh1bUMaPfKTRKhzHjDQ5IAo/1ZeRCYcETJXm1MTRTIMAF1T3d?=
 =?us-ascii?Q?YeVqwSRMZ0KoAv2hVCY3l8si1SXCP6zPV6U+GBpQWCCJM1tPXtn2Mh37OaOW?=
 =?us-ascii?Q?rlaLCnWF3BX0qV2xsAgS8nQU17N8BhnCvw6c048w3zFTSHq6WOMeyWz6RkLC?=
 =?us-ascii?Q?haranVyBhfCJNX02lvM74JWiEKYISXqD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w1BuVC3BjCZ89va7+NV1igNLlP/vZM18cxqp5WrMarEtekdPzIGnwryJ0z2l?=
 =?us-ascii?Q?pZNQHmJ95kffYJQuughiJdzPTdbdpD4dXTw8aZEmSH7/lqgZsb6eRtfGHsog?=
 =?us-ascii?Q?nBYwlulYW6YTR/84+Qa342ymBYV4K+/GmuYv9yg1t+pNhfG8ZMfhnhjMpCSb?=
 =?us-ascii?Q?N/8EDbmgUFI15yYPHlJke0G8PPUPr3FHtEkaNzLvrYM3c0N5tgdW58hw08mx?=
 =?us-ascii?Q?/sFJe6U6LFfG9p+tPbig/TRLwdqG6mzkcdp9zU7IWSuU6l3Fnp2oJbd7BHWV?=
 =?us-ascii?Q?KssjWGbPaahHf+eRIiqErUixbdNKuNloq/JZlfZw6H+LUZK0CJxnU0+e9NCX?=
 =?us-ascii?Q?ibDTX2K5U0FQqY7JI8BfZ4hnmo8XmFfIUvPsDKWFk6Yaw3zJJamF860f1wkP?=
 =?us-ascii?Q?mvOH10fcKrk/Xvli+wjYXqqhtzPdHvI0cgZM849BYahs3VfQS7aNWC7b7oUI?=
 =?us-ascii?Q?gnhzUfOV3bBmyww0JZA+nZe8vquRI6I/qNbqPzLHrRkwQvRcOsnmL544cvyc?=
 =?us-ascii?Q?GUy0YaTkC2GrDO3g1eLEQzmJeNOO+EGuTBSPVe6EA4kT1eEznLnlS0jqYVI+?=
 =?us-ascii?Q?LvvpxqLiVSZpt96n9oX2q/QQ4cT5vb4E+dygIWKph8axRHxQmDEn8SK7RuTy?=
 =?us-ascii?Q?ln7F8ggUqi8FWc31TFXL1+sZc2dU4forJGVuzra5RL4uJqshcAlPIhL7abRx?=
 =?us-ascii?Q?typPry2r2V8gE95YKaGpWOG/MzzLR5zr3Ly59nfIYuTJxPvUsSgtvm1+oUA9?=
 =?us-ascii?Q?ECqoQi6ENIJg3KyHlC+gE94CylNS3FAgIWyKFXbK3m6FVy4algGyE8IBNF4+?=
 =?us-ascii?Q?a0d82to6h+P4j7S9wSDRF4qJegzKzWhjtvDYXZn7GPUnQM0KbblVbjd8iJ5+?=
 =?us-ascii?Q?a3CRgsHhpiVUlUuruWXjG8j+TAMQTk8Z/4zSizPr9luapr0irhUZfTk6Jlna?=
 =?us-ascii?Q?Iaiel+IbQqJ0gdQD/xVwCshHtAhKpDOiuiXnQmLEeMeH4GjlpxgITtFu/CMI?=
 =?us-ascii?Q?K+tKI31kv3HdBm7r/4Jj2Jd7iSd2LxJPiul8zilINCEWxPMez2D/Wxl5NvZS?=
 =?us-ascii?Q?S4mCYmhau6A43ZKDITmDE+sC3FUYOdyoVay5bciHMZoHORHrLt/F0QLTc5ZI?=
 =?us-ascii?Q?1lDApeYj9jw2PtunJI+EKVSsdEnDaDydbUTEMO2YwmrJK67bmV44k26G4e6J?=
 =?us-ascii?Q?0vwYBoQhKO2AqZTjZcFhne1AAekNwoQ+p4mTSUX+pR3/PerJm3CqbchHZeh5?=
 =?us-ascii?Q?D2IC3Ki47iLDk3jLjJZtWGOD4fqG3kpfPnK5CA10caYjVkXulyGPo5j9eD2Y?=
 =?us-ascii?Q?wCP1BrlpYINFwqyhHLeIHs11onUSaturDr5FfrJNh3mrnCYLrZp/IQUlnsLj?=
 =?us-ascii?Q?DSWFl4+r7CwlOIY5q7NVee/HlhHgE2PxgXMvA9Jh7YpWFS6yePvH0kFoIsX9?=
 =?us-ascii?Q?AzAVdLJjTf6HnEyzp+e2UiAoDxVKwHpQwKliVqS4zWIFUmI3yyKdmF6aGwbN?=
 =?us-ascii?Q?RNWFTNRhYG4bTECl4mIX8kVP2dop2CIhcPnv/LqPUFkFgwvg9sAgpKqjxFU6?=
 =?us-ascii?Q?r1ts7plLBzWaiW4wyJI/VsZNQGSQSYyxxD88av4D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bdeda4b-78f2-429f-25bd-08de079a6189
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 01:14:37.7675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VLezEYoYL1rGWdXvDziq8I0LIZDUkZBl+DcCm9feJrNIdw3Wul+3NfWwLP+jDtFkqLP3EzPPJsAK4Uhs5V2MnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7512
X-OriginatorOrg: intel.com

On Thu, Oct 09, 2025 at 05:16:00PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 10/9/25 3:08 PM, Luck, Tony wrote:
> >> I did not mean to imply that this can be supported without refactoring. It does
> >> seem as though you agree that mon_data::sum may be used for something
> >> other than SNC and thus that using mon_data::sum as a check for SNC is not ideal.
> > 
> > Reinette,
> > 
> > Yes, we are in agreement about non-SNC future usage.
> > 
> > Is it sufficient that I plant some WARN_ON_ONCE() in places where the
> > code assumes that mon_data::sum is only used by RDT_RESOURCE_L3
> > or for SNC?
> 
> From what I understand this series does this already? I think this only applies to
> rdtgroup_mondata_show() that does below ("L3 specific" comments added by me just for this example)
> in this series:
> 
> 	rdtgroup_mondata_show() 
> 	{
> 		...
> 		if (md->sum) {
> 			struct rdt_l3_mon_domain *d;
> 
> 			if (WARN_ON_ONCE(resid != RDT_RESOURCE_L3)) {

Exactly what I now have.
> 				...
My "..." is:
				return -EINVAL;
> 			}
> 
> 			list_for_each_entry(d, &r->mon_domains, hdr.list) {
> 				if (d->ci_id == domid) { /* L3 specific field */
> 					...
> 					/* L3 specific */
> 					ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
> 				}
> 			}
> 		...
> 	}
> 
> This seems reasonable since the flow is different from the typical "check resource"
> followed by a domain_header_is_valid() that a refactor to support another resource
> would probably do as you state below.

I looked around to see if there were any other places that needed this,
but they all have checks for RDT_RESOURCE_L3 by the end of the series.
I've added a check in __mon_event_count() in patch 13 that gets deleted
in patch 18 when the L3 code is split out into a separate function.

> > 
> > Such code can be fixed by future patches that want to use mon_data::sum
> > for other things.
> 
> This discussion digressed a bit. The discussion started with a request to add a check
> for the L3 resource before calling rmdir_mondata_subdir_allrdtgrp_snc(). 
> I see this as something like:
> 	if (r->rid == RDT_RESOURCE_L3 && r->mon_scope == RESCTRL_L3_NODE) {

I'll add this. Same is needed in mkdir_mondata_subdir().

> 		rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
> 		...
> 	}
> 
> I understand that rmdir_mondata_subdir_allrdtgrp_snc() may look something like below
> but I still find the flow easier to follow if a resource check is done before calling
> rmdir_mondata_subdir_allrdtgrp_snc().
> 
> 	rmdir_mondata_subdir_allrdtgrp_snc(r, hdr)
> 	{
> 		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
>                 return -EINVAL;
> 
> 	        d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> 		...
> 
> 	}
> 
> Reinette

-Tony
