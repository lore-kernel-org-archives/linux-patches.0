Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93355471264;
	Tue, 21 Jul 2026 18:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659283; cv=none; b=jGYEgg6pMCyo0HYn0DWMPAOcdC395LdFEeSmSPkXVnlhbFy8E0JrTT2oZMHEv3WTOGJ30UGWpboIMlzPnFtZ+VxLvy3pcpBeYcF5Wn71KpxmdHYbaSUfNbMfMyvHus3jydda0Y4wS/1zXkGAEkNXe8QWN/kBygH2dySJlP6SBps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659283; c=relaxed/simple;
	bh=CK7x0v1+/DsFCuNMcvjOO1M/Lgwk2dBBlh7/0jJKO+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5yumlEwEfJa1XqNV6kHo2Bc7DMIR4ABxbJ6nr8O+y33oF8vToMv2jmvbfr/3kHneUg9RY5vTzsX7zTFk96DqDB4fBYuwqVpp2jWny+B+pZlYQU65ioXdkp4as2qOUfFNKlQzQuzCMS7K72Bk46ht26FHiatbT/So+Y7/LRlyEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYWO9x8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYWO9x8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C231F000E9;
	Tue, 21 Jul 2026 18:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659282;
	bh=uWUa5X52Tl+fg6p64dNH0EoqITnCJxADQ/1sw+Fcy0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYWO9x8xVa16rXi09w+ZU78gL0NWJwfCpo3GNpO/SWR/rHr6mxGmyHvElrMiA2o/m
	 Uu6pmKoHX4lHQA5yS3liwilUtvSX4gPIAHrSCrEkjIRnsODSy/v/qp4wVHq1K0YDfR
	 ffa5Cjm5xcvuMxud8OdNCCKmzldfTmd4KXPGspsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chen Yu <yu.c.chen@intel.com>,
	Ben Horgan <ben.horgan@arm.com>,
	stable@kernel.org
Subject: [PATCH 6.18 1462/1611] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Tue, 21 Jul 2026 17:26:18 +0200
Message-ID: <20260721152548.331740357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit ca0676ae2e1a23ac3e858224fc630b99f9e216ea upstream.

If mkdir_mondata_all() or a subsequent call in rdt_get_tree() fails, the
mon_data structures allocated by mon_get_kn_priv() are leaked.

Add mon_put_kn_priv() to the out_mongrp error path to free the mon_data
structures.

Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
Closes: https://lore.kernel.org/lkml/5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com/
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/433623b7e3316ffd52323255d1aa4f156ad97cb1.1783377598.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/resctrl/rdtgroup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -73,6 +73,8 @@ static int rdtgroup_setup_root(struct rd
 
 static void rdtgroup_destroy_root(void);
 
+static void mon_put_kn_priv(void);
+
 struct dentry *debugfs_resctrl;
 
 /*
@@ -2807,6 +2809,7 @@ out_mondata:
 		kernfs_remove(kn_mondata);
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
+		mon_put_kn_priv();
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
 		kernfs_remove(kn_mongrp);
 	}


