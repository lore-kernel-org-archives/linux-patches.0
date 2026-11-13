Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591520;
	b=OdIDw4eGNaPS0KFxQYiXlTvZZEghmo4ahrxKf9i7vZvraO+52bT6unhZZ2eAcfD+qLgz
	 ivKK0/19xn+hBgaLNQhR5A7xg0hC2t0xVXzboLwV2btF2xGygApnC0TpkjmU7BhJ5+rNH
	 Y/yDeO505DSilJriwNoTinvHTCD0+sCeXA7SD1n4yt1ilGq0kvHnEZMXVc7ybbh1j1hD3
	 Zngeoez1oqivRU1iY5/XkSmUXLZCw0zIKi032ukoy66QvBAeiTzCAZ+8zh2vutnvxLRkM
	 9eS1lc6P578kUk4lK7BDyJhCYc1uBd6ftjKvMbT/Z5EVIgpSldJNX2J/4EcFxVfrIKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5PVZEqGYp/u7kCAoWzoiIIeW5GQcTM1tJorjyhbI8Q0=;
	b=LJgh1dKqZZt8qy3Mc29i/z/PAWzkJYSNESzY1Ho/zu/aOx/JJH94ZfcZbSlIEIpFgRXu
	 gCWoar70k/lb93/tYPGpQMBiM1g7gctU4yUrIZGjzDprQu96Ug2IuJPl0xhyHWn6nvcEj
	 BPPVzPcl4irw3xlN/a+mRcOYgemGnsWumVNsKvRujiHzGm82xJfMFx+q/OQPadpxsB9aZ
	 48nfcLiW442D1rbmHTQ0ULcXX6sEPKBwldgDVDs4fAz0FqfJlP1OhLo8JBKLCPdxtETCS
	 Thzik+HN8LCL6T6zPlTNSNu/LfkMqz/xyPHBxTFPZWqPYq/JxXD1ehjtQLRZVMbNZlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msysu7Cp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DF4606A899;
	Fri, 13 Nov 2026 17:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msysu7Cp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D771F000C4;
	Fri, 13 Nov 2026 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591520;
	bh=5PVZEqGYp/u7kCAoWzoiIIeW5GQcTM1tJorjyhbI8Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msysu7Cpeq6Wt6qM7f1nMn7LDfsMJgGLbfJDG4Tip9cyDsUjXA7adBzcVRz6YG87J
	 zFbonMXIbPS5IF0MaiDaKoBIiO6DPz+mCDwiBfPjaH9Qy0dgcFG7QXWUR07FYndYrF
	 7qBsOqbCVxeeD/z27ZRZRpnrAe+PHrKmdeSDC4l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 562/670] wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload
Date: Fri, 13 Nov 2026 10:52:06 -0500
Message-ID: <20261113153830.925739652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Inlined the PSK/SAE authorization check because the baseline lacks upstream roaming and PMKID authorization support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index c3a3a08179109..a2a0cc43bc721 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6424,6 +6424,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct cfg80211_connect_resp_params conn_params;
+	bool authorized;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -6448,7 +6449,13 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		conn_params.req_ie_len = conn_info->req_ie_len;
 		conn_params.resp_ie = conn_info->resp_ie;
 		conn_params.resp_ie_len = conn_info->resp_ie_len;
+		authorized = completed &&
+			     (profile->use_fwsup == BRCMF_PROFILE_FWSUP_SAE ||
+			      profile->use_fwsup == BRCMF_PROFILE_FWSUP_PSK);
 		cfg80211_connect_done(ndev, &conn_params, GFP_KERNEL);
+		if (authorized)
+			cfg80211_port_authorized(ndev, profile->bssid, NULL, 0,
+						 GFP_KERNEL);
 		brcmf_dbg(CONN, "Report connect result - connection %s\n",
 			  completed ? "succeeded" : "failed");
 	}
-- 
2.53.0



