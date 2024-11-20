Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3CD28EC
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 03:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732074858; cv=fail; b=pCTwcsJg/gNmUaGE0d+f5OYVyiWCwMEWsB5qV37/t0+SPzXMnqHKsQNW4UmqeY94idxQR/+UgtYVmKmrouclAb1WVR06hX4mEEZCZfMSP3PuTZf8WH41Q0krNI0TVlWCh2GZ4Yaw1VMW9QSweOt9L6FcEWcF4hRnQVLtMR3pBDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732074858; c=relaxed/simple;
	bh=+vbdlhgAsdMiGMpH8V0DHxpPSomTlKaoq7sslUxWlxI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F46ZY1jsRMbTdAiLamfROEPrnMp9baO5e3/IVwCT/ncxrDGhua1FqvPKBRMLWYcRbIaEF7MLDv82i73/cxReAmlDEIio37D40RHkQIXnAggGJOkrKgCb3KT243/QXQba371ZjBXnbrjyPzc7IGorRMvp866pWZ9+T62Kqm8hqdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=klMNpq6h; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="klMNpq6h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732074857; x=1763610857;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+vbdlhgAsdMiGMpH8V0DHxpPSomTlKaoq7sslUxWlxI=;
  b=klMNpq6huuD1HcbqDTB6o1tbEOgUy5F+GSeItxVeDQGO+9GTRvlWCJFS
   3O+tzX0oLbvA17l2GslPm7Gogg8y3BTwiJjGW39jEcDwuYRRdDZXDmjBJ
   JFUzA8abAgOnf53/kZ2BVvRXA3kc4jGVxpR6xGyu7n7e+grc0s/yY8oPC
   W9fwRqoi+R7mejb7CsaJHzL+P2MaOnmryMVPqKNxpwNrcnKiBwF6PLIrS
   c8idpCOdsfSNIlf9KJ3jO2O7V0ui/lo25lLzcCZ7GmyRvRHuGLLDwNW5z
   21WekfNVQUqfOh93nfFRvrsXBQocdSbLUyuva196cTNJMCLDRq9/XWeMG
   w==;
X-CSE-ConnectionGUID: MVEKmYi+QnO6zvVJ6MSGNg==
X-CSE-MsgGUID: 9KoH9VqvShGn8B8DfU4oxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32047499"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="32047499"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 19:54:16 -0800
X-CSE-ConnectionGUID: Dxm1/LNjShOT3OPZrB06bQ==
X-CSE-MsgGUID: EE+XefSySje+mqmXWymuyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="93839878"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Nov 2024 19:54:15 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 19 Nov 2024 19:54:15 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 19 Nov 2024 19:54:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 19 Nov 2024 19:54:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a5OiVGAS+0kAyS8JQemndLOiRm4tN2XAJjzdcNqTDQkS4VCsQhmCsDbRuoHcfz9ekoUi8hp+KU/b4CJsaz5mLCVPZB/ZyP7hM2pLgoCyB4+u6aF0uVi0BOPcu0vsrxk0ySz8LQGq2aCppPTgNpcng6oRnF62DQZf7yPZZq0ona2CN1PeKdgaEYF/r+eEqNgbxIex0hNIZCbwB14pzBcIOmscfZAM9LDjbmqipOREKWz3xGYF3x0GMwFIqnOXn/Tn7y8p1Yxwey9D7DT4kTIJpNGC6BNfV9zoSo4K8YhkbmOQRLQ6i7nGKb2f6PcBu5RKPaNqenCQVulGMB5UWxC3uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFCOgSyHwyftnU+1MlXSR83ezqvOiqrXEtWHGU0GuRI=;
 b=ZPTh56Q7gkITd5axErcXng9OJSrcW3SS3lu/P9vRpj6wfZQFSY3PwHyFbxCdLfYfcGx5d4fNmUKj3+ZeJgA43KB45fpwKQhcIe+b3XieyjCyD8aTnlyvmLpLGCrlMt7tmKcu8BaqPsCMMubdmAUF99NFJr/QhMIHhQ85PNKTwCpwz3vaZ7D8YMP/mqAfyqHbmdJTmQHgkWfhx25bX/Sp5mwm/LbwFSpPpMBOXWCtknoJTvcuou1AowLFTOemeq9a5j83DoJdahPICcw1X3bKcrmWciuMFkOrkAQBS/bLqd/Yif4Ap63x33Bwao0TdcX6YRlH/2zxEnQbgUJ1RHJVVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB8427.namprd11.prod.outlook.com (2603:10b6:806:373::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Wed, 20 Nov
 2024 03:54:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Wed, 20 Nov 2024
 03:54:12 +0000
Message-ID: <a87640c0-0cd5-42be-83fc-bd12385bf69f@intel.com>
Date: Tue, 19 Nov 2024 19:54:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 5/9] x86/resctrl: Relax checks for mba_MBps mount
 option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241114001712.80315-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:303:b7::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB8427:EE_
