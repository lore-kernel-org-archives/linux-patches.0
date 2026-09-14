Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F01382F03
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 17:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406295; cv=fail; b=RhJxPF9UuHd+ooAkfqpGzKHaRdCEQDQA0Gh4QLzNqubD8Q0/8Kg2lOmppy66LVqeVso741PQQ9HvIR2VaAbWUMyPZftzl16rsiMGLT1Ljpq4e4cNPyC09UUuXY+Q6YFu7mPKDjg69h2rs2xJIAQ9WiO7KE2Eeu8Vgz6vCYkNOHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406295; c=relaxed/simple;
	bh=ptwwI/+ldfRnovqmqfkd3/Pw24FwYXP0w9V51HMuyyE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XXquhamCJcAS+61nbHPXq5Q3MFdxxbMNv1GVEEONYTTiRyI/GOrCKzN68+T7zjBrL7zKGwLyuG9ghUdCJpBFH5iyR7f1H+VG1qPjpO0i7tKF9Z8HHKYb/LLpCrtlA3wRGZ/R4jC7ahV+rWc52NIo9ng0i7FjsUUHfJvvpj4ewnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nIUKTLL+; arc=fail smtp.client-ip=192.198.163.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nIUKTLL+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789406294; x=1820942294;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ptwwI/+ldfRnovqmqfkd3/Pw24FwYXP0w9V51HMuyyE=;
  b=nIUKTLL+fec6roZrjwF7EHs1zDIYUxcR5xAFd7S9aRhX1uErUFkZ33MG
   txaqDArSkb906OaK3rhdk/QCIFqliAuZbksi7ThOUGD5Sfen3E9tbdnGZ
   kas0C49+HROkjT+TolyaKfDF3AHwt01tpdPp3QeEhZBTo8yXFW9XpAWb8
   xDU1RahnpPy/IvLZcNs/UoWDuZCaiI2OMPaeSlG3ZAzHDwAy36HIH83ns
   fiKyTNjuMzfuZpDyZHHUgCTuqDR8+iwDUo/hbeAIMqvwpNUMGOhNTy3p+
   3/2zR+lWAMjA1Cn/0MC0BwRvpdZ7JCIgS7Vy3CktpFAoEM46A93+q0YUX
   w==;
X-CSE-ConnectionGUID: C+kPwBhsT2OpFtIx8drS0Q==
X-CSE-MsgGUID: zW+cvqLGTFyxCJ6uibCKDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="267341"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="267341"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa115.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 10:18:14 -0700
X-CSE-ConnectionGUID: KnSWltrlR6uTU9Cziytbxw==
X-CSE-MsgGUID: /lolondTRLOpDM+/0Er1RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="913405"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 10:18:14 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 10:18:13 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 10:18:13 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.14) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 10:18:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g3Gno6o95gAchrXShmmpR7EOKgxWRMsgkWbQQ02cSdT4vfxFFIMbKWsSvKpejedzIWY4ytDtSGlNBGmY5eEdidevgdB4XVgzjZeH/gLfPZHx2nRwEmypZ/wwdwAbMyjKUweYoSfBe6ocIv/VFW/GlL5Bb93WkO3zE78Fch5cky7S8oLS9YWcwcZ+xub2vug2zvzD1ayNge3++6XCsTUxCMyRsoBWGWU5kbnYbSHNEIt04u1kp36Bzb95Dk7MO7FLozXsLgD9dWHdtWih+Yp/GqtXk9BjWSrJahUo6aoqKCPWCH4KuIqzt+HE38BgwKHgQ4JSeQ1oFDHwGY1D6iGlXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVWyre56G2aTSnNxoTVWzEW/3d8DZ4/O4xpiDC0IF88=;
 b=MLzium3aJq+E8y6+TOEfYhRxS/0YaFtj1LoH7kqZgBOoYvmn6XmPgIoE9gcJXVl8RcGL088Ax11gsdAJrYCd41uyFPo1TurP3dorCklhSqottBiy11ye/wyuTA1mbcpYdAXcVb6h3eNeCjPeTjiqphRYkYH99AK7SUhU3CczBjwsm8VW3mbgpPQnNBBB1u7tkILuLsVcmSGuxdoCit/nvTqEyyoIPFUsD8/ewv/5GW+s3I3VPdZxFMxHGD5u+qVntwV2pWQt0DyGk4ox7WJo21eKEY/sPcxCdX6ukAKG7Q5EXHp0v1ErjaRGHnVQ2pwtrOuidI/bgC7Yj8gykL6niA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB8489.namprd11.prod.outlook.com (2603:10b6:806:3a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 17:18:04 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 17:18:04 +0000
Date: Mon, 14 Sep 2026 10:18:02 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 08/23] x86/resctrl: Delete rdt_alloc_capable and
 rdt_mon_capable
