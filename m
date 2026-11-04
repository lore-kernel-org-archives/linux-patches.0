Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829508;
	b=GJYUBeD09c7UyIQ3LJ1Bmd+iTeVUzj9vf9xDVsIiokPczj7KVx2pedB8gGetwMitEcx8
	 05X9Cca8V4sd47fXdpXok3ZrLM8C6snhzKFKcHxFRe0dYIanVrVxjNZSrBkO7P9O8++Ew
	 mUIis/6pvJTmeZbapN7oImEKOeA7GOZOkgsVvA1QzDC8Gxpr3IqI8O1kWU+QBqFqxyNgN
	 0q0JnhmWP+T7lFKIrlHoloUh+CysR1uvbB+V8Kw6LpVbC8V9533jB1loVHaGLnaxzXG0R
	 SzfFqavQRGCAWvX5nT71LzyCYitBOELNoV2iDU+IjOi+aRGOH0KZD1zulObiKC9hyFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLPYeR1LXow4irpeBPv8LxWxyFtecQ/4purGEYWPCL4=;
	b=SXvL7473B2vZUNHFRsBPXvCKOrvfd6lR/gj7HAzbC5G1DnHumK7QRzaIvIUCG8gDp6dm
	 32HuY0s2dzaxoBjYX48W5O+7BB+15N0/b5PwzLFjzb/vTAUV6gTEIio2eTeC+80z8AYqi
	 fC0cKPsbX51oIcDb86MS1OlGuzUVmMGxCzilKldVAbQaVXYxbLQmeUxmIc25b2pS/G7WC
	 mMZ9fLRNpEn8Fajd6Ef4XjlS342i1m68WL4haeNWpNjaGLbCbFAfxcQr8bonQZHLtgQp2
	 7JVuCbEPf8aZ2LohUalxfNnY5LhAG2OLcnzp5dG4BrcVvo+StMUcnm4dZrFAwwigHnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aRSU2cQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F72606A87C;
	Wed,  4 Nov 2026 21:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aRSU2cQ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CE01F000C1;
	Wed,  4 Nov 2026 21:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829507;
	bh=eLPYeR1LXow4irpeBPv8LxWxyFtecQ/4purGEYWPCL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRSU2cQ9iX1whwvc3FZcCjvHY6tlkChDWf2Ub/AfPu84WfpP7XRfFGCPjh6bihzDQ
	 ZTSswPos6xKR6CNKtTcY7xQ5G0iEuArnXvXdedx/wgBq2jyZ+7+UWkX2q/zY+4PELh
	 5OotJqj4WeGopmKFbdLcAYLW7qF8kDMisvDSzjec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0168/1005] wifi: iwlwifi: mld: Do not cleanup FW state when the device is dead
Date: Wed,  4 Nov 2026 15:58:21 -0500
Message-ID: <20261104211048.474305255@linuxfoundation.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 1c031ac5a39ebcc3269eace8b606043adc398bfa ]

When a channel context is unassigned, there is a path to cleanup the FW
state in case of NON MLO connection: remove the link and add it again.
However, when the transport is dead, e.g., during device removal etc.,
this flow will fail and as a result the mld_vif->link[0] would be set to
NULL. Later, when the interface is removed, iwl_mld_remove_link() would
warn as the link is NULL.

Fix this by not doing the cleanup when the device is dead.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.89a0c44a72a3.I45cca8b84a25943d5771199af6b0155dbac77b58@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 5234229a070a7..4ea2d45d71e4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1113,11 +1113,13 @@ void iwl_mld_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	RCU_INIT_POINTER(mld_link->chan_ctx, NULL);
 
 	/* in the non-MLO case, remove/re-add the link to clean up FW state.
-	 * In MLO, it'll be done in drv_change_vif_link
+	 * In MLO, it'll be done in drv_change_vif_link.
+	 * Do not do so during restart or in case the device is dead.
 	 */
 	if (!ieee80211_vif_is_mld(vif) && !mld_vif->ap_sta &&
 	    !WARN_ON_ONCE(vif->cfg.assoc) &&
-	    vif->type != NL80211_IFTYPE_AP && !mld->fw_status.in_hw_restart) {
+	    vif->type != NL80211_IFTYPE_AP && !mld->fw_status.in_hw_restart &&
+	    !iwl_trans_is_dead(mld->trans)) {
 		iwl_mld_remove_link(mld, link);
 		iwl_mld_add_link(mld, link);
 	}
-- 
2.53.0



