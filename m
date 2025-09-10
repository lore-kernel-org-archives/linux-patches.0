Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EBD450F2
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 03:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757475634; cv=fail; b=PIUwXpVtQYiL+OaAmQogVcKsDx3E2jz4mx8kbLHUzxkmKbkR4iHF9hq1k4jpEoiv9FyvBkn3q1DNSVrnWDZ5pkdd8XnEsmY31lIwQQBuh8fvMB5f52DzFQn1b0J2j4h8C53bT+fyKZnDinZnTXdlwjuX7zAkTQ5XO4RRyaJoqVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757475634; c=relaxed/simple;
	bh=FNaz+kjl7b/IkiiRMxVv97qveFDiCf6tWxcW2VfcY4Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HxED8E/D7Y0KkqNkgpxijXesI2N8Nq+uW2Cum8It0unTPLy4m4L0fm0kaf+Yifw7+OUV2S/IiRIIFKe0GzlTJYs4D+NGSXkI3jwhL3HOnt1BKA6W9IY1okGwTu55Ig+e2wz76hNfonA79ysxNXmL54AhKxS7iDhnGKjmyOVGe4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bd2GbsND; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bd2GbsND"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757475633; x=1789011633;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FNaz+kjl7b/IkiiRMxVv97qveFDiCf6tWxcW2VfcY4Y=;
  b=bd2GbsNDkLJgQec66fqknTxs6y8Riya+DPDmVlkVNxfY1G0iQfI4c4d6
   s77gqNVIgEd96LShfZPEOiQX9sr5fu53A/dWdBoAJZYgVcH2Z1hNhasD6
   wvpVoBqvs/TIOYDDmbcE38ktffjs+JZqhjFbqa4PkbshUIzXehvp5Q34w
   0oMvelxpM+BDTzhcOCI7qf76ct/SaSpUkyr6LzfUt5nQeNOuK8SX+gxqc
   RV7IDE6x1JF+NeD09AXI3/X1gQKqnSuE9bBrqMIIGOkrQMpx1+Cm2b66g
   Pw306s7HRyN6/R4t5rYGOxO1TrRgpA9kQlBiG6m9BH8I6BtjWMGTWBBYV
   w==;
X-CSE-ConnectionGUID: OfUnGtQhQhKhj4dwEznIjA==
X-CSE-MsgGUID: J4+K3sYeQKyDYAv/bqVvxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="77382661"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="77382661"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:40:32 -0700
X-CSE-ConnectionGUID: x1WvNQIyQiaZvPbn7ub3Cg==
X-CSE-MsgGUID: KteioIXyS2aZKHB1P9OfSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="204259256"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:40:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:40:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 20:40:30 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:40:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V2vU3Z8qS3JTWxwwizbRRLyZhs/hDoYTfZLbd8zFRvHiFWHKig6CUIlUGN79V1Fd1b65YdtYLwFuPekYLfBh83muo2kHniuFtb6heukJaIvxLzknubyKykbBDK06/qYpoJc5StswuMy+rMwL/dfrLQtBQVlHfdUrNRw61o+rpGq/8j3J+4yMaC0MGKrB9Mgcbc0KaszFEgCWAyjYIbtZ+YPEblHY5ljBNWeBY7hCXDjtWPWfNZwTlP26tnfb23p+E3TAzUch0DjYphQ/6pzAh1OAcF2o/BH8YkvYDGATB7nvZZ7uV8XqSKGjKaWHeYtawWR2JFCyIH5PXCuWKCHgTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQm28VHiw0d4QHJaK0Y1QkKlgbGWfEvVLrYXSJTInUg=;
 b=cYWMWcylWwq82iwC6/JC8MmQ//wj292Q1mK3W5EjZftW4dHYEtAk25StO9wFkmjXCpYhXXX1vv/AO6eCbggwBfGQGOy+Qqlsrj6Mn+8ydO7Qsu3Q0rZMQQCfqoCy7VCdknL2QQSQ+ykyiXcJ/T8vvd6DtCbxWq9YQ4oJwJvFFFRebASAZEeynR+cKsxf325QYVupJAeD25/OY71oaGf+XqdEW4BGmZt7GxnLL6jRT9SklbFmUynwCOlEDvup6ajLmeXplF8lzM+BL312Wa2dARVC42QJZq/neHxoCCvta/DYOWsUUVEEZq6wATwk33miFYXNeLL+K5536gvqvR2DGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF66B2E927F.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::830) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 03:40:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 03:40:23 +0000
