Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059634;
	b=AzxSeOTLpG/+Jk2wZc3TjhDIIzXtXrEZxP0Qr210p0Tzf9HYB0+IJPff345a0ngsD11M
	 z4Eb1Dh/iX/17UrynvGDxRfPhNQKaBLTYh4tCBRjd0KMSQ1HZ1EjahjbP9+TwOOMjLuVg
	 5jYBJ/R/nhiXicACGFH9DjDVHz4F8/hoWbSryc5Cpkb7zttCpmY8rAiiZ7Q34uhmJMmEu
	 yG1XwqijCZbpBYcpjSJJN2mUuWNU8qQkE2DsYAbxlDcAgQgAoYg5N8iaia/77fe+O+Fr0
	 h9i5df6Kpch1bMnnKfrtQMBJIsPZOQvhA8H9QsSWrs9hyfFY81VPx8tw8XjBpRvPm+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=roLvAKQFpPwj+6xarTylmvcF/eqTRP9nVqdZWneeX/A=;
	b=oBLUMn6pvr0hFLOVAg2m/WMcfTVO8qHEAXq7NCU8XW94l8AX0ZDf0ffoLPbz6OiJlOd0
	 oqtYibZXtt+oaJsVOwSY0jYkK/MjhCPdru8t4OsLK4j8m2KYUTsyKs8uhZHEUZ2P6KU4N
	 SKmwT/YANixWZ8SiwUTeR/q2GbFxqO6oM+HcUuD4xqOScNj179N+U+EZYHKXXqiZQHRqv
	 J/XkccD5hWGYhZHue6q3i2R1bJgfcBPMFQs5afoHiZpYXB6UJa+zm9r7Yf5aHfLM38f1Y
	 gzq6Y3HuVaoY99p7Bwm+EdtOFifgdswPQznvzcGkYRiccrV3W+LdcOfKHJqn+mVJazQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e5tTYy/F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A3A606A338;
	Thu, 19 Nov 2026 03:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5tTYy/F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EA11F000C5;
	Thu, 19 Nov 2026 03:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059633;
	bh=roLvAKQFpPwj+6xarTylmvcF/eqTRP9nVqdZWneeX/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5tTYy/FbypoK5VjAmws9RHax+otlTNorZ6UwDCKum+TMiFJCCYCgNnFGe7NV3Ide
	 HZyN4NP50EmXEj+X1OtaoTMzBsiY3TcxWIMTPdpArys3PyyWgUm+DtSxzeAbm5ps6t
	 PmYCAB4Y9anUzfqRo1w303oWAtIAa33ITRD00dHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0911/1848] wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload
Date: Wed, 18 Nov 2026 15:49:09 +0100
Message-ID: <20261118145955.001548515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted authorization handling to inline SAE/PSK checks with the older three-argument cfg80211_port_authorized() API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 3f6d4299965b2..361675045a67d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5973,6 +5973,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct cfg80211_connect_resp_params conn_params;
+	bool authorized;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -5993,7 +5994,12 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		conn_params.req_ie_len = conn_info->req_ie_len;
 		conn_params.resp_ie = conn_info->resp_ie;
 		conn_params.resp_ie_len = conn_info->resp_ie_len;
+		authorized = completed &&
+			     (profile->use_fwsup == BRCMF_PROFILE_FWSUP_SAE ||
+			      profile->use_fwsup == BRCMF_PROFILE_FWSUP_PSK);
 		cfg80211_connect_done(ndev, &conn_params, GFP_KERNEL);
+		if (authorized)
+			cfg80211_port_authorized(ndev, profile->bssid, GFP_KERNEL);
 		brcmf_dbg(CONN, "Report connect result - connection %s\n",
 			  completed ? "succeeded" : "failed");
 	}
-- 
2.53.0



