Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216532;
	b=AdW2RZVX13mWZV221R86IK+YFiIEaZ74LEOX//k351FdNTao9cV+eQ4G0XIXULr+IExU
	 UUh8bwpKJydnB18aGpebuvKR7WLMCTQJIle4+BXXkbfVkY3j2vTJFMv3PKsZVl4Vlhad0
	 5vxFR7xz1/OB5StuAbJ8nBY+ny4qXEfiimOLmJXwapFcXMRK9HUaGLYPvJYnrUfAywUEn
	 M0vE3s5v5kfLJweUigd1bvHEWMhFAoT2q3ERDsc/5X5x4u/ugRZCC5biKRYRckJlzhQxT
	 mR2G+0Y0Saq30jR5SXpSZ1WZVcpexvUCgJm+i/OGfqpRV83V/CbbPJq2dCjWg2UiqRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZxBt8Kip0L5LmMxqhnTtH4Uwf1WgKwq0qBXpTJpdprA=;
	b=3A7yMUO6pm/RYKL8vUulolDCOc53pdVXRAidRm8ziwcIBdZ6iarp9hHQFrC5ohbH/u+V
	 shVO4me3EurpgORU9g6Z2OkKqIYW0LkhsUC6S2Yx9ZCGtSVPpyP8nkmkahgC9fIKXS9xD
	 Y3j8LL/G9/MZlfSUbxnlzyEo1e+0cQmDpr3/ZCKEj/dI9KTLBm+vQg3OnvNT+t1ttsyBV
	 VGZCmwipaeS5JO+xQ69LCjXhxpH1fBDvHPbP+PQexVHSiZKdTmEsqCmroakY3BlqiIeZG
	 Et0B0WdOS2erDzE4xIwawUr0B2Hqyh/5Jf0CjOK2UJer/8cP/48Xl4XBdrHs9+2g0gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPby9tTL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E6E606A324;
	Wed, 28 Oct 2026 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPby9tTL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236C91F01828;
	Wed, 28 Oct 2026 19:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216531;
	bh=ZxBt8Kip0L5LmMxqhnTtH4Uwf1WgKwq0qBXpTJpdprA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPby9tTLYfxd0NKqtLHuf9NGiCJ/i/GiC6CkujFCW6l8qdN1xqlJi1gVWtwk0l5so
	 g3y8kjTe9xLp/iGe7c4F5IBHJG8pneHfAxZJHKEyFBoHxZaJd5gdK7el2YVYCTdIiD
	 G0jiYF6sZCsRtcqeITGPgJcrK29Gh95n8tjc/bWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Huang <jason.huang2@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1588/1887] wifi: brcmfmac: fix P2P action frame handling without device vif
Date: Wed, 28 Oct 2026 18:01:24 +0100
Message-ID: <20261028170535.606673493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Huang <jason.huang2@infineon.com>

[ Upstream commit 1b1edb9ebed49099bdc924cef49a9aea8b552199 ]

Some P2P action frame paths assume the P2P device vif is always
available. That is not true when userspace sends non-P2P public action
frames through the primary interface, or when action-frame abort runs
after the P2P device vif has not been created.

Fall back to the primary vif when aborting an action frame without a P2P
device vif, and guard P2P device saved IE access before using it for
peer channel search.

Fixes: 30fb1b272909 ("brcmfmac: use actframe_abort to cancel ongoing action frame")
Fixes: 6eda4e2c5425 ("brcmfmac: Add tx p2p off-channel support.")
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260722082608.412472-1-Jason.Huang2@infineon.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index ac6b70ff15355..b3aeaf8a476aa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1281,6 +1281,9 @@ static s32 brcmf_p2p_abort_action_frame(struct brcmf_cfg80211_info *cfg)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	if (!vif)
+		vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
+
 	err = brcmf_fil_bsscfg_data_set(vif->ifp, "actframe_abort", &int_val,
 					sizeof(s32));
 	if (err)
@@ -1817,6 +1820,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_if *ifp,
 	/* validate channel and p2p ies */
 	if (config_af_params.search_channel &&
 	    IS_P2P_SOCIAL_CHANNEL(le32_to_cpu(af_params->channel)) &&
+	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif &&
 	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->saved_ie.probe_req_ie_len) {
 		afx_hdl = &p2p->afx_hdl;
 		afx_hdl->peer_listen_chan = le32_to_cpu(af_params->channel);
-- 
2.53.0



