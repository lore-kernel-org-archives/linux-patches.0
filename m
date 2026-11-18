Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031176;
	b=hQ3LLmnqpn9w4e0lMxgmyZlyBmkXMa3VrlJPiNMgDre/o5yllscaNELj9kPbCPs39snz
	 tMJjtfZLMrSdkZR7TiXUq4uYiPR0vuQ/stB6KCIZFDUvRBpodjRRwynTK9dNiPR6cOsrj
	 SZz02v5YNvW0bbG+wlLkXZTtBf690JUp1J2tEZQUQqAGX+Yqm8NEg15XUd+FSLLYRqOTw
	 Ioywv2CMdJpXXwWx8zCt7eZpPQMVZ3JmgUTN76WLCPF9xSsLT9i9Ho9U4uYweUmAhEMsJ
	 syg+B/+t05epd3E9JFz8n8cnJbXJ16b0ZjSf3W26dSD4CAfyGYPS1x6AHMP6dv6wZpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6T5fhL87dQsOO0GpzWsdWrovzqczuwjjSxdjkxKYVYQ=;
	b=YmleHrruX8Xeq1vAeYYfoO01vwghVMzXLRUwWp3eFTKvesr0FdzRS3a2d27+2EcolMnC
	 1RmuPikhNx7LrMh25CSX6ojrTS/DoEzwWX2Ly93x2Plr1zhcmV22N3xgrcN85r9ojKiro
	 qTqis5AvQdVfqXDEQjotjFhNctwFGwFq1UDjuOxTz3MJzOkZCkWq3xSueic4+uNVwt/KL
	 X/qaGGongnaa6gXDORU529eBdKZq1nL059XQ6YGALiVg2iGAL9xwabWwRuUC7zLxf1c7q
	 MaR+amuFVASeaXGZgchMe1yGh7iqAvowR4laKwff/FqUXESD7Zum8Ne/+GGJjZBk5DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYTGfuPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765CB606A31C;
	Wed, 18 Nov 2026 19:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYTGfuPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54E21F000C4;
	Wed, 18 Nov 2026 19:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031176;
	bh=6T5fhL87dQsOO0GpzWsdWrovzqczuwjjSxdjkxKYVYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYTGfuPcocRThKoytjo8ZEDoZ96aQjTZvuPqfXHAI1AUrzE9IWxJ8I/3w5uZ28zDK
	 4A5yHHXPNp7wD+MSmOVMwF+i/dxEPnujK88m60wHZi1zkvOQhil+5xpD9FMnQaStig
	 R9jjzaTLXKkxB060CbC3gzDytU3kXQDTZryxMVQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0964/1756] wifi: mt76: mt76x02: validate RX padding before use
Date: Wed, 18 Nov 2026 15:51:31 +0100
Message-ID: <20261118150048.465236961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit baf375ca58eaa24503f9febac75c056852694c3a ]

The RX descriptor provides L2 and PN padding lengths that are used to
locate the CCMP IV and determine how many bytes to remove from the packet.
These lengths are not checked against the received skb length before the
IV is read or mt76x02_remove_hdr_pad() is called.

Reject frames whose IV does not fit within the skb or whose header padding
would extend past the end of the skb.

Fixes: 30ce7f4456ae ("mt76: validate rx CCMP PN")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925152754.2323624-1-yaojiale02@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index d5ee2bb6f679b..441d461e76787 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -818,9 +818,13 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	pn_len = FIELD_GET(MT_RXINFO_PN_LEN, rxinfo);
 	if (pn_len) {
-		int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
-		u8 *data = skb->data + offset;
+		unsigned int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
+		u8 *data;
 
+		if (offset + 8 > skb->len)
+			return -EINVAL;
+
+		data = skb->data + offset;
 		status->iv[0] = data[7];
 		status->iv[1] = data[6];
 		status->iv[2] = data[5];
@@ -840,6 +844,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
+	if (pad_len + ieee80211_get_hdrlen_from_skb(skb) > skb->len)
+		return -EINVAL;
+
 	mt76x02_remove_hdr_pad(skb, pad_len);
 
 	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
-- 
2.53.0