X-MS-Office365-Filtering-Correlation-Id: b880af21-61d0-4400-46e0-08dd0916fedd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UEE3N3JVaDVpSjNoM3krZmVBdDUzQzYrSG1KZitMR25QK3BHQ0R1Sld5bmNm?=
 =?utf-8?B?ZE9QbnVFLzlqcVVldUhNdkcwYVlQY29TODV2SHNGTE9qZnY1cW1lb0tiZGta?=
 =?utf-8?B?eWZKY3B5NVRzWlF0bU5LRktvVG5ZS3ZWVkM4eVYzM01CMHBkV24yZFQ4OE80?=
 =?utf-8?B?Y0VLOElaenNpM0VPYXJlQjV2anBaTzd5THlmVk5ibS85MjVkckxtVkM0RVFK?=
 =?utf-8?B?eFpQVUZ4elIxTVZQTVdqWUw4VE1oa1A3UFp1bDUrRTVwMUVvbDRiSC9FNzBB?=
 =?utf-8?B?c3N6bTk5U0F0R1VVOE0zYnRyaDhDZnZXU2Vha1IzbXdpSHpsNEZ1N0VhZjlG?=
 =?utf-8?B?TU5TOElpVUg1aDNPR21LMk96eFlVcDJhSUY5eEdYWmhBbXdRZkNoOS9vV2s3?=
 =?utf-8?B?VHZodXZTNDVBbE1hQm5TNVpMQU1PbFZkL0pETVo4Q2grNjdZZzNxazd3R2Fz?=
 =?utf-8?B?OFFOaEc5Z1k3QnhORkNlMGhGaUZoYmJaTmlNMEtsZU5FeW9RM0sxS3JxMmRN?=
 =?utf-8?B?NTNnSUljbWQxbEdGejhoSHlDTWxRalNpVDdOeTBzMDl2MDZBa1V0OFZnYXly?=
 =?utf-8?B?cDE1MGcrenUzQ0RTS0lqdm1kRWxDWGdHWEZmaXk2VVg4dkhIbG9udno5OFdw?=
 =?utf-8?B?OVJNMHcyRmRRZGxmZ0pZYjlJZk9CUHRJSFhTWG9uY2w4czhESElWNXlUNkQ4?=
 =?utf-8?B?ekVlMXdmYU9VNU1TY1VmdHZIcWhIekpJVWJKWU41Sk1wRllXTFlXRmUrZUVZ?=
 =?utf-8?B?U1BSZm5sNUpNdjQ4dWZ4WGt4ZXNHbjYvYldCNTNyMFpWTExQMm5XaXF3QVhT?=
 =?utf-8?B?OTU1VXNLTUJONlV1N2FydVg5dzluYW1kdEI2d2tZZDlIakRuT1Fud05tRlBj?=
 =?utf-8?B?Zjh0cjBLQmJDNTZVT2JudXFBd09NWTFzMkZxRnppaFQxS3pMamJTS2JFcmE2?=
 =?utf-8?B?OUZMSG51WG9HL2FzN2l0RDc4WmFqRmZpMzZCL0s2SmlmY0FrVWpnQTBVZCtw?=
 =?utf-8?B?aUlidDN5RUhXc3dvR1AxZnpWTE9RRVNwL1kzU0VqVkM5RUFGUU0weW1La2Fu?=
 =?utf-8?B?VzV0d2xmNEZudUhnRE00REZMd2FRQmc3UjZzdEl5cjVDR09hYTdIZUQzbGM1?=
 =?utf-8?B?My8yNnk4YkQwL2ZrQzczRWhBL3lrL0NZYVZENXY5YSs0N1FEb1IyNFI5UXNC?=
 =?utf-8?B?VGp5L1FBSGkvK1B4QisxbzQ3blg1Tkg2U00wWWd0ZGlvVHlDOUEyN0ZLcVpN?=
 =?utf-8?B?Vkc3NDBHYXZ6aWp1YTJYbUtMRTIrdGlwdm96SEVDZzQ1RVdCbXlBN01kY1dq?=
 =?utf-8?B?NXdQMHh4ckRrQ1pOYmdqSG5pR1lRaW1GeWJtWGVjcEh2ck1nU2JkTlBVRi9G?=
 =?utf-8?B?K1FRWXZoWC85M1NvbWJveVl2MllXTkdXbjhzeVpxTWlOdG5YVVRZK2pKTW00?=
 =?utf-8?B?aUZPREsxeGZCMC9PZEdJeUxVNFVsYU9RK2J3ZnhuZE1hcElYM2MrNWlMSXVJ?=
 =?utf-8?B?MVExMXZLZGlpemYvYzNxWndVUDVyVGYxWmd4blQwOFJ4L1hFcU9UK25QWlI2?=
 =?utf-8?B?Yzh5T29oRkpnaU9IT1JQNzlFQTBVeDlZYlYvdlRoY0szS2xGQlh6Nm1lTXl2?=
 =?utf-8?B?VnlRS1I0VmFHbVR0VjBvQjZUcWhrd1ZGcit4S2ozdlBxeTNmbHRZdmw4Yy9i?=
 =?utf-8?B?cnNZUk9ZVmxMT3VCa01CMS90dFByU1BjUUE2RWxFWEZ0MVV3V2Y4YTVHYkJ4?=
 =?utf-8?Q?3yAr5yzPdyI4XKGM+VVxKqoh7jGrKg/02idn4/j?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWV4S3lENFVNTDJ1UnhZNWtuZG13WVhtU2UyUWVvZnhSZ0o3eU14c3h0MVBP?=
 =?utf-8?B?cXhjdFFnOUpJZjU3NnFaYWJBaG90eGJURVI3V1FxVldLN3NXRXF6RlFRYlB0?=
 =?utf-8?B?dHZ5VFJJaUU5QUlKam1oTW95NklkMURPYUcxUkk2TWtJNTMxaUduQjFjbWsy?=
 =?utf-8?B?OUtYdkJNK2phVDVnazM5T2FnTTdxOEFrdDJ2L0RpN1hSSldXUG1EWC9YQm1u?=
 =?utf-8?B?cFN5V1ZLTGFFb2ZiZnVLQldWTGRCcWVDclIwTkJlTldUZjlMc1N4amxnR01u?=
 =?utf-8?B?bGluTEJlMU9veW9TZWI2NkNPMjhwREcxeDV3OFRTa1UxdmdhOERRQkFuelRs?=
 =?utf-8?B?YlpFSzF2RXVrQzRWSDhIUTA3Z0RUVFlxZm9MekMyL1J3OWtxM2RVUm9aOHNT?=
 =?utf-8?B?VW1pU3p3Qi9Xa2xnYkNQUGtYOFZaQkFPMzM1ZStqUGhZUEZOTFN0SlpGME53?=
 =?utf-8?B?ZjE0SFBIbDNBMHlDQms1WHRUMG8rQXNacnpZTmFDT2FvV1RZUXhOb1UvNnF4?=
 =?utf-8?B?Mng3TGljYzkrMmxVM1NwbW1Sc3NPWGgwNUNQZmVjcjY0L1loVFhaWlZkRFIr?=
 =?utf-8?B?czJBeTNCT1ZTa3ZHZlcxQzF2NDZmV0ZaNCtyeitxbE1GMnBPTHZkUnlqdXda?=
 =?utf-8?B?Vm1mSmRGUE9xTEhBRkw4emJTOStpQmZyT0J2WjVDbE9JVXZTRGNEeGFBR0xi?=
 =?utf-8?B?dzVuaHgwejl3dVJBWE12SVpXWXArSWIvalBwTUxWN3V6VWl3Q1MxTDhnYUZN?=
 =?utf-8?B?R1hVV3d2RUFmZTZYMWhxWXoranhtMEFjaDkvcm1LMGdDWlRwTXUrc09MbU5k?=
 =?utf-8?B?aWw1bTB6WEE1UDlETHFjajJSaE94OS9lOWFMK09SUTlYeWJ4R2tXdGY2c2RD?=
 =?utf-8?B?QXpMTk8vNmlzMmRjQTRjMXZPUmpDTE1WN0h1dVhZSXE3ZEdiNnEzemUyb3JR?=
 =?utf-8?B?emRSUldlaUZhZ1p5M0Q1bjBST2NPakhJMjNVZnFnREZLSTVlODBEVGJPbTE1?=
 =?utf-8?B?ekd6YWppZ0ZEQWVGSENkK2t6Zkh1bWtQSktxZzRhbTJjZzRDeDltU3FqUmMw?=
 =?utf-8?B?Z2tNaWF6RThyMUpUWWRTU1lGOHgwbkZ3VHJMRGZ6ek9XS3Y4WWdabmJoemRR?=
 =?utf-8?B?d3E2Mmh5K3VuK2srRDdNbnBTVmVuRkw3MXJGdGYwVmR5eW5YK2w2Q3FvUWFL?=
 =?utf-8?B?NG54Vkd4MVhMdURyUVc4b2dJaWc2TlVsTTduRVc3UTFiQ1NKZU05RTlPbkZJ?=
 =?utf-8?B?dXM3UTdOeHdEeDUyMFBscUJ2MU9VTjU5TWorR1Y2dFBkOUE5TWs2UFU0eUhN?=
 =?utf-8?B?b21UTWh1VVVORVIwbVh5TytYb0ZZSmZydmxMZ253eUxJdklRcnd5SjRraVhF?=
 =?utf-8?B?OTZndittUWlOM3lZQW5RdEhRSHZRem5yeTJOQjZPSE9hUUpoRHFWSzU2NDkx?=
 =?utf-8?B?WStlcU91QVlDVjd1WlBkZ01CMjdTOEZ2UDdlbzQ5YnVSNnFmSStPY3JXaVNZ?=
 =?utf-8?B?Y0Z1TXFXeVlLWk1NK0ZUSW01T3R4cnYyRWlmb2VyQ1JhcFoyY1dTN3kzdFIx?=
 =?utf-8?B?bCt4VElONWFTN0VKR3NGNEpBYWVXaWtVVWVLeklCSjU3TTN6VlZJWDZNaHVz?=
 =?utf-8?B?bksxWmFNMk9YVm80TXpnT2JoeUxwczdYQmlWM2w3dUNDZXNQdHZwalNpWUR1?=
 =?utf-8?B?UzNNNjNUeUMwNGU5WUdESThlU0lNeFUxdlJzdUc3Um1CVnhNMG9YTExVdWVt?=
 =?utf-8?B?N3hSWnhLSVJxUFRtL1B4SUpQL1FhN3pPQWhMS3lxYSsxY0RXNUhXQzFoenV5?=
 =?utf-8?B?anZ4YjVyNitmOXF2UWkzYktMWm16SG5oWVJLcWJQZXhOMzZNcEE0Rjc2c2tJ?=
 =?utf-8?B?UG01elliakNra3BHOWpKc0RMaXRtK285U1NmMDRNcUxuTFlMd2dmbGd0bEx4?=
 =?utf-8?B?WUxhUjNhS0lYV1RyUEMrdUFEWmJoeGNBaGdIMllqNlo3d08vY1B5UTVoZU5T?=
 =?utf-8?B?cDZNRHc3R1FTYTBiSW9rWHlOZzd4cW9RR0Z0bGZCeGNPaG10NG1OMmRCVER5?=
 =?utf-8?B?eXU3WGJNaWNpYlFZVkpnSjZoOGx1Y0lhaFcxQXNZMXJVN1QzYzJUYmhrekFl?=
 =?utf-8?B?aXNRd3ZodnFDQ054WHdqbzJNSWI2Z1hVZWVQMjRFOWNFUm1HZUpVczlMQVNR?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b880af21-61d0-4400-46e0-08dd0916fedd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 03:54:12.7432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0sxG07BbE4RX7ylGdxlWmEJQqBgkWo2x3xObx3eYsXp/aoZ7kGD4rFsYyOLCYbtQLpTJmSlJAq55cHQPcaaJqG4lAWROQi//ibS9YkLnt8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8427
