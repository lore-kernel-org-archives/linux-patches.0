Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DA0149C55;
	Wed,  4 Jun 2025 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998276; cv=none; b=Yy0mnXt2QsdwGCgwa/AEyytMBGDXBKcRiufvUJC85B3ctbL4hqpf71X51kGfvO/EmJWCO4U2A56J+aIKnbjxAcVgSkoaibkDKxeY6pwcrpiYLEeD5+qXXNkfabrt2MZMRkhVDKAPgq+/su8PUlzmvDTmLavY/eYpBuYu8syks4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998276; c=relaxed/simple;
	bh=ruqyp1lgXUo0fJrZ8bntElC5bqwSl77q4nNBmXR4Xyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gP9B8kxISXHP3L6mPQWmgbmK0b2wKXZkZS5wpoacMKIO9kqh9p1jKIPghbVVz3b6Qb6q7ogBwljuzRw1u7B0zRDsQa0WAdCd7qkSJBsYWAdPrTP7pAeVwEwHDdAy4vDBB3KIwLV5REbbheCa7TeyvtSFg7FxXcYNNSq79W2/+Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kH6CVXB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kH6CVXB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF150C4CEEF;
	Wed,  4 Jun 2025 00:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998276;
	bh=ruqyp1lgXUo0fJrZ8bntElC5bqwSl77q4nNBmXR4Xyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kH6CVXB7iwlkUa6KCN5DF78aZdii5u4c+sOEJRA6SJ3v11EGrHaD1Rq6Sh6f/ioB6
	 rIp9/LJuoRsOdZTMJOuE2ewWxnLAUMPENoL3E4hQM/92Nr2KEmAtNk1zVOzRi5Srj9
	 e+54NfoEy1ja4tg3boqMDyMM7GI1zeXo1rO5L6+ZqZhnGSvIXoW89OgnF09t/eG4wN
	 45jkaa9zLhyT9l/cJTx+631yaVDB4O/fi0LA9ii9A4glWKZJsqpIBBPEINuG1VE9Bj
	 sKHlq7M5bVE2cjkV6eKqnM0bv11AsJnHMP829TIaN8fnQIU/XqA5BGM+M3nWfJ90Sc
	 nSZ/ImVSZs4pw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: sunliming <sunliming@kylinos.cn>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	lorenzo@kernel.org,
	shayne.chen@mediatek.com,
	chui-hao.chiu@mediatek.com,
	Bo.Jiao@mediatek.com,
	qasdev00@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.15 015/118] wifi: mt76: mt7996: fix uninitialized symbol warning
Date: Tue,  3 Jun 2025 20:49:06 -0400
Message-Id: <20250604005049.4147522-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: sunliming <sunliming@kylinos.cn>

[ Upstream commit 187de25110c8ac8d52e24f8c596ebdcbcd55bbbf ]

Fix below smatch warnings:
drivers/net/wireless/mediatek/mt76/mt7996/main.c:952 mt7996_mac_sta_add_links()
error: uninitialized symbol 'err'.
drivers/net/wireless/mediatek/mt76/mt7996/main.c:1133 mt7996_set_rts_threshold()
error: uninitialized symbol 'ret'.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202504101051.1ya4Z4va-lkp@intel.com/
Signed-off-by: sunliming <sunliming@kylinos.cn>
Link: https://patch.msgid.link/20250419031528.2073892-1-sunliming@linux.dev
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

This repository appears to be much older or a different branch. Let me
analyze the commit based on the code changes alone: **Analysis of the
commit:** ## YES **Extensive explanation:** This commit should be
backported to stable kernel trees for the following reasons: ### 1.
**Bug Type: Uninitialized Variable Bug** The commit fixes uninitialized
variable warnings detected by static analysis tools (smatch). Looking at
the changes: - In `mt7996_mac_sta_add_links()`: The variable `err` was
declared but not initialized (`int err;`) and changed to `int err = 0;`
- In `mt7996_set_rts_threshold()`: The variable `ret` was declared but
not initialized (`int i, ret;`) and changed to `int i, ret = 0;` ### 2.
**Consistent with Similar Backported Commits** This fix is very similar
to the reference commits that were marked as "Backport Status: YES": -
**Similar Commit #1**: Fixed uninitialized variable `msta` in mt7915
driver - marked YES for backport - **Similar Commit #3**: Fixed
uninitialized variable `ret` in ath12k driver - marked YES for backport
- **Similar Commit #4**: Fixed uninitialized variable `msta` in mt7921
driver - marked YES for backport All these commits follow the same
pattern: initializing variables to prevent potential undefined behavior.
### 3. **Analysis of Code Paths** Looking at the specific functions:
**mt7996_mac_sta_add_links():** - The `err` variable could potentially
be returned uninitialized if the `for_each_set_bit` loop doesn't execute
any iterations (if `new_links` is 0) - While this might be rare in
practice, returning an uninitialized value could lead to unpredictable
behavior **mt7996_set_rts_threshold():** - The `ret` variable could be
returned uninitialized if `hw->wiphy->n_radio` is 0, causing the for
loop to not execute - Again, this creates undefined behavior where the
function might return garbage values ### 4. **Stable Tree Criteria
Compliance** This commit meets the stable tree criteria: - **Important
bugfix**: Yes - fixes potential undefined behavior - **Small and
contained**: Yes - only two simple variable initializations - **No
architectural changes**: Yes - minimal change that doesn't affect design
- **Low regression risk**: Yes - initialization to 0 is safe and
expected - **Clear side effects**: No side effects beyond fixing the bug
### 5. **Driver Context** The mt7996 driver is for MediaTek Wi-Fi 7
devices, which are actively used hardware. Uninitialized variable bugs
in wireless drivers can potentially cause: - Random return values
leading to unpredictable error handling - Possible crashes or unexpected
behavior in error paths - Static analysis tool warnings that indicate
potential runtime issues ### 6. **Static Analysis Detection** The fact
that this was caught by automated static analysis tools (smatch) and
reported by the kernel test robot indicates this is a legitimate concern
that should be addressed in stable kernels. The fix is identical in
nature to multiple other WiFi driver commits that have been successfully
backported, demonstrating this is a well-established pattern for stable
tree inclusion.

 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 91c64e3a0860f..ba8cfca842d0f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -987,7 +987,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	unsigned int link_id;
-	int err;
+	int err = 0;
 
 	for_each_set_bit(link_id, &new_links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct ieee80211_bss_conf *link_conf;
@@ -1244,7 +1244,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 static int mt7996_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
-	int i, ret;
+	int i, ret = 0;
 
 	mutex_lock(&dev->mt76.mutex);
 
-- 
2.39.5

