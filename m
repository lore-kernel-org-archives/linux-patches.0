Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C142AE68
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 03:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745379438; cv=fail; b=Dh18eKqmaLXcUn+Ppu22cIMd+w5iFh6WF2y7YSAy/9EaiA7msY3F4JMWN1b/hB2eEXVJyGw1HiPmZl/ITl7oOsvwvbim5BWICGVYRFFMrlYnBJV2m1jOkTFkxZCuBp7s4o/oFTj2rtpuSbqeTrYCHZiwLsQZlNZApBNgXyHitAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745379438; c=relaxed/simple;
	bh=75C4UwnQ9LfTT07Nbs24KTPl5464rNKBMiU/scurZKY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bXc8zEiGrxjlqEK2A8BQ3oxy11cfLMedwhPpQcBpnXERlkEEXVxN54bF5rCqV7Qy+a5VuzuIo2lKB1nSQKPtS8kzaKsNbhYrQArUO7GFmLXd9wOt55+neWp6ajw3N+ELTZb4TmJhiCIT0wffVVxD4Y69IxMt3bdUFwl9f9Hvmqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nmxx0F91; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nmxx0F91"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745379437; x=1776915437;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=75C4UwnQ9LfTT07Nbs24KTPl5464rNKBMiU/scurZKY=;
  b=Nmxx0F91iUzVwuqGhGVCoGadmWTtDFy7jjoVWPcIIFtM4yqsmUxHM1av
   PoH1KLCVEKQYuZLxWqREXvjI4eqRYUEX8yH8SqZVWBiWyxSuhZbBs8NUj
   c81eNvOhNLEb5QYBpu5ac/z3GMKZvCqAjBxcfuqMatEkvIG36921Iy/JA
   aof6NEuCcWYy7nz/VNbx/t8h7f4GYzvJiXXRifOKUH4eHoVqnsyf7Q4sY
   qsrIzmoV+8JQeBDXxY6Z0NgA8yPMLLjkdTIqEvK6otZLXF/ccGh3feU0D
   GWWmfrE6aes/UHtIQjGd9gx7/CAnYsVLZV5q1VzGt2Zn6B/pvIR+w2JkC
   w==;
