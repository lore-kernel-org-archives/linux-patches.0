Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0B333F5B4
	for <patches@lists.linux.dev>; Thu, 28 May 2026 20:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998938; cv=fail; b=JHBeoN8dZD70P+R4KUKqrGA5Q0mHkUkxFwZ3CW6fzuSmmjR14SKWGJcHYmF2OC/RH+fanPW747rY9lEiX/O4fLwC53TqFY1WYaGaNPWO2mpC594iKtbmt5RDcvN07v9Shkp/xWNitcdgyQwQVmcH3Fa0fATKSvGBye7AzQvhya4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998938; c=relaxed/simple;
	bh=EuwRGaqzex6/e2ZaajL4/Pyhg+UzEBRoEE/Iov7W16g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YiRky0/5INxp1MvI9QvHfywaceRhtUlhJkSCmSIyi81wbmIAvwSN/Fb9rfDbkN0jQQzB8LCWgpRZTR7z91hyQk8+lBm9uCRBAb86rMhCL1MvvPxI3FvsONAMrGXnI2VcLLAGjoN54z6VZbyJq+4ONuezw2OUpwv1W6dnlyjfy2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dcTe/PNP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dcTe/PNP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779998937; x=1811534937;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EuwRGaqzex6/e2ZaajL4/Pyhg+UzEBRoEE/Iov7W16g=;
  b=dcTe/PNPJmHposuODnqCsxskd1W5/2PE4Fs3QCnTCIGD4mYbX2RBZs7F
   6IOKZZgWx0SwPDGVY6yzMfkwY9ZfEnJaxFzT2iBlem7NN2LVu5NAw26oK
   4RFMUlOggqUAd8ZqfhN7pZkURGJ1YXyvJxqDOvIhIgiVCgSopR2I8vtTd
   3EZFMhsFg6zTFSRe6S1x+doSWZ3IASP1wQg48oZkDDQ2wJf+QDjDN8ZDw
   x442OEuVmFjLB4Oi23P5wajKfzjR0xoDS7z+FNh95Vjs29v2tiN1VLa0E
   xLzY43LpSGFl/7mB5Nxen4U4PXVvPjaxYExdwunDjQKxdzQUVsYtGic0d
   g==;
X-CSE-ConnectionGUID: xu+GM8EqRiWn08EpEejGVA==
X-CSE-MsgGUID: o6oeRMehSBez+s+uIm2znQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80822884"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="80822884"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 13:08:57 -0700
X-CSE-ConnectionGUID: bcfWZEBdTieGdtsd8gf0mg==
X-CSE-MsgGUID: WueSD0qdQCCC5H9bI6u39g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="247729655"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 13:08:56 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 13:08:55 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 13:08:55 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.42) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 13:08:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dERoKdQwyPVW1T45G0oP8xwW4FPa6/uKmHcvIJQ9cmDSc600Zxkw9GFbBq1GTF2fJads/gbkvRzyVPufd0qIMkCWVw94/sP9f+ZC0/iFY5KKoAOH3tAW3hd+SQxSaghFvk16TFEx+/t4ojyaFbLGEtWaFGo0MMyBeCmwh3d+kQl9tLDZrRwo8EWH6ZMdNE0FXFt0QIz07aLSP8HFBwso5JijNRdrnk2p44py6fUTEpkByq24Fypw1pK9glkmkPTbr8/wede3AZF1QPQtF5xEahG74ISQLgVzwxuY9o3okOAFPv+BDdSg+UHuj1isKCE+2n0AyBuVkoW7t+Dc47r4Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0Uy2fzPK+cgOvoOU/Mz/bibM/1kSDL1E7FFu/sFKC8=;
 b=bfpz4u1cykqsByIzpVRlAUDFiHAKsaiAUaLKtAKOlQjVYuybC6cKKrRGaZkjSMfRLzasrKAhwhr46IwJFsHBdtzlt+uvwf4qh7smiRMG0cDXPE7beYCE6xmhMI0m72npxQ9GLepX1WL0e/ygQm66rkR9R4HVwor1eQqbJASPO0kcmDZONOhB52ltwJ+PzREddztt2bMgBAprJ5zlEl4qs5iOt4qS03lZm3IPWe/YUfxZF0Ge7h9IHId5aE33BPwL20KWqDMCJhsv1g4Ccc8BxHR9HVtRrGz0/LZBu/ftPIrXNuTcOYf3nBB8EBjeiyvfnMfS3wynQv5wJC5uOK3afw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 PH0PR11MB4983.namprd11.prod.outlook.com (2603:10b6:510:40::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.13; Thu, 28 May 2026 20:08:52 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%6]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 20:08:51 +0000