X-OriginatorOrg: intel.com

Hi Tony,

On 11/13/24 4:17 PM, Tony Luck wrote:
> This option may be used with any memory bandwidth monitoring event.

Needs a changelog.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index a8022bddf9f7..3a89516e6f56 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -2334,7 +2334,7 @@ static bool supports_mba_mbps(void)
>  	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
>  
> -	return (is_mbm_local_enabled() &&
> +	return (is_mbm_enabled() &&
>  		r->alloc_capable && is_mba_linear() &&
>  		r->ctrl_scope == rmbm->mon_scope);
>  }

I *thought* I had a handle on things with the understanding that rdtgroup.mba_mbps_event
is only valid when mba_sc is enabled. This understanding falls apart with this change since
at this point in series if a system only supports total MBM then mba_sc may be true
but rdtgroup.mba_mbps_event will be zero.

The expectation is that patches build on each other to create a solution but this series
does not respect this making it difficult to reason about this work.  I think this series
will be easier to understand if "x86/resctrl: Make mba_sc use total bandwidth if local
is not supported" is moved before this change.

> @@ -2759,7 +2759,7 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
>  		ctx->enable_cdpl2 = true;
>  		return 0;
>  	case Opt_mba_mbps:
> -		msg = "mba_MBps requires local MBM and linear scale MBA at L3 scope";
> +		msg = "mba_MBps requires MBM and linear scale MBA at L3 scope";
>  		if (!supports_mba_mbps())
>  			return invalfc(fc, msg);
>  		ctx->enable_mba_mbps = true;

Reinette
