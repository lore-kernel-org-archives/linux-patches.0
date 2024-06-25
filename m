Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A7F17CA0E
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358172; cv=fail; b=FrpO1qUEXJMGMWeCfqiaRK/9gYSwDUl/T1ZkRXK1tPi2QTqVYDoKGTQ0skiVlhdLU+viEIi4PMzypYdiqvkhKQWey/LtNJnNrtkQFizuR3ClGj2ZuNja1rc5YMQSH6P4qWua6zVVnk1gbb5uul9p8BjjeRDtVMCYiDriCrtIkk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358172; c=relaxed/simple;
	bh=biqHw0ONabVHT7Lkavon98+jkja/4/44jBFIhpVxzyw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FqICDHXar/0lYTQKpx+F4Kp8m0VCmIxNLNjoncy0t66UwwnOaK0n2GgQd4XQNXjCjUIe0fkBbCzZdUjdrAhByMr+fAQaVycn2z/jdS5TIFSf57kmOonW8FKbvsnzwNMjxmCz+GbS9FbUSu3E/9hJdpUJONDknppPjvLkVmB9b5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JQMUiQzl; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JQMUiQzl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358171; x=1750894171;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=biqHw0ONabVHT7Lkavon98+jkja/4/44jBFIhpVxzyw=;
  b=JQMUiQzlM+aLnt5ZtPAEKhhXdfeRucYNLM+oRGdCxm9Sjt6Ad0bV/wub
   w9IE19ir6posVeQIJZxYdr3oHZxoeTlWXT9JwKoNiF9QfnObhq5HKu9xo
   FNuNRVgbE84NV3OY2AkO+s1/GrA/dfL+ySMMUYMyosrPp19wOzPromsax
   0LrhQ4z5x1vZPX/355bf6EzB7rdsF7bUl/KINFDRRVKNVtpkJ9BwXWKL3
   YithJnlEVWKDVIJRnAFJAW1XGohXKICjifx7HCDvaQnXDMxqvAf6uKtrf
   X2cB69B3sLh/+UQQIBdaTwq0YPVF/e49gJ+LKu/my47HebGpWb1dIGuix
   A==;
