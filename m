Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829495;
	b=D0APoY3fthC3i8iSUs68h1uomenygBXlKHYuzzd005AbQ6ShaZs4KJtBsVM+xBtCQ6Ae
	 Ik/c4udpyiCRsgXg/1HoxOzm9WNEK1Ql1IeslD0OwfqhEzU262KVnrGE5fY5JkRY2ulbd
	 O3dzUQtf3pQw0+0hqdT06OXXBc4PSD5VnXiFXZ8IIcQ/FizC73XnNm8Lhp3EE8MZGTnTI
	 SNI+/jD/dbyI5+6Xi1Nkp298v4Xj2OX8FnFfr1FuVT32SkjU5HAnOUgFAmF+p5ZUe5hhk
	 jTq0SZE3Qrt9XuNF9KKjRRMY7hxIpVVtmfIiODqugPN3g8Q6Lx85wRdl+fIPwBFgHeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y70+ANB2nNlQfhVuBqCSvoG4rbCMN8KGWfxQMBvJeAM=;
	b=YIUI/A7bs0QxBL+xVND0eHuumvkCFueyoiF+hkGzFPrFP1FqBXBDXc+qc+/ozwXeEmEj
	 WwVNRH/hBK3fVqP0W/XKcxP6Yo329qXOnmnixtZwG1QgnGyaFpEB03JJxls7PLS9OC2eC
	 VBr9+NbhIcmQk5xOkzID40UllzSfe2/GBom89bZSh9wZ8FpdXVEUuA25qpafIy1A8tWuh
	 u+qTqXsL/CGiJoJDe2sY6KwMpCjz0ip30mugfGTI3qkf+79Kd2592qiSaPKstu1HZLB3d
	 kTO7YkNhZDhYR874LVznkxXmTI0xdp2VxjcRKmSIBh5SBAgBn0XOKcAns1gi57VBQpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZGk+Cdy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98599606A844;
	Wed,  4 Nov 2026 21:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZGk+Cdy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393971F000C1;
	Wed,  4 Nov 2026 21:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829495;
	bh=Y70+ANB2nNlQfhVuBqCSvoG4rbCMN8KGWfxQMBvJeAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZGk+CdyVNJvIxKCxRYaollRHeUIDslL+QcKPvfxKQehOXJnEWA+wPNQx3iDMbGLX
	 ilrq9rhxO1diUnI7O8S1M/8BTe8/uqeNncs/hUuKOfND1RNgJeSbKWCIMMN36qGmy6
	 UOzYSCgztzMbf6U4oAsSiO1JLAKUUXdq1EMsZjwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0161/1005] wifi: iwlwifi: mld: reset the driver state upon firmware recovery
Date: Wed,  4 Nov 2026 15:58:14 -0500
Message-ID: <20261104211048.270588317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 71ac392d8b5c23c45c66f30eff1c319580ada4da ]

Just like we did in iwlmvm, we also need to clear the mld state when the
firmware was killed because of the device being powered off during
suspend.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714165826.ff1c9e05e0a9.I8df8d4a0384065fd2a32cf258339be77084c55bd@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 3 +--
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/mld/mld.c      | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 27ae06e208402..69a066904a808 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -483,8 +483,7 @@ iwl_mld_mac80211_tx(struct ieee80211_hw *hw,
 	iwl_mld_tx_skb(mld, skb, NULL);
 }
 
-static void
-iwl_mld_restart_cleanup(struct iwl_mld *mld)
+void iwl_mld_restart_cleanup(struct iwl_mld *mld)
 {
 	iwl_cleanup_mld(mld);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
index aad04d7b2617d..f3302997b28f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 #ifndef __iwl_mld_mac80211_h__
 #define __iwl_mld_mac80211_h__
@@ -9,5 +10,6 @@
 
 int iwl_mld_register_hw(struct iwl_mld *mld);
 void iwl_mld_recalc_multicast_filter(struct iwl_mld *mld);
+void iwl_mld_restart_cleanup(struct iwl_mld *mld);
 
 #endif /* __iwl_mld_mac80211_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 49e46babf8221..cf003a4a37408 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -739,6 +739,7 @@ static void iwl_mld_device_powered_off(struct iwl_op_mode *op_mode)
 
 	wiphy_lock(mld->wiphy);
 	iwl_mld_stop_fw(mld);
+	iwl_mld_restart_cleanup(mld);
 	mld->fw_status.in_d3 = false;
 	wiphy_unlock(mld->wiphy);
 }
-- 
2.53.0



