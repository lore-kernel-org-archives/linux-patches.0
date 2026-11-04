Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829605;
	b=xuh+j88Cp9h7E2E2MwXUR/IzitSbbIF14vBzBOwOduNQSikqqff246qYp3EJ5f9uJSKY
	 uubB8aOCjThHzM5QKmbiWGhH90UsZPaBcdJ3RSIrPVqTR0ddesR7NnmjFqH452PVF1cD2
	 ln8ECZKCVP3vg8pBEDUiYMSX4YSjHJfqt1jDfJoDdj9GNuCDQFWyY5S76gVfWYvYz7AEC
	 ZToK6ykXKkjRXdMRBY01pUoxEUIyqqEuM1OwmHE5MPZf3kSW9h6kdFM/d4sajApY+pI/z
	 QWkWQAiEPB/fSCvbRzSPrOULISjha4hv7PmfkrjnoYKLiiCXHyapCrJzhRpBMOQ6M0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XRM3xSj9ga7iU7RgFv/KJlpwLDJL9+NluNPnOoZXx8s=;
	b=f8Cn469tPkEo27lLPeJgHkKEwzyXy5ztlQZT+OF4SxCpB4kixhIovDIlWtIloskSxQQr
	 5gcYgQVdgZFDnVQ4v0ZtNczmik8OuVyCU6HADnBRsPqo7fOUeqxB4ERIeMoDzWUVpKiqM
	 6X+MGGdQIPxG9idKU6kYOJ8OKU+E6bYCLCkrpvCVq5b5HpmqTcectkS3l9O1BZRyyuhHx
	 lWqKPULlgTFk8a5m3QsYLvNkoBcKjMTsbN5bctGIzVYf+/tNVkcOdKuodYCU1ausbgTNf
	 B8q607GBxq7gAFVNi4aorOBJsc/wyNE5wuGI79hNz1mS/d6zMhCR66P1D6AfRAhvBmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+mdRP9Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7446075DD2;
	Wed,  4 Nov 2026 22:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+mdRP9Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF041F00919;
	Wed,  4 Nov 2026 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829604;
	bh=XRM3xSj9ga7iU7RgFv/KJlpwLDJL9+NluNPnOoZXx8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+mdRP9YOQk7GlHyZg+B8H2KTEygsW7cdr4bYcv0/FZkSrD0z8v5do6KmiijD9KgH
	 nS0Fvu3klPoznImlMK51WlUd1nQodwWlcw8pL1usxeACsA4od2PbDpwqX9FV+BTYrE
	 9Z523NJHP9NhAITO8Mo34Za8tp2/85/wSShkrHCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0230/1005] net: libwx: disable TX VLAN offload for packets with >2 VLAN tags
Date: Wed,  4 Nov 2026 15:59:23 -0500
Message-ID: <20261104211050.284051873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit f5cfb576ce39ba5647024c6d6eeb5b7a822fab6e ]

The current hardware does not support TX VLAN offload for packets with
three or more VLAN tags. When such packets are transmitted with hardware
VLAN offload enabled, the hardware may malfunction or produce corrupted
frames.

Add a check in wx_features_check() to parse the VLAN depth of the
skb. If more than two VLAN tags are detected (including both the
hardware tag and in-band tags), strip NETIF_F_HW_VLAN_CTAG_TX and
NETIF_F_HW_VLAN_STAG_TX from the feature set. This forces the
kernel networking stack to handle VLAN insertion in software for
these specific packets, ensuring correct transmission.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/069DF89AA8029189+20260713060441.276612-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 24 +++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 4a6851612368d..9be339965a683 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -3193,6 +3193,30 @@ netdev_features_t wx_features_check(struct sk_buff *skb,
 				    netdev_features_t features)
 {
 	struct wx *wx = netdev_priv(netdev);
+	__be16 type = skb->protocol;
+	u16 vlan_depth = ETH_HLEN;
+	u32 vlan_num = 0;
+
+	if (skb_vlan_tag_present(skb))
+		vlan_num++;
+
+	while (eth_type_vlan(type)) {
+		struct vlan_hdr vhdr, *vh;
+
+		vh = skb_header_pointer(skb, vlan_depth, sizeof(vhdr), &vhdr);
+		if (unlikely(!vh))
+			break;
+
+		type = vh->h_vlan_encapsulated_proto;
+		vlan_depth += VLAN_HLEN;
+		vlan_num++;
+
+		if (vlan_num > 2) {
+			features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
+				      NETIF_F_HW_VLAN_STAG_TX);
+			break;
+		}
+	}
 
 	if (!skb->encapsulation)
 		return features;
-- 
2.53.0



