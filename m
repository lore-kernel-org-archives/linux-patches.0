Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A8321CC57
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749494987; cv=none; b=gZ5bHGtohvewnO8RniT2Z1tL6QmgcNlwYLmw1i7EwnOhfOHMBnLd1Sj7VOnzN90we/e/LjwQZf+S2eCfspdNK1qm0H3M+V8PpoVds3amo/mug43OK2yOmXuN3fP6iCB/w9p19GrBDqJHJR7CekEQXHPT7PvEFBQ8iMJhslT/3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749494987; c=relaxed/simple;
	bh=ui78fKG/j0BBOrRHqLHpqq5sKokZGqYCCMrjcYPaejI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/gmrevLUUKGwcJ9rFluGJy678skCYMXBowCabmkS3gLwDEqruBXku5+tvX7UWppuaIbnKOgC+vN7UiG1DwPno8WCYUTFChouY0sq6NA5+PqVHoXU+RHiMWQi5ZYEtfm6YqOVeD1FnMa5XFhu1TEY/LMT0cX8coqbiiyJGQG9Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V/9L7iLM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/9L7iLM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749494986; x=1781030986;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ui78fKG/j0BBOrRHqLHpqq5sKokZGqYCCMrjcYPaejI=;
  b=V/9L7iLM3OxycMUdHJ/r838FHoNf+NTCOJFOZfKLHyu0/80xSil/1LZh
   /mD1XBXUSd+YY+5IvgRFRv3DNINgTuZRrEWOkxyipYsusE9lYcOpaUErj
   gwaau35vHmBqHl+30H/4BUc2iFM47g0ZBIavLDcN8b1eAvxvaGpRhokpr
   NQwZl20E+GgOQw1VAXUqNl8lXvLxmQwAw+StgFxYfPTjv5bTbuJs8xy5m
   oWgUhueCnpXvZqEMe1RNgKEjNOlpIYwiQu7y747TTq+I9yET8LuUvnhOn
   cFl3GRVQo8nod9CKu6ca17v/VGGcuNIOVt1Ft5yl+3on9PIwZ8k60x3mu
   A==;
X-CSE-ConnectionGUID: buzCi7ttREOKx6Cq6QaFqg==
X-CSE-MsgGUID: 6gA+wSFhRB2RS+hCuPDOUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="69145275"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="69145275"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 11:49:45 -0700
X-CSE-ConnectionGUID: 7ckXQPO2Rmy/E1/meaBz/w==
X-CSE-MsgGUID: B7ZqAD11S4uaq/hmoJ76/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="183775988"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 11:49:44 -0700
Date: Mon, 9 Jun 2025 11:49:42 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
Message-ID: <aEcsxjWroliWf3G0@agluck-desk3>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-28-tony.luck@intel.com>
 <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
 <aEIxzbuFybLBE3xt@agluck-desk3>
 <9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com>
 <aEMlznLgnn6bK9lo@agluck-desk3>
 <d2be3a4e-1075-459d-9bf7-b6aefcb93820@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2be3a4e-1075-459d-9bf7-b6aefcb93820@intel.com>

