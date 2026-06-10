Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E410B26FD9B
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 22:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781130404; cv=fail; b=dUXdDqovbYp2CZl90S2s8kUPPK6GkFodtgPCFSJhuF0Uoe9M90fehOy+AsSulSSjIUKwTtfM2C3VNpYjIrIKvdJ+RIwFseF2QsRNANdrzq0CqDgBsXZbkjkUWqCSWPHvmnzciUB5DmnHD0FIiq9ZPi+YUIrLQtUBkZ2WHpHeBwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781130404; c=relaxed/simple;
	bh=dQCrRQNWAf+D5oDorCeravjhHlWFJGUFhY09MKYzzc0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eY4gTnngyDsjod/Oe97oPwoYp9WCn61nVP5cwHQh2hQfurhKasT6QnDafCBLSxqgeZfYz23DeJ2oyDfuBvDOJBwdxSWRACe/g19Qj3gwczsNYEfQA8yrKo8M1XSwuJo7+wWlK04uS1xpQKBhV7R2zVIZL58ES6w0NhnkLfuc9WE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XP5y0rTM; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XP5y0rTM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781130403; x=1812666403;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dQCrRQNWAf+D5oDorCeravjhHlWFJGUFhY09MKYzzc0=;
  b=XP5y0rTM7Ic3ZfH25YqY+EHiROkWOSI6MiWMYdEmjp1xz/moE/wfOQpy
   ZuiUdf7xWka+KQhT1d2r2L5edE8+EkINwhUhHr5sTscAWgFjraP1lIXWY
   D7buMmA9LscUOMJvVGGvc6UjQ8/PiTUSho+9rsgM0lJnBJefMmf2A3n+h
   YTuesE1KhukvJzmUSEDkB1XXp2gad+hR54t6R5sOsfrXOG8dlKvGG1n41
   6/AwBa592MHI0J4Z+LgXLYQpes4bFtsAJckPPCvQ1/l3ptsnXcMbj7i0b
   eBauT9fYlGofKebclymbFy2f/XgAUd2EWa7zVlIG0bpa3qjOao1xzmoLS
   A==;
