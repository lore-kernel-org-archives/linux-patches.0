Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B0D257AD1;
	Thu, 17 Apr 2025 18:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914571; cv=none; b=NYI5PEnky4Zvgvzmm6alIadGwWccQPgoD0a+syzkr9F0rMzXhChyPEwxEp0BygeU5gFqWPiv3Tg0xgAmJ5CUaIAWGZ0vd9durt6ZY3w0xt5yQCDD6v6sxZnack/Yb22msiMVDM+ZblRO+uhGWgN10GEGrOL7PJt4h7lekowS9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914571; c=relaxed/simple;
	bh=nHtdbpFmrzlldKDMmLez1YZ6cwnIsRv5+cTmHWl/ISI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gdm7pXqN1Dr7ZW4RCCtVmReW1+71lxhNRefToH8jarJQ19ImrR0OnQDUi7nVsX7d/Ve9wYFb3ytkMA7WQqRGdKQT7isftXjIk54EdZy1hn+LmFysPf5OCKC2hCtZbqmgzzjqvGl7Z1LiCyhvNKMit0ut2AZWlH0rPREifBW6EbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTnaMulZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTnaMulZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374AEC4CEE4;
	Thu, 17 Apr 2025 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914571;
	bh=nHtdbpFmrzlldKDMmLez1YZ6cwnIsRv5+cTmHWl/ISI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTnaMulZ30ucz65QTloXt89Yus9U0QWr1mITTrRYQ5DiszNz/LukBnBbYg543mnj6
	 7HJVnWca3ZEku+9YNkrmNVK9RN50x6R1DJh5AM/xBpLqEZRZlmgfkghUjYGJYisDzj
	 rYPCnuo8CslFrs72Xw3+UzTFoNDyRxFnsAZ2/q4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Caleb Jorden <cjorden@gmail.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.13 260/414] wifi: mt76: mt7925: fix the wrong simultaneous cap for MLO
Date: Thu, 17 Apr 2025 19:50:18 +0200
Message-ID: <20250417175121.888034915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 7dcea6fe33ee3d7cbb65baee0dd7adc76d1c9ddc upstream.

The mt7925 chip is only support a single radio, so the maximum
number of simultaneous should be 0.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Tested-by: Caleb Jorden <cjorden@gmail.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250305000851.493671-3-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -256,7 +256,7 @@ int mt7925_init_mlo_caps(struct mt792x_p
 
 	ext_capab[0].eml_capabilities = phy->eml_cap;
 	ext_capab[0].mld_capa_and_ops =
-		u16_encode_bits(1, IEEE80211_MLD_CAP_OP_MAX_SIMUL_LINKS);
+		u16_encode_bits(0, IEEE80211_MLD_CAP_OP_MAX_SIMUL_LINKS);
 
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_MLO;
 	wiphy->iftype_ext_capab = ext_capab;


