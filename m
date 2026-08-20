Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD4F47987B
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 21:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787262939; cv=fail; b=TrKZTt0+0D8RhSYoEnD0m6DdBAN1HXVaVK50Wtn26bQR2++5IgoVdKOwzqMSPt6CKtJeCE888qsVXqly+SgW6aP3ov54RnHJ/6AyLiSe7z3OZ2WU7uVRz0C+FbECR1kmP1Ic5xi3gFdf7KqU3XUgLwJ8ZuzyhlNPMfttXZlYIAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787262939; c=relaxed/simple;
	bh=sutGafzRhgwwqbLGvF+YMHsugv3JOXI7xKuF+kC/z6U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Phn/mD4ZRsUEYf7IcCsxxC7RTSm0pqLDwHRG0jiG12OyWl8yj4T3DXYYvn/8JOBRgiCY8ebpiE+nz5Bg8vKuANHYTE7lSUkBlgEcNbXQgyRgyKcA3Qv4JxZX/MhzXEAC02RBLZGlRFKzJtFjqLrjCvaIqi1HcUamqvYq+ieLJdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RYqJPPGn; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RYqJPPGn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787262937; x=1818798937;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sutGafzRhgwwqbLGvF+YMHsugv3JOXI7xKuF+kC/z6U=;
  b=RYqJPPGnE6YN7TpWgNWcrtjQOyOCT4bxgylqm73gb65zAkSoPk4KWIUU
   F7Su4ZISQJnf2ZGseabdXxreq61ohOOmZNFOKfUL9bkfPvoOGBqRRq/eY
   GLvldgxtKieuy4TKpqvKDDPAJO2ZoHeQt342dhF3u6PHveoPWXA8Z9hop
   MkylVIIeW34d+CUc9FhF87JYLY8/qvZGbSL8heONvjTL4pLVW7G7WUQqo
   Mzx6Nq4kYsKorT+pVM512q90oZR6BVMGRBC4F+ey3ggYsu78eenCrG+Lm
   g20VR/4fgBBmQ7ktClcPiDHjA4IcNzDzxW4OnWRtrQ8gu8a2mj3UKqnUU
   w==;
