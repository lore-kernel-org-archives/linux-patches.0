Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7197D376BF7
	for <patches@lists.linux.dev>; Fri,  9 Oct 2026 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791580807; cv=fail; b=cVOepi+4o5qAKGO0kkJ8FtJN40Ekc5KeosmBmqdL5ea2UyUUoAFI25/pPFdCZYcE4aF0oJj68qUL/W0w+QS6TJbTzUtNT9IY73ThR1dutaYElVxkkJ9mCZ4z0P/o8FhU2SDo5+YFd+bF1dbkRZ1wUaeI0XuRY9puSWrNhaZ8KYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791580807; c=relaxed/simple;
	bh=STiOScna78NMHfzHmB3ayIqEPL02aZFIe0EOUXO57JY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EaBVBZObqSR8DHLS3/3bVUI/PfYBeMJkMjTwoAAjSas2WfCQdf8a6eHBqAzm+6MJdAunRLX1Mo926Uy1NHGUbSgWGF44ft/Lz6CwA7cK5rjIoqCQeWDWr73iniTsK36jYBkP7eummN+n6WOt8KYkVoYyJs9RbeWq0KSZPPXyv8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ICgHeySw; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ICgHeySw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791580806; x=1823116806;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=STiOScna78NMHfzHmB3ayIqEPL02aZFIe0EOUXO57JY=;
  b=ICgHeySwdiog3P1qtcUjN2G7RFU1DwNYUnz+Su9GV97IGum4bgPxAXRH
   N4avC7NHig+MN84Yz2KtJtG7YJh5crM57D+4Qy/T9/lWZH81uC/+zKM7v
   5WP+k0XR1ei3cO0wJo5mIND6e454OOGiEHP5sYPwsUc067degcRJUfDI3
   HnsJ1+FQ/NFrCYYMjOs+290wj9srOxUJVkiWnW+WqzcJ9ILkq7kho+TjA
   uNz9q20qfu9tbyh+UXQbiAzQj0PkhGKKQK3zJL3fuDIcNErBs0ORT5OE7
   R2OE8XzA6LeJW3Ze1g+3MstLd4kRlEwddsbryNavqC9I8ZpXhnNDdNwC6
   A==;
