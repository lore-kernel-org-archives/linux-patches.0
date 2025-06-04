Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124A0262FCC
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 04:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749010510; cv=fail; b=KHObYg3DLr/sSnIDuNbMcSk3OFmXSthI/sOkN+cJTUzJAuVDZdBmdCaNbgLYlXy2l5UXDzvEXLzLfQYK9TtQb+8uVcJH2Fkr7sAPRfq6mBzUAy/o3HU7ocI6oqJurGtiwJfmmlLMJMNvqHbKHLMY2GKxtC3IWGoEDFHMITOJhOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749010510; c=relaxed/simple;
	bh=erAN1eUR1aCNK0Y8gtFW8UdaFolmZvjABqqJXN5vj/Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XkctkFSU7DW4xXCf37VA4y6yUByv3wwiNXXrz7HHeUkgCBosp3aicpTSvk3qoSDTYoRYSNS5k7AhOTfD/Q0uTHRudd72pmpSRA2xl057lrSYaU7ROls8xA/J2LkJFCk6WBAWCl+mU/OvYCNtOpq9+N3BEZThS6gsm4hZ6tBnQSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L3swk/G8; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L3swk/G8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749010509; x=1780546509;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=erAN1eUR1aCNK0Y8gtFW8UdaFolmZvjABqqJXN5vj/Q=;
  b=L3swk/G80nrvEJz4+nlM8jorplgJumArJGUqzpfDYZLdLqfA3WyWDv9p
   RmlC5LwYL7O9r2dcGBX3eui6s/z5jFz+YwgF0/vAw7kZwhtFlSn50SzK7
   EufL8IziYITDu8FF2dntQDT7SUTxd9aeoGVxEt/bcp2ZRRo4mYhwbpB2N
   CW1dL8D5EkNFdIm5ATjCTWztO6qIgxRKUEChqxBEStsi0Tiql4z29HEWj
   pfv5nmyrHQ9tWEqPpBfGh7OOTJTfjK/X7VbjATtjd/5giHNk1B3DwxtTB
   Odd9oqPHV3KI7zYFfgN9NY7dtv6jpjpumcKSPRxuwTgAlm72vb9HVs1eC
   g==;
