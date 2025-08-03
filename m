Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8942B2040A8;
	Sun,  3 Aug 2025 21:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256054; cv=none; b=I/E2NVqgWQPQsK6Jck55UKj3kGo3pg6RZUr6P4ggZmLbvtRJ3rxJOSoqivuJtfUqlS28p+wILnpD4ZRcHFrWQpiZt/LroCwKApYVjs+/SO70nwoe+JhhH4A2roOTxB/IDpV9OZ9GSQCvG7kb6pVa+EiMrwXtbgIjFEhWA9Ywm/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256054; c=relaxed/simple;
	bh=beJ0Qhf0+x95UbSfUbqVN/0QATm5+ul+IfAg+UFf1HY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=md58g1+Lvu3UFQ/D7RE8G1YmSuHeTmMWdEZI0/KyEv0tkltyVcCYwTpdvduIfIrAz7lbCd9LSbyOG1e1WmD/jCFjcpOLm6lPTVT2RAm1ToDYkRdd6XBMAZ4QzNAMa7m+eNY4KNGSUBYhUWd+p7E9XuHlG6lXBnalaDbYbsB2G38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAzAl8SI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAzAl8SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E921C4CEF8;
	Sun,  3 Aug 2025 21:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256054;
	bh=beJ0Qhf0+x95UbSfUbqVN/0QATm5+ul+IfAg+UFf1HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAzAl8SIwCgFTvGPAr+iLTUoCaf7lR2u6dI07KhLc0nXSnOqGZO7GQ3oiCajIAnQA
	 K7Tc9nKLuDAku7MI/LrIEVITqEY90DSByImB18WichiFVNpv5SXne0yq5kOoW4w++X
	 dWgee9eDB70/hxARFv4VmgYkqG0Ic0sONujChnzP7RQEMCF117zpR2edHeMnKbcLUq
	 trVbTdh9jyzGkio/TpoC540MyB2ETeyB3sn4fcQR/NPpCw7z1BQcw3eWIN3cs6lFKg
	 i2Rvgi5COoFZJK2TWXi5/mOMJ9dyDozYASfLz5HBcIPpFPcqxZgaoiJbd9WxrK8UXh
	 codZa1GcofTQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.6 09/23] gfs2: Set .migrate_folio in gfs2_{rgrp,meta}_aops
Date: Sun,  3 Aug 2025 17:20:16 -0400
Message-Id: <20250803212031.3547641-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212031.3547641-1-sashal@kernel.org>
References: <20250803212031.3547641-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Andrew Price <anprice@redhat.com>

[ Upstream commit 5c8f12cf1e64e0e8e6cb80b0c935389973e8be8d ]

Clears up the warning added in 7ee3647243e5 ("migrate: Remove call to
->writepage") that occurs in various xfstests, causing "something found
in dmesg" failures.

[  341.136573] gfs2_meta_aops does not implement migrate_folio
[  341.136953] WARNING: CPU: 1 PID: 36 at mm/migrate.c:944 move_to_new_folio+0x2f8/0x300

Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, I can now provide my assessment:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real bug**: The commit fixes a warning that appears in
   xfstests runs where GFS2 filesystems trigger a WARN_ONCE in
   mm/migrate.c:944 because the gfs2_meta_aops and gfs2_rgrp_aops
   address space operations don't implement the migrate_folio callback.

2. **Small and contained fix**: The change is minimal - it only adds two
   lines setting `.migrate_folio = buffer_migrate_folio_norefs,` to two
   address_space_operations structures in fs/gfs2/meta_io.c. This is a
   very low-risk change.

3. **Prevents test failures**: Without this fix, xfstests fail with
   "something found in dmesg" errors due to the warning, which affects
   testing infrastructure and CI systems.

4. **Follows established pattern**: The fix uses
   `buffer_migrate_folio_norefs`, which is the standard migration
   function for filesystems that use buffer heads without additional
   reference counting requirements. This same function is already used
   by ext4, nilfs2, and block device operations.

5. **Regression from upstream change**: The warning was introduced by
   commit 7ee3647243e5 ("migrate: Remove call to ->writepage"), which
   enforces that filesystems must implement migrate_folio. This makes
   the fix necessary for proper operation with newer kernels.


The fix is a classic stable tree candidate: it addresses a specific bug,
has minimal code changes, doesn't introduce new features or
architectural changes, and fixes a regression that affects users running
tests on GFS2 filesystems.

 fs/gfs2/meta_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 1f42eae112fb..b1a368fc089f 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -93,6 +93,7 @@ const struct address_space_operations gfs2_meta_aops = {
 	.invalidate_folio = block_invalidate_folio,
 	.writepage = gfs2_aspace_writepage,
 	.release_folio = gfs2_release_folio,
+	.migrate_folio = buffer_migrate_folio_norefs,
 };
 
 const struct address_space_operations gfs2_rgrp_aops = {
@@ -100,6 +101,7 @@ const struct address_space_operations gfs2_rgrp_aops = {
 	.invalidate_folio = block_invalidate_folio,
 	.writepage = gfs2_aspace_writepage,
 	.release_folio = gfs2_release_folio,
+	.migrate_folio = buffer_migrate_folio_norefs,
 };
 
 /**
-- 
2.39.5

