Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590016;
	b=kSapeq1rRt7MAVQCpBa5lb0T+HQIw2Q8I02Tg50pnN3AQFutfcOerPTNuq78A9rIsYwz
	 vHOjz2C8nr44opgoKo16mtmnULoGssrr1VjUuRb00Ztzossn87tLnUtrTeSgZbovj4QYb
	 awTJqX4TmASJSiRUeWdVi8K4kwa7swbjHjEDCU1U1i7hhjRGzc+kicTDeybDgdEFo/y1E
	 C9fStmSH4pm1DpddhPr9kO0XulADD6HxT70tbIDTDPeqsQibb82LKMhudKiPiIWOjXf0i
	 YSErIk2bbNeyr0/Tr/YGt+4lSaI/jsdQ2iHzVDD4FDa7XtyvLmFz0JUp+9rGRJl/IcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4gPDGsiXVJZSca+ru0NMZyofaq0U0XXU4/T8I8V0xWA=;
	b=c35k8pL0EBJuY7gPv2ocCZbYD4SOSc3YHqhre9k47srkuKMPjGRvm9c588Ba52mmKPTI
	 oycWyF8RwwvS//EmtzXDEkNlLB5DGP3qT97smFyhaN7pFKYvRMVhc9C2qFUNRR3pN0uYD
	 lYfSPuVnGuYpdRa15dvsx/YSuVsV86O/RmCniODkhC+k8oenCvQLTu1UsIWu2TICgpBoG
	 4Jb63tp5ygLiMZ46PPGGqpQ1L0iLMvtorJVTFiObN166tJ96lwspETE9YMgmTGYHc3Le0
	 2eTvW+9PPOEYAp09rDDsx5XzaNG4mscIKbQDlMFx88KN96TzDx1ltZ038QfJmmtN/xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fepuYyrh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802D3606A33F;
	Fri, 13 Nov 2026 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fepuYyrh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E7B1F000C4;
	Fri, 13 Nov 2026 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590016;
	bh=4gPDGsiXVJZSca+ru0NMZyofaq0U0XXU4/T8I8V0xWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fepuYyrhC1+Rz0/xBLs7W6tK6G54Ra7yEIyTehqNjJCU4tPWTm28ywX2Ss96CGFxI
	 wrX9FEROQ4LwTZjX1HgQgyx+4Dr1zs0oHZiWD++0Hm5akb2tBICizWWKaoIPjoh2e0
	 /FPjceCBkdypWFn5uWGqzGsVWEAhLKcL0dJP3KTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/686] wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload
Date: Fri, 13 Nov 2026 10:43:11 -0500
Message-ID: <20261113153822.910482500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

[ Upstream commit 6fff9de5c5b425817588eeed42bd56d665751c13 ]

Since commit 416386060 ("Mark authorization completed on driver
indication during 4-way HS offload") [0] wpa_supplicant expects
NL80211_CMD_PORT_AUTHORIZED to complete the authentication when the
driver supports 4-way handshake offload.
This was apparently never tested with the upstream brcmfmac driver as it
does not report this. This broke authentication on Apple silicon devices
(BRCM4378, BRMC4387, BRMC4388) and other devices when wpa_supplicant
2.11 was released [1]. This was initially dealt with by reverting the
commit in Fedora [2] and other Linux distributions.
Instead of carrying the revert over to wpa_supplicant 2.12 add the
expected NL80211_CMD_PORT_AUTHORIZED when the connection is established.

The "Fixes:" tag is not fully accurate as this has only became an issue
after userspace changes years after the change. Since the change is
expected to be required in all active stable branches for wpa_supplicant
2.11 / 2.12 compatibility it is helpful even though
BRCMF_PROFILE_FWSUP_SAE did not exists then.

Link: https://github.com/zephyrproject-rtos/hostap/commit/41638606054a09867fe3f9a2b5523aa4678cbfa5 [0]
Link: https://lists.infradead.org/pipermail/hostap/2024-August/042893.html [1]
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2302577 [2]
Link: https://lore.kernel.org/linux-wireless/20260911065656.1269623-5-Jason.Huang2@infineon.com/ [3]
Cc: stable@vger.kernel.org
Fixes: b8a64f0e96c2 ("brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260915-brcmfmac-4way-handshake-offload-authenticated-event-v2-1-fbb9cc7ac177@jannau.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 1fc9ecd86d5d9..1ca879ffb6021 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6481,6 +6481,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct cfg80211_connect_resp_params conn_params;
+	bool authorized;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -6505,7 +6506,13 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		conn_params.req_ie_len = conn_info->req_ie_len;
 		conn_params.resp_ie = conn_info->resp_ie;
 		conn_params.resp_ie_len = conn_info->resp_ie_len;
+		authorized = completed &&
+			     ((profile->use_fwsup == BRCMF_PROFILE_FWSUP_SAE) ||
+			      (profile->use_fwsup == BRCMF_PROFILE_FWSUP_PSK));
 		cfg80211_connect_done(ndev, &conn_params, GFP_KERNEL);
+		if (authorized)
+			cfg80211_port_authorized(ndev, profile->bssid, NULL, 0,
+						 GFP_KERNEL);
 		brcmf_dbg(CONN, "Report connect result - connection %s\n",
 			  completed ? "succeeded" : "failed");
 	}
-- 
2.53.0



