Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E1225EF8E;
	Wed, 23 Apr 2025 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421792; cv=none; b=mEW/dTZRJUN8fGa8xg4CxZkYJI0AYHfgwDx9DmK8mdOuGyYC5qlV5Oq15fSEVGU7W3hfuGBsiLHSBFYERNmFysVccIy/fDjcnVG/29dK7j8IRSShPNsObJSVkemqnrl4AUR57Z7SSB2U9RZmAVxl85k6FMyT5faPcl1y+UdAeSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421792; c=relaxed/simple;
	bh=b9XPAjsijW72XKXTWqSMAbz0xSgcMZEt0DdhqB/MrxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvCN+laBpGemqOgmI1Pdnfjox/Z07ygyb7FwhWtlE9CDGCxpfh+5SrgbjvunbVPpB1vzgROftnGBhhpovBV7SQH9N05BDZiH5yjzicMkd/EQKrApv//3VkyDnWXmH87LnrDpaSfTpWMsFgcamAXGvXtEeZDdV3fG/SMbwGo7It0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4A+zxoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4A+zxoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C98C4CEE2;
	Wed, 23 Apr 2025 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421791;
	bh=b9XPAjsijW72XKXTWqSMAbz0xSgcMZEt0DdhqB/MrxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4A+zxoQZupjRwC/oO6YZDLx0j+P71pImEKgfCYVnUaG2s+PExiuhIUP8ubn85yss
	 tNrUwK41lB0UqgYEfTgfWzS/WKsFtGjCzy3k0To5C7820jmSP7fFLNcI+VVdDaibek
	 9EWqLilq1ZvJVitMprpv2Aw2Rr2pKD9cqXXHOIKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/291] Revert "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Wed, 23 Apr 2025 16:42:48 +0200
Message-ID: <20250423142631.696346090@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0937cb5f345c79d702b4d0d744e2a2529b551cb2 ]

This reverts commit a104042e2bf6528199adb6ca901efe7b60c2c27f.

Since the original bug seems to have been around for years,
but a new issue was report with the fix, revert the fix for
now. We have a couple of weeks to figure it out for this
release, if needed.

Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/linux-wireless/20250410215527.3001-1-spasswolf@web.de
Fixes: a104042e2bf6 ("wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7c1e81e15865c..62b2817df2ba9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3800,7 +3800,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
-	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



