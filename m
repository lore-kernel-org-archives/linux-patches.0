Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62B42472B7
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 21:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752009343; cv=fail; b=JeRz1tE+oZjHV1DECkdUBgHjcTpu4FW/21D9SaxDE+kjCu1epmrLWA6QCQDDci786o29uz6xya/vPsVZeMrf/CyEOFNG458n5m1mcPkHf8zmzbgVzwnhs77YVVJWIqS8qWTzdr1+LITRab8iJvtt6cqo94uXkEC9J6TD3AsfTko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752009343; c=relaxed/simple;
	bh=Uy4hlb1+ZPBPoF2SvfkZe4ygp/1kiSXduIvIemjMPMU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YWvyCAfFGDzUwwxnVOzRTGIKz2AviPnICLskf1ujr/Pv5qlLxAL6lW6elKFPPA4Z2gUm/8uGzOB8DgD3wlsbIvGxYNGAT4KS1fmdPEYYVjXoVSbfsgUeslasAqxySeS4zOqkMZ4oRtQDPOGnXjnH0BSw+y6qaTgkknk9Cn/Hc50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ELWfxYtK; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ELWfxYtK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752009342; x=1783545342;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uy4hlb1+ZPBPoF2SvfkZe4ygp/1kiSXduIvIemjMPMU=;
  b=ELWfxYtK4Cn+/ooaQXOI5wL1WwDaOp9rRPn6iYBjqpzeEg+ZmnQkQoki
   iembhIdpn0Jq/dfLAsh/cEstx4qa9EF9baWgooKaWxF62g+6YWaodczHk
   nj3gqWWd3qd36etIFfrGMYl6ZcjhgIZTTiNsUG+WQ1r2tTX5E1ECh8wz1
   ghcu3T7dKEd/cgRu6yTzavekf30YPGu3IBji5dmiDP9BdkwDh2pAv5Pji
   O2l5IAEp5w2xq7vnllkTH56SocOQUniyJqXfAFqQHV8r9g8jiIr2xisKZ
   8aRV0+Lj7aJv2nOvghwq7VTaFV85YS0FCePcVPtdVZEuYRAv/umJJlJxx
   g==;
