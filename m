Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3F034A3DA
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241563; cv=fail; b=i2KK3Itc+fLV1DDNVfBgqpiG7swmuev4gOpO+gxy9atkyAZWZrsuSYefQrXsk/jH0MqgUngEAU8B4ucEae/MoYQ/jA+8+8yhmsw0XLMjdz/eO1wV0+RmnwSAnbjPNI9nSRR3iI4XUx7N1rj0Z/cKogGys8NlXY6Jn0soiBvGfMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241563; c=relaxed/simple;
	bh=r5Dbb05QUsdDXvQ7f9O2AnqGCEzwkN6zUVjeD0s7qXI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vh4ssDBzbDofXnkLgySrnuDOBgiKu/DzvdwvrsZKptrF/DAsKcRSO/x9lPvc9ln3wWn89rSBAdIUpOZ0vq0WzWtjdXmccmSwFRnFMtREpsYStMMX6ZIq4cRXmnlTxR50UAdLPccO+ZGIOFkl3qzOBYiemSKrtwpUraU3xD2ptSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CXQfvLUe; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CXQfvLUe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241562; x=1792777562;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r5Dbb05QUsdDXvQ7f9O2AnqGCEzwkN6zUVjeD0s7qXI=;
  b=CXQfvLUeNCwXbD+izHeKeKh0g+PEkGV+6Qjz4XK2gHmWvS0OwbATCROV
   i4NVj7Bn0/51G8yKy6yYUuwnR8b1/WqW0m9zrdvOpQyKfjOoLaqAMoMqq
   ikBELhxOfa8WJZS19fI2jqHrSVrlAi1YA/HW/P7TjtNBw2uTp/n3Hc0lz
   KcRUm92xReK0ezRJvyESFx0POeI5eljQrCxXNnZpvKnQLxwqusJP7Pet2
   ope0i8wWP+0SH97yQPQ+LY4yfcd8DLfUReIO0IjUUcQAEQNW+YrKCcPad
   68+hQeyBp19034Dbg6f12Ox5lmyiLPKGEpkLaDnNti5WR+ii2T1YRyh9c
   g==;