X-CSE-ConnectionGUID: fdb9EQttSQ2y+YPFh5Qxjw==
X-CSE-MsgGUID: xoFHLN57TcK5edH4ITa6Kg==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="57614768"
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="57614768"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 20:37:16 -0700
X-CSE-ConnectionGUID: VeftvMn0S1Gz7JJVMv3d1w==
X-CSE-MsgGUID: Qvrid5PATsungXYese31rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="133140218"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 20:37:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 20:37:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 20:37:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 20:37:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wah3oSgD2wG21z37zwlXrjL8sEjdStTMiq7Uy9Hz+0rj199a+2vGDmxbIzmKVlGtI+sg/puGvVZaNeEBHNjt4rsZYyJ1Noe1O4leKAImFQ4+osG/tBI5h2+czqEMChyXgfoNxyIO3aRzM1d+kS+DcTWHf485ok2H0w52VzdSkYdsUdsXGME30/FbOXehjL4esYKXbu28vui9JKKiFhfdbZVIon6LGx4kZqAgZRz98Khwu/rA6IDGNnDW02VejSziL/tgmL00cZQCavUm92v0yQcEnakqC/QEi3Kjd0URqnvueKvYI6CvNbEaPuqe+rvLGmRtdkNmAMrrKyqZWk3uJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7eZeY3dAMbeYt259YGMKIcla+rv3tlc/7aGlND6jUQ=;
 b=m1mGjv9kMAswM7Btp3xVr0dz+FN+timp/UZb4EiTUfLUCA7Prvrkbuiw8WXF5qG0HFWVYr2hg9fVUBjliKTqH6v9nf9L2wscZAuUrEJX2Hww2BJ4Be7yrGzY3p5qntF/ud3ppbDHwrvPKUPOzDBDEybjUsnIZE4ftM38dOKmpOJVSS130jGnUzEo2W5alGlD3ftkW+ALv5cDgUyecEo9Bwiddm0Zxe4GBYkc4h3T/yCW2UhezyijNdd79mOZqaSB7sAASJxXcQqD8t+pxjXx9lhYDbGBAQLJhjiYm23J5qKmATLWlY5qjaLFTHEPrZxPJOXCyQtMRBGm7xG97IjLyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7763.namprd11.prod.outlook.com (2603:10b6:610:145::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Wed, 23 Apr
 2025 03:37:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8655.024; Wed, 23 Apr 2025
 03:37:11 +0000
Message-ID: <2e118d15-ace5-4a07-a54a-18c9da3d3430@intel.com>
Date: Tue, 22 Apr 2025 20:37:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/26] fs/resctrl: Improve handling for events that can
 be read from any CPU
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-11-tony.luck@intel.com>
 <da51ba61-4ff0-4db4-a55f-743f6a3ea7da@intel.com>
 <aAaqbUk3gZbCan13@agluck-desk3>
 <bda6d0a8-f621-4745-a578-a7f2c9784925@intel.com>
 <DS7PR11MB607763D8B912A60A3574D2BAFCBA2@DS7PR11MB6077.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <DS7PR11MB607763D8B912A60A3574D2BAFCBA2@DS7PR11MB6077.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:303:6a::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 11d01aa7-936f-430e-885a-08dd821821f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZnZlTDdsSFpZTEQ3blNqMXZndEc4cW5jSUplbGpJNTNja0dUV3BBREZhNHNP?=
 =?utf-8?B?Q0dBQ0NTQngwVDEwZWVMbjdjMTNqOS9ldjVFdktzTjZhQnE4Q1FtOFVVYkR0?=
 =?utf-8?B?ZS9QazQ2Z2JGOFZvNTlvUXo0UU93YkhySEdMbzVRdFF1MXlMYWJxWHkzOVFI?=
 =?utf-8?B?LzJVZlRIRDMvakVpcWFMT3VuekR2dUE5d2dwaE5namEzSjZ6QTdRU0prd2xG?=
 =?utf-8?B?SkFwYXoxTGNXWWNCOXNraU9ZRjF3TzNDbWpYckdwc0dORXlFVFBQaWs2dGtJ?=
 =?utf-8?B?WmtkQkllMGlhUXFwN3ZIWjZkM3pFcnNXeUVpamcwR3BjanN2NnlWaHp5TjF4?=
 =?utf-8?B?di9CTU5nQlcxcWtBenlZQi9nTGdRcm91ZFFtK0QzRG04aVFmR245eWxQN29u?=
 =?utf-8?B?MWY5ME5iQ1J6b3EvR1ZmL0JqTzNrZHkxUkQ1d0tvV0U3MDRuUUh0MVdLMi9Z?=
 =?utf-8?B?ckw2RGI2YS9IY3VwNW1SRVpsNWdNODRTSFBFUXdHR29aa3hZWDljdzRTVGgr?=
 =?utf-8?B?aW0zL293bmF1T05MRTBLT2xPcXNmM3M4elJncnVMNWJxVkh6dlZMbGR6SEpH?=
 =?utf-8?B?c0RtbUNhRllHamVIZVBPTVRYMDlvV3R5R01KQTlkWnBlaEtyNmxDcTZFbmF3?=
 =?utf-8?B?M1BkMmdMQjJwWnBCNG9EcTh3MTBibTY1bEJ5WkZpdjJhZjBYcXkvbHdhc2hs?=
 =?utf-8?B?cnJ4R2xuR0N0NWhFY2hUVHNCc2NjTGZuT3Zicld6ejlzV2RpK25hWUxVRm1r?=
 =?utf-8?B?c1piTU8wSEd0MVYrL21JNjA5Zlg2N2ZWNklxUFB6bEFlVE9GRmZTVy9uczVT?=
 =?utf-8?B?ZThlQnZrMkg5OU5kM0N0dG96SGY1OUk3dmNzSjdYQWFzcWVvN0hManhhTGxI?=
 =?utf-8?B?TzMwTGZ6UHRTa0R5MlVobCs1SkZOU2d4d3dRUHFNNkdFbEs3UXZ0ZExva3cx?=
 =?utf-8?B?WW5nTzFHTlV6Tm0xOFpRLzQwUThzdG1XaVpQSVF5SG1VYTlDVGpRSjI3Mzlt?=
 =?utf-8?B?eXEzTmk2RlQ1Q0JnRkhzQy9KdEc0QmZmd3FjNVgrV3lyNlc4bkVqNkU1WmxG?=
 =?utf-8?B?MkQzUmZkSzhma0ZQa0NCQ3hjdWZXUDd5NUFnRHorcTNXUlhSQ1BxaHA1ZlU0?=
 =?utf-8?B?cGxaaU15SCt4TzRSR0NJSjBrTG81L1p5SVFSTnlxSklkdmNiNndyTkp3L1JH?=
 =?utf-8?B?UlpBblUzUUN6RXV6Nm9zL1ZCUnFlY1FDVlVQMkNyRHozWjMrN3l5ckFaVkVy?=
 =?utf-8?B?UVp6MDA2eXBRYUx4cWhvQ3pwRUlpR0dnVDVHdEs4V3BoTzg2TTVVYWtGQklV?=
 =?utf-8?B?QzNYVlRUTDRZRDFkKzB1cXMyd2xnN1hLV3dLMElmdHkvZ2xHTzlvcnl0QnlJ?=
 =?utf-8?B?cE5sQ2VVRGpncUlyME5jZDEvQXFBVnQrM1JVTTdkdGRVWmVBTzlRQ2hvdUZi?=
 =?utf-8?B?VG1mbGJ6NkFFbHUxTmZteUtlWWZKMXM1QUlZbkZ4YktEWGNFTFhlWFV1M29O?=
 =?utf-8?B?elh5MWNHelViNitSRTdpMDhEL1BVN3dVQzlTT3B6NG1HU0pNbVhkZ2ZhRE9q?=
 =?utf-8?B?V1p1Qm1vNUtmZUUxckVMZ2g5M29kV254Q0hKV2xxNXZBKy94MDBvZjFaRTk2?=
 =?utf-8?B?bEtSZVBsbUszRk5XUlpuYWt3eWllQWgvQVlubGxFMjVHbTdqajNWdklUUUxs?=
 =?utf-8?B?a3Z3RkEvNkYrTExpdytaVFZ1MTh3cnB2TlFKOG1odnhxN0VCdTdxdi9URTlZ?=
 =?utf-8?B?dmowWEp2NytGVjBLSzBuK0FYd2ZDMWo5aFlvM1F4enNmT0Nab0VYcVhoUE5E?=
 =?utf-8?B?N2daSzZaYzVYMXRqcGNPajFRZUt0bEhodW1rSkdiT0pnejhHMmpkaWFzdVZz?=
 =?utf-8?B?ZCtlL1ZOUFVpd3VxanRheEhib3FFWWIzSzB6RERLSEtCOW9Fa2k0Wk00T0d0?=
 =?utf-8?Q?2esILnNzUdI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWl2aUNpMEdDOTA0YVNYU25HU005dnl4WlFBMUVQd01qdjg3ektBMzQwU0dw?=
 =?utf-8?B?SVFaN3oyazMydkgxYU9CdnZnOFUzdGlYaWVVYjdQaHJEUnFVVm5KUXEyYzRw?=
 =?utf-8?B?TjdWTTdxWU1IZzg2UWd4YWFVR2tXWGFadlJiS3hiZSt0dS8rQWxhZjFkR1pT?=
 =?utf-8?B?WmJOeVJ2S1MyNXBraFFxcERhTUF0QXJTVk5EZDBJUWJCdVBSbDNFSXNyaGEv?=
 =?utf-8?B?RnNJWVowcUJjRzVibzZRZk1kZkhmbm03YXgxWjhLSzlMZHVUUmtWM20vWnVi?=
 =?utf-8?B?aFczRUhuSktiQkNKcEpabGJzb3ZHSVdYSFBEVTltMjE0QmI2bXI0d3grVmh2?=
 =?utf-8?B?c2VlTWQ5TWxSUTJsTnZINEVtZklVeDJQbWZDOCtpcG5mckc2Qi9paTBtaGtR?=
 =?utf-8?B?RU9GUXJQTUJTTHEzTE9sdkhXZlVGYTZ1Y0ZiZ01PZDhlSUxraCtSU0h2OWRh?=
 =?utf-8?B?VkxKT3hrdFhiR3FHV3BtU3FGS0lzb0NDWVhjUWhDa2RmSHZLNWJydTR5ZmQw?=
 =?utf-8?B?d08wYklvMllOVjFRVXZJcVArM243MGVqeXozckxBWHJQNlZzU0hQTlRTeUhK?=
 =?utf-8?B?aXVQcVRZbjU2blFsU29LZksrZ0J4K0RMbW1XaHAxV3RVdHlYazQ0QXVjRFp6?=
 =?utf-8?B?OEY3RHlJeEQ1ck93ajJtQlVOL0o4dW0yUDRuNmVNTFVGaTh3aytQV2Vialk1?=
 =?utf-8?B?L3hRZ01mNFlwZFdQUXhoWXBVbmpheWRhdjNkQU9aZnZEZlByTTQ2b0xaT3Y0?=
 =?utf-8?B?bU8yT2xYQkNhL1B1MmNXYXZSMlIvaUEzckd6bCsxQUo5bkMya1d1QkhJbGEx?=
 =?utf-8?B?bmlES29YKzZsdjZWcmJTMVJnY3h3bWJNbTJDSjQxU2J4Nk1CZ0o3dVRoSVEw?=
 =?utf-8?B?d1l2c0ZYZFgvOXc1b0s1WUVaWVMvNzFaZWhtdXNUNVIzNmRoeTFBM2ZTOENB?=
 =?utf-8?B?MUFNeGlIZVRZdEx6N2NkWHNTTXZBRG5rR05jby84REsvZE0yME1oc0FnOG5t?=
 =?utf-8?B?QWE1MzRWYlRwdCszNDk3bXIzY2I0bE5FNi9GUktIUGJ6MEhRNnlkUFcxVWh5?=
 =?utf-8?B?Qi9mQ1IwUEZPeU1XdjlqSmpXYWs5WGFaOUZmbE10eEZVNDYwSDFqQlNneTQ0?=
 =?utf-8?B?UEZ6OFlkbDZTZjBXNURSWkx1eldJN0hPWUxFcnY3YW1iTU5ZVFc5OE1PREk4?=
 =?utf-8?B?SGxNMFVCUXk3dktTWXUxdlUwWEhXWnpUV0E0bndoeU5vVk9WSDJnVUY1VnEr?=
 =?utf-8?B?Q1ljeEcxakFtdmJoL0ZrWTF2ZytHWFFFNEdWY0FOd0dhQ3Q1aUdXMFo2Z1J6?=
 =?utf-8?B?bWJGV2xzenhPTWhPWE4rZEVJN2ZVbFlPMDVsanBXWmQ3Y0RHTEJXNUZ5K1BT?=
 =?utf-8?B?eUV4OTFKUzZUdkhiYmlqV3FtK0Z2NlprT2J5S1hqSi9raTRlcC84MVVsWlI4?=
 =?utf-8?B?MFRMYkZiTjA2QXJlRldJVGw0L0lONEN2aE5Iby95NEJwM1Nhc0VqY25lZXY1?=
 =?utf-8?B?c0FEbURQUzhCZ2NYVnJEQW4rb2YyQUhqd0VnVHN6Z2FFRERua0VZMS8zRGtC?=
 =?utf-8?B?WE5CTzRFM3laeSs3YWs5L1NrSFVMc0FYcGFiVEllRTVqT01GZkRBdGM3aERR?=
 =?utf-8?B?ZHpoNVNvbzlxUVN0Y0I2aEc3NHZGaGlpcDd4SjdRcy9rOGZKUnNVNHhNUEI2?=
 =?utf-8?B?TWZVa2FBSDF4aE1BRWJMUjN5cURSSjVLbmdHUXJhTjhSMWxUcmlZMFlVM2Rk?=
 =?utf-8?B?ZnVja24vTERkaTA2djZNQzc5Y2VkUUU3NzNWQ1NaUTlWMHBKZVhaWEJCTEJW?=
 =?utf-8?B?SFplTndPODZpVE9XNHhSV2t2RlNRaUs5NFQ3eTdadUZwRGE5QWIycGlpZ1cr?=
 =?utf-8?B?UWo3aElPVlB1cFlqNWV1YnF2U1YwaHI4bHBaM1dSdGNucG13bWwzQjNiYlds?=
 =?utf-8?B?ODY2NHJMYWhGbmg1RnVEbkJMYzdXNDhhWUhqWVNxNzlZUmZWR3lmMEQ2YklK?=
 =?utf-8?B?VzcxcXdNWlhiQjUwOTQ2bXFRMENpSW43VXg0VlRLai9zL3RHOWowL1R4UkVN?=
 =?utf-8?B?VEZId21EdHZSY3ZsMDVBQ05KaFpQWmxqUHB6b21SLzY4STkvOFdsVkx3RmJC?=
 =?utf-8?B?QXZDeEM2ZjVjc3hNZjJ2czVVendwSjluYTczcXhXL2dlbzVWNCtNTEF2TjVT?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d01aa7-936f-430e-885a-08dd821821f7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 03:37:11.8437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1dEA/9FXGqR+odl16Kw7rR3ZTXcG0HIbZAAG6hig3GrASh6ed3nOYDhbbgwGt77qcdDe6Gi9xoDBvfIgA53HZ6h+l5qmfAJNnrUCZUE3kU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7763
