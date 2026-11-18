Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049308;
	b=UpCKuQZySnsR2SJTNQ8Ug5aGMMGgjxKvwx8ijyjbJ/c8dIjZTyYwqQH1aIqQrwLlqfQm
	 /wmEJ5vdi4ukkU0hrlSvWBXFXrHRQqmGW9g/MwegXRRtIOTLPfU+rsxZ16iXu7ycUJO1b
	 71pfGVyxN+6RdvAV4IGU4ITCiONTi0TQzj6V3NUiCzk4eZoATbDojTsbi9zHM8rwcjlPL
	 A9ACzg4cmqYP8+Ocg+Iss77lGwdwIgBRAEDVdz9Noes8dmxNh/TQ5e0I4q7Tm35PQKHEW
	 +AVYvPL4dBSYiPW/dTqTTcNZ9jp3pD22uR3F3hHQ7SukAwXP0Yvk6jOAhdWIfKkLEYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S3IQGjxAFSvH8Z655BzAn2U+HTjlvyc/dcDEDeUOAHo=;
	b=lIiw267sD2FHjwY+XUHyMMo4dxYB0jswwT17izfoJoSMOYIV39mxJIU7QbtZZziSwAi1
	 u639NxA2j/awj4V0KXIwXOqPzialB4SC1YkDouIrM0aIBJSwty1jiHIOoxD2GxMxty+6f
	 1ZjRpf6uM9DbXdAIIFqLrmp21vtpo1/FlGEra77fSEX9AKn/ueaxHAtLPdE+XklRo189t
	 +JK819uvn7U5I+r+8fqhXoF8cVFjdQMUOAolFgd+F+l17/jyKcOdppL2EQQfdawn3wBhM
	 EFT6jOxBE389foH5KDZy9ETrRHJDrYfBcOCF4wAg0/GkJXhJLWRIoallvQlqSnKdMTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8l1rmRO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870D7606A339;
	Thu, 19 Nov 2026 00:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8l1rmRO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E4A1F000C5;
	Thu, 19 Nov 2026 00:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049308;
	bh=S3IQGjxAFSvH8Z655BzAn2U+HTjlvyc/dcDEDeUOAHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8l1rmROYRQORPZ951YNqVj7fciEF4+/t3vfyMTCIMGATLNYcROLbjw0ZgevD3ntj
	 upiq80xT9PInqujOykHuM5+5xWPaAyu9SkGonwxoqgUPAoWgZw3VlQtVWefcWFRs7l
	 4+6dw5aIVvwXbpedlWBMW4ONavrtPRjTlZvNyCbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2304/2857] wifi: mt76: mt76x02: validate RX padding before use
Date: Wed, 18 Nov 2026 15:55:38 +0100
Message-ID: <20261118150324.447107299@linuxfoundation.org>
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
index a845820024796..06d1469a448bb 100644
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



