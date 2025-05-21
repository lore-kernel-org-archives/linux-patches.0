Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84A424887D
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867876; cv=none; b=gRtRe7ZAxYzRozP6xd6wVcUiy/KwO+V589CVfHIkzbTSmCMpmfTcM6iTwJY4KMQhshplPZ6iQqtHJ3kNN12pEp5MMYSS8kJnZV2h6FVstfdsY80mdtHa2eBC8AcBP4MDZb68XhDD1YfxXAEfvWMexOG9qtNMUjzUo1wy10k1OZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867876; c=relaxed/simple;
	bh=jrQloV55Ky0xgLq1zhFh0R9wuW/MuUNKJYq9Raj0okk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kzx9f4Lmtc52kgHuFy8/IugLvFPGiQ+CejlIzxcELGLVpSB9nKeR3v/xCxxrBqqGMSB68RUBdRdoQb7g8C9KliYohxTT1tIZ7vRqIUadCHnGZh4T1O+2TqmcMZSJ9LkteTKNC9QCD71BGDZOHu88TsS2vNDVJQfq6IHUkPk3iKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PDQkdJ/0; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PDQkdJ/0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867874; x=1779403874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jrQloV55Ky0xgLq1zhFh0R9wuW/MuUNKJYq9Raj0okk=;
  b=PDQkdJ/0FT40UHdMQ8lTqUcXxqYVF2o31qb367sctEmnbzGQSZ765C/4
   vIZQaWNeBiC5sH6lax3eNqPbURwX2Y5IqrwkNRU36FR+96Q0+fNbf/L0m
   DzGzZ5lZLYRB/Fz39PfstweSoOEpvdIBJ8iYg+4KfkzP3rFdFwQZ/ZBuU
   aBZDc9kVWIHUZy5bKuav0fwGWrsH7IPYf2RsLrZg+ulPKDSDbw0v6CWpG
   LmumO9yGp5gX3KJi40IXMOFMjxhGbVhMzAg8fEOjbaZME5s9yS49RPcrt
   AWj1H/0muDhHzzPrPgVKev7VDzkdl/NnxULJCiIP+YfcCLeKVTbjmYI3D
   Q==;
X-CSE-ConnectionGUID: YFlRuh6ESdiRKQIh+Sl/SA==
X-CSE-MsgGUID: LxqzmcCXSgK4hpOt/wHYSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677808"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677808"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:51:00 -0700
X-CSE-ConnectionGUID: PhPr06BlSii+AiDBGoPJHA==
X-CSE-MsgGUID: fd64e14iStGT9CnV3YtdCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352206"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for architecture info file
Date: Wed, 21 May 2025 15:50:45 -0700
Message-ID: <20250521225049.132551-28-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Creation of all files in the resctrl file system is under control of
the file system layer.

But some resources may need to add a file to the info/{resource}
directory for debug purposes.

Add a new rdt_resource::info_file field for the resource to specify
show() and/or write() operations. These will be called with the
rdtgroup_mutex held.

