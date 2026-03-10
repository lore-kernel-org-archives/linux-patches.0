Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A3C37F007;
	Tue, 10 Mar 2026 11:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142185; cv=none; b=qtgmjrXt7uXXpOr6kEB/nRo/fJiD5OO7EseljPa9lCYnGAkSf0lAMk/n7TSq+X1RqZoulO2dArzuXnHNkhPddvMr6MixyEVWaTwXJpKV927Q3bZ3gY8D9JW0TpTTx+eMK3vZgcVtPCOpm33KspZZ9i1ogMY8CbX12vyZgMv1uoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142185; c=relaxed/simple;
	bh=upzLWnSw6gmSNi3HrFwIgcISvTGcora75jAfgvJ6hTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID+NFn4qdTimOKSyE6m1hyYwKMX1piHaHLFy0iJC4hmaj/1mNhyGDoytpdX8rAvtlvfUjUr2bQbxltN+LhWyOhr4XPvw2WC/i3+IvGmONZTfhR0gdmrqJfwpQ6rNbwHMsAj+mobAC/s6whjMasZKzAZXxj1h+Z9PB2jhIiAZqxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROpTAolk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROpTAolk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800D7C2BC9E;
	Tue, 10 Mar 2026 11:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142185;
	bh=upzLWnSw6gmSNi3HrFwIgcISvTGcora75jAfgvJ6hTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROpTAolkDYpX2wK4BgCVh2ZWYFqHN412cOMccc0coepNAsuQe+qeUR3RaJbr+7t50
	 bC4HiIQnNjriTGjEYBbT5nJc72OtrR2j9RKvUmezll9tcKqJP1WovivlP3ejCke/dI
	 nzftcpKSg0Zpu1lqHmutYRPtQULA46XoM7ypzVmCKHBOtSC6dVbSUxAOuuHcVX0TX/
	 qTeiqdy1QQ6D71giryzjB84j7uNIsy6i3L34IRdIab3Krn/AEajGASR3w4u76Kf98N
	 4Q5X2B9mmdiTM2mLntBhTabMm7n645DAgAPl2DDwkMUvEKUvmd1zoyDcLiVm4OBtkh
	 fwUi1TNuz3Bew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuicheng Lin <shuicheng.lin@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/314] drm/xe/reg_sr: Fix leak on xa_store failure
Date: Tue, 10 Mar 2026 07:18:53 -0400
Message-ID: <855a84f4c711050bc36d1732f3e50ecf4f682d40.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 3091723785def05ebfe6a50866f87a044ae314ba ]

Free the newly allocated entry when xa_store() fails to avoid a memory
leak on the error path.

v2: use goto fail_free. (Bala)

Fixes: e5283bd4dfec ("drm/xe/reg_sr: Remove register pool")
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20260204172810.1486719-2-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 6bc6fec71ac45f52db609af4e62bdb96b9f5fadb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_sr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_reg_sr.c b/drivers/gpu/drm/xe/xe_reg_sr.c
index fc8447a838c4f..6b9edc7ca4115 100644
--- a/drivers/gpu/drm/xe/xe_reg_sr.c
+++ b/drivers/gpu/drm/xe/xe_reg_sr.c
@@ -101,10 +101,12 @@ int xe_reg_sr_add(struct xe_reg_sr *sr,
 	*pentry = *e;
 	ret = xa_err(xa_store(&sr->xa, idx, pentry, GFP_KERNEL));
 	if (ret)
-		goto fail;
+		goto fail_free;
 
 	return 0;
 
+fail_free:
+	kfree(pentry);
 fail:
 	xe_gt_err(gt,
 		  "discarding save-restore reg %04lx (clear: %08x, set: %08x, masked: %s, mcr: %s): ret=%d\n",
-- 
2.51.0

