Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046985;
	b=OIy7xnejlL90ndMERX9YwlOWSub2LwHFy3SLS3IJD6Xq96BN73VhFflkzvSnxdUjKbqf
	 krmyfiQq0jXKcHt6GuIBVD6wgPz6fyiL2w+JLvovUDypDPsUjsdLsB5ou2uuoSUJOXQRm
	 N7Qh6HSoMdDFsXGFszjROwlSLkSXit2TOipgWWwsF/JJ1HfkgIjBTEsTVrAJRbLt6/AZW
	 GaQ0lv9wQQxaX+FLRd5z5j5KXjPdcbB/qk5Du1ANrixdsDypqxBSSaVRVartJd1oIt6V9
	 /aKqNOcW7cwPpOudrjVhSrShoC1nyJca4vHx1VCrrG5XifPy27DJJLQDvBtrlNO0sbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6xwKJtk1yXn9TbRme+cLZ7hCSswhjyX3iaVw5Hdz0s4=;
	b=MmIKrTbKb5cXzl2/fupRFwJx9qfr30QXBCshvgn5durvKT4c5pwzlkSuoAKkgTA4ESIr
	 tev8Q4vrjYNF3Tq4Mu+mOP6uyu5BQpVXoNMO62MPuIPcRGL1+28QdXOTbrFHPns1g/+TS
	 5bSefhArL1OMy3lATaCJfh11pDf9w6sCBjYBa1eBt8qMSdhn/c4EQRNYDS3R5EGVpIwDf
	 SWCB3REJWzn1fUVAhtUtlNI5TZ0px7EKrO0z7fi1fmTUDnFYITvhn46owP66k4r8GAviv
	 c5xqKzhsDzm4H2VjEDBj9Sd26bhol5iN2h7ECFPz6zX8jX9wjNgrJiuFXKDnxR8g00A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ae4q9rvZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849A4606A325;
	Thu, 19 Nov 2026 00:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ae4q9rvZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17191F000C4;
	Thu, 19 Nov 2026 00:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046985;
	bh=6xwKJtk1yXn9TbRme+cLZ7hCSswhjyX3iaVw5Hdz0s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ae4q9rvZNfTPDmXofKLYWLdZqVHCdSUczzgL+gy/5/AGm6XSScHZ/M4HnKJlaWwRr
	 lqvtHaF69lrzYnoZTyHN2RqaXMzBCPIlDAweNFTec7bs48NErmtdNYHvzuoWBNOrGI
	 ZB4ktmC5NCRs0bX5BQ0Dc/N73AcJus44xq+Y3f9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1478/2857] wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload
Date: Wed, 18 Nov 2026 15:41:52 +0100
Message-ID: <20261118150254.530145620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
[ sashal: inlined SAE/PSK authorization checks because the existing PMKID-based authorization logic is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 66c139bf49283..e985297919936 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6027,6 +6027,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct cfg80211_connect_resp_params conn_params;
+	bool authorized;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -6047,7 +6048,13 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
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