Date: Thu, 28 May 2026 13:08:46 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v3 0/9] x86,fs/resctrl: Fix long-standing issues
Message-ID: <ahigzj0ewXQE-baI@agluck-desk3>
References: <cover.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1779476724.git.reinette.chatre@intel.com>
X-ClientProxiedBy: BY3PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::27) To DS7PR11MB6077.namprd11.prod.outlook.com
 (2603:10b6:8:87::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6077:EE_|PH0PR11MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: 010c0f14-9c3b-4707-f8b7-08debcf4ef00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: FTFMy1wykz/oikNw5xySf7SzUQ7VzbbVjumvLDpGDvmg0YVEyPmPSMco5CNi3F2l1/NILRN/b+aC6F9/OHyRmy74Nys/Vz+kZjMRqVBntcGcT/qmzXIRWlyVze+PaSzo6ffNG9mTU7J02TvyyOetTSvniCotV+cKbUOtIo9kHVvgTaGwsdqFzrIqmFDh1xo5K6gxcI/j3LZjnfS8LgQCms07SByB9mi0oqEpsb9Qasj6FfnIlQGMPXxE21YHtYoQJfIaWLtUP/LtjxaefKMmMp1alGn7QyfLHSGXVo1sHAt5sgXv4FHgWf7KFfJx38cAsodHoFv7CKLkK1RHEmd7kIhfWm69JTPmDeg8N9GQrv4APGEPzwe9vm+FMlAJNIVWbcx2HtFwdLJTxvKYsnlnqJFjRJCKjEHZlz+EDF8u9mdtxv3dxrRbaTqfrAZGBi3drufGuBbDrofwA+c4WhO3AXNQ7YH0d/WIje4rC3iJHRIe7SYHeGrtvsK247klZ5H/THC+1Sdqw1rbFvyVse6FfcFXqWQYfLqjJuNAex/3PYz7t7uPrUK6brd8Ygt/Vig8vFhMHlI6h2xZ2lES4drXLI08ky2ifoBl0dbADK+RK2+kHV4vztk9uBxPosc7mYbFs2jn7wadL0OycFhzs/PY/hGejpkhPk1BWR3ou7PE29Lr/jIQrWchJDKz0UW+BwlM/9oO6pF+InBgeAT4q1kU9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AHLmFGQS9reJWaTbeg9C+jKtdQeqfXka+fCtlaTqo98Yc/9b47z2pViF3R4r?=
 =?us-ascii?Q?ndIdnIvLaFYvgNZ4mgv+ip7SVFNyyzMJ3dUbnOtT3c+FKy5/zl6HDiYmUNa0?=
 =?us-ascii?Q?Y3cAPFoBwMidnKBXpHyyZLhjMycsiLg7Whmfh4x0ysj726LM1RRDbtzG6kyl?=
 =?us-ascii?Q?as0/nIqBxfvb6c/xtzKqw/qm+va9pseX1IrmeGDAk8t1Y25I0eHJ5Jompm1q?=
 =?us-ascii?Q?1IB5UAX6jjHN9OT0CKGzfFRYJKEsmG4C7pTFNCMMP5J3J6WGM3SfyuF9GJXJ?=
 =?us-ascii?Q?ul4V1Dw37aEfmwrG0cC0pAaprA48agxQOD3Iox4GIkj8pEjnPPKIRyiQPKWP?=
 =?us-ascii?Q?HGxh3Cwk5DjmlAwQlVqCvKcc63DctfROZ89KARkFg4wqt+Ks9WUTC+FQVxSz?=
 =?us-ascii?Q?jvwDkLGGR2dJk8fZCXAZlMCTa6bF9JKDHdxpM71Lpr6OdaeO8AdMkhBMXayI?=
 =?us-ascii?Q?j9HdNKxJnAfES70eM4PjCZI8lnnnMUJW15bipJEGSB6/vcs7YZlqvsiiai1y?=
 =?us-ascii?Q?ogTVAJlubJpK8eJ9UWjPuRH7d+u/VIPzn9kdc6K1PM2OuX3LYAsd9haOyS4M?=
 =?us-ascii?Q?crVMMr1Yt8YLuC0uEDo9CKd0JtjQoVSIg1atvnRGGt0Wycj8ij6x30h+zPmy?=
 =?us-ascii?Q?UcMt3XHzq0O8GgUZzY+8qLEWWQcPf+gJ+1zb16mDc34QmVT4/zpI+wSx8Y8q?=
 =?us-ascii?Q?5Fkd7B4qGoKmEAq0PWsWXDTUzh0b2+ujVvZpWDQdKp75dauqDkY9s3W2L1X7?=
 =?us-ascii?Q?rR1f134HzXXxZzg4bf+DAbRsm3PYRd8YWSVCkg261It+AWNYCrNLZ8ki2afg?=
 =?us-ascii?Q?aHrKVUpjb/SfUf+r24tI0d+FfhDzc0hixXJ0IBmHpJ4FI2kq8gJ5aXmpSbek?=
 =?us-ascii?Q?y3b4bgLCkKK6S9f8fHRlk7eFN175NqWEp1FqCwvc68/7p/wunJ3WHJxVnRE5?=
 =?us-ascii?Q?P1zNYDGmcd4F06bnVeo9faaW0uwpZordWklLVP2VPIn5odaZ6EBp6Qor+Ks0?=
 =?us-ascii?Q?mBL068aUAhQSifAu7c9slxaBjiY02IpRP+be/KmxJQFglbVQ3aWsuQUKyruq?=
 =?us-ascii?Q?1dTgHNLPFo4NLcu58JxEog16UmNaJaArmH7qMjwm5x4YrsEIs1UKSy/z4P6J?=
 =?us-ascii?Q?XtmGruewUl8q7K0nN7RvaGq6U649poKms7Qd0FboA3y3kCAr13fMFjklzKxA?=
 =?us-ascii?Q?8PUEei756AjqfrX70tXART5eKtCI7XWWv9M3pf+SSUsYdlPlX1xqHdg5gkAW?=
 =?us-ascii?Q?inrpCSOLWTBRr/06stQx1UIeqcZNBN+oLbL2jSXYq/HQCatlBRB1QySbJI7l?=
 =?us-ascii?Q?skwthQQGRWf8R+1x+P/KCzvjz/I6VeFvasORXSSqA/CJa05OFVhwf5KedkpK?=
 =?us-ascii?Q?ctez32JO3UCoS/ZY+3bN/gQ/W1nsjp5JkfNbEGTlA/+0BIbDx+rztkjIvWWh?=
 =?us-ascii?Q?cDdAyBrS50MvjhMxusa6MkyCH/VoWBlKI6Nn9w86T4DIq97uMwfWd4Cc9UBI?=
 =?us-ascii?Q?hvnYPRy1TNmRTvFc+jNhKJp8io5FYn80E8pPLTgAx4KfvyFNhstB0sekdKw9?=
 =?us-ascii?Q?fuVO3W8jEm29Nk7ZMTBbm8UnuDtIC2tdDL94isR8jRHKB9WEV4rtL0b6RDrA?=
 =?us-ascii?Q?ANqVCVcVlldpZHy5WaFCOXSBbnjVfhPbrkfvmWC7xxO9iwEQh1wHkmyFfoLD?=
 =?us-ascii?Q?vUgLy9meZ5PO6NtRJcQxMizDTySuaPabOX1u/h87wb69095HANkfNcGg6Q//?=
 =?us-ascii?Q?K7x7DGTmng=3D=3D?=
X-Exchange-RoutingPolicyChecked: jgvDb1Y8xnfFTWasd+67AWnYkGkXb5jYUQxzvtfCzb0WW3Hv0pnYIm88aitPQx4JmI7wCKZvDT0sVbyNQwKLZ4DD4xqM9sBsFDRdDGyAUJtvKyUzW71oSRGAQe/qu6PKgjcuHuMzOefSfEqcHgsRQ+dTrMlwFq8fuI/Ez37rhuk8v7A6xpcpK3qDDuw2423Zf5c0oiBH/uDqzBOA+c9AFYzrfAVjXDe9D6CgHDdHdEKyg7gGwO/EJGIk+IeUfwX6xtq9hlMU2+8ZlMK0MtcxtjHL7XhSUO3xRgV9xYZzS/jeKrEvv+/NcAWpgQ1yZwitCYVQbII6Ys51oGTm0dzGPw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 010c0f14-9c3b-4707-f8b7-08debcf4ef00
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 20:08:51.4332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eDH6Lm6JGsIr5DsoUeJLCmElx5h1kmP9gqNF77XWdqYq+oxZM/5zg7L3CxNhWZ/l2hHJz+c0ZkouMMLRnDOAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4983
X-OriginatorOrg: intel.com

On Fri, May 22, 2026 at 12:15:04PM -0700, Reinette Chatre wrote:
> v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
> v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/
> 
> While reviewing the AET series [1] Sashiko reported a deadlock during mount,
> and a use-after-free when an L3 domain is removed during CPU offline. Reinette
> found a memory leak in the mount error path while refactoring code for a
> solution to the mount hang.
> 
> During review of V1 of this series Sashiko found a new UAF on unmount issue
> that was fixed in V2.
> 
> During review of V2 Sashiko uncovered a couple more new issues: TOCTOU
> involving rdtgroup_kn_put() that may lead to UAF or double-free, double
> free of pseudo-locked regions, potential deadlock between resctrl unmount and
> info file readers. Sashiko also found that the CPU offline fix in V2 is flawed
> in its use of is_percpu_thread().
> 
> Address all issues identified. This version is significantly different from V2
> because of the additional fixes and reworking of the CPU offline fix. I do not
> consider this version quite "polished" but after all changes made to address
> all the issues identified by Sashiko I would like to check-in with folks (and
> Sashiko) on where the fixes are headed and would appreciate any feedback.

Several of these patches are either authored or co-authored by me, so
I'm uncertain about the ethics of piling on a Reviewed-by tag.

Apart from patch 6 to fix sashiko reported issues in pseudo-locking
everything looks good. I agree with Reinette's assessment[1] that
pursuing the bizarre corner case races for pseudo-locking should
not be a priority. That patch can be dropped.

-Tony

[1] https://lore.kernel.org/all/e40a924f-5398-43bd-821a-2ff9873c5a4c@intel.com/
