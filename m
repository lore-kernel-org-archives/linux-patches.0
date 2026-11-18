Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027995;
	b=YO6UjqV5sWZ7zhvJjdaoqJ3+LflG+dGllMoeihtl8H80Vb9O5PVhY+2n4EvjtSjhm0hq
	 xGSHHahaSx/K23obOg0vvLkt7Gh1BeL/FIw3zWV69MD8MN1s+jV+E3gKEhNyGrmdvYKQa
	 9NxDt0RXmOpK0tDduQc2IJCHA2UgKsMuHRSoK3kZBi/bUpmJl8zIfNZUZjxDL8V5VoZ+9
	 ovdVcYiV3F5C6mJsfmRr85Ho5QN0J2ML6iIGN+TWF7cAgguAOyKe3zIBg3viOxp7j/tpn
	 jO4RmRLarrNtf9MlGqCM9ylAh1BnJQa5g0SL81EJ2NOmXG4J0QnUQQtwb+4kQMycOXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RTFf70op+XqDX9Z64xtOO0qnZVbv2V1U37mEl0NpjVQ=;
	b=Icu6G2GCT7l85wgjJxK93bWMNGGlX3A07DcNQjXCTipuxf1o3p9DHN8Zrqn9cJcRTP+y
	 GI3QjedMh0le6I888SFqwaw7PG0kZX38TY2NhmW1AY9qbG9lABUZG8moVvYlaLq93kJv+
	 JUny0fBpnyEtXal9dZFBWAfp8zTWrNKcOv+SonpWwkEJE7ctA8KeeeRLIcyaqRWidYQXI
	 V6la8BFrkC6s9GvlQKU8Oafs6SSCNzeO8sqR4lS3Ykhws13l/uOrgavBGXAVUwzJ1REiG
	 fM7wt0oDUlj8XqjFqp27CDeLnXDotaOAIhll48/CJYWH/PpOIIKMglwOPvze/wIlyFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpzNZMmJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DDA606A31C;
	Wed, 18 Nov 2026 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpzNZMmJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910F01F000C4;
	Wed, 18 Nov 2026 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027995;
	bh=RTFf70op+XqDX9Z64xtOO0qnZVbv2V1U37mEl0NpjVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpzNZMmJlYAy/cxsKJpnCtuR6rZbTa01Tky5dBXNarYxwizxV67W4Ds+psEZYut0n
	 OvepRsMH16bwXZ4pQ+WNmZdO4MAz1q9YgQ9DGjAJ8ZclsxpV6jhk0bU9sDxr9jD+B1
	 K/pnow4zt7liHieCZeRaxEy9P0mq5r2ZCPqX83Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1986/2151] net: usb: cdc_mbim: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:02:01 +0100
Message-ID: <20261118150234.074006048@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit bfd7ced012c7857b5ab5edf7e416c2789b652702 ]

cdc_mbim_tx_fixup() has the same spin_unlock_bh() as cdc_ncm_tx_fixup().
Under netpoll it runs pending softirqs while the txq lock is held, and
a transmit from one of them spins on that lock.

Use plain spin_lock() as in cdc_ncm.

Fixes: 9bf211a30b3f ("net: cdc_mbim: adding MBIM driver")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261024-cdc-ncm-netpoll-v3-2-6284ca03f967@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c587d2d5cbbe9..246184945828b 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -290,9 +290,10 @@ static struct sk_buff *cdc_mbim_tx_fixup(struct usbnet *dev, struct sk_buff *skb
 		}
 	}
 
-	spin_lock_bh(&ctx->mtx);
+	/* BHs or IRQs are always off here, see cdc_ncm_tx_fixup() */
+	spin_lock(&ctx->mtx);
 	skb_out = cdc_ncm_fill_tx_frame(dev, skb, sign);
-	spin_unlock_bh(&ctx->mtx);
+	spin_unlock(&ctx->mtx);
 	return skb_out;
 
 error:
-- 
2.53.0



