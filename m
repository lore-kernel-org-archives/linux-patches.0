Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C691230BEB
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 19:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752001709; cv=none; b=nNjeLX7BIQhyhMd6DrLx6miLsBhh4+I80mZRjRXsS/tMbGZs3Mu5EF48ez3s7mlEZA54yrIxidR+688EQX/BDvZBpU89stw0xltRPylPhUZtjSToK9wxOQUCCSBUb0K0hgrH8TilosqY+ZmLSj1bVHOJdDyI7K1Ogz6VacM0qOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752001709; c=relaxed/simple;
	bh=KQzM+BI5ZydMMyjFGRtS7bGi/J65IrANyglHGUPxDTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTnLLauN73rrwVjS/yapp/h0IhdlI2rzP2qrb49qysVjD5Z9Yvk5uK8+4HFBP2HFTfNvz57sV38Om7XRsG7svRCOE0k5wExMiGVIevmHveUemRAiuN77hKkqYMr8dSy7Hjsls6MD3vrcEJD9tZcJz6o+7wWTYcJ0nDfbcMsdL/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bf+KtHKq; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bf+KtHKq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752001707; x=1783537707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KQzM+BI5ZydMMyjFGRtS7bGi/J65IrANyglHGUPxDTk=;
  b=bf+KtHKqBJRtJl+bLy/etm/E3KrrsHEDx6hnV3txNjU87rMIGvmlVYTl
   uvFBSfi8e98uu5AUIdnTchIZYkeSyEDkgSTFt4QE+v6613plq9BOJD9pC
   drfjIM27deyFqXck7RHGnfWvocw5qhyJxPvC8GRBgXO5SzcXX6u2dj+Ft
   +DYZBVFVgAHQjuaMS4Nq25Dsifeq1eiA0I30JDXZpCBvDV70CZh4OE0mQ
   xMAh5q8WoIgmp0psIE0wz729ItK7JGCe/n+l4+6jr1FEtoReaQoKAojdq
   3IxetJYGsNkUdKIzG072Hy0l3vx9AcugWz3P+YK7RMlKkHBnp7k1ynuV3
   w==;
X-CSE-ConnectionGUID: Ps3wB/ohR42Rfn0mND6cKQ==
X-CSE-MsgGUID: r2S7TlnNTdKU43/5O9smdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="64947664"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="64947664"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 12:08:26 -0700
X-CSE-ConnectionGUID: Bh80IEN1Quu9PIXBPDzPHQ==
X-CSE-MsgGUID: hsk36SrGT+C+fwVQv4Wimw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159608638"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.103.51])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 12:08:25 -0700
Date: Tue, 8 Jul 2025 12:08:24 -0700
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
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
Message-ID: <aG1sqKBJSfHydDsx@agluck-desk3>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <b2de4c92-a883-40b0-92e0-16fac9e386b0@intel.com>
 <aGa8Pg9pSCJ3XjtY@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGa8Pg9pSCJ3XjtY@agluck-desk3>

On Thu, Jul 03, 2025 at 10:22:06AM -0700, Luck, Tony wrote:
> On Thu, Jul 03, 2025 at 09:45:15AM -0700, Reinette Chatre wrote:
> > Hi Tony and Dave,
> > 
> > On 6/26/25 9:49 AM, Tony Luck wrote:
> > >  --- 14 ---
> > > Add mon_evt::is_floating_point set by resctrl file system code to limit
> > > which events architecture code can request be displayed in floating point.
> > > 
> > > Simplified the fixed-point to floating point algorithm. Reinette is
> > > correct that the additional "lshift" and "rshift" operations are not
> > > required. All that is needed is to multiply the fixed point fractional
> > > part by 10**decimal_places, add a rounding amount equivalent to a "1"
> > > in the binary place after those supplied. Finally divide by 2**binary_places
> > > (with a right shift).
> > > 
> > > Explained in commit comment how I chose the number of decimal places to
> > > use for each binary places value.
> > > 
> > > N.B. Dave Martin expressed an opinion that the kernel should not do
> > > this conversion. Instead it should enumerate the scaling factor for
> > > each event where hardware reported a fixed point value. This patch
> > > could be dropped and replaced with one to enumerate scaling factors
> > > per event if others agree with Dave.
> > 
> > Could resctrl accommodate both usages? For example, it does not
> > look too invasive to add a second file <mon_evt::name>.raw for the
> > mon_evt::is_floating_point events that can output something like Dave
> > suggested in [1]:
> > 
> > .raw file format could be:
> > 	#format:<output that depends on format>
> > 	#fixed-point:<value>/<scaling factor>
> > 
> > Example output:
> > 	fixed-point:0x60000/0x40000
> 
> Dave: Is that what you want in the ".raw" file? An alternative would be
> to put the format information for non-integer events into an
> "info" file ("info/{RESOURCE_NAME}_MON/monfeatures.raw.formats"?)
> and just put the raw value into the ".raw" file under mon_data.

