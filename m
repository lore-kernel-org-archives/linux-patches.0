Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A456033BBA7
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780961163; cv=fail; b=YOXQ14BrhqENe5b3KwUq+UQ6z5PHSWL8uD+XDBi7TnEMNXFYCqD8VuUvFFQcip1N14/i9RXHSGaP7ZgxndjXq+MLtjs9JydzRuqF++ZGFV78ASfHKNFqDMRuD2TJozFlKJhucJVI5kjVnprqUk3/Oqxs/9MxwU1rmh5Ea7X2/Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780961163; c=relaxed/simple;
	bh=0VRl8qysc8y35WnU1kEtzr2RFz2iP4yZSV7SJhjZvBU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g2qrjpMBlrNbbSbs5wMtx0a6H15uN5ku63Z3uHhjRNM+8lwtsUQaudUY/1N/TRfP8stqlJQpSK221nquzSXErZ6EemghNMLrdT0hYAXS5VMX4eKfXgfiylJPgblyHzAryy18JwInl2/vCiL4yLR2QO1p7sgseGak+T3DPyX0+OI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U+uBLBRP; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U+uBLBRP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780961162; x=1812497162;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0VRl8qysc8y35WnU1kEtzr2RFz2iP4yZSV7SJhjZvBU=;
  b=U+uBLBRP85BPGknfATmfP58wUFVDrqzb2lARcWsE1jd8NEhnRSZo7TGB
   6OwHGQjQ6ew5Nvv9XAE9Rfp2RGisQH6/7/kzMAgDDUvFQiX2BnECQTM0/
   Beu4XZt4aLAbr36EC1zjPoe2wkjiGf9t8g2eEMt2ThCP9ddWb7NmwUPHw
   mYRErzO8FXIqugHdYAlZJ/jGEr+fddojI1SuP6TSMyntHKJ82JWoMWUug
   P401Oe5M/BPoixY4lpL18igGrerg0b7TTglpUmbAAiQ2V/cfmHghSC8Yr
   rIxbmJNz1KUV/lzXgikdOAQ1WOGJ6TKurhJBHGIHM3W4HIzf9MuCaVw7u
   A==;
