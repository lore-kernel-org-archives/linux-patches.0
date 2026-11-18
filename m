Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042838;
	b=1sk4U3xPGN0e1BV3yaKPkPAtZT7g+nkSum32XyIpO/VY+AWk7pZMG3rr9vb0nnRQ/8+h
	 +Hwvy0SLi8Zb+0PNtVpmipRlhykW15WsBdTT17nSXbnP8CAQL3rMzK3sjvaiuUIdcgoV1
	 F9J+rW1SJmsF5Au2+9aYTHtmWvsWYmIs15+CEczL9wIh7DlY1mvKXPd975iqNHyrRQEqu
	 PLltw9uNzlijaVHSvZxaKyonGJTmzWsb5jYRAo1dMHqiNageDaXCxDLvzCE5S1rGOb0fQ
	 a5lDyh2BLusJHLlkJN38f5srSzHpqRvAr/E1yHzKX5IYBuFwJSQxoCbgvmqpFrBlkpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LQ+YnGtJH5nNybJPbylYqP1KYEra7B6TFV8qTnBamcA=;
	b=We2yRHd+fSnb+AxJRbBQbz6HkWwpiTZJhszCPfP5f4dHxZZv3aycA7kdlaL3XWOlGyz3
	 ezJCuCEKg6R3++WEIKu0QZf/5Jfn/gn1nJwL3PTj9NIkYlUCEsA9GxNF3edMD2zThUWnW
	 LcrcAfwxruH6Ayg49FP/r/9V/uMvBskiOCCLbKrmlaMLe/na4LmaKhQKZRNjpF+1Ks/0L
	 Xa4xlxCN1NhJUq8KnP9AFwrr7VrrM/VOpym5xcqqUWOh3M72po0fam9GqjXWpC52X8xWj
	 wK32VVZiks28YnQRPQ/squCBi0MKblrJRhQYJtUkkNBbrRv1XnV8PYxBxBfVlazyr+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FBe/NL0w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41E8606A32C;
	Wed, 18 Nov 2026 23:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FBe/NL0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0477B1F000C4;
	Wed, 18 Nov 2026 23:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042838;
	bh=LQ+YnGtJH5nNybJPbylYqP1KYEra7B6TFV8qTnBamcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBe/NL0wdtX4muJZ6PeLUgIN44cB5Xhp/Z7pS+LdpaQTY1nXx0ECtuWJ5hr6uq0Xb
	 qahr8egcHUyE1kk19jTdVumdj5PmOCnbUOwv5aiIVwBsTTSMMmLRM9C9MD8RH34ZA4
	 7wJNtv4kM4yzDu34ksQJsQfsADXcTby7ChoHS118=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.6 3313/3318] wifi: mt76: mt7996: fix mt7996_mcu_all_sta_info_event struct packing
Date: Wed, 18 Nov 2026 16:05:35 +0100
Message-ID: <20261118150458.965475012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 2ee1c40daeb9a33e25c460bf87feca58e91af879 upstream.

The internal struct and union inside mt7996_mcu_all_sta_info_event is
marked as being aligned, which conflicts with it being unaligned
within that structure:

drivers/net/wireless/mediatek/mt76/mt7996/mcu.h:165:2: error: field  within 'struct mt7996_mcu_all_sta_info_event' is less aligned than 'union mt7996_mcu_all_sta_info_event::(anonymous at ../drivers/net/wireless/mediatek/mt76/mt7996/mcu.h:165:2)' and is usually due to 'struct mt7996_mcu_all_sta_info_event' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

Mark all three as being packed as well to ensure byte packing for
the entire thing.

Fixes: adde3eed4a75 ("wifi: mt76: mt7996: Add mcu commands for getting sta tx statistic")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -190,15 +190,15 @@ struct mt7996_mcu_all_sta_info_event {
 			u8 rsv[2];
 			__le32 tx_bytes[IEEE80211_NUM_ACS];
 			__le32 rx_bytes[IEEE80211_NUM_ACS];
-		} adm_stat[0];
+		} adm_stat[0] __packed;
 
 		struct {
 			__le16 wlan_idx;
 			u8 rsv[2];
 			__le32 tx_msdu_cnt;
 			__le32 rx_msdu_cnt;
-		} msdu_cnt[0];
-	};
+		} msdu_cnt[0] __packed;
+	} __packed;
 } __packed;
 
 enum mt7996_chan_mib_offs {