X-CSE-ConnectionGUID: iFdG2gKqRKKiPjVtCZNMQA==
X-CSE-MsgGUID: mgzBT5vWTICRQrlrk7IcXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="82131060"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="82131060"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 15:26:42 -0700
X-CSE-ConnectionGUID: 9MebLyIBTFKNOKZ1qez2zw==
X-CSE-MsgGUID: 2Iy0kVdeR5ehY6SfjigGzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="245426407"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 15:26:43 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 15:26:41 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 15:26:41 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.53) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 15:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OuQ0K3hm3wM4Yov6brcY2vkAmMYlmq9ksbki6B7W0KRuOxwrU3XFClVge64zdWIFE47T1HwrpIbA99TSfqqvrP1ktNK4ZxSHyl5X+81RkqNNgGqG2fVKSjAQm66r/SpdozSxC2AdHURw0wdvm+yfqXn8g314Aeq3yVfkxt44YuOs3vXz/fCEnB7Ugl0OZcQXcq/eqmsIOJvc0cdLo8eyKq8DjKyuSYC0Ol7K1rJ3ckxH9+q7e8tuFPT9XrNQZ3pvs2xWIx3kAdmtxNAl39354ndEA7g6qASpH1Ih2plR3S/m9ZtGcWqJC0TJF02tP9SdTRVhzILKU8Cfnps5LuDDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYu3RuqnB+LXBWINQYGsS7XSdrIRdLKdAJ3GTvFj5U4=;
 b=plWoxCC4wI6M+lv9vNnDX1UYQdG1lyqAS9cNlYZV8iaUqZS7flpAI+Ly11koYa2sVZ6IafbxSmBmN7IWbBCi2MkxJ+HYiI3vhC0my9YmQrhuzfI2rz/dB4bjtdsqH4SZ+LJx7kmMeSHCvSKH4yBvDsXLIisC6DxHhuxQ75I+7hylxHa4IMz0YtoiZjye34rdONPrKozpqmCmbdRAnsyIU/Lsc1Fl/qc8/Ske+4GzFJ2CpIowklaOVJQFFeNicpucEMo1XntolV0WiprtjQGa3gKFYTqSV2cKs4k3qnJs/BCSoKnFbc0Qdc1R+3WvYI9G5ojgYFja/Mxp6892mRJWpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PHXPR11MB9688.namprd11.prod.outlook.com (2603:10b6:510:3ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Wed, 10 Jun
 2026 22:26:39 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 22:26:39 +0000
Message-ID: <f9b0c233-04a7-4ddc-b792-f2def000febd@intel.com>
Date: Wed, 10 Jun 2026 15:26:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/14] fs/resctrl: Add interface to disable a monitor
 event
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-7-tony.luck@intel.com>
 <ad6da54f-5808-475c-b46f-858f7f31cc18@intel.com>
 <aihLqhlxS7l1y3jO@agluck-desk3>
 <7bbc2796-0f33-433d-a949-d95fa1db6401@intel.com>
 <ainPljLE0yc0o1mv@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ainPljLE0yc0o1mv@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0183.namprd04.prod.outlook.com
 (2603:10b6:303:86::8) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PHXPR11MB9688:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a490b9-6a93-465f-1a3c-08dec73f572e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|3023799007|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: JScUGcck6DUCXujvX1Q30s51YLSBar+lTyL99wbn3CnJNhZvycYVAdGwjujWrQz0TxYHn1tCxu4HWTXiZfb6SMUBADFuNBlch3tlgHFGvRAZOCHVL8JT1ML52+qmvXQFTOC5+XEs0OppCmxazE+hVPRnTn0RGAf4BB2oIgUlowxAscgKY1hIwF6t3kGZ2KNwE8c+EnAovXby+zeTw0cIubFufG0/Bs9tY8DfZxhRjIlXiAu4BPS0M5NMAJcahGtuYp1Oto/E0KeE3jvLd+qJ6QxDDfs7vFIK8x96TVorK0bSXhu19jgNVjQdyEKTIL7sL2Jwu/KMlTeLoT1BHk+iKpR2lsGE1qHuK8GtEcguC5WKaFn+X8Xph773oQszGHlT2B+U7IQ5Z54xQp3tBdPgh2DXG4qbXsV5RU5AczUwMb4MaHMEmais+s3GpAWlrPYMGN1NW+tMVM+xeZRq32hFpZmdKIbw0YGg8mM/Sc9ETVhDE386ude9F1+EqkRVxvIeapTx+MhFztTqf4/TH5syCNZzezmudycJKJx/RPISOQOqtQwp706hhl675DuQTrn6+YiWxHvvk7nGDajieCfG8sd7H3UCKJncSKA88AO78MI4Gats7RHYx/S90mU92pyp/TsFzo5qB0uixNuT1mN5fWbl6xMqs9nUoLf5cS6AJGxKJNBiOiaCz9AXo8i/vJae
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlZ1M09qcG5jbVhRRzJHNFl2N1YydkprWFJBNGdpWjhFQnBoVUxoOGNhZ0lr?=
 =?utf-8?B?d0tZRmlNTzkyeGVTVWZBcWRHN3VnbFFYcU0xSTRMV2tOVUp0T2V4amZIeGJH?=
 =?utf-8?B?ZVVLcE4xeTdPWjNuUm1jZHdIYktqbE1taHppQ1B4VjRSR1U4a0VuVlE3Wmd3?=
 =?utf-8?B?YUpQczc1bXljZExJZmdvQzU5RDNaUUVmZW54MDBrWGQ2YzBkZTM1blVZbnhT?=
 =?utf-8?B?eHQvblErdllBOUNkb3UzOGpRWXd4dXdMTmFGc2FTVXQwMUZZcDZrQ1RnOWQ5?=
 =?utf-8?B?Q1hqRnNIdlFVOUIwSDBETENxWE9GbVZ2YkRKZWxUZVlIdG5KaVlVY0s1MGJC?=
 =?utf-8?B?SCtXSDdYQ2N2c3lyQXNVMm96ejIySVhKR3ptUFRqTVpGcDZmdzRHSDZzQW56?=
 =?utf-8?B?ZUJwckVhOS92dlhOblpUaFFBT0ZmeldWTTFyYktGS0VRcEJXcVhKMjhWblgy?=
 =?utf-8?B?QW83TUZhY2F0S284YWRlLzRTYndZL2Rpb2xtN1luemphcmVXanFnMW84ZDJC?=
 =?utf-8?B?bDFHLy9Ld1pTSVlPaUJYR3ZLYzhRT2ZRQ1d3Tk5mbUlrWGZOSGdFY3lSYkYw?=
 =?utf-8?B?QWZBTjFHRWtJei9BZnV1NnFSOHZ2Q3BaTkg1WkpNTTBNRjByTmZiRWFYR3pN?=
 =?utf-8?B?czFIRkdtTUtSMjZERDBMNlg1TFJvY29jUGtTZGplWlB2NGJ2SEVzNFNlNHRL?=
 =?utf-8?B?VE1tQVdmcU5Lc0l2aVVXOXZxaTJoemJBR1B2OGRPUU1GWkRBZU9VRXBkRlE5?=
 =?utf-8?B?aER2YWx2cTUydkpXcjVWbjRta2lOVEVVL3M4aWtRWmdVR1FUckcwSXV2QlV2?=
 =?utf-8?B?RDBQQ09WY3l0cEtibFpldldDYjJaKy8zb2c5ZzdqYmZUaDRkZ2V5QlJHMWFI?=
 =?utf-8?B?bHE4TUNnYlZxTmVuZHEvb3IzaCtKVFRwTDZQV0NmRzhrMExkeHNGNHhia2xL?=
 =?utf-8?B?bGRPaktDak9IQTVnRWhRT015a3RIcDhxWWtaeUdBZ0hiSWIzWEtIdzZLR3li?=
 =?utf-8?B?NlRKMVBTZmpzVGd4NThMNUpoM0ZlODIvWUFoTWxWMVZKa3FsV1hhdEVFVTF0?=
 =?utf-8?B?SjIzTWMrWlJUemVlM0FTcUE5Wmd4Y0R5VnV4T3Y4REdXZ1MvSUE4SXNIUkp5?=
 =?utf-8?B?Z0h2SlQzSm1vb1VlMnhZblUvT2htTCtHV05RUFEwSWRmZE5IMEpxMHRKL1V2?=
 =?utf-8?B?Y1R3TXV0Q284ZWhRZFNSVG1ITFpIVXQ3bXBNdkRhY2c4MXNUSU5GdlpsVDd6?=
 =?utf-8?B?RnJpakJoaXg5aEJoQXR0TG1tMzZjMEFPZzVwU0ZHRjJ4NVNkMEFVcCtUZkNG?=
 =?utf-8?B?YkNXcE0zTVZCMHcwV0YwODdEaVdPRnFLRHdrNDVwL0w4R2Y0M3B2WXg4dC93?=
 =?utf-8?B?UDNJRlhJRjErSUtkVTF3bks4eDJELzhRRnlDblh1bFBNRU0zT2tnd0QrWDgx?=
 =?utf-8?B?R21ITll1L2djcjdGWS91VzluNEZvRUJEMlhDbmo3NW1MeE4vK3hOdXYydlZO?=
 =?utf-8?B?V29rMzh6cHNWclpVUDJQejdhZ0FRMGp6Uzhsdis2UXNVRmprSis1Y3Y2TGtE?=
 =?utf-8?B?MTExampIQjNsbm92MVM0TXhoK2dCenhPMkxQTEhWdXpiMWx5aTFGOS8zZ3Y3?=
 =?utf-8?B?dXNSRGZ6Z0pyV3VPcy9lMTlyazh1RVgxUVcyWlJEUUo4NkdRMkR0LzhzdmIz?=
 =?utf-8?B?dEI5UmJhRDByNmZhMzFsR1Q2S3FmZnJxdEJwK0dNNCs2QkljRkdqaUxTbEZO?=
 =?utf-8?B?OGk1Qi92aXA0UUZqSnVPdUdhWlJOcHc3UnJvcHB0cysyN25WUEQzSTJZRE5B?=
 =?utf-8?B?dnAxQk5mRVJzTTVqWU44ald4Ym9uYzFhVmRGeDgvZy9GSnFwL3JzQmFvZVNB?=
 =?utf-8?B?enFPajdFazBBalAwMmJHTVphb201QUxhRjRqNDVHemViV1Jic1Q3Z0l5dkN6?=
 =?utf-8?B?algxRGNCMlBQTVZTUG56WVo5SE5GRGZsYW5CTm8zY0JVczZoOG9ObURRZW12?=
 =?utf-8?B?T2dsQjZiU2VQUnNiR0YwaUV5WWgvU1p6TGpOL05EN3RzYzNoang3dFFtQkpG?=
 =?utf-8?B?U3RCWWkvRVF5RHAvQS9HREYyMmplRGlqelhvc1pEK1NOeHg4NFVCRTYwVEh3?=
 =?utf-8?B?OG8rV0F3OG82UTJEWGVBSm5TM2ZYNmRjamVXbHQzOEtFdFVXQ2wwR3MvR3pK?=
 =?utf-8?B?MWRzVitKeUJPTWNDNXhaWTE5cjhUZFd2TzBMc0RaZVY4NzBwT2VRK1BORGR5?=
 =?utf-8?B?MUx3aXRET0dWVVFwWEZBbktjcVZNbGR2TUdVdXp1empWQmROcWY1bnFFUnFY?=
 =?utf-8?B?WnUrdEZHa3k1bitVaDBQODBFbk9kcGZGVEZOb3NMSHJvQ2VRMjY0c0x2R2tR?=
 =?utf-8?Q?N5CmyUzglfqkzohQ=3D?=