Message-ID: <8748a2ab-f25f-462e-b769-9afbe0462996@intel.com>
Date: Tue, 9 Sep 2025 20:40:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 20/31] x86/resctrl: Find and enable usable telemetry
 events
To: "Luck, Tony" <tony.luck@intel.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?=
	<ilpo.jarvinen@linux.intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-21-tony.luck@intel.com>
 <9ac43e78-8955-db5d-61be-e08008e41f0d@linux.intel.com>
 <aLiGuhOM4ciPLT8K@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aLiGuhOM4ciPLT8K@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0028.namprd21.prod.outlook.com
 (2603:10b6:302:1::41) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF66B2E927F:EE_
X-MS-Office365-Filtering-Correlation-Id: 962efa6e-d785-4076-68f4-08ddf01bc642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K2V5MThueEx2ZFMrWktrY1VzTThrZmtySXJXaThRbXRMUDhxVHBqSUdQL3Vr?=
 =?utf-8?B?U3VGNVdVaGN1R05OUytNdmlCRzZnZFdEQmYzSlF0ckhZMUtPR2xWYWlQV0NE?=
 =?utf-8?B?S0JBR3FlMytTS25VUTEwN0FRSlQ1SlhtWjhkWlpOZmE5K3R6dkZSbmZhT0FY?=
 =?utf-8?B?OFV5RzQ5UnZXTGluN3QzdjBRNVEwZmFycy9TTUJXakNIajR1SndIM2dDdmR3?=
 =?utf-8?B?bkxtNzNHSnFTQTVNMVdVdHNjV3IxSmg1VllRZUVlZG9ia09IUDFLcm1NbWVW?=
 =?utf-8?B?ZmtQUG1SYnF6TXMzVEwwU3Y5YUlBaGhWNGJmWTVFQjl4bk5rc0pEdklnUjZi?=
 =?utf-8?B?KzBpK09IT2d4eXFES1k2RFNNYzIxNEgwM1F3ZUpDY1hsSUtZMFJuUWpYdzZh?=
 =?utf-8?B?dlpscGJqWEFUam1RR1kxNmxMN2tlb2ROczRLN1MyYkF4dHA1T0pOR2Y0Qjdw?=
 =?utf-8?B?cWZucXh2cDRLSml1cGdKeGk3THhHQ2VheWNxOTArWlQrUlJ2dXNWd1N3ejNV?=
 =?utf-8?B?Zys3UldJZVZrNmtUVXJXWnR3RnFaSmFMN3ZoN0lNSjNIOFNJd0cxTnEyd094?=
 =?utf-8?B?MTdiOFVGRFllc1M3TTVTVFNBVW9JdkwvSmwxUDJQbkM1TWM0Rm9ZQllBaC9Z?=
 =?utf-8?B?TVl3dTRnQjN4b1JVZUExSVNUamFYckdwS1MzcmhBRk1IWE92SXZndkNqZTNW?=
 =?utf-8?B?T1doZUkxZk1ON0tzZ0FtdHNXdTAwN1VBWGZqOVlONHZUMUZzZytXTkZpempa?=
 =?utf-8?B?V3U5WlJ5NDZMMkI0cFN5cGZEV3QyTzRLQ010c3U2ZnAxL3JEWW41b3JvRTNX?=
 =?utf-8?B?Skd5RksvVFFUOG5DbGlpNHROMEhwR1FSNnZpVWhYb1VrdFpJVTVQak9Tbk0r?=
 =?utf-8?B?c3loVmtEUmRHZVhrM0JmZkxZT3Zud2NoMVdERVR0c0g2QXFBL0xTYkd2c3A4?=
 =?utf-8?B?R2pOYm5TZWFZcTJpY1FTeS9LRDhKSC9SVXk4U1BWTkpiR0Y5ZWNYaDM1cnJ1?=
 =?utf-8?B?Vk9oODdRMWdNeVVISDcxNlc4RDY1QTFOV1l3R1M2V2VIR2ZPRFgrTzZzeEFt?=
 =?utf-8?B?MHpHOUNPL0QvS3JZVlhvVnpGK3N0QzczVWJZMFplTDVHZStJNHREQUR2RU1a?=
 =?utf-8?B?VzVtZG0xazFoeEQ4bnEvcCtvTHRTenNNU243RkRvdUIvR2l6QkpmdUZUazht?=
 =?utf-8?B?OGU1NU5oTkFVaFVPRzI2Nk8wY1pSemxZOVA3WEhSL3dTdGR0VXEzL0xtQlht?=
 =?utf-8?B?WDFhR3FCK1Z3TVpscGdQT0hOQlZ1RmorRzJQcU0rNEhueldBbDRCTHVPeENE?=
 =?utf-8?B?eGxqUDhqRmwyUEx6SnhRQjhaWVVjQk52a0ZrWkFqRGxIamxVRVMrSVo2UG80?=
 =?utf-8?B?SG9iM3dsdDB5WXltVDJYNUh6YXgvSEdCZTdLaGs5YnBqZ0lyUjhYblFoZC92?=
 =?utf-8?B?MXFaa3gvWitBUE9ZMVBoUDU0SitsV1dmZ3Y3b0s5TUVPc3dWcUs4YVdqTXAr?=
 =?utf-8?B?KzlzWDFPbDg1NUN3WmZMQ0dONi9yQVVFZmxmVjd6UjJGaHZqdUpwQVc4YnFB?=
 =?utf-8?B?c3VlY3BsN2xzKzUxMk50NVpmdWhjbWtlZWZ3bEZlOHhCOFlxVU1BUTFuVFJW?=
 =?utf-8?B?eFBOZlFQMzNFYVVtS2NySjk0UG9YV2hicE5rSS9DODVROXpZODhFUTV1bWdJ?=
 =?utf-8?B?ZlMrT0YvU3A2U3dGd2FQMXhPWWlNMjFOMVdxY09iMHZzeE5YR0VoczhDdm1S?=
 =?utf-8?B?YlRyWVI3RTFLOGxBdHlCUFpqUTBUTnVCWVAyREZLbWtlQWFRWUlEUXVOWlNT?=
 =?utf-8?B?S3Y4TStTTDVBRFRvSGp4NWZZandtMnRHcU5VTC91NCtVd2NtN1MvN1dDbUxB?=
 =?utf-8?B?MkR4dFNsOFZ6TkVXOEl3N3djTE90SHFWMmdRU3JxKzJ1eFp5UXM3TGo3dyt6?=
 =?utf-8?Q?sqAyY6x/Wp0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlFPTGZEQjNvR3BNUG5FT0FnRG5tVkhMb1A3MjJsVE52dE9leEpRbEkwVENQ?=
 =?utf-8?B?OVVnNUc5WnhJNm1QeUxLc0pML0l1QVdoZ3lWZ25vTkhIQUc3eWd4c3pHeFNU?=
 =?utf-8?B?SHBiZTd0dDV3Z2x3VnRmWU56cW1iRVM4RUZyeU1jc0JCdU9MTENqQVF5WFd0?=
 =?utf-8?B?cnJhMndxa2RKUGtwbE9DMlU3eEpzTUIyVGFnOHViYklpWHZTVEJ3WEQreVpG?=
 =?utf-8?B?VGo0bGFkMmFDNjRyQVY0ZVFSeVFhR1l0Vm5iR0ZCVXNHZkdOV2J2OHg3QnlE?=
 =?utf-8?B?RTVpVjNlY0FBcDlOb3NJdi92Q3JTdVJMSmdMd0pjcTY4c2cyeUcwTDdKLzdj?=
 =?utf-8?B?MmxYT2tQYVcwd09MMzJQemVWdDRTWjN5a1NLeFZlSG1lNTJxVmxZMFJQdDJp?=
 =?utf-8?B?clFCK3dRM3JHekNiVzBYYzFpTlc4cWNPMmdWTjN1NXVjSGpOVlE0MTlQY1lv?=
 =?utf-8?B?ekdiRXJWQ3hXdlpzdk5WMHZrcnlraVprNm1nazNYMGdZczF5Z3dwQStHRm5K?=
 =?utf-8?B?em9EcHlrY1RkclFZbHNnQWJ0R1NsV3V3SHVtRnhiRW1WSGd3WFhLOEZzVEo3?=
 =?utf-8?B?c2NDY1IyZ0NzUzNHd3JmRTFqTlhnME9mczlPODU3R29KUi85RHo5SmlVbXB0?=
 =?utf-8?B?NXhyK2MybWVpczhnWC9jc2hKQWFCYkw0K0krQmNKdHBIRjVhcnhFcUJ3WWtK?=
 =?utf-8?B?RlpXc2hLZE55VVNpVzZwNlNwMklsMC8zV3lsTlhGMnJEVXhwcmFpaEg2ZENl?=
 =?utf-8?B?dE9XUXFvblYxQ0VvUHNZNHZDNjhxeGZiT0hUbDlzUDBGRWVDcjNNa3FTbkRR?=
 =?utf-8?B?Qm1yKzg4cmdYV3lqRS9CMkpiUE1SbnRCWDYzT2RpV3I5bUxTVTZTQnpTKzlT?=
 =?utf-8?B?YnhyZ1o5RFNEQlczS2t6YTJrQmFPL282aG5OOHRMZlQ4S3ZSY1NDUURzMEsy?=
 =?utf-8?B?VnBRa2JGL2w2OVM5UWg1SUhtbloydjVuT0RZRHk1NENCMURvUDEvbVhkM3ZC?=
 =?utf-8?B?TDRKdWErSjUyWUlFbjIreVMwSzBWQ2FuZUxEWWpkQ2RNWUg4MHBvV0p2Yk54?=
 =?utf-8?B?emorVkFhdEJvNURVb1E0cmlEZUhTbFlCR2NlTlE1N0psRFYrZDhIMXdRc1JD?=
 =?utf-8?B?MlVCTnk5QmV5MWNtd29EY1JNVFNENVdjRSsyVWRsaGE4Nzk2RHNMNU5NOXUv?=
 =?utf-8?B?N2JkNUtZbi9YTEk5RFNiNkNua2RwL2N5RTdsMUYzZlBvbEVIUmpDRmE0UHkr?=
 =?utf-8?B?dlB3b0laUlorS2RJZmgrT0prbjg0NWJPNnQrckovdG9jZVpPUHdaT3RWcEJB?=
 =?utf-8?B?dEpGbFNUWTBLZDNoVzc2YkxxdkMweEVlZjdRdDZkRnZYQTRqMERFaUJPMnJs?=
 =?utf-8?B?WlM1V0IyWHBnNWFla3lEcWs0M3NEWlR6N0dMalZ0VUI4UmNHelJRdUJ3Zzdi?=
 =?utf-8?B?RThqZHpOQUNwRUFQeUFIRm1pcVRhdUhCMUthM1h4RkM4YjdEaE5ONXBPd29E?=
 =?utf-8?B?UFlNNXNBYTlTNkVnZVlDUlhzMlJGWTZiSWs0VEpBZEVjMU9wL2ZTNkZiTjRI?=
 =?utf-8?B?RGdBeDlIb2V6Y29mOUE4cUdkRGdpbmp5OTloMzNqbGFVUWV1RjZPejhjbW5I?=
 =?utf-8?B?dnlFSmlvWWJDSVMvSTJoNzJDamtNcjZQekNTOTUvS3BVTUd6RmRuWjg0RWpj?=
 =?utf-8?B?Tlc5MDhuVWg3OVNVcFpYT1F0V0tSU2lvd3dUdThIS0hWUDkyYWR0dHRoWVRl?=
 =?utf-8?B?T1o4RjdnY04rWHJVQmVRY3hKaXJsMnNQdXdYc0VXSDU4Vy9WR3hRTzF6NDN1?=
 =?utf-8?B?ZDk0cStwMmEwZnAyc082ZFdiVkFSRjNGM0kxVjdhZ1JncjlKRFRQNjk3aWRY?=
 =?utf-8?B?MHdXZDRJazA5TEhmaVljZUdaTTFZNlhTUWF0bEJsY0lTZVU1dmsxdmR6M09z?=
 =?utf-8?B?WUNUcElrOERIeUZXYUFMY21NUTgxSHRHZ1NLbHNWYUtzc2tFcDYrMm5jNzV2?=
 =?utf-8?B?dE1iRm91UnlGSTRRQ3pENFZFNlRjZ0FvRjZkUyswK0lNTDN3MUxwY1U1NTBC?=
 =?utf-8?B?a1Ayb1MvYUU0ZUgrSDRqeVh5eWZmMk5HVHN3VW5EU2pkWEltYWhVSWZmWmVn?=
 =?utf-8?B?REE4RnFLaGJyUHErVUdHRDQwZEtudWhIZHVoWitnbXFnYm1pZ1hGTjFIdXNa?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 962efa6e-d785-4076-68f4-08ddf01bc642
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 03:40:23.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V75gm3BKFEnbfxHnzjLBsKrXMu4heUglr+XQYt9oXm/SvyGdBPXMEzWkbC0BhznFE7/OC6wV4qZKAKTUB4cl6s9oFMWl7iTfi7ZrbN30f/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF66B2E927F
X-OriginatorOrg: intel.com

