Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3CE3B19BA;
	Sat, 17 Oct 2026 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258989; cv=none; b=iRKoUJxnYlA9cAT8HbCR6WZQMEHHAMofnWM8BtyNKkiNAwQerEzbC5m08BgI1h4llr7EKxY+TK6EHEzz2z2wYeuGwKZv6CYgOjOy27oyXWwkXARK4Xz4pTxF4oPRYiI3p01Nhs8TleR02i+jyalvnxqlFjeEovacSsLLcFQ43u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258989; c=relaxed/simple;
	bh=KVf7hshaEPfxi+JK2qTbdanj51vDpc/v135+K2Eb8e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceyeFYSUfu8UYhcM2/5cmfG503xb4my7PkXSSS4+/qMv5uROjOZLunqrbZAzyWFMr7ld2mJz/xCc7U2jWxxdFhm8SeyocgS7MM8t+2oHH8rtMqpXusPOR1mZsj8kWP8BMcSeg/eW0HtXqPmlbcR/DqTyG82T/CqrWhedngqxZpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=th28vO3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="th28vO3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35141F000C4;
	Sat, 17 Oct 2026 17:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258988;
	bh=orZ02NSRIXlVeglDSaamy9miZkaJ/cbEQd1+JzHdyP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=th28vO3mKRjXfhadETIH0TNSw17vWvMgwpBtTJJVRfUqfIzHNoenTKNUxtQ44cpoS
	 efVW6EpdFKvSq8Zd2ivXdulVS4PmmHjmlLgG9lmAoLXOtI8K2pBcNdF/8PjpViXx+m
	 7KpeOlkr3gI+nXN9nlhmUcZV4k96Ga80BtqjGeB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meir Elisha <meir6264@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1014/1674] Staging: rtl8723bs: Remove dead code from _rtw_free_network()
Date: Sat, 17 Oct 2026 17:54:46 +0200
Message-ID: <20261017160457.161563949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meir Elisha <meir6264@gmail.com>

[ Upstream commit 6fd529666b9cca0e825479da7bddae4b1ab67eb4 ]

Clean dead code from is_same_network() and _rtw_free_network().

Signed-off-by: Meir Elisha <meir6264@gmail.com>
Link: https://lore.kernel.org/r/20240229121445.22257-1-meir6264@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 514ab9836459 ("staging: rtl8723bs: fix buffer over-read in rtw_update_protection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 5ee859ecd6d2b..b5fb0ad08f384 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -169,7 +169,6 @@ void _rtw_free_network(struct	mlme_priv *pmlmepriv, struct wlan_network *pnetwor
 {
 	unsigned int delta_time;
 	u32 lifetime = SCANQUEUE_LIFETIME;
-/* 	_irqL irqL; */
 	struct __queue *free_queue = &(pmlmepriv->free_bss_pool);
 
 	if (!pnetwork)
@@ -389,7 +388,6 @@ int is_same_network(struct wlan_bssid_ex *src, struct wlan_bssid_ex *dst, u8 fea
 	d_cap = le16_to_cpu(tmpd);
 
 	return (src->ssid.ssid_length == dst->ssid.ssid_length) &&
-		/* 	(src->configuration.ds_config == dst->configuration.ds_config) && */
 			((!memcmp(src->mac_address, dst->mac_address, ETH_ALEN))) &&
 			((!memcmp(src->ssid.ssid, dst->ssid.ssid, src->ssid.ssid_length))) &&
 			((s_cap & WLAN_CAPABILITY_IBSS) ==
-- 
2.53.0



