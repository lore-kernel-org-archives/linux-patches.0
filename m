Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5D119C540
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 04:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741235289; cv=fail; b=oCIB4PWpnxkQMFETF02CXSoIZDIBBNWRrciExtGLfG9eTTdcmJK9v0d+KgJ6c1TwfpwERdx6jp8DEroUZGLWQiOKQpz+qU/kB5qmuJs0AZhbJLcZFJjRXhBP2UD7zN3Gl0atFNmyFhfhR5+VLyb+yBBnnZMNGFE+LEHjiavg56g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741235289; c=relaxed/simple;
	bh=HikCTg8mUEp1j9vv5vNBzwnyspnNUFfvkUV26adB4vc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LHJJYqfHcAkY3TfqmYagOHNKcUzkw2toqIHwhudJ4c2KUtB01FlF7VLFkl+8+h1XRwI5C4iXA7HU/xJ4SYmjVmioJS174mtMRKx9hVRNkohP0IXo9hVjzCdNXOFEG/8tEwLMZ9dPpF6U3+Ibx/rCumtAkj8FoccK8EdrMujrCps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WSBlv9Rm; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WSBlv9Rm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741235285; x=1772771285;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HikCTg8mUEp1j9vv5vNBzwnyspnNUFfvkUV26adB4vc=;
  b=WSBlv9RmGjgxqtSBC1ZNy2QXiJ7rPhDIPcMPDS8+toTOdrhmIkpnfNTu
   mG9IUbXy4KowqZbCNkFK7EZH9k92bwTo0Lgs1XQclsqFLKO64rhWjTL5Z
   lFkQExtaW6j/j1yaRNNQSmU4ehS3YZV1gawa+M3XTmcjCwwzyedfvpmlM
   dkaye0hZnh7RgVxgYCa25MjmM56yPq+jBUcTeDPGR0kTng2QXUNibzUDg
   /C92FMRvk2zyP/LkvEdtiO0+KC7Lh0e3s6eFobxS8b1RmgMlGDmjAW1gS
   VDO/bas5d65A37TFLi+VGnhYKR7aPsnl44kA9GbthTPDywOCDB9V+NpiW
   Q==;
X-CSE-ConnectionGUID: MBsWHj6tQK2Fpof2hUzzBA==
X-CSE-MsgGUID: nabiKnWjQIOvhhspthpq+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42143776"
X-IronPort-AV: E=Sophos;i="6.14,225,1736841600"; 
   d="scan'208";a="42143776"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 20:28:05 -0800
X-CSE-ConnectionGUID: uPnh4ovZRtymkB+bbGk10Q==
X-CSE-MsgGUID: SFhCFylVSjmEkLuBse2n9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,225,1736841600"; 
   d="scan'208";a="123914594"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2025 20:28:05 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 5 Mar 2025 20:28:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 5 Mar 2025 20:28:04 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 20:28:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LsHNejSy2hez3hE/AhgnFjM7jCHS8QPqIBHuodAC/wuiopbqrChxk//6czGsn1OWKWz/iAGPUHSGZB2GkpIQRM0WIcPuK0Tpel11VaXqcXjlxZfanelYX7wnTBDqrXb2xLteFZhrcSv92rFlfmYu9djfo3wz70AeGQSxKszjj9tG/zQo9Rx9oVzsfJSVrPtosGKZl+B/2ceVtQaVKbmD8yhyF8CcBTS1DlXpzdBwJlSzVF5Ova0MFFfeouTrmzt4G64RaYxYr4yUlKEml5IKkrrfAss/icGCe3HY3C1kF3Qq7DajEcNIdavH71PmUhz/IfOjiKR1JXsdSwnsgngRpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7zTFpD5DM8+VWNyj3i3A02D5xaDvs94qFRyTt2Yhy8=;
 b=HKyuO+/7T36i2vWZKCx0+jJO6PdGPSv//Jf4jSTvVP6O2AfkFL43M+xADjAEpj6hu9uf6V+kCJFyjVC6a2udWEtNiuH6evfFGFxS5oZHwxNnU8wkX51yvrF7fHixZbNx5WqYzG2YmRCS/hL1kRYpcihvhk2KxlLcJiNuChb35MLkG4onacLQVoWPBs90+xu/c7PPW8fPvj/qt9EZu4LW8iye1UHvvaZ9rA2Q8nyDFb+Q/oCli4HZwrbDQVXPN2wMzp/6UayLnIxKb0OuLUzJE+Y/015iHCgm6nLLeKTkvXj/1XdIvvJUOeDucWvVjrc30sfFkhPLuPFHMV4bf8ALEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Thu, 6 Mar
 2025 04:28:02 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%3]) with mapi id 15.20.8489.028; Thu, 6 Mar 2025
 04:28:01 +0000