Hi Tony,

On 9/3/25 11:19 AM, Luck, Tony wrote:

> 
> Updated patch with changes applied below. Also pushed to
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git rdt-aet-v10-wip
> 
> -Tony
> 
> From 19f90ec0c526791be589fe3ff4797536f7e9e9c9 Mon Sep 17 00:00:00 2001
> From: Tony Luck <tony.luck@intel.com>
> Date: Mon, 25 Aug 2025 10:47:06 -0700
> Subject: [PATCH 20/31] x86/resctrl: Find and enable usable telemetry events
> 
> The INTEL_PMT driver provides telemetry region structures of the

"INTEL_PMT" -> "INTEL_PMT_TELEMETRY"

> types requested by resctrl.
> 
> Scan these structures to discover which pass sanity checks:
> 
> 1) They have guid known to resctrl.
> 2) They have a valid package ID.
> 3) The enumerated size of the MMIO region matches the expected
>    value from the XML description file.
> 4) At least one region passes the above checks.

Above describes how resctrl determines "valid" telemetry regions.

> 
> Enable the active events in resctrl filesystem to make them available to

This jumps from "valid telemetry regions" to "active events" without a
connection between the two.


> user space. Pass a pointer to the pmt_event structure of the event within
> the struct event_group that resctrl stores in mon_evt::arch_priv. resctrl
> passes this pointer back when asking to read the event data which enables
> the data to be found in MMIO.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 38 +++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 93862060652a..e36b3790733b 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -20,9 +20,11 @@
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/overflow.h>
> +#include <linux/printk.h>
>  #include <linux/resctrl.h>
>  #include <linux/resctrl_types.h>
>  #include <linux/stddef.h>
> +#include <linux/topology.h>
>  #include <linux/types.h>
>  
>  #include "internal.h"
> @@ -111,12 +113,44 @@ static struct event_group *known_perf_event_groups[] = {
>  	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
>  		if ((*_peg)->pfg)
>  
> -/* Stub for now */
> -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
>  {
> +	if (tr->guid != e->guid)
> +		return true;
> +	if (tr->plat_info.package_id >= topology_max_packages()) {
> +		pr_warn("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,

%d -> %u?

> +			tr->guid);
> +		return true;
> +	}
> +	if (tr->size != e->mmio_size) {
> +		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
> +			tr->size, e->guid, e->mmio_size);
> +		return true;
> +	}
> +
>  	return false;
>  }
>  

Reinette

