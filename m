Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3169231F9B4
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 23:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781046184; cv=fail; b=WvaZE5ztanpT8CO27pj4Vye77RDUzMeps155aZoe8/vT4n7ohCKazO24QZ6nR73RUdm+2CwpL2IQBYYTpQZm7vJnY/mliwwza2+7xImeHHOb936lutI/gfPEDwO1az4sT+7COZ6Da50GoJUQU/lagbLyV+eeOp8Rmeutn4/MLBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781046184; c=relaxed/simple;
	bh=EmeJhxr3dRo4PcpXw8TI051LWzCm86859d1aHEtHqtc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LdrxFCqxUxaz+DHucn0fVVO4F7cQ9NH2s2kOUd+EzPivrkLHodfZ2sYKJ+6fm479scbq4XunIhNVXmzLy1Tut3kIzE5TwYgICNWdJLMJdMeVigtTnZos1/PeQ6mmYZTtBMRBygg8pXEXTnZv1BNf1Koew6L5SeuQ2E63aHE3+hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m+RbhKyq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m+RbhKyq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781046183; x=1812582183;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EmeJhxr3dRo4PcpXw8TI051LWzCm86859d1aHEtHqtc=;
  b=m+RbhKyqz9HplteIJTUuNUk8GW4UVK6ISRPC/ykuE0Wu3Ip4JRofWF3f
   THInhHx/TXFOa+IqoJ0ouMoonLSRRsAICeu7Ne7NAzbvJQyw36d1/i6XQ
   ZqIrkA/BSDbebL21BclHsWOQubkXYcKjmba+0iZ+0R80f4UVnFUM+vVzx
   1QrWzDapmNG4auKv5vGdJ36SPFAnfnFJStAecdJbR322edcJM6/OctS3K
   fv43dRWBI/nFpDaReacXoaPcJUtaJtdLj1PeTkYpFPlnFFYiwRT+QREqS
   bamZe4v4TIf4hRYahDKJz3xs4Tgz8JcFRXRVShlSSH+/PjGRrARTsU7JX
   A==;
