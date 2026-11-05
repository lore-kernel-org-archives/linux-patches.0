Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793837632;
	b=b486b1m+egrBh/MD37qFVTGLDwBnJblZH9cFCzqeYetgaKqLaz5e4PS4wIUZSGG5oHuw
	 1qnzHYj9vhHeff3sdSZHqeN+KgAi+yZfnUL5YG+IIKixrn1NGmTS0S/lNmVa2Xmcw3Dxx
	 lTcut7fmCD+OiEPNunU1x14iW6EXBB5jWOUXIc4OYG3DgkfeVhJJ0qKTKusU31irfXaHS
	 QHDxhzUoDeR0W/xWwesANu/sF2iym4RCkE5ekhN6SUvmpvktNngS7VQNN6d0a4fEr889K
	 uzBxBCgbpO56EM42SPHRZdg8W3BaI2PMueFWlQhn+7SsI+I+OWZIcueGvTXTIVeuH8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793837632;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0+fNztufs1eVteXjQBxmHuq9j9tn1jSWfIe1L5JVEd8=;
	b=g+LhF41Uuihap4jyZEGdTwF7/XcqqJrcjk3qNcBRrUAYFA5dYZNblZwXD4RnMveiuZhu
	 ZLRTjVI4jupBkUV70fdsBogonWZVfXddjtb2cCDi9gfrAPZmHw8tF9cl9YIFlS70ZAd1a
	 zeOZKCfU3SNyurg6CNqeIxNUPdx9vCZ9K7yaujSrzgjHeG19iD423M0g4vc6NrnHxGzo9
	 MHHy0mxunGjS66+mrxzRCwa97fqpLfBSAQLEqxkg+LOaWQ4t2X7h8DrHUg8M186U+euGl
	 9NEQojwkKIpNRfN4lNOx+YmQ7BQ8125fpZ+WfU2rBsS83slmEyG9G9f9zbJXEra+i8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Jj8FdGcp;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DCA606D80C
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 00:13:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36DCA606D80C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Jj8FdGcp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793837631; x=1825373631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/U9qdISphkF+6BE2UiAWxxkGo7j3p7aKm4H3XXNWFwQ=;
  b=Jj8FdGcp4/5hXn3O7wV625QSAgIhcQZJlhd+Twsc/nwWHFli8Db+lWs/
   +oNoWIty/9FI7KwWII/GaafwgOfs6PIQUb1O37bp8pgJFDSFN5exciWWk
   Y40UnXPl+HJRwDeHuQdbmKfKDETga0N4FwNDHfO+V14pUVuowVcKFYy4y
   T6RM0xZ2Yiu83/r9P9SdS6XJomJMPgQUAANFtbjz51VRq/R0bkvT8lGxq
   TffJoNYd9HDktFHiTLvWqK5uxggFAMC6/csSImMqXAJBi4Z2Oouo4p4Iz
   v0+cXGcR/ARHxaYghp55rC33FiHt+MTISsyhC6pGf0N4Lsa604/dZpAgT
   Q==;
X-CSE-ConnectionGUID: t0d6xbb1Rpunw0nlaHADMQ==
X-CSE-MsgGUID: K5Yhi9uCSK2lvxtnIZNPiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2512787"
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="2512787"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:13:49 -0800
X-CSE-ConnectionGUID: pj7arQf6SMmCQv92sgeI0A==
X-CSE-MsgGUID: +bqv9w9ORTucceMqIrRYVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="7168853"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:13:49 -0800
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
Subject: [PATCH v3 5/5] fs/resctrl: Drop unnecessary parameter from resctrl_io_alloc_parse_line()
Date: Wed,  4 Nov 2026 16:13:33 -0800
Message-ID: <a1cbad5a426689842502793f21ddb1e9b3b6408d.1793834224.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793834224.git.reinette.chatre@intel.com>
References: <cover.1793834224.git.reinette.chatre@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
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
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since RFC v2:
- Rework changelog.

Changes since v1:
- Rework changelog.
- Add justification for the change. (Ben)
- Add Ben's Reviewed-by tag.

Changes since v2:
- Add Chenyu, Jinjie, and Tony's Reviewed-by tags.
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
2.56.0

