Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773C220296C;
	Sun,  3 Aug 2025 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255899; cv=none; b=Z8+YhaKKjEhqmdv3KPR4wRh0vqUrjyiaOjDa252FM3Dl0dPk/3Y9aoNGSs9n7Y4Cj9UAPx7wnHLWUvQVLDLot/pi/jxtnXMN4tdQ4d00HPp1coSwAfStDSdCyNuEhkUQQK1XLdjgh7vHQwt0zdy7uccX60q8K1TioTivCNGTYg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255899; c=relaxed/simple;
	bh=ERkAB5s4LEH7jUU633ii/4C4onNEvkXOHOoJNkER+Pc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LSjImXPdwqAf0duMuZJvC5QZKNaezJqLP51/jN/gxSMeyQYK+NJf2WhK8DBO1IvyuiHInY8YEERk0gfOwakBn3hSIeFrGBBUsxEDT/EbeceFogDxeD8aKoRGwGjmgJkqprFzzd009+scmtBU501eX/RypXGRUfy8yZHLAKeLGmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrkqrUtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrkqrUtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C1CC4CEF8;
	Sun,  3 Aug 2025 21:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255899;
	bh=ERkAB5s4LEH7jUU633ii/4C4onNEvkXOHOoJNkER+Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrkqrUtgQx1drfCQJt34GQnx9mkDWfUbwXRz/v/hBZwOMQ/FnkYkQ0GSjtqqWUIcs
	 gZIO9duZG03jnb7gpLm84ZuIEWIH4X3wWdWwf3EdcKyRB8AkJqZxyFYxMF3hERtAgH
	 vJyUTc66sfH3qpDzMdui/7zgFqLtpp/QcWdikW/riurdpWijEVabx3a8I7GNrHhXNR
	 YGuTKBVw8sqlJLOW6LThHoqYRKCn/HCyEm31/6wC+UJmnmoFayiguedMkecQ8RwM2m
	 KZL/TZGaWWmYxccCaiDIPa/RTRciCmYPAcQYAg+CyU1af6r1Z1Bbz9OPLmSAkH5lBO
	 N9Qpeow7qwq/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.16 17/35] gfs2: Set .migrate_folio in gfs2_{rgrp,meta}_aops
Date: Sun,  3 Aug 2025 17:17:17 -0400
Message-Id: <20250803211736.3545028-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211736.3545028-1-sashal@kernel.org>
References: <20250803211736.3545028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
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
index 9dc8885c95d0..66ee10929736 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -103,6 +103,7 @@ const struct address_space_operations gfs2_meta_aops = {
 	.invalidate_folio = block_invalidate_folio,
 	.writepages = gfs2_aspace_writepages,
 	.release_folio = gfs2_release_folio,
+	.migrate_folio = buffer_migrate_folio_norefs,
 };
 
 const struct address_space_operations gfs2_rgrp_aops = {
@@ -110,6 +111,7 @@ const struct address_space_operations gfs2_rgrp_aops = {
 	.invalidate_folio = block_invalidate_folio,
 	.writepages = gfs2_aspace_writepages,
 	.release_folio = gfs2_release_folio,
+	.migrate_folio = buffer_migrate_folio_norefs,
 };
 
 /**
-- 
2.39.5

