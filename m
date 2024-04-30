Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4058412C487;
	Tue, 30 Apr 2024 11:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474947; cv=none; b=fxghKrmgl3eqlMx4Gtaaxa292FyoikMCEy0AEsu5wlYLKULQSTOCJngsBiyyreq/uIy77J+rHDrNPaD3SPMDZcr8KpNOYK1tR61dy5/744e/4ZpFbFv5txMDoEgbWiwTZEI5RFvZnjwxuzvn0pyhRG2WnFLgj8mAlvI/Unb6xk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474947; c=relaxed/simple;
	bh=UW4EtsvpQoQZAqwxanLNoEHefzL3BzLPD6NIuQSNGZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTPXHCs8wUvG0/HcRUbpRXkGnbE+ZUMyTwcdWLeqgWUffHdHzO63w6TxlUS/pj8JvVrNxNhwOYEpZAkze5LZHs0rQHXk57BJercPJYAUd6fkHvVYooBrXlkwiEdEVoBm5gMhjta8JgkyZc8Mwqgv1uJsx4MEh5fXOeBQzpwjprQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cx3tDrT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cx3tDrT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75476C2BBFC;
	Tue, 30 Apr 2024 11:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474945;
	bh=UW4EtsvpQoQZAqwxanLNoEHefzL3BzLPD6NIuQSNGZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cx3tDrT5TWC045Dw/n7+fwh4Q9ZWRLiAdtKEjPiOT00qnWeOZL4DzQSnECCFKSkcE
	 LVSeaJyvvAz36XNmh1i7Nhi7UuUlprX2XkfkmqbRLXdbp+KRo43fLqZYgp/E8GtOlb
	 q3LXIUv++3dVqeBAfWLyanqn5Io+BWWAPfBX1w4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/138] clk: Mark all_lists as const
Date: Tue, 30 Apr 2024 12:38:50 +0200
Message-ID: <20240430103050.757333072@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 75061a6ff49ba3482c6319ded0c26e6a526b0967 ]

This list array doesn't change at runtime. Mark it const to move to RO
memory.

Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20220217220554.2711696-2-sboyd@kernel.org
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 67a882e03dfdd..1043addcd38f6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -37,7 +37,7 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
-static struct hlist_head *all_lists[] = {
+static const struct hlist_head *all_lists[] = {
 	&clk_root_list,
 	&clk_orphan_list,
 	NULL,
@@ -4063,7 +4063,7 @@ static void clk_core_evict_parent_cache_subtree(struct clk_core *root,
 /* Remove this clk from all parent caches */
 static void clk_core_evict_parent_cache(struct clk_core *core)
 {
-	struct hlist_head **lists;
+	const struct hlist_head **lists;
 	struct clk_core *root;
 
 	lockdep_assert_held(&prepare_lock);
-- 
2.43.0



