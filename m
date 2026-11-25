Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622543;
	b=qTLiLEYAjQ5hVPKs2mat2LQocNCCaLa3zwqfWreRLI3o0CoRG3AOxDHWyHjExatE7Ea4
	 xMDqEoKj/rKRknLFdrHA96Oev29/tyFC4YIaisFuNYSuDbmZXaoDxH/sKEwHtnjaz94Uz
	 1Q8d6SnaS7A8tnT8bLX0Yi7I2m+xwMv09Uk5JBrhizTov+yzaoZ4r10SRlsDtKEDhYZTC
	 U3hiep3G+xlN73tE/LrndYKhq1JQNOuSmqpVCzfvRMbv20+uHxWsyt2b6e/bgD8jB3OV9
	 t+W1uSKamOyWCwYwB+fmc2tUnOiEX3N5TRblonND0RNo3ZsIeENN3Z7XY72oyNrR2fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GCVgFLJT5kEWXN7JdBgMEaQpLfO9FVriy/eDgA9/BQU=;
	b=lE2mly0VLpj+FZiONH0/f/cFfb2Q5oujKGocLvTPDB3Q5/i2a1RQWgPwXa/6PccBeDle
	 sLZLg81D/TIdcbwmvb0i8bXHkdMiSN4kgkOZOdFmgWN88wchzEyUjg9hD3GjSqVXzM+tD
	 MQGzXrLVZnMudM8nnE2UajZ1mGkekTL0LGrHxybzryRtg8LgGvIto88tMQ0iT4BVj9I1t
	 bmyImq9//ccVEqzawdeSenHae74AH0+CFUqsaQcOLTHfBk6kUsXfcAQZZnip0ZX+K2G6s
	 XaKnSxwYpTfuI1dznVqUywxGdwJOb9q66ciH3cGMBOxf4Gb2dWeLpmrpIrKp+mdWEyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMqFrVMK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDB3606A31E;
	Wed, 25 Nov 2026 16:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMqFrVMK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A7C1F000CA;
	Wed, 25 Nov 2026 16:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622543;
	bh=GCVgFLJT5kEWXN7JdBgMEaQpLfO9FVriy/eDgA9/BQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMqFrVMK3t9fLdxYFJOA8qCb2oL5/XOtpSB9ItO8pd8wsli5Dz/wXb6d0xeEmnMeG
	 Z4NRmOMBoHJdyO2ENCp8jJOJHz1HVbnWcIY+u0WTLfj8vSJZYcpNvWwmJuzaPQ2J0W
	 /6Ai5QSdSlvpL/+xd0xym++HMZQI0RaY15+WSpSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 571/990] wifi: mt76: mt7996: free the WTBL index if a link allocation fails
Date: Wed, 25 Nov 2026 15:32:18 +0100
Message-ID: <20261125143835.468981979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 36f1934a2bf04f355e748c68ba7f7cbb5e6950fc ]

mt7996_mac_sta_init_link() takes a WTBL index from wcid_mask before it
allocates the msta_link of a link other than the first one. If that
allocation fails, the function returns -ENOMEM and the index stays set
in wcid_mask, so no later station can use it.

Return the index to wcid_mask on that error.

Fixes: dd82a9e02c05 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Link: https://patch.msgid.link/20261006205936.669125-11-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ sashal: Kept the older kzalloc(sizeof(*msta_link), GFP_KERNEL) allocation instead of kzalloc_obj(*msta_link) as the context line, then applied the same fix on top. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index fa0fe117e8f30..02ffd5b1c0ca3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1056,8 +1056,10 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 		mt7996_sta_init_txq_wcid(sta, idx);
 	} else {
 		msta_link = kzalloc(sizeof(*msta_link), GFP_KERNEL);
-		if (!msta_link)
+		if (!msta_link) {
+			mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
 			return -ENOMEM;
+		}
 
 		if (msta->seclink_id == msta->deflink_id &&
 		    (sta->valid_links & ~BIT(msta->deflink_id)))
-- 
2.53.0



