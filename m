Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ADD35C6B2
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790282979; cv=fail; b=Oz/c9dJR/ymDsTZ2iPEnp84NnS7ZABBPc8j7DqUcZ22aigtNJnuDm+SSF7HprJFs8oSmx/vS2I3pXokb92Wq40b95ygOSYSG215JT28MS9+nnTGW56wztDRX0CfkQxRCw51KHuY1vN7Qax6T/62Olwj/8rOYfdNSyHb/KzII05Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790282979; c=relaxed/simple;
	bh=A4YG+Uze7MJ1J8Z9AEZLcTPYc8z/nE/SZfbArpAeqfA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SbzjZujnp9DF/Cq65IUy0j44pVQCrs8PmPZA+7BO8QMj5Yr+MlHb5CvX/e+cwOZZ5h+CWlHevUu8RGR5YbuZz7wbCy34oypP/qRW8AlpAKHf4HbQsvpQSxoFZE9TKJq0bU/Jvh92k1FNwFPMFI3PBHfYSS0TWh8wpJ5qtcAfJuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CLDrILsa; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CLDrILsa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790282978; x=1821818978;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A4YG+Uze7MJ1J8Z9AEZLcTPYc8z/nE/SZfbArpAeqfA=;
  b=CLDrILsa73038riYtFwlGYXysb0QEAhmXISP15l3ZLNIZ6X3A/Bug0Ne
   YWmZ9FpCfrF24sQHlLmw5OVIuZ3UIsSzuQmBDnDDEXV/4ZbkVbcOD3/RM
   0afFDXONktID25m7PMg0v1765aVYmgafqAjH3765rf4vwD2tEwcJB1sb+
   ZFafCj/UpFRb4bkF1Ce/gFobo2Sfyrfh+myLTu+3a+BSqIJt41lw/vC8x
   al5mtgZLcA0PlQf710FSXTMTLrdx8xKn0scNvkvfqEe8cFOE9Y7iX5Hrm
   3oPjywhW1G3GRTJV4QS9SD4izsw03R6BUSHQC2gPEIaT4aas4v45cdxqH
   g==;
X-CSE-ConnectionGUID: KoKyIgvSRIqhpnebSwzH0Q==
X-CSE-MsgGUID: OMyazIg5Q7qqpVXMEiR3vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101649281"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="101649281"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:49:38 -0700
X-CSE-ConnectionGUID: dWGb0cQ9TlqMgbil9fadjw==
X-CSE-MsgGUID: 7Wfj/S2zRLuUEyg1NALZPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="282220038"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:49:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:49:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:49:37 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:49:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CMJr7aFxjj63M0GgUY2S6hAIPS4DBBc3V5MkkMNYTqn3jdvtSAV0ksXld7ycd63qEXbVJ1SJ0YRd9IPBf4hOyh3iU6I4nHgqpC6xWTYf4UtWA9tkNPtS4dJd5acH64p1YRe7htB2vlpFUTBP9VulOrB04ODZbd2Gv2DGAoTY6SnLZLv3A2sv4EumTnK93MRVYDud7Ou1XbiFCcxB9NIRjBr/1+FfXdu8z6WVlPPZsCH/sKu+9zZT0tbxnrwG1IlVJCiO3NvUvfE4ZXZEegb07zLgQ3HC3ONnPZX0vD85jn4Kyp33MYhN33i9NBWF/o2lIkcjSSLjJh5rCpOrqX+eDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tpx+MFS3a+XIuy/OP1sFwh1BvExHmPCdeCZ0srUsJOg=;
 b=lPIkfgxJonPPxXVGha5mBIPutfUfuHc98qJSEUR64ziybUQfGYOzzpnxTDJ3zzkeJ3Jd1sy7fWQVh/5u/8v6xLEg7IQcf7yekQl5eHNltskfb8hRCFYcpB93QcDk6ZSj1XQUGU9LbcX50sobwdDrKzz43Y5YHzQsORnyInw0SZBn7GD61sK7OCfJIRqzPxNUMZc5T1noE+TU5jeiS7+5+ZgBvGi1xbpe9IVEHMU8kOMWUMMLHYX6qr5fed/dgw7IuM4ODJKMCPJ3FiPhC/EkvFiZFPy1rEOmELdH1lbmbdvjnI7e9ZdOcv4ywqapEBB0xQcLBI4M34F+SrpymdvyLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CY8PR11MB6820.namprd11.prod.outlook.com (2603:10b6:930:60::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Thu, 24 Sep
 2026 20:49:31 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:49:31 +0000
Message-ID: <da133b75-441c-4f97-a090-34d11a1ee63f@intel.com>
Date: Thu, 24 Sep 2026 13:49:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 18/25] x86/resctrl: Use registered function pointers
 for AET enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0166.namprd04.prod.outlook.com
 (2603:10b6:303:85::21) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CY8PR11MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff8f1fc-51d3-4422-9916-08df1a7d5502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|921020|6133799003|10067099003|22082099003|56012099006|4143699003|11063799006|18002099003|5023799004;
