Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C725C2638A0
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719854; cv=fail; b=bKV38Mf//YxArBCIubqbasYWLrE+/omOZlnAUlxgKlTyjVUmMUSS/J1fgAMl2FgYKUNccpk9jJ4sdnyUkSQleSDQKTS8UdBScJJewHr/CpbE2864HBGGLKE5f5KgmJeTXq3Lndg1zGWZJzn9DElAjDpt2Cks8j2I0Raxt0PpLAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719854; c=relaxed/simple;
	bh=IKhNQ7Wp7KoqZiY3T6nkpTfzROiIGpGNI2LycMwRIQA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CgR0rz63ihwyKYWC4YV0UAVfympcqsEhBVhJ1Pvzw2AMt4+dPsAQ4alO+wZEqOenuLELm3p3kU9F8lBQuE+scgicl2YrqAWzyP+lqGPCKLArvUMN23aLaPJIfvFYQ8FsN6EA2yINstI9rs56qOIprKWh1hier+6v/C+xglDh92I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QYrAi8gt; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QYrAi8gt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719853; x=1778255853;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IKhNQ7Wp7KoqZiY3T6nkpTfzROiIGpGNI2LycMwRIQA=;
  b=QYrAi8gtTyY5BudnQZRm9u57pCEPZYdhxiFpUEsuDm9nbbWTIdgkzwM4
   9f5/jWzPhJN4GRQSA/zLqPFs6JtNpNFA08JTsQaYFdJLbJUvCvU7KTA1H
   PfXQcO1g3e9sOFHQQPe/fne7KTjqCu7K6zAEWrDlD/MnB3jNLc9iKPZ3b
   Um5O2x6GEVs7zRJBgoPlkNDZld8Uzb6k395Sn3WMJohcZzYvPKds/YZYc
   CtDmqkvaXomTSOj4/vFowdoaVCOF0UR3C8AkkReHdeiFGGXyNiV8hnk+/
   ZVUo6V1jL0dWyC0wbBK2H3pElaJkYovyYwhi6YjtC5UPQem9bUXk0bzJS
   g==;
X-CSE-ConnectionGUID: K48vWWHiTSeITIHybcjyeA==
X-CSE-MsgGUID: 7a2EzA4lT++pAeK4P03Crg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48224216"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48224216"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:57:32 -0700
X-CSE-ConnectionGUID: +iXqUewoSQi3xK4XKrgL5w==
X-CSE-MsgGUID: u05r+oQlSa+zeP5QhKHIsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="136296717"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:57:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:57:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:57:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:57:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F5YxLtCQGEd30FsxhIvY5+G8H0lHnI8qF6GlYJHcs3S3ZSDpc+mft9kzovkFOmVKS1Drp5KRC6REEkcyB06WRjRgkbUeSk3aZiipJ/3HqvKHFYc4GMviyLqDXhoQuuDDF91fBzsDJoVnuawnQ+vqE5ZjAQf+1Z9FfuTrKPTTyACzTjDEiYtb+DgYW4tekotGMDwTxHm1tLAUxfKv7K9gqsQTlWv5+geIwwgXGux7QYl/9fRV0E+3fFJucy7qdF/0wngv3+WzLBL81nYVMwBXHJCBSKTAtLSr8t/ap1WGG8MCIROVLfexIQr7HfdWISijEpeWOC5nIFdonhOXLDa2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiDEp21i0pSOeBjSlaPjFHpaA+djYCXjE8CIgRUF7es=;
 b=gHjQ4jbZ/aWbnGJD67TNWY7KnlQ6pMrQu44vsu73EsD7zJ48IVqLHidiu6O+dnHJCuDjKoKPYSwA6SqvgkjfR0V3rjnXJM3dLyOmd0bUSfFfpn8YJ0lrzZeJbcNJ/F9/zqqzLrSOIZhrCQCXNpgHRX2JtB+Wm3aEF0yRTlg004DOwv0dd+OLBMbprOwdvspphxYZ7e58nqIhyAAyKYp6CUK4FWTBHzShHEgvu0Kt12JNPQo0l5OS2LjHIsam8CSrivq0D9f+hJ4yZiVQtxMtJv8Gpiqw8v/WLkHBtWqJvWfIjBWlcCVPWldb4Nf4o9n3jn5G3rUh57uhdvW6Og/81Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF0D43D62C4.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::80b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 15:56:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:56:42 +0000