Date: Wed, 5 Mar 2025 20:29:08 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Tejas Upadhyay
	<tejas.upadhyay@intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, "Sasha
 Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.12 058/150] drm/xe: cancel pending job timer before
 freeing scheduler
Message-ID: <Z8kklJj90JKGPCHC@lstrano-desk.jf.intel.com>
References: <20250305174503.801402104@linuxfoundation.org>
 <20250305174506.154179603@linuxfoundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250305174506.154179603@linuxfoundation.org>
X-ClientProxiedBy: MW4PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:303:8c::10) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cc132c4-11f8-44a0-85b7-08dd5c674810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5FvTAxYYFCkAU69rieaiOX3BjdrhJOmE9EzgcbntUe84GfzoJ8udslsW79as?=
 =?us-ascii?Q?2sQg7Rg3pWjnwz065SIOh3jCB/zGGQ9p8sY1zAUxM7Nm0mzQnnQWmtpH1Mq+?=
 =?us-ascii?Q?awlzRkvjqgVt2/nSWOkiub45v45+Ko35iIRWCZrAcE0krakszp7L1QZD6kgj?=
 =?us-ascii?Q?R4GTX6eoJp8sW/wgXEFuqprl6zNeu1aq9e0QeDUnLe2wUu4/6H8ooO7FiXgl?=
 =?us-ascii?Q?RAwu8kBRbph9XdIeHYzLpaOSHkWny4WEf6kLUGxP78w6KhCP5Y+8f/PtHmeM?=
 =?us-ascii?Q?OI4CR52fE8ou2NvO1V2E+Gt5mFXnNzJ5BdjmmMhxOJ9B84516FdYIlQe0UVq?=
 =?us-ascii?Q?G/jV82vHfhlrUP5NnIt89gLXgQgb/u94+AyvVBRbTK5ohgdhljoYJ0phsp9I?=
 =?us-ascii?Q?6BhxSpDB9HnTSxepttVSmmS7YPGMmxqcgKc0vyeZjFh/TybjKoertmB4Br6z?=
 =?us-ascii?Q?q3dIVheI6r23BguWIy50UAF1u5M3MBs19l2PeQL8oPhVw/103t3VqIJWF3Yt?=
 =?us-ascii?Q?Lv8cp/ySnf6kYcPii3fWn7KYFLkx33NrIwAsSwpMvVHZYBqDNQ9XGd00vIlX?=
 =?us-ascii?Q?cDbiVMU9qJFczh5tmKI50BPuM1yV9XcAV0hgQdhIjigU/A4vFM5daIk2KiPt?=
 =?us-ascii?Q?sMdLgLYgITyGvk8gOTEoxlGXtyqBb996IhNlIL9b1qDuvX0Z8whZ/Qq8D3Gc?=
 =?us-ascii?Q?ITYiZXiNdXO/fcZns7/xK9e+0gIdRlnZfZL+zwXX0N29TVM591e3PNuZRWx4?=
 =?us-ascii?Q?OY3fQLpNEQXL0ED5pmVLyutkhu2HNA7Muqh3meHzynYwpkFukGmgiDg3/WOa?=
 =?us-ascii?Q?yde/srbLx18YChotmX59b7qMGegObqu4GAwox5DVLvANr0kZzQNjJMCjm8es?=
 =?us-ascii?Q?DlvSBLtJyo1AQahsl6sZs0XOuQzs3E4UzBPHTOdbW3bq4yGJG0wqjGaFjB1z?=
 =?us-ascii?Q?9i2cBwl9Fr0Kt+nafFEt/Z15y3wPZDS0/ChicYv0p0WosCkFOAuFNcohktAY?=
 =?us-ascii?Q?hchACvGQgpEq6Y2Fufnd4lxg6iyBjlfuxqCZrE9xll2wB1hcdBQxv/9HbBpx?=
 =?us-ascii?Q?QpvQBtOSR1gcw/nSkNxyizHxbH+TvB0c68ZQaHa1d1kxKIZVCX1UIQdnNS4b?=
 =?us-ascii?Q?a7+Nv6JH25/sEPMX5nRpIBTg2oycU4ZZLa5+ZZSwHYAoOswDddyRHJ16toe6?=
 =?us-ascii?Q?r1Jo2il+cGGHxzE0wh0fWzSOeEracnkuMf8Mi0zb1WAlGhD5UyZZbLmeeT/D?=
 =?us-ascii?Q?6KdCfhdQOCBojVbIfKe9KR8s7/nMLuHByXLFNgJpLD4afMX1iPCnpQWrPHfh?=
 =?us-ascii?Q?44Ku+XQeWG3oan/49ZfBO1xA3R5y9Ad3YBqRb5PKGKAkfw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SbsonkyFD5dKTsMYx/6lHs+f3eIHBly1DkyZ/RX+7NYpc3rTjLkXXAjiEhmj?=
 =?us-ascii?Q?+5OP47XpDM3XCBAe7FawT5WMVVDEyyOdDxHgg6+ZwY5vy/x9fDjDrvo6f4Yv?=
 =?us-ascii?Q?3vybP5Q882Kvq0gm93YcSmVHBoZnD3QHY9MuVZzzbGHJLId195HR1g/4V5lf?=
 =?us-ascii?Q?54n5bGT8AOxXAh5cPnEnBxQvwvVayffbP4vTtZYUIYJWf/D372KtjUxGDLAw?=
 =?us-ascii?Q?5kCqjQ94wgcu8dv8B6u8EA5JKIzkcjh5H4/cH2j8xlKhwuNexnQZcJgQ7odN?=
 =?us-ascii?Q?hDf1KTnUUtiueZSwIPdZA6GsK4dOROKfRMuMWcc3vAc32aL0OAyrzoH7rPag?=
 =?us-ascii?Q?v6H8Pwtb5ltYPFQQKZUS4OIA7MehElo+NZYZlqdBvls6DLx+R6x2N/va2m47?=
 =?us-ascii?Q?HRlDG3FpFZtuTIOax4N9Nq95eysit+c79j2RQMLOn2HC3gCHZpdR9uB7B5rk?=
 =?us-ascii?Q?jPb4KniFDE+5iCVvxUcXcysZv7JNv/BJPURKRtOIcWdltUv0E8V3x/i30xMi?=
 =?us-ascii?Q?osz3KbzcZnkNw/SrtntweCFa9XpGEEUPLgNGW94sVUudBQGJuEDLPNDiUMfh?=
 =?us-ascii?Q?4oTtNYmHjPBy3uWp2NgQSqgERzUhpAm51uEH3b5zI3Jr0WCdQp62/olcsWkK?=
 =?us-ascii?Q?3MzdatTrhMk9/gqKivgP90zsyfCahDOuBm1IblaHvtse0lJFCUTRYXzO8XZE?=
 =?us-ascii?Q?vYdRkpZgwrPMQMZakKpzXuGfvSsnr7+j2nDc0jriQSfoCXf25MfQ047NofHb?=
 =?us-ascii?Q?YnWRX1BdMdj1nveoP4Ad8+2566UKgC/Njhbsig1511tDWgrMPFChRCwt99VJ?=
 =?us-ascii?Q?CuQ55kI0kVKENhQ53inX4YgKJa211R6AyAn6WFSENFIvgdRpUp02WyX3g8F1?=
 =?us-ascii?Q?B0GUyH9sLtwor7zSR4HoXqiKqe1rEYFnhXLFBZ12a36yyvlEouUKhv4gkav2?=
 =?us-ascii?Q?WPoJC9C6eMUBJktiArvv1gbDclBy5Oy9IA0ecS8prtGP9T7VADMTuCgm1AvI?=
 =?us-ascii?Q?Kc82bTJ7gbsOvGpHCIN1+lHvtuCcgZBvsD1AQCnvy4PGczzVjnA3f+g82pfA?=
 =?us-ascii?Q?oWShNxPcvryfIxbsEiB94n5FT7S42Xz81ZTyTHgMvKOjT4PHS9svycHI9dfy?=
 =?us-ascii?Q?iqEfWWOfloRwC8rVj49N5MqRntyGO6MppNNRq/X+SdreRaUASVVieg9p5jY3?=
 =?us-ascii?Q?f/0XFJIiRo4M+BARMz1+mDRgKNaNwpoyfCtp/P/1H2XYPmrEwJwwRFsHmo1p?=
 =?us-ascii?Q?+dAwk8vdJ+0C44R80ZSCaD+sounOXmXpFM7GpmC0ZJS9lAxwlN+bLEldP2FE?=
 =?us-ascii?Q?vwIjxXECmUdvhFAmKFhtA9U8jnrgRgaOSyRO7eQOVgsAvL+mXgBXORwXEd4n?=
 =?us-ascii?Q?FSsg3hdZo3LO19Tr5GIbbA1u7WfTYVDv5dqcf4tmhL//VwjTUaMyJ5XZoEn8?=
 =?us-ascii?Q?d7QhFfvh2oweehGBuuhh2G0wel9vNi6BF6ZYm6W3jfHx0ZfDnXa4pLssq1EZ?=
 =?us-ascii?Q?rzTqp7RCR1HPr4H2qsD4mDQ7lRvCZzmx8n8jaNoJS7AzjgZ3WFxmPTj3si0R?=
 =?us-ascii?Q?fSAujNSjGlR43CRlichS6TlGZ+P/IruocwwVPzl4C70Nnsq94UmKDg96iihN?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc132c4-11f8-44a0-85b7-08dd5c674810
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 04:28:01.8390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PwWPgaR9yJoWdhxyPGEhqg5vsy9FOEpRfjINmNKKo6yQ6HKD4zLGHDfm2bUNTt0kbFzV9AchMTkfi2jLbPt6gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