X-CSE-ConnectionGUID: b8Dy2+CsStSv9d5LbWJ0iw==
X-CSE-MsgGUID: 1CvHKD/oTrubNLLCWspYMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54392006"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54392006"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:15:42 -0700
X-CSE-ConnectionGUID: dyhZvmY5R+qk4WRDLCRtgA==
X-CSE-MsgGUID: yHnwb80FRt2QvWG0dgR76g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155924835"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:15:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:15:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 14:15:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.85) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vC1PwX5nDr/7cIl8IXpSspa6r20DFYniKC4xYqnxRVmpps3AJlMrmqwusty8lY9y8bTqeEujRBCsqIGssd4d9Myz74XIzdaqhepc9L+lg/vURaUPK3HKk6GDUbyykLGFg+AXyI7XI+CNU0VtqWaSJ2WNRjdWrGGHw7wxygRIDdXbyKN+JWU+hWzh0sJMV1ieCFpEt73fQcfwZ00sO3Ae2kETRf35Pn7/B2r7iHLtC1vPpT9y0yjHLmfi8dTJIwMZKBuOuf3yxdG+el18Q/xfQqy0wCT45BWpSTkm4/Q0vaol19xsjUZmbHC0EPMGwNiwr+SP0boQu2CLPpsLpk43Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFnbpM8pNBj2zPHosSZWaIXyIrjW1SVf4Y0NB7XCeq8=;
 b=KzgyMzPlXZnbCENUtn91FRZcbqdG/F10UMHOy9++dQBO5WrA8/d5fPu01wAgfeAbpb3JgfM5feofsXmMN4ytsE9W1lX/nSA46UPY0VMXdfBHgkHY+WPBErQH6ZvRuDnLgsuPLiYVg/VtMiZ3jTIMR02H+vQiSQMoUaTe8XSVnmoo41lIfBqeP34XJL8sjIfKtgq8s6amInGrEEEVcJCePFJDLzotXDOQRWSr9nAh/Wr0DlINtIYauSvuhA4l9fV1LKHtRrtLqyOsoW7GNhaub4T7jbTAw2RrFzydxYKFFliGGdOljviVSlsBWnds6Ck9CLFY0Vg7xo/QByNIhmoUOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7028.namprd11.prod.outlook.com (2603:10b6:510:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Tue, 8 Jul
 2025 21:15:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 21:15:10 +0000
Message-ID: <dd255670-72ef-4ce7-8713-b75975470482@intel.com>
Date: Tue, 8 Jul 2025 14:15:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 13/30] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:303:b8::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: 26b05bcb-b71a-4cd1-4c9e-08ddbe648583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0JFZzFtanRQMDFpZlBpWTdMSUZpWFVVOVB0TVhNUUtxNGRRTnpjbEVmZFhv?=
 =?utf-8?B?MENZWG1PSkd6MFMveGpHc0hoZlc1TVo1M3RVNHl5YTRNV3p3OGpjNktTRG1i?=
 =?utf-8?B?ZE9SY1FzOFFlQjNseUhscXQwMnZHSDBSN0txREdET3JzeklWVEhTSUFnNE9U?=
 =?utf-8?B?VjRtZTlOWEpjMThiOFlhWUxKZHZpb1R4Uk1OOVZEd1pmTi9TcE5POE9DQmNO?=
 =?utf-8?B?RDF5Y1VPU1p1YWFzTjhZR2tTRC9mWGRsc0doQUh2UlVXcG1UUVVBNGpqTjU2?=
 =?utf-8?B?WmVrUGFWcEMvRVVtS083RnorVURkOTdsSWxUQlNER1J6UkJMdmsvRHpqMUNk?=
 =?utf-8?B?RWMwWTA1QzVGcWYzeGtSUGxiZ3FuMW1zSzJob0JPalZnZlpnaHhXM2RxbVR0?=
 =?utf-8?B?R290M0ErdG4ycGJzWlBibk5Cdkw0OUhYWlI3MTg4VDU0ckpoM0ViSTYwY3dJ?=
 =?utf-8?B?aWJIaGgrK0JXc3VhNmJWRit5bTA3SkVFQllpR2pCaVM5NkZnMzllN1NKbWRh?=
 =?utf-8?B?Ykw3TlQrNXBFZFI1YXA3SFNjckxwdjMzemRibTY0UmNuVXpLWEYwcEM3M0Rt?=
 =?utf-8?B?ajZrNDBmL2lLQmluSkJsSGRpNXV3ZStSSFM2RmVmTDMyUFZvcWZHWndyTVN2?=
 =?utf-8?B?TUZoN0ZOVTBNK0tPV3h5bFJTaDhocDFPOFpyQ1RCR2FGczNMS3JpWXp1VStO?=
 =?utf-8?B?Vk1qcmhCOWx1aFk2cXlQNy9IeENYSGwzS0g5N0ZwSzhpaVlQQnFvSmtLWkdY?=
 =?utf-8?B?VGFLMysxVUhVVThKMzl4aTBIUFhwWllwUnorb01FWm8rWS82d2NuVUdJUVBS?=
 =?utf-8?B?YkdVWTYyelZBZDFGdmdlbDUwRHo0VmYycFFBYUdFay9rOStNZE4wN1ZuZmpn?=
 =?utf-8?B?bEpOc0Z5dmdHUzR2eW4wWGJFNmd2cXZBSGdKbFBKTGU5TUZ0Zy8xRjhGY0tC?=
 =?utf-8?B?RXJUUDRWT3dUVVA2UjQwRENBUWExYllCZWo1YWlzLzJBSkpSUFhvakY5MndB?=
 =?utf-8?B?MDJBK0tqT0VxSjI3RGZZcFF3RmlQaldPVjZPL3YzOExJM2VUZTBuWGtqMzAw?=
 =?utf-8?B?SGxYcWVPS2Q3MUhlenhYTUQvaU5Cd0NWODRteU0rRGRmK2VwSEJFVm5LZGtF?=
 =?utf-8?B?WVFKdURzWjMvM0xVcThvemxET05la1V4QnVRdFFRRDhmQ1B4dGhnU21xcmR0?=
 =?utf-8?B?anVEWk1VOTY2disyY29Jc1dZUWR4aDU5cDZWTEE4L1J1eFV3QmhUbmlHNWR6?=
 =?utf-8?B?OURGK252Um1IQm54K0VtR1IwRHJPTjVtL29ITjBKS0RrVVFvdEk5WVBPZlZQ?=
 =?utf-8?B?MDA2YTd1c2xZVytlNkFrOEVzKzE5MlllN2dUUUZzYUVCZWhYem9zUG1QUDQv?=
 =?utf-8?B?a0dxcEFEdXNyM1I2N0xZVDZvZXpqVHFDamhlSWFRck8rVFVOcDNPY0xxbCtC?=
 =?utf-8?B?QldQTFRubXJ1TW1FVThLUG5uT2duRFgzNmY5cmJodW9IcXcwUC91VCszdis4?=
 =?utf-8?B?OWsydHI2QUg3VmFMZWx2UHRyeTJ0QmN3T1E0ZDJiejg5MjFrWVdCdm9nZGNT?=
 =?utf-8?B?M21IcjZyUEwycW9waEpObkpQeFAyM0FIVGNSOXUvZVliQ2ZlcCsxOHlvUFo0?=
 =?utf-8?B?N29zMXR0UnJVVjZaS1YwdXIxWkhoYmFYUFBZTG9WNXVWTEF2UkxRODNwcCta?=
 =?utf-8?B?SE5veEdOS3pWa1VWT296bzN6SWdQc0hVNEtuRmxKaWQxb2ZEOUN4MWcvTkQ4?=
 =?utf-8?B?U2IyY1NKT0pzcTc1N21PcnpnTFlybzN6TzNkdmcwaWl0YmpQNk9nNVFKY2pl?=
 =?utf-8?B?bXJoVDhiVVNJVTVFTEhyT3FtKy8xWlh1Q3BnOHJVZzZZNXV0UHJqdTBLUjRv?=
 =?utf-8?B?d0lCNlBMekFYWWI3YjE2M1VaQ0NQSTJROTBVMEpMU2JNNjFBNDhBRy9hdi9V?=
 =?utf-8?B?bmhNbkZ4R3FoQnRpRjNLRGVWTkZFY28xQy9JWkduU1lQNEJidmhsNW5KUUpv?=
 =?utf-8?B?cDlIaUtrN3B3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N29ObXNvU044SUFLNW5ZTnlBYXN0UWd6Zm51a1hkNXFmMmQzRDhjdjBrc1U0?=
 =?utf-8?B?Ty8ycTlTb3Z4bDI0SXNzS29QcE1DdmJTbmRVZjRhNXNpNENlNXVNOHQrdDgv?=
 =?utf-8?B?ZnBZaExvR2hEUm5DOFpUOFdvVGl3M1lVL2tLMWo1R3V2QlJhSVdxU09UYmRQ?=
 =?utf-8?B?UXJrYitWVkVXcXBrcXJFdEZycVl4OXowK1RIYUpNam9SRXd4WTh0TDhXZWJB?=
 =?utf-8?B?REdUbThDa3RWOWhaRHM2MVZEQkpId3czQ1hobWFNZVBhZEFndlg1SEFjNHJ3?=
 =?utf-8?B?UExuVm9TNm5FK2RHNUY4K1Y5QWViODVKdzVmYndmMlQyWTZMMUhuRnFzV2NU?=
 =?utf-8?B?UTlaVERMT3hJSVhZcllodTlhTW5lZEFOTEk5QWxZdmpTMWdOVjZZTlZBQXli?=
 =?utf-8?B?SDhMZFJ4akhGU1RaRkMyMEtqbDBjU0NrK2xKeVppRUZMT05VL1BVSURXbHl5?=
 =?utf-8?B?QVEwL01jWjdOMzhWU3ZDUXE1U1Q2RFU1UWYvZUhHVmtyQWxsN0Z3Nzh5OFBZ?=
 =?utf-8?B?dUFoUFJGNTYrYVVPcHcwMlBjTjVrN0dOZkQ3T3pITEJsVEtaQ0V0Qk96b1BJ?=
 =?utf-8?B?Q21jbForSHRDeHNvclNqaFFZMW9mNStURlFsQWFEYzZ2MDE3aHQya0lQOWZP?=
 =?utf-8?B?ak5UTExhWk4wdGpRb3FsVG1qYUxhaFY5d2VyVnlFWDhac1UxZTNsekkwejhI?=
 =?utf-8?B?Q1VtVHUwS3hnVDJBNTYyVU1QOUx3aFdqdElDSGxyNkNnMUd6SDVrc3ZqV2ln?=
 =?utf-8?B?SG5YeDd3dGV4a0YwZjU5ZVpML0RKUHBucFg5TXRLa3lMWFhudTE4Z2haQ1lY?=
 =?utf-8?B?REdjdEY5YythTks5L1A2YmFpWVp5eVBqZ1hPYW5OT1k1N2dFejZPWEh0d0t4?=
 =?utf-8?B?bzgrdmRtczRBZGRFWHpUczFHWE9VdWNvL2NNbXM3QXgreUFZTU1zd3pxNG1o?=
 =?utf-8?B?Rmc0MXRRblhlS2ZKU3UrTWd2Ky9OaFczSUQvclRLQndzdWN2VVR5S0VLNmgy?=
 =?utf-8?B?MVZrdU1oc2NKdDZNUUxyNS9aNkJCVjcxSXRBV0w2UkJEYVgxdjNORU9tWVYy?=
 =?utf-8?B?TUlVQVlFNU90T25HeFRTUW1XOGo4Qy9vdjFDR3JKdnF5Z2VzTjducGNmRnFi?=
 =?utf-8?B?blBaUmlabzFIbE5PNWU4aTN1TlBOd0Z1a1p1bEFyOE1aM2ttRXc2R0ZSTmR3?=
 =?utf-8?B?VFVVcjlBVERqSFZpMGpYbUJ1a09RWmFtY1JTYVBXWm94UjNlUkRsVjE4dC92?=
 =?utf-8?B?UHprVFduUnoxWGw3UXJJejNpU1lrRER0MWxTN051dWpZZnpiZEpFRURodFh4?=
 =?utf-8?B?UFZseEJRVVZMSDRJQ3VKMlA4Uktqc3dQSllaSjY2dnI0SmVSaVZIRS9KaXhD?=
 =?utf-8?B?TU9abFRDZi9KVlFmMmVrTXhScDdLY2NheTRTajRoaW9vVU05MzBRYVR0YmVN?=
 =?utf-8?B?cmlkZVNCd2Z2MTNxYnV3bzgwSkt2VmxWT09oaWtQK2QrUXpLRVJWempBQXF2?=
 =?utf-8?B?T3k4cFlBTnJub3BSdmdnQmUrcEo0dFZGQm9pa2ZOK0ZYeU5GSGMrZHZHanJN?=
 =?utf-8?B?TGlQU1VEUUtCMDdNZUhXQjBSR1l0U09DUm5IRjk4YUszeTJaTkx3MmMrRnFk?=
 =?utf-8?B?d0dGa0ZyRUZnUDVTbytWVFcwb09jQUx5ZEx4aHNNT05WUmtmSkxQaTBJcHBh?=
 =?utf-8?B?bVArbHhjTFROeDRjSzE3RkgyOGtkd05sOHRzL29YSU51ODNVRVY0RTNpVXNn?=
 =?utf-8?B?SDJCdTMxMHU3VHhDWnY5TmFwMGJiYkxlRjZMOE11dEpKRTNLWFNWcDNBWmtL?=
 =?utf-8?B?Z0c3cnQ4Y2RvNEMyN0MvcEJnRTZkcUlSNkwzTytWZmxDQi80b3pnc2ljbkxF?=
 =?utf-8?B?Ym15ZHRmUDV5TXR6RW43OEhHQ1ZOVEFvMWJ6bFZDMDFOSEs1VGpoN2RhS2pL?=
 =?utf-8?B?Q2hVTkdQOUk3bjMwZmxFclJwQ1NlcFFNOU5KeTlVVk9XZlJ0SzM4eU5KNmIr?=
 =?utf-8?B?OFZNZUpBc3Z6Ym1CTWJvOTk2OGVSQWNYNlZ5WElCNVJwTVVtQXFFbWU5WUg0?=
 =?utf-8?B?eUtmVkdjMkNrYzVLT253UFlkS0xaK3JFSkkyM21PbXNXN0VqaVU5WVlmbm44?=
 =?utf-8?B?RHE5Y2Z2a0huSkdwTERDRGZqNkNmSkVMa2hZeG9sWGhxWHFyUG9aUUkrRkRq?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b05bcb-b71a-4cd1-4c9e-08ddbe648583
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 21:15:10.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6UVlORWrBu7+ga5DYyCnQg4pu8emnr4I5fzIgohdDD02sf9lhAsbbgPzjOUJmqxkw1Ingmi0ymwhR7OdxwZ5We0thZeo1t7lhw9ogj1aUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7028
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 6d4191eff391..aec26457d82c 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -356,11 +356,30 @@ static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
>  	return state ? &state[idx] : NULL;
>  }
>  


