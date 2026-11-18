Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055335;
	b=UCSbs+sVgUm3j3yo4jtjAkN1q/vJD4uomgVJeYlhFZWkF+LwFUi2XW4nt9TTTyx+uthR
	 bOz8bOTZ0d7kESJVcfNe0MepAIKx0zGJ4PByh0gorFT65CzrVhxdhOJTuLnPNb7s9ode+
	 Lx6TfV6AePVgFlpbSUs8XFUGvENeBFAsNFQlzClpasfltK9JEqvmRlrnjX8mTUyGU2DIo
	 qtraT+skfpDBSfWlUIg02b/aH8w5UzTUcIRknptOsqgId4yrF4iBd9x0KIGXmcm8+pHi2
	 fNDGdFekoxcnaMhLR+0ilK/ULV2LfnEBsc5bCl1vy8Ye0gZbK5z+ouYdUT3UI+KcMfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+KnvufZDkZRu/N7xHRqPT2q/NGlIaef5EJ0w0v4LWs=;
	b=tIvOB4WzDD4uAaWtt0PqKefOWLffbGEZcxtvwHMuCQ+GOGbtiEVy/Qen5JDxcoxKVvHy
	 XFGZ69yykgBBZxxLH7HPJD/KiU7tXuNfn4pc3XH+vjI/9r2b1OzQPULdljmyht380YUaj
	 JeojI59x+M0jPQzblBjQ+o/Perv67EpBGLHFG62LfuBEG0Gt/1zjtF076pIT+kDHbXILO
	 G+w1CkoWcEydOn1lC1t6/3H6s/F5aJBZsyNK/23nhbMxiz37KMbaQvo7FtbE//0m5C4Kk
	 709LF6/Af/Emrjzqb/biK1n8pJfXcZtadK8uMAp94SKB6mKPAALB0GwcSbcTesD9Azg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AYUo+r87;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773C8606A332;
	Thu, 19 Nov 2026 02:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AYUo+r87
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAC81F000C4;
	Thu, 19 Nov 2026 02:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055335;
	bh=c+KnvufZDkZRu/N7xHRqPT2q/NGlIaef5EJ0w0v4LWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYUo+r87oy+v6T5FzZ77t4eM48ZnQ+tSu+cwdv01EWk1nSW3r4oiiDlBo8o/RuPXD
	 dPFqPJDyIEU42mNnEdUgwzHHZlZiRxLhmEtc7lgu5Wphjlb3USwSABiaJxexj9WyBP
	 jOUllmHHnO6oRdj4XIyA0ozhhojhsgAcrvGVyq88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kim Wooseok <5mghybrid@khu.ac.kr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1554/2214] wifi: rtl8xxxu: free RX skb when URB submission fails
Date: Wed, 18 Nov 2026 15:53:50 +0100
Message-ID: <20261118150114.269520600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index d95ac983177af..841b3d7dd6a7b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5199,7 +5199,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
 	struct list_head local;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret;
 
@@ -5231,8 +5230,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 		default:
 			dev_warn(&priv->udev->dev,
 				 "failed to requeue urb with error %i\n", ret);
-			skb = (struct sk_buff *)rx_urb->urb.context;
-			dev_kfree_skb(skb);
 			usb_free_urb(&rx_urb->urb);
 		}
 	}
@@ -5811,8 +5808,11 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
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
 
@@ -6372,7 +6372,6 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;
 
@@ -6423,13 +6422,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
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