X-CSE-ConnectionGUID: 0dwJGTp+R/+ZT5OH1+acFw==
X-CSE-MsgGUID: 3xTFo9aYSjaRYeOPO6j4dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="87575923"
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="87575923"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 14:55:36 -0700
X-CSE-ConnectionGUID: /nRUHzrNTnaxPWX0WOaTrA==
X-CSE-MsgGUID: 7rPbVVhgQVSFWI0yoW1tGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="266763035"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 14:55:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 14:55:35 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 14:55:35 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 14:55:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jSZSHUU+is9YLPkASbu8FlxAyz0UPsqD7XoeVW4tuCsPBFaIe//Fp1omO/COnyCBl+2aryTYx/Yvjs+zw7G9bBbqcBjeRWZrQBPt/vHobamKmeUWMvp7bYPa7bd+YwlM1NjTGP0Vq1wrr+ORItiCrJNg66wbLDUAn6eWzFRPPxwTbvPvsskYt73V2khg11mOKAsQTAz2rQFpmTWoAnR+ko7pDorq5Ea8ltERN6zxJtfxi/SUHlOa1sz8O5nWPbnTkj24nyFV8o44RVckN6/1Od7GRMC9fJfTx1y7HQy9loG6d/d+tfx5T4m835Xke41X6fDu6h9RRgb2rtofSyLR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEUgk+D1+jNFKIbcEq1RuZnnxO36mkg6CcIWqsak6Cg=;
 b=bJDaPYnmQIl1/7j9yG3Bcw6wEwwV7TGPZdFTrmzaSJUxJexHVeLNlOErdw3V+hU4HTcQQrGPaWIp9TMsr8slgahM/++itAIjUDhW+Ix6JxLJ/44rq+rqzYjHmj109RAI0jZZP3C/Ti4jnmSvMwc72nzGu5vZkx0eBbujZHIBTpLqKa1YhE+PNIv2++KTyKaehlT/8a8slzG99k1huVt5oW7Gj9J4qLxzUvog/s+97yLdlVNLZTXY+qbHJpWnjFzdzcy8/c54FBlFbLMTZ/jWSF41BtUUXKuJ4z4FAFp9xvOXt400xUDXvQd2FnxS3yrW0vEFfGw2hAcVszoXTNMWjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM6PR11MB4626.namprd11.prod.outlook.com (2603:10b6:5:2a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 20 Aug
 2026 21:55:32 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 21:55:32 +0000
Message-ID: <779e9ca5-9785-4cfd-b6c8-42efa1b2f560@intel.com>
Date: Thu, 20 Aug 2026 14:55:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/17] x86/resctrl: Enforce system RMID limit on AET
 event groups
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-9-tony.luck@intel.com>
 <cda8483e-8c83-45b9-b52b-0e465e49b698@intel.com>
 <aodKsOMxcdasi0U6@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aodKsOMxcdasi0U6@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0010.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::15) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM6PR11MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: 1447a40a-f4f3-42cd-8420-08deff05c1b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|5023799004|11063799006|4143699003|18002099003|22082099003|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info: m0iANIOFIf+0vmBqdqj+mFuCNozVLZC6ZCOohvGi8uuF5W6tIx+TyXzyN22UgKmqzIQ2yhXaiV6vjig78O9dLCv6CksHLhD1c/yICwY4XZgdc3HBckg6be+FNDMqclN6mfzC3GP8lpg+LTj/9OICoulCzI64i6ozB2P3hJGLxFduguvLPBCXvXQx3WrujCtifG3tIP3TyRo5h8PCuxPmv6xVcWYBqPlmKS6hZTMSfjKfkG5ERUPYNTfLUCmzaxXrhn1af6heaG44e9WQuNmolhJBqV5JPAsbrigmrnA1WmcJQPkKbA3u/P9aA8S+S96bn0cEnrrUI0dNggmlSf+lN7kt7L1YF/deqYh/F12gCFxVCloahXHOm6/dLICgc6f5Yl//j7Wg2ikMwh+8rbs3QxVa3eYXd8O21mn0l0UQXSvjqtTsyV1Rds5GpD1+I1Ru8ZbAQS0TM/BaoVUkGFFX365Adjq7xA1dNwmSU8XAJpP4kdAUE+OjjF12bH+5VJlHbL7ei7nRpVNXaqwcnXBaAznr3wTfZFrDsgnGNY9YmjrWhSsV3cpftNwv5g3T3yA9UYlf9wI8RKpAYgurxo8LTzyfieWO4wlq1Y2xGZKQAQJG/1GGYORt59lWn6atyeVYYPdl1AqSNz2lcNuNrp8FIkyhqHXZU0354gKXT6MVoOI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(5023799004)(11063799006)(4143699003)(18002099003)(22082099003)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHZobWZMUVhCV3A3S3dsQzFKeTlKMW9kNDNxNGVpS25McWFDREJpVERTL09t?=
 =?utf-8?B?QytKS3ZOUnJlU2srT0xOOFBiQjR0a0NUM3NyYktDS3hhNE03dXZYVjdvVVBN?=
 =?utf-8?B?aXpJdWM5K1JLb0VYSEo2MFh2SGMxcENyamN1andXckhuK1dTN0dnSDgyZXM3?=
 =?utf-8?B?R1AxZHBwVERIWTJpZEJpci9mcEFhRFZtS2oxV3YxMzNaYmhDWU80NjA4VEN0?=
 =?utf-8?B?UG5KZHBNbXhPSy9mRHQ3ZXVSaWJOOGxoSEdrK05LMXR3OXNOVEhPSUpoWnpD?=
 =?utf-8?B?dWNUdFJ6dWZFd3ZHNWVSRWZRZzlhbHpwT2NKTjVRVzUvVDg3dHNleWZkRFRa?=
 =?utf-8?B?dVhTRFJYMkNWWmczUCtCNVdqVm1RZmI4aUpEVFJQb1UyMG9KeVhBM1FOK1lo?=
 =?utf-8?B?cFhERmFlUi9BNElLMkVmeVFQaEloNjAzY3ZKSE5jbWROaFo5VXNEWnJpQVN6?=
 =?utf-8?B?Y2ZtRGlkL2xXTXUzYUxFZzV4UUNaNExFU3FGaWkzQkt2Z2xXZjYwT0Y1d3FV?=
 =?utf-8?B?VFRoRzFvYUJUOHdPYUhPdFhmOWlGYzBUMFRLZUdTQS9TU25VRHd0Q0dxQmVh?=
 =?utf-8?B?aGZSbVB1bVdnM2tMUlRQQnZndFh0U2U2SzM5MzZjY3J3ZXhwb3hkS2lLYm8y?=
 =?utf-8?B?WVNYb2lNTGFodGxYMlgrb0ozWFpqcWkyWTZmUVNTS2xSQnFUVFFQdEVmWE9K?=
 =?utf-8?B?NnZweTdyOUxHdzZwR05tSXdNR0RBWFpFbVh4dVJXbTZlQ08vaTFUa3ZMTTFh?=
 =?utf-8?B?b2R0NEQzVW01U2tObnhGRkIybW1NTDdkU3BtZHY2UVBMZHNGSlgwcFZYSG81?=
 =?utf-8?B?RXYyZjRSL0IxU1p3RUMxU3Z0Q1k1UkxqK0xqZ1VtTGM3S0ZFaDU4OEx5M3Z6?=
 =?utf-8?B?VGVIWkVXKzkwaXpSZVBjNVoya1NNNlMvUlY0TGcrVUxFSlpMMTBWTjFWLzd6?=
 =?utf-8?B?SU55RjBDYUsxQ2g1K3ltb09LM2NwOXlKemE5REp6SzZOTy9BRDZpOFdQZWFE?=
 =?utf-8?B?a0ExUDVocGpvaVd6NzhlYlNDckhGUi9WMnp2YU1aTFBkalZBYmVOVEl1SWFm?=
 =?utf-8?B?bU5CYjBxeVh6S25MQjFHVVdVejJRN2szM0F3ZGZXcTFpVkUycUpWZFlLTWJa?=
 =?utf-8?B?OXI2cG5xZE5tc0FVY3VlcE9DTmNJbkp1Vm9uaDY4ZmxWYlN2U3pzTmFVZ3hM?=
 =?utf-8?B?VFVKODltaXF2YmpuWWpHQ0dJTkhSSDN2ME9zMUdjdmRxNWR5ZDdVZVFkSFJa?=
 =?utf-8?B?L3RQWUpLMEdyTjczeHlXOWNVeS9ycnE5SGNOVk95R294SVlxcVB6UVN1MkFq?=
 =?utf-8?B?ZXJacTBPL2xPZFRRWEZjZ1VObU1tRkI4YWtaR2ozTW1tSjd1ei95Qk4xdWk0?=
 =?utf-8?B?dVFUdnkwWTBHVDNTSFBOREIyWC9qQUdLUDByVFFnOVkzS24reHdubXpWUzJP?=
 =?utf-8?B?V1JFSDJobDliNmlDeVZjaFdIdzRpdFE5ei92WjZhTDJjbWNIK2tFd0hBQlB2?=
 =?utf-8?B?QUtnc2Y2OGdNeGdzbG83VXRoZCtNTWhhQUR5YitzMEZMR0NwSjQzdzNReklx?=
 =?utf-8?B?aUUzeVJqZjg0SkxEeXVUYUhNNEFyajRmVWExTW1tMzhUYktXbm92dGczWnVo?=
 =?utf-8?B?RlI2OXVTK1RZTnVvUjIrRjNGYkl2ZEJpbnlJL29YMUZQRjdHcjdhYk84R0Fj?=
 =?utf-8?B?RDlFN2xDQWc0VEszaEZoUEVjTFROM0xkMFZpQkhla0VZODJlaWVTaUNiR0JK?=
 =?utf-8?B?eGE4enNWN1NhTk9RUWVBdkxrYUw0UTh2V3l1RS9Hd2wxWFhRNVFHT0hIMW1Y?=
 =?utf-8?B?Ukd0emlBM0ZRS1NMQkEvUVlaek4rdjI0ZC9ZTVFZUUE2OGdLOHhPMzExd0t2?=
 =?utf-8?B?djh4N0ROSkZOQ0VsMXNFWWtMSnc2dVREMy9LY1M0b1hQTlhRemk1K2k5TXV3?=
 =?utf-8?B?bk9QWi9tVTUzREd4MTJpRDU0ckFvTkt0djVjaENFS2twK1pScmY0OVZob0x2?=
 =?utf-8?B?VExDRDhXM1NpOHlONVIwRVBobTEzYlJLUzd1RldnOHAvdUt2NUc0cW9CbHU0?=
 =?utf-8?B?bE5FREJROUNvNVdqakpxanpGUVc2aDJudmFpMnB3blFCSmlNRGxkZDB1czFW?=
 =?utf-8?B?eE5WMHZteFBpUEkyNG1SQUp5dkRScW1wMnFSNWZvbTRxOXZXdG8rdGVFSEFv?=
 =?utf-8?B?TmxXeEpTNEhRclBPYS9XaGh5NTdlYXpsYUIvL3Bac1VQM2dkK2s4UDBtR2hN?=
 =?utf-8?B?eWMwMUtkRTlFdEVwM0g5TTBmNjlpNlNnVnYxY0E5NEJ4RzNBdUkzTXczQVIx?=
 =?utf-8?B?TEpDMnhSc1JMYS9WelNSOG52cm5ETEJRdDR3WkxXRUhOZGZ3bklVUi83Q1Zm?=
 =?utf-8?Q?kSR8PfcZJ5q8Wiqo=3D?=
