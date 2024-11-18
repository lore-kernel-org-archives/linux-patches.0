Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6684C1953A2
	for <patches@lists.linux.dev>; Mon, 18 Nov 2024 23:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731973658; cv=none; b=eveGgMMRgInh6RoRb5Ou70rmlEZ95Xns+NViiZqDBvh5UDQJOS9PwZ2FAq462nVF+Lyy32CNzQjJwqQwgUS1DyC60+iaztlivweQVWtBubHylHqTeBFsfaEnvsDhK59a0vqNFbJFfWlWCyvthe1RdhxnTEu4QA3d2LSTRrKJenc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731973658; c=relaxed/simple;
	bh=BKtms7LWLD9J7tF7zaMFMdbLndSiQegnvW/JfKrXOpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2ZNR1erVLBF9Va53a0lJZukV2OapZiRsFhTstHd7Yozgx7eUkujAI+LeSgXJY0ok1fU6PqZiHlCgi/L3HNnx8Wt0luOzOh9RuNAFkyyBRe3q3nONPvB0dgmlqORT4/ssZ58GunD45ISiGzvyG/nrYQPN8Lo0aHvUJ4IcWMyOqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dzygH5iy; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dzygH5iy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731973656; x=1763509656;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BKtms7LWLD9J7tF7zaMFMdbLndSiQegnvW/JfKrXOpE=;
  b=dzygH5iy9z6B5Ziwpeku2FXEEIuIARl8N4DqvnjJFZYbmHor2PEfwtJd
   /sq+Fu2OczyCAqzwcxuCXXCSnMujTbFLJKCqyi//oTDuFmMuTholU1ZKw
   RDLpeIftHVQQAy1u6G2TpvKDupXMakDT/hTw66rNm53EkKohngbgh0ZS+
   bzQf5tWx5zgd2t87eg9kz2+uatOR1ZgFqtWMTQo8t83uwiPdvKkfHe0vq
   RqpEK4maXUHifV8hlXealPCZg1oGNvV61WdzXOiTV3UVaUbNLKpRRcjsV
   yzJl07puPxnbQaAtmykteelFXgLW7Y/8EsOqdidEQ8AcTSqK7GFg75VnU
   g==;
X-CSE-ConnectionGUID: SX+wXnfVRXCeJTkunm0OTA==
X-CSE-MsgGUID: NCbhX1pZS6e8gtkZb7u5PA==
X-IronPort-AV: E=McAfee;i="6700,10204,11260"; a="35859167"
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="35859167"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 15:47:36 -0800
X-CSE-ConnectionGUID: xsTE/DjiR06FrUJO0bw6NA==
X-CSE-MsgGUID: TXvML7jURQGRPVZ9XUPe5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="120317076"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 15:47:36 -0800
Date: Mon, 18 Nov 2024 15:47:34 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: babu.moger@amd.com
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v9 2/9] x86/resctrl: Prepare for per-ctrl_mon group
 mba_MBps control
Message-ID: <ZzvSFm-dcZwdK9cO@agluck-desk3>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-3-tony.luck@intel.com>
 <8b040e1a-2af8-9d9f-4697-dee96eb65b00@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b040e1a-2af8-9d9f-4697-dee96eb65b00@amd.com>

On Fri, Nov 15, 2024 at 10:20:34AM -0600, Moger, Babu wrote:

Thanks for looking. Comments below.

> Hi Tony,
> 
> On 11/13/2024 6:17 PM, Tony Luck wrote:
> > Resctrl uses local memory bandwidth event as input to the feedback
> > loop when the mba_MBps mount option is used. This means that this
> > mount option cannot be used on systems that only support monitoring
> > of total bandwidth.
> > 
> > Prepare to allow users to choose the input event independently for
> > each ctrl_mon group.
> 
> How about this?
> 
> Provide users with the ability to select the input event independently for
> each ctrl_mon group.

That's a description for the series as a whole. This patch doesn't
do all the things in that sentence.

> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >   include/linux/resctrl.h                | 2 ++
> >   arch/x86/kernel/cpu/resctrl/internal.h | 2 ++
> >   arch/x86/kernel/cpu/resctrl/core.c     | 3 +++
> >   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 6 ++++++
> >   4 files changed, 13 insertions(+)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index d94abba1c716..fd05b937e2f4 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -49,6 +49,8 @@ enum resctrl_event_id {
> >   	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
> >   };
> > +extern enum resctrl_event_id mba_mbps_default_event;
> > +
> >   /**
> >    * struct resctrl_staged_config - parsed configuration to be applied
> >    * @new_ctrl:		new ctrl value to be loaded
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index faaff9d64102..485800055a7d 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -283,6 +283,7 @@ struct pseudo_lock_region {
> >    *				monitor only or ctrl_mon group
> >    * @mon:			mongroup related data
> >    * @mode:			mode of resource group
> > + * @mba_mbps_event:		input monitoring event id when mba_sc is enabled
> >    * @plr:			pseudo-locked region
> >    */
> >   struct rdtgroup {
> > @@ -295,6 +296,7 @@ struct rdtgroup {
> >   	enum rdt_group_type		type;
> >   	struct mongroup			mon;
> >   	enum rdtgrp_mode		mode;
> > +	enum resctrl_event_id		mba_mbps_event;
> >   	struct pseudo_lock_region	*plr;
> >   };
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index f3ee5859b69d..94bf559966d6 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -963,6 +963,9 @@ static __init bool get_rdt_mon_resources(void)
> >   	if (!rdt_mon_features)
> >   		return false;
> > +	if (is_mbm_local_enabled())
> > +		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> 
> 
> Any reason to separate this patch and patch 8?  I feel it can be combined.

patch 8 will set mba_mbps_default_event to QOS_L3_MBM_TOTAL_EVENT_ID
on systems witout support for local memory bandwidth monitoring.

The rest of the code isn't ready for that until midway through this
series when other code has been updated to handle total bandwidth
correctly.

I may have gone to extremes moving that part out all the way to patch
8. It could potentially happen earlier in the series.

> 
> > +
> >   	return !rdt_get_mon_l3_config(r);
> >   }
> > diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > index 2b198ef95e1e..a8022bddf9f7 100644
> > --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> > @@ -65,6 +65,8 @@ static void rdtgroup_destroy_root(void);
> >   struct dentry *debugfs_resctrl;
> > +enum resctrl_event_id mba_mbps_default_event;
> > +
> >   static bool resctrl_debug;
> >   void rdt_last_cmd_clear(void)
> > @@ -3611,6 +3613,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
> >   			rdt_last_cmd_puts("kernfs subdir error\n");
> >   			goto out_del_list;
> >   		}
> > +		if (is_mba_sc(NULL))
> > +			rdtgrp->mba_mbps_event = mba_mbps_default_event;
> >   	}
> >   	goto out_unlock;
> > @@ -3970,6 +3974,8 @@ static void __init rdtgroup_setup_default(void)
> >   	rdtgroup_default.closid = RESCTRL_RESERVED_CLOSID;
> >   	rdtgroup_default.mon.rmid = RESCTRL_RESERVED_RMID;
> >   	rdtgroup_default.type = RDTCTRL_GROUP;
> > +	if (supports_mba_mbps())
> > +		rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
> >   	INIT_LIST_HEAD(&rdtgroup_default.mon.crdtgrp_list);
> >   	list_add(&rdtgroup_default.rdtgroup_list, &rdt_all_groups);
> 
> -- 
> - Babu Moger

-Tony
