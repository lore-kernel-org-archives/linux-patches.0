Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE623CF683
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577787; cv=none; b=iN6au/4NgRt4/pmBtcQ8j1F2LCmtFkTxV6d3YhPJxm+u5sXk5waVngnhZ7CRrsUAAAB1puODeLz/myMVYNfBkMGngIR/kK1tv7TuRy6El/pY6n8d5sQyP30TSsgCYo8fVfO+6WUQIITaOOerpEROCruKq6zLWG4POG5n796PBrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577787; c=relaxed/simple;
	bh=kmpz5ziyeYgyjq9BX9vfAEaKU1VXDjgMSNyT/xCR9+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEPJ41E9c1l15D2csBcCBdtSFjTxBy79TKr3lC/+/Pi/0R10nz2CZk+XqL+xDV0EBuETxc8MtyAjgfoacntdzr9rkeFM7oVuKFG9kfeRO5MMjZcqh0WVlzc436lk2XKjOq/gFXRH2QGl5aKTUiZv7gxWEacXKlfgUbs9hvEQLhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wr4BH3np; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wr4BH3np"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577779; x=1807113779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kmpz5ziyeYgyjq9BX9vfAEaKU1VXDjgMSNyT/xCR9+Q=;
  b=Wr4BH3npTeMmkcIejXtis4dnTAhR2B2018a/wbLDm/wc4zfTiPHvVxyh
   J8s4iwM5dr5RNdik1M1T/PS4FeHMoHiSiiWTBGfQkguNN6Mxz07YCvQuy
   BwTdyAGkJ5L8YniOPxXxN6BPpRDOQ+PYheZbNtSON/2JHxIvgr8yJyamt
   vmouju9OaAwTYoAmtiL2/ftGjWWM+MY+ljm5HErTpjitXn9iRjifCxFLc
   9NflhMJmHjXD++5aPlRSJ08xFV9ptw33LLF0ZIY1TSNIIgtUAdpwYeGgX
   3KG1Re1dGR4ewxXa+899dx5yOq+UmAkTQl37YpC1F1TJVUkhN2XFifMLj
   g==;
X-CSE-ConnectionGUID: iBLmUZgOQrOKu3qyZ88W7g==
X-CSE-MsgGUID: dpOFR9T1RvaziSlysSSaqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432761"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432761"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:20 -0700
X-CSE-ConnectionGUID: Y85Y3FGASnaJsp9BEqyRjA==
X-CSE-MsgGUID: eu0ImZeMSqKieK3u8x93bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119069"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 13/13] fs/resctrl: Inform user space when status buffer overflowed
Date: Tue,  7 Apr 2026 09:02:10 -0700
Message-ID: <ad457d06bc7ae8186a1dbd1687948b4e9a0ec512.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl fs commands are becoming more powerful with, for example, a user
able to use syntax like '*' to make broad configuration changes. Such
commands that span multiple domains may result in more than one message
printed to the last_cmd_status buffer with more planned.

Display "[truncated]" to user space when displaying the last_cmd_status
buffer to communicate if it overflowed. Upon encountering this user space
is expected to combine details about the failure found in info/last_cmd_status
with related resctrl files to learn the accurate system state after the
command failure.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
- Add Ben's RB tag.
---
 fs/resctrl/rdtgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0677e6e4102e..5413a625ff32 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -971,10 +971,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 
 	mutex_lock(&rdtgroup_mutex);
 	len = seq_buf_used(&last_cmd_status);
-	if (len)
+	if (len) {
 		seq_printf(seq, "%.*s", len, last_cmd_status_buf);
-	else
+		if (seq_buf_has_overflowed(&last_cmd_status))
+			seq_puts(seq, "[truncated]\n");
+	} else {
 		seq_puts(seq, "ok\n");
+	}
 	mutex_unlock(&rdtgroup_mutex);
 	return 0;
 }
-- 
2.50.1