X-CSE-ConnectionGUID: mm/YcyxbQKi6agyk++vbMg==
X-CSE-MsgGUID: WtqmT+RFQzm6ngNREjDzcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="264132"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="264132"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 14:20:05 -0700
X-CSE-ConnectionGUID: JMSShby8S+uX8DIm/sEITg==
X-CSE-MsgGUID: n84ebsLXQ9i7vzOlOV2wYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="329197"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 14:20:04 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 14:20:04 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 9 Oct 2026 14:20:04 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.71)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 14:20:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmpC79D4M7K8nO+YPz6XJqR9LolMpTacGWv/MK/a7B94fBOag7NeeMikZrPi6aphHFPrZYMnuwqqtiqflY7rX97e5cCU4xETZkUCMBWOOZ5KE8QqtthAwrwxp27I9wu+kYwl0pR9hCoyBi4aSWqO4/bU8/47IXnxhwqoGqC0V+LBYgkVaZ0HrJCHcagirdJIS0ExetLhiO9fsmmIrqQh+ugzk+XQkMRjW+Wr1Lpc5QKdm7DQ15h17H4FkwVb7JnI+hhMw9GHGQKQUhx6TJ9PJl5sSJj6I9VAZjQIaIgmSS0wlioVeMJzbFSgf7gn/pDFpo788Yo56eEvDNSEKD1XZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iIi1KRYcTbHPMLMjhoPH1U+06oqUj69duxTnbglrOM0=;
 b=Nz8nBRGzx0ygYrpbP117BziP7asRLdKPXlHvJEYZWA6bGN3QyuP6gv/YtesaTQ5HL4fy23ySGGphpL/nJTN78DQh9tr3vn0uBmgBnt+ljYTvtVdseEJejpJzrEcxnSg6Q9PoF/fYZSfBGicI4cN4KpxN/pGtzV/yW/kSuaxL8lxeCJ1w56HpM85xdM42ADP+j6C+c2pWT0qziUM+3np6B+wafhhvFpjOHNqKgqw5ap5y7eV8l2nZF4DUMLm9e/272WD47VZ73OjNzDCYf5Cx1F1+NboBV5TusguFFNv7lMOrPv8r4JeiNDnoeMM/VtyGSoEstg0th9JlEAarYPcnyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by PH7PR11MB5913.namprd11.prod.outlook.com (2603:10b6:510:137::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Fri, 9 Oct
 2026 21:20:01 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0496.010; Fri, 9 Oct 2026
 21:20:01 +0000
Message-ID: <659a5a5f-7892-42f7-a317-b0428423e554@intel.com>
Date: Fri, 9 Oct 2026 14:19:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/resctrl: Ensure default group reports tasks on
 monitor-only systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Sashiko <sashiko-bot@kernel.org>
References: <20261009193923.15498-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20261009193923.15498-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0220.namprd03.prod.outlook.com
 (2603:10b6:303:b9::15) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|PH7PR11MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: 1599fe0a-da53-4119-acf6-08df264b1438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|7416014|366016|376014|22082099003|10067099003|18002099003|11063799006|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info: Koy26Vv0wjo0xDbP8x8TneOuGrvjtQPBrZGPtQqJksY39OjaZ1eNAj/NBnuTYB74ctYCWr80fY6Ns5ht9GoN6NFQqGUwmLAwmA1eq/SO/Ga42U60XzGhxbX6BMIQw6yoVLqUX6rqHykF99Ud42UpKKCuB6PywR4btPeTG/URYxWavwNTAivMfSLxJ5Td37FpbBmiotublwcu82H2bDZ7Rte9pHahv2QuV3p0yMo0zff8kt27W6aVrzA4UwQm4AVzfm8tgN2EHJommZI4itL7Kyqtz/Si2qcvOJOY15y7p+WcNxLr0vp246mWF2g3A4BmBOscvUGiaetRHThqyxLjQdHsKsd9x8DtCd+8S3iIbM9XejmVCVjcHCTEmDFSM6AABs7n9yIslp3MgRoP5yklp4CmPh+y9HSb32Mu0r9OIs4v1veocGoOp5XcQkQlTWaq+Rz0h9+ovUFNqQb4n1lpIaTFFCsIHTD9p7tXMDvL2pDst3keZL0/dYO1b5IYwvTekYRE0JL28e9b5Xs1iD4V5FBfq1fM1Ntt/VE99JlA7sRe4Z0KpOIUzvwgvWMV2OCTYDj5GhRxob6Pi6vRlYarBWO0EMnWlovQn1LJESHgFhU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(366016)(376014)(22082099003)(10067099003)(18002099003)(11063799006)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnBVNlQ0cm1DME1oS0w5Qjl6VWIwVEYyL2phYWh4djZ6KzloV25DQ1FrMzZr?=
 =?utf-8?B?MW9qOWhnT1pTQkR0eVRCcEtJdDJLWUt5TTZYVElwUjdKcjFFa1RabzNDVWo4?=
 =?utf-8?B?S0FDemxSVDNoamxvYVJkYTQ3SFFobFc5V1prbWZ6VVRjZkRHTi9YWXREZWtq?=
 =?utf-8?B?clRDWDJVZ2FGMGd0YVdCVys2RlBhYXRHYkpBU3M2bmtkZEZHQlhVTHFEUThP?=
 =?utf-8?B?UENKSzRQZ3U5TnBmTTVvdmpkRGk3MkRILzFkQzBIMk8ySFlWV1h6Rjc2eHZr?=
 =?utf-8?B?eDg5MnJEY0hCbE1FWDNlL3BUaGkxSHBKUThSSlIyRnJhTmlsalpQN1lNSFZV?=
 =?utf-8?B?V1ErbHV1eWdhQm5DVStXM3p3VmxJbVJWdTBlVEFsRkJMUWtWTFBZOUZrK01I?=
 =?utf-8?B?cGJTa2pJQStCb0x1OFZVQ2kyQ3BkZlN0ZTFDREFIenEwZnZKRHhwK1IxZmRs?=
 =?utf-8?B?VGVHWm9yVFNSR0ZscHc1UWNZdFhXOHM0cFVWQ2hjMkJ3bkZpbTdKMFMwVU5a?=
 =?utf-8?B?RmcxUElLdCtjOS9mRVZUQWhjK3FVMlZ0L2s2VlBmbUJTd1Rod3Qrcm12L0FN?=
 =?utf-8?B?Qk9ZSGV2SU13V3hsdkFPcG5pTzg3Sno4S2kzTDFuRGZuK3diYXdYYkNtL09T?=
 =?utf-8?B?ai9weWRzM3FpNHJwTXZpcW1rV25tbWRDRE1jM1ZkRzhoUXVraEx5Zm5hK2p5?=
 =?utf-8?B?S3NqK3gzU3BuWEo5a2pzVkZwUlFkWTJhRDhMc1lhTitlMlhiWVA3ampPZUhO?=
 =?utf-8?B?UHpNNUtaYk9PQ0lKMndUUzdkai9GcXJpM28vTnkybEoweDRmYUl2VjJFa2t6?=
 =?utf-8?B?dDJ2NUNQbTBoemtVc1BDNk54eERjUUZGdkFsbGpzT0YwaXRCQkpPTkRKTktK?=
 =?utf-8?B?NFg2NHNjeEZTbDdkUWdkSUthbXhYeDdqV2lwVzY1OENINkZiRkF2cnhRNmZJ?=
 =?utf-8?B?dmJDOWxPQ2xQRlZwSmxPNjF1elNiR0lqMFE4NEVKSnhEUGU3WUdibzFYcWlo?=
 =?utf-8?B?RnR1UDRtUXJKaVF2RHNtVEpRaTZGWFdrUTN1cmQxemFTOWFsWEN5bmVsd3RI?=
 =?utf-8?B?M1A4YnFXbzh6Q3dYY3NTWWpSLzRpWmVFVGoyQnA2K2pSWGg5c0NHWXhvZlZQ?=
 =?utf-8?B?YU1rUWJudWlIQmp0SGJaZEFFS0dOd0o1R0ZPeFplRGdtdFJoZFY4ajJDYWk2?=
 =?utf-8?B?NFAvdytsQkphVEt5SEd6SXJ3YXhVakVUNkpNZHhiY0tXbFFwTDRneDBaUzhC?=
 =?utf-8?B?c3k0QUZnbjR1U3ZSdVZkbkxPL0RtOHJSMG9pdFloZi9HUzExYnFzZm9IcWF3?=
 =?utf-8?B?Z3Y3MEZ6d1pjRXgvTy9VNW03WHQzZ1BUN0hoTTlrMWYzMldjQUpVLzRtRTFn?=
 =?utf-8?B?TmFxZXJiYmo3TE41dnpaWVhWQmVLRmFROTR6SG42dER5ZHV6NzM2bTl6UnR4?=
 =?utf-8?B?WHRPUG12OFBsK0tZNU9FYi9vVmoxelgrOGlEbVJlalpoOHc1eHRBSEpKWnVS?=
 =?utf-8?B?SFowaTA2YmRKMGYrV1dCRVBsZ3NMRlVsVThlVFFFNkxrV2U4dVdsamZFZXVl?=
 =?utf-8?B?N0NVRWVkL1J3OFZKeUlYZHpJZjhLRUlXejAvVzlNOEM1NDA3VVFkZ3JEN04r?=
 =?utf-8?B?ZFZ1OG1SRldKbmQ0anFETVhVUE5IMG85TEhMUFFPcjU2ZjU3T2Z3Z21rSjhJ?=
 =?utf-8?B?V1c2MkRaL2JDWk9OcmZwNXRiWi9YVFhaV3NENDFVZmc4TlVHL1VOTC94SjlI?=
 =?utf-8?B?SVBvTmpwQkl4TTVDaTVVRGZXM1YxdnlHZkRyQStkRVBlTlA4RE1icnRWLzV3?=
 =?utf-8?B?Z00zTWVGd255alVrTXhBOFFNY2FBb2hzd3pvWmdDaDk1b1dzeFVNUVdmN3dD?=
 =?utf-8?B?UkN6Qm8xUkkxT2lHZHRqNnRlcnpZSmJZbFVrM2Y3OTlDdXdvMjU3MVlHcitp?=
 =?utf-8?B?RmJHc3JvUUo4QW5Tdm81ZnpqV0JKcFIxOS9IbG1YbGEveDFoNG53SGQxYVZR?=
 =?utf-8?B?YVAzbUJkaDAxUVBmZXRUS2tSOHZDWUR2WjAyZkhpdGczczFWRW43NVNtQ2M2?=
 =?utf-8?B?NmJNV1g4RXZoM0Fhdno1QVJjbTBjV3BoaWdNVHd6V0h4MXNPM2owN1FuS3N2?=
 =?utf-8?B?MVE0Z3IyaDRodFFmeENwU3prTzZtS2l3c1ZVQXBFci9jYVAySTl5RDhMcys1?=
 =?utf-8?B?aTBDVjZKSDE5cUt3aXVSNDZBUjVoTnYwZjVwZVdibzc0d0JSSHM5NkJ1N0sx?=
 =?utf-8?B?akovQXhqaHBtaHlVTUhsSVc4TlAwOXljTzRuZytXMFJQSy9nb3J0MXRZRWZy?=
 =?utf-8?B?ankxTzJGVFlyY2VVRktQVGFMdFJPWVFlbzltdkFNRG1HVjlreEI3NmpBUVlG?=
 =?utf-8?Q?KUxKlXb4n3yKonVc=3D?=
X-Exchange-RoutingPolicyChecked: k/w0KuuRV3jzb47IAsUBBpdap1oL8Fb7MJBjzy2P25snMp2uIda82Dut0xGNeo21eFg1ZVTMtCMKg+DGKVW+q/jbVsUhEVL7+j6uWuSIHpoUxFx53pJXV2cvZlGoDoNw3iuXv24mFOj3gHP4QVzCl7ZHk0erWCpBSobk+4kElpaXUScnwC74kRHWoo4eKkb5BmAEuUYlkC2HWQX88MGC41xic0AGSFU2BuAcuYq5POf5b3JuDgD508F8gl+YM30zRkMDgYG1piDFX6fCkozpvTt36lKQCy7g9HRFDlWvuYtFDzroNdqqPVmHBBSQfyduNilwvf57QH9RVxFEyLVVKw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1599fe0a-da53-4119-acf6-08df264b1438
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 21:20:01.5573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6p20Ssj1hYjdRnzp2xIzu/69ZEhDMhwQ9NZGHAeJLioMD34PYNoHxE99We59OQSYooznXoBsg6QvXsa2QSIeLfnzYkB6B+TPnihVzt2uh2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5913
X-OriginatorOrg: intel.com



On 10/9/26 12:39 PM, Tony Luck wrote:
> resctrl can be mounted on a system that supports monitoring but not allocation.
> 
> On such a system reading the "tasks" file in the default group reports no
> tasks, even when there are tasks assigned to the default group. This problem
> occurs because the check for whether a task belongs to a CTRL_MON group is
> gated by a check for whether the system supports allocation.
> 
> The resctrl_arch_alloc_capable() check in is_closid_match() breaks task
> reporting for the default group on monitor-only systems so remove this
> check. On systems that support allocation the check is redundant.
> 
> Fixes: e6b2fac36fcc ("x86/resctrl: Use is_closid_match() in more places")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