Message-ID: <4ff8267f-989a-48ce-b6b8-1df302d00d6d@intel.com>
Date: Thu, 8 May 2025 08:56:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/31] x86/resctrl: Check for adequate MMIO space
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0147.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF0D43D62C4:EE_
X-MS-Office365-Filtering-Correlation-Id: d806f373-399a-4c17-9e64-08dd8e48ed37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|13003099007|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZDBDbk45a2pUOVJHVlc4SytRWHJqb043UjdYWEZIOWtwTUJCZlZiL3d0UGwx?=
 =?utf-8?B?SUpNejY0YWpnNE5nb1ZqOHRTNzVscVlEV1ZScW13QzdVT1RQcjg0UzltdWJr?=
 =?utf-8?B?WnlPQ2JoSWhrbVBFZjA1dWJaQkxNS2FQaUx3b1FONkZQYTVrNU1hM0hvSU1B?=
 =?utf-8?B?a2FmWG9NSFEvZHZ4aWIzaWErNkhlTkJTdXFwa3VMcG9zSFJYZHNtOVZFL0xn?=
 =?utf-8?B?T0xTb0tCeG9BY3A2MFNuMHkrZ2FCaDNQV1ZYQmxIMEJibzlaRHkyZk1pT1Js?=
 =?utf-8?B?OXI1U0NiVDFFVWp1QWNnaVAveFdBMkhLbVc1UzRidDU2aWg2NEFJaW5qeG9T?=
 =?utf-8?B?Q1g3OWFtQXZ5Q25CQ3lwT0RGZnRyYkRPYlhaZGVzWndBR3ltSjJlVGN1ZGxm?=
 =?utf-8?B?c1BZUmNyc2p4bzQxT3RONzFoUm56c25xd1cwSmN4TlVaaVRwdEE3amZ2Qnpy?=
 =?utf-8?B?cUd2byt6YUloclZrU2hnd244R0Rsa2xOeHdnTWNNNFdaT3IyRUh2eWl1VFBj?=
 =?utf-8?B?eDRFNWlyeEJSMXAvSnVMa3oyM1JKbzVaa0drN29yWlp4VHRvbzRaNHhuMU9B?=
 =?utf-8?B?SElwYzVKV3ovdU5uUldocTk4UVYzcDFxQitmd0N1MXRVYTViNng0T1hwQ21V?=
 =?utf-8?B?QzV4SVhRNWhTOGVDUjNmcW5QZ0NmNjBnSDBTSzZUSWNJcFNKMEIwMlMweGFM?=
 =?utf-8?B?eEt0OHlpVDEyakNsb25VbkthaEhZcGVCK0NDWHZUNlBpOXZXSlRvZzgvb0Zu?=
 =?utf-8?B?Q3dnVFlzM2lDNXlkSitvemVVWS9Ga25ZQ0dSR1NoTEFXMlIyUmNZM1crNmJk?=
 =?utf-8?B?MkpEcW5rbVFrVythMUlMQ2F4NktrYVhrNW5VTHBwRFVWVWxLQkxpNCtDZldO?=
 =?utf-8?B?dXpwR2QvZ3BYVEN4RU1RSDhVbEtFL0dxZFdBcGEwVFR2R3cvMmsxS0JJQ1JI?=
 =?utf-8?B?RHE5QXI1eCtSQjZIY0V0dVIreUFkWU9GdGJVaG9aMVU4bVhUR2VSMjdWaEh5?=
 =?utf-8?B?bXlxaExEM0VmZjRLSTJJMEd2TXZJbVJhS1BSa3lzSjJadmp3Rk9aL2EwclFO?=
 =?utf-8?B?QUxUREZTVXZ2MCtvVVlKdFAyc1VXaHl2VkdDRUpzeDk5a1dPWmhXd3FjSjNp?=
 =?utf-8?B?UHpRT3ZKeE1mQS9HRS9QQkRsWERZK3I5TVZiUm5OTlV3RCtScXREY2xUOUdF?=
 =?utf-8?B?azRvUFU0MXJndE1SOHRQR2U1NGlkR0ZXOTlDd2lpOHFONnBLVkIxdzVzdDRW?=
 =?utf-8?B?L29BbWFzcXp3TFF2OEdBbHpYOGl4bjFxQVhCbEoweU1MdXB3blRxQnNSSjZL?=
 =?utf-8?B?WEtHYmsweTFYUjUzQ3BGUHBHVVZjTHBKYVNzNE13QmVKV3FBc3l1VjRMdTFL?=
 =?utf-8?B?UVpnWm5SQ1h6L0N1S0dKakthVUJ6OEtHRmlFUVBwL3RhYUhLOFoweGJ1KzdC?=
 =?utf-8?B?Wk16WnFtSFNWMllaYTRRWjRXaTYzY0kvcWk5QjNVWUFFK0hDQStLQmlCdHh6?=
 =?utf-8?B?ODdhUE9NU0V3Mjl4ZVdxdE0xemtZek83RjdBRllVR0dCdVBDeFBOMWNoT3Ew?=
 =?utf-8?B?cjFrWTdJZlduR0dMMXVmd2xwajhyWVdRZ3MxOXVYT3dYamN4WFJERy9FS2o1?=
 =?utf-8?B?aDZObUdlTHdXaTJlM2FWREt5NVhHN01pVEpKcTQyb21Ubm9ONjFGNGhja3Mw?=
 =?utf-8?B?QlFtUkRvcStkbjdBNHAxREE2OGhQYmxFalFHYlNXby9WVGJQZzA1eDhQMlJm?=
 =?utf-8?B?a0JmZ3I0MG0wdHZ1R2luUWlxVHNXWThrR25iOHlXc1NtODNCb1MzRUduaEh2?=
 =?utf-8?B?UEF4eGJDdmNOQ0UrRWtTdXoyZUFjOWFlMTI3VWdQV0xCSTdhNFRMS1ZvRUNo?=
 =?utf-8?B?Wm1pbXd4NWp2WHNrelZuS3hvVnBMRTdVRzNTM25lSlpHS3g5SEwvdUFwODVt?=
 =?utf-8?B?U2VvZmJtK2gvdlVTQlg2d3BYazF6SEZIS1NWSWJwKzdGT290SFJqN041ckhC?=
 =?utf-8?B?dE1tZTJBRjhBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFJyYllOVEEyeFlRZFVwYVVNUE5XMTdqTkRpNjVyMzRuaElkU1FwdThRcjVa?=
 =?utf-8?B?akpVMlhnWEpyaFRyU0s3OXdaVUFmM2ZmQmdtMkkxbUZBeGZuWUxwZUVocDVj?=
 =?utf-8?B?YU11MXNubHBKMFczRGxhSG5ocUtybE4rUG5oRHFEeXlGUnJhcWd3VTc5bkY0?=
 =?utf-8?B?emhjREhONjBFUmk5OFI0MDRyY0luSXN6bzZ3b29pMlZOMnFGYVNWK1B0aldk?=
 =?utf-8?B?b0x1TWREVk83OHAxUHZicGk4bU5oaGx4aTBsc0xDc1NNM1Z3ek9qQjVSMXA4?=
 =?utf-8?B?YlBuOGhaeXFNd0NibmNIN1BpL2x2UFRSYjlTc3FkY2M1QUZvaTQxWG5tZ2Uv?=
 =?utf-8?B?cmE4Zmc1cit3eEY5Y3cwZE9MblFOSXdKdDRRS0dLODlsTFBzckxFQ1gxa2ha?=
 =?utf-8?B?c3ltTHd0V3JkL01xQzVZM2syUGNyUmFEemd0dmN2V1lxWVRwQnQ0S1hiSWRV?=
 =?utf-8?B?U1dDdmI0VW1BRnhadVhQM213TldGMW13UndHLy9nZitJR3VDVkR2N05MZ3hD?=
 =?utf-8?B?dlI5MWZIOGlhNkp6RGM1RDl1RzVmOGNKKy9QNTEyVlN0b2paMlM3RU1Xa2Qx?=
 =?utf-8?B?RG93UEc3RnNhSHpIeTJ4b05nbkRTRFlsZ1kvRDEzd1lkeGlvaDhqb3VPbjNM?=
 =?utf-8?B?RTR6b0pRQU8xM1cxcWIyaXduZkFyOGd2K3JBNWpTcXZ0OHZ2ZElZOEo4aFpw?=
 =?utf-8?B?NnB2UjNlYjZXaFJXMWdiM3hUcCtVYktiMnVnNG5OUE5wWDFaVVo5UFcrdDQ3?=
 =?utf-8?B?ZjBQaktGYVFNNFFibHRCYm1taHhTTWg5VjgrRG1oVFFRR3luL3VjM3FlckhF?=
 =?utf-8?B?am5kMXJINFBKbHZkNUtzZUVPbXpEdXl5WGtLLzg0RElxazEvLzJWZW13WmZD?=
 =?utf-8?B?RUM5eStZNXd4Q2Q1UWNKVFZ1TVBwRWQza00zZHFNUk9yY244akduUjY3OUhV?=
 =?utf-8?B?eE1ySkd1VUZMcXhzdjR6NkJ6enpkQkVJdnVydDRRRnJxSFRJQ1FaREwxL0E5?=
 =?utf-8?B?dEtzNE9zMVFaMzh5K2NXY3UrR3JoaVFQcmN3blU2YjhiOE9kbzl6R1lOSGU5?=
 =?utf-8?B?cXRkd3o3MUdCdFZXeFc4Q0dBU3VRUVZKaEpNRlpiTkJZUkNleExFT3pzK1Yz?=
 =?utf-8?B?bGZRdVRaQjZ3WjYxZEFsNzR2OUNldkdXcnhlWjFmcEt6M2dsTzZWUmNKME5q?=
 =?utf-8?B?ZUdnNTV4dGludGxHaUdrSzVVQ0dNNDNKOERvV3V3RnZiZG9RQld6NU5sU0U1?=
 =?utf-8?B?Y1luRHR6WFFkYXRtU2tTTUgwTjBZWWdTb1dMUExmdXFsOVpEcmNCc0hHbDEr?=
 =?utf-8?B?NkR0YS9YdlFFNnVCWjZuVm91eTFvRUE2USs1dGlTTzZRS0R0czBUeVFNZE5y?=
 =?utf-8?B?OVMrTEpDUm5vc0hjS0R6YllWSVB3bVoyRzJpVG8zb3c4L1A0WHMvUmJQbFB5?=
 =?utf-8?B?Z091Z3Q4UVpKcEExOTVzRlBWTjlRSldSck5UMUlXZDVOcG9sakJzenZmTjdT?=
 =?utf-8?B?bmZkRGM0b0lZVllOWG45SzkyM1dhTEJKSThKOWdZaWpydytBai9oODZnUWJU?=
 =?utf-8?B?Nm16V0FUSGo4SWZ1MDVuL25McUFzTDR4M0VPUjRNNDhpUmo4cmpCZnQ4T2Jr?=
 =?utf-8?B?RmlMUy9FMzVIMmg4c3QyVmVWTWlQdTdubDMwT0VIYzlHaFdjYlUvMmt3Rm5I?=
 =?utf-8?B?bTNWb3JBS2V1b3JzNXA4T0FocDFNUk8rNlFjdFhqUVlDVGpBU1Qvc29MdXIv?=
 =?utf-8?B?Qk5LR2RQRjVpZ3ExVlFuWEFHV0xEOUNURlF2TDIzelp4Zk9ZdnpSenY2a3A0?=
 =?utf-8?B?Q012M0dFeWRWaGFGVytNSG9OeXV5eDRnMHlDWkMwck8rbk41V0ptU3hUTzVL?=
 =?utf-8?B?RFRvTXlaUlNjN3hmZndINVpaVG52ZGxsb0lIS29aUTZBcjFVSGNnaXhrQ2Ju?=
 =?utf-8?B?eE5EM1BUS2xpZWtXUmRKZXRUSExjSGdPZ2FtV3Q0c1lua1NVYzYxSG9BSnlQ?=
 =?utf-8?B?WmFpTlpCaXY5aEw3M2RuTkNsY09FL0RyNmxaOVFCMmpCUVcvMndVOFFRd0h0?=
 =?utf-8?B?cEpRR21ZakJGK1VPTVNTSWVBbnZHRDJZN0xhSjJSc2tzUzcwaC9XQkRkbGpa?=
 =?utf-8?B?OWRPWmljUElnYThSYjNqUnE1SXVvOEpiUFZpd3pYQW4wbkd2T0h6azFkSmpx?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d806f373-399a-4c17-9e64-08dd8e48ed37
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:56:42.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j1bSTzd8VZTeL7Jlii6mLDAQ8RXi8rMkgpubyY8oVOcPRmsmVRHUM68ufpJA1YgrLXmIGH4VnXngzGTh/1BUcxBFlXC/L6GofSh37oHTLVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0D43D62C4
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> The MMIO space for each telemetry aggregator is arranged as a array of

