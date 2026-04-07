Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9A3342CA9
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 20:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775593999; cv=fail; b=I0xqiO0QyECSU2aZA5Xu8XIsH7/TltkIBnPcdEtR9gie7ztt6KtDZLff9a/bv9WlmdXzcy1B8jwE7QfeAOZ1gfsNstOBianM2RTPk0GlQU+Y59EaxTttAO7zZzbmRAE+pDp7FzsOkUhgsRUr1+nwXv6upxCDElsi38fW9FJeqFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775593999; c=relaxed/simple;
	bh=JJTh2slvZYVwvM56MvjQlOwp7GAa4OaaWjFte92FNKQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RNT95hh8aDd65Gzhu+33xQBgu03duf2SWJENgpIc/lNaz+A5HuNupR62sSK9bX+kz+kgOFyN1qJBjanL9xQNZA4kQzpNnHoz2vzkOncNU26LNpgtWW95c66ADaJTfsnbO6NxjPdo6wfly+JUG1dmlyri5UvhcAwk1Rr443DwALg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lcW8IkdM; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lcW8IkdM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775593997; x=1807129997;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JJTh2slvZYVwvM56MvjQlOwp7GAa4OaaWjFte92FNKQ=;
  b=lcW8IkdMdeA8tSYcGB48kTXwFjieoaonh1+g9VT+ISduHdcOH0nTX5Ej
   c9OAey/VgcCucc8XeaN/OPDzuuZvhPX4AE/EIGqHkVKqcHEZvqIaZ8Ok2
   jSLm02vKn0sdBIdUpOEuCX9ecc8Rov0R4pV9foiP1wZBIcUqn/1CMwguF
   LClIePj9+lmJk2cPAEP8bYAMsyJ9mqKnGcSMvCzKwEx6PoVMcojPr3Q6R
   2pROkaqHrT6vGlk+5IGPFg49yxZDnNS86YtBtH8fCyPNUY2cICg7B1df8
   Mp+5aJMs4iaWzyr94DQIeudaWQ1pJz10xOpWom1j98s3L9jMTnWL6mmdL
   Q==;
X-CSE-ConnectionGUID: U7xgUAUQRAuzJs2Lj4AHhA==
X-CSE-MsgGUID: lLGWvluJRriV7W5dvbm3gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="76688628"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="76688628"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 13:33:17 -0700
X-CSE-ConnectionGUID: fHbUfRIiQQSw1lIQhB47sQ==
X-CSE-MsgGUID: UHj0ZKgKSOiC1J1c9at45w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="266246241"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 13:33:17 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 13:33:16 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 13:33:16 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.11) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 13:33:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHYe5YHhOP4PIBrTm2bydKZxQgwFl1NX3mSPKMJHiKpxSwX5+ypYPr2TgVe1aZ+pNqIdl3TnxJIHB+ilEMOhJ7wCkS4C8Ulcf94DV9TabZ+1/MhBkxbXw1U8sGEBSfh054LA9lUHepIiSp3iCHaLsFY0q06JN+mKkrReTsFW0rkpJh20Zv09XXuqGKxLN1bnvMGTrAUXQ42kHdAfsMUjlt+sYijGHK+bXVX3/MgcRgo8hOtx2Bv2O9TtSdqV+PpidBlyOCTAJhMXspWE1bK/vHQtNGgWdQJ0J7CKnkFkxa3cW1x9aH0iFH+kiWZFMoRl1gBzqoW0EeqzQqK6fv3gNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuxQkJk9tMQEoobIDfR+X2P8WK18XMi9Bb/SgslbNmQ=;
 b=EVHM0PxWbhvazcuIltH0SiFg5Tb2svnIMzzJQNXlvKXsdTlDIc+2qo3qvYk+HRr5nvdxvEBJm9M/Y15exI4RR9T8YUH1lbzwTHTMsETvNNwv01Zsgin+YzbN2APqi1pjc59Ksu7tC0mDiTv1diMp4/uNwUlUg7kyt2lyu2sVq93CN8zzGb2GIz1MZeu8pPEgH17J7sB79PV/PvAy7i5dFPKdG4tgOvz1h9P/C5C8Gky1EtInGBjDmHSJ07gCgJaRCRJkHF1Ljm2YV/miAKqbfvhlpT77e91ZfmST97jx4djonnVj/VvOB8SUGSXkxYpfvAJ05ODNT8pEuFsqWj3IYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MN0PR11MB6230.namprd11.prod.outlook.com (2603:10b6:208:3c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 7 Apr
 2026 20:33:11 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.016; Tue, 7 Apr 2026
 20:33:09 +0000
Date: Tue, 7 Apr 2026 13:33:08 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v4 5/7] x86/resctrl: Resolve PMT and TPMI symbols at
 runtime