Could you please add a function comment for cpu_on_correct_domain(()
to document the different contexts that this function needs to be able
to handle? I think it is a bit subtle how the function is designed to be
run in preemptible as well as non-preemptible context. This will be helpful
when somebody aims to change/use this later.

> +static bool cpu_on_correct_domain(struct rmid_read *rr)
> +{
> +	struct cacheinfo *ci;
> +	int cpu;
> +
> +	/* Any CPU is OK for this event */
> +	if (rr->evt->any_cpu)
> +		return true;
> +
> +	cpu = smp_processor_id();
> +
> +	/* Single domain. Must be on a CPU in that domain. */
> +	if (rr->hdr)
> +		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
> +
> +	/* Summing domains that share a cache, must be on a CPU for that cache. */
> +	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
> +
> +	return ci && ci->id == rr->ci_id;
> +}
> +
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
> -	int cpu = smp_processor_id();
>  	struct rdt_l3_mon_domain *d;
> -	struct cacheinfo *ci;
>  	struct mbm_state *m;
>  	int err, ret;
>  	u64 tval = 0;
> @@ -378,9 +397,10 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	}
>  
>  	if (rr->hdr) {
> -		/* Reading a single domain, must be on a CPU in that domain. */
> -		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
> +		/* Single domain. */
> +		if (!cpu_on_correct_domain(rr))
>  			return -EINVAL;

cpu_on_correct_domain() duplicates the logic of __mon_event_count() so it
seems redundant to call cpu_on_correct_domain() in these paths. Since
cpu_on_correct_domain() contains complete logic it can be called just
once at the beginning of __mon_event_count() and thus also cover the
rr->first block?

> +
>  		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
>  						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
>  		if (rr->err)
> @@ -394,9 +414,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
>  		return -EINVAL;
>  
> -	/* Summing domains that share a cache, must be on a CPU for that cache. */
> -	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
> -	if (!ci || ci->id != rr->ci_id)
> +	/* Sum across multiple domains. */
> +	if (!cpu_on_correct_domain(rr))
>  		return -EINVAL;
>  
>  	/*
> @@ -878,7 +897,7 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>  	},
>  };
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid)
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
>  {
>  	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
>  		return;
> @@ -887,6 +906,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
>  		return;
>  	}
>  
> +	mon_event_all[eventid].any_cpu = any_cpu;
>  	mon_event_all[eventid].enabled = true;
>  }
>  

Reinette
