Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653B919D087
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 21:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752011184; cv=fail; b=psuBT/WdWY73HSD7OxSpccnEAqtFKCmUILp6rKxABsJczNBsnYcJp9ZBCpvDH5vRyDYt99HzlPisdc4NadLUvzfAEyQF2C1K+tvCzHMCzYvdnRVTItFV89f5x1iubdfnLnUNG3aYlz/8B+K3A/MHI8uzbR0mdZMhTjZumCtiDVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752011184; c=relaxed/simple;
	bh=I4N5VwZDkoidgbk2uGyrt+XNjDKD8PlI/Fw1HvKArAI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bdOvWkeleeqfGy04jzSMucN/9A2M3YGqzUkwOAQH63TnrR4WD+OzJMCMDQje22gGOWWW41oW/KYewD6wVslg1EK3/BrWbdURPzGPYXdyiEj+oCofNUo4CHVENPWxjsXKzhkY022oiy/lIf5EhmpTp/SeCXnZuj13TOqxnWxA0m4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UqiWuYoA; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UqiWuYoA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752011183; x=1783547183;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I4N5VwZDkoidgbk2uGyrt+XNjDKD8PlI/Fw1HvKArAI=;
  b=UqiWuYoAuLybZ+cdBaWUbX/4H96nXQSBbtmpy7BO/fPTULGYjqMk0vp8
   TmM8aBHUVdSO25+jZ/OseRnOEDizabRJXL0wbZ0B3cTTxK+wx7DCCNc+z
   9rq5mRwXgs4CSJOm/ZFWIFDzGXiKEmAvSjD6TZgm37UGmZ8EIVx2c+eF/
   6CsLDd7BGcdwwu4TMos0C5B+tGG1u6qE3FPd4bsHs8wk1yqEKDDlY7ldg
   +8RJ8JP0x2rIc10+8Y4qP5UL+5BlJF+8NnkVHPd63Jx/moqgcNp6XvTNO
   GycM/uKax/aIGyLM0rj2Vare0p/Wen7YDDFtkzA+pGVCpJVdbG7O5PFOY
   A==;