"a array" -> "an array"

> count registers for each event for RMID 0, followed by RMID 1, and so on.

"count registers" -> "counter registers"?

"followed by RMID 1" -> "followed by each event for RMID 1"?

> After all event counters there are three status registers.  All registers
> are 8 bytes each.
> 
> The total size of MMIO space as described by the XML files is thus:
> 
> 	(NUM_RMIDS * NUM_COUNTERS + 3) * 8
> 
> Add an "mmio_size" field to the event_group structure and a sanity
> check that the size reported in the telemetry_region structure obtained
> from intel_pmt_get_regions_by_feature() is as large as expected.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 7e4f6a6672d4..37dd493df250 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -49,6 +49,7 @@ struct pmt_event {
>   *                      retrieved from intel_pmt_get_regions_by_feature().
>   * @pfg:		The pmt_feature_group for this event group
>   * @guid:		Unique number per XML description file
> + * @mmio_size:		Number of bytes of mmio registers for this group

mmio -> MMIO
Can append "(from XML file)".

>   * @pkginfo:		Per-package MMIO addresses
>   * @num_events:		Number of events in this group
>   * @evts:		Array of event descriptors
> @@ -56,6 +57,7 @@ struct pmt_event {
>  struct event_group {
>  	struct pmt_feature_group	*pfg;
>  	int				guid;
> +	int				mmio_size;

Should this be size_t?

>  	struct mmio_info		**pkginfo;
>  	int				num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);
> @@ -64,6 +66,7 @@ struct event_group {
>  /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-ENERGY *.xml */
>  static struct event_group energy_0x26696143 = {
>  	.guid		= 0x26696143,
> +	.mmio_size	= (576 * 2 + 3) * 8,
>  	.num_events	= 2,
>  	.evts				= {
>  		EVT(PMT_EVENT_ENERGY, 0),
> @@ -74,6 +77,7 @@ static struct event_group energy_0x26696143 = {
>  /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-PERF *.xml */
>  static struct event_group perf_0x26557651 = {
>  	.guid		= 0x26557651,
> +	.mmio_size	= (576 * 7 + 3) * 8,
>  	.num_events	= 7,
>  	.evts				= {
>  		EVT(PMT_EVENT_STALLS_LLC_HIT, 0),
> @@ -134,6 +138,10 @@ static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
>  			pr_warn_once("Bad package %d\n", tr->plat_info.package_id);
>  			continue;
>  		}
> +		if (tr->size < e->mmio_size) {
> +			pr_warn_once("MMIO space too small for guid 0x%x\n", e->guid);
> +			continue;
> +		}
>  		pkgcounts[tr->plat_info.package_id]++;
>  	}
>  
> @@ -151,7 +159,8 @@ static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
>  	/* Save MMIO address(es) for each aggregator in per-package structures */
>  	for (int i = 0; i < p->count; i++) {
>  		tr = &p->regions[i];
> -		if (tr->guid != e->guid || tr->plat_info.package_id >= num_pkgs)
> +		if (tr->guid != e->guid || tr->plat_info.package_id >= num_pkgs ||
> +		    tr->size < e->mmio_size)
>  			continue;
>  		mmi = pkginfo[tr->plat_info.package_id];
>  		mmi->addrs[--pkgcounts[tr->plat_info.package_id]] = tr->addr;

Reinette