X-Exchange-RoutingPolicyChecked: IC8vQNnXS3M1zT43SVA5xs02Iyrhzww9k8khkzBDcUOPMhydwEt6xtMHhc18sEVQxs/ANQF7GKr7FltsKqA+VEqkjktLlVjaEu8k4fkWfHLL40yxjRYlWKsZhec3InijRiOy5KUr+7oE99HgJYJ2vTejXh/d1p/evc1KNkdGvg1hMuYCYAGrFaW+3DQTQGbDPLzhsIoIqxe3XxoEYY3v2TD/hF4E4A2YrOMZiCvpjhXwprRAklClyVH5sZWuc/xqQU7MZHTBve+qdHKkOQiEBK+YdAhXeTQg7aLbVTErSYup1VT2/wzSazGsA3EyMpmwxejaqpM51Was7cIh7SNBlw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a490b9-6a93-465f-1a3c-08dec73f572e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 22:26:39.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twKUPZsW8AhjmduZhTaiQzFaAa7+/O5x6zHGlkatnoC87UdCbEZ3qvn9SDEpqJ+BE2OZq2Cjk+Vu4eGL45SqMKEWDebN3Ec85orrmdj5gQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR11MB9688
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/26 1:56 PM, Luck, Tony wrote:
> On Tue, Jun 09, 2026 at 04:02:55PM -0700, Reinette Chatre wrote:
>> On 6/9/26 10:21 AM, Luck, Tony wrote:
>>> On Mon, Jun 08, 2026 at 04:18:23PM -0700, Reinette Chatre wrote:
>>>> On 6/1/26 12:56 PM, Tony Luck wrote:
>>>>> In preparation for re-running AET enumeration on every mount, AET code must be
>>>>> able to disable events on unmount so the next mount starts from a clean slate.
>>>>>
>>>>> Add a file system interface for architecture to clear the enabled flag for
>>>>> a given event.
>>>>
>>>> This just verbatim describes what the patch does. It would be helpful to describe
>>>> how the flag is used by resctrl to support the first paragraph's implicit claim
>>>> that the enabled flag's value is not relevant when resctrl is unmounted.
>>>
>>> Revised commit:
>>> ---
>>> Subject: fs/resctrl: Add interface to disable a monitor event
>>>
>>> In preparation for re-running AET enumeration on every mount, AET code must be
>>> able to disable events on unmount so the next mount starts from a clean slate.
>>>
>>> Add a file system interface for architecture to reset architecture
>>> controlled fields of the given event. mon_event::enabled is only used
>>> during mount and at run time to check which events to include in file
>>> system objects. It is not used during unmount, so it is safe to clear
>>> it as part of the unmount flow.
>>
>> This introduces a general resctrl fs interface and makes some powerful
>> generalized statements in support of the interface but these statements
>> are only true for the AET events. Surely mon_event::enabled is used
>> during unmount since domains can come and go while resctrl is not mounted
>> and as the new comments explain there is significant state coordination that
>> needs to be done between these event callbacks and hotplug handlers.
>>
>> Similarly, the resctrl LLC occupancy worker keeps running while resctrl
>> is unmounted and depends on LLC occupancy event being enabled.
>>
>> Creating a resctrl fs generalized interface but motivating it with a
>> highly customized lens of usage without making that clear in the changelog 
>> but instead just making grand claims of how safe this is seems underhanded.
> 
> I can rewrite this commit comment to call out the limitations on event
> removal. Those are listed in the new kerneldoc comments that I added to
> the resctrl_disable_mon_event() declaration in <linux/resctrl.h> based on
> your feedback on previous version of this patch.