X-Exchange-RoutingPolicyChecked: fYaw39karTpWCKp+JY1wiyHjppdcKl6Q1aE2nVSeHovLkO3OwUN9KbsZNzAtVAJAuhsAChqwqn35x8CH5LF+dthR1kIuZFy3NP9aw/P0I0PrmjsZreVdZL0XRa73vFj/73bxoxi/YzhRoGuhnGywZDYLJCuzUB6UuG8TC4r+bitlH/cQqQpmedvoyuean26ipWlB/8X+Wx+BDnHkdASNrjgGmOdbtXaaAO+ynTBqDL93z3RIdKwqc0uTTJ4p6DaqOdqp+yIYXMQQYsdz/+Tc/fFr36u41V42mW2cnILa1KuicdO5qChcxhZ+iIW5PJwS+khXn9MwwKe3560h6yaWXg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1447a40a-f4f3-42cd-8420-08deff05c1b6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 21:55:32.6057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AyEMbn/X+lcQgoDAbXwueGFSYYnhWaoXFJfp98e/zucSaYp2iQ5jUYJBCchm5qlGMY/DuA4jjgGrFrGpynDV6mh1xGf/5HL96toGxzu90lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4626
X-OriginatorOrg: intel.com

Hi Tony,

On 8/20/26 11:42 AM, Luck, Tony wrote:
> On Mon, Aug 17, 2026 at 05:58:13PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 7/29/26 10:27 AM, Tony Luck wrote:
>>> AET (Application Energy Telemetry) event groups each support a specific
>>> number of RMIDs. But that number may be lower than the number supported
>>> by the system. Especially true on systems with SNC (Sub-NUMA Cluster)
>>> enabled as that reduces the number of supported RMIDs.
>>>
>>> Fix get_rdt_mon_resources() to return true when any monitor resource is
>>
>> hmmm ... "Fix" makes one look for the accompanying "Fixes:" tag. What is
>> the fix here? What is wrong with existing implementation that needs fixing?
>> To me this does not look like a fix though (more below).
>>
>>> possibly enabled. Call intel_aet_init() to adjust the event_group::num_rmid
>>> values to not exceed the system supported maximum.
>>
>> Last sentence just documents the code. Please describe why this is needed.
>> Is this a separate logical change?
>>
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>
>> ...
>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>> index 092764cf693f..2c938b97b147 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>> @@ -1019,10 +1019,10 @@ static __init bool get_rdt_mon_resources(void)
>>>  	if (rdt_cpu_has(X86_FEATURE_ABMC))
>>>  		ret = true;
>>>  
>>> -	if (!ret)
>>> -		return false;
>>> +	if (ret)
>>> +		rdt_get_l3_mon_config(r);
>>>  
>>> -	return !rdt_get_l3_mon_config(r);
>>> +	return boot_cpu_data.x86_cache_max_rmid > 0;
>>>  }
>>
>> >From what I can tell this will return true when the system supports monitoring,
>> but no resource may actually have monitoring enabled at this point. Specifically,
>> no resource has rdt_resource::mon_capable set. 
>>
>> The resctrl initialization now proceeds where it used to stop. resctrl_arch_late_init()
>> will proceed and initialize the resctrl filesystem, which in turn would allow user space
>> to mount it.
>>
>> rdt_get_tree() handling the user mount request could thus be run on a system that does
>> not have a monitoring or allocation capable resource and then we see in rdt_get_tree():
>> 	if (resctrl_arch_alloc_capable() || resctrl_arch_mon_capable())
>> 		resctrl_mounted = true;
> 
> Should the inverse of that check really be an error condition and result
> in failing the mount? There seems no point in a mount with no monitor or
> alloc features.