X-Microsoft-Antispam-Message-Info: ieIMbF6LGYsbyZcagUUiXLRYxSybXTkSKuwa/yF+X8JzEeJf4VwQe2f9llaU8xDzDMVx+9s/71vArvhY+65Wvr7jgwENQMdF4C+eo8arrEuBLixD6Hqpp0XnpSqv7g7eVy+VY3Dh+g4KvwJDBQq0Wac1+6r72ij+5JGjGq0SvnQ8QLU49AtpqkMywM9o7s0g5bqCcUMOCrxwf2pIBLlmzHPVpWqlpVBshdJIXVw5oAhyO/nF27ZyTh9Q2P0bKdpIjA69Jq4a7O2A8M7HBeggESTUA9/aSlE4L/7l/IU+PmJT2hXvVoHvISUBxFU4s5pCMiF2RhMcB3OFm5lDGCLQa5LX2Gro2fLnAEjCpDeE0Ijr3r89Mc5LAjF6Y9qnkkXHs0sGViG5XDnlivSENfqaRo4/YRHXCXUmgPQMnttGU5qeXJSjxJosN+P7pRQuDF0/U58DhWIopKgjP4Tz/9Gx3KRnfkCDcK79/UthUyQ+frbbgO70ZqEMWmH4AdN27xGITDGmUvltFvSSbOmn51YCmiYmz3wfzoKckeTCy4/Af9P0IiM6U7pBYVsI6RmOJKv88/WDkFWlJEvN6Gp29PceqeOS8cUNrn2fEnas8Q8lLBw0hgTrMuDXdu+FzWRLMrdOWrHFYYN+QEfmxi7QnZKNVY2RfqL+CdEiYFRxvjwpeAvf2WvpqiStgvvUAtnm6U5W1fQjyyWesBIGkV1y/v1QaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(921020)(6133799003)(10067099003)(22082099003)(56012099006)(4143699003)(11063799006)(18002099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVFZVy9WeXRJa2lVS3JaQ1lPZFZmU0E0WHNGYkx1N1R2aS9CM0lqMGtBaXFx?=
 =?utf-8?B?Q1JJN0tFNWQ0SjMwT0RhcU9pb1RrUTNwK2hjYi9TTVFFV1ppblRCcmI2aHpC?=
 =?utf-8?B?S0RwVVFRZ1VpcXB0a0NrSTFyLzA1bktZUWhYdW1JMjJTYzhRTTkxRTIrLzVz?=
 =?utf-8?B?bFI1NGcrYlVBanpyTkZ2Z0NqSjUwTE1rbCtQQURIMGZ1LzhZa3lEL25OQkZa?=
 =?utf-8?B?eGVmSWFhUnZzL2g0cENNbEZzTmI3dUE1Z3orV2dpZU9DeUwwZFlEWjRGYklC?=
 =?utf-8?B?WTNoNE53Uy9BaDNWUzV1Ly9jVHFGRTJ5Tjg3NXYvR1NLNTBwY2JUKzhucnFv?=
 =?utf-8?B?eWNUdHNGVEZkNzhiZE85TzR3U2FPMTlyeTBoc1pRUFdRSWVaamU2ejQ0QThN?=
 =?utf-8?B?UHdLM1NWMllvR1pjcEFjQjFQeWJQZHRBODhXOFBGZXNySTdJK1BDNkRHREQ0?=
 =?utf-8?B?d1BCaEVDc1ZTRnpoUENpMytvNnczeGp2NDRBdmdnbzRVeWk3ZmdLd2Fkc254?=
 =?utf-8?B?cnhjWmlTZE81OEthenY1T3dKVXZENmg4U2pKWkV0REFYZXlGYnNHVXhiQStI?=
 =?utf-8?B?dS84eTR5dUVKTFpEa1B6T2NJbWcrOENTdm1lNFRWZVU2SVpXWWFNUU1XbDM3?=
 =?utf-8?B?a0dYSFVCbm1EZldWWVBvbzk4U2FYWi93ZU9MNGRXY0t6aHl5ZnBQdFVxZDhD?=
 =?utf-8?B?cElqUnN3dmxPd3V5a29nRGFSR0MyV2VSOU1MSnFuUW5MQTA4K3FrM0tVVlNX?=
 =?utf-8?B?OWh4Qm93WWRkSlFDZXV4OW92MytqQjZSVW8xcnl0QnRUaTBLSmdkbVRxSENi?=
 =?utf-8?B?WncycEE5bHIxSUNxTW1QQVNaQnpLT3ZZeCtUOG1oWG1EVkpVZS93NlU5Q3FP?=
 =?utf-8?B?aXpWMmVuUWNPblExa3BKa1ZGSmZhVXp5emZESnhVNm5pSU52NlpiNUcxWHFD?=
 =?utf-8?B?NWtnSXFUWXlCbjlRdXBRb3ZDTkFoSlgxUEt5cHM5OTlOTVJ1NEN6dnFPZzEv?=
 =?utf-8?B?endDODAzM1hPNDQ2QnRZRkxpN3VvbVR3VjMvM2JteWF0VDFBdDh4Y0NWSlZw?=
 =?utf-8?B?SHpUMkdCQ0dRK3doNzhzdXN2ZnRJWkkrQmdXcHJSR1A5MHd6Sk1OQzhxOGpu?=
 =?utf-8?B?SXI0RXcxN3Mxem1PR1dJZE1vSW44TDU3K0dnWEhXZDJBNnA0MlBDQmNVQmFK?=
 =?utf-8?B?WlNWRlRzMlpmQytOenJ6cEdWR2NoR2JhMVFXeGNRSitlVmtJZlRqMHdWTW1N?=
 =?utf-8?B?K2RZVGhaRzQydHpxSEd3SVlHZ0tDQ2QzR3hKV2h3d1NvbHFJOVNxT0pOL0Y4?=
 =?utf-8?B?am5HOS9iSXkycCtBSlVxQURTM1BRQmlNZTgzendIMnViWDlEM1cvYjZ4UjVS?=
 =?utf-8?B?QzhoZnFuV0FSU1ZUUGltdFp2ckoySDlaRnRLK1BhYTFCMjZ0cDVYY0UvdlBR?=
 =?utf-8?B?V1grZGY3QXl3bGQzMitvQkFLZVN0Uk9vdE1oMnB4L21jYUMycEdHRlk0NkJo?=
 =?utf-8?B?aTk5RlpFQmQyVzBjUWtmRFN4YUpBMjJYSGVyZU9TaUNPYXpuemNab0R1enh0?=
 =?utf-8?B?RWZVRlNjeU9lZlJHTi80NzJYWnVibnYwL3g3VjFUalBKSHBJcVFSbDFKR1Fs?=
 =?utf-8?B?REllc01SVWFueDV5ZHc1ZmhUWG1xZ2hDTjlsc3FDZ1R0amZKOGhWOFdmZlY2?=
 =?utf-8?B?M0RZcUF6MkdiVFJBczZpRWZ6eWhzejFQWEppNmVLOHU3OHU0UWptaEJnUXNp?=
 =?utf-8?B?ZUhyS3Z2RENVejJxaXRqc2V4T3F1eTRRbDgyMnNUMDFxdS9FWWhvOHdaa0h4?=
 =?utf-8?B?V0ZKVjRXSFlhRlcvQXdETWtmQjRWM2FLTHMzVmkxNlA4bkZ2Rm12aXpHM2sr?=
 =?utf-8?B?VXBuRjMyQkZTVW5iVjZTV0o4clg3b2hJdUYrTE9OTGVIcHd4M2srUFBZOG93?=
 =?utf-8?B?TlFrTzZrd3krTXF4cDFaUmhTT3VuM0Ixa24vYlgxb0VVM1dPVjdmZDdXYVQw?=
 =?utf-8?B?aHlRRERzR3QwSWdPS0tyZUJYczJ5OEVTZ2NqR1NDQWZSb3ZjeXUvQm11dXh3?=
 =?utf-8?B?dmVBbDRDSzJYVXhEcDloZE9POGg3ZGJJSVVGc04yZ0N3YzlaZkRhRkhnWlJP?=
 =?utf-8?B?aGwyOUl0K3NQUTJRNngrdDEvSi9GS0diWjE4MGFjb1FZN0x3MWp3QlQwM1V3?=
 =?utf-8?B?cmo1SWZTbmI2Z0RKQ1V6dGp5MWlsR0FUTXdhVXVTU0Nma0FsTFo0YjJpY1Jt?=
 =?utf-8?B?SXhoTkVDTjNFSVF3TXp2VGwvOEoyeDROdm1jZUdmWW9pM054WURWYjVrUUI1?=
 =?utf-8?B?QW4zM2IzSEFDdHRuSUFIeVR1VmtCVzJoMzlsc1ZoN2YvK05vazNraXNYdlVv?=
 =?utf-8?Q?6R5Jk3pG/g0tYu/M=3D?=
X-Exchange-RoutingPolicyChecked: bYpnR53m6G3B7QNdZJrTEzMjIp1yvyxU/4+0/jMyvxXVDA6CdM/Tyy0Afzp4vD5BJoel1YD8RZKA7mHT5blyP8EqNN8CtcX7MNjczhv5yMmyvW7z957d/71D4U7zGTOez1srL++EJ2m1CahrxWPPnnqZmd1m8y4tDzwJ91hpccucbQlmFfzJ/CSAnO5SAcBI2LYtlY/OC0cuD0PU4dT+fE9+7qZ8ta2QmPDmq98Fi5JqOD5F7sjWacsqtga86le7szdqQ48VAP2Q7E0qAZKibEQXvRLNyqUBf0It6F/6y6yX1r4X9jIOuN2V/uikyea7FFhnRgWYtd1lwOEs2t9YXQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff8f1fc-51d3-4422-9916-08df1a7d5502
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:49:31.0734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tb8iOosjihxGzHXOZgK5fWjYLL2j15/3wYXmQRv+P2+71J1SJNdD0ZEnX1UDgZkn7RmMnbdSwIoRXYoMgScKebH3P8DokwbaGhtk7PEV+Ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6820
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> The INTEL_PMT_TELEMETRY driver registers enumeration functions with
> resctrl Application Energy Telemetry (AET) code.
> 
> Use the function pointers instead of direct function calls in
> preparation for the telemetry driver to be a loadable module.

This creates expectation that there are no direct function calls
remaining after this patch, but there are. This is part of the
asymmetric concern raised in previous two versions of this patch.

> 
> In preparation for enumeration on each mount of the resctrl file system
> place a hold on the pmt_telemetry module while enumerating AET events during
> pre-mount processing. Release the hold if no events were enabled. This hold
> will be released when the per-mount code is added.

You added that this hold will be released in later code. Why? Could
you please add why it is safe to take a hold without releasing it? Why
does this have to be done asymmetrically? 

This patch is difficult to reason about since it claims to protect calls to
the module yet it does not remove all the direct calls that continue to be
made without any protection. Even the calls it does claim to protect takes
a hold without releasing it without any indication why it is safe to do so.

At this point this looks like a patch that breaks the driver.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
Reinette