Architecture can note the file is only for debug using by setting
the rftype::flags RFTYPE_DEBUG bit.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h | 33 +++++++++++++++++++++++++++
 fs/resctrl/internal.h   | 31 ++-----------------------
 fs/resctrl/rdtgroup.c   | 50 ++++++++++++++++++++++++++++++++++++++---
 3 files changed, 82 insertions(+), 32 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index b7e15abcde23..e067007c633c 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -73,6 +73,37 @@ enum resctrl_conf_type {
 
 #define CDP_NUM_TYPES	(CDP_DATA + 1)
 
+/**
+ * struct rftype - describe each file in the resctrl file system
+ * @name:	File name
+ * @mode:	Access mode
+ * @kf_ops:	File operations
+ * @flags:	File specific RFTYPE_FLAGS_* flags
+ * @fflags:	File specific RFTYPE_* flags
+ * @seq_show:	Show content of the file
+ * @write:	Write to the file
+ */
+struct rftype {
+	char			*name;
+	umode_t			mode;
+	const struct kernfs_ops	*kf_ops;
+	unsigned long		flags;
+	unsigned long		fflags;
+
+	int (*seq_show)(struct kernfs_open_file *of,
+			struct seq_file *sf, void *v);
+	/*
+	 * write() is the generic write callback which maps directly to
+	 * kernfs write operation and overrides all other operations.
+	 * Maximum write size is determined by ->max_write_len.
+	 */
+	ssize_t (*write)(struct kernfs_open_file *of,
+			 char *buf, size_t nbytes, loff_t off);
+};
+
+/* Only rftype::flags option available to architecture code */
+#define RFTYPE_DEBUG			BIT(10)
+
 /*
  * struct pseudo_lock_region - pseudo-lock region information
  * @s:			Resctrl schema for the resource to which this
@@ -281,6 +312,7 @@ enum resctrl_schema_fmt {
  * @mbm_cfg_mask:	Bandwidth sources that can be tracked when bandwidth
  *			monitoring events can be configured.
  * @cdp_capable:	Is the CDP feature available on this resource
+ * @info_file:		Optional per-resource debug info file
  */
 struct rdt_resource {
 	int			rid;
@@ -297,6 +329,7 @@ struct rdt_resource {
 	enum resctrl_schema_fmt	schema_fmt;
 	unsigned int		mbm_cfg_mask;
 	bool			cdp_capable;
+	struct rftype		info_file;
 };
 
 /*
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 1f4800cfcd6a..f13b63804c1a 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -232,7 +232,8 @@ struct rdtgroup {
 
 #define RFTYPE_RES_MB			BIT(9)
 
-#define RFTYPE_DEBUG			BIT(10)
+// RFTYPE_DEBUG available to architecture code in <linux/resctrl.h>
+//#define RFTYPE_DEBUG			BIT(10)
 
 #define RFTYPE_RES_PERF_PKG		BIT(11)
 
@@ -251,34 +252,6 @@ extern struct list_head rdt_all_groups;
 
 extern int max_name_width;
 
-/**
- * struct rftype - describe each file in the resctrl file system
- * @name:	File name
- * @mode:	Access mode
- * @kf_ops:	File operations
- * @flags:	File specific RFTYPE_FLAGS_* flags
- * @fflags:	File specific RFTYPE_* flags
- * @seq_show:	Show content of the file
- * @write:	Write to the file
- */
-struct rftype {
-	char			*name;
-	umode_t			mode;
-	const struct kernfs_ops	*kf_ops;
-	unsigned long		flags;
-	unsigned long		fflags;
-
-	int (*seq_show)(struct kernfs_open_file *of,
-			struct seq_file *sf, void *v);
-	/*
-	 * write() is the generic write callback which maps directly to
-	 * kernfs write operation and overrides all other operations.
-	 * Maximum write size is determined by ->max_write_len.
-	 */
-	ssize_t (*write)(struct kernfs_open_file *of,
-			 char *buf, size_t nbytes, loff_t off);
-};
-
 /**
  * struct mbm_state - status for each MBM counter in each domain
  * @prev_bw_bytes: Previous bytes value read for bandwidth calculation
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index e212e46e0780..f09674c209f8 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -329,6 +329,37 @@ static const struct kernfs_ops rdtgroup_kf_single_ops = {
 	.seq_show		= rdtgroup_seqfile_show,
 };
 
+static int rdtgroup_seqfile_show_locked(struct seq_file *m, void *arg)
+{
+	struct kernfs_open_file *of = m->private;
+	struct rftype *rft = of->kn->priv;
+
+	guard(mutex)(&rdtgroup_mutex);
+
+	if (rft->seq_show)
+		return rft->seq_show(of, m, arg);
+	return 0;
+}
+
+static ssize_t rdtgroup_file_write_locked(struct kernfs_open_file *of, char *buf,
+					  size_t nbytes, loff_t off)
+{
+	struct rftype *rft = of->kn->priv;
+
+	guard(mutex)(&rdtgroup_mutex);
+
+	if (rft->write)
+		return rft->write(of, buf, nbytes, off);
+
+	return -EINVAL;
+}
+
+static const struct kernfs_ops rdtgroup_kf_single_locked_ops = {
+	.atomic_write_len	= PAGE_SIZE,
+	.write			= rdtgroup_file_write_locked,
+	.seq_show		= rdtgroup_seqfile_show_locked,
+};
+
 static const struct kernfs_ops kf_mondata_ops = {
 	.atomic_write_len	= PAGE_SIZE,
 	.seq_show		= rdtgroup_mondata_show,
@@ -2162,7 +2193,7 @@ int rdtgroup_kn_mode_restore(struct rdtgroup *r, const char *name,
 	return ret;
 }
 
-static int rdtgroup_mkdir_info_resdir(void *priv, char *name,
+static int rdtgroup_mkdir_info_resdir(struct rdt_resource *r, void *priv, char *name,
 				      unsigned long fflags)
 {
 	struct kernfs_node *kn_subdir;
@@ -2177,6 +2208,19 @@ static int rdtgroup_mkdir_info_resdir(void *priv, char *name,
 	if (ret)
 		return ret;
 
+	if (r->info_file.name &&
+	    (!(r->info_file.flags & RFTYPE_DEBUG) || resctrl_debug)) {
+		r->info_file.mode = 0;
+		if (r->info_file.seq_show)
+			r->info_file.mode |= 0444;
+		if (r->info_file.write)
+			r->info_file.mode |= 0200;
+		r->info_file.kf_ops = &rdtgroup_kf_single_locked_ops;
+		ret = rdtgroup_add_file(kn_subdir, &r->info_file);
+		if (ret)
+			return ret;
+	}
+
 	ret = rdtgroup_add_files(kn_subdir, fflags);
 	if (!ret)
 		kernfs_activate(kn_subdir);
@@ -2221,7 +2265,7 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
 	list_for_each_entry(s, &resctrl_schema_all, list) {
 		r = s->res;
 		fflags = fflags_from_resource(r) | RFTYPE_CTRL_INFO;
-		ret = rdtgroup_mkdir_info_resdir(s, s->name, fflags);
+		ret = rdtgroup_mkdir_info_resdir(r, s, s->name, fflags);
 		if (ret)
 			goto out_destroy;
 	}
@@ -2229,7 +2273,7 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
 	for_each_mon_capable_rdt_resource(r) {
 		fflags = fflags_from_resource(r) | RFTYPE_MON_INFO;
 		sprintf(name, "%s_MON", r->name);
-		ret = rdtgroup_mkdir_info_resdir(r, name, fflags);
+		ret = rdtgroup_mkdir_info_resdir(r, r, name, fflags);
 		if (ret)
 			goto out_destroy;
 	}
-- 
2.49.0