X-CSE-ConnectionGUID: ZEU5Au8JSI6Q4UzwYJnfpg==
X-CSE-MsgGUID: 5qb0cz+5TE6cgWivxQNQHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67258664"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67258664"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:46:02 -0700
X-CSE-ConnectionGUID: aLcrzpJHSUikJ+qrUq1KxA==
X-CSE-MsgGUID: 9laK6DK6QFK79fO9z6Kwjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="207870534"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:46:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:46:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:46:01 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:46:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YbMb6bZrbUIUZJiVayNCsTn8Ihk49SU++IQaU60JuVC/YhbSoQ49geqUc1PaAvT1IQhabv/Repu1YGxkxfuhUIHycwIlDJG0L6m4ZGGUqycdo9ykbZKYBUWM6PEc90nJ9RcS3bH3gQ5Nu4DGgREJC2bI/ImUOH0Esc/sNGkXPi01QpFKmtS/dHybRTUzaIPGoOzFb2NXH6+FR7P40osFA+dS1+H3pWqCCmUGcOAzIpQWtZx1d62SDZoqc/b9rGAiWzEMKAo1fGqKgN705REupOOrJanXHaph/ubttWKDfcXxHEya1RDS7zgXx5Pnml3qJTnlAojn2Hj4Pj1jhp/ktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0UwOmw5e3EvqHEpZ6YP6xfKCvbNROg7OSuDpmEdnnM=;
 b=igIuCLLSkTHN6VjhwG6rL6StppsNXsOyje2dguSqZUrrKfuDZW+dZOfYu7hR5eqUzdrCUmnTPuvmGwYoI1TR3gj3+IagkFMnHGfui9uUTe+6x0nLI4LkNUbN3HKR4fh/sLfcilTsHLY/U/4kx8YF2Qzq2EFtvN+xpej0bxk7qdGaWhQZWWC/zvLsuq9gM7fl8yGV/JpMNGbe4lqW0uocVy5vUSDu3A9K6BGtZGZKv42Lyi2kKFE2MU1OjvwpgW2zfVMSYa2UPvYPzGuKP3+CmZi9FR6bdQpjzzK54zFk8Wjri9xCaw4XQ+AEaBr8wRy+CSsfqenSOJW77P183j0mKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7323.namprd11.prod.outlook.com (2603:10b6:610:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 17:45:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:45:59 +0000
Message-ID: <1d9b83e6-48b3-4e62-a9aa-09947013c907@intel.com>
Date: Thu, 23 Oct 2025 10:45:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 23/31] x86/resctrl: Add energy/perf choices to rdt
 boot option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-24-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fc2c21d-08a1-4b78-6417-08de125c0678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Zm9MRUx1bnV2disrRnFFQzVpRUNDUisvRXF0VjlzVWJXaUxhSExxSkVpTUtM?=
 =?utf-8?B?RW1XS1oxRS82VEwxbGpNVlorY0l3a0JiazFHQjFXRFFSQVJMVkdIZk56amFH?=
 =?utf-8?B?YjZQMWljUnpJeFAwL2VRL3ZObmJmdVdaQ3lKQ3ZUWm90SXRyQWovU0o4eWJv?=
 =?utf-8?B?aTRkMGhWU3N2bEpOL0R5V2I4Zk0xODYrbTBuMFJmQ3Zubkg3OXYzZThSZ0Ft?=
 =?utf-8?B?ekNHYTIxSGQ5REhLNTkyTFY4WTd4WlJkNEUxc0RDZEpJRGRvamF2RDZkQXZ5?=
 =?utf-8?B?Mjd3azBXK0tnSGNqWGZuYU5oWThqcm9KNU1YaHc4SXozdHlpWUNGRkx6V2Qr?=
 =?utf-8?B?ZHdCYS9QdU5xbTJEam44WmRvTjZtQ3NweDU3QkdpZXdnWDRDVGk3WHdHK3VS?=
 =?utf-8?B?QTR1L1JtN1Y1RERBWTRNTGh2WUVBc1hVYVB6U2ZHNUNOOHhyeEl6ME5uUXIx?=
 =?utf-8?B?V2JOTkJ2cTREdFdNTjBGMnZycmNHbUVQblRBeDkvcWpZWjBacVdjdldDYXM2?=
 =?utf-8?B?SnRZQkJmc3RRTVhBa0IzVXlISHdkeldXZmhhTEU5b0J1VFBJZndwTDUwdE0x?=
 =?utf-8?B?MnMrd2t3UmczZzVKWVdSNGwwdFpISlFEalE0VSsrclVib1U2NmVab2dld2lV?=
 =?utf-8?B?NS9GQmhmWXpjYmRvVkZaMmlMb0k4bnpYZ3ZxVzZZNXh6a1lEZGRqSlhVRUxF?=
 =?utf-8?B?Q3NYMnIwQ2FraWQ0YkJvMU5OSnpsNytocGpFcHFpTGgxclVaQVNQS05PTTJz?=
 =?utf-8?B?Y1FlQzZNNCtyckZqOU4vbGtOc1FueFZHdU92ekRsdHY0NjI1ZnRtS2c1akhN?=
 =?utf-8?B?SXJvSUFheFpoeWJYTExzRUttN1NxbGhSemVtQ0lTcnRPRytqRzlFSXk0SDNx?=
 =?utf-8?B?SThrREVvM0pQaDk3MThqOVFab3NLN1ZXdEJFWXhzM0J3QlVCbm1WMklIeGZt?=
 =?utf-8?B?OXhRMm5sd3JMQTg5ZVU3YnYvWWNmNS9Hd3VuaEpTSUt1bGhYZTN0bXVoUmtM?=
 =?utf-8?B?SmtIYnU3WUJyTXB1Qy9SZXR3MjQxQWZnNEMvNHdtWkM3a1FUYXdQUW1ZazQ0?=
 =?utf-8?B?dDlFdXJkT2tWdm83R1BUME9sNGtJZDFmcWQyQ0pXK016RXZFdEpiTlM0dWw5?=
 =?utf-8?B?OSt3TnBGRUUrd3V5dVkrZ2tTYjIrQUs4U3Q0eFBqWjlsYm5TcmpGV1ZwM0lN?=
 =?utf-8?B?ZzBLZEU4dDVkNFNwMlhRVXZtZkdQVmF6RDFtSitlUFJIRU1QU050TTZPbWU2?=
 =?utf-8?B?YjVKdmJxSlZNTnBpVE01QjhRVE9BVlIwZnFqdHNpS3owTVRJOFdka2NMWmV0?=
 =?utf-8?B?aGUycjhjYW51aVNIeEVzR0NIaDdja21FR2FzL2J6YnVXM0hiK0I4c0NIR0Rn?=
 =?utf-8?B?ZzVybUxyYTJJekVtdmZTOEExaHVJcjYwYUYvQTZFYmt1eUtzL0RsbThWWTlR?=
 =?utf-8?B?WlpFVExiNHhVMUV0VDZFRWQ4RkJSNnlQMUdxeU52MytHaExDb1pkc0NmYjNo?=
 =?utf-8?B?alZFWXJVeHVEaVJHcjZoWTZlS2twQndWeVVHbXAzT1RGZ0FLTTdzeTBEeERC?=
 =?utf-8?B?clZiUnZJRzJFMUVyOXh2VmxrRkhBNUlhVHpQZnVqZFozWlRSWno2RDR4dmZs?=
 =?utf-8?B?dS93bWR2SWdLbDcxNzdnWTI4RGRvaWVHT0hsdlBwNzkzSm4zK3ZCOTY1WERs?=
 =?utf-8?B?blY5WXJ0K3V2UW91bmZneHdhWWlSYklZM3FyZFJCSGV1LzVON0grT0U4dUgw?=
 =?utf-8?B?NEJURFBWOGNWSmhwb1NlZEwxNzFGdXVralA4QVJ0VEtTeEdRc2N5VHdVbmsx?=
 =?utf-8?B?TmdUNUszOHNDQ2pma21HOTM0ZHNZTlM0OWd6djVPQjdHM0VrbUtMTS90SzNL?=
 =?utf-8?B?dk0xWUtzakRGb2YrckNzVHJNS1BWUnFQUnIxbThJY2hVTkovL3pYaC9yb0hD?=
 =?utf-8?Q?BJ/8bp+K2fZIGGuAY1FpvDUr6NozWh6a?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEJoUlFqQnpydjRuK1Y2ZkpoN2c1eDJXTC9sWlZuTkFTcm8vd0V2bERqRm8x?=
 =?utf-8?B?ME5WdTJuam0xeG1zQUxlWHdvTk5yU0VMcDlsM0ZwcXc0cVFhQXdkUDVYNE9w?=
 =?utf-8?B?V3ZXQUdQWVFFUmUyb2ROOE5DNVUrMjBzcmtVdEhleXpnU1ZYM09PS3BsRkZO?=
 =?utf-8?B?TjNGQlAzRFByUFd2cjNXQnkzSEtRTjFsRTBMN050WFZYRW1kM1RldUNlZUp6?=
 =?utf-8?B?NTk0QzhNNWo0ZjkzOXlEcmVDUlo4VUdvMXcrdyt4a2piSkt3STU3dUpHemZ6?=
 =?utf-8?B?cmozNUQvMU4wR2RucHZ4UWtDZnJiZVNTY0ppTmhZRnphQy9McGVTMFF4YVdy?=
 =?utf-8?B?QWpDVFJWTzlDYUNWTklLKzlhQ3pVS2pIdG95NElic1V5c2ZVdStvRzNLQ2Fi?=
 =?utf-8?B?NVVyNzdMWHpOUGI4WWVFYlFpNXh2YWdwSE9iNm94VytqWHRnY0ZoSXVhbUUv?=
 =?utf-8?B?VnNzazJLTTJ5T1FBaForWngrNjdXQXJiTWlOanpKbW4zV1ZqOFVUSlF4SjMw?=
 =?utf-8?B?MDcrL0hsOFd3cE1zM09NZERkNS9nb2VuTkJuZXV3R2JCT1l6c2pqSkVQbkJn?=
 =?utf-8?B?VjBPN2ZoVnREbWRhR2RsV2RHUzZQRmNUWlhBNk90V2padFVqNlBNVjZ2TE5K?=
 =?utf-8?B?TlFCUDFFYUF1Sk9JLzBpTDJ4aFkrc0ZpUmJaZzN3N0ZYQVRRUDJFSTlLZWpI?=
 =?utf-8?B?S2ErRlZxQm92ZWY4RnNrWjRGUzJoNXpkNEJLYWNrMld1ekRlcCsyU2xPRGFa?=
 =?utf-8?B?aERDTDlhWTBMaFdDSWJiV2FMR3c5U0dMQ3A2dnN4Q1J1SW1hWmFwclFOMWcx?=
 =?utf-8?B?am5qcTNEbis2T1g5eDJ2VFY5S3lCMHlZS1JYeUtyZEFLdFB3Z0YrODJXeEtQ?=
 =?utf-8?B?aEIzWjlnTWtpSlRLL2pCU3lybnM1eERjL3EvL2JoUW9tQnBsN2cvZVFmUWVY?=
 =?utf-8?B?blEzWlo3YmpDc0VpL1lZY0hPTWltbGZRbFF4QzFWZk5Vdm53MUd3MHprQWhv?=
 =?utf-8?B?c2FuanhocTk5Q2pic2dRQTYrOWl3clBpN2RUUnVkdE9Nc1hEdWNDMXhRcFBI?=
 =?utf-8?B?UDRuWnlwQmdZSWxNM0MrSC9yTlRPNWVQRitBZ0QxcERmWFVXd2o4cG10QXRU?=
 =?utf-8?B?WlloTmtweTBmQi9tSFordjd0NmNKQjZvNWViaXhzaGF3ZVh1WE9LSXFaMEd2?=
 =?utf-8?B?RU5wT0g3Q2I3MmVaWFIxK0NRR2xTV2ZOVStaY3dJNlVHLytyRy9YcEc3WE5E?=
 =?utf-8?B?WTlheWlYK2g4d2MxU3RGQWY2RWh5cVVDNEVyMUhjTGZiN3g3eDY0ZDhWSU1a?=
 =?utf-8?B?MGJZNmd2RzJXYndkMm5rRy8wZWRLcVpMMit1MGJxQ1VCSXNBWU1ZeFQ4UTlV?=
 =?utf-8?B?cE1nOXVPV1ZkVVU2SWxJUjB3ejVXa0xUaXhMR1ZPRGxjOUI4RTF3QW9ucWhC?=
 =?utf-8?B?emFWMkllZEREVzVzOU4vdGFqcmY1a28rb3RLSHBtV0xvR2U5cnJieFk1UHVm?=
 =?utf-8?B?WFE1VGtyWGo1ZFdHemZaTDZydEtaai9NbEZTd0RSV3pZdllBNnEzMEI3ZjBD?=
 =?utf-8?B?Vy84YlpYYjNaZ0lNQVFTNVBacitWRmJMTlY0akdsaUQ4d1k4aXpVdjZKVHVl?=
 =?utf-8?B?ZlV4S3VWQy80Y2hIazZwZUFsUWIvNWFSWkVOQTZDak9iNXl2T1lqWkNOOXI4?=
 =?utf-8?B?bU9JSldMYjJyeVcwdnFSQnMxYnhmVmhjL2ZuNzFXcmZCZk93VWY0cURmcWNp?=
 =?utf-8?B?aEtFMDFHVEU3SHJoaTJHVGkrekFGcUlBTFRlYmxUUFdrVWgwQTQ1WC9hNnRm?=
 =?utf-8?B?SUhkVjZ5Vi9UTXNWanlwU2dOTHFUNnQrQnhMN3o2NkVuWkJweTk0cC90TWVM?=
 =?utf-8?B?anYvQ0ZRWmRuSlN5dkJTLy92eTVQeTR6WHQ4ZE5obUZmRmh2WDZWL3cyY1Yv?=
 =?utf-8?B?allvV0xpNGxzNUlVMUExNCtMNXFVcWF5aGFHaEhzbG9YdzBVL1hrK3M4MXVD?=
 =?utf-8?B?MU13YjNBcjJpak9JS0dOTFhvK0VQSmtKMjZhMitaOVp6czUwT3ZyaWt3RGRp?=
 =?utf-8?B?d3Z5NzNmOXFaNDlWZHJwMGtQc3ZZRWNRUE8zWElIMXp3NmFWcmxLQnNLcXZh?=
 =?utf-8?B?QTkvUndxOExUTzZmVmVub0U5cHRLMzZRZTdpTGJWV3J3SlZuVWlzUXhBRTN2?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc2c21d-08a1-4b78-6417-08de125c0678
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:45:59.0098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gDOE8Esd6TjNl4I4altdBMCLOd93oIXZofSAEu5aAt4qQfsg2tUrR6niIdtVPp51qkDwwR5wfgmvab3f+3DhQdTcJHpcNEXShh6j8Cu7yqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7323
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Legacy resctrl features are enumerated by X86_FEATURE_* flags. These
> may be overridden by quirks to disable features in the case of errata.
> Users can use kernel command line options to either disable a feature,
> or to force enable a feature that was disabled by a quirk.
> 
> Provide similar functionality for hardware features that do not have an
> X86_FEATURE_* flag.  Unlike other features that are tied to X86_FEATURE_*
> flags, these must be queried by name. Add rdt_is_feature_enabled()
> to check whether quirks or kernel command line have disabled a feature.
> 
> Users may force a feature to be disabled. E.g. "rdt=!perf" will ensure
> that none of the perf telemetry events are enabled.
> 
> Resctrl architecture code may disable a feature that does not provide
> full functionality. Users may override that decision.  E.g. "rdt=energy"
> will enable any available energy telemetry events even if they do not
> provide full functionality.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