I agree that there is no point in a mount with no monitor or alloc features.
That is indeed how resctrl behaved until this misrepresentation of a fix changed
this behavior.

> 
> This code appeared as part of James' separating the x86 specific static
> branch code out of the filesystem generic mount path in commit
> 13e5769debf0 ("x86/resctrl: Make resctrl_mounted checks explicit")

This change would have had same consequence even without that patch, no? Only
difference is that before the patch you point out rdt_enable_key was used to
check if resctrl fs was mounted and rdt_enable_key would not be set if there
are no monitor or alloc features resulting in the same problem of resctrl
allowing a remount after it is already mounted.

> 
> My plan is to move this inverted check earlier (right after the call
> to resctrl_arch_pre_mount() which could be the decision point on if
> any monitor resources are enabled.
> 
> 
> rdt_get_tree()
> {
> 	mutex_lock(&resctrl_mount_lock); // NEW (revived from v4 of series)
> 
> 	check for nested mount -> -EBUSY
> 
> 	resctrl_arch_pre_mount();
> 
> 	if (!resctrl_arch_alloc_capable() && !resctrl_arch_mon_capable()) {

A test like this looks to be needed after this patch, yes. Even so, why does this
need to be outside of the main function protected by rdtgroup_mutex? I do not think
that it is ideal to have this information accessed by resctrl fs with different mutex
inconsistently held. Or does this actually reflect the larger "always return the same
data from mount to unmount" implicit contract with architecture?

There clearly needs to be a contract between fs and arch on what the fs expects these
two functions to return. Patch 6/17 is beginning to create this contract. 

> 		ret = -EINVAL;
> 		goto out_mount_unlock;
> 	}
> 
> 	...
> 
> 	resctrl_mounted = true;
> 
> Choice of error code is still open. I tried -ENODEV, but that results in
> an error message to the user saying the resctrl filesystem is not
> supported.
> 
>>
>> The above flow change would cause resctrl to think the system supports monitoring
>> but resctrl_arch_mon_capable() returns false. If there are no allocation features
>> then this will result in resctrl fs mounted ... but resctrl_mounted is not set to
>> true and thus allow a remount that is not supported.
Reinette