X-CSE-ConnectionGUID: tPABFAAJROansnQTYKvILw==
X-CSE-MsgGUID: NloVYlqCQ/Gj9Pd91ED1UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="53982641"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="53982641"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:46:22 -0700
X-CSE-ConnectionGUID: z9ROTJwAQEGIj27Y/iilgg==
X-CSE-MsgGUID: 1/b7WGyZTmuZkssM7RJsoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159868460"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:46:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:46:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 14:46:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.86) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:46:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kI81HIoHdB2jqIMt9D54r5p10VN23SdCGiSQCxZQQDciGE4xCiyZQWDyf/Q7/OW7Y4bYfE6h+aMUSJUyx9/5FKhyNFxWWXuJ49oj6VAV1rVVo0Xj6w6yhCOuEMU3a65AG+6gKtUamJComoe5xXwHrczWmePEzSSKwHimm6yTCe3QSXENrpLUYihJSnITLykpgCztlw8SPxs/l7WMS5YUb/wZYx7U85pVJPC42jvjddY7uDidXZxAOf1E2O5S80zmg5rwG3R/INo/mbSBXBWYjndRs3Qfza1JCjpY+6scf4k7JNqgdVz96v0ftQHXW6tDuZgsbezJ0frEowDGcAIHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfvrk+M3m8fJufgqdnOwAdGtUyFxyOBdBBGP0JN9EVM=;
 b=YQnYzTxgagAf6mJ4ClCnLMepM0tgG2QRDbHhSx5DBPSWVZO4hZJ3lzIVURzxUtZL4ciWJmB7LTv1gfIHXJNZMj/f/NgF4sswRHfiW0/qkg/R9banyQ970fMtP2h18L0BmMH0KXWs2F1y4IWwyAVOLFlaA/TMsw2on9wNihvdAb6OHj5btbO1HzqtuAQzIOvugCP/tGDQBiXUfRjWsB8wkbnsteZeEZM6LbfcGpNc7Ng8egO1MCx7Gu8EJBMkBXWCIzjPJ1sCzTU8xdrJuC+AXWAw2z8sSdmJ5jOEAJKavvFgDFnmU2e1YlFuEeV8d9O3HCQ/9zf51UnkrDHC8nckFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7882.namprd11.prod.outlook.com (2603:10b6:208:40f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 8 Jul
 2025 21:46:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 21:46:02 +0000
Message-ID: <8214ae1f-d64c-496c-b41d-13b31250acea@intel.com>
Date: Tue, 8 Jul 2025 14:46:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/30] x86,fs/resctrl: Support binary fixed point event
 counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:303:b5::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7882:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aa42712-2df2-4510-51f7-08ddbe68d53a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OTZqMW16dzhlMDJuVG1zVnprb1Rla3dvK3R3WWVtMG1qL3BzbnJ1eS90SGNu?=
 =?utf-8?B?K2pDQzdjSkxIVkk5dndKTWxCVEM5bnhwWnV1WDZ0UjhTY1lMZGZ0UHVjL1FZ?=
 =?utf-8?B?R1VVV3lwM2wvOUtJUVNXeUtGL21jTE1CQ0tCODlUbUNZK3liY05kVEtzbWQy?=
 =?utf-8?B?ZU8yQXpYOGVLYjNVNlErR2JycEtGd09ya1M2V045eFdDRnBuUjNwV3hrNVRD?=
 =?utf-8?B?YVFCcTVoTzRvT0VRQlVERm5neFFNT3ZVbDlQYW8vQ0Qvb3NIU05kbXVYdFow?=
 =?utf-8?B?VGI1UTI1WkdWdkRZekV3ZFRoK3hudTJEK09Za3RQNVk4T1VUYWZYdHJJMWlq?=
 =?utf-8?B?VVJOdlUrQlZZQzZMbHM1UDhYc1RORGk2VzcrZGNsN1VVU3NqVW90MmxBTm55?=
 =?utf-8?B?QlZncG53UkdNckZTSlcyREs4am5VMVdXL0QzQmJuQ0JlOXFkbENSTG45aDBB?=
 =?utf-8?B?QVV4NHl4OW1lNEpkY1BFVDlNeVp6QWhuekdleHpTTVA2MmdrNzEvZzBDdU5U?=
 =?utf-8?B?UFpSek13ZHkxcm5aUXlla0I4NjJJR1NUbWJSbGtjS0F3QzJWZENEb1I0MkVk?=
 =?utf-8?B?VU16YTYzdzM3NjRFMjg2NDF2azNZNUtvQ1lpTDBPcm10dUJjbGZsN1k3V25Q?=
 =?utf-8?B?OHBGVzAxMkVzU3ZHNjlVZExrMFQ4RVUrWm5QQWFYSkhhS2hvSG1UcUQ5ZmM0?=
 =?utf-8?B?MFIxSzZpeG9vVFphUUFKVkJ3RkYybVVyMWdOU1FnR0k4WDdWaGV3S1JUdThU?=
 =?utf-8?B?ZVhiTXQwRGFkUnJaeXdJWDRuem1VWmxzVlp0cTdNckphQWlwdHMyTzJZaGVB?=
 =?utf-8?B?anNtYjBHY1ZuWVExK3BhZGtKZFZyaG9EMXhxQ0NrUDRWSEdOSEFuYzUzaXNJ?=
 =?utf-8?B?L0ptbDViUlhpZjRDYkpuSG4rZXpxbUZnVUE0K3grbEs0QUNGU3psNVdXY0Fw?=
 =?utf-8?B?UGlsWHk5VmZaWUpyYXFRM2JDMVcrNVhGK2czelJlaFVlZE5acERFcFVaSU1i?=
 =?utf-8?B?ZGhnbnp0TTZySHRpYXBTUHppdW5vVjhmQUtHcWdlSXhnN3dsWjdNRkFuRm5B?=
 =?utf-8?B?N01ub0cvMzBxdjZnRDFieTBWazRqK1B1cHJaem5IcnRGVUo0UVViYnVJYlRM?=
 =?utf-8?B?TDB6bExvU1ZBdVlNZUdhZys5cnMyVEo3cCtrdE50ZElnM0luazVDRWkwMTd6?=
 =?utf-8?B?NTQxbUdYLzFQWXBhSUZRcHQyRGwzY3dteDlBcUs3bXlBNUxiYUhUY1FrcWx5?=
 =?utf-8?B?UXkzb2ZwVnRMKytaSFlaTFIvQURPK3lyRDhZWmhRN0xJSW5FM0NpQkRiUGts?=
 =?utf-8?B?RDJ6NmVmNWZIMXByOHVYTmo1K0JBc0phNWIxelQwMEI0cVA3cjAyRTZ6NFgv?=
 =?utf-8?B?akRFYUdwL1I3OHVwcXNGczF0ZWZIVE1JODhUV2s3Y01mVHhGV09PZHk3RDVv?=
 =?utf-8?B?ZllZVnZyWXpJZlVtUDJsZk5vaEF5a0JVUCs1QUl2WC81OUFLblhjUXI2WlE5?=
 =?utf-8?B?dHBkVVNXbTc5TmVjTmxtVGZjQkVOeDY5NkVJL3M3TFlsaUd2eW9TYU9ENHZE?=
 =?utf-8?B?NnRLZWN4ZzJ1b2xiaXdBYWlIVXk0eENxZVd5MHY2SG1VV2w2Znplb2J5NVpW?=
 =?utf-8?B?ZjZCOGNHR1FrZUcrNGUyem9Na2lmME5GNXNBQzlNUDRxTWp5ZzMyYjR2RU5v?=
 =?utf-8?B?TVh1eWZsVi91bm5CanpVeTgvTFUxYTM0d2JIRlFIOGp2S3ZyUHI0dHV5Slo2?=
 =?utf-8?B?Q1R3ZFhjU3dXQXU2bG9rNnVWV3ZzblFJdkYyWVRnbzh5MWZGUFNLdEk5Y3Z3?=
 =?utf-8?B?MDJENDhLZ2dNR0NaTEs1d1Q2SFJVMnJremlJb3o3SnN1aW9WZ1hyU2dWQ1pT?=
 =?utf-8?B?UkZwQXZ0dHRMZ1crbC9NeldpT2x3ZVMvNTQ4R3BwNmpoQ3dCVGtlQTkzcUJS?=
 =?utf-8?B?dmhUdU4rWDU0QUpjZ205S1ozNUNuRGJKUGtnS3kxbStETHM0N3NSakptUlRX?=
 =?utf-8?B?bDdKUlUvb2ZBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmlhbnpuUy9pWTZmVkUwM0luZkNGYW8rdVFza25jaktGNVFaVTNkM0REQXBq?=
 =?utf-8?B?Z21xTXlaU21CR1RUa0VQUndoNTcxNzh3RnFIakVsNnhXRy9LaXZGK3BleXVo?=
 =?utf-8?B?dDF0NEFBRGxmSXNkSmx2YlR1U3ZncFBtSVBrV09zU2o4T2NteEZ2a0ZscHBh?=
 =?utf-8?B?L3dKYllDVVdpNUV2bDFIY1RtUkl2ZU1mOVBDZUs2VjdQcm9HN2tROExaczZs?=
 =?utf-8?B?MFRhMExDU3p3NTN3REJQWVd6U1dIbDg0QVVBMzcwcFg4eGZnOElOSXhYb2k5?=
 =?utf-8?B?Si9NcTA4Y1FJbzF0U1cxNHdaQVV4UlpEcVptNmMyR2lEaWc2M2VFYUd5emQr?=
 =?utf-8?B?Syt4OExST2FpVkU3c1cyci82Y0ladXdxMk5Mc2Zuc2V5aEI5L0F0ckRjSVpF?=
 =?utf-8?B?VDBqNEZBS3JUdWV2dGt6T3RlVDgxbFFPeFB1cWl3dDB0Z3o3TkwyT0N3T0xF?=
 =?utf-8?B?cHpzUTNIQ2pLQW56c3hTdWQ4ZzRTODFvc1orYm5oQTNBcWdrQnhoa0tEdlho?=
 =?utf-8?B?eFBETE9yVXJlTEhXM3VoUVZ0enY3cm9NQ3ZhYjBOalJocmk3eXFNdTNVR25N?=
 =?utf-8?B?UXhHcHEzQVowUFNtayt6aElta0lHSm1uN3dZOHBmYk1MYXA4Y0M1dnlNdSty?=
 =?utf-8?B?RE1jWEhjcGhpT1FRYzBUQURPZVB0eVhBM3IvRm5lLyt5MTZGTEErYmNMRlUy?=
 =?utf-8?B?Y2tMSjBXWTR3OUdXdHp0cHhSbU5BU25HdlIxS0JnS2Z6V1FqZ1ROMFBPRWx6?=
 =?utf-8?B?a2F5bGdXNkFNUWVJaXpsdWhlcUlpRDRUK3ZIZGE5Ty8rckxIWFR2eUY4L3Fv?=
 =?utf-8?B?RmFxSnFuOWlKcU4ra3hmQXBOSXNSNWxwTjB5T3ZVMlBERmkwcHZLRy9HM1c4?=
 =?utf-8?B?UVZtRjlyZXJ6RFg4VGhxNEEvc2tuT0o1eWhZVlBrY2trRmliTk1UcGl5K2Va?=
 =?utf-8?B?TXA4bEVSSHRsa2M3eEN0WldpUThhb1ZndlJnSzNpbmtjcEUrSlRWVVhPemR3?=
 =?utf-8?B?S1ROTnZvdDZqYk8wVXQyUithMUkrb1MraTRXcFVNUTIrUXNwd1hpcnpjSVNN?=
 =?utf-8?B?WFhwWUF3eEJJTngyVW1IdnNvWFIxa21WUnlnLzZ3T2JISHVUeHVvOXJ5K0s4?=
 =?utf-8?B?Tko5bDNjOGRBN3JUM3MyT3NENWlyRXJ2MWkwUEwwTXByN2lFbjFVZ3hsanJu?=
 =?utf-8?B?eCtIeDlBRktwdFZ6UXNzL1hDVkFIV28wWm05cTcvVGNkTzRsSVJpMXhGZ1k4?=
 =?utf-8?B?NC9pb0tvOHF2V1czcnptOGlVVS9xQ1hjenZYbllYLzgyeEFmNk45WDRYZEln?=
 =?utf-8?B?N3RLYUVZUlFHeE1URFV2MUZoU2Q2ZzVSbnVTaUxVYVNMdjBheW1MYWNDTThV?=
 =?utf-8?B?TnFYeE5DeVVFRWxJZEN0aXJYSFprMEhHOWV6dWtoeUdiRzJxWFE3TlNUYmFC?=
 =?utf-8?B?Zk1WWHVZb0lKUFJyZkVxbWtTNXFBZkg5WEg5em5vS3psSURhS2NzVDlFUGdp?=
 =?utf-8?B?MG1oOUFMOHNrVDVQWFlJaExvZTcxMXpIc3o2SXA1bFlIcE9DNnBuVk9vNlBD?=
 =?utf-8?B?ektPcUhyN1JzcFZRVzd2aFowNjhrVjNXcStzdUhQWFJQeEFWUkt4VzNCV09I?=
 =?utf-8?B?VlB0MG1mQkpKS3VYOXpMb1VaTWhtUmNEeXlTeHF0dmxiMUlBenZVaXlYOGlW?=
 =?utf-8?B?dkgydTFrN29GcXQ4OEZkVFN6RitPQXV3QkJlaElqdVQzMUZ3NmFwb3c4aFhk?=
 =?utf-8?B?OCtxWmdoOUp1K0IwSmthMmRXejdtcDlzdHMvOS9VU3lOREFLcmtZOTRHYk0v?=
 =?utf-8?B?M3hvTS9JdXF2Sm5FN3czN1ZxSjAxeHltWmVEVCttaUg0T3FKOC91dk9DQ1Y4?=
 =?utf-8?B?UjgzLzFFa3JqMlRlSC9JdUZTSzQ2L2NFTlR4OS8xczg2WitwVExkZnk3VTgv?=
 =?utf-8?B?NFJ5SjdYZmpBNE1WNWRRUFJtNk1iU2xtUnd0WE9XbTBuWVBVN2VJYXo2MnZj?=
 =?utf-8?B?eG1kRTRYajdxS0sxektpRXB1a0FSNnB5QW1IZEdaZm1OK2srN3dGV1NvY3Fi?=
 =?utf-8?B?aC9wQVAvYlZjRzIxZTJNTVNZZ3dRLzdZdzY3akFvdnhJakpya3krN2FrYWkw?=
 =?utf-8?B?L21FRVp3eEhHVkxYc2tROUc1czZ1TDFTdWZQTURKWDJOZFBxY0hIdWREb1lZ?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa42712-2df2-4510-51f7-08ddbe68d53a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 21:46:02.1657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8P/+qb9o9bYxdPKCoXhXGvKiTZxfZndJSUJN0QAARE3Si+AF0zLi4pDfukKiJ4Kx7PSjm2eZ8/Cp+8P5qwlrFN9TCvbSmwohE76WCObjOjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7882
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Resctrl was written with the assumption that all monitor events can be
> displayed as unsigned decimal integers.
> 
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
> 
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.  The file system will
> only allow architecture to use floating point format on events that it
> marked with mon_evt::is_floating_point.
> 
> Fixed point values are displayed with values rounded to an appropriate
> number of decimal places for the precision of the number of binary places
> provided. In general one extra decimal place is added for every three
> additional binary places. There are some exceptions for low precision
> binary values where exact representation is possible:
> 
>   1 binary place is 0.0 or 0.5.			=> 1 decimal place
>   2 binary places is 0.0. 0.25, 0.5, 0.75	=> 2 decimal places
>   3 binary places is 0.0, 0.125, etc.		=> 3 decimal places
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  4 +-
>  fs/resctrl/internal.h              |  4 ++
>  arch/x86/kernel/cpu/resctrl/core.c |  6 +-
>  fs/resctrl/ctrlmondata.c           | 91 +++++++++++++++++++++++++++++-
>  fs/resctrl/monitor.c               | 10 +++-
>  5 files changed, 108 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index e05a1abb25d4..1060a54cc9fa 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -379,7 +379,9 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
> +#define MAX_BINARY_BITS	27
> +
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits);
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
>  
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index f51d10d6a510..4dc678af005c 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -58,6 +58,8 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   * @name:		name of the event
>   * @configurable:	true if the event is configurable
>   * @any_cpu:		true if the event can be read from any CPU
> + * @is_floating_point:	event values may be displayed in floating point format

