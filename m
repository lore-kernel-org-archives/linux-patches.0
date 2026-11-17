Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794889219;
	b=zyLeb/hBJxW7owPR+Jm6gQosa+0JD1kJHVZVCBkzUvkAGNDWXBHfNvABBrSiNJK1a+Cs
	 ptsNqOcm/6igE0leYd9ALxnTdcmN3G4Zqm5yCZniauBFOrT4V10TaJnVcLlQWe8dNW3Lb
	 c6nQ3JHdnCRyOuOMpgEClY7Io644xjRChT2cLzbsvobXMVwVoeWKJyIgGZ3Ggan7jG1Gp
	 Q0Z1uj9IG3Kav0Alnuhbgus0SlBHOdOweYu7bwIHkh1Wet6A1y5q22mez+Wa51r4MUw/Y
	 0Sp8OC6EiNkwdDaHloU1/g9jMwebSIgg+TPtljDfov+ku3jZu9Q4rm4eSyKU+enh5+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794889219;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:
	 Subject:To:CC:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=y3sC/KtckIe+HtjQtYPGJj3dW874KJBt+vK6iRqim7E=;
	b=x1pvhPWY8HWLuBxD8MsdcEZrOKnJh3SXYej73oBhXJc63gN7gpk7P7soLG60x+23/x4v
	 UkDyPF5n2o171ysBD1pVxibl8nMgOr747bHt7RVmgxepii7qAGFgDuhY2en8TNmt6RYP5
	 sgdBb/Pou4MvN126W3j9xynRwHkxqT6UoWYKCatHj7VzeyU/1zuJXThuLOBNmgZwNCI0r
	 z0/kns/8ptL2uossX1hBbCdYl4enAK10jM84zLS8Hx/iTROI0FUIuxD4vUApPvJgSQ8lz
	 MvsMeE9SCIM3KqJu2l1niOVaKV9geGZ9hHS9C1ZCwDKVwHRQDiwM4kUNaJVn5O53U2A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EkkknqTG;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=BiGWM7NB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8D5606A31C;
	Tue, 17 Nov 2026 04:20:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC8D5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EkkknqTG;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=BiGWM7NB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794889219; x=1826425219;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gTgyLlMgJdFVwDby8Coe1x69LBfv252mQKzu07VjHc0=;
  b=EkkknqTGe8+96uZl8pl1ZJk63ZMu6CECneSWmZCAkRA2NeKxXaoqa5Tl
   RGWfd38Zlm/OaIqZer1ZmcVjd/i94srFGOoPAfqv+Dxe/TCVGJAtCQUsy
   DEEd75oAtL2XHzNwlB+eo71lUNdSPaLhhhGuxIkBXZ44dHJJXvf1nBLGJ
   /yh0ckLjnnLMgem1P2JNlCYPkQcOPvzfdoyIO/qEk1SgmA9PmniaP19hY
   TOYe8DshespdLDIeqoTfPLR7NAJbVR4ydpwQLGRuSvAxt/NiBgyxmdJVV
   dJyAfRRmWTA5nUQBdDVyQXIvl0NbC835PzbJY5CMTiLCoW9k86eQhV/A4
   g==;
