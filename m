Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050860;
	b=rLyUDHPYhwziio6PpAezupfs3yrBYPkDV2MPwTTociVvDLjvLH9yEkxbxAH8C1R8y42O
	 7kVxAMYYZdAxeeT58z6LjPd6MWAAgxyYFY4KEQplOplcXBWBs1+vn8GrvR27adrk92ABU
	 iSee3oaYVy7RocF0nuXURd8iis8yjvDvslZn9670sP9FKsae+9AsTRCT95jWa21TM9A4E
	 Xs4qe1auFsb5/aQFYoeVrcLhBAhy7P5kI1FL2lER/A4XvJzMeh00VPmQ/BNA4Y3LJc2ND
	 yNmkV4LzlHWEi7Bzz3G23LnCrhm7uEgOwd2p+dMLmzm0FNUifhbDA9zrvk2HFmsVUpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HDxiGwDjAZ0vKlC8zF3iQhKlsocbIlKxg+zFI90xgpQ=;
	b=UkemLuWo3hnD060dG3NudLRzruRcOugAnvZqdxFL5yQbkbCPbDo7RrX/vkF+9khqRaBP
	 TidJGIvc6sHvAEr6wW93lQ1i/2T1qEEwJRHjfOOJK7oZuYy6xvOmCxcETLoq+g3R6KYCF
	 MKMyDWG+mjCvlGAST0n74pGTHbtKMhhUlanGffzzcjqohBCF/7Zmf/wK/47ZJ5cYmjxRq
	 5ElwiRgTJ10lbiLi55bNDLuIhec4QHr42EW3mZVVAXaTrZCStzQuxlY6dZp5dBulACdkm
	 fjCnP6gM+9YzSe9Rtmym2aJ6rQfSjR+xL6QJc/slYMhFeggUaDU3GBtxTMK1VfBQH1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImTAOBJ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E502A606A325;
	Thu, 19 Nov 2026 01:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImTAOBJ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1410F1F000C4;
	Thu, 19 Nov 2026 01:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050859;
	bh=HDxiGwDjAZ0vKlC8zF3iQhKlsocbIlKxg+zFI90xgpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImTAOBJ57nuaPbdgPGNO9dF7FxfxFaJF/C7D1zg/LrWRdxgbZKU8uTW9HBhB+Ly1q
	 Xz1pHEWAaJI7lNmWtG5gUo+xx2PxAAnJKP9ZSIsLmxCYQMIwNOms+eQyqW8F/1yyPJ
	 mSzmOpWkh2tsCORdO2ESy9Ls8Fmj1Z5xSMMTUxyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Chen <yn.chen@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 2843/2857] wifi: mt76: mt7921: use driver flags rather than mac80211 flags to mcu
Date: Wed, 18 Nov 2026 16:04:37 +0100
Message-ID: <20261118150343.928572163@linuxfoundation.org>
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

From: Neil Chen <yn.chen@mediatek.com>

commit a5af1481a85679a9812f728ee5cf64ee7edbe669 upstream.

FIF_* flags from mac80211 is not ABI. mt7921 should not pass it into mcu
directly. Remap FIF_* to driver defined flags as mcu command input.

Fixes: c222f77fd421 ("wifi: mt76: mt7921: fix rx filter incorrect by drv/fw inconsistent")
Signed-off-by: Neil Chen <yn.chen@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -610,10 +610,25 @@ static void mt7921_configure_filter(stru
 				    unsigned int *total_flags,
 				    u64 multicast)
 {
+#define MT7921_FILTER_FCSFAIL    BIT(2)
+#define MT7921_FILTER_CONTROL    BIT(5)
+#define MT7921_FILTER_OTHER_BSS  BIT(6)
+#define MT7921_FILTER_ENABLE     BIT(31)
+
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
+	u32 flags = MT7921_FILTER_ENABLE;
+
+#define MT7921_FILTER(_fif, _type) do {			\
+		if (*total_flags & (_fif))		\
+			flags |= MT7921_FILTER_##_type;	\
+	} while (0)
+
+	MT7921_FILTER(FIF_FCSFAIL, FCSFAIL);
+	MT7921_FILTER(FIF_CONTROL, CONTROL);
+	MT7921_FILTER(FIF_OTHER_BSS, OTHER_BSS);
 
 	mt7921_mutex_acquire(dev);
-	mt7921_mcu_set_rxfilter(dev, *total_flags, 0, 0);
+	mt7921_mcu_set_rxfilter(dev, flags, 0, 0);
 	mt7921_mutex_release(dev);
 
 	*total_flags &= (FIF_OTHER_BSS | FIF_FCSFAIL | FIF_CONTROL);