On Fri, Jun 06, 2025 at 02:14:56PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/6/25 10:30 AM, Luck, Tony wrote:
> > On Fri, Jun 06, 2025 at 09:26:06AM -0700, Reinette Chatre wrote:
> >> With /sys/kernel/debug/resctrl potentially mirroring /sys/fs/resctrl to
> >> support various debugging scenarios there may later be resource level
> >> debugging for which a "/sys/kernel/debug/resctrl/info/<resource>/<debugfile>" can
> >> be used. Considering this it looks to me as though one possible boundary could
> >> be to isolate arch specific debug to, for example, a new directory named
> >> "/sys/kernel/debug/resctrl/info/arch_debug_name_tbd/". By placing the
> >> arch debug in a sub-directory named "info" it avoids collision with resource
> >> group names with naming that also avoids collision with resource names since
> >> all these names are controlled by resctrl fs. 
> > 
> > 
> > That seems like a good path. PoC patch below. Note that I put the dentry
> > for the debug info directory into struct rdt_resource. So no call from
> > architecture to file system code needed to access.
> 
> ok, reading between the lines there is now a switch to per-resource
> requirement, which fits with the use.
> 
> > 
> > Directory layout looks like this:
> > 
> > # tree /sys/kernel/debug/resctrl/
> > /sys/kernel/debug/resctrl/
> > └── info
> >     ├── L2
> >     ├── L3
> >     ├── MB
> >     └── SMBA
> > 
> 
> This looks like something that needs to be owned and managed by
> resctrl fs (more below).
> 
> > 6 directories, 0 files
> > 
> > -Tony
> > 
> > ---
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 5e28e81b35f6..78dd0f8f7ad8 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -281,6 +281,7 @@ enum resctrl_schema_fmt {
> >   * @mbm_cfg_mask:	Bandwidth sources that can be tracked when bandwidth
> >   *			monitoring events can be configured.
> >   * @cdp_capable:	Is the CDP feature available on this resource
> > + * @arch_debug_info:	Debugfs info directory for architecture use
> >   */
> >  struct rdt_resource {
> >  	int			rid;
> > @@ -297,6 +298,7 @@ struct rdt_resource {
> >  	enum resctrl_schema_fmt	schema_fmt;
> >  	unsigned int		mbm_cfg_mask;
> >  	bool			cdp_capable;
> > +	struct dentry		*arch_debug_info;
> >  };
> 
> ok ... but maybe not quite exactly (more below)

Would have been useful with the "always create directories" approach.
As you point out below the name is problematic. Would need separate
entries for control and monitor resources like RDT_RESOURCE_L3.

I don't think it is useful in the "only make directories when requested
by architecture" mode.

> >  
> >  /*
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index ed4fc45da346..48c587201fb6 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -4274,6 +4274,8 @@ void resctrl_offline_cpu(unsigned int cpu)
> >   */
> >  int resctrl_init(void)
> >  {
> > +	struct dentry *debuginfodir;
> > +	struct rdt_resource *r;
> >  	int ret = 0;
> >  
> >  	seq_buf_init(&last_cmd_status, last_cmd_status_buf,
> > @@ -4320,6 +4322,12 @@ int resctrl_init(void)
> >  	 */
> >  	debugfs_resctrl = debugfs_create_dir("resctrl", NULL);
> >  
> > +	/* Create debug info directories for each resource */
> > +	debuginfodir = debugfs_create_dir("info", debugfs_resctrl);
> > +
> > +	for_each_rdt_resource(r)
> > +		r->arch_debug_info = debugfs_create_dir(r->name, debuginfodir);
> 
> This ignores (*) several of the boundaries my response aimed to establish. 
> 
> Here are some red flags:
> - This creates the resource named directory and hands off that pointer to the
>   arch. As I mentioned the arch should not have control over resctrl's debugfs.
>   I believe this is the type of information that should be in control of resctrl fs
>   since, as I mentioned, resctrl fs may need to add debugging that mirrors /sys/fs/resctrl. 
> - Blindly creating these directories (a) without the resource even existing on the
>   system, and (b) without being used/requested by the architecture does not create a good
>   interface in my opinion. User space will see a bunch of empty directories
>   associated with resources that are not present on the system.
> - The directories created do not even match /sys/fs/resctrl/info when it comes
>   to the resources. Note that the directories within /sys/fs/resctrl/info are created
>   from the schema for control resources and appends _MON to monitor resources. Like
>   I mentioned in my earlier response there should ideally be space for a future
>   resctrl fs extension to mirror layout of /sys/fs/resctrl for resctrl fs debug
>   in debugfs. This solution ignores all of that.
>   
> I still think that the architecture should request the debugfs directory from resctrl fs.
> This avoids resctrl fs needing to create directories/files that are never used and
> does not present user space with an empty tree. Considering that the new PERF_PKG
> resource may not come online until resctrl mount this should be something that can be
> called at any time.
> 
> One possibility, that supports intended use while keeping the door open to support
> future resctrl fs use of the debugfs, could be  a new resctrl fs function,
> for example resctrl_create_mon_resource_debugfs(struct rdt_resource *r), that will initialize
> rdt_resource::arch_debug_info(*) to point to the dentry of newly created
> /sys/kernel/debug/resctrl/info/<rdt_resource::name>_MON/arch_debug_name_TBD *if*
> the associated resource is capable of monitoring ... or do you think an architecture
> may want to add debugging information before a resource is discovered/enabled?
> If doing this then rdt_resource::arch_debug_info is no longer appropriate since it needs
> to be specific to the monitoring resource. Perhaps then rdt_resource::arch_mon_debugfs
> that would eventually live in [1]?
> 
> This is feeling rushed and I am sharing some top of mind ideas. I will give this
> more thought.
> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/cb8425c73f57280b0b4f22e089b2912eede42f7a.1747349530.git.babu.moger@amd.com/
> 
> (*) I have now asked several times to stop ignoring feedback. This should not even
>     be necessary in the first place. I do not require you to agree with me and I do not claim
>     to always be right, please just stop ignoring feedback. The way forward I plan to ignore
>     messages that ignores feedback.

So here's a second PoC. Takes into account all of the points you make
above with the following adjustments:

1) Not adding the rdt_resource::arch_mon_debugfs field.  Just returning
the "struct dentry *" looks to be adequate for existing use case.

Having the pointer in "struct resource" would be useful if some future
use case needed to access the debugfs locations from calls to
architecture code that pass in the rdt_resource pointer. Could be
added if ever needed.

2) I can't envision a need for debugfs entries for resources
pre-discovery, or when not enabled. So keep things simple for
now.

3) I think the function name resctrl_debugfs_mon_info_mkdir() is a bit
more descriptive (it is making a directory and we usually have such
functions include "mkdir" in the name).

-Tony

---

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 8bec8f766b01..771e69c0c5c1 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -564,6 +564,12 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
 extern unsigned int resctrl_rmid_realloc_threshold;
 extern unsigned int resctrl_rmid_realloc_limit;
 
+/**
+ * resctrl_debugfs_mon_info_mkdir() - Create a debugfs info directory.
+ * @r:	Resource (must be mon_capable).
+ */
+struct dentry *resctrl_debugfs_mon_info_mkdir(struct rdt_resource *r);
+
 int resctrl_init(void);
 void resctrl_exit(void);
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 8d094a3acf2f..0f11b8d0ce0b 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4344,6 +4344,22 @@ int resctrl_init(void)
 	return ret;
 }
 
+struct dentry *resctrl_debugfs_mon_info_mkdir(struct rdt_resource *r)
+{
+	static struct dentry *debugfs_resctrl_info;
+	char name[32];
+
+	if (!r->mon_capable)
+		return NULL;
+
+	if (!debugfs_resctrl_info)
+		debugfs_resctrl_info = debugfs_create_dir("info", debugfs_resctrl);
+
+	sprintf(name, "%s_MON", r->name);
+
+	return debugfs_create_dir(name, debugfs_resctrl_info);
+}
+
 static bool resctrl_online_domains_exist(void)
 {
 	struct rdt_resource *r;
-- 
2.49.0