Message-ID: <adVqBP2JIWaT777T@agluck-desk3>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-6-tony.luck@intel.com>
 <435073c9-02c7-4816-ad07-fdec09610114@intel.com>
 <adVJUSFFypXYp4qT@agluck-desk3>
 <2d1cb9b7-2f75-48c3-88d3-3c2419298e5d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2d1cb9b7-2f75-48c3-88d3-3c2419298e5d@intel.com>
X-ClientProxiedBy: SJ0PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MN0PR11MB6230:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e84f3dc-86b7-420e-0cce-08de94e4e1d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: AApla3XiL4VjPctSquzNDJy8Iru+goKUHRfMGtyYJxHEJkOW5GEiSQvy6Jgz5XiI6Pc66bVLzSuLjwWUEiYvv6II6Acq8bAhxSOpPmO1T/BJ/kSFjYM95rLAFEQI9aWPgvEMSym6RSSr02TL0llaBlrCLi9SUqkqHf6H2OABiphGvM/lyWZJS+woV/XNvtNuNQvmvKdEAIQFrmi8M+5YvcYTsb2Y1tMi0JJV++Z8Ng6YttzPGbuBC9eu5RdZcZmnCTGgF6UeowqpAnFU1as8TGRtek1mMKzhIcf6Wz+eqpr/z3rwe+eO5llCmDGAcMdGbA/cEa3Ok7DTzj11rIEeVlH6CRtf4EBzdAKYj7F0GIA9AFZIHlaEOquFopZk+31RVzKBfq/azR4ORj9hhSfr2yoNswcHD2wR+IX8NEQlKOZRrcRzyWRdVfnIX5J6G8DX9IOSYtqCdWSODpg6QUsDiIvLcONxvZFeE/6BWDWiFHwfMXTaYUl8/EgoujAlTPP+4TwI2hrd3rbyL4Z6OI081AtMC06dJOO/FSNJ5gKM8WGPktZIRvt8sTZ7lvtt+NVC70he2nlwKk1m+ztZY7wa43lDAaIi4uHcDbU21ZZOODL9uU7zh8ar6qL97mPpZZIXIq9vwxmk+nXDD9wHCn+4g887qM5Cxi4KwJW86xdGMkpHTPf58wEV6OAXdOeHDfPJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ku8opMXtAXcogm5vqBOObHW5ncjt1oSe1oorxAP6kZmT32Tbb/DRzmxg2Yse?=
 =?us-ascii?Q?nctQeTCTk+JVUQ4Nhp1n4YBlk4hWfRv1VetVBQEHV3dVrP9ucokDsBYwjOkp?=
 =?us-ascii?Q?k1Car+4LFVyaF2mbeLZb0p1GiUmZ0DNgbGV1bI7CzXqlP+8TALTE4ftyTUhN?=
 =?us-ascii?Q?0oi/WFW9XxqgSDLw4XkNzBj4NEzo35drsVqllcy1GOVKmKZ3ND4K3M95hpf5?=
 =?us-ascii?Q?zlidbpDQczQ+QGLbjMuj3Cme3hE4TWOlRyaDiDBr9qZtIQbAq2XSg8M9fOUS?=
 =?us-ascii?Q?sbTyxHtxBARV8bYE7JC4bv24K0mQMG9u9j43MA4WFdDlIoY8M/ZRLXNpKD3k?=
 =?us-ascii?Q?fJDqF0z7vuS9Y8QI6PvetXM/Mh3xgNjDoEf6QTO4rwND1G5jFWv1IjymC4KY?=
 =?us-ascii?Q?BWkCpmsUonKrKg1FYlCBZwSe5Ucu1h4wgX+cD6r1y6p7gqJzq3oPwT8f26W6?=
 =?us-ascii?Q?pcNk/rVXK9vAd6fM3VmpY5TasC4KRh+7+MeYbzCG8tsl4ZV9qWy2JVKcGCaq?=
 =?us-ascii?Q?iq6J2owF6fjV/nNoEovs0bFz5d58ZZVBTMQTyc3fiELahCWW3a2+3HUKSLdd?=
 =?us-ascii?Q?MBX9TVRfdlEvf4fOCnhd2cGuuBP0Jtln2BJ3ANsL8wig3dSAb1FxHus4nSbe?=
 =?us-ascii?Q?y5r4OJzpMTQdV+19dQqwO5P1/t3DO40RUCJ7lPG8tEVFjzu3rO6/ilS8yWUA?=
 =?us-ascii?Q?1ytpUglhT3gNmm9XFOrZzhpbJWEXY6agKves+8ii8kAuSd8IJad9jyyaInGH?=
 =?us-ascii?Q?kOemsYfUOCFXFCShKaU7jOp4xLeVlV2VTrN+B7ajEpNTHGckl+lRF1j6ZbsZ?=
 =?us-ascii?Q?AiwaazTzYEFrZBL2PFP3TZ8E0TgCCjpH5VTIoC7d290BP+QQ0tfFIUuPjIBf?=
 =?us-ascii?Q?ZsBbT3kauAIMdllMcATzKK06gpbLa2Nsjz+WBO3/V35uVaoowpUqQXW5OV0c?=
 =?us-ascii?Q?8VvABxVwTYRAcrHiFnUMA8gpVYFXpUG874fIttQ2MJ5cpGfe+tfiLlKuvnJ3?=
 =?us-ascii?Q?jK02wg8clXy28xWS07oFQqBzkDzeqCReGLKaVP0eySgEjKMPDFhBema8MKcE?=
 =?us-ascii?Q?DTYPqttn+yBSonjsFZ0qXuktsG1J7JmJiDxAaIyTBvavbWcKGaDhjPO7D7C4?=
 =?us-ascii?Q?dkYGDY/KZyZujf6lv7pXIi/pjU9O7lyiVmJoNxS2bpNSEkInlMOlMpEVvlpV?=
 =?us-ascii?Q?pMnbUQJkpC+2dsAkKZjU0/rTP7K76LLkPtuEAHurhmpi2yLWxiBhbTaMwi4g?=
 =?us-ascii?Q?/xqF6SJEhJgB9HygFS4+st8aG7A5In0X31M0NCm37FzwmhmivReqtYg/03yt?=
 =?us-ascii?Q?B6BZjlyg6ZAvnq8Aru/lAvF8F9+tr7BNFHdaAh/BaCmZ0TgBsXJL2QMZuieC?=
 =?us-ascii?Q?KehPtdOiwGBVyPBLLFwzywMFWU1qn7ZOTgcmZZfInGW8mM6Sr9pRIt1bpUeN?=
 =?us-ascii?Q?oHaNXaFUAXIJ0G+JWIb37op4068IDhEAOBW76FEXtOCyo045oTB4TQs14mOQ?=
 =?us-ascii?Q?liyVaoy9bMGwr1ADMV3X9k5Ijcf2V4PJZBIREvWkbtDTzOyv63y/4PyVGzhT?=
 =?us-ascii?Q?/uy0HQw6D6AClJRjDschnrHr31Fkt5bxKmaIXQJrNCmhoHuGXSViMJGY31hI?=
 =?us-ascii?Q?gqHfXx2NymFoxvMfcUwCSUNWuiVrGRMXtQB0PoBfyVo74zCA0PN+vhIxcR/j?=
 =?us-ascii?Q?BBceweBr2S2TPRvt4BdTFVZaRtY4fS3klkyKzXSR7TE9RVIJayYzcC6jhUih?=
 =?us-ascii?Q?TnVxzduVVA=3D=3D?=