X-CSE-ConnectionGUID: CzYDOkWEQ+6oX//C3Dq7Ag==
X-CSE-MsgGUID: lZgixSogSk6S8wdhYTkR+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81937544"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81937544"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 16:03:03 -0700
X-CSE-ConnectionGUID: GrJROzPbQ6esQlQsYzzQGA==
X-CSE-MsgGUID: WGmNwm8SRqGgkCuVUukxYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="244856638"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 16:03:03 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 16:03:01 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 16:03:01 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.45) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 16:02:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uOUydX9vBlDTimmey6Xbh6VD90kpzyIG7SeB+5CRQrQ3ZXdzI1HShNiontuqOGQUsmtXgjgDj4Q84U0rIpVkzBib7XluvGSlr0QNiYJNUNB3NB9qJX4L2CfVOUjC6zKVtADn+K5iCXa1ctC9KyKw0koUOl4lfICd6jifv56V1FxmIiQpgZ1wN/pMDYmEE3G6c9lc4ukCeb2adroCaa0iImfbWMyWe9uoqca4sbNFUFfRrw8a3HKSbyGE7jQw9YRjeeLOLSoUgUGO0GMbBLsSMwL4iR804m9SvQRDAx0wPGFAD09NGValvOz3gn2/5EBkXiW+P/G7TH0u8gT4QDk38Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fi0URC2Qszw6ng6oKeJapMUWjHmZ/K3UcRvDfheZfkg=;
 b=ivZsJW7WozdN9kWCqRr3qWuPlpwLtJP3l/F6k/F22jjfoaMk76/T/pjr0z2p4b6zf+JZ/JXqNDb9NTbNiomcZsE5O+p4RnYRxrXctUHmP7fZWJ646gYhF3Lo06kz06zuIIyYsE50D66lY5ljl5vjYgjft/MSIED+HaslXPYwBWsdSMMNPAgU2YThfPtujdzSqAM9KEJGF8R7RXPg7c8UcBV9TTrbQ2OkDLM8JacQh3isLE+tecglJOH1r3KQ07wa17bD/hVGje0MPf+5VgqRuSeaG/ZQyIzbESphXBHLGy3sqyPTplZgzl/22uzWtYjGpZSpnirXBiZ7jCozt+/agw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS0PR11MB7336.namprd11.prod.outlook.com (2603:10b6:8:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 23:02:57 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 23:02:57 +0000
Message-ID: <7bbc2796-0f33-433d-a949-d95fa1db6401@intel.com>
Date: Tue, 9 Jun 2026 16:02:55 -0700
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
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aihLqhlxS7l1y3jO@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0250.namprd03.prod.outlook.com
 (2603:10b6:303:b4::15) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS0PR11MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: 57d0b713-009b-40fd-70ca-08dec67b3ee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|22082099003|18002099003|11063799006|4143699003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info: ABrNWI17oIGrWygVzCAcGfEm99mEeoAUqFuyiJVK/CR5FEd5csuncdYtEotb5/G+xsqMJ84YYIfxeJtaUl+1nVmsAw8bq9A+q9/KGDvRbVY7ddvQ0Y+aC/X7uawu/xnDmw0BZ4gGwG2WF2IhHewJHCoH+hIIwT6afTKBCORMy9OHSIVWZX4R6xvrB14X/4moaheajgvkKF/Ovp1vlkLInlV1ItplBlwKh6JVPeZbXAZdK7vVFJ1dTE1IH2opFODLxuNriWBHC3eddK0GIQf2IfBArkvQ8ByWIwPbNo7QoWZkEfbURHBIvwdlLYk/kcspn5Jcy/ORz85ZRw65MfqnSjSXm4P1SSLeMv6FqkKxhV6269h7Y/crDp+geNHYm2kzT18GnPTXjD4RnfaFCmvSo0WBRUk8V4WAfn78+JlIHdBTC4yZb9/E+VDH68l++oi4P6vKDqBVYfU+NxrIRHVRZP/PxmEgpNbazsxQEfHI7mntuvqD0IOQQpWHQJ0/tb93O10K/PDKJPlhzzsh7krdYrKN1PhDT3LQgBcbTa1SedOgdZstETgqcHti7c1e73PB/YELcR5fgRfjQtg8+LWnZT8PjRQB0o9RDgXJ5jVi6NDwPMooH9irLMxXHLFP7ZkdyLDr6zQG6bXD3ehCDaX1R3BKDw32nthVRDLK3cwDQxgB4qpazOdZ5m3EiPAno9B3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aSthWDZiSlVxYTI2aEV4NGxQOE5xUWlkbVU4QlN0N3ZQQ2NCU29DMWtjOHBu?=
 =?utf-8?B?T1hkdWYrU0tqNjdDVHNZWWdMam4xQlRNL0dxTWsxbEgyMk1ZeHp5TE5BRDJD?=
 =?utf-8?B?RlZXQmsxT1VLS2hXSktWeDVBNGZmdkpDNUsrVGdtZ0JXdUE5aGcwS0VmT05n?=
 =?utf-8?B?eU1hQlZKa0ZzV1JHa0xFZTVWL0x6RTh2ZnB2Y3RJaHZTbk4zNEY1UFI3eDJs?=
 =?utf-8?B?QXljNE9hS2VQTmFPc0o1bFgwS0lwclVDVk83UEludkdBRldRVDFtY0k1SXdv?=
 =?utf-8?B?YnVoWFQycTltNk5DTDRjTDZHcXNUYk4zc0ZnNkt4YUNNOURzNWdyenVsUXd2?=
 =?utf-8?B?YjFPaTZJaEhpdHBkTzNJNmJ2bXI1Zm5sZFptZ0FQUmRiMGR2N0krbTgvTlVQ?=
 =?utf-8?B?R0cwb1VwOERxRzUrZ2tZM2RicTUvb3ZNS2VBTE1HTlpIRzJwWHBDUWliNDJW?=
 =?utf-8?B?QlNRVzNJSGhEeXozc1lKSGRHQ0hHd3dGRTFYUlJBSjZJZk1UUG84ZjZhQWo3?=
 =?utf-8?B?Y2RyaUw2UDV6cWxROGlBTE5XaVNpYWdYcDVDcmkvUVZsdnB0dUVYcEV3cDk5?=
 =?utf-8?B?RSswZGJRRUV3bk5xWEpYWUNmMnhFZlcwQkhnaWg0Wk5oc0lRNVVPVHVJOWFn?=
 =?utf-8?B?TDdqdlUxR2Vob2xISzFwaHpGSVIvMk5PNk5PVWtyRHhTczJIZDFKUVE3NzBD?=
 =?utf-8?B?RjdCbUZaTzdISnBPT2tVeHpvc29mUU1LaENjVXFHbVczUkZTUG91NXBKcGVa?=
 =?utf-8?B?cDBTS2JBQjBOOGtUVFArem5rcFN5WFMyTzJXU0cwVHViRGx3ZzFib1RvcFp5?=
 =?utf-8?B?Z0VoeGFOd2IyTzJDQWNHZVEvME9Edk1LTnVIRzBYVWlNRXhBNlIzcEk0QnBM?=
 =?utf-8?B?a2pTOTlrUk5uT253ZFFJZFNubUVVampMcGZtSW5RTysxaE1JMnhGcVpQZWxr?=
 =?utf-8?B?QXFpZHhmSU85V3FTSzRqSk5qNTFmT1pzRi9JMmRxWlQ2K0Vtb0xEV3lDNE9r?=
 =?utf-8?B?a3dVdyt2MjNzNnNLanJIc3Q0NlNKQ3dVblBxVVhCSXRUUTRGdk9SbnA2WXNT?=
 =?utf-8?B?b0tTcHZXMXUzTy9TUkduT1V1YWNTdkF3MnM5dFMvQlQyTlRBS3phK0o3MHpl?=
 =?utf-8?B?UEx2VW92bERLeEpiTzFDY2xSbEhVK2h6eHJDNFdqdmVHQ0pyeWxkNngvUjR3?=
 =?utf-8?B?ZDd6VVplcVROYXN0Rzl2Yk13STlCSkROeW9OQTk5WFpNWW9yakIwNWl6MlIy?=
 =?utf-8?B?OEtPMmVFZnVWd3oyY1V3UjdPVi9SSUhqZjZlZFhlTGVSdE13Rlh4c2NYdGQ0?=
 =?utf-8?B?NGVKbTBjVGo3eEdhWTRZL2VBTUVSMmtIZXBhRXFlVnVNZDRER2FBdWl3VXhT?=
 =?utf-8?B?ZkxYZHFKVm9VRUxnQXpqdytCdnMyMit3V09nbjZhS3lBTDlrYWZTZW03R0lH?=
 =?utf-8?B?a0NQY1FrOHBVdFhpQ0NOSUhwZzJRSEY3OHlWM3JIUWk4L0ppSzg3b0g5Lzh0?=
 =?utf-8?B?NXpnYzVqMGhFMEZYa3hYTVR2eUZNWnltdmFRUDZDaHZ3K1luMDBwQWlXeE9o?=
 =?utf-8?B?S2I3cTZUSDZVWTBWSSs2Vlg4V0ZrRGtYcWUxWlFiUzV4TnNRdkplclkzbXNE?=
 =?utf-8?B?VzJTcFFNVGlJbXFjMU5VM2owV3h0S1ZiRVFDZHNKWG9OVmJ0SzIvWGpzTHUx?=
 =?utf-8?B?K0hwcEwxOHRkY2swUGJIbkxNV1pVVE43ZkJzd3RCQWRLMFdmbGdFKzMwbTQ5?=
 =?utf-8?B?RUJrTERsMXBxcTQrbVZBUGVGc2hMOFZxVXpPREdnQzZDcWpNbTZ6MnFsN1lv?=
 =?utf-8?B?S3BNTC9jUlRNUUs3c0VuNFVZNjdWZGJsQmFEUE1JVVgxaWY2N2tuZk45UXdF?=
 =?utf-8?B?dFk5QXZLOEZiOTdtVVNFL2NSMEdrMlZsb0xRVENMZFNMYnBLUjB6dTZKc3Zl?=
 =?utf-8?B?VkFLNC9SNGY0V0UvUzA0b2xyU2NXMUpaa2NhTDI1MXd5TFBreVlEbnJSWHQ0?=
 =?utf-8?B?N0MyNkdha3pTMUF0U2tUbVdubVNrNzVvYWtXcnQ1VDVGWTNTTFNrNFdnQmZh?=
 =?utf-8?B?MXdsa1ByTk9jMUlPcmZjL2JIR1VjTk0xSFBxVlhMekpmcEJKb0NLdGNsV3pU?=
 =?utf-8?B?UWk1M2V5RHRiYmVVWmU4SS9NZjhFZ2h4VW9YaHVLVlVhMFoxdGhZcC9WSm0z?=
 =?utf-8?B?NTNQZmJIM1FLYVg4Yit4bTlDc0ZJOG5zQnhWSFc1cG42UXBmU3F4Tjd5TFRZ?=
 =?utf-8?B?UWlxcVBLWm5GaFhUOVJ0OGlFRFEwWWNhWmpSVUtRSFp4OTV5YWdzSS9YSnJi?=
 =?utf-8?B?VVp3S3JWRUV2ME9lTU5hc0VsSWg2bGdUTDhMNnM1azU5UVI3c01zenJMNmQ0?=
 =?utf-8?Q?rtIX/odRqA8mL6yU=3D?=
X-Exchange-RoutingPolicyChecked: Yh/uUZFxuXxjfCEiK00hlCqhuks/RtTvzJpRCwGfeSfZheXeEdoR8OGuIT6Q/EryvLAeHCm15dvVZWeM5hl5ROTDazHO1o5IXRS4uzBATn3uASreSonG4yR+9jEFmAQv3Jp4nq7/S683kybxb7ABI6OB+HyLOpxtHzPFda4+vr2u3IDjiZtTt0j+T5/W5CDHwPlmAQNprx6/5npOkabpuYsPiToOA14OleMZlS0SsmhBEF+0fwxeDiuhEyZyySDn98nn9eKRn0wbSZ1+LaoCd+nCgcLltU78M/MB4rGzKnh3ccGlXCPjhiIDfsQ4i8XJcIUONS19xwUo2eYX276ifg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d0b713-009b-40fd-70ca-08dec67b3ee5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 23:02:57.3207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4rbN1jfGO8OOjAALue9ejpx6YPEsHVw4swQ84bIGAiibznyAMvkh7xD97QkS1Ds71FYnpm8iB/mN/0eqNAgKklu1VI9EcaMIaV2hd1fcns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7336
X-OriginatorOrg: intel.com

Hi Tony,

On 6/9/26 10:21 AM, Luck, Tony wrote:
> On Mon, Jun 08, 2026 at 04:18:23PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 6/1/26 12:56 PM, Tony Luck wrote:
>>> In preparation for re-running AET enumeration on every mount, AET code must be
>>> able to disable events on unmount so the next mount starts from a clean slate.
>>>
>>> Add a file system interface for architecture to clear the enabled flag for
>>> a given event.
>>
>> This just verbatim describes what the patch does. It would be helpful to describe
>> how the flag is used by resctrl to support the first paragraph's implicit claim
>> that the enabled flag's value is not relevant when resctrl is unmounted.
> 
> Revised commit:
> ---
> Subject: fs/resctrl: Add interface to disable a monitor event
> 
> In preparation for re-running AET enumeration on every mount, AET code must be
> able to disable events on unmount so the next mount starts from a clean slate.
> 
> Add a file system interface for architecture to reset architecture
> controlled fields of the given event. mon_event::enabled is only used
> during mount and at run time to check which events to include in file
> system objects. It is not used during unmount, so it is safe to clear
> it as part of the unmount flow.

This introduces a general resctrl fs interface and makes some powerful
generalized statements in support of the interface but these statements
are only true for the AET events. Surely mon_event::enabled is used
during unmount since domains can come and go while resctrl is not mounted
and as the new comments explain there is significant state coordination that
needs to be done between these event callbacks and hotplug handlers.

Similarly, the resctrl LLC occupancy worker keeps running while resctrl
is unmounted and depends on LLC occupancy event being enabled.

Creating a resctrl fs generalized interface but motivating it with a
highly customized lens of usage without making that clear in the changelog 
but instead just making grand claims of how safe this is seems underhanded.

> 
> Add kerneldoc comments to describe limitations on when events may be enabled
> or disabled.
> ---
> 
>>
>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index 9fd901c78dc6..327e7a863614 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -1012,6 +1012,18 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
>>>  	return true;
>>>  }
>>>  
>>> +void resctrl_disable_mon_event(enum resctrl_event_id eventid)
>>> +{
>>> +	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
>>> +		return;
>>> +	if (!mon_event_all[eventid].enabled) {
>>> +		pr_warn("Repeat disable for event %d\n", eventid);
>>> +		return;
>>> +	}
>>> +
>>> +	mon_event_all[eventid].enabled = false;
>>> +}
>>
>> It seems reasonable for architecture to expect that "disable" of event undoes all
>> settings from the earlier "enable" of event. The new function only sets the "enabled"
>> flag to false though. This is potentially confusing since it leaves the event with
>> some lingering state, some of which is a pointer to state that an architecture may
>> be reasonable to remove after disabling this event leaving a dangling pointer. 
> 
> Ok. I'll add:
> 
> +	mon_event_all[eventid].any_cpu = false;
> +	mon_event_all[eventid].binary_bits = 0;
> +	mon_event_all[eventid].arch_priv = NULL;

Thank you.

Reinette