To help be specific and match user interface doc in patch #30 (and supported with a change
to this patch, more below):
"event values may be displayed" -> "event values are displayed"

> + * @binary_bits:	number of fixed-point binary bits from architecture

Please append "only valid if @is_floating_point is true".

>   * @enabled:		true if the event is enabled
>   */
>  struct mon_evt {
> @@ -66,6 +68,8 @@ struct mon_evt {
>  	char			*name;
>  	bool			configurable;
>  	bool			any_cpu;
> +	bool			is_floating_point;
> +	int			binary_bits;

hmmm ... first hunk of this patch uses "u32" as type for binary_bits and
this hunk uses "int", this mix of types is not clear at this point.

Since "binary_bits" is used as index into array I do not think "int" is
appropriate. How about just unsigned int throughout?

>  	bool			enabled;
>  };
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index b83861ab504f..2b6c6b61707d 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -887,15 +887,15 @@ static __init bool get_rdt_mon_resources(void)
>  	bool ret = false;
>  
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
>  		ret = true;
>  	}
>  
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 2e65fddc3408..29de0e380ccc 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -590,6 +590,93 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
>  }
>  
> +/**
> + * struct fixed_params - parameters to decode a binary fixed point value
> + * @decplaces:	Number of decimal places for this number of binary places.
> + * @pow10:	Multiplier (10 ^ decimal places).

To help be specific:
* @pow10:	Multiplier (10 ^ @decplaces).

... but I wonder if this cannot just use int_pow() to avoid this hardcoding?

> + */
> +struct fixed_params {
> +	int	decplaces;
> +	int	pow10;
> +};
> +
> +static struct fixed_params fixed_params[MAX_BINARY_BITS + 1] = {
> +	[1]  = { .decplaces = 1, .pow10 = 10 },
> +	[2]  = { .decplaces = 2, .pow10 = 100 },
> +	[3]  = { .decplaces = 3, .pow10 = 1000 },
> +	[4]  = { .decplaces = 3, .pow10 = 1000 },
> +	[5]  = { .decplaces = 3, .pow10 = 1000 },
> +	[6]  = { .decplaces = 3, .pow10 = 1000 },
> +	[7]  = { .decplaces = 3, .pow10 = 1000 },
> +	[8]  = { .decplaces = 3, .pow10 = 1000 },
> +	[9]  = { .decplaces = 3, .pow10 = 1000 },
> +	[10] = { .decplaces = 4, .pow10 = 10000 },
> +	[11] = { .decplaces = 4, .pow10 = 10000 },
> +	[12] = { .decplaces = 4, .pow10 = 10000 },
> +	[13] = { .decplaces = 5, .pow10 = 100000 },
> +	[14] = { .decplaces = 5, .pow10 = 100000 },
> +	[15] = { .decplaces = 5, .pow10 = 100000 },
> +	[16] = { .decplaces = 6, .pow10 = 1000000 },
> +	[17] = { .decplaces = 6, .pow10 = 1000000 },
> +	[18] = { .decplaces = 6, .pow10 = 1000000 },
> +	[19] = { .decplaces = 7, .pow10 = 10000000 },
> +	[20] = { .decplaces = 7, .pow10 = 10000000 },
> +	[21] = { .decplaces = 7, .pow10 = 10000000 },
> +	[22] = { .decplaces = 8, .pow10 = 100000000 },
> +	[23] = { .decplaces = 8, .pow10 = 100000000 },
> +	[24] = { .decplaces = 8, .pow10 = 100000000 },
> +	[25] = { .decplaces = 9, .pow10 = 1000000000 },
> +	[26] = { .decplaces = 9, .pow10 = 1000000000 },
> +	[27] = { .decplaces = 9, .pow10 = 1000000000 }
> +};
> +
> +static void print_event_value(struct seq_file *m, int binary_bits, u64 val)
> +{
> +	struct fixed_params *fp = &fixed_params[binary_bits];
> +	unsigned long long frac;
> +	char buf[10];
> +
> +	/* Mask off the integer part of the fixed-point value. */
> +	frac = val & GENMASK_ULL(binary_bits, 0);
> +
> +	/*
> +	 * Multiply by 10^{desired decimal places}. The
> +	 * integer part of the fixed point value is now
> +	 * almost what is needed.
> +	 */
> +	frac *= fp->pow10;
> +
> +	/*
> +	 * Round to nearest by adding a value that
> +	 * would be a "1" in the binary_bit + 1 place.
> +	 * Integer part of fixed point value is now
> +	 * the needed value.
> +	 */
> +	frac += 1 << (binary_bits - 1);

The static checker I tried pointed out that since the right side
does "int" math that is assigned to "unsigned long long" this risks
an "overflow before widen" issue. You can avoid overflow by casting
1 to "unsigned long long."

> +
> +	/*
> +	 * Extract the integer part of the value. This
> +	 * is the decimal representation of the original
> +	 * fixed-point fractional value.
> +	 */
> +	frac >>= binary_bits;
> +
> +	/*
> +	 * "frac" is now in the range [0 .. fp->pow10).
> +	 * I.e. string representation will fit into
> +	 * fp->decplaces.
> +	 */
> +	sprintf(buf, "%0*llu", fp->decplaces, frac);

Please use snprintf() to handle changes to fixed_params[].

> +
> +	/* Trim trailing zeroes */
> +	for (int i = fp->decplaces - 1; i > 0; i--) {
> +		if (buf[i] != '0')
> +			break;
> +		buf[i] = '\0';
> +	}
> +	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
> +}
> +
>  int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  {
>  	struct kernfs_open_file *of = m->private;
> @@ -666,8 +753,10 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  		seq_puts(m, "Error\n");
>  	else if (rr.err == -EINVAL)
>  		seq_puts(m, "Unavailable\n");
> -	else
> +	else if (evt->binary_bits == 0)
>  		seq_printf(m, "%llu\n", rr.val);
> +	else
> +		print_event_value(m, evt->binary_bits, rr.val);
>  

At this time I understand that it will be clear for which
events user space expects floating point numbers. If the architecture in
turn does not support any "binary bits" then I think resctrl
should still print a floating point number ("x.0") to match user space
expectation.

>  out:
>  	rdtgroup_kn_unlock(of->kn);
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index aec26457d82c..076c0cc6e53a 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -897,16 +897,22 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>  	},
>  };
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits)
>  {
> -	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
> +	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS) ||
> +			 binary_bits > MAX_BINARY_BITS)

This alignment is off.

>  		return;
>  	if (mon_event_all[eventid].enabled) {
>  		pr_warn("Duplicate enable for event %d\n", eventid);
>  		return;
>  	}
> +	if (binary_bits && !mon_event_all[eventid].is_floating_point) {
> +		pr_warn("Event %d may not be floating point\n", eventid);
> +		return;
> +	}
>  
>  	mon_event_all[eventid].any_cpu = any_cpu;
> +	mon_event_all[eventid].binary_bits = binary_bits;
>  	mon_event_all[eventid].enabled = true;
>  }
>  

Reinette