X-Exchange-RoutingPolicyChecked: keem/C4wdaGL25fk5j84Vr+CosPM+4w3XvpX8tlWW9giARn9zt8Ddwq9ukF5l3IKz2zPPZYHXI+CRVrnhkeGhPy5qjUE0Sk4zLL2HtRJoFd50thmXn0nmcaQZdknJKwyM3xyRwETfhb9q2bxsalsxf6/07GzqtAsamQ9dEe9NT0RtTMOb9LIlAFH7k3sWT5H5vIktkTP1Y+V40tut+5uZkX72uGK71sddkUw1g/zvtrIIcjBOWN2D3miqM6BKkLXNEuBapzxoaZXR+XkAgAO8b+ntHIyMu+pFGwrS/f6S1AwlRKmzapVgbLPADgOy4r3oefA9d86pCf6/CipKOhCGw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e84f3dc-86b7-420e-0cce-08de94e4e1d3
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 20:33:09.8315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZwZid2oIx9xn/FrUb1OyNzLT+spsG7T4urDb9fcONIHaFWsKtNZwqVSfiZ420A8uYYJoXElnRpSA+yZ6pttOrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6230
X-OriginatorOrg: intel.com

On Tue, Apr 07, 2026 at 11:40:49AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/7/26 11:13 AM, Luck, Tony wrote:
> ...
> > Adding a "resctrl" line to /etc/fstab attempts the mount at 39.667. Three
> > seconds too early. No PMT events are found, and code in this V4 version
> > of the patch series marks the system as AET_NOT_PRESENT and will never
> > look again :-(
> > 
> > I can drop the AET_NOT_PRESENT state so that a retry will succeed. I don't
> > see another fix other than to document this limitation.
> > 
> > Workarounds are:
> > 1) Change the CONFIG to build pmt_telemetry into the kernel (where we
> >    are today, but haven't heard from Linux distros like Red Hat, SUSE etc.
> >    on whether this is acceptable.)
> > 2) Delay mounting the resctrl file system.
> 
> As I mentioned in https://lore.kernel.org/lkml/e85cd466-2202-4b40-82ed-91e421d8e073@intel.com/
> I find (2) to be a poor user interface since it (a) requires user space to
> somehow know that the system supports AET and then (b) either delay for some
> indeterminate time or repetitively (for some indeterminate count) remount resctrl
> to obtain needed features. 
> 
> Considering all the complications, could you please provide the motivation
> for this series? I should have checked for this first. The cover letter does not
> contain this information.

Reinette,

I'm concerned that AET will not be available in Linux distros. The beta for
Ubuntu 26.04 is available. I downloaded the iso and booted. It has the v7.0
kernel, so AET is in the source. But checking the config I see:

   ubuntu@ubuntu:/boot$ grep VSEC config-7.0.0-10-generic
   CONFIG_INTEL_VSEC=m
   ubuntu@ubuntu:/boot$ grep INTEL_PMT config-7.0.0-10-generic
   CONFIG_INTEL_PMT_CLASS=m
   CONFIG_INTEL_PMT_TELEMETRY=m
   CONFIG_INTEL_PMT_CRASHLOG=m
   CONFIG_INTEL_PMT_DISCOVERY=m
   ubuntu@ubuntu:/boot$ grep AET config-7.0.0-10-generic
   ubuntu@ubuntu:/boot$

The default for most distributions is to build as much as possible as
modules. So I expect to see the same when Fedora, Red Hat, SUSE.

Even our internal intel-next daily builds are configuring modules (I did
get them to switch the relevant modules to built-in for one release cycle.
But they feel they should match what is done in production systems, so
they have switched back.

-Tony