X-OriginatorOrg: intel.com

Hi Tony,

On 4/22/25 5:51 PM, Luck, Tony wrote:
>>>> cpumask_any() is just cpumask_first() so it will pick the first CPU in the
>>>> online mask that may not be the current CPU.
>>>>
>>>> fwiw ... there are some optimizations planned in this area that I have not yet studied:
>>>> https://lore.kernel.org/lkml/20250407153856.133093-1-yury.norov@gmail.com/
>>>
>>> I remember Peter complaining[1] about extra context switches when
>>> cpumask_any_housekeeping() was introduced, but it seems that the
>>> discussion died with no fix applied.
>>
>> The initial complaint was indeed that reading individual events is slower.
>>
>> The issue is that the intended use case read from many files at frequent
>> intervals and thus becomes vulnerable to any changes in this area that
>> really is already a slow path (reading from a file ... taking a mutex ...).
>>
>> Instead of working on shaving cycles off this path the discussion transitioned
>> to resctrl providing better support for the underlying use case. I
>> understood that this is being experimented with [2] and last I heard it
>> looks promising.
>>
>>>
>>> The blocking problem is that ARM may not be able to read a counter
>>> on a tick_nohz CPU because it may need to sleep.
>>>
>>> Do we need more options for events:
>>>
>>> 1) Must be read on a CPU in the right domain        // Legacy
>>> 2) Can be read from any CPU                 // My addtion
>>> 3) Must be read on a "housekeeping" CPU             // James' code in upstream
>>> 4) Cannot be read on a tick_nohz CPU                // Could be combined with 1 or 2?
>>
>> I do not see needing additional complexity here. I think it will be simpler
>> to just replace use of cpumask_any_housekeeping() in mon_event_read() with
>> open code that supports the particular usage. As I understand it is prohibited
>> for all CPUs to be in tick_nohz_full_mask so it looks to me as though the
>> existing "if (tick_nohz_full_cpu(cpu))" should never be true (since no CPU is being excluded).
>> Also, since mon_event_read() has no need to exclude CPUs, just a cpumask_andnot()
>> should suffice to determine what remains of given mask after accounting for all the
>> NO_HZ CPUs if tick_nohz_full_enabled().
> 
> Maybe there isn’t much complexity to make this "read one counter" better on systems
> where reading from any CPU is possible. Taking your advice from the earlier review
> the filesystem code can set a flag in the mon_evt structure. struct mon_data and
> struct rmid_read can change from holding the event id to holding a pointer to the
> mon_evt (as the source of truth).
> 
> Then mon_event_read() can just have a simple direct call to mon_event_count()
> just before the call to cpumask_any_housekeeping() like this:
> 
> 		if (evt->any_cpu) {
> 			mon_event_count(rr);
> 			goto done;
> 		}
> 
> The "goto done" jumps to the resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
> at the end of mon_event_read()

Thanks, this looks great.

> 
> Folks can still pursue the bulk read of many counters (though I expect you might want
> one file per domain, rather than a single file to report everything).

I will have to re-read that thread to refresh myself on the discussion but scanning the thread
I did find a summary of points (end of [3]) and this was there.

> 
>>
>> Reinette
>>
>>>
>>>> Reinette
>>>
>>> [1] https://lore.kernel.org/all/20241031142553.3963058-2-peternewman@google.com/
>>>>
>>
>> [2] https://lore.kernel.org/lkml/CALPaoCgpnVORZfbKVLXDFUZvv8jhpShHPzB3cwdLTZQH1o9ULw@mail.gmail.com/
> 

[3] https://lore.kernel.org/lkml/34fd8713-3430-4e27-a2c2-fd8839f90f5a@intel.com/

Reinette
