Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3164A0144
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790262844; cv=fail; b=L7t9aFjKOU/m2Djim08B7ETntEg9tmwct2o7mG1ecx0jqlZExvhq3DkNb+vOmwd2ONeoH37OVwaR+aSUwVw7r9LZVfY1TB7W9hXZYWHFIqRDBwHQgvE2Mpjag0BcYnHPhRDf3NdYB9Hm1ZIZHv35E53ks1z5jyZxiGX3Hq3+ZF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790262844; c=relaxed/simple;
	bh=lhRuRN/dMY6a4z/OzGVL5OqjDRO6PmqRc3zH+pghrQo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O1jfszscCGyLEJqfDq5jmzQBps9eKhhVvPFsXLfUHXJaqMQ8rdDWWgGi4geK/WvXqmIR0rENAuLhQTkzset14hoTxxXSbRriyy0VhCfZdu5zQTB2Q0DYRbnVwx4Y3j9r2S2i4aaYtzaLPh7T3YJg14zxjocOCUBhDl1GHZMwiF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fdFRBJET; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fdFRBJET"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790262843; x=1821798843;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lhRuRN/dMY6a4z/OzGVL5OqjDRO6PmqRc3zH+pghrQo=;
  b=fdFRBJET3ZWiFrg+mNbYa2+mqlhTJA9HdjniGk9UNYpe8fTZnTuqlfDc
   +C/2SRf2od57u9xwX8rXr7qjRQqBbI9jsbqOnGh/cE8kzgJWrcVQYaD/W
   RDQrtEQdr7BR2ThYNpy0vGG1p8fLQSbCXM5HgHwdmxzskmkzIYeAHCJ3f
   cbG9uEHRIF7zmteRcHe81i/qnEJmYpAcL2a4yFqPUyjkLW9EQBz4/7yKI
   /92Kz9oDBldeOc/aJVIgL7JjEAjEYNhdJPtMDbZ1yT/2IRn2zvDHZM8WD
   qIWy9igzIyNYJkyv3J0KOAZvYd14aVQrhER8AZUXniKJ2NQpj9mQ+gw69
   A==;