X-CSE-ConnectionGUID: rQetPkBySyOCKds8adAjMQ==
X-CSE-MsgGUID: C/IqJUgPRxaAjQIn0hMnOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16633749"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16633749"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:29:30 -0700
X-CSE-ConnectionGUID: WtDuqPX6RUWEo7avVB0WUQ==
X-CSE-MsgGUID: eQgrs2ADRuG3WRILod0B0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="48253134"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:29:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:29:29 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:29:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:29:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:29:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+LXgQoyfKHLCgiKnZYXjQxwPMxSsLh9gqJBgq7SgxVSa/QGeHfxf2jz42htD/GdYyLDekjlYMe5GiT6snuEdlY9R8H2AHJbVaMwjQdTB7hVxcXT21gjiLUgv3cgVi/laRa8hsyYRSoPNolOMZBrIx69DX85zdSpK4vZ9PwGqeasLvJna+2pT9C+XWNCNX4mlwUWcQkEoz3TSMuCp34AnIvNvvihj1g2T77TOvM+i+YSpSuTnuReHt2g8WkUN1yVQbwLxO0dGYk0MrR/ZNJE/MAy4IgxhPVGIHvMPqrLmIr059GN4TwaHbeTe4Q2wNTGDSyWSby89blWLpRdvB/Rcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRV3w9GiUu/YSTq5aW9pw/A6dnGJSAFXTfTkAUiankU=;
 b=jamde5vvm9/dHrz4onZPgKNKPEsuFXgoYHLqgcvDcIRVEp6f0aIDw6fPg3AkHnOTR7bsz9REkzsc2dGSwyAymHyqBpmYajMy9eihG5wF0bvl5oUOUYfDOhGJQJM0ojZEwxc5Iswm+WvnL2Em0AjfpKoeJqnggd68IiM40L/FiOtXGO/wtW7yjQgNxSPq4Cz/E6d3VMeaSGc2AB2gb7jVtDQWMWdY5+xdv12tX9zcs6ODt2TiMn5hi82tzdL7j3lyo3QYqI6po9ud9OXOw8A9bptf08XsP470DtlqcUWNTyZfk8nakhe4UOqHfdBn6hzIsqmdhx7/7rA9xMlcvzAuuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7170.namprd11.prod.outlook.com (2603:10b6:930:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 23:29:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:29:24 +0000
Message-ID: <18804d69-0fe5-4108-9bd3-0f7104dd3c38@intel.com>
Date: Tue, 25 Jun 2024 16:29:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-10-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240621223859.43471-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:303:8e::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 9820907b-d487-4492-9a05-08dc956ea63d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R1RDRlI5QWF6S3JuaUMvVk9RMFI5MFhOOXBQZTI0aUFiVitseUFoRERsRlov?=
 =?utf-8?B?K1lRQTBVc3RlT1lpckF1dzJhWko0VkgxeVM1M205ejlQZk9vTXU4MWxUU3hX?=
 =?utf-8?B?Sk5MR1NVWFI4TmJNSDNYS29TM2NXN1NoL3ZxNWVpUG5XRGI0d3U2NXVGajhZ?=
 =?utf-8?B?ZTcyOGF0a1VsVDB5YWpXV3grWUQwWGl4RVVJZjFucjg0aHRjTkZuaWltMTVj?=
 =?utf-8?B?VWJpT3VRS0dtbmdiOTRhZVk0MnVKc0xBbXVrNXczcTY0MDNyNDhab1hYRGVs?=
 =?utf-8?B?RkVuUUFOUFRCY0NlSm55clo0MWhsSTlyZTgvVTVjcXRkRFh2TUJCVlljWEN0?=
 =?utf-8?B?ZzVTTzZNd0ZsdDY3eGxCRFRXV1UrT3VzcW5VNGR3YVk4aHRWZ3FSSkVsY3pN?=
 =?utf-8?B?b2QrcTFIL25kdDBPUTVtbXJsVDFIcHBML2JacVhPaUhBZk1TaGtGYmg0OHNl?=
 =?utf-8?B?elVsUjVXQkx2RFRuOVIvTXk0ZVdxcjM2S05KL2JVMUN6MnpVZld2YXFkb2pq?=
 =?utf-8?B?a1hrblV3Z1B2TUtXbTVMcVJHNFQrSmNtaGJPZnQ1MHJKcmJSSFMwRUx6MWhG?=
 =?utf-8?B?M092ZndYME9aYUd5RmlyajV5dlFlR1RaZlV4b05ycGJ1TllTWWNkTy9ZZ2cr?=
 =?utf-8?B?WnYvempiZDZnaC8wOW1GSHpwZW00d29NOTBwMkhLZHNpNGFEZDFpcFZ1UW96?=
 =?utf-8?B?VlBrVmhLcTVSRlBYTUJDeTNWUUg2U1Facm5OWVMxeXJJOGZqbnp6aTh3YWxu?=
 =?utf-8?B?d09LaGk1U1hRT1grZDA0d24zdDYrWHIzcVYzUUI4dUFCM1gvOU11aHNYeUR4?=
 =?utf-8?B?Qjhhajg4TDJaVTFwL0EzNmpvcjIrOGRFaVBmd3NHT3JQcXUyMkJSV1g4aks4?=
 =?utf-8?B?Mno0S2tsekhiMHdDRk5sakJMR0xUL0JTT3lpdlhEOEdORVhsN1l5ZjBGQWF4?=
 =?utf-8?B?U3VGUGJ3TUc1VnpCd25hWExTUG93QWgza0lBWGFQbmV5aFNRNmcyYVpzRjJt?=
 =?utf-8?B?VHZFRXExaHBlc0szQUJWVmZncWhES0RBajRmK0RTZHBDcVRWRjVZb2cyUnd2?=
 =?utf-8?B?Y2NZckpudmhKbDdnRXVqVi9sK1hDV3R0amNYUHVCMHBWenBGRzlHK1lxK3Y2?=
 =?utf-8?B?L0JPS3greWY1OTFLdmtFS3FTMGlueE4vUlpOQUZOY29hYnNXcmZvZTRrd3hM?=
 =?utf-8?B?dWlaenFpclUwUUlGMnhhRUdvU3FPekVjOWdGVWFWRU04ek9jU1l1dFRFYVE5?=
 =?utf-8?B?TU1sMUpQaWZpNVQ4dUNLRG9KQWx2TUpJUW9jdS9qcXlVUDRwYkxrRk1JMmNi?=
 =?utf-8?B?S3NRaldlRllVT0RjYXliQW04ajJqTzdFYVFVSmswN0tnOENNY0s1SW50a1ha?=
 =?utf-8?B?Wi9qMDR3akh1OEVRRk1KR2lONStQcVphS0JUL05TYUtJTWtxZUt1bGdsMFln?=
 =?utf-8?B?VFVFd2M4WW5XNnVEbUZHOEcxSW5ZcHp2SFRiS3d0N3BrYmhLZTcrY3dpdTlr?=
 =?utf-8?B?Mmc1SGJIYXpMaHZmdW1lb0o5dHFGb2JVTUJoV0JkK3BVVFhEVTMrWXNsdTh6?=
 =?utf-8?B?eDhqb2dyT3lYV0ZOZWxGRmJjU1BVeGdzV1l1NkJ5NUtvQVFIQjA1UHp4WlBD?=
 =?utf-8?B?eVE2WlBaV3I2RHJQTDJvM3d3K2V2TnQybkhVT2hIRmtwOGt1eVhFcFpDa093?=
 =?utf-8?B?b3Jqbk1Ydk9XNXNEWC9jTHBWR3crYVdiYytHWk9kY2xaN092UC9ycnNrMlFG?=
 =?utf-8?Q?AMHpKaBoa0kc3ZD/xE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3NGRTMyWmNNVVdJVmM1R2xIVGZ1NjNycDJoN0xxNktkOHQraStiKzk3MGxR?=
 =?utf-8?B?eUV6Ykt3a1BHeGp1NWVueXdpVmVsYzB0MWNsTXY0dnlKWmVxUWNoOFMwMmto?=
 =?utf-8?B?SkZFT25TcHdEOVovYmFHTUM0OXY3ZEJlRGFMMDRHRHB2YzdIUVR2RndOczRq?=
 =?utf-8?B?MmFrNUJkeEdvbEFpenc4VlZZc21NVFZJZyt5c3NtOTd1QXo2Q05ReUpiWmlt?=
 =?utf-8?B?Q0FyYit6VU5DVW1GVXhOaFZSS0ZvM1VteWxOdGVsSEJRVEYrdFArbFAvWXVl?=
 =?utf-8?B?ekhUbjFaV2J1NWpUQzg4andZSDk2OU5VUGU3VmRrdnlxbDZrWWJabUJMK1JJ?=
 =?utf-8?B?MG9hSHFqL1RLV0wza2hLMUxGaUJFeTR2UHFXMXpJc2lXRnhSMGs1Uis3QjFj?=
 =?utf-8?B?aU5rT0prcUdhRWRYNHN5czVtWElKVzZLRWdJQU5OR3dXVGR1bUpVeE8xM1lh?=
 =?utf-8?B?U2llbmFvMkVlK2lDZTRYbzcxL2lqWk5kZXdOb0pySjR4M1VueHNrdGhOVlZN?=
 =?utf-8?B?YllEKzlLeElRanBMWWFWYmNGcXlQbVc4NWE1bDIreEcwdmM0ZEMxTFQxQ1Ny?=
 =?utf-8?B?bGdQSERnUStwQmM4M2x4UjNJK3RiSDRtbG8yV25xSisxaXd5UXg2UEtSVFJ0?=
 =?utf-8?B?VE0ybEovbnRNRGIzc3VSRERZaU9TR243TXFlNXJ5MUdkUURNUk1YUk5aVFRQ?=
 =?utf-8?B?Z2w5bENDSVRhNUlybTBrcUxFeGRCOUpPcDZVcld3bDBQSXMwUjFEWkFQNjVj?=
 =?utf-8?B?U0tHNTdkQW1MY2xwRzRFMDVFaTNoNnhQNEFabDVzK0lkT1IwMitRT3A5VXov?=
 =?utf-8?B?R0x2RkxDQ3BIcFVBc3lXN2dVckZVb0Fta3ZCNG5ta0dMZzZRelI5cXMyaCtz?=
 =?utf-8?B?RU5ZVWRTUWkvMTBQWWNyZ0g4ZEdTRldoUEpjNEpXM3p1czN1QmNjamVGY0Fp?=
 =?utf-8?B?dVZTQm8vVjhrTkU4bGYvTjFiRitURWhRQjcyYnVOb2h2aVEydmh5UmE3VG1R?=
 =?utf-8?B?a2NPbFlEVDRGZ3pieTR1bEpBWEt6eU5PZVUrWFlWMXNGa3JiZHc0VE9Iblhk?=
 =?utf-8?B?YnVJVkdvK05GRHUwdFNEdjBiVHRDLzRvSkZwcSt4TDVYTUFKVHFvelREZXUw?=
 =?utf-8?B?VXlRb0R2YzN0QVd5UWMxT2ZrREtKdG9NdmpVRGszcVBaQ3ZKWUcxbFZQNDdM?=
 =?utf-8?B?TVE0SElJQkp0eHVROTBRVFIyNmZPcXFzelV5Qkpua1dnckJzY0J5NlJRVDN0?=
 =?utf-8?B?bjZPZHBleUtZdGZObFNsYmZMRDdzYVkrNFMyNlU2NU1vUHpwWS96Y0w5bXQ1?=
 =?utf-8?B?amROZTM4bjFqVWlUQ3hPenNIVGhYRFBmUmIrSWtQcWhhVW5QWXh3WWxtbW1K?=
 =?utf-8?B?ZHVaOXFEd00wejhoWDNxc0FtYVdpR1ZaM3NoMDA3MFJMN0dmK0JpbzQxTWVh?=
 =?utf-8?B?RGpiTHZVMUYvUTI4TVZEV0taemxLTEcwY1VpWmFldmpDdDB5QmpYRmZ0T21z?=
 =?utf-8?B?enhwd20wR2NCazExRW90K1R2OFhrSlBUSGJJTExqWnZFS2xoZGdyQWdZTmQx?=
 =?utf-8?B?N0cwWWNQdGhWWGw0dXdnZHU3R2lIdVhlNlpkUE8xSmlRTUMrWmh4Qk84UWpR?=
 =?utf-8?B?WWRKVzgrblNmaEFwaWJMK2crMEtxSEVmdHVRSnlnRjlZVDhhMzNuSUdZbDk5?=
 =?utf-8?B?K3Y3ZUdwdkFuNmxtdDJVdmlpcC9VK3dNckJ6SWNmZnNFaUg2UnZ3VS9ZV211?=
 =?utf-8?B?RkRsb0k0TVJqTnk1VURNL2QxQmJYSm5BTTZrWkJrNG8yMHp6OEV1SFVEQVdM?=
 =?utf-8?B?NkFyZXV2azBITWhvSXl6eVVBaWYreUI4a2ZDMlRtVjlpbDQ5amhoT1RZQkZE?=
 =?utf-8?B?alBiS1BsNTJTa3QrZlZKOWtIa05iUThzZGVCZGVlS3l2ZnJ6dENPSWJPOWVU?=
 =?utf-8?B?Um5CTTFybWtYSzdZTnlYK0VYR1A5TGlvRWE4bkJFL3pjUFpxNmRobmZzN29G?=
 =?utf-8?B?YTByU3BiYVRON0RqbkcxUU1La2VsMlZaZWZZa21NcVR1TmRGamd5ME96QnRK?=
 =?utf-8?B?S1Z0Yk5mV09wODN2cXVuaFltUlNJZ0NmRmIyT0Y5OHVubnJ5cGt3aDhaSnNN?=
 =?utf-8?B?eFQ4ZnhwUHpNazBuak5XTExLOE1IKzJtdDBWTHpCK2RYVkExeUNRWlg0L0da?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9820907b-d487-4492-9a05-08dc956ea63d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:29:24.8784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJJLusxnPnaYPLa7nFAee+KoSPgv1D6ps4PgHxZ6FlA53qaBaYezvZkejmOxaAppKPX74zEq44K/+GplKYUykyduf+WrcdktE8ENS0LSCns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7170
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> When a user reads a monitor file rdtgroup_mondata_show() calls
> mon_event_read() to package up all the required details into an rmid_read
> structure which is passed across the smp_call*() infrastructure to code
> that will read data from hardware and return the value (or error status)
> in the rmid_read structure.
> 
> Sub-NUMA Cluster (SNC) mode adds files with new semantics. These require
> the smp_call-ed code to sum event data from all domains that share an
> L3 cache.
> 
> Add a pointer to the L3 "cacheinfo" structure to struct rmid_read
> for the data collection routines to use to pick the domains to be
> summed.
> 
> Reinette suggested that the rmid_read structure has become complex enough
> to warrant documentation of each of its fields and provided the kerneldoc
> documentation for struct rmid_read.
> 
> Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 135190e0711c..d04018b8b571 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -144,12 +144,31 @@ union mon_data_bits {
>   	} u;
>   };
>   
> +/**
> + * struct rmid_read - Data passed across smp_call*() to read event count.
> + * @rgrp:  Resource group for which the counter is being read. If it is a parent
> + *	   resource group then its event count is summed with the count from all
> + *	   its child resource groups.
> + * @r:	   Resource describing the properties of the event being read.
> + * @d:	   Domain that the counter should be read from. If NULL then sum all
> + *	   domains in @r sharing L3 @ci.id
> + * @evtid: Which monitor event to read.
> + * @first: Initialize MBM counter when true.
> + * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
> + * @err:   Error encountered when reading counter.
> + * @val:   Returned value of event counter. If @rgrp is a parent resource group,
> + *	   @val contains the sum of event counts from its child resource groups.

(nit: "contains" -> "includes" [1] to indicate sum is from parent as well as children)

Reinette

[1] https://lore.kernel.org/lkml/2e083f94-d982-412f-b212-1d520d7743c5@intel.com/