X-CSE-ConnectionGUID: Ur/lCpKUQLm9vpDn5kRGSw==
X-CSE-MsgGUID: SUu/ADHmSxSphpbNW1N30w==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="81712412"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="81712412"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:26:01 -0700
X-CSE-ConnectionGUID: Gc0OF9lIR/Ge7rR46vCmaw==
X-CSE-MsgGUID: prx7hk5jSbSku6QnM5gVgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="245545911"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:26:01 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:26:00 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:26:00 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:26:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EOUXswHqh5abvPtDfuvgaz8OZqDIpHNv31QAbcundM3Mo0oUavWvgJomBsdQERD+c6dGcKXSOsNDf3oK6hIEsisHA01PBrTiqNSJ60QWadf+LUsaMeHSCing0EbR/r4+0pqbKXx1HkAehURWrFm1BJ/21W1S2G1rh5q2in/B8OafH64Lto0WbiGrZiKux9sGWeKGlteBZNxdtrWnSgL1zV56NTxlVzFy5vdBVDL3J5C4H5WT8GdZ8vTMJcizAPL9BrfjcfxuDmnYsO6l46fDCXX4BQ0Xsi6aHpKFV3+oTGA5SAiHb886py2dTN9jfHrRnL5myq8vG2Q4n3Wwoa++bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIK5HpCo1waduliIhMg78gceZ3iQMZAw3+L9s4qhkW0=;
 b=Vpx8FCyRcFL0brqNMVPzYMmScNC1f5upKRgSmsEc9b8qlOCJPeEjkFf3bKk2Bj322xkaComOhQfjUz9W2iGZaaKHHPJzwFDfsTSpdYKfI/1iGvrInieXv9UM7e9SlTwJ0A6hZmTenUwHHGnJA3/3b/Yrl0LKW9c0GGZQw1rDvvzQrFOm87wzplgVkIkwicvHiEzMp3kVhQij/puXFE19+/snV0MyG9sFZ/rvpSkIFvhYQSBOcLl0OYwPRYGtNeV76Agp/3OCyC+gcDFYqdOgNUeD48CSMWZlYK0BceBXYAoFbNcaTvNL7CeyPGqV2G9KRuIXQzZ7K0JSbPxodykN8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB7581.namprd11.prod.outlook.com (2603:10b6:806:31b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 23:25:53 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:25:53 +0000
Message-ID: <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
Date: Mon, 8 Jun 2026 16:25:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0165.namprd04.prod.outlook.com
 (2603:10b6:303:85::20) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB7581:EE_
X-MS-Office365-Filtering-Correlation-Id: 468472ce-889d-458d-e5fc-08dec5b54894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|5023799004|11063799006|4143699003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: yZSq4iLetc8FZe19fUkzD/Od1C5TkbpPAoGi3rzY5CfTVw8zKACGyMLNpbGHCEes5MoAzdHDdtBNBCF4nP4yAphrTmka+EjRBcKoY6BI+s/F7uhdQcn/GRK4oL+II2cXZbXQnFw5HAi95wkkXE8yCAFVkHdNTQmpxU8V1etc18Knc2CgiHikx9vhjar1vrNqEz9HkH4rnrn8b8RHp7UxcAZJpFSVoLebXZ8oST0/VcnUDt4JfMtoO01TxJzgp7DpZnw2I7pgMvzF3MTajT7HQxWH0NaM85ZzXmLQoAIdoGJRMOkhks3ax2YyyDnwuZebW5faEbtStAlBVDAsCgXNdUeO5myuNxMLtnYeirr/+2NBbhYBMSza7N4f/uHt7tLfOzUlNMytFMmJAR6ScDRCY++HGuvcHHHeqFhTt/BV2f2j9DfIEdGVwvDD7jVPZ7XHsMWHsq+0XKjMstATRctKmjV+z3q2y/KBJ9FbVrGzCq2WLZWt1X6Iy0inrxMcyhuEv/30eZNDVFHlKmT9WRbS1mRMjINUSgy17Z+Eg/N54Wse619TWnV2s+oLZrKSstGC8fbHy4hZdG1uNL0hWPen+eOJ+Af+KlPMqqxv+lTESRu0cROYFUY2Bxy2uDvvoXVqHdXtl8oayT5IZkEpa6gsmODINCa60abSf+fVWpI7z5OjI56kKO6Gc7RTXP0wIXzL9KnFzGO1o6JEHNrCmfQLZxsDW08MppyJAZ8zGJlVeKA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(5023799004)(11063799006)(4143699003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWdxZmFsNVhHM3pTcmhPQ2ttR0dqK3VmOFh3WkFvdmQrV1ZnNTRGNC96QWho?=
 =?utf-8?B?U0RsM2tFZ01EWVlSdUFaelVGa3I3dm9vTUZpZEpaYi9zcmZYeEh1VElyVm0r?=
 =?utf-8?B?bThFbHc5SnNRNzJUUE50MXI3NW0yMEQ3MFcyNFBlVGtWb29VY1VmZmZaek9p?=
 =?utf-8?B?cFFHQzZTR01GekVhQTVjMHFTaGdPOEFCb0o4L3k3YmlKdEFocGZFNmordU9G?=
 =?utf-8?B?b1ZBYWFyTzdXWXFXaFhrdXc4dkowMU01dEhQWnRVNEtlU3pBK0NhREQ4SnQ4?=
 =?utf-8?B?TG9mYmFiMWhZUkNsT2JZdWR4S21FV202QzlGd1RlcW5URlBhS1Q3VHRubkZI?=
 =?utf-8?B?QzZnajFFTGkrRE5KQXNxRDhwVkZ1dUdoY1RYU0JmM1lLcVVBcVhqYWVuRERw?=
 =?utf-8?B?NEtIaTBqV0hhR3ZuYXpzYkxyaTRDQ0JlM1BVWVNQVnpVWmpXbVpxMFRFRC9O?=
 =?utf-8?B?dzN5aDg4TDcrRGFBMXdwclQvRWI2MWF5WXRTb3U3M2NCMXdSYTRUZDVWZEcw?=
 =?utf-8?B?UjRLRDBHZzZjYStHc2VQSjZhaThldGl4UXY5VlplazdiSEEwcFdQWUNhQjBv?=
 =?utf-8?B?bjFGQjczZjQxendENXRvM2s4UXIwNndQZTVGRVJSNXp4Wkc3ZXpncnBRTzNs?=
 =?utf-8?B?WnViTGI5NWFVMmRQK2puR1ZEdjZpdEI2Vm1zRzllczZsWkR1TkZMTlplbXNT?=
 =?utf-8?B?Q1NjWFpTZkVHRDY3MTN4ZXVhc3BWVlp0aXBjVmJidHZ6MWoxNWluVXZIUzNH?=
 =?utf-8?B?VW4zS2l2cEpQRWVDSFhvYjdCT0xweWc2ZnFhMndJMVFXbldhQ3RhUjhkalZk?=
 =?utf-8?B?WHhndThLNFVPZVlwR2Z3eXRlRUhDaFJMQkg5ZHpPVjZtalVnMXoxbnlONXdn?=
 =?utf-8?B?YmxRMktpaTBTTWUybWtYeWQxSTBOU21CN1FKQW0yS1dqM010eXU3VVJGcWFI?=
 =?utf-8?B?UVRGeENJbnhYMjJubFZhTkc0Z0luVHlDNUJzeDZUSGJZMnJuNUpDZis3Vmxh?=
 =?utf-8?B?SU1iV3lZY0R2azZ3UUxtL1Z5b3pTejV2V1lPRzhndEliWG1PM29yTEJVRGJa?=
 =?utf-8?B?bExGaGc5NVVXUDJJQ3pEQnQ5ZWpuVHIreThiU2NrdnRqaEVEaVlLelpGTzFL?=
 =?utf-8?B?NkNkUHQwbG1aUU5PN1hUL0g5S21DL1ZjbkUwTjRSUXNNcmh6U3Zpb1hTMTAy?=
 =?utf-8?B?T1U3akQyQUVPOEhIcTNOazhBb3FXN0ZCSThwaG9PbEovdEJzdWVPNEJRUEdV?=
 =?utf-8?B?NzgrbkxKNS94c0lYS1pMK0IvNW5PcFk1TlhUZSs4QTlOWEdmeE1seUZzVlZX?=
 =?utf-8?B?NjBpWlhFWmJldkFpSW80NUcwM25tVXl1TUpnZHZtR2g2SDZEeEMraGNDR055?=
 =?utf-8?B?VkU2NnY0cnIxY0hwNWFzQ1RnSWJSRVVtQ3VPUmRGTkRFVTJML3Z4NWtQcWRF?=
 =?utf-8?B?YUFRRkJzN2NQZGhDM3JqcU0ya01reVh3NER0c2VZOVQ4VS9nNW5zTDhVSTBl?=
 =?utf-8?B?REcvek50aG00TU1YZXlCWTZVV0J1MkRHV3pzNklHK1B2SEdtaFBYRkJCY1NP?=
 =?utf-8?B?Yi9RNmZHYWlXZlEzY2E3SmhKSW55Tk1LaHU1Z0lzMjlpenNuUXVmdG1GK0dV?=
 =?utf-8?B?S2VwYmhBWTRQS3ZVMW5aajBHcWFOUGk2a2JvOXFmc0YwNFMxbFNROWR3d1dD?=
 =?utf-8?B?ZmdlL1dvb1JZdmdDMjJxTUVjRE54MkwxM2NvcW9KM3NkTUY0TGloYnE2WEJG?=
 =?utf-8?B?ZWpLUzgxaG4waHExSWkvYUVTQkFsTHBKK2JZbTF6SHM3QTVEbW5MWXNvalRJ?=
 =?utf-8?B?bXhGTEZKeElIMlZJWktZdnFQUzBlUEFRcGgxallSMVpvTUowL1JZZDZkdllr?=
 =?utf-8?B?SGZ2NnJFUXRkdHByZ1JqbW5NVXRHKy9wVTJFZm9IRXU3WUcvY0hUMFBIVmhD?=
 =?utf-8?B?VENHdVFnZ2VCK0RDRk1WUTNWbFNMUDJJWnY4NDkxYmlzb1Nud0pJMlNTY0JP?=
 =?utf-8?B?UEZ6ODVWU3ZKSVpvaGtEcDJPRVYwa0VGQUZSOXJEZ3BKRVlwc0hMMXpsdmtK?=
 =?utf-8?B?V29waUVjYjV0RUNmQlp2SFdwWkIvNGFpQmw2ckpzMEdQblRjYUJ4bTB6bFhB?=
 =?utf-8?B?ZGxidjVzUEZFTTFsREV0NU9Mc2xkS3lvU1YvTDJBdG9LczZsUldtRkpHbkZm?=
 =?utf-8?B?KzQzRnFMdThnbmdISE5TK3F5bEo5c0tmajJCRWhsWWRyWkxaM3owSE9DTzhE?=
 =?utf-8?B?MHBUS3FxOWNqQWlPZE5SQzIzUlYyemhENHRDQ2x6UW5RbXozUEJIQ21ZMVFz?=
 =?utf-8?B?bGVhUFdnV3lQTUdvK2VXWThxei9jdzZoRXlRd1cweEJjeDMzSXBlaC9DL2xM?=
 =?utf-8?Q?GHzFe2up1FYiNpug=3D?=
X-Exchange-RoutingPolicyChecked: PUikzhudqJqykWmBy2WxmKKnAyNspU24DXMVjE/dXE+TrkgF5j5yTFo9vJ38o9Kyl4uQxeAfjWrOEvqm3C1wiWUTbr2wA7cxg9abAZQzLXcCcaI2ctRMVUXyYPCiw21+liLLWc0ilAccJqFQBfsDNk34w9wXaLke8gx5iPdYOr3nx2NH/2dEbMbVN6Ch63DtdYqtNkZkPvJjxnjOBLvDVO9wTvF9rtZHpUmo1+MhkeJPgkBCRqPjBPuDcA1xnSMBifxCfKO7rUsr4S1DgBEgkRCcQ3Fwy7ug2u7lavAMqoto5+FXVYkA5sYSDWKF20JEE+Rba1yb2X6EXwML0+07rg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 468472ce-889d-458d-e5fc-08dec5b54894
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:25:53.1878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1GpSLf+HEDU6Ff43Q66k0H+I/B1NielHOcpnPFkbqXOs0AtKELGox1sqG4PlfA78ST7P+B9RnEnfYhheQl0r90RKpSLYomK5WAIqLO5QLXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7581
X-OriginatorOrg: intel.com

Hi Tony,

Regarding a subject prefix ... We do not yet have a precedent for prefix
when MPAM, x86 and fs is changed so this series may indeed have the
opportunity to set that precedent. When doing so, please be consistent.

On 6/1/26 12:56 PM, Tony Luck wrote:
> resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
> logically independent and should be loadable modules.  Switch AET to use
> the function-pointer registration API (introduced in the preceding patch)

Please drop "(introduced in the preceding patch)" since patches may not
always keep this series's order once merged.

> instead of direct link-time references to PMT symbols.
> 
> Prepare for the file system to call resctrl_arch_pre_mount() on every mount
> by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
> resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
> the filesystem is not mounted.
> 
> Remove intel_aet_exit because all cleanup now happens in the unmount path.
> 
> Note that the Linux file system code does not serialize calls to
> fs_context_operations::get_tree(), so there may be arbitrarily many
> parallel calls if users invoke mount(2) multiple times.
> 
> Add locking and state (resctrl_arch_mount_entries) to avoid repeated
> enumeration on nested mount requests from file system code (which will be
> failed with -EBUSY status).
> 
> event_group::num_rmid may be reset (reduced) during enumeration. This is
> not worth resetting on unmount because the same reduction would occur on
> each subsequent mount.

Even more important to ensure that PMT is done with its enumeration when
AET enumeration starts?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  3 ++
>  arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++--
>  arch/x86/kernel/cpu/resctrl/core.c      | 41 +++++++++++++++++--
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 52 ++++++++++++++++++++++---
>  drivers/resctrl/mpam_resctrl.c          |  4 ++
>  5 files changed, 95 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 3705f0214fa6..9534d42e0c57 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -557,6 +557,9 @@ void resctrl_offline_cpu(unsigned int cpu);
>   */
>  void resctrl_arch_pre_mount(void);
>  
> +/* Called to report unmount. */
> +void resctrl_arch_unmount(void);
> +
>  /**
>   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>   *			      for this resource and domain.
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 3b09cfe9a046..017a19143ec9 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>  
>  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> -bool intel_aet_get_events(void);
> -void __exit intel_aet_exit(void);
> +bool intel_aet_pre_mount(void);
> +void intel_aet_unmount(void);
>  int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  				struct list_head *add_pos);
>  bool intel_handle_aet_option(bool force_off, char *tok);
>  #else
> -static inline bool intel_aet_get_events(void) { return false; }
> -static inline void __exit intel_aet_exit(void) { }
> +static inline bool intel_aet_pre_mount(void) { return false; }
> +static inline void intel_aet_unmount(void) { }
>  static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
>  {
>  	return -EINVAL;
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 934492c7e643..9336299b9647 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -16,10 +16,12 @@
>  
>  #define pr_fmt(fmt)	"resctrl: " fmt
>  
> +#include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/cpuhotplug.h>
> +#include <linux/mutex.h>
>  
>  #include <asm/cpu_device_id.h>
>  #include <asm/msr.h>
> @@ -776,12 +778,20 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> +static DEFINE_MUTEX(resctrl_arch_mount_lock);

Please document what this mutex protects.

> +static int resctrl_arch_mount_entries;
> +
>  void resctrl_arch_pre_mount(void)
>  {
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int cpu;
>  
> -	if (!intel_aet_get_events())
> +	guard(mutex)(&resctrl_arch_mount_lock);
> +
> +	if (++resctrl_arch_mount_entries > 1)
> +		return;
> +
> +	if (!intel_aet_pre_mount())
>  		return;
>  
>  	/*
> @@ -798,6 +808,33 @@ void resctrl_arch_pre_mount(void)
>  	cpus_read_unlock();
>  }
>  
> +void resctrl_arch_unmount(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	int cpu;
> +
> +	guard(mutex)(&resctrl_arch_mount_lock);
> +
> +	if (--resctrl_arch_mount_entries > 0)
> +		return;
> +
> +	WARN_ON(resctrl_arch_mount_entries < 0);
> +
> +	intel_aet_unmount();
> +
> +	if (!r->mon_capable)
> +		return;
> +
> +	cpus_read_lock();
> +	mutex_lock(&domain_list_lock);
> +	for_each_online_cpu(cpu)
> +		domain_remove_cpu_mon(cpu, r);
> +	r->mon_capable = false;
> +	rdt_mon_feature_count--;
> +	mutex_unlock(&domain_list_lock);
> +	cpus_read_unlock();
> +}
> +
>  enum {
>  	RDT_FLAG_CMT,
>  	RDT_FLAG_MBM_TOTAL,
> @@ -1174,8 +1211,6 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> -	intel_aet_exit();
> -
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index db671725acbb..74c34593876b 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -25,8 +25,8 @@
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
>  #include <linux/minmax.h>
> -#include <linux/mutex.h>
>  #include <linux/module.h>
> +#include <linux/mutex.h>
>  #include <linux/printk.h>
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>
> @@ -308,7 +308,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
>   * struct pmt_feature_group to indicate that its events are successfully
>   * enabled.
>   */
> -bool intel_aet_get_events(void)
> +static bool aet_get_events(void)
>  {
>  	struct pmt_feature_group *p;
>  	enum pmt_feature_id pfid;
> @@ -317,14 +317,14 @@ bool intel_aet_get_events(void)
>  
>  	for_each_event_group(peg) {
>  		pfid = lookup_pfid((*peg)->pfname);
> -		p = intel_pmt_get_regions_by_feature(pfid);
> +		p = get_feature(pfid);
>  		if (IS_ERR_OR_NULL(p))
>  			continue;
>  		if (enable_events(*peg, p)) {
>  			(*peg)->pfg = p;
>  			ret = true;
>  		} else {
> -			intel_pmt_put_feature_group(p);
> +			put_feature(p);
>  		}
>  	}
>  
> @@ -353,16 +353,56 @@ void intel_aet_unregister_enumeration(void)
>  }
>  EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
>  
> -void __exit intel_aet_exit(void)
> +/*
> + * The pmt_telemetry module may not be loaded when the resctrl file system

Is this accurate? What prevents pmt_telemetry module from being loaded when
resctrl file system is mounted?

> + * is mounted. Keep track of whether a hold was placed on the module to know
> + * whether to release it during unmount.
> + */
> +static bool have_pmt_hold;
> +
> +bool intel_aet_pre_mount(void)
> +{
> +	bool ret;
> +
> +	guard(mutex)(&aet_register_lock);
> +	if (!get_feature || !put_feature)
> +		return false;
> +
> +	if (pmt_module) {
> +		if (!try_module_get(pmt_module))
> +			return false;
> +		have_pmt_hold = true;
> +	}
> +
> +	ret = aet_get_events();
> +
> +	if (!ret && pmt_module && have_pmt_hold) {
> +		module_put(pmt_module);
> +		have_pmt_hold = false;
> +	}
> +
> +	return ret;
> +}
> +
> +void intel_aet_unmount(void)
>  {
>  	struct event_group **peg;
>  
> +	guard(mutex)(&aet_register_lock);

Could this get a short-circuit to make behavior on AMD obvious?

>  	for_each_event_group(peg) {
>  		if ((*peg)->pfg) {
> -			intel_pmt_put_feature_group((*peg)->pfg);
> +			struct event_group *e = *peg;
> +
> +			for (int j = 0; j < e->num_events; j++)
> +				resctrl_disable_mon_event(e->evts[j].id);
> +			put_feature((*peg)->pfg);
>  			(*peg)->pfg = NULL;
>  		}
>  	}
> +	if (have_pmt_hold && pmt_module) {
> +		module_put(pmt_module);
> +		have_pmt_hold = false;
> +	}
>  }
>  
>  #define DATA_VALID	BIT_ULL(63)
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 7079870ca894..5859cc0f5e37 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -162,6 +162,10 @@ void resctrl_arch_pre_mount(void)
>  {
>  }
>  
> +void resctrl_arch_unmount(void)
> +{
> +}
> +
>  bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
>  {
>  	return mpam_resctrl_controls[rid].cdp_enabled;

Reinette