It is not necessary to duplicate the documentation added by the patch but 
really should not make false statements like "It is not used during unmount"

> 
> Is that what you are looking for here? Or are you suggesting that the
> new interface be less general?

I do not think it is necessary to make the interface less general but if you have
ideas then please share. My concern is just that the changelog should accurately
describe what the patch does.

Consider, for example, something like below. Please do not copy&paste what I write since
I already acknowledge it is not ideal. Please consider it just as a draft of how I think
this change can be described:
	Without enforcement resctrl assumes that all events are enabled before any
	domain is created. This assumption supports events that requires per-domain
	state that is created with the domain via the architecture's CPU hotplug handlers.
	resctrl	does not support disabling of events since, in addition to coordination with
	the domain management done by the architecture's CPU hotplug handlers, disabling
	of events needs	to be coordinated with the resctrl filesystem that may be mounted
	and exposing enabled events.

	The AET telemetry resources are enumerated and managed by the INTEL_PMT_TELEMETRY
	driver. In preparation for INTEL_PMT_TELEMETRY to be loaded as module resctrl should
	handle the scenario where INTEL_PMT_TELEMETRY is unloaded after resctrl
	discovered the telemetry resources and enabled the associated events. This means
	that resctrl needs to support disabling of events.

	The architecture manages the domain and knows the resctrl mount state via
	the resctrl_arch_pre_mount() callback. The architecture is thus in the best position
	to know	when it is safe to disable an event.

	Allow the architecture to disable an event and trust it to only do so when resctrl
	fs is not mounted and that it will ensure the event's state is cleaned up. Without being
	able to do enforcement of safe event disabling, document what an architecture needs to
	consider before using this new capability.
	
Reinette

