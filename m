Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6808741BA9B
	for <patches@lists.linux.dev>; Wed,  7 Oct 2026 21:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407223; cv=none; b=Zbk4401voq7LGQHT5kEw8GZiox5km4plUL7dFgYl+qbBSVf7M0OuSBrmd61V9dwHhshTxAdYfhPIvlz359ACD6SZ5MLUhNStJLwmenyT8DadFb7KH/hcwJuA94BIEuDPHD4u16x7HGGoTQ3IidMGhGehTe+kdhh28dyyjnv25rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407223; c=relaxed/simple;
	bh=Scrct7ScSRFbkVyEA2UPHG4EIk3xC7AXEWEsL6EUzx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBUiM7NGrEp0b9XvR2g+BHFGwfNFOn4k/9H57x+ascfsfYXj5e9S8B/THcDC2+B+NZgBYN2w0KwaPnNYfHu3pWPcNqMSfWSzcaXdefuhtc8W/ms+BbreT2j3YXu+pV2xRjkGJEqhyABPwneaJFnigOKzaarlZYOMMtuaSq5ERI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KmZGuxpf; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KmZGuxpf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791407222; x=1822943222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Scrct7ScSRFbkVyEA2UPHG4EIk3xC7AXEWEsL6EUzx0=;
  b=KmZGuxpfIFsqa3t0JKd+WLOUcXvJZIeEQTzUHQaRvEQ5PPW8xukbirOX
   Xt0quSGYTMa9Axpx7bicYHXA0Toq3zE7udi/gMAwURh3cTMthIr1cX7p0
   aMCF8QHzY+uzms3cnF1yoq/n2ltdSMg6crtyRqZ9wjSo+7OqowZHsSu0J
   otJE97uqgzeK5Jy0kqMCYWLz+vz+qfDOopR4j7zcUy2AP7HJRo14WANzr
   Uz1n5lFfOr2Gb98u81u18ckLLfO0QlpWTUXOo38+LRT4dHp7tQQ3/Yi72
   AziOboeMhjVW4PmmQHU1+NUX4qiy6oktjMFyFeE98f0PEg7DGcad8GuxC
   Q==;
X-CSE-ConnectionGUID: vLnK8Ug2Sgm7v4eJfRSzVQ==
X-CSE-MsgGUID: x2YDQuSbRIGMsDcnz4aDEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="289430"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="289430"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:58 -0700
X-CSE-ConnectionGUID: e/e/1sK/Qn+tUOvVj3KVsA==
X-CSE-MsgGUID: cTYtnZmLSCSzbKe/Hz4Shg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="282359709"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 14:06:57 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v2 5/5] fs/resctrl: Drop unnecessary parameter from resctrl_io_alloc_parse_line()
Date: Wed,  7 Oct 2026 14:06:47 -0700
Message-ID: <b01d58ebb13c6cadd68c0fb33f469fdb32dcb597.1791406459.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791406459.git.reinette.chatre@intel.com>
References: <cover.1791406459.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl_io_alloc_parse_line() parses a line written to the io_alloc_cbm file.
It receives both a schema and a pointer to the schema's resource. Its only
caller looks up the resource from the schema just to pass both.

Passing the resource separately is redundant and allows a caller to pass a
resource that does not belong to the schema. parse_line(), which parses lines
written to the schemata file, already receives only the schema and determines
the resource from it.

Pass only the schema to resctrl_io_alloc_parse_line() and have it determine
the resource itself, matching parse_line() and in preparation for passing
additional information when supporting multiple controls.

No functional change.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since RFC v2:
- Rework changelog.

Changes since v1:
- Rework changelog.
- Add justification for the change. (Ben)
- Add Ben's Reviewed-by tag.
---
 fs/resctrl/ctrlmondata.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 4562072b8ba6..69123b2a3274 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -955,11 +955,12 @@ int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
 	return ret;
 }
 
-static int resctrl_io_alloc_parse_line(char *line,  struct rdt_resource *r,
-				       struct resctrl_schema *s, u32 closid)
+static int resctrl_io_alloc_parse_line(char *line, struct resctrl_schema *s,
+				       u32 closid)
 {
 	enum resctrl_conf_type peer_type;
 	unsigned long dom_id = ULONG_MAX;
+	struct rdt_resource *r = s->res;
 	struct rdt_parse_data data;
 	struct rdt_ctrl_domain *d;
 	bool update_all = false;
@@ -1052,7 +1053,7 @@ ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
 	io_alloc_closid = resctrl_io_alloc_closid(r);
 
 	rdt_staged_configs_clear();
-	ret = resctrl_io_alloc_parse_line(buf, r, s, io_alloc_closid);
+	ret = resctrl_io_alloc_parse_line(buf, s, io_alloc_closid);
 	if (ret)
 		goto out_clear_configs;
 
-- 
2.55.0

