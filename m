Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016867;
	b=nt88vnkLW3LnUF6v/032BGgGbItiDl/85qOtRp4iLml3dQpjdQPRuEcosKR+4bCgauPg
	 86aYNbLzdK6SpHg8fupTzjgzWtcoTD8UHABQPXYqhxH6vPVcDUSPGZgBSjHLDTLSXF3/x
	 yNw9F12w+MRm68qXQqEEb3fkLVc6d2m7vClFwvFm15k212S26VVfhVwbtocCoUTWxohHT
	 K7Lsao8WP6AnbNWcgYXYOegTVZMBffK/z2FIutC2o3dwBs6xEtsAXwT4EoI0MzdMFIMlY
	 VkQ5JurY4uaZosS+H2j7FgkU8KVOKAfYB5pLUAjNHEZ9Fd+cNk/PwIZOd0YLNImPKRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1xIRP8ua6CAIbDJOgSj/AVywfj6wGYPW9e6DDr68CoY=;
	b=wz1wXVVfPCQY7/azqSocME9kygHJ8REluOzxBx99/T84dLkBQdbwp8F1CmGEMFElTHHV
	 e9DJKJOjsbObd8CSMLofY6s2eX9oGDS3e5twSa/Xs8sc6vr58rSmEPTqLXahaj5oKw9Q2
	 PRvAdKFtmgUVGEKdxiCTIMG0GID3xhp1tDR1a/Yxy2f+aR5rGCFh+QFVKC92XACmM4+fo
	 KfT3k5gt0IuVWg689F3GDFsRh2QN+A4p2MeFoheI8yTop5HFb/6AKD8dWD4RzRNKBQ79h
	 Yq3zOOkmf3pDSkldVobaoLmAl9eh5y3JD0wYihV5ndRGQ/Eq7uhLuLo7Cec+EfxWODA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYctaApt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAA0606A331;
	Wed, 18 Nov 2026 15:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYctaApt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5DF1F000C5;
	Wed, 18 Nov 2026 15:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016867;
	bh=1xIRP8ua6CAIbDJOgSj/AVywfj6wGYPW9e6DDr68CoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYctaAptyDhXYbfKGDS3PDanV8vnuKwtfjqiVfTjRdnjChvHxvj/Bsb8s03wJiNM3
	 BFE33P9vcTNw3+9cAnxDY8qArJ2oHCShsxP7ial1vYd8nGFPuRJvhV3UhMPnjHWZ/S
	 K4ti9pfWB+SDeiVFKdxp38ZyaDQ8DESLhh9uPnpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kim Wooseok <5mghybrid@khu.ac.kr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0680/2651] wifi: rtl8xxxu: free RX skb when URB submission fails
Date: Wed, 18 Nov 2026 15:32:00 +0100
Message-ID: <20261118150312.344780040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bddbd0990de72..795a5ec2f8cd4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -5864,7 +5864,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
 	struct list_head local;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret;
 
@@ -5896,8 +5895,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 		default:
 			dev_warn(&priv->udev->dev,
 				 "failed to requeue urb with error %i\n", ret);
-			skb = (struct sk_buff *)rx_urb->urb.context;
-			dev_kfree_skb(skb);
 			usb_free_urb(&rx_urb->urb);
 		}
 	}
@@ -6596,8 +6593,11 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
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
 
@@ -7410,7 +7410,6 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;
 
@@ -7461,13 +7460,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
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



