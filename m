Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5822DC765;
	Fri,  7 Aug 2026 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115751; cv=none; b=CehZmwcUaYlFYO0OkSTr6mtBTHGfiF6Q3UzpqXaWlAoB36guu7yM1/LK15yk0r5D8E1S1p5r2ehXdBZ1UGbWlSIH9I8MYOVGNRBRK5bi5jyRLDcPlO4qvr28L4pY4WQQOHBhvw8szMS3TyYEyoOj5gRdWgDR3a+vtBxCgx1dRlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115751; c=relaxed/simple;
	bh=hnwIdqogI/wTm/6OCwS/b/MxJ4NanxMXzDEZUjSvyDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KePqV2FQf0oYWbMyJWUjx1Nspv1I8xXWBk3ZMPiEtF9GBkRa0+RV7BrxsqNqNTzl6gBv+WiatO21pnIDcKIDcrmqOELsK+N3sYK6PGjBKgp2WP9DfJKheozT+6yRsT+0U/82qbqJTASmOuPxJQi0xqBetVLyzyYN45x4aTY6HrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4FQo1ec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4FQo1ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672521F00A3A;
	Fri,  7 Aug 2026 15:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115749;
	bh=gBYngiL80D2oXhiWsahWZCkTgyJC4lQZsCRWQbzTUUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4FQo1ecDHCmhkRCyjwgDOa0+hVnegbkssL7eZpwanQUZo1UV3tRHOn/h7dMcZtTr
	 eetMbiRRv3qPTiHAmhTWTJWD/xZAu2WCdAJTyw5ir3+cmOP0aBTM1F+tauvzZYKuu+
	 ooIM+SO40287W5/tCMVz1D/2WHHi0+XuHYMOYvFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Sanjay Yadav <sanjay.kumar.yadav@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Xin Wang <x.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 379/396] drm/xe/pat: Add helper to query compression enable status
Date: Fri,  7 Aug 2026 16:38:59 +0200
Message-ID: <20260807143432.455570645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Xin Wang <x.wang@intel.com>

[ Upstream commit b2bce0e551e89af37cfcb1b1158d80f369eeea3f ]

Add xe_pat_index_get_comp_en() helper function to check whether
compression is enabled for a given PAT index by extracting the
XE2_COMP_EN bit from the PAT table entry.

There are no current users, however there are multiple in-flight series
which will all use this helper.

CC: Nitin Gote <nitin.r.gote@intel.com>
CC: Sanjay Yadav <sanjay.kumar.yadav@intel.com>
CC: Matt Roper <matthew.d.roper@intel.com>
Suggested-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Xin Wang <x.wang@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Nitin Gote <nitin.r.gote@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Sanjay Yadav <sanjay.kumar.yadav@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20251110221458.1864507-2-x.wang@intel.com
Stable-dep-of: 7bc597ce74ba ("drm/xe/vm: Fix BO prefetch with CONSULT_MEM_ADVISE_PREF_LOC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pat.c |    6 ++++++
 drivers/gpu/drm/xe/xe_pat.h |   10 ++++++++++
 2 files changed, 16 insertions(+)

--- a/drivers/gpu/drm/xe/xe_pat.c
+++ b/drivers/gpu/drm/xe/xe_pat.c
@@ -160,6 +160,12 @@ u16 xe_pat_index_get_coh_mode(struct xe_
 	return xe->pat.table[pat_index].coh_mode;
 }
 
+bool xe_pat_index_get_comp_en(struct xe_device *xe, u16 pat_index)
+{
+	WARN_ON(pat_index >= xe->pat.n_entries);
+	return !!(xe->pat.table[pat_index].value & XE2_COMP_EN);
+}
+
 static void program_pat(struct xe_gt *gt, const struct xe_pat_table_entry table[],
 			int n_entries)
 {
--- a/drivers/gpu/drm/xe/xe_pat.h
+++ b/drivers/gpu/drm/xe/xe_pat.h
@@ -58,4 +58,14 @@ void xe_pat_dump(struct xe_gt *gt, struc
  */
 u16 xe_pat_index_get_coh_mode(struct xe_device *xe, u16 pat_index);
 
+/**
+ * xe_pat_index_get_comp_en - Extract the compression enable flag for
+ * the given pat_index.
+ * @xe: xe device
+ * @pat_index: The pat_index to query
+ *
+ * Return: true if compression is enabled for this pat_index, false otherwise.
+ */
+bool xe_pat_index_get_comp_en(struct xe_device *xe, u16 pat_index);
+
 #endif