On Wed, Mar 05, 2025 at 06:48:07PM +0100, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 

We just got CI report on this patch, can you please hold off on backporting this.

Thanks!

Matt

> ------------------
> 
> From: Tejas Upadhyay <tejas.upadhyay@intel.com>
> 
> [ Upstream commit 12c2f962fe71f390951d9242725bc7e608f55927 ]
> 
> The async call to __guc_exec_queue_fini_async frees the scheduler
> while a submission may time out and restart. To prevent this race
> condition, the pending job timer should be canceled before freeing
> the scheduler.
> 
> V3(MattB):
>  - Adjust position of cancel pending job
>  - Remove gitlab issue# from commit message
> V2(MattB):
>  - Cancel pending jobs before scheduler finish
> 
> Fixes: a20c75dba192 ("drm/xe: Call __guc_exec_queue_fini_async direct for KERNEL exec_queues")
> Reviewed-by: Matthew Brost <matthew.brost@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20250225045754.600905-1-tejas.upadhyay@intel.com
> Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
> (cherry picked from commit 18fbd567e75f9b97b699b2ab4f1fa76b7cf268f6)
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/xe/xe_guc_submit.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
> index fed23304e4da5..3fd2b28b91ab9 100644
> --- a/drivers/gpu/drm/xe/xe_guc_submit.c
> +++ b/drivers/gpu/drm/xe/xe_guc_submit.c
> @@ -1215,6 +1215,8 @@ static void __guc_exec_queue_fini_async(struct work_struct *w)
>  
>  	if (xe_exec_queue_is_lr(q))
>  		cancel_work_sync(&ge->lr_tdr);
> +	/* Confirm no work left behind accessing device structures */
> +	cancel_delayed_work_sync(&ge->sched.base.work_tdr);
>  	release_guc_id(guc, q);
>  	xe_sched_entity_fini(&ge->entity);
>  	xe_sched_fini(&ge->sched);
> -- 
> 2.39.5
> 
> 
> 