X-CSE-ConnectionGUID: KoLT1K6sRl65mSF1iNX4ow==
X-CSE-MsgGUID: ZXwK7iB+QfSqq2iwoyPTAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101616353"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="101616353"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:14:03 -0700
X-CSE-ConnectionGUID: Nt6YDOAoSk6msO9HoAwXIg==
X-CSE-MsgGUID: xhbP1YPiQQWeqlg/zkY7oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="277812797"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:14:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:14:01 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:14:01 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.20) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:14:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fISAAIzCJOzfXHbqBikdp5bTqBPODDbAy0zSnDSMMC8AhUxodO1VXBfJZW4c15xwl81TW8DYAQ5xElrRuI5bJ8XEPfdKSyn3nSOb+LkXV13+UWz14TBDJDKcx1Jz3wNZIrt8NiUbV7eYrT+etJcNVfc1uHvd/qbYJyoCxUcGES4nNyyHPZ5uDELdi0ftgLVyD2jvwf+SyEUNsE3UUjTg3KsxYHokrQSVYGnISRrwUnLNvFjWoaaclk7K0FNeWabGkMVZBalW3Jdd6sSFTuQvPCgL8MZa0MZVPknzcWn/XeLhSxz7w4TCaMCo8NkirflKq+lCIcWnEjP15cbkRxYLSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZDYEQBUsCDaOAUL2rXt6Hwz9110VFt5UVovolx5jhI=;
 b=Qxs7l6BSZ1z3Q9nQslbCgf6XiJ5nS7n9UjHlF3wHCKB8vtViM9IFyLEypPkURKZalkOswV+/SZVgkWZzJW9uLmQQERPB6KSL/lPBFIZ/KiKyNt8yLP6xfkdsVu5RO1NbF2NDNvVqZZ2jIyGQUWCMjbKqOvJX9S3buWFaXWEeif7PmWgMAy4b4FOu4h05fsy3pGvt3bhQzZ4tM7QsUvb2Vv6r2B6YOoBGUps9DZHKvxg1aOYJ5dWKsVtNB33bWGRvW6ksHT8PGm33s9xQXAR5/S72kk/WPNRmu1Zy4LzQKaw3T7a/0Vm+1OX3zZsah1+1NpWmWr8xsgcOnybi1HyZmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MN6PR11MB8195.namprd11.prod.outlook.com (2603:10b6:208:47f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:13:57 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:13:57 +0000
Message-ID: <430f74d4-5d04-4f95-b7e9-83dcd5cd5ba5@intel.com>
Date: Thu, 24 Sep 2026 08:13:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 02/25] x86/resctrl: Check if monitoring features are
 supported
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-3-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0019.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::24) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MN6PR11MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: a3657b31-8259-44d5-db95-08df1a4e7427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|921020|4143699003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: sFcnIwpXZGTalndUQx7LlOBhveasyHz46XI3v2aqqirhEl+EmWY+6IIHct26CuUj/Tlkbt0uApPpzwarV9GkMkLCJyJV/7gp+n6nB+F8fq5igx+QrFtmLeqphOncxB+N2TtEJ32zTMoruY7a4Dl2WKQ9QiAMUide/+kPPiNRGlDxUJO7vAYzQu/HAa4vaFg42Kjm1qz0adDua4mRI4FODw38wgLFpUdHVbI3Roigiimbv2wOSlsWl0OYS+JY25Kx/7VG2rKd3jkoVPLbk+BNNMpgzxtBE8+TKXaMUKkZSBkY7yIjhOM5LmI1IOiMnmYqp292RPnAzTM7aAxVrB9kng0/pM1zaTX4J+USlX6K5/ZtUZcf8BFYjte1/BGKJlfvNBKBdzuERbt47DZyfMN7wE4Imss2xiOrNeNug+yqZ/U3r9LGdpfjfkQWElDBwIV3xgRR86Rec1PJ/db2SOcb452slKxIjpaoMnhMM96EASA1X8UCwkAHYv89aCuBi6DTaGyXF+DPyYBaYvUQ5WpyMXy68hLQHUSYvR4M4kVCQ/jwrZwnPV7smeEzcHVtWwOg4sJ83ybc4Oc+PU3Q5GVm+4PEEzjyaPy9mgLq+tdUq882aYe8v3S04r+Ej2wKpuMSH5ie1uXPaE7AaMp3W4wRr4VFky+wFkMiX4Y4l6xhHeZOUc14tdWtzRirbuYaT7yuM9HJHFkZPbv1q8D15MKG3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(921020)(4143699003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajRWR0ZmdDZEbGtXZVpsenMzUnhKTkdXSkRTUEgzeUJ0WU84WnpBUDd1MDZ4?=
 =?utf-8?B?RWpUa1F5RHRRSDZ4KzVUVm9WNkF6STFCNjlDSWNlV2U0NENIRXJCY1NudGJO?=
 =?utf-8?B?emlYYVFuU0VOaGFHOTJUNmZtQVBpVkg4RDN2aG1jL2pkdEpKdk1SNU1tVWRv?=
 =?utf-8?B?RjhoUkNUb3NINEtleWVFSUNFbWVib1BrTTh4VGphcmt2UEpIVk1rUHdSV2JG?=
 =?utf-8?B?OUlVRU9mVWJvRTc0aTByZEd2cWVucWErQ2VDRTZJYit3Ly9zOW9ZWTg4UlBl?=
 =?utf-8?B?ZVprUUNFRVFWYWZUMHliRTZGMUV1S3lmK3ZETThIYTdoeHFwb2NqTVYxQ2tW?=
 =?utf-8?B?Nmk4eHgxd1JEakc3Z1kxZmY0bWlvb1g3OGY3LzVWM1dsSFZEV2xWQmFEWTFD?=
 =?utf-8?B?OVVhK29nWElyN3h4c1VqZjkydWNhbEZiZUwweU40OW5wZUxZSCt2R1R4NExE?=
 =?utf-8?B?T2lxMUpjNDgwK3dOMWZWYmtDMVZCM3pzRVlEVjE0SFAvRjZNTzZwb2E2d3lG?=
 =?utf-8?B?REtyNk9vZ2ZnTEpYLytYMndIUFFlVzN3azFwZ0hENXFDU1BZRUdTei9VV3lO?=
 =?utf-8?B?Wk5UcmV6WEdyU013TFVvMHJ5a3ErQ1BhM0RnQ0p5VGsxOFh6V2dEOEdYdXFK?=
 =?utf-8?B?TUZEU1Nuc05URkg2dmo1VzVwMUl4RXluOE9VYU41ZHpLRDluRU41VEN5eEtY?=
 =?utf-8?B?bGYxc1llTUlHc0kwSGxSWitkZGYyODc3Y0l0WjZrc0hsTks0bHZhdmx6TEx6?=
 =?utf-8?B?YVQ3aW9uWkdGcWlUbVk3NU4zVVRVcTVHdm5jVGxLWjB6a0RHTXRWbVZLckN0?=
 =?utf-8?B?YnNjbkN3NUsvcldrYUxIZWFLak9xSk9HWWE2QVRLKzE2alpCQm9uRzBwUFl3?=
 =?utf-8?B?WW1xU3NZWHBYTDBuWFhBT2oyYlloeXdISUt6NGtad1orQkVocFVYMDNkcjRl?=
 =?utf-8?B?NitvUjN0TjIySFdHNTA1TFBpZmp2Wm1adU05ODZWaFovVWpaUXdMU0NGQ0Rw?=
 =?utf-8?B?ZUZqRno2cjUxZU4xQWYxYXFrWTNjT2JjVUNpYjRLVzEyOW9tUUt3NkRWU2da?=
 =?utf-8?B?cCtObXZTTzN6MjJySkFLeEJLcHphVVBDOFpUZ3grM3N3cWFlYUUyaHZrbW9k?=
 =?utf-8?B?TUV2QnduNis5cU1qLzFMN2tlMzRXZDJNbmQyV0dKakE2R2JnVThjaTgxYzdN?=
 =?utf-8?B?dmsrUThONjZQV3U2T0hlUlJzSG5FQkMraDhkMi9tRFBSVy9ZV1VudFkweDFq?=
 =?utf-8?B?d0hSVkZjSFpwdk1XWVZRMHQ0TTZ3bjhKdXl4cHNhU2ZIalkvdU5pTFR5TVp4?=
 =?utf-8?B?RUM3bmk5bVpVbFV3YkI3UEpXSXZDN1NtcjR3TjJTRytiOURKeXgrdFZYVkFk?=
 =?utf-8?B?MkxEVFhsb3JhdUZIMWxLTm1HQnFWRktGVk4wZUtRT3JhT3lTUnNIQzNvODMv?=
 =?utf-8?B?OTJPVGdOZEpiOEJwSUJ3NHlCaHl0bHlXVEplZE1NTXdzRUdGRklmZ3QweXVq?=
 =?utf-8?B?bEx1cDZaZzA2K0ZTVDlaeTdtTUlVamU5bWRGcFBiYVhNSU5TZWo2eXFzc2xE?=
 =?utf-8?B?OGxBTGNYbkxReTliWngwVjR6NjJuYktlNUV5VkVia0J5SmQ2cTg2MGZUVTA4?=
 =?utf-8?B?b3RDMEZ0TWpDZCtWRGt6NEFpd3F3OFBjOXM2OXpvckFNaEdNcmJNM2FTUUJV?=
 =?utf-8?B?ejR6dFVVKzUyMFNzOXdWejAvcTlWTi9CKy8zR0paMDFRMUZMdzM0cTNrMzBG?=
 =?utf-8?B?bjVGMnFwdGZTclZhNEpTNkF3ZXdXZlNJcVNmVTNOc1I0UUJ5SmRNRUpCYWdH?=
 =?utf-8?B?MkxoRElVd0plcWRKbmxEUU1TOTlPelB6WlBsQUdRc2N3TUVMWTl5MHEzcnYy?=
 =?utf-8?B?VHBwTUMzOW04cnVQVWFINllBS0RTb2wzTzhjTVpLY05jV09PbDdENXRDRE9y?=
 =?utf-8?B?dHZ4WmtZdmxNd2RTQTgwNERwM013RXhnMFQ3ZFh4TkFrdmpMV2xrSkc1dWh3?=
 =?utf-8?B?aCtHSU9tR1RRbE5NemJkZ0l0bjJsc1QvTnVpUncremlCM1ZHSnZLOVNjL1dz?=
 =?utf-8?B?N0syYUhwbGwzclJhamlXaHpQQTlEMnRQZE9iK0FNQ3BUV2JzYXBvS0dsdjRa?=
 =?utf-8?B?SkxVK2NKZU9ZNEhHbjRGWGJoSDVnMVpTWnduZW15Y3hlNnNVVTJkL3A0NTdp?=
 =?utf-8?B?MDdPKzlxZnJWeklZL1RzVXZvbHJHYWx1QXUwdE5zNUsydWxsS3ErZjc2bnNS?=
 =?utf-8?B?YUxFRmpQMHNEM3VGek96YTZRRTNTNFJLWUtMSld3eDkzYTFaTU5hUlNjaGpj?=
 =?utf-8?B?TmZ2NTEwWEY0clhJMUw2bWtZa3ZYMG5vRUZVT0p0enRMRHgzd1ZuS2lyWkU4?=
 =?utf-8?Q?K54oAH3+CvQ5eHjI=3D?=
X-Exchange-RoutingPolicyChecked: GNXr2D/jRtPLVkNatnKb40wOj2UdM3rJUddpXd+izpUexzgWyujm54MXpuXbia7EigSGNf2fUeOKlxnJeirz9T9aaDPshAxcWiAGszLhR8KD8onBDdPIzbErRpM3mf2H1qyTa9je8S6abr1I3+ab/NMMm3OUgW2GvxVWV6i/uYVyu5vCgY0RzbFc4pNWDAL4QaBhyzjhWrE+RTssWcwaTMPFU7W6QqWPCz/ZKFebC7iVcE7nsh96mzFLt/hJhEhvSBHs0Zm+ZvEw/9rT4HyEj9ndc6DTGosSjQS2pxYXmtBRQqQwAaQcCNOLQa4i6+X+EFKbFwuKHKaYqdSKye79Ng==
X-MS-Exchange-CrossTenant-Network-Message-Id: a3657b31-8259-44d5-db95-08df1a4e7427
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:13:56.9695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FBJ5XvAi6YQWsPiwiPSjDQAGnkQbaWqT8FsNtUE/ub3ARYM0yLGpq7ARKWiMOO1trFTOe5cA9MQvjLPNVjZHmf/Jl/muTqgEspuldQMiEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8195
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:12 PM, Tony Luck wrote:
> Both Intel and AMD manuals say that software must first check
> CPUID(0x7,0x0).EBX[12] (Linux: X86_FEATURE_CQM) to see if any monitoring

The "Linux:" caveat (here and below) seems unnecessary?

> features are supported before checking for specific features supported

To connect with the text that follows "specific features" could be
"resource specific monitoring features" ...

> in subleaves.
> 
> Each of the L3-based monitoring features is further gated by

... then "L3-based monitoring features" could be "L3 resource monitoring
features".

> CPUID(0xF,0x0).EDX[1] (Linux: X86_FEATURE_CQM_LLC).
> 
> Add checks for these feature bits.
> 
> Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

To help move this along it may be useful to add a note in "maintainer" section
that, even though this is a fix, it is not targeting stable (and why).

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

