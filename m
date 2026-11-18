Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024122;
	b=06PD73VCb4irkci29OQxfDVrfvLpOog7mx37/juv5NO+WhNoRGRVmoUhS69PxJE3Yu7c
	 3/aFQFsUWelRK2FmJgoPx+2/fije7/Vc+G0lKayIG2MuFSFbcAuHBz/kAKzwdBprjNA+f
	 oRvR6iuCA+EejyrYkj86LxZK9KInrp6BLdKzo653E4Hi6dj9YNmUb1gybdLfXH6WqCfxD
	 +zwUUitTOhJ5I/17l3AbLd0Ccm289mDHI41zMwYvUWC2zwt/pAzX4GUymC+5f+qSMGEe6
	 lDHsnDb6uH/00O6GmFd/HinGFu98t/B/a4Ik8Zkle6HyeOdM7DBbj3UWjzL3izJVFeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gWZFR+IOUd+GfCGL60sMJrT7ONwcMAFI1sVhlBvfC9U=;
	b=sEpFm2yaMqQUOFleN/5GzV7UeELzKUvlXvSU3VKY4ZZZCLMP1o+rsNAnDTl78k/HS3g/
	 XB/tbJZbRK12/mR/vvc6GGf5Eey9gorsdnp2gKF7er8omR62J09k5FGe1ep6PBSxuKO6n
	 JK/R1nyYxVrFlKezahd1M5C2K6sYTQoOcUgTE6tOp5hZSMA1m6JGdIWqO2kA7lQdJrbgs
	 ylk9NLaFH5EPhH5CwQRqW5lvF81x/ZOwmQH2w0HiDstbChijXFAQ87SrpUTsI9DInvCrD
	 uUd+mjQ+51nTPKo/nq4im3QEo18VV52thn/aWzuDUS45Rc11tsypUuh8qakqVi41Avg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWa9VFkG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE8E606A31C;
	Wed, 18 Nov 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWa9VFkG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBF61F000C4;
	Wed, 18 Nov 2026 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024122;
	bh=gWZFR+IOUd+GfCGL60sMJrT7ONwcMAFI1sVhlBvfC9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWa9VFkGizA+67e5uDPiRHa3+AK3BZhJT0AXPz2QZ/CDdk8nzi02EXoy4OiZbswwe
	 8MY5XJuHlK1RnCnzMU8RTceIXZ1OsTOAZ7n9Ih4M9avCpjJztM0EIBJQE6QM0alj1S
	 M/gCqJxN4UCrN8Ci1s4WPsjNghxjFzoOdj6EMsEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kim Wooseok <5mghybrid@khu.ac.kr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0614/2151] wifi: rtl8xxxu: free RX skb when URB submission fails
Date: Wed, 18 Nov 2026 15:39:09 +0100
Message-ID: <20261118150144.289082608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Kim Wooseok <5mghybrid@khu.ac.kr>

[ Upstream commit 9f7edf4e8584c87e3c478c6dd87c08d51b5157c2 ]

When usb_submit_urb() fails, rtl8xxxu_submit_rx_urb() unanchors the URB
but leaves the newly allocated skb in urb.context. For ENOMEM/EAGAIN,
the RX worker puts the request back on the pending list. The next
submission allocates another skb and overwrites that pointer, leaking
the previous buffer. Stopping before the retry also leaks it, because
pending-list cleanup frees only the URB.

Free the skb and clear urb.context in rtl8xxxu_submit_rx_urb() when
submission fails. This keeps buffer allocation and failure cleanup in
the same function, so a request returned for retry or teardown no longer
owns an skb. Remove the corresponding cleanup from start and the RX
worker; they only need to decide whether to retry or free the URB.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Assisted-by: GPT-6 Astra
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260921-codex-rtl-rx-v3-submit-v4-1-eeb09fe8f791@khu.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index f8bd9bfe74ba3..0f3f10dbfc541 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -5912,7 +5912,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
 	struct list_head local;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret;
 
@@ -5944,8 +5943,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 		default:
 			dev_warn(&priv->udev->dev,
 				 "failed to requeue urb with error %i\n", ret);
-			skb = (struct sk_buff *)rx_urb->urb.context;
-			dev_kfree_skb(skb);
 			usb_free_urb(&rx_urb->urb);
 		}
 	}
@@ -6640,8 +6637,11 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 			  skb_size, rtl8xxxu_rx_complete, skb);
 	usb_anchor_urb(&rx_urb->urb, &priv->rx_anchor);
 	ret = usb_submit_urb(&rx_urb->urb, GFP_ATOMIC);
-	if (ret)
+	if (ret) {
 		usb_unanchor_urb(&rx_urb->urb);
+		dev_kfree_skb(skb);
+		rx_urb->urb.context = NULL;
+	}
 	return ret;
 }
 
@@ -7454,7 +7454,6 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;
 
@@ -7505,13 +7504,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		rx_urb->hw = hw;
 
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		if (ret) {
-			if (ret != -ENOMEM) {
-				skb = (struct sk_buff *)rx_urb->urb.context;
-				dev_kfree_skb(skb);
-			}
+		if (ret)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
-		}
 	}
 
 	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
-- 
2.53.0