X-CSE-ConnectionGUID: WVSFrgu3RyK4CclUal1J/A==
X-CSE-MsgGUID: ZvGxhsJaSgeAWv9bv6f9Tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11968"; a="3536187"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3536187"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 20:20:17 -0800
X-CSE-ConnectionGUID: qx0z3fuOS/GU9mEPlfnBSA==
X-CSE-MsgGUID: VYTtd2PgRQqk4i16R0tfsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="9649898"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 20:20:17 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 20:20:16 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 16 Nov 2026 20:20:16 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.15) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 20:20:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MU7BNcSFv+mxQ8ROEePcGnZzK5D3EDi3itGJXHji5SJFDQyAmMyQhv9Bugd26ygyXBO2e4mskBKE8SKr3hpTGjJvLCpvegfBOHwZQAuetYcQKJffOmyVmacDmDN+OF81x9u2ez2sT2hbRJ79Q1MvS6Bl9VxRtzU0nAGZE/h8iNne80Zm8Sfz+Z203W7N5GkCRscNcuMj/u79Fi7ne4whq+lm/MSom5UVJUKohb7wa5iv+HQDt7l2Z4rVwByENxWBxLK3f8vNVy0dkTrdtmO2y/uGX6VPR1OsqBpu3vSIWJ2q6uPkt0yq5q5JAF7BvXikMGPZlxkcTb6Nqz9K6eB0tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3sC/KtckIe+HtjQtYPGJj3dW874KJBt+vK6iRqim7E=;
 b=m+KvG/Ui8ikSHlLZ3CE3OA6a83HIf47y70q9ABWzlnuMCvjj0zsqtClZICbcgzxGpBAXOoB45wVfmy4LYatl1FcNFcOkvj/sZ0S+Va++iNMmbTaCANKr+YCgLzaxpu0pbNXEcSjJGV9NVBQIuc1RdFQmHTkWEPsrR5kMXQfSy9luwS7tjfDc3GVE5Z/qeTsUwjKy009hQNMIftntMyGlon4SEkSeUHmgyadVfQTRUkBlvtQgpN5x/zmBu6PGCwiVOP0CY40lDYf3j5wvOyYhKjLwVBCSQUZtNB1LB5AvqM9PMSYmbivK1dYQvYeLr10O+e0wRE2atuqCtm3g8NpK7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3sC/KtckIe+HtjQtYPGJj3dW874KJBt+vK6iRqim7E=;
 b=BiGWM7NBXe1jqJOJFzqsrlnvvUMaIwkcrqaCUIM4N2iImgWGd3UxTSG8DOyk/6ZORJl6r/lXRdlbqK7b9rfiNYPzRH9zXTd+TDrqClQHv3EIotqkAwm4RN/CIBXUXEHsN6cMNMkqayF3JaAEtnp302yDWl2QR0uarCaWnNcqivM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA2PR11MB5081.namprd11.prod.outlook.com (2603:10b6:806:118::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 04:20:10 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 04:20:10 +0000
Message-ID: <8fb8b947-482a-48be-8618-32989a840dfa@intel.com>
Date: Mon, 16 Nov 2026 20:20:06 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA
 configuration check
To: kernel test robot <yi1.lai@intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Chen Yu <yu.c.chen@intel.com>,
	Tony Luck <tony.luck@intel.com>, Jinjie Ruan <ruanjinjie@huawei.com>,
	<linux-kernel@vger.kernel.org>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <patches@lists.linux.dev>
References: <202611171056.912725cf-lkp@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <202611171056.912725cf-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:303:16d::27) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA2PR11MB5081:EE_
X-MS-Office365-Filtering-Correlation-Id: 2086c8f3-642c-4bce-c758-08df446210a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18002099003|6133799003|261009223027099003|3023799007|5023799004|11063799006|260925021911599003|260925021311599003|260925022911599003|56012099006|261102123227099003|261028144727099003|261026130827099003|261026121527099003|261026140227099003|10067099003|261021133027099003|261026135527099003|261021121427099003|261021130227099003|261021135927099003|261022075727099003|261022113327099003|261021123027099003|261022105027099003|261022115727099003;
X-Microsoft-Antispam-Message-Info: za+87h9/dC2uvZ6Q+ursxO9jVFPAnfztscVq9VTDBmgeHx9sHKM2tsaqTR2IVgzIH4fUwQbVyrPqf4pikQWuucSaWAoIbpq247pZy/FE+XneI7Oe5tIW33o7T39N36TuDjEwGgKCOyNi0w5BI4Ad3JJVMNUgR4a0vnnI3r8cNCsEuQoqpv3AB6/Ejxsg003DrPgaUETYxPn4je27FDjyqrzaQaYwfXMtN7gCH4rGFB0JGtwQIhH9ssT9whTTw8VTXL6p70eNBE6rsdyep/FufkT8oK0ad0W9bAT/wBohH3hzFGr2RTj+NDdUBD4yAsnyLbEJEY9ZP+349L8oE/16mmjPICmKDhOWuADVnDoA0gvKsh3ErB5vOUVOy2kdI2A9K8UbNCBtLfSVKC3dnA3PdT8HQuaWApk/jTHJlPmFLG2+0SZhkNFupX4LkTJhUNxV2XTkfvrKAp8AjSIxEhXcw/zyDJEmI3HBcYYPocU2e+YXPLmJd/JUHPJk+NGgMiAw/Pn9AVxJtQJlkFY2QbfVgdJ4dGhzDAsoNK2B0YhkO2HyRvpbm+9ywSnqJBJLoRBhRrK0KR40pA4slLzK46YaMUCZNIt7L0j39DAnm+t0g6elF/86BEPQUhjkeoAgq47d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18002099003)(6133799003)(261009223027099003)(3023799007)(5023799004)(11063799006)(260925021911599003)(260925021311599003)(260925022911599003)(56012099006)(261102123227099003)(261028144727099003)(261026130827099003)(261026121527099003)(261026140227099003)(10067099003)(261021133027099003)(261026135527099003)(261021121427099003)(261021130227099003)(261021135927099003)(261022075727099003)(261022113327099003)(261021123027099003)(261022105027099003)(261022115727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTBRRmgybzlUK0xDbHhPS2o1ZEFnVVIwWHRWMDlGWTZMeC9WYTVVUVpmYU5k?=
 =?utf-8?B?cHVHdjAza1piejhwMzU1T3Y1VGZDYkJGQXMvOSt6SExnenBhWTkzU0lDYUlZ?=
 =?utf-8?B?K2p4SDRzaFUyZkdoaWN4bjJrazBjclhOTjU2OGJWYnV0SWl0VEFYM3FVNHhn?=
 =?utf-8?B?RkVDQ3QxMUVnbWpRNTJWVFd5bDVYZ1MvNWhteGpkYnF6RzdUT1NyQUc2VUhT?=
 =?utf-8?B?cWtNS0VnOHBRTkdQN1pGNDg2UDZmTWUyTHFPMUMvWU1rQWVVK0pZL1ZyMEpN?=
 =?utf-8?B?aXNKMFMvQmJVMmJkUlBKc1JEeUUwSjdsWSsvdnQzODRESFNEODdja0pVQnkz?=
 =?utf-8?B?eVpsbTI5TmN4WmlmTG1qb0RiWHhueG9UdjFOZS9PTGlFd2hBRFhUeXpIY29a?=
 =?utf-8?B?dDBac1ZHNGNGMFEvUkJjbFg1cGJySDVJRHFvVmp1aC8vaVQrVlJ3TWVTbGpQ?=
 =?utf-8?B?V2VMcmZhMjM0ZjYrd1hKLy9XeUY1b0pXUGFHRmN2bWZISnlKOXFwS2gzTzFR?=
 =?utf-8?B?MTRZNWlDcDc1aWMxVGxHOTM0d3A0QU8rNGgzQmFhNlRCSmFkOG1FamdzT0J4?=
 =?utf-8?B?OTNJRlQrdmV1OUd2d0JMVmY0V2t0WUt4NXlFQktTRFJOL3czUDJIVkR6VW0x?=
 =?utf-8?B?N3RIZkVPWkJsV3A5VXpoSDBNNkpaUGs3YUUxWThmOE85Qm5sN2NwSnRkZE1Q?=
 =?utf-8?B?VnhMMWxweVBzK24wenZrMmNlMWR1d3ltZzVja01KQXMrakFqZTdhTzh0c2RS?=
 =?utf-8?B?eDBINTZROTA5VGJ6WnJBN3h0d0R4b01FTzFxTzgwbExJOURBSWtOamh3VlFk?=
 =?utf-8?B?Z3h5c09YbVlmcTdPVTNIS3MvczJHeTBZTUU0K0haeDBhdjh3aFBGeDFocEZB?=
 =?utf-8?B?VmlHZThrMGVNTTFIQXdzSTJYelA2V1I5Mk44ZWNFR0NPVE82OUw5S3lUZjBZ?=
 =?utf-8?B?Mkx1VUQzbU15TS9TcDU0ZXZLWGtRTlhldlFseTNwZS9QRTRPc0dQbFhzWmdk?=
 =?utf-8?B?R2FEZG8wc3VwMnRaZkVrbzlLSFg0QzNpTWxTMndDOUtSbFZseVhrTjdZZ25t?=
 =?utf-8?B?TEZPcFMreUtuTjRYVjVheHFXYW5XQml4YzMrMlFBd09JQ0lTcm81a1NPR3N4?=
 =?utf-8?B?Yzl4TUVXc3hndE9QZE5nNGh5Nld2Q01ZK2MxYUdTeWo3K2NIS3FzUjdRRVZB?=
 =?utf-8?B?NFBwSjgzaER0T0t4djQrYWtOZnprS1V1emhHMjM2dWsrWVpMTjBWRlZtTUJ3?=
 =?utf-8?B?Z0NmV3BnNm5aNWMwZGZHbVVyQlNMM2JEQ2EyM1NaN0dKMEMwV09jSFE3ZjNC?=
 =?utf-8?B?Wm1INmJ1am1pYWRUdmpqKzE1NWF3WGhqbXI2anhNdUk1VEd2d2xoN2Zza3ln?=
 =?utf-8?B?TGpJbGVUTUhZM29icUhXeUVOVUgzOGVEQlJ1eUJobzZMNjRUZUdvc3VkTy9x?=
 =?utf-8?B?TVJOS0tKMFRLdHJSVEZWN0tEOVUwb2RXdSt2blJ6UWdXdUt6SG00YndUYWxQ?=
 =?utf-8?B?R0NnWVJWOUZGbEFvWFRoZHk4alpZK1B4WlJtWjl0dTdxamxiRmVkWXh5VXFO?=
 =?utf-8?B?MHlaNUpoRkZWQ1hrQW9lL25aWmVyM2lwcG9BV3FqaktDTzNVZXlLaCtuUk0v?=
 =?utf-8?B?TzZvT04xdDFseEJoS2F2RmwrK2RXQkpLamFLTnBuZlkxK0J3bnptT3d4bG9m?=
 =?utf-8?B?NmRXTThKMWFlTDc1NkV2S1J1RUpISEZOaUVUTjdzdkVNaXlpTXl6cW8rR3lM?=
 =?utf-8?B?NG10WkhPQVpIQlNNRUI0NkpCMUM3aHpMcm1MWHVYbndJTk5Xc0k0QXlCbTdL?=
 =?utf-8?B?ay9adFNCNHMrVjUxYnp6RGZPV3huQXFtUEZGcFdZc2wwSHlJOGZ3ekErYVN1?=
 =?utf-8?B?TThTLzUxcWpacGpuM2h6YmxnekJkN1Fmait1Z0JSUElkeEFOZDFHdGVrRE9Y?=
 =?utf-8?B?ME8yUE82aEV2Ri96VUd3WXJYVDFWTTRQQkVJbXhqTzdaZ0RFWVBKKzJndXpF?=
 =?utf-8?B?VXdGcm42enM2UG4ybTBYTzkyVkkwckpqeCtJVTJBcEY4ZmRqQUlPRlliN0pB?=
 =?utf-8?B?Qml5N0o5TXZuSkNxd0xuVGcyMEJadGowUll0L0M4dkJ3eXZzdjMvSUxVM0R5?=
 =?utf-8?B?UzE5SHpaTkNCc0UvVWtzUzV3WFIwQWlCOWE1V29HcEVIMHlBVFZGb295dm8y?=
 =?utf-8?B?NzZEelBQa05DVUw4bTNlaE0wb2JiSCtQL0JzRWY5OG9zcGZDQWFxMDl0U2xX?=
 =?utf-8?B?eU5mYzkyVit6cVcxcGNNcGlaZVUxRGJlUU5ycmJQTk9Pb1Q0OTIzOUMvTWhL?=
 =?utf-8?B?MkhWVlQxaDcwR0M0aW02Vzlwc3pWRlIxN3REUXhFTUk1WlcrNVZ2ZWZDMjgw?=
 =?utf-8?Q?FPNMd9gZgZyzhWUI=3D?=
X-Exchange-RoutingPolicyChecked: TIPYtO1/t5lGerVmizwIS0P1ZLVoN9TjDN7x3uqxmzlCAErVg6MoV84XfWtlKwnOICZvAjri0yfqWDI4rWQSCQpZt8JDgl4faJO0Q7FHkrdgMyRajIwRPKyBl2Xkg9lvNugxWVGSwDhjZNzJep0D02eAlznKV+k2oZSO5NoWpxMWQmKY0e6fWj6+tnsJ3XmAPQDXPUp82KeOgTkX0kurrJGISoum27U//6JOjaJZNg2otbAMwUnLGHNL9abSaRWGiTl/dPwPIAM+c/W24Y/C0pB3V71VFJEyFyiQ15DR92k9MPVmId7vJwWfJ2JEvewaVbWmOwXQBWGlb0f5AEiN+w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2086c8f3-642c-4bce-c758-08df446210a6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 04:20:09.2524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+tKkG051GzzL5lWVbw4e55WussciCrOOb1uQxfPslNFYyQEBApj1uujwC96FrOWaKGdMNyNK0sNs3mk5PN1SsJOHJE269MDfJ75PQLCsRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5081
X-OriginatorOrg: intel.com

Hi,

On 11/16/26 7:36 PM, kernel test robot wrote:
> 
> Hello,
> 
> kernel test robot noticed a 4.4% regression of stress-ng.sockfd.ops_per_sec on:
> 
> commit: 12a0f554b3d62eb1270d6d60e9c6ab2c07dbbe35 ("[PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check")
> url: https://github.com/intel-lab-lkp/linux/commits/Reinette-Chatre/x86-fs-resctrl-Remove-unused-non-linear-bandwidth-delay-mapping/20261104-161329
> patch link: https://lore.kernel.org/all/7e1aeee81a38a33ca889db68e4c645f935e4e6cd.1793834224.git.reinette.chatre@intel.com/
> patch subject: [PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check
> 
> testcase: stress-ng
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
> parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: sockfd
> 	cpufreq_governor: performance
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <yi1.lai@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202611171056.912725cf-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20261117/202611171056.912725cf-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/sockfd/stress-ng/60s
> 
> commit: 
>   0d4f0ec1db ("x86,fs/resctrl: Remove unused non-linear bandwidth delay mapping")
>   12a0f554b3 ("[PATCH v3 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check")
> 
> 0d4f0ec1dbca25be 12a0f554b3d62eb1270d6d60e9c
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>   56484401            -4.4%   54013430        stress-ng.sockfd.ops
>     940555            -4.4%     899375        stress-ng.sockfd.ops_per_sec
>    3901263            -1.5%    3841842        stress-ng.time.involuntary_context_switches
>    2386355 ±  6%     -10.4%    2138169 ±  5%  stress-ng.time.voluntary_context_switches
> 
I am unable to see the connection between this test and the patch identified.

The patch identified is a resctrl change and looking at the reproducer script
resctrl was not mounted during the test. The kernel config does have 
CONFIG_X86_CPU_RESCTRL=y so resctrl will do its enumeration and then just do
nothing until resctrl is mounted, which never happens.

The patch does remove a struct member so this does change the resctrl memory
layout. The structure changed, resctrl_membw, can be found in rdt_resources_all[]
that is a writable global with static storage. I expect it to be located in
.data. Could this possibly impact the test? 

Reinette

