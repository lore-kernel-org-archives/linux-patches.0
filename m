Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D24E390986
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880046; cv=none; b=Bs4n2VYo6acPsj0Yl7Was12Uges0NHQ4Ksc8Sq8zPkop5RcD4/DIi8p+gWv2qRhuxu6k3ThsPyb19PPAUOsejUipzdW9VWfE7LWrbhdNxXfY2X9ql8rmYHbE+i6BNNf1qxtf8aLx54Qhdaexj3VTNB8/jajmXmuFdNuFPvNl30E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880046; c=relaxed/simple;
	bh=HHnIVECCW8v+1P7f5PgYa2YSAJnLVUlrfkptge7PY3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbnKB5en5kuPemQ2glf6JA2XW1hM8RC9mfkgeeiykdIerGFVVI63EH0Eqq6uuKBDvQvP854KrlaCASE1n6u/jWapITKnj2P+w8pQOlZgvQXUJ9jkFLmc5IGTn/90NiDK3r0S50o1mSSr9pwdE/Ujt2QmED9XDiNYgrn+UjmFNTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JrkmlAq6; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JrkmlAq6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880042; x=1814416042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HHnIVECCW8v+1P7f5PgYa2YSAJnLVUlrfkptge7PY3A=;
  b=JrkmlAq6hSBF+bXSNFKVvlBBwyJ70CD8ZoPailB63d4dXfDBi0K+H6WC
   Env3vgag5apbU/k96OXwHQ5iiXdjmG17OJFs4Nchb7y98X9hYjn60mo+m
   8btedUbJ0HYRGVeuEuzsZFE1MlI/JtdU7G4EpjFr+5XJYkrmNRL7Jw2zk
   nLhgBUo17Xuy51+IQ0mDLEo0ZKMzKpUJ5VE2pt0y80PYOv02VfoZpCgjY
   8CWJKUrMu2GOUtYkWmuQNJOCyFcqakgSVZqckORgmi0UHvAl3wxaeyF4J
   H2vwfzDVCn0fxFtXEkgSBIi6BkxcwPShyO4EOeFrtkJc4MfJUVFuyGoiO
   g==;
X-CSE-ConnectionGUID: l/ShAmY3S3+H30yWA2EoYQ==
X-CSE-MsgGUID: lA8f3aFZQBuDtU+A8BY1XA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514264"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514264"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:19 -0700
X-CSE-ConnectionGUID: qrCDhO5uQVqBPnc/yILpEA==
X-CSE-MsgGUID: UDOsSo5ASuyKJv59dlfGrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080586"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:18 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 04/10] fs/resctrl: Use accurate type for rdt_resource::rid
Date: Tue, 30 Jun 2026 21:27:04 -0700
Message-ID: <926b334c50b00b4b763c983c0dca6d4ec9083d60.1782857711.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
References: <cover.1782857711.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every resctrl resource has a unique ID described by enum resctrl_res_level.
enum resctrl_res_level is used in all resource ID initializations and all
resource ID comparisons. All functions consuming the resource ID expects an
enum resctrl_res_level. Of the four structures that contain a resource ID
(struct mon_data, struct mon_evt, struct rdt_domain_hdr, and struct
 rdt_resource) only struct rdt_resource does not use enum resctrl_res_level.

Switch the type of rdt_resource::rid to be enum resctrl_res_level to make
it obvious what values are valid, match the type everywhere this member is
used, and obtain benefits from tools that can flag any enum misuse.

Move define of RDT_NUM_RESOURCES outside the enum to enable tools to catch
when a switch() on the resource ID does not handle all the resources and
thus help flag which switch statements need an update when a new resource
is added.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v1:
- Use RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG as last entry in enum.(Ben)

Changes since v2:
- Add Ben's RB tag.

Changes since v4:
- Add Tony's Reviewed-by tag.
---
 include/linux/resctrl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index c3ae0e8cb522..dd09c2ce9a0f 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -54,11 +54,11 @@ enum resctrl_res_level {
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
 	RDT_RESOURCE_PERF_PKG,
-
-	/* Must be the last */
-	RDT_NUM_RESOURCES,
+	RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG
 };
 
+#define RDT_NUM_RESOURCES (RDT_RESOURCE_LAST + 1)
+
 /**
  * enum resctrl_conf_type - The type of configuration.
  * @CDP_NONE:	No prioritisation, both code and data are controlled or monitored.
@@ -324,7 +324,7 @@ struct resctrl_mon {
  * @cdp_capable:	Is the CDP feature available on this resource
  */
 struct rdt_resource {
-	int			rid;
+	enum resctrl_res_level	rid;
 	bool			alloc_capable;
 	bool			mon_capable;
 	enum resctrl_scope	ctrl_scope;
-- 
2.54.0