X-CSE-ConnectionGUID: kvrR+AKkTgOcyESzKhoaaA==
X-CSE-MsgGUID: e3GobLInTJiGvK3ucSQXjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50942620"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="50942620"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:15:08 -0700
X-CSE-ConnectionGUID: 3aPpr3goRHy6BSzHviYWcw==
X-CSE-MsgGUID: EFX2hYG2Q+e6w9s5d6ZtrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="144930229"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:15:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 21:15:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 21:15:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.89)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 21:15:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iWO2YXFM9WTwBWEMhq0caNSA9+FnRzboDEDf1vgDIY5kADFOAHL0emjfL6FFWFTrFP/8K933qPY/RmOwPlIvbbTzqJwsokw9zKkjYs96eBzPCua2YsDy5nCVQIOODAH1TbcB2WHpmNCq5sA6Ce6iTobQKwpJiDhBL0XB64yiuu5X7snt4DNPxMKpPdAY5IIQdlG2pS0mmtF/Qg87NAU7nixgI+Z7bQraSxqPRHltY4nnCOCuO6OPDCvj6gBRdgMwulvXEubd/BquLrUjewTP0lBOUxE8T93WZZCyBl2hXSc8TlRE3Kli47askLvZCVkMprhXzC3470oN1NzlRL+Zuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIOG2g0Sn0UQgPFYr0gWBeIWEFjG8sY38fthCcHpOZc=;
 b=tBst8l5I7JPoaZFsrD5Iz+1qsG49c8HxjrF4PqUfRnCiI3E4Cz5o2AP/KZ8rH4T5/9yZuHLVsW7O+skxsDllFG/bnaNKnM8qFslXsCzevsYX2WY2FPeCylxD9WZ5duO08+zkfNVXJpTzV2LC/XJWtx4eoIC4IhW2XF1YGYnuKSoU/77KiycxzxR5ObBl0V24/pa/dESr8Bhpa8QbtXisQZXxc3XlOnpTj4VIJ3a37U/rDr9SVN6tMXFQLFQ0dIaAPprZoKJ5oBBHQO6/6gyaR1YFiO7CuQLBZqcChfxK4VY2e5TZbJ8ar/x6eIUYcgi5X8uawBD4QiSeJq2kj9TUxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PR11MB8714.namprd11.prod.outlook.com (2603:10b6:0:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.34; Wed, 4 Jun 2025 04:15:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 04:15:04 +0000
Message-ID: <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
Date: Tue, 3 Jun 2025 21:15:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-28-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-28-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0073.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PR11MB8714:EE_
X-MS-Office365-Filtering-Correlation-Id: 160759c6-4fb7-40c5-6657-08dda31e61df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ditYbEViZFRFR3ZYMW42M1FiUiszUkV4djJmM3RjMmY4TE9HdUYrcEJSWkU0?=
 =?utf-8?B?L1ZaK1pqNnpTWXl2djU4elFHWVlTaDkxMndQVUJiYmlMaVlLS2FXMjhDNmxp?=
 =?utf-8?B?YUh1QmU1eERRTzlKazBHbjlpUURYUXgxd3k1cGdrdDMzWVFEd0RlTzBoeU9a?=
 =?utf-8?B?Uk9PTU1wbzluaGtFN1V3UlU4MXk0eFp1OG94VDIwUk80ZGhDQStFNDlDc2Ux?=
 =?utf-8?B?aFd4Lzlrc3U4N1lIa3dXa29NYUIrbkFXQVU2MU8rQmROdzJWUVpucXptWWZE?=
 =?utf-8?B?MXp2eEFXazJuUThLdmdXTjBYd1Z4QzNubVkwWWtoV3ArajdZVDZ2dUhxUXE3?=
 =?utf-8?B?YjNsTnJtdXFidnMrbklPNllOZFlxN0F0a1Q4aGRpZnhhWEJCMVN5OXQ5Nk5D?=
 =?utf-8?B?TTNlaWhMb2hOdWxzN3lHd2dWSW15L2hMcTVjdjluS09HVnU3SDBKWTFJQUp5?=
 =?utf-8?B?OU15WTF3cTZiVVQ0d1NTMmdFVFdlbWU0UGh3N2cwVWdnTXA0bWVVaE95cWww?=
 =?utf-8?B?UDhSVEFlZU1LZC9RT3VzaDBVL25TRTZtTkNBV0JweWpVS2htdEVYMW1pa2JM?=
 =?utf-8?B?YXBDOFZHQ3pzQlI3YU90U1hFQ0w4QlhQbEtsMldDMmRvVjlvZS9pZm40Rmcy?=
 =?utf-8?B?UFB2bjVPSDV0eU1INkx0MldpbWZscDl0TXRGZS9tTEl5eHdTczUwN0Rpdkkr?=
 =?utf-8?B?ZUdmVEJiRVVNMHlzT0x1SDJib1N2bUZBTzRUS0NsWnBFeU5xYmpEUSs3eGJy?=
 =?utf-8?B?Q05ZU3kzTFlmRzZZdnMxM1NyNXBDdUtacVk4a3ZXUW1KSlZWS2NjejdONUpK?=
 =?utf-8?B?bjBRbjEveHV0eHV2dnR1RlBXakN3cDRJVWVaOFlGckJOai93Nm53bmNhTzFw?=
 =?utf-8?B?TGthZVkrMEpWTXA4c3ZzNjlVdS9vd3VKeEc4bkJpZnY0dzF5Q2dnT3c0RUt5?=
 =?utf-8?B?TlhPRnNBSlBLY0t1SHY5T0s2a015a3lrWExGdEpKWVpZUHkwVnFNUFMwVjdi?=
 =?utf-8?B?NzhxNzcvKzhEZmxQRC8vTGxIQkNRcW1LTnlTeTFWMnpuOUt0UEhVZjU0Ry9K?=
 =?utf-8?B?Nk5nY2VjbE10TGZtNDVmWjlpZjIvUGRLNE9SMVpPM3dMcEpvQUFjb0Y2OEha?=
 =?utf-8?B?Ymd0eXZybEcyNExoUkI4SVRJUW5MRlNUeHM5OGJrb3k1YnRUd1JvWXFSN2Rr?=
 =?utf-8?B?ZFBzUUh6S1hlT0dyWWJUWWdVeVV5Y2RpNnZaWHVxSFJEM3lyclF4OVV2U3VI?=
 =?utf-8?B?bGs3OXFZRXVDUXJSSEhueW9RaS8rbnRlZXFaN3hYSXRVeWxQZmM2clJodXR5?=
 =?utf-8?B?NTZaQWMva3psd1dNeVE4T09KOVpEMFpmZmRtQnlvdFZHSmJHTFNuTkd5RXdF?=
 =?utf-8?B?OEVMTExaRmJHek5Wby84c3N0bGl2dzVvbGh3bUV1WVJpZ2pKU0xJT1VWNlhI?=
 =?utf-8?B?akV1ZjVkcWNNUks0UlRSZ3JoS2w3aWVlMmFmRUIya1RsM1BUUUtWd3BDdTd3?=
 =?utf-8?B?dVVQK2diekFuZUI2c1VRTGxRV0paS0hrOERHZTZjMUVQS2YxZFJRVFJwUzFy?=
 =?utf-8?B?ZG1qbWpoamNkN3dTeVF6cS9LZ1M5UXpHVnFXTzNNRnJZV3NRWU5RUjlUeVhj?=
 =?utf-8?B?aTl0ajIwMVVUbzIzeVRaUHlnN2hHdjEzSkZ6cFRFbzBoeUMrd2d1V1NKcVlT?=
 =?utf-8?B?VEhackhXbmpxRkxyZFdQYkNEd1VMSzVIOWNxYWk0cGVicGQ3MW1QWDQ2bThD?=
 =?utf-8?B?dGJ3L0RWdDV6TnhwYjkrLzdwejNxa0RJYnJPNUwxMXh1VnhQTmNHUm14SEJv?=
 =?utf-8?B?VzZzT05VdU1CdnpOWVZlNHBVTDdkOFVjQzV2eFVKSjRPWUtlSHRPRGFSLzZP?=
 =?utf-8?B?eTJtNWNIS2xobnZpclM1THp5eEpDUitBeFZ1cGE5dS84RnV3czY3SjU5cEhD?=
 =?utf-8?B?N0xob2ljODl2QmZBK21SSG5MWUczVHRsUC8rbUtmS0RvcVBkZ3FqdGJtZFlS?=
 =?utf-8?B?dWdNL3g4bGx3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDBud0RGQ0RyY0JXVlVraDdDUytjRHVvNUM0Ti9iSE1oQWNYZmN0dE1rQkdZ?=
 =?utf-8?B?UUl2ZkxFY3dzcEZ1aXRxS0tMV0NteDFXZ3hIWmU4VERvTFdjcTJCUmNBY1dv?=
 =?utf-8?B?QmExdGNBUXFNVkpVcEJyamVBblhxMWhSMGdIbkRZNU9CZWtyejdEWG04WUpo?=
 =?utf-8?B?aXlieWFwbjR6K0J6NUd0YXBsM1dUa2FmTnYramVDZ1I2Z3o0WUtYVWszVkFv?=
 =?utf-8?B?ZFdsSWo5R3UzS0lialJUdU9vNE1rc1k3d3NiUmNXYUk4NVNxS3duMVZpSEIw?=
 =?utf-8?B?bFhRQW9hVXpaYSs5VnlCcDFYbGY0TE1NQVhwaUxhU1p1bldxSktVK3NBanpK?=
 =?utf-8?B?MEpVa21mWk1tWlpQM29QMVdXUWF1QjBMaDFlMVZySXBpN1cxb1hLUzk2NnY2?=
 =?utf-8?B?YmpXMTBoL0hjb2JsU3FFSUJtTlp1WHlWTEVQUjBwZkFqQUlwQUhucnhOODJ0?=
 =?utf-8?B?ck16bzJ4eU1BZmdibHp6SzNUNzVhRS95SHR1TjFzakMyd3BZN09pdElTRDNE?=
 =?utf-8?B?Y0FoSWYwUm5ZdFJZRnA2NGwrSHhlRFAvYmJlTEZJMFB2VWRwYUVjbmFCdXlP?=
 =?utf-8?B?V0F3THhBdU1PRGI4U3Y0dUhTZnJ1NEtzOFp4MUtEcklEN1ljMEJ4OTNDZ083?=
 =?utf-8?B?NytXSnR0UWljcEdveUpweDJNVE1McEhxMlRpRWtVVkQvUVpEVE01eFM2KzZy?=
 =?utf-8?B?MjE1bm5tQnpNRHp3dmpOOWlpNzZjdmQzUEgwcW9PR3JUL1JUdk1UNXFkLzRU?=
 =?utf-8?B?ZUR3YTF0K3hrOGo5OXhOd3Q3aStQVm1WR3JFODFJVW12NmkyMU1hNTVnTHdj?=
 =?utf-8?B?U0xyRVQyNncyMWJ0UTVhOUtzUEQzNW43NTdOdkVhMnAyTFJ5b0FScjhZUThE?=
 =?utf-8?B?Tm02QVlscnViTTZIektPM0lHR0NlVCtMY0pOK1h5SnkzSlA1TW0zYmt6WEwz?=
 =?utf-8?B?bGdVTHJGQURSYUU1SXVsM01tN0JTUkdMNVRISDhxRlZkYkhyekJBN0RiZEds?=
 =?utf-8?B?Y3h3SDVUdENyVk1FNXJyTlp4aTE3SE1xVlNESnNYdVljSDhYa3A3alI1Ymlp?=
 =?utf-8?B?eStkVjg3QThyZVFTYnUvSUtnNEd2U3htR3NDZG16TVpvckJ4U3YzcTZWVDhI?=
 =?utf-8?B?aktZQnFhaDdiZzIzbEhTUFZDYkJFNm5CRllRdDZxcTNGeUhqSStZVWpqSHVH?=
 =?utf-8?B?blZLSVFNTTRyYm93UGQrNjl4eDZrVkpkUUxKWHdod01CR2kxNUdJOG1KV09G?=
 =?utf-8?B?VEltQUZSQjZmMTJYaUJiMzJQZW1VT2JQendSQWt2V0ZNZTFxOTRTTnl1N2Ra?=
 =?utf-8?B?R3JNRkY0TmdXQkgrMHpMZ24weUhaU0tYQlFTeVp0Qmc3V25YaFpEclZRVXBC?=
 =?utf-8?B?U3lqc1h2QzhsdFFxUTZPYmNLeHVKbmdCMkdHc1FsKzRPanZocWpHOWNYcGxz?=
 =?utf-8?B?RHlzbDRZWVl6TlBFWW5RWFpOWDBEanlOR0t5VzBwLzE2QlFCdUhPTmh0bUVV?=
 =?utf-8?B?MDI2cjJvQ2duaS9rdWlZOXJyNC8yenZuekY0UmFITDFNQzFEdG1HSTRtZFB1?=
 =?utf-8?B?RWlVdmFBK3RrMGJZRG9JMHFtZ0hwQzMwRkYxWTVUWEMyZzdhM21EUnI1ZzJT?=
 =?utf-8?B?SmtUOVM4MmY5TCtrZjd0REJzbXJiMEw2a2NJZG5jOXRxQjRuOE5xV05ZNVBz?=
 =?utf-8?B?Q3ZmQXNkRHltSjVnN2xIKzRtdmxSYndBTDJmZW5PVFNVQlJBZnNoVjNpVGNr?=
 =?utf-8?B?N2JXMGsyQXh3eE5GeGNvYTFnUXA5MHlrSnJhaGREeFV3ckZEWHZoWTl6dHdr?=
 =?utf-8?B?LzY3WkNMazQwRWYvSklwN0lOK2JKV2F2TFNCZ2tSUUZwNUxwYTEvOHFCUDQ4?=
 =?utf-8?B?alI4aitEaHZEdjZrc3VidlNMRlNidmFScDI4UGJLdmd2d043KzZ3bFIxeEZK?=
 =?utf-8?B?WFBrOFNKS3RpRU1aUFBFWTNBditVbWJnVlIzaGpTQkRIaUJvZFZYbVBONk9l?=
 =?utf-8?B?V0ZTMzZINEtyclBwSmo4SEpNMnEzTHVFQ1V6MDVRVk0xcUNydGpOckZQYnJk?=
 =?utf-8?B?WFY0WE56MjhpTlQ4RWNMakxUUzAyY3J1bzA3RW9QYlRLU2x4d2dOQmJVR1BU?=
 =?utf-8?B?dGNtYjJ1Qmw2Y3ZCUk41aDhHU2psbEdld1ZINkRBTjRYUnR6ZGdUSXlkZCtY?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 160759c6-4fb7-40c5-6657-08dda31e61df
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 04:15:04.4053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJg1Lib+BU+utknoqtmzKwq8fT/3a+5sSxKIV1jtHsJVH4gyYaL743eUClc5GhcCWvZ3KbmXKvGRi19LeXHU/vDs9boGtZ8LfuqCYKEwEkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8714
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Creation of all files in the resctrl file system is under control of
> the file system layer.
> 
> But some resources may need to add a file to the info/{resource}
> directory for debug purposes.
> 
> Add a new rdt_resource::info_file field for the resource to specify
> show() and/or write() operations. These will be called with the
> rdtgroup_mutex held.
> 
> Architecture can note the file is only for debug using by setting
> the rftype::flags RFTYPE_DEBUG bit.

This needs to change. This punches a crater through the separation
between fs and arch that we worked hard to achieve. Please make an attempt
to do so as I am sure you can.

Reinette