Message-ID: <aqgsSj_qDM8ICWgt@agluck-desk3>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-9-tony.luck@intel.com>
 <cd00837e-3a60-4b22-96ce-738c98bd47fa@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cd00837e-3a60-4b22-96ce-738c98bd47fa@intel.com>
X-ClientProxiedBy: BY5PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::39) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA1PR11MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cd57a2a-1d62-4cd4-aeba-08df12842306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|4143699003|5023799004|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 0MXp0Q0mOGBUaBd0+t+rlRuPqWjiRkQ/AlwDG5Aa5kU0D3UKEpy7lyaKrd77qnInQjPIhytOg9m7Jgy/S2MIvtZN+zPCbNT6d7npwZMjkM/1CUCkkDPdaaJYKc/1LQ710Ms5VL7knf091BPuqgVr65ZJsd420oLjnKgOznj0zaj2+BS8ga1qHudEitJp8YPBvwtwxoK//+RYgj8p4eWWAhjAHFFNY6NMazcpM2XRLSuE5Ur/JAyj9ezlUEVU8Y/sMGhKOOjtDPUavid+4WUwrARW9JCpWinlwUPIbeQ5ua7fgQcgvP7HpPpuOqff70aZa+z7UJR61dB3aBMohfesV4g71NxsVK1KsS02WUvxEX570w81Cd7ZQ84Fk2nEQYWqzUASAYm1BmXPWNK0tDGPvIL0007bo1ir0ksUXCMOh+eiRg1PhKIccZjLfbwnNZqlp5wjmAyd89pR8JAw/C8l8/UppUa1A81de+YDKr74i85/UtxeOhuRkCwPexPjxYL/1L7b2r51iNMViCRX3TssFZGmsi3BekGhp5hlpvFTXUHFKd7270RrG+FrtAzu2tQO+s4s8w3jP/n6MDSE40sejPKzTvlLDeiAgPMIM2H+Q0w2sjr25QMdDusNOUBPi4SRMzDn1iwBaduHffgWjF02n8ykRpnK206GgJJtwQ812j4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(4143699003)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLrq92w/oht3An83D3S9bo3eh+pqWYL9HRFqPXh5aaBALwIhGPedKNq+adFg?=
 =?us-ascii?Q?kHqfByMB5Eym4ltrJQ5YLYc58KfUTz04VHqzRZTXJSVk4nUw6AmqUyCKpk4q?=
 =?us-ascii?Q?I+CwRIWdZ/HNp+uKGsJgddZ54dYCq544fSLuoZ3Iwf/BdAlYNTmq1Xude8Fl?=
 =?us-ascii?Q?rZB0bnFVkV7umPXdWItubGsFL7Q9vgc3yhXYxntH+ilDjuBc9XycUUo16XC5?=
 =?us-ascii?Q?m23Evd5EZ3OsmiJMp0rfl6rgJ7hMkqW1aoy+00D0Q5SbetUwdNGQ53JB9351?=
 =?us-ascii?Q?2CsL+VaQFNL7PwoRw2CI5UZx7o8vl3xc7pNPPPmWana9Vw+feKDnh+YKtqFE?=
 =?us-ascii?Q?9Hh/PchU5z9J1UUobJFK3FhYsHd6MgRDDN4xI4+DNfRb+xboeyrduI0mJKS1?=
 =?us-ascii?Q?6i28qRtWmCsgUK7UwbBCQ1I/R80yJVutlPK8oJBXA2jH9l3P1C3Kf29Skms3?=
 =?us-ascii?Q?/4Oi3nlfkB58i4ZOZ5WYcFA69BOGE+CyjQkbELXXIkrTSN7U+8RTCL281UYp?=
 =?us-ascii?Q?ks5SxAOOUOXT6LQnWk1nwgAfkCXaoZj0KjddU9quUWjxAP/EW6Q0gi0UWPBH?=
 =?us-ascii?Q?m01Ae2+YRWVWDreFg7cE5dFK2xz/T3yyVWxMTivRqZ+Ch4BDn3RkoqmAWgyc?=
 =?us-ascii?Q?DPmpKQzfxwyWqgQcJzgLGrJjmh44OstwoVUDPOz6MBIHlGNBvkpul9db3ZNx?=
 =?us-ascii?Q?4MItR/o3ztH8EtbR5NwqC/rXE0JPvSHiMK3C+IQSGAX3F6C57w6AL/frbj0h?=
 =?us-ascii?Q?juVgcxOk02PwYxmxNkK/mErSz/Nrw18dUDAgQFSUBEj87B1KAQzpe1XlruDp?=
 =?us-ascii?Q?ldRE/TTLWJn7j0fmYYS0487xMtbW6ep95EeeGrlIo2aecvBc8B8uOiHqhZJP?=
 =?us-ascii?Q?TTQPxq8RafJGv3TGAFqasmoh82z5FGKakwKCiCXVdMUkbOyP9+nCrIIkz3gV?=
 =?us-ascii?Q?alks81hzvLtbe4loXKQRqqk8MHnTyYhC3qGvkg1EKHkAAi3nqhUftovp+RwG?=
 =?us-ascii?Q?BoikkqZAd7sYew004K31oLaAhwtOIWJA8jLW9uKHCMPQ6+2qi2iJhS9nHRZX?=
 =?us-ascii?Q?ZRSmEs0rbIlKP2N+F6EM7vQJVihFwJVC+P0k5VkWvkmTEptJNk3INLot1axP?=
 =?us-ascii?Q?9d7K1ZMQBaWL6RUTCrNPfY52937uW1IzbfZnvmG46FlvINxKimfUlIN81bDs?=
 =?us-ascii?Q?TQ7Hzh17T5k2fkufvOq/v7x+chnisFT3UpgqzFlsFNMCtwn2E06TJvAYwrK/?=
 =?us-ascii?Q?HkUfZ58USLpuWr5WHNdu0bb7Qfi0zg35GjLTwccpZo4rloVaP43voUQv6Zsn?=
 =?us-ascii?Q?PKV3Oy5V6nxT/QXLLklDi4qusd7cUAs8KfGKcizMNkysM744zBIe6cP2XJC/?=
 =?us-ascii?Q?xXZ6l9GU3G9iva28KvHUBh8RWFfE4KDMgjM8LbW32pOfEys2Q+21Y64GC0Ct?=
 =?us-ascii?Q?kIW05r6VDx3Opx1w0URP3nUL9aer2ojIlPp4IatqpsSuCvo2NcIwsZl83wdt?=
 =?us-ascii?Q?zyVmFXn0Gyy/h4QNDTqN6QPtwMR8uj4MoSvtdRv0qL6IOvbdwkwmTrbEFkvn?=
 =?us-ascii?Q?2YSH6lt/Icyw7BZftv+UMRyVpncOfrYtFbxqWqZuS8hbt5vr6AvFUk3ihDU5?=
 =?us-ascii?Q?OG/EEyoW8sG+OnDroQ1lSzzOykEfdV2E+zHUzet7iSovvtUN4IK9c8GV3P6q?=
 =?us-ascii?Q?emMEPYiU5jZmjZP0E7HkU3KTzP5V9Lg4asIfgpJp/WVDHHiJ9m5DATE/6hYY?=
 =?us-ascii?Q?ZaXCB6QTHg=3D=3D?=