Note that I thought it easier for users to keep the raw file to just
showing a value, rather than including the formatting details in
Reinette's proposal.

Patch to implement my alternative suggestion below. To the user things
look like this:

$ cd /sys/fs/resctrl/mon_data/mon_PERF_PKG_01
$ cat core_energy
0.02203
$ cat core_energy.raw
5775
$ cat /sys/fs/resctrl/info/PERF_PKG_MON/mon_features_raw_scale
core_energy 262144
activity 262144
$ bc -ql
5775 / 262144
.02202987670898437500

If this seems useful I can write up a commit message and include
as its own patch in v7. Suggestions for better names?

-Tony

---

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 4704ea7228ca..5ac4e3c98f23 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -90,6 +90,8 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  *                   the event file belongs. When @sum is one this
  *                   is the id of the L3 cache that all domains to be
  *                   summed share.
+ * @raw:             Set for ".raw" files that directly show hardware
+ *                   provided counts with no interpretation.
  *
  * Pointed to by the kernfs kn->priv field of monitoring event files.
  * Readers and writers must hold rdtgroup_mutex.
@@ -100,6 +102,7 @@ struct mon_data {
 	struct mon_evt		*evt;
 	int			domid;
 	bool			sum;
+	bool			raw;
 };
 
 /**
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 29de0e380ccc..78e7af296d5a 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -753,7 +753,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		seq_puts(m, "Error\n");
 	else if (rr.err == -EINVAL)
 		seq_puts(m, "Unavailable\n");
-	else if (evt->binary_bits == 0)
+	else if (md->raw || evt->binary_bits == 0)
 		seq_printf(m, "%llu\n", rr.val);
 	else
 		print_event_value(m, evt->binary_bits, rr.val);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 511362a67532..97786831722a 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1158,6 +1158,21 @@ static int rdt_mon_features_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+static int rdt_mon_features_raw_scale_show(struct kernfs_open_file *of,
+					   struct seq_file *seq, void *v)
+{
+	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
+	struct mon_evt *mevt;
+
+	for_each_mon_event(mevt) {
+		if (mevt->rid != r->rid || !mevt->enabled || !mevt->binary_bits)
+			continue;
+		seq_printf(seq, "%s %u\n", mevt->name, 1 << mevt->binary_bits);
+	}
+
+	return 0;
+}
+
 static int rdt_bw_gran_show(struct kernfs_open_file *of,
 			    struct seq_file *seq, void *v)
 {
@@ -1823,6 +1838,13 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_mon_features_show,
 		.fflags		= RFTYPE_MON_INFO,
 	},
+	{
+		.name		= "mon_features_raw_scale",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdt_mon_features_raw_scale_show,
+		.fflags		= RFTYPE_MON_INFO,
+	},
 	{
 		.name		= "num_rmids",
 		.mode		= 0444,
@@ -2905,7 +2927,7 @@ static void rmdir_all_sub(void)
  */
 static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 					struct mon_evt *mevt,
-					bool do_sum)
+					bool do_sum, bool rawfile)
 {
 	struct mon_data *priv;
 
@@ -2916,7 +2938,8 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evt == mevt)
+		    priv->sum == do_sum && priv->evt == mevt &&
+		    priv->raw == rawfile)
 			return priv;
 	}
 
@@ -2928,6 +2951,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 	priv->domid = domid;
 	priv->sum = do_sum;
 	priv->evt = mevt;
+	priv->raw = rawfile;
 	list_add_tail(&priv->list, &mon_data_kn_priv_list);
 
 	return priv;
@@ -3078,12 +3102,13 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 	struct rmid_read rr = {0};
 	struct mon_data *priv;
 	struct mon_evt *mevt;
+	char rawname[64];
 	int ret;
 
 	for_each_mon_event(mevt) {
 		if (mevt->rid != r->rid || !mevt->enabled)
 			continue;
-		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
+		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum, false);
 		if (WARN_ON_ONCE(!priv))
 			return -EINVAL;
 
@@ -3093,6 +3118,18 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 
 		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
 			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
+
+		if (!mevt->binary_bits)
+			continue;
+
+		sprintf(rawname, "%s.raw", mevt->name);
+		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum, true);
+		if (WARN_ON_ONCE(!priv))
+			return -EINVAL;
+
+		ret = mon_addfile(kn, rawname, priv);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