X-Exchange-RoutingPolicyChecked: L3ndrRUfAkyAIGc80CHuloJtC/8MJ6OE4Jm70Rf7W18buEWm/ScDy2/ui2DTppVAPqVbegHmq+yC9kIphtO2KCVwqCSYsOQ0wxPXjxTj/jXEL8pcuaaeA3sFw5sKb0fGILfiAUZZ61DmQ47iCCO8j+Otxu7/edYyO8va7Q0fGxgWe59jcAeO8mZKB4PPdHWQ9oH+QNJIoUXuGSVXW5B5GObtqitMz98sslqTxUC6HJjLo9H+Ts0gwKLXC0G9/GqAFtfjO4XjLjSEFvrnzbwSfiVrRD1rHOudDOMO6vJQLpIsIojoC+eBUHkRQ34LjCb/gMfFeg48vxcwmmBXG53wcQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd57a2a-1d62-4cd4-aeba-08df12842306
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 17:18:04.4953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZVKZ+vmXX14sJ+VqKP65Fgg5vhUKOwCnm5/4WgbolFzuKQrT3WdpbCmB6rSm2g875gLKD6Dy9ot80Jv23zeYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8489
X-OriginatorOrg: intel.com

On Wed, Sep 09, 2026 at 08:57:04PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 8/31/26 10:44 AM, Tony Luck wrote:
> > These globals are no longer needed.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> (missing scissor lines)
> 
> > v11:
> > 	New patch
> > ---
> >  arch/x86/include/asm/resctrl.h        |  2 --
> >  arch/x86/kernel/cpu/resctrl/core.c    | 15 +++++----------
> >  arch/x86/kernel/cpu/resctrl/monitor.c |  6 ------
> >  3 files changed, 5 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> > index fb6cfff82e2f..49b5357e2e5c 100644
> > --- a/arch/x86/include/asm/resctrl.h
> > +++ b/arch/x86/include/asm/resctrl.h
> > @@ -42,8 +42,6 @@ struct resctrl_pqr_state {
> >  
> >  DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
> >  
> > -extern bool rdt_alloc_capable;
> > -extern bool rdt_mon_capable;
> >  extern unsigned int __ro_after_init rdt_l3_mon_scale;
> >  
> >  DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 62b97e357ce5..e851da431dd9 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -45,12 +45,6 @@ static DEFINE_MUTEX(domain_list_lock);
> >   */
> >  DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
> >  
> > -/*
> > - * Global boolean for rdt_alloc which is true if any
> > - * resource allocation is enabled.
> > - */
> > -bool rdt_alloc_capable;
> > -
> >  static void mba_wrmsr_intel(struct msr_param *m);
> >  static void cat_wrmsr(struct msr_param *m);
> >  static void mba_wrmsr_amd(struct msr_param *m);
> > @@ -786,7 +780,6 @@ void resctrl_arch_pre_mount(void)
> >  	cpus_read_lock();
> >  	mutex_lock(&domain_list_lock);
> >  	r->mon_capable = true;
> > -	rdt_mon_capable = true;
> >  	for_each_online_cpu(cpu)
> >  		domain_add_cpu_mon(cpu, r);
> >  	mutex_unlock(&domain_list_lock);
> > @@ -1026,10 +1019,12 @@ static __init void check_quirks(void)
> >  
> >  static __init bool get_rdt_resources(void)
> >  {
> > -	rdt_alloc_capable = get_rdt_alloc_resources();
> > -	rdt_mon_capable = get_rdt_mon_resources();
> > +	bool alloc_capable, mon_capable;
> > +
> > +	alloc_capable = get_rdt_alloc_resources();
> > +	mon_capable = get_rdt_mon_resources();
> >  
> > -	return (rdt_mon_capable || rdt_alloc_capable);
> > +	return (mon_capable || alloc_capable);
> 
> Are these new local variables really needed? Looks like this can just be a single
> return statement ... which in turn makes get_rdt_resources() look unnecessary?

I need to call both get_rdt_alloc_resources() and get_rdt_mon_resources()
regardless of the return value of each. Changing this to:

	return get_rdt_mon_resources() || get_rdt_alloc_resources();

would skip the call to get_rdt_alloc_resources() when get_rdt_mon_resources()
returns "true".

Am I missing something?

> 
> >  }
> >  
> >  static __init void rdt_init_res_defs_intel(void)
> > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> > index 0bce199a5f7b..bc2df287ccfa 100644
> > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > @@ -26,12 +26,6 @@
> >  
> >  #include "internal.h"
> >  
> > -/*
> > - * Global boolean for rdt_monitor which is true if any
> > - * resource monitoring is enabled.
> > - */
> > -bool rdt_mon_capable;
> > -
> >  /*
> >   * Scale factor to convert L3 monitor events to bytes.
> >   */
> 
> Reinette

-Tony
